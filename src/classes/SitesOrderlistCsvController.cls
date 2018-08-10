public with sharing class SitesOrderlistCsvController extends SitesAbstractController {

    // 定数
    /** 案件ID区切り文字 */
    private static String DELIMITER = ',';
    /** ステータス：受注納期通知済み */
    private static String STATUS_ANNOUNCED = '受注納期通知済み';
    /** ステータス：受注委託済み */
    private static String STATUS_OUTSOURCED = '受注委託済み';
    /** ステータス：受注納品済み */
    private static String STATUS_DELIVERED = '受注納品済み';
    /** ステータス：アップロード完了*/
    private static String STATUS_UPLOADFINISH = 'アップロード完了';
    /** ステータス：ダウンロード済み */
    private static String STATUS_DOWNLOADFINISH = 'ダウンロード済み';
    /** 表示用ステータス：作業開始準備中 */
    private static String DISP_STATUS_ANNOUNCED = '作業開始準備中';
    /** 表示用ステータス：作業中 */
    private static String DISP_STATUS_OUTSOURCED = '作業中';
    /** 表示用ステータス：納品済 */
    private static String DISP_STATUS_DELIVERED = '納品済';

    /**
     * CSV用案件データ
     */
    public List<AnkenDummy> ankenList {
        get;
        set;
    }

    /**
     * 案件IDリスト
     */
    private List<String> aidList;

    /**
     * デフォルトコンストラクタ
     */
    public SitesOrderlistCsvController() {

        // リクエストパラメータ取得
        String Ids = ApexPages.currentPage().getParameters().get('aidList');

        // 案件IDリスト生成
        this.aidList = Ids.split(DELIMITER);
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {

        // 案件データ取得
        this.ankenList = this.getAnkenData(this.aidList);

        return null;
    }

    /**
     * 案件データ取得
     *
     * @param aidList 案件IDリスト
     * @return 案件データ
     */
    private List<AnkenDummy> getAnkenData(List<String> aidList) {

        // 案件データ取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        JuchuDateTime__c,
                                        ClientOrderNumber__c,
                                        Status__c,
                                        AnkenName__c,
                                        KokyakuTantosya_Main__r.Department,
                                        KokyakuTantosya_Main__r.Name,
                                        FolderName__c,
                                        ItemCnt__c,
                                        NohinDateTime__c,
                                        NohinTantosya__r.Name,
                                        JuchuTotalKingaku__c,
                                        JuchuTotalTax__c,
                                        JuchuTotalKingaku_Tax__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aidList
                                    ORDER BY
                                        Name DESC];

        // 案件に対応する請求データ取得
        List<Seikyu__c> seikyuList = [SELECT
                                          Id,
                                          Name,
                                          SeikyusyoNo__r.SeikyuStatus__c,
                                          DenpyoNo__c
                                      FROM
                                          Seikyu__c
                                      WHERE
                                          DenpyoNo__c = :aidList
                                      AND
                                          SeikyusyoNo__r.Del_Flg__c = false];

        // 案件IDをキーとした請求データマップ作成
        Map<String, Seikyu__c> seikyuMap = new Map<String, Seikyu__c> ();
        for (Seikyu__c item : seikyuList) {
            seikyuMap.put(item.DenpyoNo__c, item);
        }

        // 表示用案件データ作成
        List<AnkenDummy> dummyList = new List<AnkenDummy>();
        for (Anken__c item : ankenList) {
            // 表示用案件データ作成
            AnkenDummy dummy = new AnkenDummy();
            dummy.anken = item;
            // ステータスを設定
            if(item.Status__c == STATUS_ANNOUNCED) {
                // 受注納期通知済み
                dummy.ankenStatus = DISP_STATUS_ANNOUNCED;
            }
            else if (item.Status__c == STATUS_OUTSOURCED || item.Status__c == STATUS_UPLOADFINISH || item.Status__c == STATUS_DOWNLOADFINISH) {
                // 受注委託済み OR アップロード完了 OR ダウンロード済み
                dummy.ankenStatus = DISP_STATUS_OUTSOURCED;
            }
            else if (item.Status__c == STATUS_DELIVERED) {
                // 受注納品済み
                dummy.ankenStatus = DISP_STATUS_DELIVERED;
            }
            else {
                // その他
                dummy.ankenStatus = item.Status__c;
            }
            // 請求状況を設定
            if (seikyuMap.containsKey(item.Id)) {
                dummy.seikyuStatus = seikyuMap.get(item.Id).SeikyusyoNo__r.SeikyuStatus__c;
            }
            // リストに追加
            dummyList.add(dummy);
        }

        return dummyList;
    }

    /**
     * CSV用案件クラス
     */
    public class AnkenDummy {

        /** 案件データ */
        public Anken__c anken {get; private set;}

        /** 案件ステータス */
        public String ankenStatus {get; private set;}

        /** 請求状況 */
        public String seikyuStatus {get; private set;}

        /** デフォルトコンストラクタ */
        public AnkenDummy() {
        }
    }

}