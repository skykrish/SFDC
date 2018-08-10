global class SeikyuKakuteiBatchScheduler_25 implements Schedulable {

    /**
     * 請求確定バッチを締めグループ25日で起動する
     */
    global void execute(SchedulableContext ctx){
        
        // 請求確定バッチ起動（締めグループ：25日）
        SeikyuKakuteiBatch batch = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_25);
        Database.executebatch(batch, SeikyuKakuteiBatch.BATCH_STEP_COUNT);
    }

    /** テストメソッド */
    public static testmethod void myUnitTest(){
        Test.startTest();
        String jobId = System.schedule('Test SeikyuKakuteiBatchScheduler_25', '0 0 * * * ?', new SeikyuKakuteiBatchScheduler_25());
        Test.stopTest();
    }
}