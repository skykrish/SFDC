public with sharing class SitesContactController extends SitesAbstractController {

    // 定数
    /** メールテンプレート置換ワード：番号 */
    private static String REPLACE_KEYWORD_0 = '\\{0\\}';
    /** メールテンプレート置換ワード：名前 */
    private static String REPLACE_KEYWORD_1 = '\\{1\\}';
    /** メールテンプレート置換ワード：問い合わせ内容 */
    private static String REPLACE_KEYWORD_2 = '\\{2\\}';
    /** メールテンプレート置換ワード：会社名 */
    private static String REPLACE_KEYWORD_3 = '\\{3\\}';
    /** 問い合わせソース：オンライン発注フォーム */
    private static String CONTACT_SOURCE_ONLINE = 'オンライン問い合わせフォーム';

    /** 登録用問い合わせデータ */
    public Contact__c contact {
    	get;
    	set;
    }

    /** 電話番号１ */
    public String phone1 {
    	get;
    	set;
    }

    /** 電話番号２ */
    public String phone2 {
    	get;
    	set;
    }

    /** 電話番号３ */
    public String phone3 {
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
    public SitesContactController() {
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

    	// 登録用問い合わせデータ初期化
    	if (this.contact == null) {
    	    this.contact = new Contact__c();
    	}

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
    	if (Strings.isNullOrEmpty(this.contact.CompanyName__c)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, '会社名が入力されていません。');
    	}

    	// 名前：必須チェック
    	if (Strings.isNullOrEmpty(this.contact.ContactName__c)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, 'お名前が入力されていません。');
    	}

    	// メールアドレス：必須チェック
    	if (Strings.isNullOrEmpty(this.contact.Email__c)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, 'メールアドレスが入力されていません。');

    	} else {
            // メールアドレス：形式チェック
            if (!Strings.isEMail(this.contact.Email__c)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, 'メールアドレスの形式が正しくありません。');
            }
    	}

    	// 電話番号：必須チェック
    	if (Strings.isNullOrEmpty(this.phone1) ||
    	    Strings.isNullOrEmpty(this.phone2) ||
    	    Strings.isNullOrEmpty(this.phone3)
    	) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, 'お電話番号が入力されていません。');

    	} else {
            // 電話番号：形式チェック
            if (!Strings.isPhoneNumber(this.phone1 + this.phone2 + this.phone3)) {
    	        ret = false;
	   		    addMessage(MESSAGE_CLS_ERROR, 'お電話番号の形式が正しくありません。');
            }
    	}
    	
    	// お問い合わせ内容：必須チェック
    	if (Strings.isNullOrEmpty(this.contact.Detail__c)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, 'お問い合わせの内容が入力されていません。');
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
    	
    	// 問い合わせ登録
    	this.contact.Phone__c = this.phone1 + '-' + this.phone2 + '-' + this.phone3;
   	    this.contact.Source__c = CONTACT_SOURCE_ONLINE;
    	insert this.contact;
    	
        // メール送信
        this.sendMail(this.contact.Id);

        // 遷移
    	return getNextPage(System.Label.RedirectContact);
    }
    
    /**
     * メール送信
     *
     * @param conId 問い合わせID
     */
    private void sendMail(String conId) {

        // 問い合わせデータ再取得
        Contact__c con = [SELECT Id, Name, CompanyName__c, ContactName__c, Detail__c, Email__c FROM Contact__c WHERE Id = :conId];

        // メールテンプレート取得
        List<EmailTemplate> templateList = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = :System.Label.ContactMailTemplate AND IsActive = :true];

        // 組織のメールアドレス取得
        List<OrgWideEmailAddress> orgAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];

        // メール件名を生成（キーワード置換）
        String subject = templateList[0].Subject;
        subject = subject.replaceAll(REPLACE_KEYWORD_0, con.Name);

        // メール本文を生成（キーワード置換）
        String body = String.valueOf(templateList[0].Body);
        body = body.replaceAll(REPLACE_KEYWORD_0, con.Name);
        body = body.replaceAll(REPLACE_KEYWORD_1, con.ContactName__c);
        body = body.replaceAll(REPLACE_KEYWORD_2, con.Detail__c);
        body = body.replaceAll(REPLACE_KEYWORD_3, con.CompanyName__c);

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setOrgWideEmailAddressId(orgAddressList[0].Id);
        email.setToAddresses(new String[] {con.Email__c});
        email.setSubject(subject);
        email.setPlainTextBody(body);

        // メール送信
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }

}