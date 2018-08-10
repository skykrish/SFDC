public with sharing class SitesLoginControllerRakuten extends SitesAbstractControllerRakuten {

    // 定数
    /** デフォルト遷移先 */
    private static String DEFAULT_FORWARD_URL = 'SitesOrderRakuten';

    /** ユーザID */
    public String userId {
        get;
        set;
    }

    /** パスワード */
    public String password {
        get;
        set;
    }

    /** ID省略チェックボックス */
    public Boolean isAutoset {
        get;
        set;
    }

    /** 遷移先URL */
    private String forwardUrl;

    /**
     * デフォルトコンストラクタ
     */
    public SitesLoginControllerRakuten() {
        
        // リクエストパラメータ取得
        String url = ApexPages.currentPage().getParameters().get('forwardUrl');
        this.forwardUrl = (url == null) ? DEFAULT_FORWARD_URL : url;
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
        
        this.userId = getSaveUserId();
        this.password = getSavePassword();
        return null;
    }

    /**
     * ログイン処理
     */
    public PageReference login() {
        
        // メッセージクリア
        clearMessage();
        
        // パラメータ取得
//        this.userId = ApexPages.currentPage().getParameters().get('userId');
//        this.password = ApexPages.currentPage().getParameters().get('password');
//        this.isAutoset = (ApexPages.currentPage().getParameters().get('isAutoset') == 'true') ? true : false ;
        
        // 入力チェック
        if (!this.validate()) {
            return getNextPage('SitesLoginErrorRakuten');
        }

        // 遷移先
        PageReference nextPage = null;
        // ログインデータ取得
        Account loginUser = this.getLoginUser(this.userId, this.password);

        // ログイン判定
        if (loginUser != null) {
            // OK
            addMessage(MESSAGE_CLS_NORMAL, 'ログインOK！');
            // クッキー発行
            createCookie(loginUser.Id);
            // クッキー発行（ログインページのユーザID、パスワード保存用）
            if (this.isAutoset) {
                saveUserId(this.userId);
                savePassword(this.password);
            }
            // 遷移先設定
            /* mod start 2015-02-05 */
            //nextPage = getNextPage('order');
            if (this.forwardUrl == 'mypage'){
	            nextPage = getNextPage('SitesMypageRakuten');
            } else {
	            nextPage = getNextPage('SitesOrderRakuten');
            }
            /* mod end 2015-02-05 */

        } else {
            // NG
            nextPage = getNextPage('SitesLoginErrorRakuten');
        }
        
        return nextPage;
    }

    /**
     * 入力チェック
     * @return OK:true, NG:false
     */
    private Boolean validate() {
        
        Boolean ret = true;
        
        // ユーザID：必須チェック
        if (Strings.isNullOrEmpty(this.userId)) {
            ret = false;
        //  addMessage(MESSAGE_CLS_ERROR, 'ユーザIDが入力されていません。');
        }

        // パスワード：必須チェック
        if (Strings.isNullOrEmpty(this.password)) {
            ret = false;
        //  addMessage(MESSAGE_CLS_ERROR, 'パスワードが入力されていません。');
        }
        
        return ret;
    }

    
    /**
     * ログインデータ取得
     * @param userId ユーザID
     * @param password パスワード
     * @return ログインOK:取引先データ, NG：null
     */
    private Account getLoginUser(String userId, String password) {
        
        Account loginUser = null;
        
        List<Account> accList = [SELECT
                                     Id,
                                     Name
                                 FROM
                                     Account
                                 WHERE
                                     KokyakuId__c = :userId AND
                                     KokyakuPw__c = :password AND
                                     SampleKokyakuFlg__c = false];

        if (accList.size() > 0) {
            loginUser = accList[0];
        }
        
        return loginUser;
    }

    /**
     * パスワードリマインド
     */
    public PageReference forget() {
        
        // 遷移
        PageReference nextPage = getNextPage('SitesPasswordRemindRakuten');
        return nextPage;
    }

    /**
     * ログインページへ戻る
     */
    public PageReference back() {
        
        // 遷移
        PageReference nextPage = getNextPage('SitesloginRakuten');
        return nextPage;
    }
}