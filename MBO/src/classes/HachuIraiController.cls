public with sharing class HachuIraiController {

    /** 発注情報ID */
    private String hachuInfoId;

    /** 処理対象の発注情報IDリスト */
    private List<String> hachuInfoIdList;
    
    /** 発注情報リスト */
    public List<HachuInfo__c> hachuInfoList {
        get;
        set;
    }

    /** 戻り先URL */
    private String retUrl;

    /**
     * デフォルトコンストラクタ
     */
    public HachuIraiController() {

        // リクエストパラメータ取得
        this.hachuInfoId = ApexPages.currentPage().getParameters().get('hid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');

        // 処理対象の発注情報IDリスト生成
        // 発注情報登録（一括）より遷移した場合には、
        // 発注情報Idはカンマ区切りで複数送信されます。
        this.hachuInfoIdList = this.hachuInfoId.split(',');
    }

    /**
     * 初期化処理
     */
    public PageReference init() {
        
        // 発注情報取得
        this.hachuInfoList = this.getHachuInfoData(this.hachuInfoIdList);
        
        // 発注依頼内容取得
        
        return null;
    }
    
    /**
     * 発注情報取得
     *
     * @param hids 発注情報Id
     * @return 発注情報
     */
    private List<HachuInfo__c> getHachuInfoData(List<String> hids) {

        List<HachuInfo__c> hachuInfoList = [SELECT
                                                Id,
                                                Name,
                                                Nouki__c,
                                                ItemCnt__c,
                                                Hachusaki__c,
                                                HachuStatus__c,
                                                HachuDate__c,
                                                Sagyoshiji_Renrakujiko__c,
                                                Anken__c
                                            FROM
                                                HachuInfo__c
                                            WHERE
                                                Id IN :hids
                                            ORDER BY
                                                Anken__r.Nouki_Date__c asc nulls last,
                                                Anken__r.Nouki_Time__c,
                                                Name];

        return hachuInfoList;
    }

    /**
     * ステータス変更
     */
    public PageReference updStatus() {
        
        // 更新対象案件Id
        List<String> ankenIdList = new List<String> ();
        
        // 発注ステータス、発注日時変更
        for (HachuInfo__c item : this.hachuInfoList) {
                item.HachuStatus__c = '依頼済み';
                item.HachuDate__c = Datetime.now();
                ankenIdList.add(item.Anken__c);
        }
        update this.hachuInfoList;

        // 案件ステータス変更
        List<Anken__c> ankenList = [SELECT Id, Name, Status__c FROM Anken__c WHERE Id = :ankenIdList];
        for (Anken__c item : ankenList) {
            item.Status__c = '受注委託済み';
        }
        update ankenList;
        
        // 呼び出し元画面へ遷移
        return new PageReference(this.retUrl);
    }

    /**
     * キャンセル
     */
    public PageReference cancel() {

        // 呼び出し元画面へ遷移
        return new PageReference(this.retUrl);
    }
}