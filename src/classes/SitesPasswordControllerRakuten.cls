public with sharing class SitesPasswordControllerRakuten extends SitesAbstractControllerRakuten {

    // 定数
    /** 更新元：Sites */
    private static String UPDATED_BY_SITES = 'sites-password';
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


    /**
     * 現在のパスワード
     */
    public String password {
    	get; set;
    }

    /**
     * 新しいパスワード
     */
    public String newPassword {
    	get; set;
    }

    /**
     * 新しいパスワード再入力
     */
    public String newPasswordConfirm {
    	get; set;
    }
    
    /**
     * 顧客データ
     */
    private Account kokyaku;

    /**
     * デフォルトコンストラクタ
     */
    public SitesPasswordControllerRakuten() {
        // デフォルト表示モードは通常モード
        this.dispMode = DISP_MODE_NORMAL;
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {
    	
    	// 顧客ID取得
    	String kokyakuId = getKokyakuId();
    	
    	//　顧客データ取得
    	this.kokyaku = this.getKokyakuData(kokyakuId);
        
        return null;
    }

    /**
     * 変更用顧客データ取得
     *
     * @param kokyakuId 顧客ID
     * @return 顧客データ
     */
    private Account getKokyakuData(String kokyakuId) {
        
        // 顧客データ取得
        List<Account> accList = [SELECT
                                     Id,
                                     Name,
                                     KokyakuId__c,
                                     KokyakuPw__c,
                                     KokyakuPwNew__c
                                 FROM
                                     Account
                                 WHERE
                                     Id = :kokyakuId];
        
        return accList[0];
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

        // 現在のパスワード：必須チェック
    	if (Strings.isNullOrEmpty(this.password)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, '現在のパスワードが入力されていません。');
    		
    	} else {
            // 現在のパスワード：認証チェック
            if (this.password != this.kokyaku.KokyakuPw__c) {
                ret = false;
	   		    addMessage(MESSAGE_CLS_ERROR, 'パスワードが正しくありません。');
            }
    	}

        // 新しいパスワード：必須チェック
    	if (Strings.isNullOrEmpty(this.newPassword)) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, '新しいパスワードが入力されていません。');

    	} else {
			// 新しいパスワード：桁数チェック
			if (this.newPassword.length() < 4) {
	    		ret = false;
		   		addMessage(MESSAGE_CLS_ERROR, '新しいパスワードは４桁以上である必要があります。');
			}
    		// 新しいパスワード：形式チェック
    		if (!this.isKokyakuPwFormat(this.newPassword)) {
	    		ret = false;
		   		addMessage(MESSAGE_CLS_ERROR, '新しいパスワードは半角英数字、ハイフン、アンダースコアである必要があります。');
    		}
    		// 新しいパスワード：パスワード再入力チェック
    		if (this.newPassword != this.newPasswordConfirm) {
	    		ret = false;
		   		addMessage(MESSAGE_CLS_ERROR, '新しいパスワードと再入力されたパスワードが一致しません。');
    		}
    	}

		//  同一パスワードチェック
		if (ret && this.password == this.newPassword) {
    		ret = false;
	   		addMessage(MESSAGE_CLS_ERROR, '新しいパスワードは現在のパスワードと違う値を設定する必要があります。');
		}
       
        return ret;
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
        
        // 顧客データ変更
        this.kokyaku.KokyakuPwNew__c = this.newPassword;
        this.kokyaku.WhoUpdated__c = UPDATED_BY_SITES;
        update this.kokyaku;

        // 結果モードに切り替え
        dispMode = DISP_MODE_RESULT;
        return null;
    }
    
    /**
     * 発注フォーム
     */
    public PageReference order() {

        // 遷移
        PageReference nextPage = getNextPage('SitesOrderRakuten');
        return nextPage;
    }

}