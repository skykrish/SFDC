public with sharing class SitesFormatTextController extends SitesAbstractController {

    /** 定型テキスト１ */
    public String formatText1 {
    	get;
    	set;
    }

    /** 定型テキスト２ */
    public String formatText2 {
    	get;
    	set;
    }

    /** 定型テキスト３ */
    public String formatText3 {
    	get;
    	set;
    }
    
    /** 顧客データ */
    private Account kokyaku;

    /**
     * デフォルトコンストラクタ
     */
    public SitesFormatTextController() {
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {
    	
    	// ユーザID取得
    	String kokyakuId = getKokyakuId();

    	// 顧客データ取得
    	this.kokyaku = this.getKokyaku(kokyakuId);
    	
    	// 定型テキスト設定
    	this.formatText1 = kokyaku.FormatText1__c;
    	this.formatText2 = kokyaku.FormatText2__c;
    	this.formatText3 = kokyaku.FormatText3__c;
    	
    	return null;
    }

    /**
     * 顧客データ取得
     *
     * @param accId 顧客ID
     * @return 顧客データ
     */
    private Account getKokyaku(String accId) {
    	
    	List<Account> accList = [SELECT Id, Name, FormatText1__c, FormatText2__c, FormatText3__c FROM Account WHERE Id = :accId];
    	return accList[0];
    }
    
    /**
     * 定型テキスト１の登録
     */
    public PageReference saveFormatText1() {
    	
    	// メッセージクリア
    	clearMessage();
    	
    	// update
    	this.kokyaku.FormatText1__c = this.formatText1;
    	update this.kokyaku;

    	// 完了メッセージ
		addMessage(MESSAGE_CLS_NORMAL, '作業指示１を登録しました。');
    	
    	return null;
    }

    /**
     * 定型テキスト２の登録
     */
    public PageReference saveFormatText2() {
    	
    	// メッセージクリア
    	clearMessage();
    	
    	// update
    	this.kokyaku.FormatText2__c = this.formatText2;
    	update this.kokyaku;

    	// 完了メッセージ
		addMessage(MESSAGE_CLS_NORMAL, '作業指示２を登録しました。');

    	return null;
    }

    /**
     * 定型テキスト３の登録
     */
    public PageReference saveFormatText3() {
    	
    	// メッセージクリア
    	clearMessage();
    	
    	// update
    	this.kokyaku.FormatText3__c = this.formatText3;
    	update this.kokyaku;

    	// 完了メッセージ
		addMessage(MESSAGE_CLS_NORMAL, '作業指示３を登録しました。');

    	return null;
    }

}