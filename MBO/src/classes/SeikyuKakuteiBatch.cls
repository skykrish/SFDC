global class SeikyuKakuteiBatch implements Database.Batchable<sObject>, Database.Stateful {

    // 定数
    /** 処理結果：Normal */
    public static String RESULT_NORMAL = 'Normal';
    /** 処理結果：Warning */
    public static String RESULT_WARNING = 'Warning';
    /** 処理結果：Error */
    public static String RESULT_ERROR = 'Error';
    /** １回の処理件数 */
    public static Integer BATCH_STEP_COUNT = 1;
    /** 検索用基本クエリ */
    private static String BASIC_QUERY = 'SELECT Id, Name, KokyakuCd__c, TorihikiKbn__c, FurikomiBankName_SMBC__c, FurikomiKozaType_SMBC__c, FurikomiKozaNo_SMBC__c, FurikomiKozaName_SMBC__c, FurikomiShitenName_SMBC__c, FurikomiBankName__c, FurikomiKozaType__c, FurikomiKozaNo__c, FurikomiKozaName__c, FurikomiShitenName__c, BillingCity, BillingState, BillingStreet, BillingPostalCode, KaisyuCycle__c, KaisyuDate__c FROM Account ';
    /** 締めグループ：15日締め */
    public static String SHIME_GROUP_15 = '15日';
    /** 締めグループ：20日締め */
    public static String SHIME_GROUP_20 = '20日';
    /** 締めグループ：25日締め */
    public static String SHIME_GROUP_25 = '25日';
    /** 締めグループ：末日締め */
    public static String SHIME_GROUP_END = '末日';
    /** 締めグループ：クレジット */
    public static String SHIME_GROUP_CREDIT = 'クレジットカード';
    /** 締めグループ：楽天 20160328追加*/
    public static String SHIME_GROUP_RAKUTEN = '楽天';
    /** 案件ステータス：受注納品済み */
    public static String ANKEN_STATUS_JUCYU_NOHINZUMI = '受注納品済み';
    /** 案件ステータス：請求確定済み */
    public static String ANKEN_STATUS_SEIKYU_KAKUTEIZUMI = '請求確定済み';
    /** 請求ヘッダ-請求ステータス：未請求 */
    public static String SH_SEIKYU_STATUS_MISEIKYU = '未請求';
    /** 請求ヘッダ-請求ステータス：請求済み */
    public static String SH_SEIKYU_STATUS_SEIKYUZUMI = '請求済み';
    /** 請求ヘッダ-入金ステータス：入金済み */
    public static String SH_NYUKIN_STATUS_NYUKINZUMI = '入金済み';
    /** 回収サイクル：翌月 */
    public static String KAISYU_CYCLE_NEXT = '翌月';
    /** 回収サイクル：翌々月 */
    public static String KAISYU_CYCLE_NEXT2 = '翌々月';
    /** 回収サイクル：翌々々月 */
    public static String KAISYU_CYCLE_NEXT3 = '翌々々月';
    /** 回収日：末日 */
    public static String KAISYU_DATE_END = '末日';
    /** 入金ステータス：新規 */
    public static String NYUKIN_STATUS_SHINKI = '新規';
    /** 入金ステータス：相殺済み */
    public static String NYUKIN_STATUS_SOUSAIZUMI = '相殺済み';
    /** デリミタ：カンマ */
    public static String DELIMITER_COMMA = ',';

    // クラス変数
    /** バッチ実行日付 */
    private BatchExecDate__c batchExecDate;
    /** ログオブジェクト */
    private BatchLog log;
    /** エラーオブジェクト */
    private List<Account> errObjList;
// add start 2015-11-30
    /** 請求ヘッダーオブジェクト作成件数 */
    private Integer cntCreateSH;
// add end 2015-11-30
 
    /**
     * コンストラクタ
     */
    global SeikyuKakuteiBatch(String shimeGroup) {

        // バッチ実行日付取得
        this.batchExecDate = [SELECT Id, Name, ShimeGroup__c, Shimebi__c FROM BatchExecDate__c WHERE ShimeGroup__c = :shimeGroup LIMIT 1];
        // ログリスト初期化
        this.log = new BatchLog();
        // エラーオブジェクト初期化
        this.errObjList = new List<Account> ();
// add start 2015-11-30
        // 請求ヘッダーオブジェクト作成件数初期化
        this.cntCreateSH = 0;
// add end 2015-11-30
    }

    /**
     * 開始処理
     */
    global Database.Querylocator start(Database.BatchableContext BC) {

        // 開始ログ
        this.log.write('=== START SeikyuKakuteiBatch ============');
        this.log.write('ShimeGroup : ' + this.batchExecDate.ShimeGroup__c);
        this.log.write('Shimebi : ' + this.batchExecDate.Shimebi__c);
        this.log.write('=========================================');
        this.log.write('');

        // クエリ作成
        String query = BASIC_QUERY;
        query += ' WHERE ShimeGroup__c = \'' + this.batchExecDate.ShimeGroup__c + '\'';

        return Database.getQueryLocator(query);
    }

    /**
     * 主処理
     * 請求確定処理
     */
    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        // 顧客（請求先 ）ごとに処理を行う
        for(Account item : (List<Account>) scope){
            try {
                // 各請求先ごとの開始ログ
                this.log.write('Execute Account : ' + item.KokyakuCd__c + ' - ' + item.Name);

                // 案件取得
                List<Anken__c> ankenList = this.getAnkenList(item.Id, this.batchExecDate.Shimebi__c);
                this.log.write('Get ' + ankenList.size() + ' Anken Records.');

                // 相殺入金取得
                List<Nyukin__c> nyukinList = this.getNyukinList(item.Id);
                this.log.write('Get ' + nyukinList.size() + ' Nyukin Records.');

                // 請求確定処理
                if (ankenList.size() > 0) {

                    // 相殺後の請求金額を取得
                    Decimal ret = this.validation(ankenList, nyukinList);
                    if (ret >= 0) {
                        // 請求ヘッダ作成
                        SeikyuHeader__c sh = this.getSeikyuHeader(item, this.batchExecDate);
                        // 相殺後の請求金額が0円の場合
                        if (ret == 0) {
                            // 請求ステータス、入金ステータスを請求済み、入金済みに設定する
                            sh.SeikyuStatus__c = SH_SEIKYU_STATUS_SEIKYUZUMI;
                            sh.NyukinStatus__c = SH_NYUKIN_STATUS_NYUKINZUMI;
                            this.log.write('Billing Zero. ');
                        }
                        insert sh;
                        this.log.write('Created SeikyuHeader Record. ');
// add start 2015-11-30
                        this.cntCreateSH += 1;
// add end 2015-11-30

                        // 請求作成
                        List<Seikyu__c> sList = this.getSeikyu(sh.Id, ankenList);
                        Map<String, Seikyu__c> osMap = this.getOffsetSeikyu(sh.Id, nyukinList);
                        insert sList;
                        insert osMap.values();
                        this.log.write('Created ' + sList.size() + ' Seikyu Records.');

                        // 請求明細作成
                        List<SeikyuMeisai__c> smList = this.getSeikyuMeisai(sList);
                        List<SeikyuMeisai__c> osmList = this.getOffsetSeikyuMeisai(nyukinList, osMap);
                        insert smList;
                        insert osmList;
                        this.log.write('Created ' + smList.size() + ' SeikyuMeisai Records.');

                        // 案件ステータス、ステータスロックの更新
                        for (Anken__c anken : ankenList) {
                            anken.Status__c = ANKEN_STATUS_SEIKYU_KAKUTEIZUMI;
                            anken.StatusLock__c = true;
                        }
                        update ankenList;
                        this.log.write('Updated Anken Status of ' + ankenList.size() + ' Anken Records.');

                        // 案件ステータスの更新
                        for (Nyukin__c nyukin : nyukinList) {
                            nyukin.Status__c = NYUKIN_STATUS_SOUSAIZUMI;
                            nyukin.Keshikomibi__c = Datetime.now();
                        }
                        update nyukinList;
                        this.log.write('Updated Nyukin Status of ' + nyukinList.size() + ' Nyukin Records.');
                    }else{
                        // Infoログ
                        this.log.write('Not Exceeded Carry Over');
                    }
                }

                // 各請求先ごとの終了ログ
                this.log.write('Done.');
                this.log.write('');

            } catch (Exception e) {
                // エラーログ
                this.log.write('Error!');
                this.log.write(e.getMessage());
                // エラーオブジェクトへ格納
                this.errObjList.add(item);

                throw e;
            }
        }
    }

    /**
     * 案件データ取得
     * 請求先送り対象を除外して取得する
     *
     * @param kokyakuId 顧客ID
     * @param shimebi 締め日
     * @return 案件のリスト
     */
    private List<Anken__c> getAnkenList(String kokyakuId, Date shimebi) {

        // 検索用締め日を生成
        Datetime searchShimebi = Datetime.newInstance(shimebi.year(), shimebi.month(), shimebi.day(), 23, 59, 59);

        // 案件データ取得
        List<Anken__c> tmpAnkenList = [SELECT
                                           Id,
                                           Name,
                                           AnkenName__c,
                                           Status__c,
                                           KokyakuTantosya_Main__r.Name,
                                           JuchuTotalKingaku_Tax__c,
                                           NohinDateTime__c,
                                           SeikyuSkipDate__c
                                       FROM
                                           Anken__c
                                       WHERE
                                           KokyakuName__c = :kokyakuId AND
                                           NohinDateTime__c <= :searchShimebi AND
                                           NohinDateTime__c != null AND
                                           Status__c = :ANKEN_STATUS_JUCYU_NOHINZUMI AND
                                           SampleKokyakuFlg__c = false];

        // 請求先送り対象案件を除外
        List<Anken__c> ankenList = new List<Anken__c> ();
        for (Anken__c item : tmpAnkenList) {
            if (item.SeikyuSkipDate__c == null || item.SeikyuSkipDate__c <= shimebi) {
                // 請求対象案件
                ankenList.add(item);
            } else {
                // 請求先送り対象案件
                this.log.write('Seikyu Skip! - AnkenNo : ' + item.Name + ' SeikyuSkipDate : ' + item.SeikyuSkipDate__c);
            }
        }

        return ankenList;
    }

    /**
     * 入金データ取得
     * 次回相殺分を取得する
     *
     * @param kokyakuId 顧客ID
     * @return 入金のリスト
     */
    private List<Nyukin__c> getNyukinList(String kokyakuId) {

        // 入金データ取得
        List<Nyukin__c> nyukinList = [SELECT
                                           Id,
                                           Name,
                                           Nyukinsaki__c,
                                           NyukingakuTotal__c
                                       FROM
                                           Nyukin__c
                                       WHERE
                                           Nyukinsaki__c = :kokyakuId AND
                                           Status__c = :NYUKIN_STATUS_SHINKI AND
                                           Offset_Flg__c = true];

        return nyukinList;
    }

    /**
     * 請求金額チュック
     *
     * @param ankenList 案件リスト
     * @param nyukinList 入金リスト
     * @return 相殺後の請求金額
     */
    private Decimal validation(List<Anken__c> ankenList, List<Nyukin__c> nyukinList) {

        // 受注金額を計算
        Decimal juchukingaku = 0;
        for(Anken__c item :ankenList){
            if(item.JuchuTotalKingaku_Tax__c != null){
                juchukingaku += item.JuchuTotalKingaku_Tax__c;
            }
        }

        // 相殺金額を計算
        Decimal sousaigaku = 0;
        for(Nyukin__c item :nyukinList){
            if(item.NyukingakuTotal__c != null){
                sousaigaku += item.NyukingakuTotal__c;
            }
        }

        // 相殺後の請求金額を返却
        return (juchukingaku - sousaigaku);
    }

    /**
     * 請求ヘッダ作成
     *
     * @param kokyaku 顧客データ
     * @param batchExecDate バッチ実行日付
     * @return 案件のリスト
     */
    private SeikyuHeader__c getSeikyuHeader(Account kokyaku, BatchExecDate__c batchExecDate) {

        // 回収予定日取得
        Date kaisyuScheduledDate = this.calcKaisyuScheduledDate(batchExecDate.Shimebi__c, kokyaku.KaisyuCycle__c, kokyaku.KaisyuDate__c);

        // 請求ヘッダ作成
        SeikyuHeader__c seikyuHeader = new SeikyuHeader__c();
        seikyuHeader.Seikyusaki__c = kokyaku.Id;
        seikyuHeader.SeikyuStatus__c = SH_SEIKYU_STATUS_MISEIKYU;
        seikyuHeader.ShimeGroup__c = batchExecDate.ShimeGroup__c;
        seikyuHeader.Shimebi__c = batchExecDate.Shimebi__c;
        seikyuHeader.KaisyuScheduledDate__c = kaisyuScheduledDate;
        seikyuHeader.SeikyusakiName__c = kokyaku.Name;
        seikyuHeader.SeikyusakiTorihikiKbn__c = kokyaku.TorihikiKbn__c;
        
        If (!String.ISBLANK(kokyaku.FurikomiBankName_SMBC__c)){
            seikyuHeader.FurikomiBankName__c = kokyaku.FurikomiBankName_SMBC__c;
            seikyuHeader.FurikomiKozaType__c = kokyaku.FurikomiKozaType_SMBC__c;
            seikyuHeader.FurikomiKozaNo__c = kokyaku.FurikomiKozaNo_SMBC__c;
            seikyuHeader.FurikomiKozaName__c = kokyaku.FurikomiKozaName_SMBC__c;
            seikyuHeader.FurikomiShitenName__c = kokyaku.FurikomiShitenName_SMBC__c;
        }else{
            seikyuHeader.FurikomiBankName__c = kokyaku.FurikomiBankName__c;
            seikyuHeader.FurikomiKozaType__c = kokyaku.FurikomiKozaType__c;
            seikyuHeader.FurikomiKozaNo__c = kokyaku.FurikomiKozaNo__c;
            seikyuHeader.FurikomiKozaName__c = kokyaku.FurikomiKozaName__c;
            seikyuHeader.FurikomiShitenName__c = kokyaku.FurikomiShitenName__c;
        }
        
        seikyuHeader.BillingCity__c = kokyaku.BillingCity;
        seikyuHeader.BillingState__c = kokyaku.BillingState;
        seikyuHeader.BillingStreet__c = kokyaku.BillingStreet;
        seikyuHeader.BillingPostalCode__c = kokyaku.BillingPostalCode;

        return seikyuHeader;
    }

    /**
     * 回収予定日計算
     *
     * @param shimebi 締め日
     * @param kaisyuCycle 回収サイクル
     * @param kaisyuDate 回収日
     * @return 回収予定日
     */
    private Date calcKaisyuScheduledDate(Date shimebi, String kaisyuCycle, String kaisyuDate) {

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
        Date tmpDate = Date.newInstance(shimebi.year(), shimebi.month(), 1);
        tmpDate = tmpDate.addMonths(addMonth);
        // 回収予定日を取得
        Integer kaisyuYear = tmpDate.year();
        Integer kaisyuMonth = tmpDate.month();
        Integer kaisyuDay = (kaisyuDate == KAISYU_DATE_END) ? Date.daysInMonth(kaisyuYear, kaisyuMonth) : Integer.valueOf(kaisyuDate.substring(0, 2));

        // 回収予定日を返却
        return Date.newInstance(kaisyuYear, kaisyuMonth, kaisyuDay);
    }

    /**
     * 請求作成
     *
     * @param shid 請求ヘッダID
     * @param ankenList 請求確定案件リスト
     * @return 請求リスト
     */
    private List<Seikyu__c> getSeikyu(String shid, List<Anken__c> ankenList) {

        // 案件リストから請求を作成
        List<Seikyu__c> sList = new List<Seikyu__c> ();
        for (Anken__c item : ankenList) {
            // 請求作成
            Seikyu__c s = new Seikyu__c();
            s.SeikyusyoNo__c = shid;
            s.DenpyoNo__c = item.Id;
            s.AnkenName__c = item.AnkenName__c;
            s.AnkenTantosya__c = item.KokyakuTantosya_Main__r.Name;
            s.UriageDateTime__c = item.NohinDateTime__c;
            sList.add(s);
        }

        return sList;
    }

    /**
     * 相殺請求作成
     *
     * @param shid 請求ヘッダID
     * @param nyukinList 入金リスト
     * @return 請求マップ
     */
    private Map<String, Seikyu__c> getOffsetSeikyu(String shid, List<Nyukin__c> nyukinList) {

        // 入金リストから請求を作成
        Map<String, Seikyu__c> osMap = new Map<String, Seikyu__c>();
        for (Nyukin__c item : nyukinList) {
            // 請求作成
            Seikyu__c s = new Seikyu__c();
            s.SeikyusyoNo__c = shid;
            s.OffsetNyukin__c = item.Id;
            s.Offset_Flg__c = true;
            osMap.put(item.Id, s);
        }

        return osMap;
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
     * @param nyukinList 入金リスト
     * @param osMap 相殺請求マップ
     * @return 相殺請求明細リスト
     */
    private List<SeikyuMeisai__c> getOffsetSeikyuMeisai(List<Nyukin__c> nyukinList, Map<String, Seikyu__c> osMap) {

        // 請求明細作成
        List<SeikyuMeisai__c> osmList = new List<SeikyuMeisai__c>();
        for (Nyukin__c item : nyukinList) {
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

        return osmList;
    }

    /**
     * 終了処理
     */
    global void finish(Database.BatchableContext BC) {

        // エラー判定
        AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, ExtendedStatus FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        if (aaj.NumberOfErrors > 0) {
            // 予期していないエラー
            // 終了ログ出力
            this.log.write('=== END SeikyuKakuteiBatch ==============');
            this.log.write('Result : ' + RESULT_ERROR);
            this.log.write('Batch Infomation : ');
            for (Account item : this.errObjList) {
                this.log.write(' - Not Created SeikyuData : ' + item.KokyakuCd__c + ' - ' +  item.Name);
            }
            this.log.write('Error Infomation : ');
            this.log.write(' - ExtendedStatus : ' + aaj.ExtendedStatus);
            this.log.write('=========================================');
            this.log.write('');

            // エラーメール送信
            this.sendMail(RESULT_ERROR, this.batchExecDate, this.log);

        } else {
            // 処理結果設定
            // 終了ログ出力
            this.log.write('=== END SeikyuKakuteiBatch ==============');
            this.log.write('Result : ' + RESULT_NORMAL);
            this.log.write('Batch Infomation : ');
            for (Account item : this.errObjList) {
                this.log.write(' - Not Created SeikyuData : ' + item.KokyakuCd__c + ' - ' + item.Name);
            }
            this.log.write('=========================================');
            this.log.write('');

            // 完了メール送信
            this.sendMail(RESULT_NORMAL, this.batchExecDate, this.log);

            // バッチ実行日付更新
            this.batchExecDate.Shimebi__c = this.getNextShimebi(this.batchExecDate);
            update this.batchExecDate;
        }
    }

    /**
     * 完了メール送信
     * @param batchStatus バッチステータス
     * @param batchExecDate バッチ実行日付
     * @param log ログオブジェクト
     */
    private void sendMail(String batchStatus, BatchExecDate__c batchExecDate, BatchLog log) {

        // 送信先、件名
        String address = System.Label.BatchMailAddress;
        String subject = '請求確定完了 [' + batchStatus + ']';
        String shimeGroup = batchExecDate.ShimeGroup__c;
        String shimebi = String.valueOf(batchExecDate.Shimebi__c).subString(0, 10);

        // メール本文
        String body = '';
        if (batchStatus == RESULT_ERROR) {
            // エラー終了時
            body += '請求確定バッチにてシステムエラーが発生しました。\r\n';
            body += '\r\n';
            body += '処理結果     ： ' + batchStatus + '\r\n';
            body += '締めグループ ： ' + shimeGroup + '\r\n';
            body += '締め日       ： ' + shimebi + '\r\n';
            body += '\r\n';
            body += 'システム管理者へ連絡してください。\r\n';
            body += 'エラーの詳細については添付のログファイルを参照してください。' + '\r\n';
            body += '\r\n';

            // 請求書作成URL生成
            body += '下記リンクより請求書作成を実施してください。' + '\r\n';
            //body += 'https://ap.salesforce.com/apex/CreateSeikyusyo?shimeGroup=' + EncodingUtil.urlEncode(shimeGroup, 'UTF-8') + '&shimebi=' + shimebi + '\r\n';
            body += URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CreateSeikyusyo?shimeGroup=' + EncodingUtil.urlEncode(shimeGroup, 'UTF-8') + '&shimebi=' + shimebi + '\r\n';
            body += '\r\n';

        } else {
            // 正常終了時
            body += '請求確定処理が完了しました。\r\n';
            body += '\r\n';
            body += '処理結果     ： ' + batchStatus + '\r\n';
            body += '締めグループ ： ' + shimeGroup + '\r\n';
            body += '締め日       ： ' + shimebi + '\r\n';
            body += '\r\n';

// mod start 2015-11-30
            // 請求書PDF作成上限件数チェック
            if (this.cntCreateSH > Integer.valueOf(System.Label.ExecuteLimitCount_SeikyuKakuteiBatchPDF) ){
                // 上限超過アラートメッセージ設定
                body += '請求書PDF作成上限件数（' + System.Label.ExecuteLimitCount_SeikyuKakuteiBatchPDF + '件）を超えています。' + '\r\n';
                body += '請求書未作成一覧画面より手動で作成してください。' + '\r\n';
                body += '\r\n';
            } else {
                // 請求書作成URL生成
                body += '下記リンクより請求書作成を実施してください。' + '\r\n';
                //body += 'https://ap.salesforce.com/apex/CreateSeikyusyo?shimeGroup=' + EncodingUtil.urlEncode(shimeGroup, 'UTF-8') + '&shimebi=' + shimebi + '\r\n';
                body += URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CreateSeikyusyo?shimeGroup=' + EncodingUtil.urlEncode(shimeGroup, 'UTF-8') + '&shimebi=' + shimebi + '\r\n';
                body += '\r\n';
            }

//            // 請求書作成URL生成
//            body += '下記リンクより請求書作成を実施してください。' + '\r\n';
//            //body += 'https://ap.salesforce.com/apex/CreateSeikyusyo?shimeGroup=' + EncodingUtil.urlEncode(shimeGroup, 'UTF-8') + '&shimebi=' + shimebi + '\r\n';
//            body += URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CreateSeikyusyo?shimeGroup=' + EncodingUtil.urlEncode(shimeGroup, 'UTF-8') + '&shimebi=' + shimebi + '\r\n';
//            body += '\r\n';
// mod end 2015-11-30

        }

        // 添付ログファイル作成
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('SeikyuKakuteiBatch_' + Datetime.now().format('yyyyMMddHHmmss') + '.log');
        efa.setBody(Blob.valueof(log.toStr()));

        // メール送信

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(address.split(DELIMITER_COMMA));
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});

    }

    /**
     * 次回締め日の取得
     * @param batchExecDate バッチ実行日付
     * @return 次回締め日
     */
    private Date getNextShimebi(BatchExecDate__c batchExecDate) {

        Date next = batchExecDate.Shimebi__c.addMonths(1);
        Integer year = next.year();
        Integer month = next.month();
        Integer day = (batchExecDate.ShimeGroup__c == SHIME_GROUP_END || batchExecDate.ShimeGroup__c == SHIME_GROUP_RAKUTEN) ? Date.daysInMonth(year, month) : next.day();

        return Date.newInstance(year, month, day);
    }

}