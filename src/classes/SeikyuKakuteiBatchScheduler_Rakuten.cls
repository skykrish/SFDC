global class SeikyuKakuteiBatchScheduler_Rakuten implements Schedulable {

    /**
     * 請求確定バッチを締めグループ末日で起動する
     */
    global void execute(SchedulableContext ctx){
        
        // 請求確定バッチ起動（締めグループ：末日）
        SeikyuKakuteiBatch batch = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_RAKUTEN);
        Database.executebatch(batch, SeikyuKakuteiBatch.BATCH_STEP_COUNT);
    }
}