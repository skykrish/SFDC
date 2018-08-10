global without sharing class CreateOpportunityService{

    /** エラーメッセージ：案件が削除された */
    private static final String CREATE_ANKEN_ERR = '選択された案件が削除されています。';
    /** 完了メッセージ：商談データの作成 */
    private static final String CREATE_ANKEN_OK = '商談データを作成しました。';

    /**
     * 商談レコード作成
     *
     * @param id 案件ID
     * return "OK" の文字列を返す。
     *        エラーがあった場合はエラーメッセージを返す。
     *
     */
    webService static String createOpportunity(Id ankenId){
        Boolean statusLockBak;
        
        Map<String, Object> response = new Map<String, Object>();

        // 案件情報取得
        Anken__c anken = getAnkenInfo(ankenId);
        // 取得できない場合、エラーメッセージを表示する。
        if(anken == null){
            // エラーメッセージ表示
            response.put('status', '500');
            response.put('msg', CREATE_ANKEN_ERR);
            return JSON.serialize(response);
        }

        // 商談の作成
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = anken.KokyakuName__r.Name;
        newOpportunity.AccountID = anken.KokyakuName__c;
        newOpportunity.CloseDate = Date.today();
        newOpportunity.StageName = '交渉中';
        newOpportunity.Setumei__c = anken.EndUserComment__c;
        insert newOpportunity;

        // 案件のステータスを更新
        // テータスロックはTrueの場合、ステータスは変更できませんので、
        // 一旦Falseに変更しステータスをキャンセルに変更してまたステータスロックをTrueに変更。
        statusLockBak = anken.StatusLock__c;
        if(statusLockBak){
            anken.StatusLock__c = false;
        }
        anken.Status__c = 'キャンセル';
        update anken;
        
        // ステータスロックを元に戻す
        if(statusLockBak){
            anken.StatusLock__c = true;
            update anken;
        }

        response.put('status', '200');
        response.put('oppoId', newOpportunity.Id);
        response.put('msg', CREATE_ANKEN_OK);
        return JSON.serialize(response);

    }

    /**
     * 案件情報の取得
     *
     * @param ankenId 案件Id
     * return 案件情報
     *        取得できない場合、nullを返す。
     */
    private static Anken__c getAnkenInfo(Id ankenId){
        List<Anken__c> ankenList = [SELECT Id, AnkenName__c, KokyakuName__c,KokyakuName__r.Name, EndUserComment__c, StatusLock__c FROM Anken__c WHERE Id=:ankenId];
        return (ankenList.isEmpty()) ? null : ankenList[0];
    }

}