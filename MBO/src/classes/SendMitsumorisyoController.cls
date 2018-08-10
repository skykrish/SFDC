public with sharing class SendMitsumorisyoController {

    /** 見積回答URL */
    private static String QUOTATION_URL = 'https://kirinuki.secure.force.com/quotation';

    /** 案件ID */
    private String ankenId;

    /** 処理対象の案件IDリスト */
    private List<String> ankenIdList;

    /** 戻り先URL */
    private String retUrl;

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

    /** start add 2016/03/09 **/
    /** ユーザー別名 */
    private String userAlias;
    /** end add 2016/03/09 **/

    /**
     * デフォルトコンストラクタ
     */
    public SendMitsumorisyoController() {

        // リクエストパラメータ取得
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        this.ankenIdList.add(this.ankenId);

        /** start add 2016/03/09 **/
        // ユーザ取得
        this.userAlias = '';
        User user = [ SELECT Id, Name, Alias 
                                              FROM User 
                                              WHERE Id = : UserInfo.getUserId() 
                                            ];

        if(user != null){
            this.userAlias = user.Alias;
        }
        /** end add 2016/03/09 **/

    }

    /**
     * リストビュー上から呼ばれるコンストラクタ
     */
    public SendMitsumorisyoController (ApexPages.StandardSetController controller) {

        // リクエストパラメータ取得
        this.records = (List<Anken__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        for (Anken__c anken : this.records) {
            this.ankenIdList.add(anken.Id);
        }
        /** start add 2016/03/15 **/
        // ユーザ取得
        this.userAlias = '';
        User user = [ SELECT Id, Name, Alias 
                                              FROM User 
                                              WHERE Id = : UserInfo.getUserId() 
                                            ];

        if(user != null){
            this.userAlias = user.Alias;
        }
        /** end add 2016/03/15 **/
    }

    /**
     * 案件詳細から見積書送付を実行したときのチェック
     */
    public PageReference initCheck() {
        
        this.isInitCheck = true;
        
        // 宛先チェック
        if (!this.checkMainAddress(this.ankenId)) {
            this.isInitCheck = false;
        }

        // 見積情報チェック
        if (!this.checkMitsumoriSection(this.ankenId)) {
            this.isInitCheck = false;
        }
        
        return null;
    }

    /**
     * 一括時の初期表示チェック
     */
    public PageReference initCheckAll() {
        
        this.isInitCheck = true;
        
        // 選択レコード件数が0件
        if (this.records.size() == 0) {
            this.isInitCheck = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '選択されたレコードがありません。'));
        }
        
        // 選択レコード件数が上限以上
        if (this.records.size() > Integer.valueOf(System.Label.ExecuteLimitCount_Mitsumorisyo)) {
            this.isInitCheck = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '一括処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Mitsumorisyo + '件です。'));        
        }
        
        // 宛先、見積情報チェック
        for (Anken__c anken : this.records) {
            // 宛先チェック
            if (!this.checkMainAddress(anken.Id)) {
                this.isInitCheck = false;
            }

            // チェック
            if (!this.checkMitsumoriSection(anken.Id)) {
                this.isInitCheck = false;
            }
        }

        return null;
    }
    
    /**
     * 顧客担当者（主）の宛先チェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG 
     */
    private Boolean checkMainAddress(String aid) {
        
        Boolean ret = true;

        // 案件データ取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        KokyakuTantosya_Main__c,
                                        KokyakuTantosya_Main__r.Email
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];


        // 顧客担当者（主）が設定されているか
        if (Strings.isNullOrEmpty(ankenList[0].KokyakuTantosya_Main__c)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '顧客担当者（主）が設定されていません。'));

        } else {
            // 顧客担当者（主）のメールアドレスが設定されているか
            if (Strings.isNullOrEmpty(ankenList[0].KokyakuTantosya_Main__r.Email)) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '顧客担当者（主）のメールアドレスが設定されていません。'));
            }
        }
        
        return ret;
    }

    /**
     * 見積情報チェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG 
     */
    private Boolean checkMitsumoriSection(String aid) {
        
        Boolean ret = true;

        // 案件データ取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        MitsumoriTantosya__c,
                                        StatusLock__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];

        // 見積担当者が設定されているか
        if (Strings.isNullOrEmpty(ankenList[0].MitsumoriTantosya__c)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '見積担当者が設定されていません。'));
        }
        
        // ステータスが請求確定済み以降となっていないかチェック
        if (ankenList[0].StatusLock__c) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '請求確定済みの案件です。'));
        }

        return ret;
    }

    /**
     * PDF送付
     */
    public PageReference sendPdf() {
        
        // 更新対象案件リスト
        List<Anken__c> updAnkenList = new List<Anken__c> ();
        // PDF生成対象リスト
        List<Attachment> upsAttList = new List<Attachment> ();
        // メール送信キューの添付リスト
        List<Attachment> mailQueueAttList = new List<Attachment> ();
        // Email送付象リスト
        List<Messaging.SingleEmailMessage> sendMailList = new List<Messaging.SingleEmailMessage> ();
        // メール送信キューリスト
        List<MailQueue__c> sendMailQueueList = new List<MailQueue__c> ();

        // 見積書送付メールテンプレート取得
        EmailTemplate mailTemplate = this.getMailTemplate();

        // 組織のメールアドレス取得
        OrgWideEmailAddress orgAddress = this.getOrgAddress();
        
        // 更新案件データ取得
        

        // 案件データ更新、PDF生成、メール生成
        for (String aid : this.ankenIdList) {
            // 更新案件データ取得
            Anken__c updAnken = this.getUpdateAnkenData(aid);
            updAnkenList.add(updAnken);
            // PDF取得
            Attachment att = this.getAttachmentPdf(aid);
            upsAttList.add(att);
            // Email取得
            // 即時送信フラグチェック
            if(this.getUpdateAnkenData(aid).SendImmediateFlag__c){
                // 即時送信フラグが立っている場合
                // 既存の送付処理
                sendMailList.add(this.getEmail(aid, att, mailTemplate, orgAddress));
                
            }else{
                // 即時送信フラグが立ってない場合
                // メール送信キューオブジェクトにレコードとして登録
                sendMailQueueList.add(this.getMailQueue(updAnken, orgAddress));
            }
        }

        // 見積書作成＆更新
        upsert upsAttList;

        // 案件データの見積書IDを設定
        for (Anken__c item : updAnkenList) {
            for (Attachment att : upsAttList) {
                if (item.Id == att.parentId) {
                    item.MitsumorisyoId__c = att.Id;
                    break;
                }
            }
        }
        // 案件データ更新
        update updAnkenList;
        
        // メール送信
        Messaging.sendEmail(sendMailList);
        // メール送信キューの登録
        insert sendMailQueueList;

        // メール送信キューに添付ファイルを登録
        Map<String, Attachment> mapAtt = new Map<String, Attachment>();
        for (Attachment att : upsAttList){
            mapAtt.put(att.parentId, att);
        }
        
        for (MailQueue__c mailQueue : sendMailQueueList){
            for (Attachment att : upsAttList) {
                if (mailQueue.Anken__c == att.parentId) {
                    Attachment mailQueueAtt = new Attachment();
                    mailQueueAtt.Name = mapAtt.get(mailQueue.Anken__c).Name;
                    mailQueueAtt.Body = mapAtt.get(mailQueue.Anken__c).Body;
                    mailQueueAtt.parentId = mailQueue.Id;
                    mailQueueAtt.contenttype = 'application/pdf';
            
                    mailQueueAttList.add(mailQueueAtt);
                }
            }
        }
        
        insert mailQueueAttList;


        // 案件画面へ遷移
        return new PageReference(this.retUrl);
    }
    
    /**
     * 見積書送付メールテンプレートを取得する
     *
     * @return 見積書送付メールテンプレート
     */
    private EmailTemplate getMailTemplate() {

        List<EmailTemplate> templateList = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :System.Label.MitsumorisyoMailTemplate AND IsActive = :true];
        return templateList[0];
    }
    
    /**
     * 組織のメールアドレスを取得
     *
     * @return 組織のメールアドレス
     */
    private OrgWideEmailAddress getOrgAddress() {
        
        List<OrgWideEmailAddress> orgAddressList = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = :System.Label.OrgMailAddress];
        return orgAddressList[0];
    }

    /**
     * 更新対象案件データの取得
     * 
     * @param aid 案件Id
     * @return Ankenオブジェクト
     */
    private Anken__c getUpdateAnkenData(String aid) {
        
        // 更新対象案件データ取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        Status__c,
                                        MitsumoriDateTime__c,
                                        MitsumoriReplyDate__c,
                                        MitsumoriCommitURL__c,
                                        MitsumoriCancelURL__c,
                                        MitsumorisyoId__c,
                                        SendImmediateFlag__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];

        // ステータスを更新
        ankenList[0].Status__c = '見積回答待ち';

        // 見積日時を更新
        ankenList[0].MitsumoriDateTime__c = DateTime.Now();

        // 見積回答日時をクリア
        ankenList[0].MitsumoriReplyDate__c = null;

        // 見積確定URL、見積キャンセルURL用のパラメータ生成
        String criptKey = Strings.encryptString(aid + '@' + ankenList[0].MitsumoriDateTime__c);
        
        // 見積確定用URLを更新
        String commitUrl = QUOTATION_URL + '?aid=' + EncodingUtil.urlEncode(criptKey, 'UTF-8') + '&type=commit';
        ankenList[0].MitsumoriCommitURL__c = commitUrl;
        
        // 見積キャンセル用URLを更新
        String cancelUrl = QUOTATION_URL + '?aid=' + EncodingUtil.urlEncode(criptKey, 'UTF-8') + '&type=cancel';
        ankenList[0].MitsumoriCancelURL__c = cancelUrl;
        
        return ankenList[0];
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
        List<Attachment> attList = [SELECT Id, parentId, Name, Body, contenttype FROM Attachment WHERE parentId = :aid AND Name = :System.Label.MitsumorisyoName ORDER BY CreatedDate DESC];
        if (attList.size() > 0) {
            // update（既存見積書を更新）
            att = attList[0];
            
        } else {
            // insert（新規見積書を登録）
            att = new Attachment(parentId = aid, Name = System.Label.MitsumorisyoName);
        }
        
        // 本文
        // テストメソッドではgetContentコールをサポートしていないため落ちないように回避
        if (Test.IsRunningTest()){
            att.Body = Blob.valueOf('UNIT.TEST');
        } else {
            att.Body = pdf.getContent();
        }

        return att;
    }
    
    /**
     * メール送信キュー生成
     * @param aid 案件Id
     * @param att 添付PDF
     * @param orgAddress 組織のメールアドレス
     * @return MailQueueList__c メール送信キューオブジェクト
    **/
   private MailQueue__c getMailQueue(Anken__c updAnken, OrgWideEmailAddress orgAddress){
        
        // 案件取得
        List<Anken__c> ankenList = getAnkenList(updAnken.Id);
        
        // メール送信キュー生成
        MailQueue__c mailQueue = new MailQueue__c();
        mailQueue.Anken__c = ankenList[0].Id;
        mailQueue.To__c = ankenList[0].KokyakuTantosya_Main__r.Email;
        mailQueue.Cc1__c = ankenList[0].KokyakuTantosya_CC1__r.Email;
        mailQueue.Cc2__c = ankenList[0].KokyakuTantosya_CC2__r.Email;
        mailQueue.Cc3__c = ankenList[0].KokyakuTantosya_CC3__r.Email;
        mailQueue.Cc4__c = ankenList[0].KokyakuTantosya_CC4__r.Email;
        mailQueue.Sender__c = orgAddress.Address;
        mailQueue.SenderName__c = orgAddress.DisplayName;
        mailQueue.Subject__c = '御見積書送付［見積No：'+ ankenList[0].Name+']';
        
        mailQueue.Body__c =  ankenList[0].KokyakuName__r.Name + '\n' +
                             ankenList[0].KokyakuTantosya_Main__r.Name +'　様' + '\n' +
                             '\n' +
                             'お世話になっております。' + '\n' +
                             '\n' +
                             'ご依頼頂いたご発注につきまして' + '\n' +
                             '御見積書を送付させて頂きます。' + '\n' +
                             '\n' +
                             '■見積No　：　' + ankenList[0].Name + '\n' +
                             '■案件名　：　' + ankenList[0].AnkenName__c + '\n' +
                             '\n' +
                             '御見積内容に関しましては添付PDFをご参照ください。' + '\n' +
                             '内容に問題が無い様でしたら、下記見積確定リンクを' + '\n' +
                             'クリックし、ご発注の確定をお願い致します。' + '\n' +
                             '\n' +
                             '　[見積確定URL]' + '\n' +
                             updAnken.MitsumoriCommitURL__c + '\n' +
                             '\n' +
                             'キャンセルを行う場合は下記リンクをクリックしてください。' +  '\n' +
                             '\n' +
                             '　[見積キャンセルURL]' + '\n' +
                             updAnken.MitsumoriCancelURL__c + '\n' +
                             '\n' +
                             '━━━━━━━━━━━━━━━━━━━━━' + '\n' +
                             '株式会社メディア・バックオフィス' + '\n' +
                             '切り抜きJP事業部 ' + '\n' +
                             /** start edit 2016/02/29 **/
                             //'担当:'+ System.UserInfo.getLastName() + ' ' + System.UserInfo.getFirstName() + '\n' +
                             /** start edit 2016/03/09 **/
                             //'担当:'+ ankenList[0].MitsumoriTantosya__r.Alias + '\n' +
                             '担当:'+ this.userAlias + '\n' +
                             /** end edit 2016/03/09 **/
                             /** end edit 2016/02/29 **/
                             '\n' +
                             '〒101-0063' + '\n' +
                             '東京都千代田区神田淡路町2-1 NCO神田淡路町6階 ' + '\n' +
                             '0120-359-831 (フリーダイヤル) ' + '\n' +
                             '03-6629-7330（IP電話より） ' + '\n' +
                             '03-6685-7136（FAX） ' + '\n' +
                             '---------------------------------------' + '\n' +
                             'URL : http://www.kirinuki.jp' + '\n' +
                             'メール : info@kirinuki.jp' + '\n' +
                             '━━━━━━━━━━━━━━━━━━━━━ ';
        
        mailQueue.Body__c = mailQueue.Body__c.replaceAll('null', '');
        return mailQueue;
   }

    /**
     * メール生成
     * 
     * @param aid 案件Id
     * @param att 添付PDF
     * @param mailTemplate メールテンプレート
     * @param orgAddress 組織のメールアドレス
     * @return Messaging.SingleEmailMessageオブジェクト
     */
    private Messaging.SingleEmailMessage getEmail(String aid, Attachment att, EmailTemplate mailTemplate, OrgWideEmailAddress orgAddress) {
        
        // 案件取得
        List<Anken__c> ankenList = getAnkenList(aid);
        
        // CCアドレス取得
        List<String> ccAddress = getCcAddress(ankenList[0]);
        
        // 添付ファイル作成
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(att.Name);
        efa.setBody(att.Body);

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(mailTemplate.Id);
        email.setOrgWideEmailAddressId(orgAddress.Id);
        email.setTargetObjectId(ankenList[0].KokyakuTantosya_Main__c);
        email.setWhatId(aid);
        email.setCcAddresses(ccAddress);
        email.setSaveAsActivity(true);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        return email;
    }
    
    /**
     * 案件オブジェクトからccを取得する
     *
     * @param anken 案件オブジェクト
     * @return ccのメールアドレスリスト
     */
    private List<String> getCcAddress(Anken__c anken) {

        List<String> ccList = new List<String> ();
        
        // 顧客担当者（CC-1）
        if (!Strings.isNullOrEmpty(anken.KokyakuTantosya_CC1__r.Email)) {
            ccList.add(anken.KokyakuTantosya_CC1__r.Email);
        }

        // 顧客担当者（CC-2）
        if (!Strings.isNullOrEmpty(anken.KokyakuTantosya_CC2__r.Email)) {
            ccList.add(anken.KokyakuTantosya_CC2__r.Email);
        }

        // 顧客担当者（CC-3）
        if (!Strings.isNullOrEmpty(anken.KokyakuTantosya_CC3__r.Email)) {
            ccList.add(anken.KokyakuTantosya_CC3__r.Email);
        }

        // 顧客担当者（CC-4）
        if (!Strings.isNullOrEmpty(anken.KokyakuTantosya_CC4__r.Email)) {
            ccList.add(anken.KokyakuTantosya_CC4__r.Email);
        }

        return ccList;
    }
    // 案件取得
    private List<Anken__c> getAnkenList(String aid){
        
        // 宛先取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        AnkenName__c,
                                        MitsumoriCancelURL__c,
                                        MitsumoriCommitURL__c,
                                        /** start add 2016/02/29 **/
                                        MitsumoriTantosya__r.Alias,
                                        /** end add 2016/02/29 **/
                                        KokyakuName__r.Name,
                                        KokyakuTantosya_Main__r.Name,
                                        KokyakuTantosya_Main__c,
                                        KokyakuTantosya_Main__r.Email,
                                        KokyakuTantosya_CC1__r.Email,
                                        KokyakuTantosya_CC2__r.Email,
                                        KokyakuTantosya_CC3__r.Email,
                                        KokyakuTantosya_CC4__r.Email
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];
                                        
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