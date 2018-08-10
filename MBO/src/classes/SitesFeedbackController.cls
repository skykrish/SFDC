public with sharing class SitesFeedbackController extends SitesAbstractController {

    // 定数
    /** メールテンプレート置換ワード：番号 */
    private static String REPLACE_KEYWORD_0 = '\\{0\\}';
    /** メールテンプレート置換ワード：名前 */
    private static String REPLACE_KEYWORD_1 = '\\{1\\}';
    /** メールテンプレート置換ワード：ご意見等 */
    private static String REPLACE_KEYWORD_2 = '\\{2\\}';
    /** メールテンプレート置換ワード：会社名 */
    private static String REPLACE_KEYWORD_3 = '\\{3\\}';

    /** 会社名 */
    public String companyName {
    	get;
    	set;
    }

    /** 名前 */
    public String name {
    	get;
    	set;
    }

    /** メールアドレス */
    public String email {
    	get;
    	set;
    }

    /** ご意見等 */
    public String detail {
        get;
        set;
    }

    /** プライバシーポリシー、利用規約チェック */
    public Boolean isAgree {
    	get;
    	set;
    }
    
    /**
     * デフォルトコンストラクタ
     */
    public SitesFeedbackController() {
    }
    
    /**
     * セッションチェックを実行するかどうか
     * 実行しない
     */
    public override Boolean isExecSessionCheck() {
    	return false;
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {

    	// プライバシーポリシー、利用規約チェック初期化
    	this.isAgree = false;

    	return null;
    }

    /**
     * 確認
     */
    public PageReference confirm() {
    	
    	// メッセージクリア
    	clearMessage();
    	
    	// TODO:入力チェック
    	if (!this.validate()) {
    		return null;
    	}
    	
    	// 確認モードに切り替え
    	dispMode = DISP_MODE_CONFIRM;
		return null;
    }

    /**
     * 入力チェック
     */
    private Boolean validate() {
    	
    	Boolean ret = true;
    	
    	// 会社名：必須チェック
    	if (Strings.isNullOrEmpty(this.companyName)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, '会社名が入力されていません。');
    	}

    	// 名前：必須チェック
    	if (Strings.isNullOrEmpty(this.name)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, 'お名前が入力されていません。');
    	}

    	// メールアドレス：必須チェック
    	if (Strings.isNullOrEmpty(this.email)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, 'メールアドレスが入力されていません。');

    	} else {
            // メールアドレス：形式チェック
            if (!Strings.isEMail(this.email)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, 'メールアドレスの形式が正しくありません。');
            }
    	}

    	// ご意見：必須チェック
    	if (Strings.isNullOrEmpty(this.detail)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, 'ご意見等が入力されていません。');
    	}

    	// プライバシーポリシー、利用規約チェック
    	if (ret && !this.isAgree) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, '当サイトのプライバシーポリシーと、利用規約に同意して頂く必要があります。');
    	}

    	return ret;
    }

    /**
     * 戻る
     */
    public PageReference back() {

    	// 通常モードに切り替え
    	dispMode = DISP_MODE_NORMAL;
		return null;
    }

    /**
     * 送信
     */
    public PageReference send() {
    	
    	// メッセージクリア
    	clearMessage();
    	
        // メール送信
        this.sendMail(this.companyName, this.name, this.email, this.detail);

        // 遷移
    	return getNextPage(System.Label.RedirectFeedback);
    }

    /**
     * メール送信
     *
     * @param companyName 会社名
     * @param name 名前
     * @param mailAddress メールアドレス
     * @param detail ご意見等
     */
    private void sendMail(String companyName, String name, String mailAddress, String detail) {

        // メールテンプレート取得
        List<EmailTemplate> templateList = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = :System.Label.FeedbackMailTemplate AND IsActive = :true];

        // 組織のメールアドレス取得
        List<OrgWideEmailAddress> orgAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];
        
        // 宛先メールアドレス
        String[] toAddresses = new String[] {System.Label.FeedbackMailAddress};

        // メール件名を生成
        String subject = 'フィードバック通知';

        // メール本文を生成（キーワード置換）
        String body = String.valueOf(templateList[0].Body);
        body = body.replaceAll(REPLACE_KEYWORD_0, name);
        body = body.replaceAll(REPLACE_KEYWORD_1, mailAddress);
        body = body.replaceAll(REPLACE_KEYWORD_2, detail);
        body = body.replaceAll(REPLACE_KEYWORD_3, companyName);

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setOrgWideEmailAddressId(orgAddressList[0].Id);
        email.setToAddresses(toAddresses);
        email.setSubject(subject);
        email.setPlainTextBody(body);

        // メール送信
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}