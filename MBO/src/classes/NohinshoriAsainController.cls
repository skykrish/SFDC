public with sharing class NohinshoriAsainController {
    
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
    
    /** 納品処理担当者 */
    public Anken__c ankenAsain {get;set;}
    
    /** 処理対象の案件リスト */
    public List<Anken__c> ankenList {
        get;
        set;
    }

    /** 戻り先URL */
    private String retUrl;
    
    /** 納品ステータス */
    private String NOHINSHORI = '納品処理中';
    
    
    /**
     * デフォルトコンストラクタ
     */
    public NohinshoriAsainController() {
        
        // リクエストパラメータ取得
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        // 初期化
        ankenList = new List<Anken__c>();
        ankenAsain = new Anken__c();
        
        ankenFlg = false;
        ankenCheckFlg = false;
        
    }
    
    /**
     * リストビュー上から呼ばれるコンストラクタ
     */
    public NohinshoriAsainController(ApexPages.StandardSetController controller) {

        // リクエストパラメータ取得
        this.records = (List<Anken__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        // 初期化
        ankenList = new List<Anken__c>();
        ankenIdSet = new Set<ID>();
        ankenAsain = new Anken__c();
        
        // 案件IDList取得
        for(Anken__c anken : this.records){
            ankenIdSet.add(anken.Id);
        }
        
        ankenFlg = false;
        ankenCheckFlg = false;
    }
    
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
                            Id = :ankenId];
        
        // ステータスが請求確定済み以降となっていないかチェック
        if (ankenList[0].StatusLock__c) {
            ankenCheckFlg = true;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '請求確定済みの案件です。'));
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
                if(anken.Status__c != NOHINSHORI){
                    ankenFlg = true;
                }
            }
        }
        
        return null;
    }
    
    /**
     * ステータス変更処理
     **/
    public PageReference updateAnken() {
        
        // 納品担当者入力チェック
        if(ankenAsain.InvoicePersonnelAsain__c == null){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '納品担当者を選択してください。'));
            return null;
        }
        
        for(Anken__c anken : ankenList){
            anken.Status__c = NOHINSHORI;
            anken.InvoicePersonnel__c = ankenAsain.InvoicePersonnelAsain__c;
            anken.NohinshoriFlg__c = true;
        }
        update ankenList;
        
        // 案件画面へ遷移
        return new PageReference(this.retUrl);
    }
    
    /**
     * 戻る処理
     **/
    public PageReference closeCompiled(){
        
        // 案件画面へ遷移
        return new PageReference(this.retUrl);
    }
    
}