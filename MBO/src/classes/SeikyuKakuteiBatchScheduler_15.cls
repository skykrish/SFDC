global class SeikyuKakuteiBatchScheduler_15 implements Schedulable {

    /**
     * 請求確定バッチを締めグループ15日で起動する
     */
    global void execute(SchedulableContext ctx){
    	
        // 請求確定バッチ起動（締めグループ：15日）
        SeikyuKakuteiBatch batch = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_15);
        Database.executebatch(batch, SeikyuKakuteiBatch.BATCH_STEP_COUNT);
    }
    
    /** テストメソッド */
    public static testmethod void myUnitTest(){
        Test.startTest();
        String jobId = System.schedule('Test SeikyuKakuteiBatchScheduler_15', '0 0 * * * ?', new SeikyuKakuteiBatchScheduler_15());
        Test.stopTest();
    }

}