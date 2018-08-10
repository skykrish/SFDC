public with sharing class AnkenMeisaiRegisterController {

    /** 案件ID */
    private String ankenId;

    /** どのボタンから遷移したかのパラメータ 20180412追加 */
    private String param;
    
    /** 楽天顧客コード */
    public String rakutenCode = System.Label.RakutenCode;

    /** 案件データ */
    public Anken__c anken {
        get;
        set;
    }

    /** 表示用案件明細データリスト */
    public List<AnkenMeisaiDummy> ankenMeisaiList {
        get;
        set;
    }
    
    /** 表示用RMS案件明細データリスト */
    public List<AnkenMeisaiDummy> RmsAnkenMeisaiList {
        get;
        set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public AnkenMeisaiRegisterController() {
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.param = ApexPages.currentPage().getParameters().get('param');
    }

    /**
     * 初期化処理
     */
    public PageReference init() {

        // 案件データ取得
        this.anken = this.getAnkenData(this.ankenId);

        // 案件明細データ取得
        this.ankenMeisaiList = new List<AnkenMeisaiDummy>();

        /** mod start 20180412 */
        /*
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000001'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000002'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000003'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000004'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000005'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000006'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000007'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000008'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000009'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000010'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000011'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000012'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000013'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000014'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000027'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000028'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000030'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000032'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000038'));
        this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, null, '00000042'));
        */
        /** mod end */

        /** add to 20180412 */
        // 作業名をリストに追加
        List<String> nameList = new List<String>();
        nameList.add('00000001');
        nameList.add('00000002');
        nameList.add('00000003');
        nameList.add('00000004');
        nameList.add('00000005');
        nameList.add('00000006');
        nameList.add('00000007');
        nameList.add('00000008');
        nameList.add('00000009');
        nameList.add('00000010');
        nameList.add('00000011');
        nameList.add('00000012');
        nameList.add('00000013');
        nameList.add('00000014');
        nameList.add('00000027');
        nameList.add('00000028');
        nameList.add('00000030');
        nameList.add('00000032');
        nameList.add('00000038');
        nameList.add('00000042');

        // デフォルト作業データ取得
        List<Sagyo__c> defaultSagyoList = this.getDefaultSagyo(namelist);
        for (Sagyo__c defaultSagyo : defaultSagyoList) {
            this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, defaultSagyo.Id, defaultSagyo.Name));
        }
        /** add end */        

        // 案件明細データ取得（顧客別作業）
        List<Sagyo__c> sagyoList = this.getKobetsuSagyo(this.ankenId);
        for (Sagyo__c sagyo : sagyoList) {
            this.ankenMeisaiList.add(this.getAnkenMeisaiData(this.anken, sagyo.Id, sagyo.Name));
        }

        // 3/25 追加
        // 楽天用案件明細データ取得
        List<Sagyo__c> RmsSagyoList = new List<Sagyo__c>();
        RmsSagyoList = [SELECT ID
                              ,Name
                              ,Kokyaku__r.KokyakuCd__c
                              FROM Sagyo__c
                              WHERE Kokyaku__r.KokyakuCd__c =: rakutenCode
                              AND DelFlg__c = false // 20180412 追加
                              ORDER BY Name
                              ];
        System.debug('RmsSagyoList: '+RmsSagyoList);                           
        this.RmsAnkenMeisaiList = new List<AnkenMeisaiDummy>();
        for (Sagyo__c sagyo : RmsSagyoList) {
            this.RmsAnkenMeisaiList.add(this.getAnkenMeisaiData(this.anken, sagyo.Id, sagyo.Name));
        } 

        return null;
    }

    /**
     * 案件データを取得する。
     *
     * @param aid 案件ID
     * @return 案件データ
     */
    private Anken__c getAnkenData(String aid) {

        List<Anken__c> ankenList = [SELECT Id, Name, AnkenName__c, KokyakuName__c, KokyakuName__r.Name FROM Anken__c WHERE Id = :aid];
        return ankenList[0];
    }


    /**
     * 指定した作業ID、作業コード、難易度で表示用の案件明細データを取得する。
     *
     * @param anken 案件データ
     * @param code 作業ID
     * @param code 作業コード
     * @return 案件明細データ
     */
    private AnkenMeisaiDummy getAnkenMeisaiData(Anken__c anken, String sagyoId, String code) {

        // 作業データ取得
        List<Sagyo__c> sagyoList = null;
        /** mod start 20180412 */
        /*if (Strings.isNullOrEmpty(sagyoId)) {
            // デフォルト作業データ
            // 20180412 SagyoName_E__c,DelFlg__c追加
            sagyoList = [SELECT Id, Name, SagyoName__c, Teika__c, SagyoName_E__c, DelFlg__c FROM Sagyo__c WHERE Name = :code];

        } else {*/
            // 顧客別作業データ
            // 20180412 SagyoName_E__c,DelFlg__c追加
            sagyoList = [SELECT Id, Name, SagyoName__c, Teika__c, SagyoName_E__c,DelFlg__c FROM Sagyo__c WHERE Id = :sagyoId];
        //}
        /** mod end */

        // 割引データ取得
        Decimal waribikiritsu = 0.00;
        List<Waribiki__c> waribikiList = [SELECT Waribikiritsu__c FROM Waribiki__c WHERE Kokyaku__c = :anken.KokyakuName__c AND Sagyo__c = :sagyoList[0].Id];
        if (waribikiList.size() > 0) {
            waribikiritsu = waribikiList[0].Waribikiritsu__c;
        }

        // 消費税データ取得
        Double taxRate = Double.valueOf(System.Label.TaxRate);

        /** add start 20180412 */
        // 作業名設定
        String sagyoName = '';
        // InputClassificationボタンから遷移した場合、作業名は英名を設定
        if(this.param == 'InputClassification'){
          sagyoName = sagyoList[0].SagyoName_E__c;
        }
        /** add end */

        // 案件明細データ生成
        AnkenMeisai__c ankenMeisai =  new AnkenMeisai__c(
                                              Anken__c = anken.Id,
                                              SagyoCd__c = sagyoList[0].Id,
                                              SagyoName__c = sagyoList[0].SagyoName__c, // 20180412 コメントアウト
                                              SagyoName_English__c = sagyoName, // 20180425追加
                                              Suryo__c = 0.00,
                                              Tanka__c = sagyoList[0].Teika__c,
                                              Waribikiritsu__c = waribikiritsu,
                                              TaxRate__c = taxRate,
                                              MitsumoriFlg__c = true);
System.debug('ankenMeisai'+ankenMeisai);

        // 表示用案件明細データ生成
        AnkenMeisaiDummy ankenMeisaiData = new AnkenMeisaiDummy();
        ankenMeisaiData.ankenMeisai = ankenMeisai;

        return ankenMeisaiData;
    }

    /**
     * 指定した案件IDから顧客別作業データを取得する。 
     *
     * @param aid 案件ID
     * @return 顧客別作業データ
     */
     private List<Sagyo__c> getKobetsuSagyo(String aid) {

        // 顧客ID取得
        List<Anken__c> ankenList = [SELECT Id, kokyakuName__c FROM Anken__c WHERE Id = :aid];

        // 顧客別作業データ取得
        // 20180410 DelFlg__c条件追加
        List<Sagyo__c> sagyoList = [SELECT Id, Name FROM Sagyo__c WHERE Kokyaku__c = :ankenList[0].kokyakuName__c AND DelFlg__c = false];

        return sagyoList;
     }

    /**
     * 20180412 追加
     * 指定した作業名からデフォルト作業データを取得する。 
     *
     * @param nameList デフォルト作業名
     * @return デフォルト作業データ
     */
     private List<Sagyo__c> getDefaultSagyo(List<String> nameList) {

        // デフォルト作業データ取得
        List<Sagyo__c> defaultSagyoList = [SELECT Id, Name FROM Sagyo__c WHERE Name IN :namelist AND DelFlg__c = false ORDER BY Name];

        return defaultSagyoList;
     }

    /**
     * 登録処理
     * 登録にチェックされている案件明細を登録する。
     * 登録後は案件画面へ遷移する。
     */
    public PageReference save() {

        // 入力チェック
        if (!this.validation()) {
            return null;
        }

        // 登録対象レコード
        List<AnkenMeisai__c> insItemList = new List<AnkenMeisai__c>();

        // 全ての案件明細をチェック
        for (AnkenMeisaiDummy item : this.ankenMeisaiList) {
            // 登録にチェックがあるもののみ登録対象とする
            if (item.checked) {
                insItemList.add(item.ankenMeisai);
            }
        }

        // 更新対象があればinsert
        if (insItemList.size() > 0) {
            insert insItemList;
        }

        // 案件画面へ遷移
        return new PageReference('/' + this.ankenId);
    }
    
    /**
     * 3/28 追加
     * 楽天案件登録処理
     * 登録にチェックされている案件明細を登録する。
     * 登録後は案件画面へ遷移する。
     */
    public PageReference saveRms() {

        // 入力チェック
        if (!this.validation()) {
            return null;
        }

        // 登録対象レコード
        List<AnkenMeisai__c> insItemList = new List<AnkenMeisai__c>();

        // 全ての案件明細をチェック
        for (AnkenMeisaiDummy item : this.RmsAnkenMeisaiList) {
            // 登録にチェックがあるもののみ登録対象とする
            if (item.checked) {
                insItemList.add(item.ankenMeisai);
            }
        }

        // 更新対象があればinsert
        if (insItemList.size() > 0) {
            insert insItemList;
        }

        // 案件画面へ遷移
        return new PageReference('/' + this.ankenId);
    }

    /**
     * 入力チェック
     */
    private Boolean validation() {

        Boolean ret = true;

        // 全ての案件明細をチェック
        for (AnkenMeisaiDummy item : this.ankenMeisaiList) {
            // 登録にチェックがあるもののみ入力チェック対象とする
            if (item.checked) {
                // 割引率チェック
                if (item.ankenMeisai.Waribikiritsu__c < 0 || item.ankenMeisai.Waribikiritsu__c > 100) {
                    item.ankenMeisai.Waribikiritsu__c.addError('割引率には0～100%の値を設定してください。');
                    ret = false;
                }
            }
        }
        
        // 3/28追加
        for (AnkenMeisaiDummy item : this.RmsAnkenMeisaiList) {
            // 登録にチェックがあるもののみ入力チェック対象とする
            if (item.checked) {
                // 割引率チェック
                if (item.ankenMeisai.Waribikiritsu__c < 0 || item.ankenMeisai.Waribikiritsu__c > 100) {
                    item.ankenMeisai.Waribikiritsu__c.addError('割引率には0～100%の値を設定してください。');
                    ret = false;
                }
            }
        }

        return ret;
    }

    /**
     * キャンセル処理
     * 案件画面へ遷移する。
     */
    public PageReference cancel() {
        return new PageReference('/' + this.ankenId);
    }

    /**
     * 画面表示用クラス
     */
    public class AnkenMeisaiDummy {

        /** 案件明細データ */
        public AnkenMeisai__c ankenMeisai {get; set;}

        /** 登録チェックボックス */
        public boolean checked {get; set;}
        
        /** デフォルトコンストラクタ */
        public AnkenMeisaiDummy() {
            this.checked = false;
        }
    }
}