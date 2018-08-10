public with sharing class CreateMitsumorisyoController {

    /** 案件ID */
    public String ankenId;

    /** 処理対象の案件IDリスト */
    public List<String> ankenIdList;

    /** 戻り先URL */
    public String retUrl;

	/** リストビュー上で選択されたレコード */
    public List<Anken__c> records {
    	get;
    	private set;
    }

    /** 初期表示チェック結果 */
    public Boolean isInitCheck {
    	get;
    	private set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public CreateMitsumorisyoController() {

		// リクエストパラメータ取得
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        this.ankenIdList.add(this.ankenId);
    }

    /**
     * リストビュー上から呼ばれるコンストラクタ
     */
    public CreateMitsumorisyoController (ApexPages.StandardSetController controller) {

		// リクエストパラメータ取得
        this.records = (List<Anken__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        for (Anken__c anken : this.records) {
        	this.ankenIdList.add(anken.Id);
        }
    }

    /**
     * 一括時の初期表示チェック
     */
    public PageReference initCheck() {
    	
    	this.isInitCheck = true;
    	
    	// 選択レコード件数が0件
        if (this.records.size() == 0) {
        	this.isInitCheck = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '選択されたレコードがありません。'));
        }
    	
    	// 選択レコード件数が上限以上
        if (this.records.size() > Integer.valueOf(System.Label.ExecuteLimitCount_Mitsumorisyo)) {
        	isInitCheck = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '一括処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Mitsumorisyo + '件です。'));        
        }

    	return null;
    }

    /**
     * PDF生成
     */
    public PageReference createPdf() {

		// PDF作成対象リスト生成
		List<Attachment> upsAttList = new List<Attachment> ();
        for (String aid : this.ankenIdList) {
        	upsAttList.add(this.getAttachmentPdf(aid));
        }

		// 見積書作成＆更新
		upsert upsAttList;

        // 更新対象案件リスト、マップ取得
        List<Anken__c> updAnkenList = this.getUpdateAnkenData(this.ankenIdList);
        Map<String, Anken__c> updAnkenMap = new Map<String, Anken__c> ();
        for(Anken__c item : updAnkenList) {
        	updAnkenMap.put(item.Id, item);
        }
        
        // 案件データの見積書IDを設定
        for (Attachment attItem : upsAttList) {
        	if (updAnkenMap.containsKey(attItem.parentId)) {
        		Anken__c anken = updAnkenMap.get(attItem.parentId);
        		anken.MitsumorisyoId__c = attItem.Id;
        	}
        }

        // 案件データ更新
        update updAnkenList;

		// 案件画面へ遷移
		return new PageReference(this.retUrl);
    }

    /**
     * PDF生成
     * 
     * @param aid 案件Id
     * @return Attachmentオブジェクト
     */
    private Attachment getAttachmentPdf(String aid) {
    	
		// 見積書作成
        PageReference pdf = Page.Mitsumorisyo;
		pdf.getParameters().put('aid', aid);
		
		// 既存見積書を取得
		Attachment att = null;
		List<Attachment> attList = [SELECT Id, parentId, Name, Body FROM Attachment WHERE parentId = :aid AND Name = :System.Label.MitsumorisyoName ORDER BY CreatedDate DESC];
		if (attList.size() > 0) {
			// update（既存見積書を更新）
	        att = attList[0];
	        att.Body = pdf.getContent();
			
		} else {
			// insert（新規見積書を登録）
	        att = new Attachment(parentId = aid, Name = System.Label.MitsumorisyoName, Body = pdf.getContent());
		}

		return att;
    }

    /**
     * 更新対象案件データの取得
     * 
     * @param aid 案件Id
     * @return 更新対象案件データ
     */
    private List<Anken__c> getUpdateAnkenData(List<String> aidList) {
        
        // 更新対象案件データ取得
        List<Anken__c> ankenList = [SELECT Id, Name, MitsumorisyoId__c FROM Anken__c WHERE Id IN :aidList];
        return ankenList;
    }

    /**
     * キャンセル（一括）
     */
    public PageReference cancel() {

		// 案件リスト画面へ遷移
		return new PageReference(this.retUrl);
    }

}