public with sharing class SitesMitsumoriKakuteiController extends SitesAbstractController {

    // 定数
    /** 見積自動確定用IDの区切り文字 */
    private static String QUOTATION_ID_DELIMITER = '@';
    /** 案件ステータス：見積回答待ち*/
    private static String STATUS_MITSUMORI_KAITOMACHI = '見積回答待ち';
    /** 案件ステータス：受注 */
    private static String STATUS_JUCYU = '受注';
    /** 案件ステータス：キャンセル */
    private static String STATUS_CANCEL = 'キャンセル';
    /** 処理区分：確定 */
    private static String EXEC_TYPE_COMMIT = 'commit';
    /** 処理区分：キャンセル */
    private static String EXEC_TYPE_CANCEL = 'cancel';
    /** 更新元：Sites */
    private static String UPDATED_BY_SITES = 'sites-mitsumori-kakutei';

    // クラス変数
    /** 見積自動確定用ID */
    private String quotationId;
    
    /** 処理区分 */
    private String execType;
    
    /** 案件データ */
    public Anken__c anken {
    	get;
    	private set;
    }
    
    /**
     * デフォルトコンストラクタ
     */
    public SitesMitsumoriKakuteiController() {
    	
    	// リクエストパラメータ取得
    	this.quotationId = ApexPages.currentPage().getParameters().get('aid');
    	this.execType = ApexPages.currentPage().getParameters().get('type');
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
    	
    	// 案件初期化
    	this.anken = null;
    	
    	// メッセージクリア
    	clearMessage();
  		
  		try {
	    	// リクエストパラメータチェック
	    	if (Strings.isNullOrEmpty(this.quotationId) || Strings.isNullOrEmpty(this.execType)) {
		   		addMessage(MESSAGE_CLS_ERROR, '見積回答できませんでした。');
	    		addMessage(MESSAGE_CLS_ERROR, 'URLが正しくありません。');
	    		
	    		return null;
	    	}
	
	    	// 見積自動確定用IDを復号化し
	    	// 案件ID、見積日時を取得
	        String[] decryptStrs = Strings.decryptString(this.quotationId).split(QUOTATION_ID_DELIMITER);
	        String aid = decryptStrs[0];
	        Datetime mitsumoriTime = Datetime.valueOf(decryptStrs[1]);
	        
	        // 案件データ取得
	        this.anken = this.getAnken(aid);
	        
	        // 案件データ存在チェック
	        if (this.anken == null) {
		   		addMessage(MESSAGE_CLS_ERROR, '見積回答できませんでした。');
	    		addMessage(MESSAGE_CLS_ERROR, '案件データを取得できません。');

	    		return null;
	        }
	        
	        // 案件見積回答日時チェック
	        if (this.anken.MitsumoriReplyDate__c != null) {
		   		addMessage(MESSAGE_CLS_ERROR, '見積回答できませんでした。');
	    		addMessage(MESSAGE_CLS_ERROR, '既に回答済みです。');

	    		return null;
	        }
	
	        // 案件見積有効期限チェック
	        if (this.anken.YukoDate__c < Date.today()) {
		   		addMessage(MESSAGE_CLS_ERROR, '見積回答できませんでした。');
	    		addMessage(MESSAGE_CLS_ERROR, '有効期限を過ぎています。');

	    		return null;
	        }
	
	        // 案件ステータスチェック
	        if (this.anken.Status__c != STATUS_MITSUMORI_KAITOMACHI) {
		   		addMessage(MESSAGE_CLS_ERROR, '見積回答できませんでした。');
	    		addMessage(MESSAGE_CLS_ERROR, '案件データのステータスが「見積回答待ち」ではありません。');

	    		return null;
	        }
	        
	        // 案件ステータス更新
	        if (this.execType == EXEC_TYPE_COMMIT) {
	        	// 確定
	        	this.anken.Status__c = STATUS_JUCYU;
	        	this.anken.MitsumoriReplyDate__c = Datetime.now();
	            this.anken.JuchuDateTime__c = Datetime.now();
	        	this.anken.WhoUpdated__c = UPDATED_BY_SITES;
	        	
	        } else {
	        	// キャンセル
	        	this.anken.Status__c = STATUS_CANCEL;
	        	this.anken.MitsumoriReplyDate__c = Datetime.now();
	        	this.anken.WhoUpdated__c = UPDATED_BY_SITES;
	        }
	        update this.anken;

  		} catch (Exception e) {
  			// システムエラー
	   		addMessage(MESSAGE_CLS_ERROR, 'システムエラーが発生しました。');
    		addMessage(MESSAGE_CLS_ERROR, e.getMessage());
    		
    		return null;
  		}
  		
  		// 終了メッセージ
   		addMessage(MESSAGE_CLS_NORMAL, '見積回答を受け付けました。');
  		
    	return null;
    }
    
    /**
     * 案件データ取得
     *
     * @param aid 案件ID
     * @return 案件データ（取得できない場合はnullを返す）
     */
    private Anken__c getAnken(String aid) {
    	
    	Anken__c anken = null;
    	
    	List<Anken__c> ankenList = [SELECT
    	                                Id,
    	                                Name,
    	                                AnkenName__c,
    	                                Status__c,
    	                                MitsumoriDateTime__c,
    	                                MitsumoriReplyDate__c,
    	                                YukoDate__c,
    	                                WhoUpdated__c
    	                            FROM
    	                                Anken__c
    	                            WHERE
    	                                Id = :aid];
    	
    	// 取得できない場合はnull
    	if (ankenList.size() > 0) {
    		anken = ankenList[0];
    	}
    	
    	return anken;
    }
    
}