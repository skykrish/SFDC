public with sharing class SendNokiTsuchiController {

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
    public SendNokiTsuchiController() {

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
    public SendNokiTsuchiController (ApexPages.StandardSetController controller) {

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
     * 案件詳細から納期通知を実行したときのチェック
     */
    public PageReference initCheck() {

        this.isInitCheck = true;

        // 宛先チェック
        if (!this.checkMainAddress(this.ankenId)) {
            this.isInitCheck = false;
        }

        // 納期、ステータスチェック
        if (!this.checkNoukiAndStatus(this.ankenId)) {
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

        // 宛先、納期、ステータスチェック
        for (Anken__c anken : this.records) {
            // 宛先チェック
            if (!this.checkMainAddress(anken.Id)) {
                this.isInitCheck = false;
            }

            // 納期、ステータスチェック
            if (!this.checkNoukiAndStatus(anken.Id)) {
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
     * 納期、ステータスチェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG
     */
    private Boolean checkNoukiAndStatus(String aid) {

        Boolean ret = true;

        // 案件データ取得
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        Nouki__c,
                                        StatusLock__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];

        // 納期が設定されているか
        if (Strings.isNullOrEmpty(ankenList[0].Nouki__c)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '納期が設定されていません。'));
        }

        // ステータスが請求確定済み以降となっていないかチェック
        if (ankenList[0].StatusLock__c) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '請求確定済みの案件です。'));
        }

        return ret;
    }

    /**
     * 納期通知送付
     */
    public PageReference sendNokiTsuchi() {

        // 更新対象案件リスト
        List<Anken__c> updAnkenList = new List<Anken__c> ();
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
            // Email取得
            // 即時送信フラグチェック
            if(this.getUpdateAnkenData(aid).SendImmediateFlag__c){
                // 即時送信フラグが立っている場合
                // 既存の送付処理
                sendMailList.add(this.getEmail(aid, mailTemplate, orgAddress));
                
            }else{
                // 即時送信フラグが立っていない場合
                // メール送信キューオブジェクトにレコードとして登録
                sendMailQueueList.add(this.getMailQueue(aid, orgAddress));
            }
        }

        // 案件データ更新
        update updAnkenList;

        // メール送信
        Messaging.sendEmail(sendMailList);
        // メール送信キューの登録
        insert sendMailQueueList;

        // 案件画面へ遷移
        return new PageReference(this.retUrl);
    }

    /**
     * 納期通知メールテンプレートを取得する
     *
     * @return 納期通知メールテンプレート
     */
    private EmailTemplate getMailTemplate() {

        List<EmailTemplate> templateList = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :System.Label.NokiTsuchiMailTemplate AND IsActive = :true];
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
                                        Status__c,
                                        NokiTsuchiDateTime__c,
                                        SendImmediateFlag__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];

        // ステータスを更新
        ankenList[0].Status__c = '受注納期通知済み';

        // 納期通知日時を更新
        ankenList[0].NokiTsuchiDateTime__c = system.now();

        return ankenList[0];
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
        
        // 担当者名
        String tantosyaNameList = ankenList[0].KokyakuTantosya_Main__r.Name +'　様';
        // CCが入っている場合追加
        tantosyaNameList = getTantosyaNameList(tantosyaNameList, ankenList[0].KokyakuTantosya_CC1__r.Name);
        tantosyaNameList = getTantosyaNameList(tantosyaNameList, ankenList[0].KokyakuTantosya_CC2__r.Name);
        tantosyaNameList = getTantosyaNameList(tantosyaNameList, ankenList[0].KokyakuTantosya_CC3__r.Name);
        tantosyaNameList = getTantosyaNameList(tantosyaNameList, ankenList[0].KokyakuTantosya_CC4__r.Name);
        
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
        mailQueue.Subject__c = '納期通知［伝票番号：'+ ankenList[0].Name+']';
        
        mailQueue.Body__c =  ankenList[0].KokyakuName__r.Name + '\n' +
                             tantosyaNameList + '\n' +
                             '\n' +
                             'お世話になっております。' + '\n' +
                             '\n' +
                             '下記案件につきまして、確かに承りましたので、ただ今より作業開始の手配を致します。' + '\n' +
                             '\n' +
                             '--------------------------------------------------' + '\n' +
                             '■伝票番号' + '\n' +
                             ankenList[0].Name + '\n' +
                             '\n' +
                             '■完了予定時刻' + '\n' +
                             ankenList[0].Nouki__c + '\n' +
                             '\n' +
                             '■案件名' + '\n' +
                             + ankenList[0].AnkenName__c  + '\n' +
                             '\n' +
                             '■フォルダ名' + '\n' +
                             ankenList[0].FolderName__c + '\n' +
                             '\n' +
                             '■点数'+ '\n' +
                             ankenList[0].ItemCnt__c + '\n' +
                             '--------------------------------------------------' + '\n' +
                             '\n' +
                             'ご不明点、その他ご要望等御座いましたら、何なりとお申し付けください。' + '\n' +
                             '何卒、よろしくお願い申し上げます。' + '\n' +
                             '\n' +
                             '\n' +
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
                             'ホームページ : http://www.kirinuki.jp' + '\n' +
                             'お客様ページ : https://kirinuki.secure.force.com/mypage' + '\n' +
                             'Email : info@kirinuki.jp' + '\n' +
                             '━━━━━━━━━━━━━━━━━━━━━ ';
                             
         mailQueue.Body__c = mailQueue.Body__c.replaceAll('null', '');
         return mailQueue;
     }
    
    /**
     * メール生成
     *
     * @param aid 案件Id
     * @param mailTemplate メールテンプレート
     * @param orgAddress 組織のメールアドレス
     * @return Messaging.SingleEmailMessageオブジェクト
     */
    private Messaging.SingleEmailMessage getEmail(String aid, EmailTemplate mailTemplate, OrgWideEmailAddress orgAddress) {

        // 宛先取得
        List<Anken__c> ankenList = getAnkenList(aid);

        // CCアドレス取得
        List<String> ccAddress = getCcAddress(ankenList[0]);

        // メール生成
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(mailTemplate.Id);
        email.setOrgWideEmailAddressId(orgAddress.Id);
        email.setTargetObjectId(ankenList[0].KokyakuTantosya_Main__c);
        email.setWhatId(aid);
        email.setCcAddresses(ccAddress);
        email.setSaveAsActivity(true);

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
                                        Nouki__c,
                                        ItemCnt__c,
                                        FolderName__c,
                                        /** start add 2016/02/29 **/
                                        MitsumoriTantosya__r.Alias,
                                        /** end add 2016/02/29 **/
                                        KokyakuName__r.Name,
                                        KokyakuTantosya_Main__c,
                                        KokyakuTantosya_Main__r.Name,
                                        KokyakuTantosya_CC1__r.Name,
                                        KokyakuTantosya_CC2__r.Name,
                                        KokyakuTantosya_CC3__r.Name,
                                        KokyakuTantosya_CC4__r.Name,
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
    
    /** Ccが入っている場合は担当者名リストに追加
     *
     *  @param tantosyaNameList (担当者名リスト)
     *  @param ccName (Ccに登録されている名前)
     *  @retuen tantosyaNameList (担当者名リスト)
     */
    private String getTantosyaNameList(String tantosyaNameList, String ccName){
        if(ccName != null){
            tantosyaNameList = tantosyaNameList + '、　' + ccName + '　様';
        } 
        
        return tantosyaNameList;
    }

    /**
     * キャンセル（一括）
     */
    public PageReference cancel() {

        // 案件リスト画面へ遷移
        return new PageReference(this.retUrl);
    }
}