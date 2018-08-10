public with sharing class NohinshoriController {
    
    /** 案件ID */
    private String ankenId;

    /** 処理対象の案件IDリスト */
    public Set<ID> ankenIdSet {get;set;}
    
    /** 処理対象の案件ステータスフラグ */
    public Boolean ankenFlg {get;set;}
    
    /** リストビュー上で選択されたレコード */
    public List<Anken__c> records {get;set;}
    
    /** 初期表示チェック */
    public Boolean isInitCheck {get;set;}
    
    /** 処理対象チェックフラグ */
    public Boolean ankenCheckFlg {get;set;}
    
    /** 処理対象の案件リスト */
    public List<Anken__c> ankenList {get;set;}
    
    /** 処理対象の案件Map */
    public Map<Id, Anken__c> ankenMap {get;set;}
    
    /** 排他処理チェック案件リスト */
    public List<Anken__c> ankenExList {get;set;}
    
    /** 排他処理フラグ */
    public boolean exclusionFlg {get;set;}

    /** 戻り先URL */
    private String retUrl;
    
    /** 納品ステータス */
    private String NOHINSHORI = '納品処理中';
    
    
    /**
     * デフォルトコンストラクタ
     */
    public NohinshoriController() {
        
        // リクエストパラメータ取得
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        //初期化
        ankenList = new List<Anken__c>();
        ankenIdSet = new Set<ID>();
        ankenMap = new Map<Id, Anken__c>();
        ankenExList = new List<Anken__c>();
        exclusionFlg = false;
        
        ankenFlg = false;
        ankenCheckFlg = false;
        isInitCheck = false;
        
        ankenIdSet.add((Id)this.ankenId);
    }
    
    /**
     * リストビュー上から呼ばれるコンストラクタ
     */
    public NohinshoriController(ApexPages.StandardSetController controller) {

        // リクエストパラメータ取得
        this.records = (List<Anken__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        //初期化
        ankenList = new List<Anken__c>();
        ankenIdSet = new Set<ID>();
        ankenMap = new Map<Id, Anken__c>();
        ankenExList = new List<Anken__c>();
        exclusionFlg = false;
        
        ankenFlg = false;
        ankenCheckFlg = false;
        isInitCheck = false;
        
        // 案件IDList取得
        for(Anken__c anken : this.records){
            ankenIdSet.add(anken.Id);
        }
    }
    
    /**
     * 案件詳細画面より起動
     */
    public PageReference init() {
        
        // 案件データ取得
        ankenList = [SELECT
                            Id,
                            Name,
                            Status__c,
                            MitsumoriJisshiFlg__c,
                            KokyakuName__c,
                            ItemCnt__c,
                            Nouki__c,
                            SagyoNaiyo__c,
                            JuchuDateTime__c,
                            SendImmediateFlag__c,
                            InvoicePersonnel__c,
                            KokyakuTantosya_Main__c,
                            StatusLock__c,
                            NohinshoriFlg__c,
                            HachusakiText__c
                        FROM
                            Anken__c
                        WHERE
                            Id IN :ankenIdSet];
        
        // ステータスが請求確定済み以降となっていないかチェック
        for(Anken__c an : ankenList){
            if (an.StatusLock__c) {
                ankenCheckFlg = true;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + an.Name + '　　' + '請求確定済みの案件です。'));
            }
            
            //案件Map
            ankenMap.put(an.Id, an);
        }
        
        // 案件ステータス設定
        for(Anken__c anken : ankenList){
            if(anken.Status__c != NOHINSHORI){
                ankenFlg = true;
            }
        }
        
        if(ankenList.size() != 0 && ankenFlg && !ankenCheckFlg){
            return updateAnken();
        }
        
        return null;
    }
    
    public PageReference initCheckAll() {
        
        // 案件データ取得
        ankenList = [SELECT
                            Id,
                            Name,
                            Status__c,
                            MitsumoriJisshiFlg__c,
                            KokyakuName__c,
                            ItemCnt__c,
                            Nouki__c,
                            SagyoNaiyo__c,
                            JuchuDateTime__c,
                            SendImmediateFlag__c,
                            InvoicePersonnel__c,
                            KokyakuTantosya_Main__c,
                            StatusLock__c,
                            NohinshoriFlg__c,
                            HachusakiText__c
                        FROM
                            Anken__c
                        WHERE
                            Id IN :ankenIdSet];
        
        // 選択レコード件数が0件
        if(ankenList.size() == 0){
            ankenCheckFlg = true;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '選択されたレコードがありません。'));
        }
        
        // 選択レコード件数が上限以上
        if(ankenList.size() > Integer.valueOf(System.Label.ExecuteLimitCount_Nohinshori)) {
            ankenCheckFlg = true;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '一括処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Nohinshori + '件です。'));
        }
        
        // ステータスが請求確定済み以降となっていないかチェック
        for(Anken__c an : ankenList){
            if (an.StatusLock__c) {
                ankenCheckFlg = true;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + an.Name + '　　' + '請求確定済みの案件です。'));
            }
        }
        
        // 案件ステータス設定
        if(ankenList.size() != 0){
            for(Anken__c anken : ankenList){
                if(anken.Status__c == NOHINSHORI){
                    ankenFlg = true;
                }
                
                //案件Map
                ankenMap.put(anken.Id, anken);
            }
        }
        
        if(ankenList.size() != 0 && !ankenCheckFlg && !ankenFlg){
            return updateAnken();
        }
        
        return null;
    }
    
    /**
     * ステータス変更処理
     **/
    public PageReference updateAnken() {
        
        //排他処理
        ankenExList = [SELECT Id, Name, Status__c, InvoicePersonnel__c FROM Anken__c WHERE Id IN :ankenIdSet];
        
        for(Anken__c anken : ankenExList){
            if(ankenMap.get(anken.Id).Status__c != anken.Status__c || ankenMap.get(anken.Id).InvoicePersonnel__c != anken.InvoicePersonnel__c){
                ankenCheckFlg = true;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + anken.Name + '　　' + '納品処理中にステータスまたは納品処理担当者が別のユーザによって更新されました。再度納品処理を実施してください。'));
            }
        }
        
        if(!ankenCheckFlg){
            for(Anken__c anken : ankenList){
                anken.Status__c = NOHINSHORI;
                anken.InvoicePersonnel__c = UserInfo.getUserId();
                anken.NohinshoriFlg__c = true;
            }
            update ankenList;
            
            // 案件画面へ遷移
            return new PageReference(this.retUrl);
        }else{
            return null;
        }
    }
    
    /**
     * 戻る処理
     **/
    public PageReference closeCompiled(){
        
        // 案件画面へ遷移
        return new PageReference(this.retUrl);
    }
}