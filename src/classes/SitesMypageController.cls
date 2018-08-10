public with sharing class SitesMypageController extends SitesAbstractController {

    /**
     * デフォルトコンストラクタ
     */
    public SitesMypageController() {
    }

    /**
     * 個別初期化処理
     */
    public override PageReference individualInit() {
    	return null;
    }

    /**
     * ご利用履歴
     */
    public PageReference orderlist() {
    	
    	// 遷移
    	PageReference nextPage = getNextPage('orderlist');
    	return nextPage;
    }

    /**
     * ご請求履歴
     */
    public PageReference billing() {
    	
    	// 遷移
    	PageReference nextPage = getNextPage('billing');
    	return nextPage;
    }

    /**
     * お客様情報の変更
     */
    public PageReference useredit() {
    	
    	// 遷移
    	PageReference nextPage = getNextPage('useredit');
    	return nextPage;
    }

    /**
     * クレジットカード情報の変更
     */
    public PageReference creditcardedit() {
    	
    	// 遷移
    	PageReference nextPage = getNextPage('creditcardedit');
    	return nextPage;
    }

    /**
     * パスワードの変更
     */
    public PageReference password() {
    	
    	// 遷移
    	PageReference nextPage = getNextPage('password');
    	return nextPage;
    }
    
    /**
     * 発注フォーム
     */
    public PageReference order() {

    	// 遷移
    	PageReference nextPage = getNextPage('order');
    	return nextPage;
    }
}