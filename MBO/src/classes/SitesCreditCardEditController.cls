public with sharing class SitesCreditCardEditController extends SitesAbstractController{
    
    /**
     * 顧客データ
     */
    public KokyakuDummy kokyaku {
        get; set;
    }
    
    /**
     * 表示用顧客データ（確認画面で使用）
     */
    public List<KokyakuDummy> dispKokyakuList {
        get;
        private set;
    }
    
    /**
     * デフォルトコンストラクタ
     */
    public SitesCreditCardEditController() {
    }
    
    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {
        
        // 顧客ID取得
        String kokyakuId = getKokyakuId();

        // 変更用顧客データ取得
        this.kokyaku = this.getKokyakuData(kokyakuId);

        
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
        
        this.dispKokyakuList = new List<KokyakuDummy> ();
        // 確認モードに切り替え
        dispMode = DISP_MODE_CONFIRM;
        return null;
    }
    
    /**
     * 入力チェック
     * @return OK:true, NG:false
     */
    private Boolean validate() {
        
        boolean retMain = true;
        boolean retSub1 = true;
        boolean retSub2 = true;
        
        // クレジットカードメイン
        retMain = creditCardCheck(this.kokyaku.CardCompany,
                              this.kokyaku.CardNo1,
                              this.kokyaku.CardNo2,
                              this.kokyaku.CardNo3,
                              this.kokyaku.CardNo4,
                              this.kokyaku.CardLimitMM,
                              this.kokyaku.CardLimitYY,
                              this.kokyaku.CardOwner);
        // クレジットカードサブ１
        retSub1 = creditCardCheck(this.kokyaku.CardCompanySub1,
                              this.kokyaku.CardNo1Sub1,
                              this.kokyaku.CardNo2Sub1,
                              this.kokyaku.CardNo3Sub1,
                              this.kokyaku.CardNo4Sub1,
                              this.kokyaku.CardLimitMMSub1,
                              this.kokyaku.CardLimitYYSub1,
                              this.kokyaku.CardOwnerSub1);
        // クレジットカードサブ２
        retSub2 = creditCardCheck(this.kokyaku.CardCompanySub2,
                              this.kokyaku.CardNo1Sub2,
                              this.kokyaku.CardNo2Sub2,
                              this.kokyaku.CardNo3Sub2,
                              this.kokyaku.CardNo4Sub2,
                              this.kokyaku.CardLimitMMSub2,
                              this.kokyaku.CardLimitYYSub2,
                              this.kokyaku.CardOwnerSub2);
        
        // 全てがtrueならtrueを返す
        if (retMain && retSub1 && retSub2){
            return true;
        }else {
            return false;
        }
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
        
        // 顧客ID取得
        String kokyakuId = getKokyakuId();
        
        // 顧客データ変更
        Account kokyaku = this.getUpdKokyakuData(kokyakuId, this.kokyaku);
        update kokyaku;
        
        // 結果モードに切り替え
        dispMode = DISP_MODE_RESULT;
        return null;
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
     * 更新対象顧客データ取得
     * @param kokyakuId 顧客ID
     * @param kokyaku 変更用顧客データ
     * @return 更新用の顧客データ
     */
    private Account getUpdKokyakuData(String kokyakuId, KokyakuDummy kokyaku) {
         
        // 顧客データ取得
        List<Account> updList = [SELECT
                                     Id,
                                     Name,
                                     CardCompany__c,
                                     CardCompanySub1__c,
                                     CardCompanySub2__c,
                                     CardNo__c,
                                     CardNoSub1__c,
                                     CardNoSub2__c,
                                     CardOwner__c,
                                     CardOwnerSub1__c,
                                     CardOwnerSub2__c,
                                     CardLimit__c,
                                     CardLimitSub1__c,
                                     CardLimitSub2__c
                                     
                                 FROM
                                     Account
                                 WHERE
                                     Id = :kokyakuId];
                                     
        // 更新情報設定
        // クレジットカード（メイン）
        updList[0].CardCompany__c = kokyaku.CardCompany;
        updList[0].CardNo__c = kokyaku.CardNo1 + kokyaku.CardNo2 + kokyaku.CardNo3 + kokyaku.CardNo4;
        updList[0].CardLimit__c = cardLimit(kokyaku.CardLimitMM, kokyaku.CardLimitYY);
        updList[0].CardOwner__c = kokyaku.CardOwner;
        
        // クレジットカード（サブ１）
        updList[0].CardCompanySub1__c = kokyaku.CardCompanySub1;
        updList[0].CardNoSub1__c = kokyaku.CardNo1Sub1 + kokyaku.CardNo2Sub1 + kokyaku.CardNo3Sub1 + kokyaku.CardNo4Sub1;
        updList[0].CardLimitSub1__c = cardLimit(kokyaku.CardLimitMMSub1, kokyaku.CardLimitYYSub1);
        updList[0].CardOwnerSub1__c = kokyaku.CardOwnerSub1;
        
        // クレジットカード（サブ２）
        updList[0].CardCompanySub2__c = kokyaku.CardCompanySub2;
        updList[0].CardNoSub2__c = kokyaku.CardNo1Sub2 + kokyaku.CardNo2Sub2 + kokyaku.CardNo3Sub2 + kokyaku.CardNo4Sub2;
        updList[0].CardLimitSub2__c = cardLimit(kokyaku.CardLimitMMSub2, kokyaku.CardLimitYYSub2);
        updList[0].CardOwnerSub2__c = kokyaku.CardOwnerSub2;
        
        
        return updList[0];
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
                                     CardCompany__c,
                                     CardCompanySub1__c,
                                     CardCompanySub2__c,
                                     CardNo__c,
                                     CardNoSub1__c,
                                     CardNoSub2__c,
                                     CardOwner__c,
                                     CardOwnerSub1__c,
                                     CardOwnerSub2__c,
                                     CardLimit__c,
                                     CardLimitSub1__c,
                                     CardLimitSub2__c
                                     
                                 FROM
                                     Account
                                 WHERE
                                     Id = :kokyakuId];
        
        // 変更用顧客データ生成
        KokyakuDummy kokyakuData = new KokyakuDummy();
        kokyakuData.setKokyakuData(accList[0]);
        
        return kokyakuData;
    }
    
    
    /* このままだとカードの有効期限が空白のときも「/」が出力されてしまうので
     * カードの有効期限チェック
     * @param yy(有効期限 年)
     * @param mm(有効期限 月)
     * @return ret(カード有効期限)
     */
    private String cardLimit(String mm, String yy){
        String ret;
        if(yy == null || yy.length() == 0){
            ret = null;
        }else {
            ret = mm + '/' + yy;
        }
        
        return ret;
    }
    
    /* クレジットカード情報チェック
     * @param CardCompany(カード会社)
     * @param CardNo1(カード番号１)
     * @param CardNo2(カード番号２)
     * @param CardNo3(カード番号３)
     * @param CardNo4(カード番号４)
     * @param CardLimitMM(カード有効期限月)
     * @param CardLimitYY(カード有効期限年)
     * @param CardOwner(カード名義)
     * @return check(正しく入力されている場合true,そうでない場合false)
     */
    private boolean creditCardCheck(String CardCompany,
                                    String CardNo1,
                                    String CardNo2,
                                    String CardNo3,
                                    String CardNo4,
                                    String CardLimitMM,
                                    String CardLimitYY,
                                    String CardOwner){
        boolean check = true;
        
        // 項目のどこかに入力がある場合
        if (!Strings.isNullOrEmpty(CardCompany) ||
            !Strings.isNullOrEmpty(CardNo1)     ||
            !Strings.isNullOrEmpty(CardNo2)     ||
            !Strings.isNullOrEmpty(CardNo3)     ||
            !Strings.isNullOrEmpty(CardNo4)     ||
            !Strings.isNullOrEmpty(CardLimitMM) ||
            !Strings.isNullOrEmpty(CardLimitYY) ||
            !Strings.isNullOrEmpty(CardOwner)) {
            // カード会社：必須チェック
            if (Strings.isNullOrEmpty(CardCompany)) {
                check = false;
                addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード会社が指定されていません。');
            }
            // カード番号：必須チェック
            if (Strings.isNullOrEmpty(CardNo1) ||
                Strings.isNullOrEmpty(CardNo2) ||
                Strings.isNullOrEmpty(CardNo3) ||
                Strings.isNullOrEmpty(CardNo4)
            ) {
                check = false;
                addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード番号が入力されていません。');
             } else {
                // カード番号：形式チェック（半角数値13～16文字でなりたっているかだけチェック）
                if (!Strings.isCreditCardNo(CardNo1, CardNo2, CardNo3, CardNo4)) {
                    check = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード番号の形式が正しくありません。');
                }
            }
            // カード有効期限：必須チェック
            if (Strings.isNullOrEmpty(CardLimitMM) ||
                Strings.isNullOrEmpty(CardLimitYY)
            ) {
                check = false;
                addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード有効期限が入力されていません。');
            } else {
                // カード有効期限：形式チェック
                String code = '20' + CardLimitYY + '/' + CardLimitMM + '/' + '01';
                if (!Strings.isDate(code)) {
                    check = false;
                    addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード有効期限の形式が正しくありません。');
                }
            }
            // カード名義人：必須チェック
            if (Strings.isNullOrEmpty(CardOwner)) {
                check = false;
                addMessage(MESSAGE_CLS_ERROR, '[お支払方法]  カード名義人が入力されていません。');
            }
        }
        return check;
    }
    
    /**
     * 変更用顧客クラス
     */
    public class KokyakuDummy {
        
        /**
         * メインクレジットカード
         */
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
        
        
        /**
         * サブ１クレジットカード
         */
        /** カード会社（サブ１） */
        public String CardCompanySub1 {get; set;}
        /** カード番号１（サブ１） */
        public String CardNo1Sub1 {get; set;}
        /** カード番号２（サブ１） */
        public String CardNo2Sub1 {get; set;}
        /** カード番号３（サブ１） */
        public String CardNo3Sub1 {get; set;}
        /** カード番号４（サブ１） */
        public String CardNo4Sub1 {get; set;}
        /** カード有効期限（年）（サブ１） */
        public String CardLimitYYSub1 {get; set;}
        /** カード有効期限（月）（サブ１） */
        public String CardLimitMMSub1 {get; set;}
        /** カード名義人（サブ１） */
        public String CardOwnerSub1 {get; set;}
        
        
        /**
         * サブ２クレジットカード
         */
        /** カード会社（サブ２） */
        public String CardCompanySub2 {get; set;}
        /** カード番号１（サブ２） */
        public String CardNo1Sub2 {get; set;}
        /** カード番号２（サブ２） */
        public String CardNo2Sub2 {get; set;}
        /** カード番号３（サブ２） */
        public String CardNo3Sub2 {get; set;}
        /** カード番号４（サブ２） */
        public String CardNo4Sub2 {get; set;}
        /** カード有効期限（年）（サブ２） */
        public String CardLimitYYSub2 {get; set;}
        /** カード有効期限（月）（サブ２） */
        public String CardLimitMMSub2 {get; set;}
        /** カード名義人（サブ２） */
        public String CardOwnerSub2 {get; set;}

        /** デフォルトコンストラクタ */
        public KokyakuDummy() {
        }
        
        /** 顧客データ設定 */
        public void setKokyakuData(Account kokyaku) {
            
            // クレジットカード（メイン）
            this.CardCompany = kokyaku.CardCompany__c;
            if(!Strings.isNullOrEmpty(kokyaku.CardNo__c) && kokyaku.CardNo__c.length() > 12){
                this.CardNo1 = this.cardNo(kokyaku.CardNo__c, 0, 4);
                this.CardNo2 = this.cardNo(kokyaku.CardNo__c, 4, 8);
                this.CardNo3 = this.cardNo(kokyaku.CardNo__c, 8, 12);
                this.CardNo4 = this.cardNo(kokyaku.CardNo__c, 12, kokyaku.CardNo__c.length());
            }
            this.CardLimitMM = this.split(kokyaku.CardLimit__c, 0, '/');
            this.CardLimitYY = this.split(kokyaku.CardLimit__c, 1, '/');
            this.CardOwner = kokyaku.CardOwner__c;
            
            // クレジットカード（サブ１）
            this.CardCompanySub1 = kokyaku.CardCompanySub1__c;
            if(!Strings.isNullOrEmpty(kokyaku.CardNoSub1__c) && kokyaku.CardNoSub1__c.length() > 12){
                this.CardNo1Sub1 = this.cardNo(kokyaku.CardNoSub1__c, 0, 4);
                this.CardNo2Sub1 = this.cardNo(kokyaku.CardNoSub1__c, 4, 8);
                this.CardNo3Sub1 = this.cardNo(kokyaku.CardNoSub1__c, 8, 12);
                this.CardNo4Sub1 = this.cardNo(kokyaku.CardNoSub1__c, 12, kokyaku.CardNoSub1__c.length());
            }
            this.CardLimitMMSub1 = this.split(kokyaku.CardLimitSub1__c, 0, '/');
            this.CardLimitYYSub1 = this.split(kokyaku.CardLimitSub1__c, 1, '/');
            this.CardOwnerSub1 = kokyaku.CardOwnerSub1__c;
            
            // クレジットカード（サブ２）
            this.CardCompanySub2 = kokyaku.CardCompanySub2__c;
            if(!Strings.isNullOrEmpty(kokyaku.CardNoSub2__c) && kokyaku.CardNoSub2__c.length() > 12){
                this.CardNo1Sub2 = this.cardNo(kokyaku.CardNoSub2__c, 0, 4);
                this.CardNo2Sub2 = this.cardNo(kokyaku.CardNoSub2__c, 4, 8);
                this.CardNo3Sub2 = this.cardNo(kokyaku.CardNoSub2__c, 8, 12);
                this.CardNo4Sub2 = this.cardNo(kokyaku.CardNoSub2__c, 12, kokyaku.CardNoSub2__c.length());
            }
            this.CardLimitMMSub2 = this.split(kokyaku.CardLimitSub2__c, 0, '/');
            this.CardLimitYYSub2 = this.split(kokyaku.CardLimitSub2__c, 1, '/');
            this.CardOwnerSub2 = kokyaku.CardOwnerSub2__c;
        }
        
        /** スプリットして取得 */
        private String split(String target, Integer cnt, String Mark) {
            String ret = null;
            if(!Strings.isNullOrEmpty(target)) {
                List<String> targetList = target.split(Mark);
                if (targetList.size() > cnt) {
                   ret = targetList[cnt];
                }
            }
            return ret;
        }
        
        /** カードの番号を分解 */
        private String cardNo(String target, Integer beginNum, Integer endNum){
            String ret = null;
            if(!Strings.isNullOrEmpty(target)) {
                ret = target.substring(beginNum , endNum);
            }
            return ret;
        }
    }
}