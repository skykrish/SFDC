global without sharing class ContractConcludeService{

    /** エラーメッセージ：商談データが削除された */
    private static final String CREATE_OPPO_ERR = '選択された商談が削除されています。';
    /** エラーメッセージ：商談が成約済 */
    private static final String ALREADY_CONTRACTCONCLUDE_ERR = '既に成約済商談は改めて成約できません。';
    /** メッセージ：商談を成約に更新 */
    private static final String CREATE_OPPPO_OK = '商談データを更新しました。';

    /**
     * 商談のフェーズの更新
     *
     * @param id 商談ID
     * return "OK" の文字列を返す。
     *        エラーがあった場合はエラーメッセージを返す。
     *
     */
    webService static String ContractConclude(Id oppoId){
        Map<String, Object> response = new Map<String, Object>();

        // 案件情報取得
        Opportunity oppo = getOppoInfo(oppoId);
        // 取得できない場合、エラーメッセージを表示する。
        if(oppo == null){
            // エラーメッセージ表示
            response.put('status', '500');
            response.put('msg', CREATE_OPPO_ERR);
            return JSON.serialize(response);
        }

        // 成約済かをチェックする
        if(oppo.ContractConcludeDate__c != null){
            response.put('status', '500');
            response.put('msg', ALREADY_CONTRACTCONCLUDE_ERR);
            return JSON.serialize(response);
        }

        // 商談を成約に更新
        oppo.ContractConcludeDate__c = Date.today();
        oppo.StageName = '成立';
        oppo.Probability = 100;
        oppo.OwnerId = UserInfo.getUserId();

        update oppo;
        
        // 顧客情報の更新
        if(oppo.AccountId != null){
            List<Account> accList = [Select Id,date_of_contract__c,OwnerId From Account Where Id=:oppo.AccountId];
            if(!accList.isEmpty()){
                accList[0].date_of_contract__c = Date.today();
                accList[0].OwnerId = UserInfo.getUserId();
                update accList[0];
            }
        }
        
        // 成約の更新は正常完了
        response.put('status', '200');
        response.put('oppoId', oppoId);
        response.put('msg', CREATE_OPPPO_OK);
        return JSON.serialize(response);
    }

    /**
     * 商談情報の取得
     *
     * @param oppoId 商談Id
     * return 商談情報
     *        取得できない場合、nullを返す。
     */
    private static Opportunity getOppoInfo(Id oppoId){
        List<Opportunity> oppoList = [SELECT Id, ContractConcludeDate__c,StageName,Probability,OwnerId,AccountId FROM Opportunity WHERE Id=:oppoId];
        return (oppoList.isEmpty()) ? null : oppoList[0];
    }

}