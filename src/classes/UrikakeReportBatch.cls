global class UrikakeReportBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	// 定数
    /** 処理結果：Normal */
    public static String RESULT_NORMAL = '正常終了';
    /** 処理結果：Warning */
    public static String RESULT_WARNING = 'Warning';
    /** 処理結果：Error */
    public static String RESULT_ERROR = 'Error';
    
	/** １回の処理件数 */
	public static Integer BATCH_STEP_COUNT = 1;
	
	/** 顧客取得用基本クエリ */
	private static String ACCOUNT_BASIC_QUERY = 'SELECT Id, Name FROM Account';

	/** 顧客取得用順序クエリ */
	private static String ACCOUNT_ORDER_QUERY = ' ORDER BY Name';

	/** 売上額取得用基本クエリ */
	private static String URIAGEGAKU_BASIC_QUERY = 'SELECT KokyakuName__c kokyaku, SUM(JuchuTotalKingaku_Tax__c) uriagegaku FROM Anken__c';

	/** 売上額取得用グループクエリ */
	private static String URIAGEGAKU_GROUP_QUERY = ' GROUP BY KokyakuName__c';

	/** 入金額取得用基本クエリ */
// mod start 2015-11-30
//	private static String NYUKINGAKU_BASIC_QUERY = 'SELECT Nyukinsaki__c nyukinsaki, SUM(NyukingakuTotal__c) nyukingaku FROM Nyukin__c';
	private static String NYUKINGAKU_BASIC_QUERY = 'SELECT Nyukinsaki__c nyukinsaki, SUM(Nyukingaku__c) nyukingaku, SUM(Sagaku__c) sagaku FROM Nyukin__c';
// mod end 2015-11-30

	/** 入金額取得用グループクエリ */
	private static String NYUKINGAKU_GROUP_QUERY = ' GROUP BY Nyukinsaki__c';
	
	/** 請求クライテリアオブジェクト */
	public SeikyuCriteria__c criteria ;
    /** JST時刻調整 */
    public static Integer AJUST_JST_TIME = -9;
	
    /** バッチ実行日付 */
    private Date batchExecDate;
    /** ログオブジェクト */
    private BatchLog log;
    /** バッチ実行ユーザのアドレス */
	private String Address;
	
	/**
	 * コンストラクタ
	 */
	global UrikakeReportBatch(SeikyuCriteria__c Item) {
		
		// バッチ実行日付初期化
		this.batchExecDate = date.today();
		// 請求クライテリア初期化
		this.criteria = Item;
		// ログリスト初期化
		this.log = new BatchLog();
		// ユーザのアドレス初期化
		this.Address = Userinfo.getUserEmail();
		
	}
	
	/**
	 * 開始処理
	 */
	global Database.Querylocator start(Database.BatchableContext BC) {
		
		// クエリ生成
		String query = ACCOUNT_BASIC_QUERY;
		query += this.getAccountConditionQuery(this.criteria);
		query += ACCOUNT_ORDER_QUERY;

		return Database.getQueryLocator(query);
	}
	
	/**
	 * 主処理
	 * 売掛レポート作成処理
	 */
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		
		try {
			// 処理対象リスト取得
			List<Account> processList = (List<Account>) scope;

			// 請求額マップを取得
			Map<Id, Decimal> uriagegakuMap = this.getUriagegakuMap(this.criteria, processList);

			// 入金取得
			Map<Id, Decimal> nyukingakuMap = this.getNyukingakuMap(this.criteria, processList);

// add start 2015-11-30
			// 差額取得
			Map<Id, Decimal> sagakuMap = this.getSagakuMap(this.criteria, processList);
// add end 2015-11-30

			// 売掛レポート作成
// mod start 2015-11-30
//			List<UrikakeReport__c> urikakeList = this.createUrikakeList(processList, uriagegakuMap, nyukingakuMap);
			List<UrikakeReport__c> urikakeList = this.createUrikakeList(processList, uriagegakuMap, nyukingakuMap, sagakuMap);
// mod end 2015-11-30

			// 売掛レポート登録
			insert urikakeList;
			
		} catch (Exception e) {
            // エラーログ
            this.log.write('Error!');
            this.log.write(e.getMessage());

            throw e;
        }
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
            this.log.write('Batch Infomation : ' + aaj.ExtendedStatus);
            this.log.write('=========================================');
            this.log.write('');

            // 完了メール送信
        	this.sendMail(RESULT_NORMAL, this.batchExecDate, this.log);
        }
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
	
	/**
	 * 売上額取得処理
	 *
	 * @param criteria 請求クライテリア
	 * @param accList 顧客リスト
	 * @return 売上額のマップ
	 */
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

	/**
	 * 売上額取得条件生成
	 *
	 * @param criteria 請求クライテリア
	 * @return 売上額取得条件
	 */
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

	/**
	 * 入金額取得処理
	 *
	 * @param criteria 請求クライテリア
	 * @param accList 顧客リスト
	 * @return 入金額のマップ
	 */
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

	/**
	 * 入金額取得条件生成
	 *
	 * @param criteria 請求クライテリア
	 * @return 入金額取得条件
	 */
	private String getNyukingakuConditionQuery(SeikyuCriteria__c criteria) {

		String ret = '';

		// 入金額取得条件：入金先
		ret += ' WHERE Nyukinsaki__c IN :accList';

		// 入金額取得条件：入金日
		Date targetDate = criteria.TargetDate__c;
		ret += ' AND NyukinDate__c <=' + targetDate.format().replace('/', '-');

		return ret;
	}
	
