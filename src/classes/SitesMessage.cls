public with sharing class SitesMessage {

	/** メッセージタイプ */
	public String cls {get; set;}

	/** メッセージ */
	public String msg {get; set;}

    /**
     * デフォルトコンストラクタ
     */
    public SitesMessage() {
    }

    /**
     * コンストラクタ
     *
     * @param cls メッセージタイプ
     * @param msg メッセージ
     */
    public SitesMessage(String cls, String msg) {
    	this.cls = cls;
    	this.msg = msg;
    }

}