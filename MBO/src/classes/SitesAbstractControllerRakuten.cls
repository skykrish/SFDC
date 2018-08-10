public abstract class SitesAbstractControllerRakuten {

    // 定数
    /** メッセージタイプ：正常 */
    public static String MESSAGE_CLS_NORMAL = 'normal';
    /** メッセージタイプ：警告 */
    public static String MESSAGE_CLS_WARNING = 'warning';
    /** メッセージタイプ：エラー */
    public static String MESSAGE_CLS_ERROR = 'error';
    /** 表示モード：通常モード */
    public static String DISP_MODE_NORMAL = 'normal';
    /** 表示モード：確認モード */
    public static String DISP_MODE_CONFIRM = 'confirm';
    /** 表示モード：結果モード */
    public static String DISP_MODE_RESULT = 'result';
    /** クッキー：顧客ID */
    public static String COOKIE_KOKYAKU_ID = 'sites-kokyaku-id';
    /** クッキー：ログインユーザID */
    public static String COOKIE_SAVE_USER_ID = 'sites-save-user-id';
    /** クッキー：ログインパスワード */
    public static String COOKIE_SAVE_USER_PW = 'sites-save-user-pw';
    /** 締めグループ：クレジットカード */
    private static String SHIME_GROUP_CREDIT = 'クレジットカード';
    /** 回収サイクル：クレジットカード */
    private static String KAISYU_CYCLE_3MONTH_AFTER = '翌々々月';

    /** Sitesメッセージ */
    public List<SitesMessage> msgList {
        get;
        private set;
    }

    /** 表示モード */
    public String dispMode {
        get;
        private set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public SitesAbstractControllerRakuten() {
        this.msgList = new List<SitesMessage> ();
    }

    /**
     * 初期化処理
     */
    public PageReference init() {
        
        // セッションチェック
        if (this.isExecSessionCheck()) {
            // セッションが有効かどうか
            if (!this.isEnableSession()) {
                // セッションが無効の場合、ログイン画面へ遷移
                PageReference nextPage = this.getNextPage('SitesloginRakuten');
                nextPage.getParameters().put('forwardUrl', '');
                return nextPage;
            } else {
                // セッションが有効の場合、顧客IDのクッキーを更新
                this.createCookie(this.getKokyakuId());
            }
        }
        
        // デフォルト表示モードは通常モード
        this.dispMode = DISP_MODE_NORMAL;

        // 各サブクラスの個別初期化処理を実行
        return this.individualInit();
    }

    /**
     * セッションチェックを実行するかどうか
     */
    public virtual Boolean isExecSessionCheck() {
        return true;
    }

    /**
     * 個別初期化処理
     */
    public abstract PageReference individualInit();
    
    /**
     * Sitesメッセージ追加
     */
    public void addMessage(String cls, String msg) {
        this.msgList.add(new SitesMessage(cls, msg));
    }

    /**
     * Sitesメッセージクリア
     */
    public void clearMessage() {
        this.msgList.clear();
    }

    /**
     * Sites遷移先取得
     * 引数の遷移先が "http" で始まっていない場合は、Sitesドメインを付加する
     */
    public PageReference getNextPage(String page) {
        
        String nextPage = page;
        if (!page.startsWith('http')) {
            nextPage = 'https://' + Site.getDomain() + '/rakuten/' + page;
        }
        
        return new PageReference(nextPage);
    }

    /**
     * セッションが有効かどうかをチェック
     *
     * @return セッションが有効：true, それ以外：false
     */
    public Boolean isEnableSession() {

        Boolean ret = false;
        Cookie cookie = ApexPages.currentPage().getCookies().get(COOKIE_KOKYAKU_ID);
        if (cookie != null) {
            String kokkyakuId = cookie.getValue();
            if (kokkyakuId != null) {
                ret = true;
            }
        }
        return ret;
    }

    /**
     * ログインしている顧客IDを取得
     *
     * @return ログインしている顧客ID
     */
    public String getKokyakuId() {

        String kokyakuId = null;
        Cookie cookie = ApexPages.currentPage().getCookies().get(COOKIE_KOKYAKU_ID);
        if (cookie != null) {
            kokyakuId = cookie.getValue();
        }
        return kokyakuId;
    }

    /**
     * クッキー発行
     *
     * @param kokyakuId ログインしている顧客ID
     */
    public void createCookie(String kokyakuId) {

        // 顧客IDをクッキーに格納
        Integer sessionTime = Integer.valueOf(System.Label.SessionTime);
        Cookie[] cookies = new Cookie[] {
            new Cookie(COOKIE_KOKYAKU_ID, kokyakuId, null, sessionTime, true)
        };
        ApexPages.currentPage().setCookies(cookies);
    }

    /**
     * クッキー削除
     */
    public void removeCookie() {
        
        // 顧客IDのクッキー削除
        Cookie[] cookies = new Cookie[] {
            new Cookie(COOKIE_KOKYAKU_ID, null, null, 0, true)
        };
        ApexPages.currentPage().setCookies(cookies);
    }
    
    /**
     * ユーザID保存
     *
     * @param userId ユーザID
     */
    public void saveUserId(String userId) {

        // ユーザIDをクッキーに格納（有効期限１ヶ月）
        Integer sessionTime = 2592000;
        Cookie[] cookies = new Cookie[] {
            new Cookie(COOKIE_SAVE_USER_ID, userId, null, sessionTime, true)
        };
        ApexPages.currentPage().setCookies(cookies);
    }

    /**
     * 保存されているユーザID取得
     *
     * @return 保存されているユーザID （取得できない場合は、null）
     */
    public String getSaveUserId() {

        String userId = null;

        Cookie cookie = ApexPages.currentPage().getCookies().get(COOKIE_SAVE_USER_ID);
        if (cookie != null) {
            userId = cookie.getValue();
        }
        return userId;
    }
    
    /**
     * パスワード保存（暗号化して保存する）
     *
     * @param password パスワード
     */
    public void savePassword(String password) {

        // パスワードを暗号化
        String criptPassword = Strings.encryptString(password);

        // ユーザIDをクッキーに格納（有効期限１ヶ月）
        Integer sessionTime = 2592000;
        Cookie[] cookies = new Cookie[] {
            new Cookie(COOKIE_SAVE_USER_PW, criptPassword, null, sessionTime, true)
        };
        ApexPages.currentPage().setCookies(cookies);
    }

    /**
     * 保存されているパスワード取得（復号化して取得する）
     *
     * @return 保存されているパスワード （取得できない場合は、null）
     */
    public String getSavePassword() {

        String password = null;

        Cookie cookie = ApexPages.currentPage().getCookies().get(COOKIE_SAVE_USER_PW);
        if (cookie != null) {
            password = Strings.decryptString(cookie.getValue());
        }
        return password;
    }
    
    /**
     * ログアウト
     */
    public PageReference logout() {

        // 顧客IDのクッキー削除
        this.removeCookie();
        // ログイン画面へ遷移
        PageReference nextPage = this.getNextPage('SitesloginRakuten');
        return nextPage;
    }

    /**
     * マイページ
     */
    public PageReference mypage() {

        // マイページへ遷移
        PageReference nextPage = this.getNextPage('SitesMypageRakuten');
        return nextPage;
    }

    /**
     * 選択リストオプションから指定した選択値に対応するラベル値を取得
     *
     * @param selectOptions 選択リストオプション
     * @param val 選択値
     * @return 選択値に対応するラベル値（一致しなければnull）
     */
    public String getSelectListValue(List<SelectOption> selectOptions, String val) {
        
        String ret = null;
        for (SelectOption item : selectOptions) {
            if (item.getValue() == val) {
                ret = item.getLabel();
                break;
            }
        }
        return ret;
    }
    
    /**
     * 都道府県選択リストオプション取得
     */
    public List<SelectOption> getPrefSelectOptions() {

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('北海道', '北海道'));
        options.add(new SelectOption('青森県', '青森県'));
        options.add(new SelectOption('岩手県', '岩手県'));
        options.add(new SelectOption('宮城県', '宮城県'));
        options.add(new SelectOption('秋田県', '秋田県'));
        options.add(new SelectOption('山形県', '山形県'));
        options.add(new SelectOption('福島県', '福島県'));
        options.add(new SelectOption('茨城県', '茨城県'));
        options.add(new SelectOption('栃木県', '栃木県'));
        options.add(new SelectOption('群馬県', '群馬県'));
        options.add(new SelectOption('埼玉県', '埼玉県'));
        options.add(new SelectOption('千葉県', '千葉県'));
        options.add(new SelectOption('東京都', '東京都'));
        options.add(new SelectOption('神奈川県', '神奈川県'));
        options.add(new SelectOption('新潟県', '新潟県'));
        options.add(new SelectOption('富山県', '富山県'));
        options.add(new SelectOption('石川県', '石川県'));
        options.add(new SelectOption('福井県', '福井県'));
        options.add(new SelectOption('山梨県', '山梨県'));
        options.add(new SelectOption('長野県', '長野県'));
        options.add(new SelectOption('岐阜県', '岐阜県'));
        options.add(new SelectOption('静岡県', '静岡県'));
        options.add(new SelectOption('愛知県', '愛知県'));
        options.add(new SelectOption('三重県', '三重県'));
        options.add(new SelectOption('滋賀県', '滋賀県'));
        options.add(new SelectOption('京都府', '京都府'));
        options.add(new SelectOption('大阪府', '大阪府'));
        options.add(new SelectOption('兵庫県', '兵庫県'));
        options.add(new SelectOption('奈良県', '奈良県'));
        options.add(new SelectOption('和歌山県', '和歌山県'));
        options.add(new SelectOption('鳥取県', '鳥取県'));
        options.add(new SelectOption('島根県', '島根県'));
        options.add(new SelectOption('岡山県', '岡山県'));
        options.add(new SelectOption('広島県', '広島県'));
        options.add(new SelectOption('山口県', '山口県'));
        options.add(new SelectOption('徳島県', '徳島県'));
        options.add(new SelectOption('香川県', '香川県'));
        options.add(new SelectOption('愛媛県', '愛媛県'));
        options.add(new SelectOption('高知県', '高知県'));
        options.add(new SelectOption('福岡県', '福岡県'));
        options.add(new SelectOption('佐賀県', '佐賀県'));
        options.add(new SelectOption('長崎県', '長崎県'));
        options.add(new SelectOption('熊本県', '熊本県'));
        options.add(new SelectOption('大分県', '大分県'));
        options.add(new SelectOption('宮崎県', '宮崎県'));
        options.add(new SelectOption('鹿児島県', '鹿児島県'));
        options.add(new SelectOption('沖縄県', '沖縄県'));
        
        return options;
    }

    /**
     * 選択オプション取得(月)
     */
    public List<SelectOption> getMonthOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--'));
        options.add(new SelectOption('01', '01'));
        options.add(new SelectOption('02', '02'));
        options.add(new SelectOption('03', '03'));
        options.add(new SelectOption('04', '04'));
        options.add(new SelectOption('05', '05'));
        options.add(new SelectOption('06', '06'));
        options.add(new SelectOption('07', '07'));
        options.add(new SelectOption('08', '08'));
        options.add(new SelectOption('09', '09'));
        options.add(new SelectOption('10', '10'));
        options.add(new SelectOption('11', '11')); 
        options.add(new SelectOption('12', '12'));
         return options;
    }

    /**
     * 選択オプション取得(年)
     */
    public List<SelectOption> getYearOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '----'));
        options.add(new SelectOption('15', '2015'));
        options.add(new SelectOption('16', '2016'));
        options.add(new SelectOption('17', '2017'));
        options.add(new SelectOption('18', '2018'));
        options.add(new SelectOption('19', '2019'));
        options.add(new SelectOption('20', '2020'));
        options.add(new SelectOption('21', '2021'));
        options.add(new SelectOption('22', '2022'));
        options.add(new SelectOption('23', '2023'));
        options.add(new SelectOption('24', '2024'));
        options.add(new SelectOption('25', '2025'));
        return options;
    }


    /**
     * PC環境選択リストオプション取得
     */
    public List<SelectOption> getPcSelectOptions() {
        
        // 選択リスト取得
        Schema.DescribeFieldResult sField = Account.PC__c.getDescribe();
        List<PicklistEntry> pEntryList = sField.getPicklistValues();
        
        // 選択リストオプション作成
        List<SelectOption> options = new List<SelectOption> ();
        for (PicklistEntry item : pEntryList) {
            options.add(new SelectOption(item.getValue(), item.getLabel()));
        }
        return options;
    }
    
    /**
     * 締日（締めグループ）選択リストオプション取得
     */
    public List<SelectOption> getShimeGroupSelectOptions() {
        
        // 選択リスト取得
        Schema.DescribeFieldResult sField = Account.ShimeGroup__c.getDescribe();
        List<PicklistEntry> pEntryList = sField.getPicklistValues();
        
        // 選択リストオプション作成
        List<SelectOption> options = new List<SelectOption> ();
        for (PicklistEntry item : pEntryList) {
            // クレジットカードは除く
            if (item.getValue() != SHIME_GROUP_CREDIT) {
                options.add(new SelectOption(item.getValue(), item.getLabel()));
            }
        }
        return options;
    }

    /**
     * 支払サイクル選択リストオプション取得
     */
    public List<SelectOption> getKaisyuCycleSelectOptions() {
        
        // 選択リスト取得
        Schema.DescribeFieldResult sField = Account.KaisyuCycle__c.getDescribe();
        List<PicklistEntry> pEntryList = sField.getPicklistValues();
        
        // 選択リストオプション作成
        List<SelectOption> options = new List<SelectOption> ();
        for (PicklistEntry item : pEntryList) {
            // 翌々々月は除く
            if (item.getValue() != KAISYU_CYCLE_3MONTH_AFTER) {
                options.add(new SelectOption(item.getValue(), item.getLabel()));
            }
        }
        return options;
    }

    /**
     * 支払日選択リストオプション取得
     */
    public List<SelectOption> getKaisyuDateSelectOptions() {
        
        // 選択リスト取得
        Schema.DescribeFieldResult sField = Account.KaisyuDate__c.getDescribe();
        List<PicklistEntry> pEntryList = sField.getPicklistValues();
        
        // 選択リストオプション作成
        List<SelectOption> options = new List<SelectOption> ();
        for (PicklistEntry item : pEntryList) {
            options.add(new SelectOption(item.getValue(), item.getLabel()));
        }
        return options;
    }

    /**
     * カード会社選択リストオプション取得
     */
    public List<SelectOption> getCardCompanySelectOptions() {
        
        // 選択リスト取得
        Schema.DescribeFieldResult sField = Account.CardCompany__c.getDescribe();
        List<PicklistEntry> pEntryList = sField.getPicklistValues();
        
        // 選択リストオプション作成
        List<SelectOption> options = new List<SelectOption> ();
        for (PicklistEntry item : pEntryList) {
            options.add(new SelectOption(item.getValue(), item.getLabel()));
        }
        return options;
    }
}