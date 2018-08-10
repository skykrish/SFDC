public with sharing class AnkenRegisterController {

    /** 顧客ID */
    private String kokyakuId;

    /** 担当者ID */
    private String tantosyaId;

    /** 戻り先URL */
    public String retUrl {
        get;
        private set;
    }
    
    /** ファイルサーバURL（Win用）*/
    public String WinUrl {get; set;}
    
    /** ファイルサーバURL（mac用）*/
    public String MacUrl {get; set;}

    /** 案件データ */
    public Anken__c anken {
        get;
        set;
    }
    
    /** 顧客データ */
    public Account kokyaku {
        get;
        set;    
    }
    
    /** 担当者選択リストオプション */
    public List<SelectOption> tantosyaSelectOptions {
        get;
        private set;
    }

    /** 発注タイミング選択リストオプション */
    public List<SelectOption> HatyutaiminguSelectOptions {
        get;
        private set;
    }
    
    /**
     * 標準コンストラクタ
     */
    public AnkenRegisterController () {

        // リクエストパラメータ取得
        this.kokyakuId = ApexPages.currentPage().getParameters().get('aid');
        this.tantosyaId = ApexPages.currentPage().getParameters().get('cid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
    }

    /**
     * 初期化処理
     */
    public PageReference init() {

        // 顧客データ取得
        this.kokyaku = this.getKokyakuData(this.kokyakuId);

        // 担当者データ取得
        List<Contact> tantosyaList = this.getTantosyaData(this.kokyakuId);

        // 担当者選択リスト取得
        this.tantosyaSelectOptions = this.getTantosyaSelectOptions(tantosyaList);
        
        

        // 案件データ生成
        this.anken = new Anken__c();
        this.anken.KokyakuName__c = this.kokyakuId;
        this.anken.KokyakuTantosya_Main__c = this.tantosyaId;
        this.anken.SagyoNaiyo__c = kokyaku.SagyoNaiyo__c;
        this.anken.SagyoNaiyo_1__c = kokyaku.SagyoNaiyo_1__c;
        this.anken.SagyoNaiyo_2__c = kokyaku.SagyoNaiyo_2__c;
        this.anken.Sagyoshiji_Renrakujiko__c = kokyaku.Sagyoshiji_Renrakujiko__c;
        this.anken.SampleKokyakuFlg__c = kokyaku.SampleKokyakuFlg__c;
        this.anken.PC__c = kokyaku.PC__c;
        this.anken.Hatyutaimingu__c = kokyaku.Mitsumori__c;
        this.anken.firestorage__c = kokyaku.firestorage__c;
        // add start　20180410
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
        
        this.WinUrl = 'file://' + Kokyaku.LocalIP__c + '/MBOusers/' + Kokyaku.KokyakuId__c; //ファイルサーバURL（Win用）の数式項目と同様
        this.MacUrl = 'afp://' + Kokyaku.KokyakuId__c + ':' + Kokyaku.KokyakuPw__c + '@' + Kokyaku.LocalIP__c; //ファイルサーバURL（Mac用）の数式項目と同様
        
        return null;
    }

    /**
     * 顧客データ取得
     *
     * @param kokyakuId 顧客ID
     * @return 顧客データ
     */
    private Account getKokyakuData(String kokyakuId) {

        List<Account> kokyakuList = [SELECT
                                         Id,
                                         Name,
                                         SagyoNaiyo__c,
                                         SagyoNaiyo_1__c,
                                         SagyoNaiyo_2__c,
                                         Sagyoshiji_Renrakujiko__c,
                                         SampleKokyakuFlg__c,
                                         PC__c,
                                         IchiritsuKakakuKokyakuFkg__c,
                                         Mitsumori__c,
                                         BoxSync__c,
                                         
                                         KokyakuId__c, //URL用の値
                                         KokyakuPw__c,
                                         LocalIP__c,
                                         // add start 20180410
                                         ColorMode__c,
                                         ClippingPath__c,
                                         ClippingPathName__c,
                                         FileFormat__c,
                                         Resolution__c,
                                         Nihondeno_nouhin__c,
                                         Background__c,
                                         Flatness__c,
                                         Margin__c,
                                         // add end 20180410
                                         firestorage__c
                                          
                                     FROM
                                         Account
                                     WHERE
                                         Id = :kokyakuId];

        return kokyakuList[0];
    }

    /**
     * 担当者データ取得
     *
     * @param kokyakuId　顧客ID
     *　@return 担当者データ
     */
    private List<Contact> getTantosyaData(String kokyakuId) {

        // 担当者データ取得
        List<Contact> tantosyaList = [SELECT
                                          Id,
                                          Name
                                      FROM
                                          Contact
                                      WHERE
                                          AccountId = :kokyakuId AND
                                          Del_Flg__c = false
                                     ORDER BY
                                         MainTantoFlg__c DESC,
                                         Name];

        return tantosyaList;
    }

    /**
     * 担当者選択リスト取得
     *
     * @param tantosyaList　担当者データ
     *　@return 担当者選択リストオプション
     */
    private List<SelectOption> getTantosyaSelectOptions(List<Contact> tantosyaList) {

        // 担当者選択リストオプション生成
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--なし--'));

        for (Contact item : tantosyaList) {
            options.add(new SelectOption(item.Id, item.Name));
        }

        return options;
    }

    /**
     * 保存
     */
    public PageReference save() {

        // 受注日時の必須チェック
        if(!this.juchuDateRequiredCheck()){
            return null;
        }

        // 案件データ登録
        insert this.anken;

        // 案件データの詳細画面へ遷移
        return new PageReference('/' + this.anken.Id);
    }

    /**
     * 保存＆新規
     */
    public PageReference saveNew() {

        // 受注日時の必須チェック
        if(!this.juchuDateRequiredCheck()){
            return null;
        }

        // 案件データ登録
        insert this.anken;

        // 完了メッセージ設定
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '案件を登録しました。'));

        // リクエストパラメータ設定
        PageReference nextPage = new PageReference('/apex/AnkenRegister');
        nextPage.getParameters().put('aid', this.kokyakuId);
        if (this.tantosyaId != null) {
            nextPage.getParameters().put('cid', this.tantosyaId);
        }
        nextPage.getParameters().put('retUrl', this.retUrl);

        // 案件登録画面へ遷移
        return nextPage;
    }

    /**
     * 受注日時の必須チェック
     */
    private Boolean juchuDateRequiredCheck(){

        if(anken.JuchuDateTime__c == null){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '受注日時が入力されていません。'));
            return false;
        }

        return true;
    }

    /**
     * キャンセル
     */
    public PageReference cancel() {

        // 呼出元に遷移
        return new PageReference(this.retUrl);
    }
}