// add start 2015-11-30
	/**
	 * 差額取得処理
	 *
	 * @param criteria 請求クライテリア
	 * @param accList 顧客リスト
	 * @return 差額のマップ
	 */
	private Map<Id, Decimal> getSagakuMap (SeikyuCriteria__c criteria, List<Account> accList) {

		// クエリ生成
		String query = NYUKINGAKU_BASIC_QUERY;
		query += this.getNyukingakuConditionQuery(criteria);
		query += NYUKINGAKU_GROUP_QUERY;

		// 集計結果取得
		List<AggregateResult> aggregateList = database.query(query);

		// マップ作成
		Map<Id, Decimal> sagakuMap = new Map<Id, Decimal>();
		for(AggregateResult ar :aggregateList){
			String nyukinsaki = String.valueOf(ar.get('nyukinsaki'));
			String sagakuStr = String.valueOf(ar.get('sagaku'));
			Decimal sagaku = 0;
			if (sagakuStr != null){
				sagaku = Decimal.valueOf(sagakuStr);
			}
			sagakuMap.put(nyukinsaki, sagaku);
		}

		return sagakuMap;
	}
// add end 2015-11-30
	
    /**
     * 売掛リポートリスト作成
     *
     * @param accList 顧客リスト
     * @param uriagegakuMap 売上額マップ
     * @param nyukingakuMap 入金額マップ
     * @param sagakuMap 差額マップ
     * @return 売掛リポートのリスト
     */
// mod start 2015-11-30
//    private List<UrikakeReport__c> createUrikakeList(List<Account> accList, Map<Id, Decimal> uriagegakuMap, Map<Id, Decimal> nyukingakuMap){
    private List<UrikakeReport__c> createUrikakeList(List<Account> accList, Map<Id, Decimal> uriagegakuMap, Map<Id, Decimal> nyukingakuMap, Map<Id, Decimal> sagakuMap){
// mod end 2015-11-30

        List<UrikakeReport__c> urikakeList = new List<UrikakeReport__c>();

        for(Account acc : accList){
            UrikakeReport__c urikake = new UrikakeReport__c();
            urikake.Name = acc.Name;
            urikake.Uriagegaku__c = 0;
            urikake.Nyukingaku__c = 0;
// add start 2015-11-30
            urikake.Sagaku__c = 0;
// add end 2015-11-30
            if(uriagegakuMap.containsKey(acc.Id)){
                urikake.Uriagegaku__c = uriagegakuMap.get(acc.Id);
            }
            if(nyukingakuMap.containsKey(acc.Id)){
                urikake.Nyukingaku__c = nyukingakuMap.get(acc.Id);
            }
// add start 2015-11-30
            if(sagakuMap.containsKey(acc.Id)){
                urikake.Sagaku__c = sagakuMap.get(acc.Id);
            }
// add end 2015-11-30

            urikakeList.add(urikake);
        }

        return urikakeList;
    }
	
    /**
     * 完了メール送信
     * @param batchStatus バッチステータス
     * @param batchExecDate バッチ実行日付
     * @param log ログオブジェクト
     */
    private void sendMail(String batchStatus, Date batchExecDate, BatchLog log) {

        // 送信先、件名
        
        String address = this.Address;
        String subject = '売掛レポート作成完了 [' + batchStatus + ']';
        
        // 現在Loginしている環境のURL取得
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        // レポートのID取得
        String reportId = getReportId();
        // レポートのURL
        String reportURL = baseURL + '/' + reportId;

        // メール本文
        String body = '';
        if (batchStatus == RESULT_ERROR) {
            // エラー終了時
            body += '売掛レポート作成バッチにてシステムエラーが発生しました。\r\n';
            body += '\r\n';
            body += '処理結果     ： ' + batchStatus + '\r\n';
            body += '\r\n';
            body += 'システム管理者へ連絡してください。\r\n';
            body += 'エラーの詳細については添付のログファイルを参照してください。' + '\r\n';
            body += '\r\n';


        } else {
            // 正常終了時
            body += '売掛レポート作成が完了しました。\r\n';
            body += '\r\n';
            body += '処理結果     ： ' + batchStatus + '\r\n';
            body += '\r\n';

            // 売掛レポートURL生成
            body += '下記リンクより売掛レポートを確認してください' + '\r\n';
            body += reportURL + '\r\n';
            body += '\r\n';
        }

        // 添付ログファイル作成
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('UrikakeReportBatch_' + Datetime.now().format('yyyyMMddHHmmss') + '.log');
        efa.setBody(Blob.valueof(log.toStr()));

        // メール送信
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {address});
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    /**
     * 売掛リポートリスト作成
     *
     * @param accList 顧客リスト
     * @param uriagegakuMap 売上額マップ
     * @param nyukingakuMap 入金額マップ
     * @return 売掛リポートのリスト
     */
    private String getReportId(){
    	
    	List<Report> reportList = [SELECT Id FROM Report WHERE DeveloperName = 'UrikakeReport001'];
    	
    	if (reportList.size() == 0){
    		return null;
    	}else {
    		return reportList[0].Id;
    	}
    	
    }
}