global class UrikakeReportDeleteBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    // 定数
    /** 処理結果：Normal */
    public static String RESULT_NORMAL = '正常終了';
    /** 処理結果：Warning */
    public static String RESULT_WARNING = 'Warning';
    /** 処理結果：Error */
    public static String RESULT_ERROR = 'Error';
    
	/** １回の処理件数 */
	public static Integer BATCH_STEP_COUNT = 200;
    
    /** 売掛レポート取得用基本クエリ */
    private static String URIKAKE_BASIC_QUERY = 'SELECT Id FROM UrikakeReport__c';
    
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
    global UrikakeReportDeleteBatch(SeikyuCriteria__c Item) {
        
		// 請求クライテリア初期化
		this.criteria = Item;
        // バッチ実行日付初期化
        this.batchExecDate = date.today();
        // ログリスト初期化
        this.log = new BatchLog();
        // ユーザのアドレス初期化
        this.Address = Userinfo.getUserEmail();
    }
    
    /**
     * 開始処理
     */
    global Database.Querylocator start(Database.BatchableContext BC) {
        
        
        // クエリ作成
        String query = URIKAKE_BASIC_QUERY;
        String userId = Userinfo.getUserId();
        query += ' WHERE OwnerId = \'' + userId + '\'';
        
        // クエリ実行
        return Database.getQueryLocator(query);
    }
    /**
     * 主処理
     * 売掛レポート削除処理
     */
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        
        try {
            // 処理対象リスト作成
            List<UrikakeReport__c> deleteList = (List<UrikakeReport__c>) scope;
            
            delete deleteList;
        
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
            this.log.write('=== END SeikyuKakuteiDeleteBatch ==============');
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
            this.log.write('=== END SeikyuKakuteiDeleteBatch ==============');
            this.log.write('Result : ' + RESULT_NORMAL);
            this.log.write('Batch Infomation : ' + aaj.ExtendedStatus);
            this.log.write('=========================================');
            this.log.write('');

            // 完了メール送信
            this.sendMail(RESULT_NORMAL, this.batchExecDate, this.log);
            
            // 売掛レポートバッチ起動
            UrikakeReportBatch batch = new UrikakeReportBatch(this.criteria);
            Database.executebatch(batch, UrikakeReportBatch.BATCH_STEP_COUNT);
            
        }
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
        String subject = '売掛レポート削除完了 [' + batchStatus + ']';

        // メール本文
        String body = '';
        if (batchStatus == RESULT_ERROR) {
            // エラー終了時
            body += '売掛レポート削除バッチにてシステムエラーが発生しました。\r\n';
            body += '\r\n';
            body += '処理結果     ： ' + batchStatus + '\r\n';
            body += '\r\n';
            body += 'システム管理者へ連絡してください。\r\n';
            body += 'エラーの詳細については添付のログファイルを参照してください。' + '\r\n';
            body += '\r\n';

        } else {
            // 正常終了時
            body += '前回の売掛レポート削除が完了しました。\r\n';
            body += '新規売掛レポート作成処理を開始します。\r\n';
            body += '\r\n';
            body += '処理結果     ： ' + batchStatus + '\r\n';
            body += '\r\n';
        }

        // 添付ログファイル作成
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('UrikakeReportDeleteBatch_' + Datetime.now().format('yyyyMMddHHmmss') + '.log');
        efa.setBody(Blob.valueof(log.toStr()));

        // メール送信
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {address});
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
}