public with sharing class SitesTrialController extends SitesAbstractController {

    // 定数
    /** デフォルト案件名 */
    private static String DEFAULT_ANKEN_NAME = 'トライアル';
    /** ステータス：見積受付 */
    private static String STATUS_JUCYU = '受注';
    /** 更新元：Sites */
    private static String UPDATED_BY_SITES = 'sites-trial';

    /**
     * お客様データ
     */
    public CustomerInfo customer {
        get;
        set;
    }

    /** 登録用案件データ */
    public Anken__c anken {
        get;
        set;
    }
    
    /** プライバシーポリシー、利用規約チェック */
    public Boolean isAgree {
        get;
        set;
    }

    /** ファイルサーバアドレス(グローバル) */
    public String fileServerAddressGlobal {
        get;
        private set;
    }
    
    /** ファイルサーバID */
    public String fileServerId {
        get;
        private set;
    }

    /** ファイルサーバパスワード */
    public String fileServerPw {
        get;
        private set;
    }
    
    /** ファイルサーバディレクトリ */
    public String fileServerDir {
        get;
        private set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public SitesTrialController() {
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

        // お客様データ初期化
        this.customer = new CustomerInfo();

        // ファイルサーバ接続情報設定
        this.fileServerAddressGlobal = System.Label.SitesTrialGlobalIP;         
        this.fileServerId = System.Label.SitesTrialUser;
        this.fileServerPw = System.Label.SitesTrialPassword;
        this.fileServerDir = Datetime.now().addHours(9).format('yyyyMMddHHmmss');
        
        // 登録用案件データ初期化
        if (this.anken == null) {
            this.anken = new Anken__c();
            this.anken.AnkenName__c = DEFAULT_ANKEN_NAME;
            this.anken.Status__c = STATUS_JUCYU;
            this.anken.WhoUpdated__c = UPDATED_BY_SITES;
            this.anken.FolderName__c = this.fileServerDir;
            this.anken.SampleKokyakuFlg__c = true;
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
        
        // 入力チェック
        if (!this.validate()) {
            return null;
        }
        
        // 確認モードに切り替え
        dispMode = DISP_MODE_CONFIRM;
        return null;
    }

    /**
     * 入力チェック
     * @return OK:true, NG:false
     */
    private Boolean validate() {
        
        Boolean ret = true;
        
        // 会社名：必須チェック
        if (Strings.isNullOrEmpty(this.customer.KokyakuName)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '会社名が入力されていません。');
        }

        // 会社名（全角カナ）：必須チェック
        if (Strings.isNullOrEmpty(this.customer.KokyakuNameKana)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '会社名（全角カナ）が入力されていません。');

        } else {
            // 会社名（全角カナ）：形式チェック
            if (!Strings.isWideAlphaNumKana(this.customer.KokyakuNameKana)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '会社名（全角カナ）の形式が正しくありません。');
            }
        }

        // 郵便番号：必須チェック
        if (Strings.isNullOrEmpty(this.customer.PostalCode1) && Strings.isNullOrEmpty(this.customer.PostalCode2)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '郵便番号が入力されていません。');

        } else {
            // 郵便番号：形式チェック
            String code = Strings.nullToBlank(this.customer.PostalCode1) + Strings.nullToBlank(this.customer.PostalCode2);
            if (!Strings.isPostalCode(code)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '郵便番号の形式が正しくありません。');
            }
        }
        
        // 住所：必須チェック
        if (Strings.isNullOrEmpty(this.customer.State) &&
            Strings.isNullOrEmpty(this.customer.City) &&
            Strings.isNullOrEmpty(this.customer.Street1) &&
            Strings.isNullOrEmpty(this.customer.Street2)
        ) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '住所が入力されていません。');
        }
        
        // 電話番号：必須チェック
        if (Strings.isNullOrEmpty(this.customer.Phone1) ||
            Strings.isNullOrEmpty(this.customer.Phone2) ||
            Strings.isNullOrEmpty(this.customer.Phone3)
        ) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, 'お電話番号が入力されていません。');

        } else {
            // 電話番号：形式チェック
            String code = this.customer.Phone1 + this.customer.Phone2 + this.customer.Phone3;
            if (!Strings.isPhoneNumber(code)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, 'お電話番号の形式が正しくありません。');
            }
        }
        
        // メールアドレス：必須チェック
        if (Strings.isNullOrEmpty(this.customer.Email)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, 'ご担当者様のメールアドレスが入力されていません。');

        } else {
            // 担当者／メールアドレス：形式チェック
            if (!Strings.isEMail(this.customer.Email)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, 'メールアドレスの形式が正しくありません。');
            }
        }

        // 担当者名：必須チェック
        if (Strings.isNullOrEmpty(this.customer.TantosyaName)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, 'ご担当者様が入力されていません。');
        }

        // PC環境：必須チェック
        if (Strings.isNullOrEmpty(this.customer.Pc)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, 'PC環境が選択されていません。');
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
        
        // 顧客データ登録
        Account kokyaku = this.customer.getKokyakuData();
        insert kokyaku;

        // 担当者データ登録
        Contact tantosya = this.customer.getTantosyaData(kokyaku.Id);
        insert tantosya;
        
        // 案件データ登録
        this.anken.KokyakuName__c = kokyaku.Id;
        this.anken.KokyakuTantosya_Main__c = tantosya.Id;

        /** 20180410 add start */
        // 顧客情報を取得
        Account accountInfo = new Account();
        accountInfo = this.getAccountInfo(kokyaku.Id);
        // 受注日時にシステム日付を設定
        this.anken.JuchuDateTime__c = datetime.now();
        this.anken.ColorMode__c = accountInfo.ColorMode__c;
        this.anken.ClippingPath__c = accountInfo.ClippingPath__c;
        this.anken.ClippingPathName__c = accountInfo.ClippingPathName__c;
        this.anken.FileFormat__c = accountInfo.FileFormat__c;
        this.anken.Resolution__c = accountInfo.Resolution__c;
        this.anken.Nihondeno_nouhin__c = accountInfo.Nihondeno_nouhin__c;
        this.anken.Background__c = accountInfo.Background__c;
        this.anken.Flatness__c = accountInfo.Flatness__c;
        this.anken.Margin__c = accountInfo.Margin__c;
        /** add end */

        insert this.anken;
        
        // メール送信
        this.sendMail(this.anken.Id, tantosya.Id);
        
        // 遷移
        return getNextPage(System.Label.RedirectTrial);
    }

    /**
     * 20180411 追加
     * 顧客情報を取得
     *
     */
    private Account getAccountInfo(String accountId){

        Account accountInfo = new Account();
        accountInfo = [SELECT
                        Id,
                        ColorMode__c,
                        ClippingPath__c,
                        ClippingPathName__c,
                        FileFormat__c,
                        Resolution__c,
                        Nihondeno_nouhin__c,
                        Background__c,
                        Flatness__c,
                        Margin__c
                        FROM
                        Account
                        WHERE
                        Id = :accountId
                        ];

        return accountInfo;
    }

    /**
     * メール送信
     *
     * @param ankenId 案件ID
     * @param tantosyaId 担当者ID
     */
    private void sendMail(String ankenId, String tantosyaId) {

        // メールテンプレート取得
        List<EmailTemplate> templateList = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = :System.Label.TrialMailTemplate AND IsActive = :true];

        // 組織のメールアドレス取得
        List<OrgWideEmailAddress> orgAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateList[0].Id);
        email.setOrgWideEmailAddressId(orgAddressList[0].Id);
        email.setTargetObjectId(tantosyaId);
        email.setWhatId(ankenId);
        email.setSaveAsActivity(true);

        // メール送信
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }

    /**
     * お客様情報クラス
     */
    public class CustomerInfo {
        
        /** 会社名 */
        public String KokyakuName {get; set;}
        /** 会社名（全角カナ） */
        public String KokyakuNameKana {get; set;}
        /** 郵便番号１ */
        public String PostalCode1 {get; set;}
        /** 郵便番号２ */
        public String PostalCode2 {get; set;}
        /** 都道府県 */
        public String State {get; set;}
        /** 市区郡 */
        public String City {get; set;}
        /** 町名・番地・ビル名など１ */
        public String Street1 {get; set;}
        /** 町名・番地・ビル名など２ */
        public String Street2 {get; set;}
        /** 電話番号１ */
        public String Phone1 {get; set;}
        /** 電話番号２ */
        public String Phone2 {get; set;}
        /** 電話番号３ */
        public String Phone3 {get; set;}
        /** メールアドレス */
        public String Email {get; set;}
        /** 担当者名 */
        public String TantosyaName {get; set;}
        /** PC環境 */
        public String Pc {get; set;}

        /** デフォルトコンストラクタ */
        public CustomerInfo() {
        }

        /** 顧客データ取得 */
        public Account getKokyakuData() {

            Account kokyaku = new Account();    
            kokyaku.Name = this.KokyakuName;
            kokyaku.KokyakuNameKana__c = this.KokyakuNameKana;
            kokyaku.BillingPostalCode = this.PostalCode1 + '-' + this.PostalCode2;
            kokyaku.BillingState = this.State;
            kokyaku.BillingCity = this.City;
            kokyaku.BillingStreet = this.Street1 + this.Street2;
            kokyaku.Phone = this.Phone1 + '-' + this.Phone2 + '-' + this.Phone3;
            kokyaku.SampleKokyakuFlg__c = true;
            kokyaku.Pc__c = this.Pc;
            kokyaku.GlobalIP__c = System.Label.SitesTrialGlobalIP;
            kokyaku.LocalIP__c = System.Label.SitesTrialLocalIP;            
            kokyaku.KokyakuId__c = System.Label.SitesTrialUser;
            kokyaku.KokyakuPw__c = System.Label.SitesTrialPassword;

            return kokyaku;
        }

        /** 担当者データ取得 */
        public Contact getTantosyaData(String kokyakuId) {

            Contact tantosya = new Contact (AccountId=kokyakuId);
            tantosya.LastName = this.TantosyaName;
            tantosya.Email = this.Email;
            tantosya.SeikyuTantoFlg__c = true;
            
            return tantosya;
        }
    }
}