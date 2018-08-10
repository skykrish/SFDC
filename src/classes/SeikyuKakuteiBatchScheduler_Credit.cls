global class SeikyuKakuteiBatchScheduler_Credit implements Schedulable{

    /**
     * 請求確定バッチを締めグループクレジットで起動する
     */
    global void execute(SchedulableContext ctx){
    	
        // 請求確定バッチ起動（締めグループ：クレジット）
        SeikyuKakuteiBatch batch = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_CREDIT);
        Database.executebatch(batch, SeikyuKakuteiBatch.BATCH_STEP_COUNT);
    }
    
    /** テストメソッド */
    public static testmethod void myUnitTest(){
        Test.startTest();
        String jobId = System.schedule('Test SeikyuKakuteiBatchScheduler_Credit', '0 0 * * * ?', new SeikyuKakuteiBatchScheduler_Credit());
        Test.stopTest();
    }

}