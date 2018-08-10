public with sharing class SitesMypageControllerRakuten extends SitesAbstractControllerRakuten {

    /**
     * デフォルトコンストラクタ
     */
    public SitesMypageControllerRakuten() {
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
    	PageReference nextPage = getNextPage('SitesOrderlistRakuten');
    	return nextPage;
    }

    /**
     * お客様情報の変更
     */
    public PageReference useredit() {
    	
    	// 遷移
    	PageReference nextPage = getNextPage('SitesUsereditRakuten');
    	return nextPage;
    }

    /**
     * パスワードの変更
     */
    public PageReference password() {
    	
    	// 遷移
    	PageReference nextPage = getNextPage('SitesPasswordRakuten');
    	return nextPage;
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