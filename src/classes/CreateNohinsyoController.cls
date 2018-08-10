public with sharing class CreateNohinsyoController {

    /** 案件ID */
    private String ankenId;

    /** 処理対象の案件IDリスト */
    public List<String> ankenIdList;

    /** 戻り先URL */
    public String retUrl;

    /** リストビュー上で選択されたレコード */
    public List<Anken__c> records {
        get;
        private set;
    }

    /** 納品日時 */
    public Datetime nohinDateTime {
        get;
        private set;
    }

    /** 初期表示チェック結果 */
    public Boolean isInitCheck {
        get;
        private set;
    }

    /** 納品書作成フラグ */
    public Boolean isCreatePdf {
        get;
        private set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public CreateNohinsyoController() {

		// リクエストパラメータ取得
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');

        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        this.ankenIdList.add(this.ankenId);

        // 納品日時設定
        this.nohinDateTime = System.now();

        // 納品書作成フラグ初期化
        this.isCreatePdf = false;
    }

    /**
     * リストビュー上から呼ばれるコンストラクタ
     */
    public CreateNohinsyoController (ApexPages.StandardSetController controller) {

		// リクエストパラメータ取得
        this.records = (List<Anken__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');

        // 納品日時設定
        this.nohinDateTime = System.now();

        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        for (Anken__c anken : this.records) {
        	this.ankenIdList.add(anken.Id);
        	anken.Status__c = '受注納品済み';
        	if(anken.NohinDateTime__c == null){
                anken.NohinDateTime__c = this.nohinDateTime;
            }
        	anken.NohinTantosya__c = Userinfo.getUserId();
        }

        // 納品書作成フラグ初期化
        this.isCreatePdf = false;
    }

    /**
     * PDF生成（案件詳細）
     */
    public PageReference createPdf() {

		// PDF作成対象リスト生成
		List<Attachment> upsAttList = new List<Attachment> ();
        for (String aid : this.ankenIdList) {
        	upsAttList.add(this.getAttachmentPdf(aid));
        }

		// 納品書作成＆更新
		upsert upsAttList;


        // 更新対象案件リスト、マップ取得
        List<Anken__c> updAnkenList = this.getUpdateAnkenData(this.ankenIdList);
        Map<String, Anken__c> updAnkenMap = new Map<String, Anken__c> ();
        for(Anken__c item : updAnkenList) {
            // ステータスを更新
            item.Status__c = '受注納品済み';
        	updAnkenMap.put(item.Id, item);
        }

        // 案件データの見積書IDを設定
        for (Attachment attItem : upsAttList) {
        	if (updAnkenMap.containsKey(attItem.parentId)) {
        		Anken__c anken = updAnkenMap.get(attItem.parentId);
        		anken.NohinsyoId__c = attItem.Id;
        	}
        }

        // 案件データ更新
        update updAnkenList;

        // 納品書作成フラグ初期化
        this.isCreatePdf = false;

		// 案件画面へ遷移
		return new PageReference(this.retUrl);
    }

    /**
     * 案件詳細から納品書作成を実行したときのチェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG
     */
    public PageReference initCheck() {

        this.isInitCheck = true;

        // 納品情報チェック
    	if (!this.checkNohinSection(this.ankenId)) {
            this.isInitCheck = false;
    	}

        return null;
    }

    /**
     * 一括時の初期表示チェック
     */
    public PageReference initCheckAll() {

        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '納品書は送信されません。よろしいですか？'));

    	this.isInitCheck = true;

    	// 選択レコード件数が0件
        if (this.records.size() == 0) {
        	this.isInitCheck = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '選択されたレコードがありません。'));
        }

    	// 選択レコード件数が上限以上
        if (this.records.size() > Integer.valueOf(System.Label.ExecuteLimitCount_Nohinsyo)) {
        	this.isInitCheck = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '一括処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Nohinsyo + '件です。'));
        }

        // 必須チェック
        for (Anken__c anken : this.records) {
	        // 納品情報チェック
	    	if (!this.checkNohinSection(anken.Id)) {
	            isInitCheck = false;
	    	}
        }

    	return null;
    }

    /**
     * 納品情報チェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG
     */
    private Boolean checkNohinSection(String aid) {

        Boolean ret = true;

		// 案件データ取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        JuchuTotalKingaku_Tax__c, // 合計金額（税込み）
                                        StatusLock__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];

        // 合計金額（税込み）が0かどうか（一括時のみ）
        if (this.records != null && ankenList[0].JuchuTotalKingaku_Tax__c == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '合計金額（税込み）が0円です。'));
        }

        // ステータスが請求確定済み以降となっていないかチェック
        if (ankenList[0].StatusLock__c) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '請求確定済みの案件です。'));
        }

        return ret;
    }

    /**
     * 案件データの更新
     *
     * @return 更新対象案件データ
     */
    public PageReference updateAnkenData() {

        // 更新対象案件リスト取得
        List<Anken__c> updAnkenList = this.getUpdateAnkenData(this.ankenIdList);

        for(Anken__c item :updAnkenList){
            // 納品日時を更新
            if(item.NohinDateTime__c == null){
                item.NohinDateTime__c = this.nohinDateTime;
            }
            // 納品担当者
            item.NohinTantosya__c = UserInfo.getUserId();
        }

        update updAnkenList;

        // 納品書作成フラグ更新
        this.isCreatePdf = true;

        return null;
    }

    /**
     * PDF生成
     *
     * @param aid 案件Id
     * @return Attachmentオブジェクト
     */
    private Attachment getAttachmentPdf(String aid) {

		// 納品書作成
        PageReference pdf = Page.Nohinsyo;
		pdf.getParameters().put('aid', aid);

		// 既存納品書を取得
		Attachment att = null;
		List<Attachment> attList = [SELECT Id, parentId, Name, Body FROM Attachment WHERE parentId = :aid AND Name = :System.Label.NohinsyoName ORDER BY CreatedDate DESC];
		if (attList.size() > 0) {
			// update（既存納品書を更新）
	        att = attList[0];
	        att.Body = pdf.getContent();

		} else {
			// insert（新規納品書を登録）
	        att = new Attachment(parentId = aid, Name = System.Label.NohinsyoName, Body = pdf.getContent());
		}

		return att;
    }

    /**
     * 更新対象案件データの取得
     *
     * @param aidList 案件Idリスト
     * @return 更新対象案件データ
     */
    private List<Anken__c> getUpdateAnkenData(List<String> aidList) {

        // 更新対象案件データ取得
        List<Anken__c> ankenList = [SELECT Id, Name, NohinDateTime__c, NohinsyoId__c FROM Anken__c WHERE Id IN :aidList];
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