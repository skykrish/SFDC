public with sharing class TokusokuController {

    /** 検索用基本クエリ */
    private static String BASIC_QUERY = 'SELECT Id, Name, Seikyusaki__c, ShimeGroup__c, Shimebi__c, Seikyusaki__r.Name, SeikyusakiTorihikiKbn__c, Seikyugaku__c, Tax__c, Seikyugaku_Tax__c, SeikyuTantosya__c, SeikyuDateTime__c, KaisyuScheduledDate__c, SeikyuStatus__c, NyukinStatus__c, Del_Flg__c, Del_Date__c, MeisaiAmount__c, SeikyusyoId__c, PDFDowload__c, TokusokuStatus__c FROM SeikyuHeader__c';

    /** 戻り先URL */
    public String retUrl;

    /** リストビュー上で選択されたレコード */
    public List<SeikyuHeader__c> records {
        get;
        private set;
    }

    /** 処理対象の請求ヘッダリスト */
    public List<SeikyuHeader__c> sHeadList;

    /** 初期表示チェック結果 */
    public Boolean isInitCheck {
        get;
        private set;
    }

    /** 督促ステータス：督促済み */
    private static String TOKUSOKUSTATUS_TOKUSOKUZUMI = '督促済み';

    /**
     * リストビュー上から呼ばれるコンストラクタ
     */
    public TokusokuController(ApexPages.StandardSetController controller) {

		// リクエストパラメータ取得
        this.records = (List<SeikyuHeader__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        // 請求書ヘッダ情報取得
        this.sHeadList = new List<SeikyuHeader__c>();
        for (SeikyuHeader__c r : this.records){
        	SeikyuHeader__c item = new SeikyuHeader__c();
        	item = this.getSeikyuHeader(r.Id);
        	this.sHeadList.add(item);
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
        if (this.records.size() > Integer.valueOf(System.Label.ExecuteLimitCount_Tokusoku)) {
        	isInitCheck = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '一括処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Seikyusyo + '件です。'));
        }

        // 選択された請求ヘッダに請求取消された請求ヘッダ含まれる
        for(SeikyuHeader__c item: this.sHeadList){
            if(item.Del_Flg__c){
                isInitCheck = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '選択されたレコードに請求取消されたレコードが含まれています。'));
                break;
            }
        }

    	return null;
    }

    /**
     * 請求ヘッダ検索処理
     *
     * @return 請求ヘッダ
     */
    private SeikyuHeader__c getSeikyuHeader (String shid) {

        // 検索用クエリ生成
        String query = BASIC_QUERY;
        query += ' Where Id =\'' + shid + '\'';

        // 検索
        SeikyuHeader__c searchResult = database.query(query);

        // 表示用データ作成
        return searchResult;
    }

    /**
     * 貸し倒れ
     */
    public PageReference NyukinStatusUpdate() {

		// ステータスを更新
		this.NyukinStatusUpdate_For_Kasidaore();

		// 未入金一覧リスト画面へ遷移
		return new PageReference(this.retUrl);
    }

    /**
     * 督促状送付
     */
    public PageReference sendPdf() {

        // 顧客（請求先）IDをキーとした請求担当者のマップを取得
        Map<String, Contact> tantosyaMap = this.getTantosyaMap(this.sHeadList);

        // 請求書送付メールテンプレート取得
        EmailTemplate mailTemplate = this.getMailTemplate();

        // 組織のメールアドレス取得
        OrgWideEmailAddress orgAddress = this.getOrgAddress();

        // 入力チェック
        if (!this.sendValidation(this.sHeadList, tantosyaMap)) {
            return null;
        }

        // メール生成
        List<Messaging.SingleEmailMessage> sendMailList = new List<Messaging.SingleEmailMessage> ();
        for (SeikyuHeader__c item : this.sHeadList) {
            // PDF取得
            Attachment att = this.getAttachmentPdf(item.SeikyusyoId__c);
            // メール生成
            Contact seikyuTantosya = tantosyaMap.get(item.Seikyusaki__c);
            sendMailList.add(this.getEmail(item.Id, att, seikyuTantosya.Id, mailTemplate, orgAddress));
        }
        Messaging.sendEmail(sendMailList);

        // 請求ヘッダ更新（）
        List<SeikyuHeader__c> updShList = new List<SeikyuHeader__c> ();
        for (SeikyuHeader__c item : this.sHeadList) {
			// 請求ステータス、請求日時設定
            item.TokusokuDate__c = date.today();
            item.TokusokuStatus__c = TOKUSOKUSTATUS_TOKUSOKUZUMI;
            updShList.add(item);
        }
        update updShList;

        // 完了メッセージを表示
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '督促状を送付しました。'));

        return null;
    }

    /**
     * 顧客（請求先）IDをキーとした請求担当者のマップを取得する。
     *
     *　@param 表示用請求ヘッダデータリスト
     *　@return 請求担当者マップ
     */
    private Map<String, Contact> getTantosyaMap(List<SeikyuHeader__c> shList) {

        // 顧客（請求先）IDリストを作成
        Map<String, String> kokyakuIdMap = new Map<String, String> ();
        for (SeikyuHeader__c item : shList) {
            // 重複排除
            if (!kokyakuIdMap.containsKey(item.Seikyusaki__c)) {
                kokyakuIdMap.put(item.Seikyusaki__c, item.Seikyusaki__c);
            }
        }
        List<String> kokyakuIdList = kokyakuIdMap.values();

        // 担当者情報取得
        List<Contact> conList = [SELECT Id, Name, Email, AccountId FROM Contact WHERE AccountId = :kokyakuIdList AND SeikyuTantoFlg__c = true];

        // 顧客（請求先）IDをキーとした請求担当者のマップを作成
        Map<String, Contact> tantosyaMap = new Map<String, Contact> ();
        for (Contact item : conList) {
                tantosyaMap.put(item.AccountId, item);
        }

        return tantosyaMap;
    }

    /**
     * 督促状送付メールテンプレートを取得する
     *
     * @return 督促状送付メールテンプレート
     */
    private EmailTemplate getMailTemplate() {

        List<EmailTemplate> templateList = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :System.Label.TokusokuMailTemplate AND IsActive = :true];
        return templateList[0];
    }

    /**
     * 入力チェック（請求書送付時）
     *
     * @param shList 表示用請求ヘッダデータリスト
     * @param tantosyaMap 顧客（請求先）IDをキーとした請求担当者のマップ
     * @return true:OK, false:NG
     */
    private Boolean sendValidation(List<SeikyuHeader__c> shList, Map<String, Contact> tantosyaMap) {

        Boolean ret = true;

        // 宛先、PDFチェック
        for(SeikyuHeader__c item : shList) {
            // 請求担当者が設定されているか
            if (!tantosyaMap.containsKey(item.Seikyusaki__c)) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求先：' + item.Seikyusaki__r.Name + '　　' + '請求担当者が設定されていません。'));
            } else {
                // 請求担当者のメールアドレスが設定されているか
                Contact con = tantosyaMap.get(item.Seikyusaki__c);
                if (Strings.isNullOrEmpty(con.Email)) {
                    ret = false;
                    Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求先：' + item.Seikyusaki__r.Name + '　　' + '請求担当者のメールアドレスが設定されていません。'));
                }
            }
            // PDFが添付されているか
            if(Strings.isNullOrEmpty(item.SeikyusyoId__c)){
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + 'PDFが添付されていません。'));
            }
        }

        return ret;
    }

    /**
     * 組織のメールアドレスを取得
     *
     * @return 組織のメールアドレス
     */
    private OrgWideEmailAddress getOrgAddress() {

        List<OrgWideEmailAddress> orgAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];
        return orgAddressList[0];
    }

    /**
     * PDFを取得
     *
     * @param seikyusyoId 請求書Id
     * @return Attachmentオブジェクト
     */
    private Attachment getAttachmentPdf(String seikyusyoId) {

        List<Attachment> attList = [SELECT Id, parentId, Name, Body FROM Attachment WHERE Id = :seikyusyoId];
        return attList[0];
    }

    /**
     * メール生成
     *
     * @param shid 請求ヘッダId
     * @param att 添付PDF
     * @param tantosyaId 請求担当者ID
     * @param mailTemplate メールテンプレート
     * @param orgAddress 組織のメールアドレス
     * @return Messaging.SingleEmailMessageオブジェクト
     */
    private Messaging.SingleEmailMessage getEmail(String shid, Attachment att, String tantosyaId, EmailTemplate mailTemplate, OrgWideEmailAddress orgAddress) {

        // 添付ファイル作成
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(att.Name);
        efa.setBody(att.Body);

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(mailTemplate.Id);
        email.setOrgWideEmailAddressId(orgAddress.Id);
        email.setTargetObjectId(tantosyaId);
        email.setWhatId(shid);
        email.setSaveAsActivity(true);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        return email;
    }

    /**
     * 入金ステータス更新（貸し倒れ）
     */
     private void NyukinStatusUpdate_For_Kasidaore(){

     	// ステータス設定
     	List<SeikyuHeader__c> updItemList = New List<SeikyuHeader__c>();
     	for (SeikyuHeader__c updItem : this.sHeadList){
     		updItem.NyukinStatus__c = '貸し倒れ';
     		updItemList.add(updItem);
     	}
     	// 更新
     	if (updItemList.size()>0){
     		update updItemList;
     	}

     }


    /**
     * キャンセル（一括）
     */
    public PageReference cancel() {

		// 未入金一覧リスト画面へ遷移
		return new PageReference(this.retUrl);
    }
}