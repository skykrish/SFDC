public with sharing class SitesPasswordRemindController extends SitesAbstractController {

    /** メールアドレス */
    public String email {
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

    /**
     * デフォルトコンストラクタ
     */
    public SitesPasswordRemindController() {
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
        
        return null;
    }
    
    /**
     * 再発行
     */
    public PageReference send() {
        
        // メッセージクリア
        clearMessage();
        
        // 入力チェック
        if (!this.validate()) {
            return null;
        }
        
        // 担当者データ取得
        List<Contact> tantosyaList = this.getTantosyaList(this.email);
        if (tantosyaList.size() == 0) {
            // 該当データなし
            addMessage(MESSAGE_CLS_ERROR, '該当するご担当者様情報が見つかりませんでした。');
            return null;
        }
        
        // 顧客存在チェック
        String phone = this.phone1 + this.phone2 + this.phone3;
        Contact tantosya = this.getTantosya(tantosyaList, phone);
        if (tantosya == null) {
            // 該当データなし
            addMessage(MESSAGE_CLS_ERROR, '該当するお客様情報が見つかりませんでした。');
            return null;
        }
        
        // メール送信
        this.sendMail(tantosya.Id);

        // 完了メッセージ
        addMessage(MESSAGE_CLS_NORMAL, 'ユーザIDとパスワードを送信しました。');

        // 結果モードに切り替え
        dispMode = DISP_MODE_RESULT;

        // 入力内容クリア
        this.email = null;
        this.phone1 = null;
        this.phone2 = null;
        this.phone3 = null;

        return null;
    }
 
    /**
     * 入力チェック
     */
    private Boolean validate() {
        
        Boolean ret = true;
        
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

        // 電話番号：必須チェック
        if (Strings.isNullOrEmpty(this.phone1) ||
            Strings.isNullOrEmpty(this.phone2) ||
            Strings.isNullOrEmpty(this.phone3)
        ) {
            ret = false;
            addMessage(MESSAGE_CLS_ERROR, '電話番号が入力されていません。');

        } else {
            // 電話番号：形式チェック
            if (!Strings.isPhoneNumber(this.phone1 + this.phone2 + this.phone3)) {
                ret = false;
                addMessage(MESSAGE_CLS_ERROR, '電話番号の形式が正しくありません。');
            }
        }
        
        return ret;
    }
    
    /**
     * 担当者データ取得
     *
     * @param email メールアドレス
     * @return 担当者データ
     */
    private List<Contact> getTantosyaList(String email) {
        
        List<Contact> conList = [SELECT
                                     Id,
                                     Name,
                                     Account.Phone
                                 FROM
                                     Contact
                                 WHERE
                                     Email = :email AND
                                     Del_Flg__c = false
                                 ORDER BY
                                     Account.SampleKokyakuFlg__c];

        return conList;
    }
    
    /**
     * 顧客存在チェック
     * 電話番号が一致する顧客データを親に持つ担当者データを取得する。
     *
     * @param tantosyaList 担当者データ
     * @param phone 電話番号
     * @return 電話番号が一致する顧客データを親に持つ担当者データ（一致しない場合はnull）
     */
    private Contact getTantosya(List<Contact> tantosyaList, String phone) {
        
        Contact tantosya = null;

        // 電話番号が一致する顧客データを親に持つ担当者データを取得
        for (Contact item : tantosyaList) {
            // ハイフンを排除した上で比較
            String kokyakuPhone = item.Account.Phone;
            if (kokyakuPhone != null) {
                kokyakuPhone = kokyakuPhone.replaceAll('-', '');
            }
            // 電話番号が一致するかどうか
            if (kokyakuPhone == phone) {
                tantosya = item;
                break;
            }
        }
        return tantosya;
    }
    
    /**
     * メール送信
     *
     * @param tantosyaId 担当者ID
     */
    private void sendMail(String tantosyaId) {

        // メールテンプレート取得
        List<EmailTemplate> templateList = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :System.Label.PasswordRemindMailTemplate AND IsActive = :true];

        // 組織のメールアドレス取得
        List<OrgWideEmailAddress> orgAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateList[0].Id);
        email.setOrgWideEmailAddressId(orgAddressList[0].Id);
        email.setTargetObjectId(tantosyaId);
        email.setSaveAsActivity(true);

        // メール送信
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
    
}