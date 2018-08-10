public with sharing class UrikakeReportController {
    
    
    /** START ランド 削除 2014/11/19 */
    /** 表示用売掛レポートリスト */
    /*
    public List<UrikakeReport__c> dispList {
           get;
           set;
    }
     */

    /** 売上額合計 */
    /*
    public Decimal totalUriagegaku {
           get;
           set;
    }
     */

    /** 入金額合計 */
    /*
    public Decimal totalNyukingaku {
           get;
           set;
    }
     */

    /** 売掛金残高合計 */
    /*
    public Decimal totalUrikakekin {
           get;
           set;
    }
     */
    /** END ランド 削除 2014/11/19 */

    /** 請求クライテリア */
    public SeikyuCriteria__c criteria {
        get;
        set;
    }

    /** START ランド 削除 2014/11/19 */
    /** ソート項順 */
    /*
    public String sortDirection {
           get;
           set;
    }
     */

    /** ソート項目 */
    /*
    public String sortExpression {
           get;
           set;
    }
     */

    /** 表示ページ */
    /*
    public Integer dispPage {
           get;
           set;
    }
     */

    /** 最終ページ */
    /*
    public Integer lastPage {
           get;
           private set;
    }
     */

    /** リジューム制御 */
    /*
    public Resume resume {
           get;
           set;
    }
     */

    /** 現在のソート項目 */
    /*
    private String sortExpressionNow;
     */

    /** １回あたりの処理件数 */
    /*
    private Integer processCount;
     */

    /** 売掛レポート取得用基本クエリ */
    /*
    private static String BASIC_QUERY = 'SELECT Name, Uriagegaku__c, Nyukingaku__c, Urikakekin__c FROM UrikakeReport__c';
     */

    /** 顧客取得用基本クエリ */
    
    private static String ACCOUNT_BASIC_QUERY = 'SELECT Id, Name FROM Account';
    

    /** 顧客取得用順序クエリ */
    private static String ACCOUNT_ORDER_QUERY = ' ORDER BY Name';
    

    /** 売上額取得用基本クエリ */
    /*
    private static String URIAGEGAKU_BASIC_QUERY = 'SELECT KokyakuName__c kokyaku, SUM(JuchuTotalKingaku_Tax__c) uriagegaku FROM Anken__c';
     */

    /** 売上額取得用グループクエリ */
    /*
    private static String URIAGEGAKU_GROUP_QUERY = ' GROUP BY KokyakuName__c';
     */

    /** 入金額取得用基本クエリ */
    /*
    private static String NYUKINGAKU_BASIC_QUERY = 'SELECT Nyukinsaki__c nyukinsaki, SUM(NyukingakuTotal__c) nyukingaku FROM Nyukin__c';
     */

    /** 入金額取得用グループクエリ */
    /*
    private static String NYUKINGAKU_GROUP_QUERY = ' GROUP BY Nyukinsaki__c';
     */

    /** ソート順：昇順 */
    /**
    private static String SORT_DIRECTION_ASC = 'ASC';
     */

    /** ソート順：降順 */
    /*
    private static String SORT_DIRECTION_DESC = 'DESC';
     */

    /** １ページの表示請求ヘッダ数 */
    /*
    private static integer MAX_LINE = 100;
     */

    /** JST時刻調整 */
    /*
    public static Integer AJUST_JST_TIME = -9;
     */
    /** END ランド 削除 2014/11/19 */
    
    /** SELECTの上限 */
    private static String SELECT_LIMIT = ' LIMIT 49001';
    

    /**
     * デフォルトコンストラクタ
     */
    public UrikakeReportController() {

        // 請求クライテリア初期化
        this.criteria = new SeikyuCriteria__c();

    /** START ランド 削除 2014/11/19 */
        /** ソート項目のデフォルト設定 */
    /*
        this.sortDirection = SORT_DIRECTION_ASC;
        this.sortExpression = 'Name';
        this.sortExpressionNow = this.sortExpression;
     */

        /** 表示ページの初期化 */
    /*
        this.dispPage = 1;
     */

        /** 合計金額の初期化 */
    /*
        this.totalUriagegaku = 0;
        this.totalNyukingaku = 0;
        this.totalUrikakekin = 0;
     */

        /** １回あたりの処理件数 */
    /*
        this.processCount = Integer.valueOf(System.Label.ExecuteCount_UrikakeReport);
     */
    /** END ランド 削除 2014/11/19 */
    }

    /**
     * 実行
     */
    /** START ランド 削除 2014/11/19 */
    /*
    public PageReference execute() {

        // 表示ページの初期化
        this.dispPage = 1;

        // 合計金額の初期化
        this.totalUriagegaku = 0;
        this.totalNyukingaku = 0;
        this.totalUrikakekin = 0;

        // 入力チェック
        if (!this.validation(this.criteria)) {
            return null;
        }

        // 売掛レポート削除（前回実行結果のクリア）
        this.deleteUrikakeReport();

        // 取引先を取得
        List<Account> accList = this.getAccountList(this.criteria);

        // リジューム処理設定
        this.resume = new Resume();
        this.resume.records = accList;
        this.resume.totalCnt = accList.size();
        this.resume.processCnt = this.processCount;
        this.resume.isStart = true;
        this.resume.hasNext = true;

        return null;
    }
     */
    /** END ランド 削除 2014/11/19 */
    
    /** START ランド 追加 2014/11/19 */
    // バッチで実行
    public PageReference execute(){
        
        // 入力チェック
        if (!this.validation(this.criteria)) {
            return null;
        }
        
        // 処理件数チェック
        if (!this.transactions(this.criteria)){
        	return null;
        }
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'レポートを作成しています。完了したらメールで通知いたします。'));
        
        // 売掛レポート削除バッチ起動
        UrikakeReportDeleteBatch batch = new UrikakeReportDeleteBatch(this.criteria);
        Database.executebatch(batch, UrikakeReportBatch.BATCH_STEP_COUNT);

        return null;
        
    }
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * リジューム処理
     */
    /*
    public PageReference resumeProcess() {

        // 処理対象リスト取得
        List<Account> processList = (List<Account>) this.resume.next();

        // 請求額マップを取得
        Map<Id, Decimal> uriagegakuMap = this.getUriagegakuMap(this.criteria, processList);

        // 入金取得
        Map<Id, Decimal> nyukingakuMap = this.getNyukingakuMap(this.criteria, processList);

        // 売掛レポート作成
        List<UrikakeReport__c> urikakeList = this.createUrikakeList(processList, uriagegakuMap, nyukingakuMap);

        // 売掛レポート登録
        insert urikakeList;

        return null;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * リジューム終了処理
     */
    /*
    public PageReference resumeFinish() {

        // 売掛レポート再取得
        List<UrikakeReport__c> urikakeList = this.getUrikakeReportList(this.criteria, this.sortExpression, this.sortDirection);

        // 最終ページ設定
        this.lastPage = urikakeList.size() / MAX_LINE + 1;
        if(Math.mod(urikakeList.size(), MAX_LINE) == 0){
            this.lastPage = urikakeList.size() / MAX_LINE;
        }else{
            this.lastPage = urikakeList.size() / MAX_LINE + 1;
        }

        // 表示用売掛レポートリスト作成
        this.dispList = this.createDispList(urikakeList, this.dispPage);

        // リジューム処理終了
        this.resume.isStart = false;

        return null;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * ソート
     */
    /*
    public PageReference sortData() {

        // 指定されたソート項目をチェック
        if (this.sortExpression == this.sortExpressionNow) {
            // 現在のソート項目と一致すれば、ソート順を入れ替える
            this.sortDirection = (this.sortDirection == SORT_DIRECTION_ASC) ? SORT_DIRECTION_DESC : SORT_DIRECTION_ASC;
        } else {
            // 一致しなければ、指定されたソート項目を昇順で設定
            this.sortDirection = SORT_DIRECTION_ASC;
            this.sortExpressionNow = this.sortExpression;
        }

        // 表示ページの初期化
        this.dispPage = 1;

        // 再取得
        List<UrikakeReport__c> urikakeList = this.getUrikakeReportList(this.criteria, this.sortExpression, this.sortDirection);

        // 表示用売掛レポートリスト作成
        this.dispList = this.createDispList(urikakeList, this.dispPage);

        return null;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * ページング
     */
    /*
    public PageReference paging() {

        // 取得
        List<UrikakeReport__c> urikakeList = this.getUrikakeReportList(this.criteria, this.sortExpression, this.sortDirection);

        // 表示用売掛レポートリスト作成
        this.dispList = this.createDispList(urikakeList, this.dispPage);

        return null;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /**
     * 入力チェック
     *
     * @param criteria 請求クライテリア
     * @return true:OK, false:NG
     */
    private Boolean validation(SeikyuCriteria__c criteria) {

        Boolean ret = true;

        if (criteria.TargetDate__c == null) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '日付が入力されていません。'));
            ret = false;
        }

        return ret;
    }

    /** START ランド 追加 2014/11/20 */
    /**
     * 処理件数チェック
     *
     * @param criteria 請求クライテリア
     * @return true:OK, false:NG
     */
    private Boolean transactions(SeikyuCriteria__c criteria) {

        Boolean ret = true;
        
        List<Account> AccountList = this.getAccountList(criteria);

        if (AccountList.size() >= 49000) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '実行可能な件数を超えています。実行対象を絞って実行してください。'));
            ret = false;
        } else if  (AccountList.size() <= 0) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '実行対象がありません。'));
            ret = false;
        }

        return ret;
    }
    /** END ランド 追加 2014/11/20 */
    
    /**
     * 顧客取得処理
     *
     * @param criteria 請求クライテリア
     * @return 顧客のリスト
     */
    private List<Account> getAccountList (SeikyuCriteria__c criteria) {

        // クエリ生成
        String query = ACCOUNT_BASIC_QUERY;
        query += this.getAccountConditionQuery(criteria);
        query += ACCOUNT_ORDER_QUERY;
        query += SELECT_LIMIT;

        // 顧客取得
        List<Account> accList = database.query(query);

        return accList;
    }

    /**
     * 顧客取得条件生成
     *
     * @param criteria 請求クライテリア
     * @return 顧客取得条件
     */
    private String getAccountConditionQuery(SeikyuCriteria__c criteria) {

        Boolean isFirst = true;
        String ret = '';

        // 顧客取得条件：顧客
        if (!Strings.isNullOrEmpty(criteria.Seikyusaki__c)) {
            ret += ' WHERE ';
            ret += 'Id = \'' + criteria.Seikyusaki__c + '\'';
            isFirst = false;
        }

        // 顧客取得条件：顧客コード
        if (!Strings.isNullOrEmpty(criteria.KokyakuCd__c)) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'KokyakuCd__c = \'' + criteria.KokyakuCd__c + '\'';
        }

        // 顧客取得条件：サンプル顧客フラグ
        if (criteria.ExcludeSampleFlg__c) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'SampleKokyakuFlg__c = false';
        }

        return ret;
    }

    /** START ランド 削除 2014/11/19 */
    /**
     * 売上額取得処理
     *
     * @param criteria 請求クライテリア
     * @param accList 顧客リスト
     * @return 売上額のマップ
     */
    /*
    private Map<Id, Decimal> getUriagegakuMap (SeikyuCriteria__c criteria, List<Account> accList) {

        // クエリ生成
        String query = URIAGEGAKU_BASIC_QUERY;
        query += this.getUriagegakuConditionQuery(criteria);
        query += URIAGEGAKU_GROUP_QUERY;

        // 集計結果取得
        List<AggregateResult> aggregateList = database.query(query);

        // マップ作成
        Map<Id, Decimal> uriagegakuMap = new Map<Id, Decimal>();
        for(AggregateResult ar :aggregateList){
            String kokyaku = String.valueOf(ar.get('kokyaku'));
            String uriagegakuStr = String.valueOf(ar.get('uriagegaku'));
            Decimal uriagegaku = Decimal.valueOf(uriagegakuStr);
            uriagegakuMap.put(kokyaku, uriagegaku);
        }

        return uriagegakuMap;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * 売上額取得条件生成
     *
     * @param criteria 請求クライテリア
     * @return 売上額取得条件
     */
    /*
    private String getUriagegakuConditionQuery(SeikyuCriteria__c criteria) {

        String ret = '';

        // 売上額取得条件：顧客名
        ret += ' WHERE KokyakuName__c IN :accList';

        // 売上額取得条件：納品日時
        Date targetDate = criteria.TargetDate__c;
        Datetime nohinDateTime = Datetime.newInstance(targetDate.year(), targetDate.month(), targetDate.day(), 23, 59, 59);
        nohinDateTime = nohinDateTime.addHours(AJUST_JST_TIME);

        ret += ' AND NohinDateTime__c <=' + nohinDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss.SS\'Z\'');

        // 売上額取得条件：ステータス
        ret += ' AND (Status__c = \'受注納品済み\' OR Status__c = \'請求確定済み\')';

        // 売上額取得条件：サンプル案件
        ret += ' AND SampleKokyakuFlg__c = false';

        return ret;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * 入金額取得処理
     *
     * @param criteria 請求クライテリア
     * @param accList 顧客リスト
     * @return 入金額のマップ
     */
    /*
    private Map<Id, Decimal> getNyukingakuMap (SeikyuCriteria__c criteria, List<Account> accList) {

        // クエリ生成
        String query = NYUKINGAKU_BASIC_QUERY;
        query += this.getNyukingakuConditionQuery(criteria);
        query += NYUKINGAKU_GROUP_QUERY;

        // 集計結果取得
        List<AggregateResult> aggregateList = database.query(query);

        // マップ作成
        Map<Id, Decimal> nyukingakuMap = new Map<Id, Decimal>();
        for(AggregateResult ar :aggregateList){
            String nyukinsaki = String.valueOf(ar.get('nyukinsaki'));
            String nyukingakuStr = String.valueOf(ar.get('nyukingaku'));
            Decimal nyukingaku = Decimal.valueOf(nyukingakuStr);
            nyukingakuMap.put(nyukinsaki, nyukingaku);
        }

        return nyukingakuMap;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * 入金額取得条件生成
     *
     * @param criteria 請求クライテリア
     * @return 入金額取得条件
     */
    /*
    private String getNyukingakuConditionQuery(SeikyuCriteria__c criteria) {

        String ret = '';

        // 入金額取得条件：入金先
        ret += ' WHERE Nyukinsaki__c IN :accList';

        // 入金額取得条件：入金日
        Date targetDate = criteria.TargetDate__c;
        ret += ' AND NyukinDate__c <=' + targetDate.format().replace('/', '-');

        return ret;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * 既存の売掛リポートを削除
     */
    /*
    private void deleteUrikakeReport(){

        List<UrikakeReport__c> deleteList = [SELECT Id
                                             FROM UrikakeReport__c
                                             WHERE OwnerId = :Userinfo.getUserId()];

        delete deleteList;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * 売掛リポートリスト作成
     *
     * @param accList 顧客リスト
     * @param uriagegakuMap 売上額マップ
     * @param nyukingakuMap 入金額マップ
     * @return 売掛リポートのリスト
     */
    /*
    private List<UrikakeReport__c> createUrikakeList(List<Account> accList, Map<Id, Decimal> uriagegakuMap, Map<Id, Decimal> nyukingakuMap){

        List<UrikakeReport__c> urikakeList = new List<UrikakeReport__c>();

        for(Account acc : accList){
            UrikakeReport__c urikake = new UrikakeReport__c();
            urikake.Name = acc.Name;
            urikake.Uriagegaku__c = 0;
            urikake.Nyukingaku__c = 0;
            if(uriagegakuMap.containsKey(acc.Id)){
                urikake.Uriagegaku__c = uriagegakuMap.get(acc.Id);
                this.totalUriagegaku += urikake.Uriagegaku__c;
            }
            if(nyukingakuMap.containsKey(acc.Id)){
                urikake.Nyukingaku__c = nyukingakuMap.get(acc.Id);
                this.totalNyukingaku += urikake.Nyukingaku__c;
            }

            urikakeList.add(urikake);
        }

        this.totalUrikakekin = this.totalUriagegaku - this.totalNyukingaku;

        return urikakeList;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * 売掛レポート取得処理
     *
     * @param criteria 請求クライテリア
     * @param sortExpression ソート項目
     * @param sortDeirection ソート順
     * @return 売掛レポートのリスト
     */
    /*
    private List<UrikakeReport__c> getUrikakeReportList(SeikyuCriteria__c criteria, String sortExpression, String sortDeirection) {

        // クエリ生成
        String query = BASIC_QUERY;
        query += ' WHERE OwnerId = \'' + Userinfo.getUserId() + '\'';
        query += this.getOrderQuery(sortExpression, sortDeirection);

        // 売掛レポート取得
        List<UrikakeReport__c> urikakeList = database.query(query);

        return urikakeList;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * ソート指定生成
     *
     * @param sortExpression ソート項目
     * @param sortDeirection ソート順
     * @return ソート指定
     */
    /*
    private String getOrderQuery(String sortExpression, String sortDeirection) {

        return ' ORDER BY ' + sortExpression + ' ' + sortDeirection;
    }
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * 表示用売掛リポートリスト作成
     *
     * @param urikakeList 売掛リポートリスト
     * @return 表示用売掛リポートリスト
     */
    /*
    private List<UrikakeReport__c> createDispList(List<UrikakeReport__c> urikakeList, Integer dispPage){

        List<UrikakeReport__c> dispList = new List<UrikakeReport__c>();

        Integer minIndex = (dispPage - 1) * MAX_LINE;
        Integer maxIndex = dispPage * MAX_LINE - 1;
        if(maxIndex > urikakeList.size() - 1){
            maxIndex = urikakeList.size() - 1;
        }

        for(Integer i = minIndex; i <= maxIndex; i++){
            dispList.add(urikakeList[i]);
        }

        return dispList;
    }
     */
    /** END ランド 追加 2014/11/19 */

    /** START ランド 削除 2014/11/19 */
    /**
     * リジューム用クラス
     */
    /*
    public class Resume {
     */

        /** 対象レコード */
    /*
        private List<Account> records;
     */

        /** １回ごとの処理件数 */
    /*
        private Integer processCnt;
     */

        /** メッセージ */
    /*
        private List<String> msgList;
     */

        /** 処理対象件数 */
    /*
        public Integer totalCnt {get; private set;}
     */

        /** 処理件数 */
    /*
        public Integer execCnt {get; private set;}
     */

        /** 処理を開始するかどうか */
    /*
        public Boolean isStart {get; private set;}
     */

        /** 次回の処理対象があるかどうか */
    /*
        public Boolean hasNext {get; private set;}
     */

        /** 進捗率 */
    /*
        public Integer progress {
            get {
                Integer ret = 0;
                if (this.totalCnt > 0) {
                    ret = (this.execCnt * 100 / this.totalCnt);
                }
                return ret;
            }
            private set;
        }
     */

        /** デフォルトコンストラクタ */
    /*
        public Resume() {

            // 各パラメータ初期化
            this.processCnt = 0;
            this.totalCnt = 0;
            this.execCnt = 0;
            this.isStart = false;
            this.hasNext = false;
            this.msgList = new List<String>();
        }
     */

        /** 処理対象レコード取得 */
    /*
        public List<Account> next() {

            // １回ごとの処理対象レコードを取得する
            List<Account> targetList = new List<Account> ();
            for (Integer i = this.execCnt; i < this.execCnt + this.processCnt && i < this.records.size(); i ++) {
                targetList.add(this.records[i]);
            }

            // 処理件数加算
            this.execCnt += targetList.size();

            // 残レコードがあるか
            if (this.execCnt >= this.totalCnt) {
                this.hasNext = false;
            }

            return targetList;
        }
    }
     */
    /** END ランド 追加 2014/11/19 */

}