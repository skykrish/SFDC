public with sharing class SeikyuKakuteiController {

    // 定数
    /** 検索用基本クエリ */
    private static String BASIC_QUERY = 'SELECT Id, Name, KokyakuName__c, KokyakuName__r.Name, KokyakuName__r.TorihikiKbn__c, KokyakuName__r.ShimeGroup__c, KokyakuName__r.KaisyuCycle__c, KokyakuName__r.KaisyuDate__c, KokyakuName__r.FurikomiBankName__c, KokyakuName__r.FurikomiShitenName__c, KokyakuName__r.FurikomiKozaType__c, KokyakuName__r.FurikomiKozaNo__c, KokyakuName__r.FurikomiKozaName__c, AnkenName__c, KokyakuTantosya_Main__r.Name, NohinDateTime__c, SeikyuSkipDate__c, JuchuTotalKingaku__c, JuchuTotalTax__c, JuchuTotalKingaku_Tax__c, Status__c, StatusLock__c FROM Anken__c ';
    /** ソート順：昇順 */
    private static String SORT_DIRECTION_ASC = 'ASC';
    /** ソート順：降順 */
    private static String SORT_DIRECTION_DESC = 'DESC';
    /** 締めグループ：15日締め */
    public static String SHIME_GROUP_15 = '15日';
    /** 締めグループ：20日締め */
    public static String SHIME_GROUP_20 = '20日';
    /** 締めグループ：25日締め */
    public static String SHIME_GROUP_25 = '25日';
    /** 締めグループ：末日締め */
    public static String SHIME_GROUP_END = '末日';
    /** 締めグループ：都度 */
    public static String SHIME_GROUP_ANY = '都度';
    /** 締めグループ：クレジットカード */
    public static String SHIME_GROUP_CREDIT = 'クレジットカード';
    /** 締めグループ：楽天 20160328追加*/
    public static String SHIME_GROUP_RAKUTEN = '楽天';
    /** 案件ステータス：受注納品済み */
    public static String ANKEN_STATUS_JUCYU_NOHINZUMI = '受注納品済み';
    /** 案件ステータス：請求確定済み */
    public static String ANKEN_STATUS_SEIKYU_KAKUTEIZUMI = '請求確定済み';
    /** 回収サイクル：翌月 */
    public static String KAISYU_CYCLE_NEXT = '翌月';
    /** 回収サイクル：翌々月 */
    public static String KAISYU_CYCLE_NEXT2 = '翌々月';
    /** 回収サイクル：翌々々月 */
    public static String KAISYU_CYCLE_NEXT3 = '翌々々月';
    /** 回収日：末日 */
    public static String KAISYU_DATE_END = '末日';
    /** 取引区分：クレジットカード */
    public static String TORIHIKI_KBN_CREDITCARD = 'クレジットカード';
    /** 請求ヘッダ-請求ステータス：未請求 */
    public static String SH_SEIKYU_STATUS_MISEIKYU = '未請求';
    /** 請求ヘッダ-請求ステータス：請求済み */
    public static String SH_SEIKYU_STATUS_SEIKYUZUMI = '請求済み';
    /** 請求ヘッダ-入金ステータス：入金済み */
    public static String SH_NYUKIN_STATUS_NYUKINZUMI = '入金済み';
    /** JST時刻調整 */
    public static Integer AJUST_JST_TIME = -9;
    /** 入金ステータス：新規 */
    public static String NYUKIN_STATUS_SHINKI = '新規';
    /** 入金ステータス：相殺済み */
    public static String NYUKIN_STATUS_SOUSAIZUMI = '相殺済み';

    /** 請求クライテリア */
    public SeikyuCriteria__c criteria {
        get;
        set;
    }

    /** 表示用案件リスト */
    public List<AnkenDummy> ankenList {
        get;
        set;
    }

    /** チェックされた表示用案件マップ */
    public Map<String, List<AnkenDummy>> checkedMap {
        get;
        set;
    }

    /** 次回相殺入金マップ */
    public Map<String, List<Nyukin__c>> offsetMap {
        get;
        set;
    }

    /** 請求確定対象顧客IDリスト */
    public List<String> kokyakuIdList {
        get;
        set;
    }

    /** ソート項順 */
    public String sortDirection {
        get;
        set;
    }

    /** ソート項目 */
    public String sortExpression {
        get;
        set;
    }

    /** 現在のソート項目 */
    private String sortExpressionNow;

    /** 請求書作成リスト */
    private List<SeikyuHeader__c> createPdfList;

    /** 請求書作成フラグ */
    public Boolean isCreatePdf {
        get;
        private set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public SeikyuKakuteiController() {

        // 請求クライテリア初期化
        this.criteria = new SeikyuCriteria__c();
        this.criteria.SeikyuDay__c = '1';

        // ソート項目のデフォルト設定
        this.sortDirection = SORT_DIRECTION_ASC;
        this.sortExpression = 'NohinDateTime__c';
        this.sortExpressionNow = this.sortExpression;

        // 請求書作成フラグ初期化
        this.isCreatePdf = false;
    }

    /**
     * 検索
     */
    public PageReference ankenSearch() {

        // 入力チェック
        if (!this.validation(this.criteria)) {
            return null;
        }

        // 検索
        this.ankenList = this.getAnkenList(this.criteria, this.sortExpression, this.sortDirection);

        return null;
    }

    /**
     * ソート
     */
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

        // 再検索
        this.ankenList = this.getAnkenList(this.criteria, this.sortExpression, this.sortDirection);

        return null;
    }

    /**
     * 入力チェック
     *
     * @param criteria 請求クライテリア
     * @return true:OK, false:NG
     */
    private Boolean validation(SeikyuCriteria__c criteria) {

        Boolean ret = true;

        // 請求年月を生成
        String seikyuYear = criteria.SeikyuYear__c;
        String seikyuMonth = criteria.SeikyuMonth__c;
        String seikyuDay = '01';
        if (criteria.ShimeGroup__c == SHIME_GROUP_ANY || criteria.ShimeGroup__c == SHIME_GROUP_CREDIT) {
            seikyuDay = criteria.SeikyuDay__c;
        }

        // 請求年月チェック
        String seikyuDate = seikyuYear + '/' + seikyuMonth + '/' + seikyuDay;
        if (!Strings.isDate(seikyuDate)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求年月の日付が正しくありません。'));
        }

        return ret;
    }

    /**
     * 案件検索処理
     *
     * @param criteria 請求クライテリア
     * @param sortExpression ソート項目
     * @param sortDeirection ソート順
     * @return 案件のリスト
     */
    private List<AnkenDummy> getAnkenList(SeikyuCriteria__c criteria, String sortExpression, String sortDeirection) {

        // 検索用クエリ生成
        String query = BASIC_QUERY;
        query += this.getConditionQuery(criteria);
        query += this.getOrderQuery(sortExpression, sortDeirection);

        // 検索
        List<Anken__c> searchResult = database.query(query);

        // 表示用データ作成
        List<AnkenDummy> ankenList = new List<AnkenDummy>();
        for (Anken__c item : searchResult) {

            //*201501 add start
            List<String> skip = new List<String>();

            // [請求先送り日]が入力されている場合
            if(item.SeikyuSkipDate__c != null){
                String skipDate1 = String.ValueOf(item.SeikyuSkipDate__c.year());
                skip.add(skipDate1);
                String skipDate2 = String.ValueOf(item.SeikyuSkipDate__c.month());
                skip.add(skipDate2);
                String skipDate3 = String.ValueOf(item.SeikyuSkipDate__c.day());
                skip.add(skipDate3);

            // [請求先送り日]が入力されていない場合
            }else{
                String skipDate1 = String.ValueOf(criteria.SeikyuYear__c);
                skip.add(skipDate1);
                String skipDate2 = String.ValueOf(criteria.SeikyuMonth__c);
                skip.add(skipDate2);
                String skipDate3 = String.ValueOf(criteria.SeikyuDay__c);
                skip.add(skipDate3);
            }
            //*201501 add end

            // 請求先送り日がNullまたは請求先送り日が今日よりも過去
            //*201501 delete if (item.SeikyuSkipDate__c == null || item.SeikyuSkipDate__c <= Date.today()){
            AnkenDummy anken = new AnkenDummy();
            anken.anken = item;

            // 回収予定日計算
            anken.kaisyuScheduledDate = this.calcKaisyuScheduledDate(
                                                skip,  //*201501 change
                                                item.KokyakuName__r.kaisyuCycle__c,
                                                item.KokyakuName__r.kaisyuDate__c
                                                );
            ankenList.add(anken);
            //*201501 delete }
        }
        return ankenList;
    }

    /**
     * 検索条件生成
     *
     * @param criteria 請求クライテリア
     * @return 検索条件
     */
    private String getConditionQuery(SeikyuCriteria__c criteria) {

        Boolean isFirst = true;
        String ret = '';

        // 検索条件：顧客名
        if (!Strings.isNullOrEmpty(criteria.Seikyusaki__c)) {
            ret += ' WHERE ';
            ret += 'KokyakuName__c = \'' + criteria.Seikyusaki__c + '\'';
            isFirst = false;
        }

        // 検索条件：取引区分
        if (!Strings.isNullOrEmpty(criteria.TorihikiKbn__c)) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'KokyakuName__r.TorihikiKbn__c = \'' + criteria.TorihikiKbn__c + '\'';
        }

        // 検索条件：締めグループ
        if (!Strings.isNullOrEmpty(criteria.ShimeGroup__c)) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'KokyakuName__r.ShimeGroup__c = \'' + criteria.ShimeGroup__c + '\'';
        }

        // 検索条件：請求年月
        Integer seikyuYear = Integer.valueOf(criteria.SeikyuYear__c);
        Integer seikyuMonth = Integer.valueOf(criteria.SeikyuMonth__c);
        Integer seikyuDay = 1;
        if (criteria.ShimeGroup__c == SHIME_GROUP_15) {
            seikyuDay = 15;
        }
        else if (criteria.ShimeGroup__c == SHIME_GROUP_20) {
            seikyuDay = 20;
        }
        else if (criteria.ShimeGroup__c == SHIME_GROUP_25) {
            seikyuDay = 25;
        }
        //20160328楽天追加
        else  if (criteria.ShimeGroup__c == SHIME_GROUP_END || criteria.ShimeGroup__c == SHIME_GROUP_RAKUTEN) {
            seikyuDay = Date.daysInMonth(seikyuYear, seikyuMonth);
        }
        else  if (criteria.ShimeGroup__c == SHIME_GROUP_ANY || criteria.ShimeGroup__c == SHIME_GROUP_CREDIT) {
            seikyuDay = Integer.valueOf(criteria.SeikyuDay__c);
        }
        Datetime seikyuDatetime = Datetime.newInstance(seikyuYear, seikyuMonth, seikyuDay, 23, 59, 59);
        seikyuDatetime = seikyuDatetime.addHours(AJUST_JST_TIME);
        if (isFirst) {
            ret += ' WHERE ';
            isFirst = false;
        } else {
            ret += ' AND ';
        }
        ret += 'NohinDateTime__c <= ' + seikyuDatetime.format('yyyy-MM-dd\'T\'HH:mm:ss.SS\'Z\'') + ' AND NohinDateTime__c != null';

        // 検索条件：ステータス
        ret += ' AND Status__c = \'' + ANKEN_STATUS_JUCYU_NOHINZUMI + '\'';

        // 検索条件：サンプルフラグ
        ret += ' AND SampleKokyakuFlg__c = false';

        return ret;
    }

    /**
     * ソート指定生成
     *
     * @param sortExpression ソート項目
     * @param sortDeirection ソート順
     * @return ソート指定
     */
    private String getOrderQuery(String sortExpression, String sortDeirection) {

        return ' ORDER BY ' + sortExpression + ' ' + sortDeirection;
    }

    /**
     * 回収予定日計算
     *
     * @param criteria 請求クライテリア
     * @param kaisyuCycle 回収サイクル
     * @param kaisyuDate 回収日
     * @return 回収予定日
     */
    //*201501 change
    private Date calcKaisyuScheduledDate(List<String> skip, String kaisyuCycle, String kaisyuDate) {
    //private Date calcKaisyuScheduledDate(SeikyuCriteria__c criteria, String kaisyuCycle, String kaisyuDate) {

        // 顧客の請求情報チェック
        if (Strings.isNullOrEmpty(kaisyuCycle) ||
            Strings.isNullOrEmpty(kaisyuDate)
        ) {
            // 設定されていなければ回収予定日はnullを設定
            return null;
        }

        // 回収予定日：計算用（月）
        Integer addMonth = 0;

        // 回収サイクルから、回収予定日：計算用（月）を加算
        if (kaisyuCycle == KAISYU_CYCLE_NEXT) {
            addMonth = 1;
        }
        else if (kaisyuCycle == KAISYU_CYCLE_NEXT2) {
            addMonth = 2;
        }
        else if (kaisyuCycle == KAISYU_CYCLE_NEXT3) {
            addMonth = 3;
        }

        // 回収予定日を計算
        //*201501 change
        //Date tmpDate = Date.newInstance(year, month, 1);
        Date tmpDate = Date.newInstance(Integer.ValueOf(skip[0]), Integer.ValueOf(skip[1]), 1);
        tmpDate = tmpDate.addMonths(addMonth);

        // 回収予定日を取得
        Integer kaisyuYear = tmpDate.year();
        Integer kaisyuMonth = tmpDate.month();
        Integer kaisyuDay = (kaisyuDate == KAISYU_DATE_END) ? Date.daysInMonth(kaisyuYear, kaisyuMonth) : Integer.valueOf(kaisyuDate.substring(0, 2));

        // 回収予定日を返却
        return Date.newInstance(kaisyuYear, kaisyuMonth, kaisyuDay);
    }

    /**
     * 請求確定
     */
    public PageReference seikyuFix() {

        // 入力チェック（FIX時）
        if (!this.fixValidation(this.ankenList)) {
            return null;
        }

        // チェックされている表示用案件マップと金額マップを作成
        this.checkedMap = new Map<String, List<AnkenDummy>>();
        Map<String, Decimal> seikyugakuMap = new Map<String, Decimal>();
        for (AnkenDummy item : this.ankenList) {
            // チェックされているかどうか
            if (item.checked) {
                // 既にMAPに存在するかどうか
                if (!this.checkedMap.containsKey(item.anken.KokyakuName__c)) {
                    // マップの初期化
                    this.checkedMap.put(item.anken.KokyakuName__c, new List<AnkenDummy>());
                    seikyugakuMap.put(item.anken.KokyakuName__c, 0);
                }

                // 表示用案件リストに追加
                this.checkedMap.get(item.anken.KokyakuName__c).add(item);

                // 請求額を加算
                if(item.anken.JuchuTotalKingaku_Tax__c != null){
                    Decimal seikyugakuTemp = seikyugakuMap.get(item.anken.KokyakuName__c);
                    seikyugakuMap.put(item.anken.KokyakuName__c, seikyugakuTemp + item.anken.JuchuTotalKingaku_Tax__c);
                }
            }
        }

        // 次回相殺入金マップと相殺額マップを作成
        List<Nyukin__c> offsetList = this.getOffsetList(this.checkedMap.keySet());
        this.offsetMap = new Map<String, List<Nyukin__c>>();
        Map<String, Decimal> sousaigakuMap = new Map<String, Decimal>();
        for (Nyukin__c item : offsetList) {
            // 既にMAPに存在するかどうか
            if (!this.offsetMap.containsKey(item.Nyukinsaki__c)) {
                // マップの初期化
                this.offsetMap.put(item.Nyukinsaki__c, new List<Nyukin__c>());
                sousaigakuMap.put(item.Nyukinsaki__c, 0);
            }

            // 表示用案件リストに追加
            this.offsetMap.get(item.Nyukinsaki__c).add(item);

            // 請求額を加算
            if(item.NyukingakuTotal__c != null){
                Decimal sousaigakuTemp = sousaigakuMap.get(item.Nyukinsaki__c);
                sousaigakuMap.put(item.Nyukinsaki__c, sousaigakuTemp + item.NyukingakuTotal__c);
            }
        }

        // 請求確定する顧客リストを作成
        this.kokyakuIdList = new List<String>();
        Set<ID> autoCompleteIdSet = new Set<ID> ();
        for(String kokyakuId :this.checkedMap.keySet()){
            // 請求額と相殺額を取得
            Decimal seikyugaku = seikyugakuMap.get(kokyakuId);
            Decimal sousaigaku = 0;
            if(sousaigakuMap.containsKey(kokyakuId)){
                sousaigaku = sousaigakuMap.get(kokyakuId);
            }

            // 請求額と相殺額の差が0以上か判定
            if(seikyugaku - sousaigaku >= 0){
                this.kokyakuIdList.add(kokyakuId);
            }

            // 請求額と相殺額の差が0となる顧客IDセットを生成
            if(seikyugaku - sousaigaku == 0){
                autoCompleteIdSet.add(kokyakuId);
            }
        }

        // 顧客リストから請求ヘッダを作成
        List<SeikyuHeader__c> shList = new List<SeikyuHeader__c> ();
        Map<String, SeikyuHeader__c> shMap = new Map<String, SeikyuHeader__c> ();
        for(String kokyakuId : this.kokyakuIdList) {
            AnkenDummy item = this.checkedMap.get(kokyakuId)[0];
            // 顧客Idから請求ヘッダを取得
            SeikyuHeader__c sh = this.getSeikyuHeader(this.criteria, item.anken.KokyakuName__c, item.kaisyuScheduledDate);
            // 請求額と相殺額の差が0となる顧客の場合
            if (autoCompleteIdSet.contains(kokyakuId)) {
                // 請求ステータス、入金ステータスを請求済み、入金済みに更新する
                sh.SeikyuStatus__c = SH_SEIKYU_STATUS_SEIKYUZUMI;
                sh.NyukinStatus__c = SH_NYUKIN_STATUS_NYUKINZUMI;
            }
            shList.add(sh);
            // 顧客Idをキーに請求ヘッダをMapに格納
            shMap.put(item.anken.KokyakuName__c, sh);
        }
        insert shList;

        // 顧客リストから請求を作成
        List<Seikyu__c> sList = new List<Seikyu__c> ();
        Map<String, Seikyu__c> osMap = new Map<String, Seikyu__c>();
        for(String kokyakuId : this.kokyakuIdList) {
            // 表示用案件リスト分ループ
            for (AnkenDummy item : this.checkedMap.get(kokyakuId)) {
                // 請求ヘッダ取得
                SeikyuHeader__c sh = shMap.get(item.anken.KokyakuName__c);
                // 請求作成
                Seikyu__c s = new Seikyu__c();
                s.SeikyusyoNo__c = sh.Id;
                s.DenpyoNo__c = item.anken.Id;
                s.AnkenName__c = item.anken.AnkenName__c;
                s.AnkenTantosya__c = item.anken.KokyakuTantosya_Main__r.Name;
                s.UriageDateTime__c = item.anken.NohinDateTime__c;
                sList.add(s);
            }

            // 次回相殺入金リスト分ループ
            if(this.offsetMap.containsKey(kokyakuId)){
                for (Nyukin__c item : this.offsetMap.get(kokyakuId)) {
                    // 請求ヘッダ取得
                    SeikyuHeader__c sh = shMap.get(item.Nyukinsaki__c);
                    // 請求作成
                    Seikyu__c s = new Seikyu__c();
                    s.SeikyusyoNo__c = sh.Id;
                    s.OffsetNyukin__c = item.Id;
                    s.Offset_Flg__c = true;
                    osMap.put(item.Id, s);
                }
            }
        }
        insert sList;
        insert osMap.values();

        // 請求リストから請求明細を作成
        List<SeikyuMeisai__c> smList = this.getSeikyuMeisai(sList);
        List<SeikyuMeisai__c> osmList = this.getOffsetSeikyuMeisai(osMap);
        insert smList;
        insert osmList;

        // 案件の案件ステータス、ステータスロック、入金のステータス更新
        List<Anken__c> updAnkenList = new List<Anken__c>();
        List<Nyukin__c> updNyukinList = new List<Nyukin__c>();
        for(String kokyakuId : this.kokyakuIdList) {
            // 表示用案件リスト分ループ
            for (AnkenDummy item : this.checkedMap.get(kokyakuId)) {
                item.anken.Status__c = ANKEN_STATUS_SEIKYU_KAKUTEIZUMI;
                item.anken.StatusLock__c = true;
                updAnkenList.add(item.anken);
            }

            // 次回相殺入金リスト分ループ
            if(this.offsetMap.containsKey(kokyakuId)){
                for (Nyukin__c item : this.offsetMap.get(kokyakuId)) {
                    item.Status__c = NYUKIN_STATUS_SOUSAIZUMI;
                    item.Keshikomibi__c = Datetime.now();
                    updNyukinList.add(item);
                }
            }
        }
        // 案件更新
        update updAnkenList;
        // 入金更新
        update updNyukinList;

        // 請求書作成リスト作成、請求書作成フラグOFF
        this.createPdfList = shList.clone();
        this.isCreatePdf = true;

        return null;
    }

    /**
     * 入力チェック（FIX時）
     */
    private Boolean fixValidation(List<AnkenDummy> ankenList) {

        Boolean ret = true;

        // 最低１件でもチェックされているか
        Integer checkNum = 0;
        for(AnkenDummy item : ankenList) {
            if (item.checked) {
                checkNum ++;
            }
        }
        if (checkNum == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求確定対象が選択されていません。'));
        }

        // 選択レコード件数が上限以上
        if (checkNum > Integer.valueOf(System.Label.ExecuteLimitCount_SeikyuKakutei)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求確定処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_SeikyuKakutei + '件です。'));
        }

        // 顧客情報チェック
        Set<String> kokyakuIdSet = new Set<String> ();
        for(AnkenDummy item : ankenList) {
            if (item.checked) {
                // チェック済みかどうかを判定
                if (!kokyakuIdSet.contains(item.anken.KokyakuName__c)) {
                    // 取引区分チェック
                    if (Strings.isNullOrEmpty(item.anken.KokyakuName__r.TorihikiKbn__c)) {
                        ret = false;
                        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '顧客名：' + item.anken.KokyakuName__r.Name + '　　取引区分が設定されていません。'));
                    }

                    // チェック済みとして格納
                    kokyakuIdSet.add(item.anken.KokyakuName__c);
                }
            }
        }

        return ret;
    }

    /**
     * 次回相殺入金取得処理
     *
     * @param kokyakuNameList 顧客リスト
     * @return 次回相殺入金リスト
     */
    private List<Nyukin__c> getOffsetList(Set<String> kokyakuNameList) {

        // 次回相殺入金取得
        List<Nyukin__c> offsetList = [SELECT Id,
                                             Name,
                                             Nyukinsaki__c,
                                             NyukingakuTotal__c
                                      FROM Nyukin__c
                                      WHERE Nyukinsaki__c IN :kokyakuNameList
                                      AND Offset_Flg__c = true
                                      AND Status__c = :NYUKIN_STATUS_SHINKI];

        return offsetList;
    }

    /**
     * 顧客ID、回収予定日から請求ヘッダを取得する
     *
     * @param criteria 請求クライテリア
     * @param kokyakuId 顧客Id
     * @param kaisyuScheduledDate 回収予定日
     * @return 請求ヘッダ
     */
    private SeikyuHeader__c getSeikyuHeader(SeikyuCriteria__c criteria, String kokyakuId, Date kaisyuScheduledDate) {

        // 締めグループ取得
        String shimeGroup = criteria.ShimeGroup__c;

        // 締め日取得
        Integer year = Integer.valueOf(criteria.SeikyuYear__c);
        Integer month = Integer.valueOf(criteria.SeikyuMonth__c);
        Integer day = 0;
        if(shimeGroup == SHIME_GROUP_15) {
            day = 15;
        }
        else if (shimeGroup == SHIME_GROUP_20) {
            day = 20;
        }
        else if (shimeGroup == SHIME_GROUP_25) {
            day = 25;
        }
        //20160328楽天追加
        else if (shimeGroup == SHIME_GROUP_END || shimeGroup == SHIME_GROUP_RAKUTEN) {
            day = Date.daysInMonth(year, month);
        }
        else if (shimeGroup == SHIME_GROUP_ANY || shimeGroup == SHIME_GROUP_CREDIT) {
            day = Integer.valueOf(criteria.SeikyuDay__c);
        }
        Date shimebi = Date.newInstance(year, month, day);

        // 顧客データ取得
        List<Account> accList = [SELECT
                                     Id,
                                     Name,
                                     FurikomiBankName__c,
                                     FurikomiKozaType__c,
                                     FurikomiKozaNo__c,
                                     FurikomiKozaName__c,
                                     FurikomiShitenName__c,
                                     
                                     FurikomiBankName_SMBC__c, //振込先銀行名(SMBC)                                
                                     FurikomiKozaType_SMBC__c, //振込先口座種類(SMBC)
                                     FurikomiKozaNo_SMBC__c, //振込先口座番号(SMBC)
                                     FurikomiKozaName_SMBC__c, //振込先口座名(SMBC)
                                     FurikomiShitenName_SMBC__c, //振込先支店名(SMBC)
                                     
                                     BillingCity,
                                     TorihikiKbn__c,
                                     BillingState,
                                     BillingStreet,
                                     BillingPostalCode
                                 FROM
                                     Account
                                 WHERE
                                     Id = :kokyakuId];
                             
         //201512_Add_start
         //SMBCがnullでない場合,振込先情報にSMBCの情報を代入
         String Bankname;
         String KozaType;
         String KozaNo;
         String KozaName;
         String ShitenName;
         
         If (!String.ISBLANK(accList[0].FurikomiBankName_SMBC__c)){
             BankName = accList[0].FurikomiBankName_SMBC__c;
             KozaType = accList[0].FurikomiKozaType_SMBC__c;
             KozaNo = accList[0].FurikomiKozaNo_SMBC__c;
             KozaName = accList[0].FurikomiKozaName_SMBC__c;
             ShitenName= accList[0].FurikomiShitenName_SMBC__c;
         }else{
             Bankname = accList[0].FurikomiBankName__c;
             KozaType = accList[0].FurikomiKozaType__c;
             KozaNo = accList[0].FurikomiKozaNo__c;
             KozaName = accList[0].FurikomiKozaName__c;
             ShitenName= accList[0].FurikomiShitenName__c;
         }
         
         //201512_Add_end

        // 請求ヘッダ作成
        SeikyuHeader__c seikyuHeader = new SeikyuHeader__c();
        seikyuHeader.Seikyusaki__c = kokyakuId;
        seikyuHeader.KaisyuScheduledDate__c = kaisyuScheduledDate;
        seikyuHeader.SeikyuStatus__c = SH_SEIKYU_STATUS_MISEIKYU;
        seikyuHeader.ShimeGroup__c = shimeGroup;
        seikyuHeader.Shimebi__c = shimebi;
        seikyuHeader.FurikomiBankName__c = BankName;
        seikyuHeader.FurikomiKozaType__c = KozaType;
        seikyuHeader.FurikomiKozaNo__c = KozaNo;
        seikyuHeader.FurikomiKozaName__c = KozaName;
        seikyuHeader.FurikomiShitenName__c = ShitenName;
        seikyuHeader.BillingCity__c = accList[0].BillingCity;
        seikyuHeader.SeikyusakiTorihikiKbn__c = accList[0].TorihikiKbn__c;
        seikyuHeader.BillingState__c = accList[0].BillingState;
        seikyuHeader.BillingStreet__c = accList[0].BillingStreet;
        seikyuHeader.SeikyusakiName__c = accList[0].Name;
        seikyuHeader.BillingPostalCode__c = accList[0].BillingPostalCode;

        return seikyuHeader;
    }



    /**
     * 請求明細作成
     *
     * @param sList 請求リスト
     * @return 請求明細リスト
     */
    private List<SeikyuMeisai__c> getSeikyuMeisai(List<Seikyu__c> sList) {

        // 案件IDリスト作成
        // 案件IDをキーに請求データをMap化
        List<String> aidList = new List<String> ();
        Map<String, Seikyu__c> sMap = new Map<String, Seikyu__c> ();
        for (Seikyu__c item : sList) {
            aidList.add(item.DenpyoNo__c);
            sMap.put(item.DenpyoNo__c, item);
        }

        // 案件明細取得
        List<AnkenMeisai__c> amList = [SELECT
                                           Id,
                                           Name,
                                           SagyoCd__c,
                                           SagyoCd__r.Name,
                                           SagyoCd__r.SagyoName__c,
                                           SagyoName__c,
                                           Suryo__c,
                                           WaribikigoTanka__c,
                                           TaxRate__c,
                                           Anken__r.Id
                                       FROM
                                           AnkenMeisai__c
                                       WHERE
                                           Anken__r.Id = :aidList];

        // 請求明細作成
        List<SeikyuMeisai__c> smList = new List<SeikyuMeisai__c>();
        for (AnkenMeisai__c item : amList) {
            // 対応する請求データを取得
            Seikyu__c seikyu = sMap.get(item.Anken__r.Id);
            // 請求明細作成
            SeikyuMeisai__c seikyuMeisai = new SeikyuMeisai__c();
            seikyuMeisai.SeikyuNo__c = seikyu.Id;
            seikyuMeisai.SagyoCd__c = item.SagyoCd__r.Name;
            seikyuMeisai.SagyoName__c = item.SagyoCd__r.SagyoName__c;
            seikyuMeisai.Suryo__c = item.Suryo__c;
            seikyuMeisai.Tanka__c = item.WaribikigoTanka__c;
            seikyuMeisai.TaxRate__c = item.TaxRate__c;
            smList.add(seikyuMeisai);
        }

        return smList;
    }

    /**
     * 相殺請求明細作成
     *
     * @param osMap 相殺請求マップ
     * @return 相殺請求明細リスト
     */
    private List<SeikyuMeisai__c> getOffsetSeikyuMeisai(Map<String, Seikyu__c> osMap) {

        // 請求明細作成
        List<SeikyuMeisai__c> osmList = new List<SeikyuMeisai__c>();
        for(String kokyakuId : this.kokyakuIdList) {
            // 次回相殺入金リスト分ループ
            if(this.offsetMap.containsKey(kokyakuId)){
                for (Nyukin__c item : this.offsetMap.get(kokyakuId)) {
                    // 対応する請求データを取得
                    Seikyu__c seikyu = osMap.get(item.Id);
                    // 請求明細作成
                    SeikyuMeisai__c seikyuMeisai = new SeikyuMeisai__c();
                    seikyuMeisai.SeikyuNo__c = seikyu.Id;
                    seikyuMeisai.Suryo__c = 1;
                    seikyuMeisai.Tanka__c = -item.NyukingakuTotal__c;
                    seikyuMeisai.TaxRate__c = 0;
                    osmList.add(seikyuMeisai);
                }
            }
        }

        return osmList;
    }

    /**
     * 請求書作成
     * 請求確定処理後に自動的に実行されます。
     * 請求確定と処理を分けている理由は下記の通り。
     * ・同一トランザクションでPDF作成を行うと
     *  請求ヘッダ、請求、請求明細の各レコードがコミットされていないため
     *  白紙の請求書PDFが作成されてしまうことを回避するため。
     */
    public PageReference createPdf() {

        Boolean isError = false;

        // 請求書作成
        try {
            List<Attachment> upsAttList = new List<Attachment> ();
            for (SeikyuHeader__c item : this.createPdfList) {
                // PDF生成
                upsAttList.add(this.getAttachmentPdf(item.Id));
            }
            upsert upsAttList;

            // 請求ヘッダ更新（請求書ID）
            for (SeikyuHeader__c item : this.createPdfList) {
                // 請求書ID設定
                for (Attachment att : upsAttList) {
                    if (item.Id == att.parentId) {
                        item.SeikyusyoId__c = att.Id;
                        break;
                    }
                }
            }
            update this.createPdfList;

        } catch(Exception e) {
            // エラーフラグを更新
            isError = true;

            // 作成された請求ヘッダ、請求、請求明細をdelete
            delete this.createPdfList;

            // 案件ステータス更新（案件ステータスを受注納品済みに戻す）
            // 入金ステータス更新（ステータスを新規に戻す）
            List<Anken__c> updAnkenList = new List<Anken__c>();
            List<Nyukin__c> updNyukinList = new List<Nyukin__c>();
            for(String kokyakuId : this.kokyakuIdList) {
                // 表示用案件リスト分ループ
                for (AnkenDummy item : this.checkedMap.get(kokyakuId)) {
                    item.anken.Status__c = ANKEN_STATUS_JUCYU_NOHINZUMI;
                    item.anken.StatusLock__c = false;
                    updAnkenList.add(item.anken);
                }

                // 次回相殺入金リスト分ループ
                if(this.offsetMap.containsKey(kokyakuId)){
                    for (Nyukin__c item : this.offsetMap.get(kokyakuId)) {
                        item.Status__c = NYUKIN_STATUS_SHINKI;
                        updNyukinList.add(item);
                    }
                }
            }
            update updAnkenList;
            update updNyukinList;

        }finally{

            // 請求書作成リスト破棄、請求書作成フラグOFF、チェックされた表示用案件マップ破棄、次回相殺入金マップ破棄、請求確定対象顧客IDリスト破棄
            this.createPdfList.clear();
            this.isCreatePdf = false;
            this.checkedMap.clear();
            this.offsetMap.clear();
            this.kokyakuIdList.clear();

            // 再検索
            this.ankenList = this.getAnkenList(this.criteria, this.sortExpression, this.sortDirection);

            if(isError){
                // エラーメッセージを表示
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書の作成に失敗しました。'));
            }else{
                // 完了メッセージを表示
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求確定処理が完了しました。'));
            }
        }

        return null;
    }

    /**
     * PDF生成
     *
     * @param shid 請求ヘッダId
     * @return Attachmentオブジェクト
     */
    private Attachment getAttachmentPdf(String shid) {

        // 請求書作成
        PageReference pdf = Page.Seikyusyo;
        pdf.getParameters().put('shid', shid);

        // 既存請求書を取得
        Attachment att = null;
        List<Attachment> attList = [SELECT Id, parentId, Name, Body FROM Attachment WHERE parentId = :shid AND Name = :System.Label.SeikyusyoName ORDER BY CreatedDate DESC];
        if (attList.size() > 0) {
            // update（既存請求書を更新）
            att = attList[0];
            att.Body = pdf.getContent();

        } else {
            // insert（新規請求書を登録）
            att = new Attachment(parentId = shid, Name = System.Label.SeikyusyoName, Body = pdf.getContent());
        }

        return att;
    }

    /**
     * 画面表示用クラス
     */
    public class AnkenDummy {

        /** 請求ヘッダデータ */
        public Anken__c anken {get; set;}

        /** 選択用チェックボックス */
        public boolean checked {get; set;}

        /** 回収予定日 */
        public Date kaisyuScheduledDate {get; set;}

        /** デフォルトコンストラクタ */
        public AnkenDummy() {
            this.checked = false;
        }
    }

}