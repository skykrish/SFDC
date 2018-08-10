public with sharing class SoufujoController {
    /** 送付状リスト */
    public List<PageData> soufujoList {
        get;
        private set;
    }

    /** 請求日 */
    public Date seikyubi {
        get;
        private set;
    }

    /** 請求ヘッダID */
    private List<String> seikyuHeaderId;

    /** 請求ヘッダ区切り文字 */
    private static String DELIMITER = ',';

    /**
     * デフォルトコンストラクタ
     */
    public SoufujoController() {
        this.seikyuHeaderId = ApexPages.currentPage().getParameters().get('shid').split(DELIMITER);

        this.seikyubi = system.today();

        this.init();
    }

    /**
     * 初期化処理
     */
    public PageReference init() {
        // 請求ヘッダデータ取得
        Map<Id, SeikyuHeader__c> sHead = this.getSeikyuHeaderData(this.seikyuHeaderId);

        // 請求担当者マップ作成
        Map<Id, Contact> stMap = this.getTantosyaMap(sHead);

        // 送付状リストを作成
        this.soufujoList = new List<PageData>();
        for(Id shid :this.seikyuHeaderId){
            SeikyuHeader__c sh = sHead.get(shid);
            Contact contact = new Contact();
            contact = stMap.get(sh.Seikyusaki__c);
            String seikyuTantosya = contact.Name;
            String department = contact.Department;
            PageData pData = new PageData(sh, seikyuTantosya, department);
            this.soufujoList.add(pData);
        }

        // 最終送付状フラグを更新
        PageData lastSoufujo = this.soufujoList[this.soufujoList.size() - 1];
        lastSoufujo.isLast = true;

        return null;
    }

    /**
     * 請求ヘッダデータを取得する。
     *
     * @param shidList 請求ヘッダIDリスト
     * @return 請求ヘッダデータ
     */
    private Map<Id, SeikyuHeader__c> getSeikyuHeaderData(List<String> shidList) {

        Map<Id, SeikyuHeader__c> shMap = new Map<Id, SeikyuHeader__c>([SELECT
                                        Id, //ID
                                        Name, //請求書番号
                                        Seikyusaki__c, //請求先
                                        Seikyusaki__r.KokyakuCd__c, //顧客コード
                                        SeikyusakiName__c, //請求先名
                                        BillingPostalCode__c, //請求先郵便番号
                                        BillingState__c, //請求先都道府県
                                        BillingCity__c, //請求先市区町村
                                        BillingStreet__c //請求先番地
                                    FROM
                                        SeikyuHeader__c
                                    WHERE
                                        Id = :shidList]);
        return shMap;
    }

    /**
     * 請求担当者のマップを作成する。
     *
     * @param shMap 請求ヘッダマップ
     * @return 請求担当者マップ
     */
    private Map<Id, Contact> getTantosyaMap(Map<Id, SeikyuHeader__c> shMap) {

        // 請求先IDリスト作成
        Map<Id, Id> aIdMap = new Map<Id, Id>();
        for(SeikyuHeader__c sh :shMap.values()){
            // 重複排除
            if (!aIdMap.containsKey(sh.Seikyusaki__c)) {
                aIdMap.put(sh.Seikyusaki__c, sh.Seikyusaki__c);
            }
        }

        // 請求担当者取得
        List<Contact> stList = this.getSeikyuTantosya(aIdMap.values());

        // 請求担当者マップ作成
        Map<Id, Contact> stMap = new Map<Id, Contact>();
        for(Contact st :stList){
            stMap.put(st.AccountId, st);
        }

        return stMap;
    }

    /**
     * 請求担当者データを取得する。
     *
     * @param aIdList 顧客IDリスト
     * @return 請求担当者リスト
     */
    private List<Contact> getSeikyuTantosya(List<Id> aIdList) {

        List<Contact> stList = [SELECT
                                        Id, //ID
                                        Name, //名前
                                        AccountId, //取引先
                                        Department //部署名
                                    FROM
                                        Contact
                                    WHERE
                                        AccountId = :aIdList
                                    AND SeikyuTantoFlg__c = true];

        return stList;
    }

    /**
     * １ページのデータを纏めたクラス
     */
    public class PageData {

        /** このページに表示する請求先データ */
        public SeikyuHeader__c sHead {get; set;}

        /** 請求先名リスト */
        public List<String> seikyusakiNameList {get; set;}

        /** 請求担当者 */
        public String seikyuTantosya {get; set;}

        /** 部署 */
        public String department {get; set;}

        /** 最終送付状かどうか */
        public boolean isLast {get; set;}

        /** デフォルトコンストラクタ */
        public PageData(SeikyuHeader__c sHead, String seikyuTantosya, String department) {
            this.sHead = sHead;
            this.seikyusakiNameList = new List<String>();
            this.setSeikyusakiNameList();
            this.seikyuTantosya = seikyuTantosya;
            this.department = department;
            this.isLast = false;
        }

        /**
         * 請求先名を分割しリストに設定
         */
        private void setSeikyusakiNameList(){

            String seikyusakiName = this.sHead.SeikyusakiName__c;

            while (seikyusakiName.length() > 20){
                this.seikyusakiNameList.add(seikyusakiName.substring(0, 20));
                seikyusakiName = seikyusakiName.substring(20);
            }
            this.seikyusakiNameList.add(seikyusakiName);
        }

    }
}