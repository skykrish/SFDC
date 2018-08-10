public with sharing class SitesRegisterController extends SitesAbstractController {

    // 定数
    /** 取引区分：掛売上 */
    private static String TORIHIKI_KBN_KAKEURI = '掛売上';
    /** 取引区分：クレジットカード */
    private static String TORIHIKI_KBN_CREDIT = 'クレジットカード';
    /** 締めグループ：クレジットカード */
    private static String SHIME_GROUP_CREDIT = 'クレジットカード';
    /** 更新元：Sites */
    private static String UPDATED_BY_SITES = 'sites-register';

    /**
     * 登録用顧客データ
     */
    public KokyakuDummy kokyaku {
        get;
        set;
    }

    /**
     * 担当者データ
     */
    public List<TantosyaDummy> tantosyaList {
        get;
        set;
    }

    /**
     * ユーザIDチェック結果
     */
    public SitesMessage resultKokyakuIdCheck {
        get;
        private set;
    }

    /** プライバシーポリシー、利用規約チェック */
    public Boolean isAgree {
        get;
        set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public SitesRegisterController() {
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

        // 登録用顧客データ初期化
        this.kokyaku = new KokyakuDummy();
        
        // 選択リストの初期値設定
        this.kokyaku.ShimeGroup = '末日';
        this.kokyaku.KaisyuCycle = '翌月';
        this.kokyaku.KaisyuDate = '末日';

        // 登録用担当者データ初期化
        this.tantosyaList = new List<TantosyaDummy> {
            new TantosyaDummy(),
            new TantosyaDummy(),
            new TantosyaDummy(),
            new TantosyaDummy(),
            new TantosyaDummy()
        };

        return null;
    }

    /**
     * ユーザIDが利用可能かどうか
     */
    public PageReference checkKokyakuId() {

        // 入力チェック（入力されていなければ何もしない）
        if (Strings.isNullOrEmpty(this.kokyaku.kokyakuId)) {
            this.resultKokyakuIdCheck = new SitesMessage();
            return null;
        }

        // 桁数チェック
        if (this.kokyaku.kokyakuId.length() < 4) {
            this.resultKokyakuIdCheck = new SitesMessage(MESSAGE_CLS_ERROR, 'ユーザIDは４桁以上である必要があります。');
            return null;
        }

        // 形式チェック
        if (!this.isKokyakuIdFormat(this.kokyaku.kokyakuId)) {
            this.resultKokyakuIdCheck = new SitesMessage(MESSAGE_CLS_ERROR, 'ユーザIDは半角英数字、ハイフン、アンダースコアである必要があります。');
            return null;
        }

        // 使用不可チェック
        if (this.kokyaku.kokyakuId == System.Label.SitesTrialUser || this.kokyaku.kokyakuId == System.Label.SitesMitsumoriUser) {
            this.resultKokyakuIdCheck = new SitesMessage(MESSAGE_CLS_ERROR, 'そのユーザIDは使用できません。');
            return null;
        }

        // 使用済みチェック
        if (this.isExistKokyakuId(this.kokyaku.kokyakuId)) {
            this.resultKokyakuIdCheck = new SitesMessage(MESSAGE_CLS_ERROR, 'ユーザIDは既に登録されています。');
            return null;
        }

        // 全チェックOK
        this.resultKokyakuIdCheck = new SitesMessage(MESSAGE_CLS_NORMAL, '利用可能です。');
        return null;
    }

    /**
      * 文字列がユーザIDの形式かどうかを判定します。
      * @return 半角英数、アンダースコア、ハイフンの場合は true。それ以外は false。
      */
    private Boolean isKokyakuIdFormat(String value) {

        // 未入力の場合はエラー
        if (Strings.isNullOrEmpty(value)) {
            return false;
        }

        String p = '^[0-9a-zA-Z\\w\\-]+$';
        return Pattern.matches(p, value);
    }

    /**
      * 文字列がパスワードの形式かどうかを判定します。
      * @return 半角英数、アンダースコア、ハイフンの場合は true。それ以外は false。
      */
    private Boolean isKokyakuPwFormat(String value) {

        // 未入力の場合はエラー
        if (Strings.isNullOrEmpty(value)) {
            return false;
        }

        String p = '^[0-9a-zA-Z\\w\\-]+$';
        return Pattern.matches(p, value);
    }

    /**
     * ユーザIDが既に登録済みかどうかをチェックする
     *
     * @param kokyakuId ユーザID
     * @return 存在する:true, 存在しない:false
     */
    private Boolean isExistKokyakuId(String kokyakuId) {

        Boolean ret = false;

        List<Account> accList = [SELECT Id, Name FROM Account WHERE KokyakuId__c = :kokyakuId];
        if (accList.size() > 0) {
            ret = true;
        }

        return ret;
    }

    /**
     * 担当者追加
     */
    public PageReference addTantosya() {

        this.tantosyaList.add(new TantosyaDummy());
        return null;
    }

    /**
     * 確認
     */
    public PageReference confirm() {

        // メッセージクリア
        clearMessage();
        this.resultKokyakuIdCheck = new SitesMessage();

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
        if (Strings.isNullOrEmpty(this.kokyaku.KokyakuName)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  会社名が入力されていません。');
        }

        // 会社名（全角カナ）：必須チェック
        if (Strings.isNullOrEmpty(this.kokyaku.KokyakuNameKana)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  会社名（全角カナ）が入力されていません。');

        } else {
            // 会社名（全角カナ）：形式チェック
            if (!Strings.isWideAlphaNumKana(this.kokyaku.KokyakuNameKana)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  会社名（全角カナ）の形式が正しくありません。');
            }
        }

        // 郵便番号：必須チェック
        if (Strings.isNullOrEmpty(this.kokyaku.PostalCode1) && Strings.isNullOrEmpty(this.kokyaku.PostalCode2)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  郵便番号が入力されていません。');

        } else {
            // 郵便番号：形式チェック
            String code = Strings.nullToBlank(this.kokyaku.PostalCode1) + Strings.nullToBlank(this.kokyaku.PostalCode2);
            if (!Strings.isPostalCode(code)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  郵便番号の形式が正しくありません。');
            }
        }

        // 住所：必須チェック
        if (Strings.isNullOrEmpty(this.kokyaku.State) &&
            Strings.isNullOrEmpty(this.kokyaku.City) &&
            Strings.isNullOrEmpty(this.kokyaku.Street1) &&
            Strings.isNullOrEmpty(this.kokyaku.Street2)
        ) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  住所が入力されていません。');
        }

        // 電話番号：必須チェック
        if (Strings.isNullOrEmpty(this.kokyaku.Phone1) ||
            Strings.isNullOrEmpty(this.kokyaku.Phone2) ||
            Strings.isNullOrEmpty(this.kokyaku.Phone3)
        ) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  お電話番号が入力されていません。');

        } else {
            // 電話番号：形式チェック
            String code = this.kokyaku.Phone1 + this.kokyaku.Phone2 + this.kokyaku.Phone3;
            if (!Strings.isPhoneNumber(code)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  お電話番号の形式が正しくありません。');
            }
        }

        // FAX番号：形式チェック
        if (!Strings.isNullOrEmpty(this.kokyaku.Fax1) ||
            !Strings.isNullOrEmpty(this.kokyaku.Fax2) ||
            !Strings.isNullOrEmpty(this.kokyaku.Fax3)
        ) {
            String code = this.kokyaku.Fax1 + this.kokyaku.Fax2 + this.kokyaku.Fax3;
            if (!Strings.isPhoneNumber(code)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  FAX番号の形式が正しくありません。');
            }
        }

        // キャンペーンソース：必須チェック
        if (!this.kokyaku.Source01 &&
            !this.kokyaku.Source02 &&
            !this.kokyaku.Source03 &&
            !this.kokyaku.Source04 &&
            !this.kokyaku.Source05 &&
            !this.kokyaku.Source06 &&
            !this.kokyaku.Source07 &&
            !this.kokyaku.Source08 &&
            !this.kokyaku.Source09 &&
            !this.kokyaku.Source10 &&
            !this.kokyaku.Source11 &&
            !this.kokyaku.Source12 &&
            !this.kokyaku.Source13 &&
            !this.kokyaku.Source14 &&
            !this.kokyaku.Source15 &&
            !this.kokyaku.Source16 &&
            !this.kokyaku.Source17 &&
            !this.kokyaku.Source18 &&
            !this.kokyaku.Source19 &&
            !this.kokyaku.Source20
        ){
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  お知りになった媒体が選択されていません。');
        }

        //　キャンペーンソース："その他" を選択した場合の必須チェック
        if (this.kokyaku.Source20 && Strings.isNullOrEmpty(this.kokyaku.OtherDetail)){
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お客様情報]  お知りになった媒体「その他」の詳細が入力されていません。');
        }

        // ユーザID：必須チェック
        if (Strings.isNullOrEmpty(this.kokyaku.kokyakuId)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  ユーザIDが入力されていません。');

        } else {
            // ユーザID：桁数チェック
            if (this.kokyaku.kokyakuId.length() < 4) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  ユーザIDは４桁以上である必要があります。');
            }
            // ユーザID：形式チェック
            if (!this.isKokyakuIdFormat(this.kokyaku.kokyakuId)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  ユーザIDは半角英数字、ハイフン、アンダースコアである必要があります。');
            }
            // ユーザID：使用不可チェック
            if (this.kokyaku.kokyakuId == System.Label.SitesTrialUser || this.kokyaku.kokyakuId == System.Label.SitesMitsumoriUser) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  そのユーザIDは使用できません。');
            }
            // ユーザID：使用済みチェック
            if (this.isExistKokyakuId(this.kokyaku.kokyakuId)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  ユーザIDは既に登録されています。');
            }
        }
 
        // パスワード：必須チェック
        if (Strings.isNullOrEmpty(this.kokyaku.kokyakuPw)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  パスワードが入力されていません。');

        } else {
            // パスワード：桁数チェック
            if (this.kokyaku.kokyakuPw.length() < 4) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  パスワードは４桁以上である必要があります。');
            }
            // パスワード：形式チェック
            if (!this.isKokyakuPwFormat(this.kokyaku.kokyakuPw)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  パスワードは半角英数字、ハイフン、アンダースコアである必要があります。');
            }
            // パスワード：パスワード再入力チェック
            if (this.kokyaku.kokyakuPw != this.kokyaku.kokyakuPwConfirm) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  パスワードと再入力されたパスワードが一致しません。');
            }
        }

        // PC環境：必須チェック
        if (Strings.isNullOrEmpty(this.kokyaku.Pc)) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[その他のご利用情報]  PC環境が選択されていません。');
        }

        // 担当者チェック
        // 入力されている担当者レコードを取得
        List<TantosyaDummy> checkList = new List<TantosyaDummy>();
        for (TantosyaDummy item : this.tantosyaList) {
            if (item.isEntry()) {
                checkList.add(item);
            }
        }
        // 担当者：必須チェック
        if (checkList.size() == 0) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[ご担当者様情報]  ご担当者様情報が入力されていません。');

        } else {
            Integer checkNumSeikyuTantoFlg = 0;
            for (TantosyaDummy item : checkList) {
                // 担当者／名前：必須チェック
                if (Strings.isNullOrEmpty(item.TantosyaName)) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[ご担当者様情報]  ご担当者様のお名前が入力されていません。');
                }
                // 担当者／メールアドレス：必須チェック
                if (Strings.isNullOrEmpty(item.Email)) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[ご担当者様情報]  ご担当者様のメールアドレスが入力されていません。');

                } else {
                    // 担当者／メールアドレス：形式チェック
                    if (!Strings.isEMail(item.Email)) {
                        ret = false;
                        addMessage(MESSAGE_CLS_ERROR, '[ご担当者様情報]  ご担当者様のメールアドレスの形式が正しくありません。');
                    }
                }
                // 請求担当フラグのチェック数を取得
                if (item.SeikyuTantoFlg) {
                    checkNumSeikyuTantoFlg ++;
                }
            }
            // 請求担当フラグ：必須チェック
            if (checkNumSeikyuTantoFlg == 0) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '[ご担当者様情報]  ご請求先が指定されていません。');
            }
        }

        // 支払い方法：必須チェック
        if (!this.kokyaku.PaymentSeikyusyo && !this.kokyaku.PaymentCredit) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  お支払い方法が指定されていません。');

        } else {
            // 支払い方法／請求書払いチェック
            if (this.kokyaku.PaymentSeikyusyo) {
                // 締日：必須チェック
                if (Strings.isNullOrEmpty(this.kokyaku.ShimeGroup)) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  締日が指定されていません。');
                }
                // 支払いサイクル：必須チェック
                if (Strings.isNullOrEmpty(this.kokyaku.KaisyuCycle)) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  お支払いサイクルが指定されていません。');
                }
                // 支払い日：必須チェック
                if (Strings.isNullOrEmpty(this.kokyaku.KaisyuDate)) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  お支払い日が指定されていません。');
                }
            }
            // 支払い方法／クレジット払いチェック
            if (this.kokyaku.PaymentCredit) {
                // カード会社：必須チェック
                if (Strings.isNullOrEmpty(this.kokyaku.CardCompany)) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード会社が指定されていません。');
                }
                // カード番号：必須チェック
                if (Strings.isNullOrEmpty(this.kokyaku.CardNo1) ||
                    Strings.isNullOrEmpty(this.kokyaku.CardNo2) ||
                    Strings.isNullOrEmpty(this.kokyaku.CardNo3) ||
                    Strings.isNullOrEmpty(this.kokyaku.CardNo4)
                ) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード番号が入力されていません。');

                } else {
                    // カード番号：形式チェック（半角数値13～16文字でなりたっているかだけチェック）
                    if (!Strings.isCreditCardNo(this.kokyaku.CardNo1, this.kokyaku.CardNo2, this.kokyaku.CardNo3, this.kokyaku.CardNo4)) {
                        ret = false;
                        addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード番号の形式が正しくありません。');
                    }
                }
                // カード有効期限：必須チェック
                if (Strings.isNullOrEmpty(this.kokyaku.CardLimitMM) ||
                    Strings.isNullOrEmpty(this.kokyaku.CardLimitYY)) 
                {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード有効期限が入力されていません。');

                } else {
                    // カード有効期限：形式チェック
                    String code = '20' + this.kokyaku.CardLimitYY + '/' + this.kokyaku.CardLimitMM + '/' + '01';
                    if (!Strings.isDate(code)) {
                        ret = false;
                        addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード有効期限の形式が正しくありません。');
                    }
                }
                // カード名義人：必須チェック
                if (Strings.isNullOrEmpty(this.kokyaku.CardOwner)) {
                    ret = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード名義人が入力されていません。');
                }
            } 
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
        Account kokyaku = this.kokyaku.getKokyakuData();
        insert kokyaku;

        // 担当者データ登録
        List<Contact> insTantosyaList = new List<Contact>();
        for (TantosyaDummy item : this.tantosyaList) {
            if (item.isEntry()) {
                insTantosyaList.add(item.getTantosayData(kokyaku.Id));
            }
        }
        insert insTantosyaList;

        // メール送信
        this.sendMail(kokyaku, insTantosyaList);

        // 遷移
        return getNextPage(System.Label.RedirectRegister);
    }

    /**
     * メール送信
     *
     * @param kokyaku 顧客データ
     * @param tantosyaList 担当者データ
     */
    private void sendMail(Account kokyaku, List<Contact> tantosyaList) {

        // メールテンプレート取得
        List<EmailTemplate> templateList = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = :System.Label.RegisterMailTemplate AND IsActive = :true];

        // 組織のメールアドレス取得
        List<OrgWideEmailAddress> orgAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];

        // 主担当データ取得
        Contact tantosyaMain = tantosyaList[0];

        // CCメールアドレス取得
        Map<String, String> ccAddressesMap = new Map<String, String> ();
        for (Integer i = 1; i < tantosyaList.size() ; i ++) {
            if (tantosyaMain.Email != tantosyaList[i].Email) {
                if(!ccAddressesMap.containsKey(tantosyaList[i].Email)) {
                    ccAddressesMap.put(tantosyaList[i].Email, tantosyaList[i].Email);
                }
            }
        }

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateList[0].Id);
        email.setOrgWideEmailAddressId(orgAddressList[0].Id);
        email.setTargetObjectId(tantosyaMain.Id);
        email.setCcAddresses(ccAddressesMap.values());
        email.setWhatId(kokyaku.Id);
        email.setSaveAsActivity(true);

        // メール送信
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }

    /**
     * 登録用顧客クラス
     */
    public class KokyakuDummy {

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
        /** FAX番号１ */
        public String Fax1 {get; set;}
        /** FAX番号２ */
        public String Fax2 {get; set;}
        /** FAX番号３ */
        public String Fax3 {get; set;}
        /** ユーザID */
        public String KokyakuId {get; set;}
        /** パスワード */
        public String KokyakuPw {get; set;}
        /** パスワード再入力 */
        public String KokyakuPwConfirm {get; set;}
        /** PC環境 */
        public String Pc {get; set;}
        /** 支払方法：請求書払い */
        public Boolean PaymentSeikyusyo {get; set;}
        /** 支払方法：クレジット払い */
        public Boolean PaymentCredit {get; set;}
        /** 締日（締めグループ） */
        public String ShimeGroup {get; set;}
        /** 支払サイクル */
        public String KaisyuCycle {get; set;}
        /** 支払日 */
        public String KaisyuDate {get; set;}
        /** カード会社 */
        public String CardCompany {get; set;}
        /** カード番号１ */
        public String CardNo1 {get; set;}
        /** カード番号２ */
        public String CardNo2 {get; set;}
        /** カード番号３ */
        public String CardNo3 {get; set;}
        /** カード番号４ */
        public String CardNo4 {get; set;}
        /** カード有効期限（年） */
        public String CardLimitYY {get; set;}
        /** カード有効期限（月） */
        public String CardLimitMM {get; set;}
        /** カード名義人 */
        public String CardOwner {get; set;}
        /** キャンペーンソース01 */
        public Boolean Source01 {get; set;}
        /** キャンペーンソース02 */
        public Boolean Source02 {get; set;}
        /** キャンペーンソース03 */
        public Boolean Source03 {get; set;}
        /** キャンペーンソース04 */
        public Boolean Source04 {get; set;}
        /** キャンペーンソース05 */
        public Boolean Source05 {get; set;}
        /** キャンペーンソース06 */
        public Boolean Source06 {get; set;}
        /** キャンペーンソース07 */
        public Boolean Source07 {get; set;}
        /** キャンペーンソース08 */
        public Boolean Source08 {get; set;}
        /** キャンペーンソース09 */
        public Boolean Source09 {get; set;}
        /** キャンペーンソース10 */
        public Boolean Source10 {get; set;}
        /** キャンペーンソース11 */
        public Boolean Source11 {get; set;}
        /** キャンペーンソース12 */
        public Boolean Source12 {get; set;}
        /** キャンペーンソース13 */
        public Boolean Source13 {get; set;}
        /** キャンペーンソース14 */
        public Boolean Source14 {get; set;}
        /** キャンペーンソース15 */
        public Boolean Source15 {get; set;}
        /** キャンペーンソース16 */
        public Boolean Source16 {get; set;}
        /** キャンペーンソース17 */
        public Boolean Source17 {get; set;}
        /** キャンペーンソース18 */
        public Boolean Source18 {get; set;}
        /** キャンペーンソース19 */
        public Boolean Source19 {get; set;}
        /** キャンペーンソース20 */
        public Boolean Source20 {get; set;}
        /** キャンペーンソース20（詳細） */
        public String OtherDetail {get; set;}

        /** デフォルトコンストラクタ */
        public KokyakuDummy() {
            this.PaymentSeikyusyo = false;
            this.PaymentCredit = false;
            this.Source01 = false;
            this.Source02 = false;
            this.Source03 = false;
            this.Source04 = false;
            this.Source05 = false;
            this.Source06 = false;
            this.Source07 = false;
            this.Source08 = false;
            this.Source09 = false;
            this.Source10 = false;
            this.Source11 = false;
            this.Source12 = false;
            this.Source13 = false;
            this.Source14 = false;
            this.Source15 = false;
            this.Source16 = false;
            this.Source17 = false;
            this.Source18 = false;
            this.Source19 = false;
            this.Source20 = false;
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
            kokyaku.Fax = this.Fax1 + '-' + this.Fax2 + '-' + this.Fax3;
            kokyaku.KokyakuId__c = this.KokyakuId;
            kokyaku.KokyakuPw__c = this.KokyakuPw;
            kokyaku.Pc__c = this.Pc;
            // 取引区分：掛売上
            if (this.PaymentSeikyusyo) {
                kokyaku.TorihikiKbn__c = TORIHIKI_KBN_KAKEURI;
                kokyaku.ShimeGroup__c = this.ShimeGroup;
                kokyaku.KaisyuCycle__c = this.KaisyuCycle;
                kokyaku.KaisyuDate__c = this.KaisyuDate;
                // 振込口座情報をデフォルトで設定
                kokyaku.FurikomiBankName__c = System.Label.FurikomiBankName;
                kokyaku.FurikomiShitenCd__c = '---';
                kokyaku.FurikomiShitenName__c = 'ﾐｾｯﾃｲ';
                kokyaku.FurikomiKozaType__c = System.Label.FurikomiKozaType;
                kokyaku.FurikomiKozaNo__c = '-------';
                kokyaku.FurikomiKozaName__c = System.Label.FurikomiKozaName;
            }
            // 取引区分：クレジットカード
            if (this.PaymentCredit) {
                kokyaku.TorihikiKbn__c = TORIHIKI_KBN_CREDIT;
                kokyaku.CardCompany__c = this.CardCompany;
                kokyaku.CardNo__c = this.CardNo1 + this.CardNo2 + this.CardNo3 + this.CardNo4;
                kokyaku.CardLimit__c = this.CardLimitMM + '/' + this.CardLimitYY;
                kokyaku.CardOwner__c = this.CardOwner;
                kokyaku.ShimeGroup__c = SHIME_GROUP_CREDIT;
            }
            //キャンペーンソース
            kokyaku.CampaignSource01__c = this.Source01;
            kokyaku.CampaignSource02__c = this.Source02;
            kokyaku.CampaignSource03__c = this.Source03;
            kokyaku.CampaignSource04__c = this.Source04;
            kokyaku.CampaignSource05__c = this.Source05;
            kokyaku.CampaignSource06__c = this.Source06;
            kokyaku.CampaignSource07__c = this.Source07;
            kokyaku.CampaignSource08__c = this.Source08;
            kokyaku.CampaignSource09__c = this.Source09;
            kokyaku.CampaignSource10__c = this.Source10;
            kokyaku.CampaignSource11__c = this.Source11;
            kokyaku.CampaignSource12__c = this.Source12;
            kokyaku.CampaignSource13__c = this.Source13;
            kokyaku.CampaignSource14__c = this.Source14;
            kokyaku.CampaignSource15__c = this.Source15;
            kokyaku.CampaignSource16__c = this.Source16;
            kokyaku.CampaignSource17__c = this.Source17;
            kokyaku.CampaignSource18__c = this.Source18;
            kokyaku.CampaignSource19__c = this.Source19;
            kokyaku.CampaignSource20__c = this.Source20;
            kokyaku.OtherDetail__c = this.OtherDetail;
            
            //グローパルＩＰとローカルＩＰのデフォルトを設定。
            kokyaku.GlobalIP__c = System.Label.RegisterGlobalIP;
            kokyaku.LocalIP__c = System.Label.RegisterLocalIP;
            
            // 更新元：Sites
            kokyaku.WhoUpdated__c = UPDATED_BY_SITES;

            return kokyaku;
        }
    }

    /**
     * 登録用担当者クラス
     */
    public class TantosyaDummy {

        /** 名前 */
        public String TantosyaName {get; set;}
        /** 部署名 */
        public String Department {get; set;}
        /** 役職 */
        public String Title {get; set;}
        /** メールアドレス */
        public String Email {get; set;}
        /** 請求担当 */
        public Boolean SeikyuTantoFlg {get; set;}

        /** デフォルトコンストラクタ */
        public TantosyaDummy() {
            this.SeikyuTantoFlg = false;
        }

        /** 入力されているかどうか */
        public Boolean isEntry() {

            Boolean ret = false;

            // １つでも入力されていれば入力済みとする
            if (!Strings.isNullOrEmpty(this.TantosyaName) ||
                !Strings.isNullOrEmpty(this.Department) ||
                !Strings.isNullOrEmpty(this.Title) ||
                !Strings.isNullOrEmpty(this.Email) ||
                this.SeikyuTantoFlg
            ) {
                ret = true;
            }
            return ret;
        }

        /** 担当者データ取得 */
        public Contact getTantosayData(String kokyakuId) {

            Contact tantosya = new Contact (AccountId=kokyakuId);
            tantosya.LastName = this.TantosyaName;
            tantosya.Department = this.Department;
            tantosya.Title = this.Title;
            tantosya.Email = this.Email;
            tantosya.SeikyuTantoFlg__c = this.SeikyuTantoFlg;

            return tantosya;
        }
    }
}