public with sharing class ShiireKingakuTriggerHandler {

    private boolean m_isExecuting = false;
    private integer batchSize = 0;

    /**
     * コンストラクタ
     */
    public ShiireKingakuTriggerHandler(boolean isExecuting, integer size){
        this.m_isExecuting = isExecuting;
        this.batchSize = size;
    }

    /**
     * BeforeInsert
     */
    public void OnBeforeInsert(ShiireKingaku__c[] newObjs){

        for (ShiireKingaku__c obj : newObjs) {
            // 作業名または単価が未設定か判定
            if (Strings.isNullOrEmpty(obj.SagyoName__c) || obj.Tanka__c == null) {
                // 発注情報から発注先を取得
                List<HachuInfo__c> hachuInfoList = [SELECT Id, Name, Hachusaki__c FROM HachuInfo__c WHERE Id = :obj.HachuInfo__c];
                
                // 発注先仕入価格オブジェクトから作業名、単価を取得
                List<HachusakiShiireKakaku__c> SiireKakakuList = [SELECT Id, Name, SagyoName__c, ShiireKakaku__c FROM HachusakiShiireKakaku__c WHERE Sagyo__c = :obj.SagyoCd__c AND Hachusaki__c = :hachuInfoList[0].Hachusaki__c];
                
                // 発注先仕入価格オブジェクトに登録があるか判定
                if (SiireKakakuList.size() > 0) {
                    // 作業名が未設定なら発注先仕入価格オブジェクトから設定
                    if(Strings.isNullOrEmpty(obj.SagyoName__c)){
                        obj.SagyoName__c = SiireKakakuList[0].SagyoName__c;
                    }
                    // 単価が未設定なら発注先仕入価格オブジェクトから設定
                    if(obj.Tanka__c == null) {
                        obj.Tanka__c = SiireKakakuList[0].ShiireKakaku__c;
                    }
                }
            }
        }
    }
}