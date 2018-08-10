public with sharing class SitesOrderlistController extends SitesAbstractController {

    // 定数
    /** 日付項目：発注日時 */
    private static String DATE_LABEL_ORDER = 'ご発注日時';
    /** 日付項目：納品日時 */
    private static String DATE_LABEL_DELIVERY = '納品日時';
    /** 日付項目：発注日時 */
    private static String DATE_COLUMN_ORDER = 'JuchuDateTime__c';
    /** 日付項目：納品日時 */
    private static String DATE_COLUMN_DELIVERY = 'NohinDateTime__c';
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

    /** JST調整 */
    private static Integer ADJUST_JST = -9;
    /** スタイル：first */
    private static String FIRST = 'first';
    /** スタイル：firstoff */
    private static String FIRSTOFF = 'firstoff';
    /** スタイル：prev */
    private static String PREV = 'prev';
    /** スタイル：prevoff */
    private static String PREVOFF = 'prevoff';
    /** スタイル：next */
    private static String NEXT = 'next';
    /** スタイル：nextoff */
    private static String NEXTOFF = 'nextoff';
    /** スタイル：last */
    private static String LAST = 'last';
    /** スタイル：lastoff */
    private static String LASTOFF = 'lastoff';
    /** ソート順：昇順 */
    private static String SORT_DRC_ASC = 'ASC';
    /** ソート順：降順 */
    private static String SORT_DRC_DESC = 'DESC';
    /** null値ソート指定：最初 */
    private static String SORT_NULLS_FIRST = 'NULLS FIRST';
    /** null値ソート指定：最後 */
    private static String SORT_NULLS_LAST = 'NULLS LAST';
    /** デフォルトソート項目：案件番号 */
    private static String DEFAULT_SORT_COLUMN = 'Name';

    /**
     * 日付項目
     */
    public String dateColumn {
        get;
        set;
    }

    /** 日付項目選択リストオプション */
    public List<SelectOption> dateSelectOptions {
        get;
        private set;
    }

    /**
     * 日時（開始）
     */
    public String dateFrom {
        get;
        set;
    }

    /**
     * 日時（終了）
     */
    public String dateTo {
        get;
        set;
    }

    /**
     * 表示用案件データ
     */
    public List<AnkenDummy> ankenList {
        get;
        set;
    }

    /**
     * ページング
     */
    public Paginator paginator {
        get;
        set;
    }

    /** ソート項順 */
    public String sortDrc {
        get;
        set;
    }

    /** ソート項目 */
    public String sortExp {
        get;
        set;
    }
    
    /** 検索結果件数 */
    public Integer resultCount {
        get;
        set;
    }
    
    /** 案件Id */
    public String ankenIdsStr {
        get;
        set;
    }

    /** 現在のソート項目 */
    private String sortExpNow;

    /**
     * デフォルトコンストラクタ
     */
    public SitesOrderlistController() {
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {

        // 日付項目初期化
        this.dateColumn = DATE_COLUMN_DELIVERY;

        // 担当者選択リストオプション生成
        this.dateSelectOptions = new List<SelectOption>();
        this.dateSelectOptions.add(new SelectOption(DATE_COLUMN_ORDER, DATE_LABEL_ORDER));
        this.dateSelectOptions.add(new SelectOption(DATE_COLUMN_DELIVERY, DATE_LABEL_DELIVERY));


        // 日時初期化
        this.dateFrom = null;
        this.dateTo = null;

        // ソート項目のデフォルト設定
        this.sortDrc = SORT_DRC_DESC;
        this.sortExp = DEFAULT_SORT_COLUMN;
        this.sortExpNow = this.sortExp;

        // 表示用案件データ取得
        List<AnkenDummy> ankenList = this.getAnkenData(getKokyakuId(), this.dateColumn, this.dateFrom, this.dateTo, this.sortExp, this.sortDrc);

        // ページング初期化
        this.paginator = new Paginator(Integer.valueOf(System.Label.OrderlistPerPage));
        this.ankenList = this.paginator.getDispAnkenData(ankenList);

        return null;
    }

    /**
     * 案件データ取得
     *
     * @param kokyakuId 顧客ID
     * @param dateColumn 日付項目
     * @param dateFrom 日時（開始）
     * @param dateTo 日時（終了）
     * @param sortExp ソート項目
     * @param sortDrc ソート順
     * @return 案件データ
     */
    private List<AnkenDummy> getAnkenData(String kokyakuId, String dateColumn, String dateFrom, String dateTo, String sortExp, String sortDrc) {

        // 日付条件生成：日時（開始）
        Datetime searchFrom = null;
        if (!Strings.isNullOrEmpty(dateFrom)) {
            List<String> dateFromItem = dateFrom.split('/');
            searchFrom = Datetime.newInstance(Integer.valueOf(dateFromItem[0]), Integer.valueOf(dateFromItem[1]), Integer.valueOf(dateFromItem[2]), 0, 0, 0);
            searchFrom = searchFrom.addHours(ADJUST_JST);
        }

        // 日付条件生成：日時（終了）
        Datetime searchTo = null;
        if (!Strings.isNullOrEmpty(dateTo)) {
            List<String> dateToItem = dateTo.split('/');
            searchTo = Datetime.newInstance(Integer.valueOf(dateToItem[0]), Integer.valueOf(dateToItem[1]), Integer.valueOf(dateToItem[2]), 23, 59, 59);
            searchTo = searchTo.addHours(ADJUST_JST);
        }

        // 検索用クエリ生成
        String query = 'SELECT '
                     + ' Id, '
                     + ' Name, '
                     + ' JuchuDateTime__c, '
                     + ' ClientOrderNumber__c, '
                     + ' Status__c, '
                     + ' AnkenName__c, '
                     + ' KokyakuTantosya_Main__r.Department, '
                     + ' KokyakuTantosya_Main__r.Name, '
                     + ' FolderName__c, '
                     + ' ItemCnt__c, '
                     + ' NohinDateTime__c, '
                     + ' NohinTantosya__r.Name, '
                     + ' JuchuTotalKingaku__c, '
                     + ' JuchuTotalTax__c, '
                     + ' JuchuTotalKingaku_Tax__c, '
                     + ' MitsumorisyoId__c, '
                     + ' NohinsyoId__c '
                     + 'FROM '
                     + ' Anken__c '
                     + 'WHERE '
                     + ' KokyakuName__c = :kokyakuId AND '
                     + ' SampleKokyakuFlg__c = false AND '
                     + dateColumn + ' >= :searchFrom AND '
                     + dateColumn + ' <= :searchTo '
                     + 'ORDER BY '
                     + sortExp + ' ' + sortDrc + ' '
// mod start 2017-11-13
//                     + ((sortDrc == SORT_DRC_DESC) ? SORT_NULLS_FIRST : SORT_NULLS_LAST);
                     + ((sortDrc == SORT_DRC_DESC) ? SORT_NULLS_FIRST : SORT_NULLS_LAST)
                     + ' limit 20000';
// mod end 2017-11-13

        // 検索
        List<Anken__c> ankenList = database.query(query);

        // 案件に対応する請求データ取得
        List<String> aidList = new List<String> ();
        for (Anken__c item : ankenList) {
            aidList.add(item.Id);
        }
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
        
        // 検索結果件数を取得する
        this.resultCount = dummyList.size();
        
        // 全件ダウンロード用案件Idを取得する
        this.ankenIdsStr = '';
        for(Integer i = 0; i < dummyList.size(); i++){
            if(i==0){
                this.ankenIdsStr += dummyList.get(i).anken.Id;
            }else{
                this.ankenIdsStr += ',' + dummyList.get(i).anken.Id;
            }
            
            // 1000件まで
            if(i == 999){
                break;
            }
        }

        return dummyList;
    }

    /**
     * 絞込み
     */
    public PageReference search() {

        // メッセージクリア
        clearMessage();

        // 入力チェック
        if (!this.validate()) {
            return null;
        }

        // 表示用案件データ取得
        List<AnkenDummy> ankenList = this.getAnkenData(getKokyakuId(), this.dateColumn, this.dateFrom, this.dateTo, this.sortExp, this.sortDrc);
        
        // ページング
        this.paginator.dispPage = 0;
        this.ankenList = this.paginator.getDispAnkenData(ankenList);

        return null;
    }
    
    /**
     * 全件ダウンロードのチェック
     */
    public PageReference checkDownLoadAllCsvData() {
        
        // 1000件以上なら、エラーを表示する
        if(resultCount > 1000){
            // メッセージクリア
             clearMessage();

             this.validate();
             
             addMessage(MESSAGE_CLS_ERROR, 'ダウンロード制限（1000 件）を超えるため、案件情報をダウンロードできません。検索条件を絞ってください。');
        }
        return null;
    }

    /**
     * 入力チェック
     */
    private Boolean validate() {

        Boolean ret = true;

        // 形式チェック - 日時（開始）
        if (!Strings.isNullOrEmpty(this.dateFrom)) {
            if (!Strings.isDate(this.dateFrom)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '開始日時が日付形式ではありません。');
            }
        }
        // 形式チェック - 日時（終了）
        if (!Strings.isNullOrEmpty(this.dateTo)) {
            if (!Strings.isDate(this.dateTo)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '開始日時が日付形式ではありません。');
            }
        }

        return ret;
    }

    /**
     * ソート
     */
    public PageReference sort() {

        // 指定されたソート項目をチェック
        if (this.sortExp == this.sortExpNow) {
            // 現在のソート項目と一致すれば、ソート順を入れ替える
            this.sortDrc = (this.sortDrc == SORT_DRC_ASC) ? SORT_DRC_DESC : SORT_DRC_ASC;

        } else {
            // 一致しなければ、指定されたソート項目を昇順で設定
            this.sortDrc = SORT_DRC_ASC;
            this.sortExpNow = this.sortExp;
        }

        // 再検索
        return this.search();
    }

    /**
     * 見積書ダウンロード
     */
    public PageReference printMitsumorisyo() {

        // リクエストパラメータ取得
        String aid = ApexPages.currentPage().getParameters().get('aid');

        // PDF表示
        PageReference nextPage = getNextPage('mitsumorisyo');
        nextPage.getParameters().put('aid', aid);
        nextPage.getParameters().put('sites', 'on');

        return nextPage;
    }

    /**
     * 納品書ダウンロード
     */
    public PageReference printNohinsyo() {

        // リクエストパラメータ取得
        String aid = ApexPages.currentPage().getParameters().get('aid');

        // PDF表示
        PageReference nextPage = getNextPage('nohinsyo');
        nextPage.getParameters().put('aid', aid);
        nextPage.getParameters().put('sites', 'on');
        return nextPage;
    }

    /**
     * ページング
     */
    public PageReference paging() {

        // 表示用案件データ取得
        List<AnkenDummy> ankenList = this.getAnkenData(getKokyakuId(), this.dateColumn, this.dateFrom, this.dateTo, this.sortExp, this.sortDrc);

        // ページング
        this.ankenList = this.paginator.getDispAnkenData(ankenList);

        return null;
    }

    /**
     * 発注フォーム
     */
    public PageReference order() {

        // 遷移
        PageReference nextPage = getNextPage('order');
        return nextPage;
    }

    /**
     * 表示用案件クラス
     */
    public class AnkenDummy {

        /** 選択用チェックボックス */
        public boolean checked {get; set;}

        /** 案件データ */
        public Anken__c anken {get; private set;}

        /** 案件ステータス */
        public String ankenStatus {get; private set;}

        /** 請求状況 */
        public String seikyuStatus {get; private set;}

        /** デフォルトコンストラクタ */
        public AnkenDummy() {
            this.checked = false;
        }
    }

    /**
     * ページングクラス
     */
    public class Paginator {

        /** １ページ件数 */
        public Integer perPage {get; private set;}

        /** 表示ページ */
        public Integer dispPage {get; set;}

        /** 最大ページ */
        public Integer maxPage {get; private set;}

        /** スタイル：First */
        public String classFirst {get; private set;}

        /** スタイル：Prev */
        public String classPrev {get; private set;}

        /** スタイル：Next */
        public String classNext {get; private set;}

        /** スタイル：Last */
        public String classLast {get; private set;}

        /** デフォルトコンストラクタ */
        public Paginator(Integer perPage) {
            this.perPage = perPage;
            this.dispPage = 0;
            this.maxPage = 0;
            this.classFirst = FIRSTOFF;
            this.classPrev = PREVOFF;
            this.classNext = NEXTOFF;
            this.classLast = LASTOFF;
        }

        /** 表示データ取得 */
        public List<AnkenDummy> getDispAnkenData(List<AnkenDummy> orgList) {

            // 表示範囲
            Integer pageFrom = this.perPage * this.dispPage;
            Integer pageTo = this.perPage * this.dispPage + this.perPage;

            // 表示データ取得
            List<AnkenDummy> ankenList = new List<AnkenDummy> ();
            for (Integer i = pageFrom; i < pageTo && i < orgList.size(); i ++) {
                ankenList.add(orgList[i]);
            }

            // 最大ページ数
            this.maxPage = orgList.size() / this.perPage;
            if (Math.mod(orgList.size(), this.perPage) == 0) {
                this.maxPage --;
            }

            if (orgList.size() > 0) {
                // スタイル設定
                this.classFirst = (this.dispPage == 0) ? FIRSTOFF : FIRST;
                this.classPrev = (this.dispPage == 0) ? PREVOFF : PREV;
                this.classNext = (this.dispPage == maxPage) ? NEXTOFF : NEXT;
                this.classLast = (this.dispPage == maxPage) ? LASTOFF : LAST;
            } else {
                // スタイル設定(検索結果が0件)
                this.classFirst = FIRSTOFF;
                this.classPrev = PREVOFF;
                this.classNext = NEXTOFF;
                this.classLast = LASTOFF;
            }

            return ankenList;
        }
    }
}