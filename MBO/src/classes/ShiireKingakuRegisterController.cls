public with sharing class ShiireKingakuRegisterController {

    /** 発注情報ID */
    private String hachuInfoId;

    /** 発注情報データ */
    public HachuInfo__c hachuInfo {
        get;
        set;
    }

    /** 表示用仕入金額データリスト */
    public List<ShiireKingakuDummy> shiireKingakuList {
        get;
        set;
    }

    /** 戻り先URL */
    private String retUrl;

    /**
     * デフォルトコンストラクタ
     */
    public ShiireKingakuRegisterController() {

        // リクエストパラメータ取得
        this.hachuInfoId = ApexPages.currentPage().getParameters().get('hid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
    }

    /**
     * 初期化処理
     */
    public PageReference init() {
        
        // 案件データ取得
        this.hachuInfo = this.getHachuInfoData(this.hachuInfoId);
        
        // 案件明細データ取得
        this.shiireKingakuList = new List<ShiireKingakuDummy>();
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000001'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000002'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000003'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000004'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000005'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000006'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000007'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000000'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000000'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000000'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000000'));
        this.shiireKingakuList.add(this.getShiireKingakuData(this.hachuInfo, '00000000'));
        
        return null;
    }

    /**
     * 発注情報データを取得する。
     *
     * @param hid 発注情報ID
     * @return 発注情報データ
     */
    private HachuInfo__c getHachuInfoData(String hid) {
                
        List<HachuInfo__c> hachyInfoList = [SELECT Id, Name, Hachusaki__c, HachuStatus__c FROM HachuInfo__c WHERE Id = :hid];
        return hachyInfoList[0];
    }

    /**
     * 指定した発注情報ID、作業コードで表示用の仕入金額データを取得する。
     * 
     * @param hachuInfo 発注情報データ
     * @param code 作業コード
     * @return 仕入金額データ
     */
    private ShiireKingakuDummy getShiireKingakuData(HachuInfo__c hachuInfo, String code) {
        
        // 作業データ取得
        List<Sagyo__c> sagyoList = [SELECT Id, Name, SagyoName__c, Teika__c FROM Sagyo__c WHERE Name = :code];
        
        // 発注先仕入価格取得
        Decimal shiireKakaku = 0;
        List<HachusakiShiireKakaku__c> shiireKakakuList = [SELECT Id, Name, ShiireKakaku__c FROM HachusakiShiireKakaku__c WHERE Sagyo__c = :sagyoList[0].Id AND Hachusaki__c = :hachuInfo.Hachusaki__c];
        if (shiireKakakuList.size() > 0) {
            shiireKakaku = shiireKakakuList[0].ShiireKakaku__c;
        }
        
        // 仕入金額データ生成
        ShiireKingaku__c shiireKingaku =  new ShiireKingaku__c(
                                                  HachuInfo__c = hachuInfo.Id,
                                                  SagyoCd__c = sagyoList[0].Id,
                                                  SagyoName__c = sagyoList[0].SagyoName__c,
                                                  Suryo__c = 0.00,
                                                  Tanka__c = shiireKakaku);

        // 表示用仕入金額データ生成
        ShiireKingakuDummy shiireKingakuData = new ShiireKingakuDummy();
        shiireKingakuData.shiireKingaku = shiireKingaku;
                       
        return shiireKingakuData;
    }

    /**
     * 登録処理
     * 登録にチェックされている仕入金額を登録する。
     * 登録後は発注情報画面へ遷移する。
     */
    public PageReference save() {
        
        // 入力チェック
        if (!this.validation(this.shiireKingakuList)) {
            return null;
        }
        
        // 登録対象レコード
        List<ShiireKingaku__c> insItemList = new List<ShiireKingaku__c>();
        
        // 全ての案件明細をチェック
        for (ShiireKingakuDummy item : this.shiireKingakuList) {
            // 登録にチェックがあるもののみ登録対象とする
            if (item.checked) {
                insItemList.add(item.shiireKingaku);
            }
        }
        
        // 更新対象があればinsert
        if (insItemList.size() > 0) {
            insert insItemList;
        }
        
        // 発注情報の発注ステータスを更新
        this.hachuInfo.HachuStatus__c = '金額入力完了';
        update this.hachuInfo;
        
        // 発注情報画面へ遷移
        return new PageReference(this.retUrl);
    }

    /**
     * 入力チェック
     *
     * @param List<ShiireKingakuDummy> 入力された仕入金額情報
     * @return true:OK, false:NG
     */
    private Boolean validation(List<ShiireKingakuDummy> shiireKingakuList) {
        
        Boolean ret = true;
        
        // 最低１件でもチェックされているか
        Boolean isCheck = false;
        for(ShiireKingakuDummy item : shiireKingakuList) {
            if (item.checked) {
                isCheck = true;
            }
        }
        if (!isCheck) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '登録対象の仕入金額が選択されていません。'));
        }

        return ret;
    }

    /**
     * キャンセル処理
     * 案件画面へ遷移する。
     */
    public PageReference cancel() {

        return new PageReference(this.retUrl);
    }

    /**
     * 画面表示用クラス
     */
    public class ShiireKingakuDummy {
        
        /** 仕入金額データ */
        public ShiireKingaku__c shiireKingaku {get; set;}

        /** 登録チェックボックス */
        public boolean checked {get; set;}

        /** デフォルトコンストラクタ */     
        public ShiireKingakuDummy() {
            this.checked = false;
        }
    }

}