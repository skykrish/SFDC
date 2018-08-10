global class SeikyuKakuteiBatchScheduler_20 implements Schedulable {

    /**
     * 請求確定バッチを締めグループ20日で起動する
     */
    global void execute(SchedulableContext ctx){
    	
        // 請求確定バッチ起動（締めグループ：20日）
        SeikyuKakuteiBatch batch = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_20);
        Database.executebatch(batch, SeikyuKakuteiBatch.BATCH_STEP_COUNT);
    }

    /** テストメソッド */
    public static testmethod void myUnitTest(){
        Test.startTest();
        String jobId = System.schedule('Test SeikyuKakuteiBatchScheduler_20', '0 0 * * * ?', new SeikyuKakuteiBatchScheduler_20());
        Test.stopTest();
    }
}