public with sharing class SitesOrderControllerRakuten extends SitesAbstractControllerRakuten {

    // 定数
    /** 見積：要 */
    private static String MITSUMORI_NEED = '要';
    /** 見積：不要 */
    private static String MITSUMORI_NOT_NEED = '不要';
    /** ステータス：見積受付 */
    private static String STATUS_MITSUMORI_UKETSUKE = '見積受付';
    /** ステータス：受注 */
    private static String STATUS_JUCYU = '受注';
    /** 受注ソース：オンライン発注フォーム */
    private static String JUCYU_SOURCE_ONLINE = 'オンライン発注フォーム';
    /** 更新元：Sites */
    private static String UPDATED_BY_SITES = 'sites-order';
    /** 発注タイミング：見積り後の発注 */
    private static String HATYUTAIMINGU_NEED = '見積り後の発注';
    /** 発注タイミング：見積り不要 */
    private static String HATYUTAIMINGU_NOT_NEED = '見積り不要';
    /** 表示モード */
    public String dispMode {
        get;
        private set;
    }
    /** 表示モード：通常モード */
    public static String DISP_MODE_NORMAL = 'normal';
    /** 表示モード：確認モード */
    public static String DISP_MODE_CONFIRM = 'confirm';
    /** 表示モード：結果モード */
    public static String DISP_MODE_RESULT = 'result';


    /** 登録用案件データ */
    public Anken__c anken {
        get;
        set;
    }
    
    /** 登録用アップロード方法 */
    public String upload {
        get;
        set;
    }

    /** 登録用納品方法 */
    public String nouhin {
        get;
        set;
    }

    /** 登録用PC環境 */
    public String pc {
        get;
        set;
    }

    /** 登録用担当者（メイン） */
    public String tantosyaMain {
        get;
        set;
    }

    /** 登録用担当者（CC1） */
    public String tantosyaCc1 {
        get;
        set;
    }

    /** 登録用担当者（CC2） */
    public String tantosyaCc2 {
        get;
        set;
    }

    /** 登録用担当者（CC3） */
    public String tantosyaCc3 {
        get;
        set;
    }

    /** 登録用担当者（CC4） */
    public String tantosyaCc4 {
        get;
        set;
    }

    /** 登録用担当者名（メイン） */
    public String tantosyaMainName {
        get;
        private set;
    }

    /** 登録用担当者名（CC1） */
    public String tantosyaCc1Name {
        get;
        private set;
    }

    /** 登録用担当者名（CC2） */
    public String tantosyaCc2Name {
        get;
        private set;
    }

    /** 登録用担当者名（CC3） */
    public String tantosyaCc3Name {
        get;
        private set;
    }

    /** 登録用担当者名（CC4） */
    public String tantosyaCc4Name {
        get;
        private set;
    }

    /** 担当者選択リストオプション */
    public List<SelectOption> tantosyaSelectOptions {
        get;
        private set;
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
    public SitesOrderControllerRakuten() {
        // デフォルト表示モードは通常モード
        this.dispMode = DISP_MODE_NORMAL;
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {

        // 顧客ID取得
        String kokyakuId = getKokyakuId();

        // 顧客データ取得
        Account kokyaku = this.getKokyaku(kokyakuId);

        // 担当者データ取得
        List<Contact> tantosyaList = this.getTantosyaList(kokyakuId);

        // 担当者選択リストオプション生成
        this.tantosyaSelectOptions = this.getTantosyaSelectOptions(tantosyaList);

        // ファイルサーバ接続情報設定
        this.fileServerAddressGlobal = kokyaku.GlobalIP__c;        
        this.fileServerId = kokyaku.KokyakuId__c;
        this.fileServerPw = kokyaku.KokyakuPw__c;
        this.fileServerDir = Datetime.now().addHours(9).format('yyyyMMddHHmmss');

        // 登録用案件データ初期化
        if (this.anken == null) {
            this.anken = new Anken__c();
            this.anken.KokyakuName__c = kokyaku.Id;
            this.anken.SagyoNaiyo__c = kokyaku.SagyoNaiyo__c;
            this.anken.SagyoNaiyo_1__c = kokyaku.SagyoNaiyo_1__c;
            this.anken.SagyoNaiyo_2__c = kokyaku.SagyoNaiyo_2__c;
            this.anken.Sagyoshiji_Renrakujiko__c = kokyaku.Sagyoshiji_Renrakujiko__c;
            this.anken.Status__c = (kokyaku.Mitsumori__c == HATYUTAIMINGU_NOT_NEED) ? STATUS_JUCYU : STATUS_MITSUMORI_UKETSUKE;
            this.anken.JuchuSorce__c = JUCYU_SOURCE_ONLINE;
            this.anken.WhoUpdated__c = UPDATED_BY_SITES;
            this.anken.IsUseUploader__c = false;
            this.anken.PC__c = kokyaku.PC__c;
            // add start 20180410
            this.anken.ColorMode__c = kokyaku.ColorMode__c;
            this.anken.ClippingPath__c = kokyaku.ClippingPath__c;
            this.anken.ClippingPathName__c = kokyaku.ClippingPathName__c;
            this.anken.FileFormat__c = kokyaku.FileFormat__c;
            this.anken.Resolution__c = kokyaku.Resolution__c;
            this.anken.Nihondeno_nouhin__c = kokyaku.Nihondeno_nouhin__c;
            this.anken.Background__c = kokyaku.Background__c;
            this.anken.Flatness__c = kokyaku.Flatness__c;
            this.anken.Margin__c = kokyaku.Margin__c;
            // add end
        }
        

        return null;
    }

    /**
     * 顧客データ取得
     *
     * @param accId 顧客ID
     * @return 顧客データ
     */
    private Account getKokyaku(String accId) {

        List<Account> accList = [SELECT
                                     Id,
                                     Name,
                                     KokyakuId__c,
                                     KokyakuPw__c,
                                     SagyoNaiyo__c,
                                     SagyoNaiyo_1__c,
                                     SagyoNaiyo_2__c,
                                     Sagyoshiji_Renrakujiko__c,
                                     Mitsumori__c,
                                     GlobalIP__c,
                                     PC__c,
                                     // add start 20180410
                                     ColorMode__c,
                                     ClippingPath__c,
                                     ClippingPathName__c,
                                     FileFormat__c,
                                     Resolution__c,
                                     Nihondeno_nouhin__c,
                                     Background__c,
                                     Flatness__c,
                                     Margin__c
                                     // add end 20180410
                                 FROM
                                     Account
                                 WHERE
                                     Id = :accId];

        return accList[0];
    }

    /**
     * 担当者データ取得
     *
     * @param accId 顧客ID
     * @return 担当者データ
     */
    private List<Contact> getTantosyaList(String accId) {

        List<Contact> conList = [SELECT
                                     Id,
                                     Name
                                 FROM
                                     Contact
                                 WHERE
                                     AccountId = :accId AND
                                     Del_Flg__c = false
                                 ORDER BY
                                     MainTantoFlg__c DESC,
                                     Name];

        return conList;
    }

    /**
     * 担当者選択リストオプション生成
     *
     * @param tantosyaList 担当者データ
     * @return 担当者選択リスト
     */
    private List<SelectOption> getTantosyaSelectOptions(List<Contact> tantosyaList) {

        List<SelectOption> options = new List<SelectOption>();
        for (Contact item : tantosyaList) {
            options.add(new SelectOption(item.Id, item.Name));
        }

        return options;
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

        // 担当者名を設定
        this.tantosyaMainName = getSelectListValue(this.tantosyaSelectOptions, this.tantosyaMain);
        this.tantosyaCc1Name = getSelectListValue(this.tantosyaSelectOptions, this.tantosyaCc1);
        this.tantosyaCc2Name = getSelectListValue(this.tantosyaSelectOptions, this.tantosyaCc2);
        this.tantosyaCc3Name = getSelectListValue(this.tantosyaSelectOptions, this.tantosyaCc3);
        this.tantosyaCc4Name = getSelectListValue(this.tantosyaSelectOptions, this.tantosyaCc4);

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

        // 案件データに顧客担当者情報を設定
        this.anken.KokyakuTantosya_Main__c = this.tantosyaMain;
        this.anken.KokyakuTantosya_CC1__c = this.tantosyaCc1;
        this.anken.KokyakuTantosya_CC2__c = this.tantosyaCc2;
        this.anken.KokyakuTantosya_CC3__c = this.tantosyaCc3;
        this.anken.KokyakuTantosya_CC4__c = this.tantosyaCc4;
        
        // 案件データに発注タイミングを設定
        if(this.anken.Status__c == STATUS_JUCYU){
            this.anken.Hatyutaimingu__c = HATYUTAIMINGU_NOT_NEED;
        }else if(this.anken.Status__c == STATUS_MITSUMORI_UKETSUKE){
            this.anken.Hatyutaimingu__c = HATYUTAIMINGU_NEED;
        }

        // 案件データに受注日時を設定
        this.anken.JuchuDateTime__c = Datetime.now();

        // アップローダが使用されていれば入稿フォルダ名に
        // ファイルサーバディレクトリを追記
        if (this.anken.IsUseUploader__c) {
            if (Strings.isNullOrEmpty(this.anken.FolderName__c)) {
                this.anken.FolderName__c = this.fileServerDir;
            } else {
                this.anken.FolderName__c += '\r\n' + this.fileServerDir;
            }
        }

        // 案件データに発注フォーム用PC環境を設定
        // nullの場合は顧客から取得したPC環境をそのまま設定
        if(this.pc != null){
            this.anken.PC__c = this.pc;
        }
        
        // 案件データに納品方法を設定
        if (nouhin == 'サーバーへのアップロード'){
            this.anken.ServerUpload__c = true;
        }else if (nouhin == 'ダウンロード用URLでの納品'){
            this.anken.firestorage__c = true;
        }
        
        // アップロード方法を設定
        if (upload == 'FTPでアップロード'){
            this.anken.FTPUpload__c = true;
        }

        // 登録
        insert this.anken;

        // メール送信
        this.sendMail(this.anken.Id, this.tantosyaMain, this.tantosyaCc1, this.tantosyaCc2, this.tantosyaCc3, this.tantosyaCc4);

        // 遷移
        return getNextPage(System.Label.RedirectOrderRakuten);
    }

    /**
     * メール送信
     *
     * @param ankenId 案件ID
     * @param tantosyaMain 担当者ID
     * @param tantosyaCc1 担当者ID（CC1）
     * @param tantosyaCc2 担当者ID（CC2）
     * @param tantosyaCc3 担当者ID（CC3）
     * @param tantosyaCc4 担当者ID（CC4）
     */
    private void sendMail(
        String ankenId,
        String tantosyaMain,
        String tantosyaCc1,
        String tantosyaCc2,
        String tantosyaCc3,
        String tantosyaCc4
    ) {
        // メールテンプレート取得
        List<EmailTemplate> templateList = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = :System.Label.OrderMailTemplate AND IsActive = :true];

        // 組織のメールアドレス取得
        List<OrgWideEmailAddress> orgAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];

        // CCメールアドレス取得
        List<String> ccAddresses = this.getCcAddresses(tantosyaCc1, tantosyaCc2, tantosyaCc3, tantosyaCc4);

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateList[0].Id);
        email.setOrgWideEmailAddressId(orgAddressList[0].Id);
        email.setTargetObjectId(tantosyaMain);
        email.setCcAddresses(ccAddresses);
        email.setWhatId(ankenId);
        email.setSaveAsActivity(true);

        // メール送信
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }

    /**
     * CCメールアドレス取得
     *
     * @param cc1 担当者ID（CC1）
     * @param cc2 担当者ID（CC2）
     * @param cc3 担当者ID（CC3）
     * @param cc4 担当者ID（CC4）
     * @return CCメールアドレス
     */
    private List<String> getCcAddresses(String cc1, String cc2, String cc3, String cc4) {

        // IDリスト作成
        List<String> idList = new List<String> {cc1, cc2, cc3, cc4};

        // メールアドレス取得
        List<Contact> tantosyaList = [SELECT Id, Name, Email FROM Contact WHERE Id IN :idList];

        // CCメールアドレス
        List<String> addressList = new List<String> ();
        for (Contact item : tantosyaList) {
            if (!Strings.isNullOrEmpty(item.Email)) {
                addressList.add(item.Email);
            }
        }

        return addressList;
    }


}