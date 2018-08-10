public with sharing class SendNohinsyoAddURLController {

    /** 案件ID */
    public String ankenId;

    /** 処理対象の案件IDリスト */
    public List<String> ankenIdList;
    
    /** 処理対象の案件リスト */
    public List<Anken__c> ankenAllList {get;set;}

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

    /** 納品書送信フラグ */
    public Boolean isSendPdf {
        get;
        private set;
    }
    
    /** 一律価格顧客チェックフラグ */
    public Boolean ichiritsuFlg {get;set;}

    /** start add 2016/03/09 **/
    /** ユーザー別名 */
    private String userAlias;
    /** end add 2016/03/09 **/

    /**
     * デフォルトコンストラクタ
     */
    public SendNohinsyoAddURLController() {

        // リクエストパラメータ取得
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        
        system.debug('-----this.ankenId-----'+this.ankenId);
        
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');

        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        this.ankenIdList.add(this.ankenId);

        // 納品日時設定
        this.nohinDateTime = System.now();

        // 納品書送信フラグ初期化
        this.isSendPdf = false;

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
    public SendNohinsyoAddURLController (ApexPages.StandardSetController controller) {

        // リクエストパラメータ取得
        this.records = (List<Anken__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        // 案件リスト初期化
        ankenAllList = new List<Anken__c>();
        
        // 一律価格顧客チェックフラグ初期化 
        this.ichiritsuFlg = false;

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
        
        ankenAllList = [SELECT Id, IchiritsuKakakuKokyakuFkg__c FROM Anken__c WHERE Id IN: this.ankenIdList];
        
        for(Anken__c anAll : ankenAllList){
            
            // 一律価格顧客チェック
            if(anAll.IchiritsuKakakuKokyakuFkg__c){
                this.ichiritsuFlg = true;
            }
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

        // 納品書送信フラグ初期化
        this.isSendPdf = false;
    }

    /**
     * 案件詳細から納品書送付を実行したときのチェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG
     */
    public PageReference initCheck() {

        this.isInitCheck = true;

        boolean isNohinSectionCheck = true;
        boolean isEmailAddressCheck = true;

        // 納品情報チェック
        if (!this.checkNohinSection(this.ankenId)) {
            isNohinSectionCheck = false;
        }

        // 宛先チェック
        if (!this.checkEmailAddress(this.ankenId)) {
            isEmailAddressCheck = false;
        }

        //チェックが１つでもNGの場合はエラー
        if (isNohinSectionCheck == false || isEmailAddressCheck == false){
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
        if (this.records.size() > Integer.valueOf(System.Label.ExecuteLimitCount_Nohinsyo)) {
            this.isInitCheck = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '一括処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Nohinsyo + '件です。'));
        }

        boolean isNohinSectionCheck = true;
        boolean isEmailAddressCheck = true;

        // 必須チェック
        for (Anken__c anken : this.records) {
            // 納品情報チェック
            if (!this.checkNohinSection(anken.Id)) {
                isNohinSectionCheck = false;
            }

            // 宛先チェック
            if (!this.checkEmailAddress(anken.Id)) {
                isEmailAddressCheck = false;
            }

        }

        //チェックが１つでもNGの場合はエラー
        if (isNohinSectionCheck == false || isEmailAddressCheck == false){
            this.isInitCheck = false;
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
                                        NohinTantosya__c, //納品担当者
                                        NohinDateTime__c, //納品日時
                                        JuchuTotalKingaku_Tax__c, // 合計金額（税込み）
                                        StatusLock__c,
                                        DownloadURL__c //ダウンロード用URL
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
        
        // ダウンロード用URLが空白
        if (Strings.isNullOrEmpty(ankenList[0].DownloadURL__c,true)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + 'ダウンロード用URLが空白です。'));
        }

        return ret;
    }

    /**
     * 宛先チェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG
     */
    private Boolean checkEmailAddress(String aid) {

        Boolean ret = true;

        // 案件データ取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        KokyakuTantosya_Main__c, //顧客担当者（主）
                                        KokyakuTantosya_Main__r.Email, //顧客担当者（主）のメールアドレス
                                        KokyakuTantosya_CC1__c, //顧客担当者（CC1）
                                        KokyakuTantosya_CC1__r.Name, //顧客担当者（CC1）のName
                                        KokyakuTantosya_CC1__r.Email, //顧客担当者（CC1）のメールアドレス
                                        KokyakuTantosya_CC2__c, //顧客担当者（CC2）
                                        KokyakuTantosya_CC2__r.Name, //顧客担当者（CC2）のName
                                        KokyakuTantosya_CC2__r.Email, //顧客担当者（CC2）のメールアドレス
                                        KokyakuTantosya_CC3__c, //顧客担当者（CC3）
                                        KokyakuTantosya_CC3__r.Name, //顧客担当者（CC3）のName
                                        KokyakuTantosya_CC3__r.Email, //顧客担当者（CC3）のメールアドレス
                                        KokyakuTantosya_CC4__c, //顧客担当者（CC4）
                                        KokyakuTantosya_CC4__r.Name, //顧客担当者（CC4）のName
                                        KokyakuTantosya_CC4__r.Email //顧客担当者（CC4）のメールアドレス
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

        // 案件データ更新、PDF生成、メール生成
        for (String aid : this.ankenIdList) {
            // 更新案件データ取得
            updAnkenList.add(this.getUpdateAnkenData(aid));
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
                // 即時送信フラグが立っていない場合
                // メール送信キューオブジェクトにレコードとして登録
                sendMailQueueList.add(this.getMailQueue(aid, orgAddress));
            }
        }

        // 納品書作成＆更新
        upsert upsAttList;

        // 案件データの見積書IDを設定
        for (Anken__c item : updAnkenList) {
            for (Attachment att : upsAttList) {
                if (item.Id == att.parentId) {
                    item.NohinsyoId__c = att.Id;
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

        // 納品書送信フラグ初期化
        this.isSendPdf = false;

        // 案件画面へ遷移
        return new PageReference(this.retUrl);
    }

    /**
     * 納品書送付メールテンプレートを取得する
     *
     * @return 納品書送付メールテンプレート
     */
    private EmailTemplate getMailTemplate() {

        List<EmailTemplate> templateList = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :System.Label.NohinsyoAddURLMailTemplate AND IsActive = :true];
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
                                        NohinDateTime__c,
                                        NohinsyoId__c,
                                        SendImmediateFlag__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];

        // ステータスを更新
        ankenList[0].Status__c = '受注納品済み';

        return ankenList[0];
    }
    /**
     * 更新対象案件データの取得
     *
     * @param aidList 案件Idリスト
     * @return 更新対象案件データ
     */
    private List<Anken__c> getUpdateAnkenDataList(List<String> aidList) {

        // 更新対象案件データ取得
        List<Anken__c> ankenList = [SELECT Id, Name, NohinDateTime__c, NohinsyoId__c FROM Anken__c WHERE Id IN :aidList];
        return ankenList;
    }

    /**
     * 案件データの更新
     *
     * @return 更新対象案件データ
     */
    public PageReference updateAnkenData() {

        // 更新対象案件リスト取得
        List<Anken__c> updAnkenList = this.getUpdateAnkenDataList(this.ankenIdList);

        for(Anken__c item :updAnkenList){
            // 納品日時を更新
            if(item.NohinDateTime__c == null){
                item.NohinDateTime__c = this.nohinDateTime;
            }
            // 納品担当者
            item.NohinTantosya__c = UserInfo.getUserId();
        }

        update updAnkenList;

        // 納品書送信フラグ更新
        this.isSendPdf = true;

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
        List<Attachment> attList = [SELECT Id, parentId, Name, Body, contenttype FROM Attachment WHERE parentId = :aid AND Name = :System.Label.NohinsyoName ORDER BY CreatedDate DESC];
        if (attList.size() > 0) {
            // update（既存納品書を更新）
            att = attList[0];

        } else {
            // insert（新規納品書を登録）
            att = new Attachment(parentId = aid, Name = System.Label.NohinsyoName);
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
     * @param orgAddress 組織のメールアドレス
     * @return MailQueueList__c メール送信キューオブジェクト
    **/
    private MailQueue__c getMailQueue(String aid, OrgWideEmailAddress orgAddress){
        
        // 案件取得
        List<Anken__c> ankenList = getAnkenList(aid);
        
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
        mailQueue.Subject__c = '作業完了のお知らせ［伝票No：'+ ankenList[0].Name+']';
        
        mailQueue.Body__c =  ankenList[0].KokyakuName__r.Name + '\n' +
                             ankenList[0].KokyakuTantosya_Main__r.Name +'　様' + '\n' +
                             '\n' +
                             'お世話になっております。' + '\n' +
                             '\n' +
                             'ただ今、作業完了し、データを下記にアップ致しました。' + '\n' +
                             '\n' +
                             ankenList[0].DownloadURL__c + '\n' +
                             '\n' +
                             '■伝票No：　'+ ankenList[0].Name + '\n' +
                             '■件名  ：　'+ ankenList[0].AnkenName__c + '\n' +
                             '\n' +
                             '納品内容に関しましては添付PDFをご参照ください。' + '\n' +
                             '\n' +
                             '\n' +
                             '※Boxからのデータダウンロード方法につきましては下記URLをご参照ください。' + '\n' +
                             '　https://goo.gl/AAV1J9' + '\n' +
                             '\n' +
                             '尚、データの保管期間は1カ月間となっておりますのでご注意ください。' + '\n' +
                             '\n' +
                             '以上、ご確認の上、ご査収頂きます様、何卒宜しくお願い申し上げます。' + '\n' +
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
                             '0120-359-831（フリーダイヤル） ' + '\n' +
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

        // 宛先取得
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
                                        DownloadURL__c,
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