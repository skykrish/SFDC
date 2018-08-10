global class SeikyuKakuteiBatchScheduler_End implements Schedulable {

    /**
     * 請求確定バッチを締めグループ末日で起動する
     */
    global void execute(SchedulableContext ctx){
    	
        // 請求確定バッチ起動（締めグループ：末日）
        SeikyuKakuteiBatch batch = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_END);
        Database.executebatch(batch, SeikyuKakuteiBatch.BATCH_STEP_COUNT);
    }

    /** テストメソッド */
    public static testmethod void myUnitTest(){
        Test.startTest();
        String jobId = System.schedule('Test SeikyuKakuteiBatchScheduler_END', '0 0 * * * ?', new SeikyuKakuteiBatchScheduler_End());
        Test.stopTest();
    }
}