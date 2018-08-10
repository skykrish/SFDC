public with sharing class SitesUsereditController extends SitesAbstractController {
	
    /**
     * 顧客データ
     */
    public KokyakuDummy kokyaku {
        get; set;
    }

    /**
     * 変更用担当者データ
     */
    public List<TantosyaDummy> tantosyaList {
        get;
        set;
    }
    
    /**
     * 表示用担当者データ（確認画面で使用）
     */
    public List<TantosyaDummy> dispTantosyaList {
        get;
        private set;
    }
    
    /**
     * デフォルトコンストラクタ
     */
    public SitesUsereditController() {
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {
        
        // 顧客ID取得
        String kokyakuId = getKokyakuId();

        // 変更用顧客データ取得
        this.kokyaku = this.getKokyakuData(kokyakuId);

        // 変更用担当者データ取得
        this.tantosyaList = this.getTantosyaList(kokyakuId);
        
        return null;
    }
    
    /**
     * 変更用顧客データ取得
     *
     * @param kokyakuId 顧客ID
     * @return 変更用顧客データ
     */
    private KokyakuDummy getKokyakuData(String kokyakuId) {
        
        // 顧客データ取得
        List<Account> accList = [SELECT
                                     Id,
                                     Name,
                                     KokyakuNameKana__c,
                                     BillingPostalCode,
                                     BillingState,
                                     BillingCity,
                                     BillingStreet,
                                     Phone,
                                     Fax
                                 FROM
                                     Account
                                 WHERE
                                     Id = :kokyakuId];
        
        // 変更用顧客データ生成
        KokyakuDummy kokyakuData = new KokyakuDummy();
        kokyakuData.setKokyakuData(accList[0]);
        
        return kokyakuData;
    }
    
    /**
     * 変更用担当者データ取得
     *
     * @param 顧客ID
     * @return 変更用担当者データ
     */
    private List<TantosyaDummy> getTantosyaList(String kokyakuId) {

        // 担当者データ取得
        List<Contact> conList = [SELECT
                                     Id,
                                     Name,
                                     Department,
                                     Title,
                                     Email,
                                     SeikyuTantoFlg__c
                                 FROM
                                     Contact
                                 WHERE
                                     AccountId = :kokyakuId AND
                                     Del_Flg__c = false
                                 ORDER BY
                                     Name];

        // 担当者データ生成
        List<TantosyaDummy> tantosyaList = new List<TantosyaDummy> ();
        for (Contact item : conList) {
        	TantosyaDummy dummy = new TantosyaDummy();
            dummy.setTantosyaData(item);
            tantosyaList.add(dummy);
        }
        
        return tantosyaList;
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
        
        // 入力チェック
        if (!this.validate()) {
            return null;
        }
        
        // 表示用担当者リスト生成
        this.dispTantosyaList = new List<TantosyaDummy> ();
        for (TantosyaDummy item : this.tantosyaList) {
    		// 入力のないレコードは確認画面では表示しない
            if (item.isEntry()) {
            	this.dispTantosyaList.add(item);
            }
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
        
        // 入力のないレコード除去（変更用担当者データ）
        List<TantosyaDummy> editList = new List<TantosyaDummy>();
        for (TantosyaDummy item : this.tantosyaList) {
            if (item.isEntry()) {
                editList.add(item);
            }
        }

        // 顧客ID取得
        String kokyakuId = getKokyakuId();

        // 顧客データ変更
        Account kokyaku = this.getUpdKokyakuData(kokyakuId, this.kokyaku);
        update kokyaku;
        
        // 担当者データ取得（追加）
		List<Contact> insList = new List<Contact>();
		List<Contact> updList = new List<Contact>();
		List<Contact> delList = new List<Contact>();
        for (TantosyaDummy item : this.tantosyaList) {
        	// 新規
        	if (item.tantosya == null) {
        		// 入力のないレコードは除去
                if (item.isEntry()) {
                    insList.add(item.getInsTantosyaData(kokyakuId));
                }
        	}
        	// 更新、論理削除
        	if (item.tantosya != null) {
        		// 入力のないレコードは論理削除
                if (item.isEntry()) {
                	// 更新
                	updList.add(item.getUpdTantosyaData());
                } else {
                	// 論理削除
                	delList.add(item.getDelTantosyaData());
                }
        	}
        }
		// 担当者データ変更
        insert insList;
        update updList;
        update delList;
        
        // 結果モードに切り替え
        dispMode = DISP_MODE_RESULT;
        return null;
    }
    
    /**
     * 更新対象顧客データ取得
     * @param kokyakuId 顧客ID
     * @param kokyaku 変更用顧客データ
     * @return 更新用の担当者データ
     */
    private Account getUpdKokyakuData(String kokyakuId, KokyakuDummy kokyaku) {

        // 顧客データ取得
    	List<Account> updList = [SELECT
                                     Id,
                                     Name,
                                     KokyakuNameKana__c,
                                     BillingPostalCode,
                                     BillingState,
                                     BillingCity,
                                     BillingStreet,
                                     Phone,
                                     Fax
                                 FROM
                                     Account
                                 WHERE
                                     Id = :kokyakuId];
    	
        // 更新情報設定
        updList[0].Name = kokyaku.KokyakuName;
        updList[0].KokyakuNameKana__c = kokyaku.KokyakuNameKana;
        updList[0].BillingPostalCode = kokyaku.PostalCode1 + '-' + kokyaku.PostalCode2;
        updList[0].BillingState = kokyaku.State;
        updList[0].BillingCity = kokyaku.City;
        updList[0].BillingStreet = kokyaku.Street1 + kokyaku.Street2;
        updList[0].Phone = kokyaku.Phone1 + '-' + kokyaku.Phone2 + '-' + kokyaku.Phone3;
        updList[0].Fax = kokyaku.Fax1 + '-' + kokyaku.Fax2 + '-' + kokyaku.Fax3;
    	
    	return updList[0];
    }

    /**
     * 発注フォーム
     */
    public PageReference order() {

        // 遷移
        PageReference nextPage = getNextPage('order');
        return nextPage;
    }

    /**
     * 変更用顧客クラス
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

        /** デフォルトコンストラクタ */
        public KokyakuDummy() {
        }
        
        /** 顧客データ設定 */
        public void setKokyakuData(Account kokyaku) {
            
            this.KokyakuName = kokyaku.Name;
            this.KokyakuNameKana = kokyaku.KokyakuNameKana__c;
            this.PostalCode1 = this.split(kokyaku.BillingPostalCode, 0);
            this.PostalCode2 = this.split(kokyaku.BillingPostalCode, 1);
            this.State = kokyaku.BillingState;
            this.City = kokyaku.BillingCity;
            this.Street1 = kokyaku.BillingStreet;
            this.Phone1 = this.split(kokyaku.Phone, 0);
            this.Phone2 = this.split(kokyaku.Phone, 1);
            this.Phone3 = this.split(kokyaku.Phone, 2);
            this.Fax1 = this.split(kokyaku.Fax, 0);
            this.Fax2 = this.split(kokyaku.Fax, 1);
            this.Fax3 = this.split(kokyaku.Fax, 2);
        }

        /** スプリットして取得 */
        private String split(String target, Integer cnt) {
            String ret = null;
            if(!Strings.isNullOrEmpty(target)) {
                List<String> targetList = target.split('-');
                if (targetList.size() > cnt) {
                   ret = targetList[cnt];
                }
            }
            return ret;
        }
    }

    /**
     * 変更用担当者クラス
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
        /** 請求先 */
        public Boolean SeikyuTantoFlg {get; set;}
        /** 処理モード */
        private String ExecMode {get; set;}
        /** 担当者オブジェクト */
        private Contact tantosya {get; set;}

        /** デフォルトコンストラクタ */
        public TantosyaDummy() {
            this.SeikyuTantoFlg = false;
            this.tantosya = null;
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
        
        /** 担当者データ設定 */
        public void setTantosyaData(Contact tantosya) {

            this.TantosyaName = tantosya.Name;
            this.Department = tantosya.Department;
            this.Title = tantosya.Title;
            this.Email = tantosya.Email;
            this.SeikyuTantoFlg = tantosya.SeikyuTantoFlg__c;
            this.tantosya = tantosya;
        }

        /** 担当者データ取得（新規） */
        public Contact getInsTantosyaData(String kokyakuId) {

        	Contact ret = new Contact (AccountId=kokyakuId);
            ret.LastName = this.TantosyaName;
            ret.Department = this.Department;
            ret.Title = this.Title;
            ret.Email = this.Email;
            ret.SeikyuTantoFlg__c = this.SeikyuTantoFlg;
	    	return ret;
        }

        /** 担当者データ取得（更新） */
        public Contact getUpdTantosyaData() {

            Contact ret = this.tantosya;
            ret.LastName = this.TantosyaName;
            ret.Department = this.Department;
            ret.Title = this.Title;
            ret.Email = this.Email;
            ret.SeikyuTantoFlg__c = this.SeikyuTantoFlg;
	    	return ret;
        }

        /** 担当者データ取得（削除） */
        public Contact getDelTantosyaData() {

            Contact ret = this.tantosya;
            ret.Del_Flg__c = true;
	    	return ret;
        }
    }
}