public with sharing class SitesBillingController extends SitesAbstractController {

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


    /**
     * デフォルトコンストラクタ
     */
    public SitesBillingController() {
    }

    /**
     * 表示用案件データ
     */
    public List<SeikyuDummy> seikyuList {
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

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {
        
        // 顧客ID取得
        String kokyakuId = getKokyakuId();
        
        // 請求データ取得
        List<SeikyuDummy> seikyuList = this.getSeikyuData(kokyakuId);

        // ページング初期化
        this.paginator = new Paginator(Integer.valueOf(System.Label.SeikyulistPerPage));
        this.seikyuList = this.paginator.getDispSeikyuData(seikyuList);

        return null;
    }
    
    /**
     * 請求データ取得
     *
     * @param kokyakuId 顧客ID
     * @return 請求データ
     */
    private List<SeikyuDummy> getSeikyuData(String kokyakuId) {

        // 請求データ取得
        List<SeikyuHeader__c> seikyuList = [SELECT
                                                Id,
                                                Name,
                                                Seikyusaki__c,
                                                SeikyuStatus__c,
                                                NyukinStatus__c,
                                                Seikyugaku__c,
                                                Tax__c,
                                                Seikyugaku_Tax__c,
                                                SeikyuDateTime__c,
                                                SeikyusyoId__c,
                                                PDFDowload__c,
                                                Del_Flg__c
                                            FROM
                                                SeikyuHeader__c
                                            WHERE
                                                Seikyusaki__c = :kokyakuId AND
                                                SeikyuStatus__c = '請求済み' AND
                                                Del_Flg__c = false
                                            ORDER BY
                                                Name DESC];
                                                
        // 表示用案件データ作成
        List<SeikyuDummy> dummyList = new List<SeikyuDummy>();
        for (SeikyuHeader__c item : seikyuList) {
            // 表示用案件データ作成
            SeikyuDummy dummy = new SeikyuDummy();
            dummy.seikyu = item;

            // リストに追加
            dummyList.add(dummy);
        }                       

        return dummyList;
    }

    /**
     * 請求書ダウンロード
     */
    public PageReference print() {

        // リクエストパラメータ取得
        String seikyusyoId = ApexPages.currentPage().getParameters().get('shid');

        // PDF表示
        PageReference nextPage = getNextPage('seikyusyo');
        nextPage.getParameters().put('shid', seikyusyoId);
        return nextPage;
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
    public class SeikyuDummy {

        /** 案件データ */
        public SeikyuHeader__c seikyu {get; private set;}


        /** デフォルトコンストラクタ */
        public SeikyuDummy() {
        }
    }

    /**
     * ページング
     */
    public PageReference paging() {

        // 表示用案件データ取得
        List<SeikyuDummy> seikyuList = this.getSeikyuData(getKokyakuId());

        // ページング
        this.seikyuList = this.paginator.getDispSeikyuData(seikyuList);

        return null;
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
        public List<SeikyuDummy> getDispSeikyuData(List<SeikyuDummy> orgList) {

            // 表示範囲
            Integer pageFrom = this.perPage * this.dispPage;
            Integer pageTo = this.perPage * this.dispPage + this.perPage;

            // 表示データ取得
            List<SeikyuDummy> seikyuList = new List<SeikyuDummy> ();
            for (Integer i = pageFrom; i < pageTo && i < orgList.size(); i ++) {
                seikyuList.add(orgList[i]);
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

            return seikyuList;
        }
    }

}