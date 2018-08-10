public without sharing class ReplaceSagyoCodeController{

    /**
     * 日時（開始）
     */
    public String sagyoCodeFrom {
        get;
        set;
    }

    /**
     * 日時（終了）
     */
    public String sagyoCodeTo {
        get;
        set;
    }
    
    public String sagyoCodeTarget {
        get;
        set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public ReplaceSagyoCodeController() {
    }
    
    /**
     * 初期化処理
     */
    public PageReference init() {
        
        this.sagyoCodeFrom = '30065501';
        this.sagyoCodeTo = '30065529';
        return null;
    }
    
    /**
     * 作業コードの置換
     **/
    public PageReference replaceSagyoCode() {
        
        // チェック
        Boolean hasErr = false;
        if(Strings.isNullOrEmpty(this.sagyoCodeFrom, true)){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Error, '作業コード（FROM）の値を入力してください。'));
            hasErr = true;
        }
        
        if(Strings.isNullOrEmpty(this.sagyoCodeTo, true)){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Error, '作業コード（TO）の値を入力してください。'));
            hasErr = true;
        }
        
        if(Strings.isNullOrEmpty(this.sagyoCodeTarget, true)){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'ターゲット作業コードの値を入力してください。'));
            hasErr = true;
        }
        
        // 作業情報を取得
        List<Sagyo__c> sagyoListFromTo = [SELECT Id,Name FROM Sagyo__c Where Name>=:sagyoCodeFrom And Name<=:sagyoCodeTo ORDER BY Name];
        List<Sagyo__c> sagyoList = [SELECT Id,Name FROM Sagyo__c Where Name=:sagyoCodeTarget];
        
        // 置換元レコードが存在しません
        if(sagyoListFromTo.isEmpty()){
	        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Error, '置換元レコードが存在しません。'));
	        hasErr = true;
        }
        
        // 置換先レコードが存在しません
        if(sagyoList.isEmpty()){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Error, '置換先レコードが存在しません。'));
            hasErr = true;
        }
        
        // エラーがある場合
        if(hasErr){
            return null;
        }
        
        // 作業に紐づく案件明細を取得するため、作業IDのセット作成
        Set<Id> sagyoIds = (new Map<Id,SObject>(sagyoListFromTo)).keySet();
        
        // 作業に紐づく案件明細を取得
        List<AnkenMeisai__c> ankenMeisaiList = [SELECT Id,Anken__c,SagyoCd__c,Suryo__c FROM AnkenMeisai__c WHERE SagyoCd__c IN :sagyoIds];
        
        // 作業コードを置き換える
        for(AnkenMeisai__c ankenMeisai : ankenMeisaiList){
            ankenMeisai.SagyoCd__c = sagyoList.get(0).Id;
        }
        // 案件明細を更新
        update ankenMeisaiList;
        
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Info, '置換処理を完了しました。'));
        return null;
    }
}