public with sharing class CreateSeikyusyoController {

    /** 請求ヘッダリスト */
    public List<SeikyuHeader__c> shList {
        get;
        private set;
    }

    /** 締めグループ */
    public String shimeGroup {
        get;
        private set;
    }

    /** 締め日 */
    public Date shimebi {
        get;
        private set;
    }
    
    /** リジューム制御 */
    public Resume resume {
        get;
        set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public CreateSeikyusyoController() {
        
        // リクエストパラメータ取得
        this.shimeGroup = ApexPages.currentPage().getParameters().get('shimeGroup');
        this.shimebi = Date.valueOf(ApexPages.currentPage().getParameters().get('shimebi'));
        
        // リジューム制御初期化
        this.resume = new Resume();
    }
    
    /**
     * 初期化処理
     */
    public PageReference init() {
        
        // 請求ヘッダ検索
        this.shList = this.getSeikyuHeader(this.shimeGroup, this.shimebi);
        return null;
    }
    
    /**
     * 請求ヘッダリスト取得
     *
     * @param shimeGroup 締めグループ
     * @param shimebi 締め日
     * @return 請求ヘッダリスト
     */
    private List<SeikyuHeader__c> getSeikyuHeader(String shimeGroup, Date shimebi) {
        
        List<SeikyuHeader__c> shList = [SELECT
                                            Id,
                                            Name,
                                            ShimeGroup__c,
                                            Shimebi__c,
                                            SeikyusyoId__c,
                                            Seikyusaki__r.Name,
                                            SeikyusakiTorihikiKbn__c,
                                            KaisyuScheduledDate__c,
                                            Seikyugaku_Tax__c
                                        FROM
                                            SeikyuHeader__c
                                        WHERE
                                            ShimeGroup__c = :shimeGroup AND
                                            Shimebi__c = :shimebi AND
                                            Del_Flg__c = FALSE AND
                                            SeikyusyoId__c = null];

        return shList;
    }
    
    /**
     * 請求書作成
     */
    public PageReference createPdf() {
        
        // リジューム処理設定
        this.resume = new Resume();
        this.resume.records = this.shList;
        this.resume.totalCnt = this.shList.size();
        this.resume.processCnt = 5;
        this.resume.hasNext = true;
        this.resume.isFinish = false;

        return null;
    }

    /**
     * リジューム処理
     */
    public PageReference resumeProcess() {
        
        // 処理対象リスト取得
        List<SeikyuHeader__c> processList = (List<SeikyuHeader__c>) this.resume.next();
        
        // 請求書作成
        for (SeikyuHeader__c item : processList) {
            try {
                // PDF生成
                Attachment att = this.getAttachmentPdf(item.Id);
                upsert att;
    
                // 請求書ID設定
                item.SeikyusyoId__c = att.Id;
                update item;
            
            } catch (Exception e) {
                // 請求書作成エラー
                this.resume.msgList.add('請求書番号：' + item.Name + '　　' + e.getMessage());
            }
        }
        
        // 終了処理
        if (this.resume.execCnt >= this.resume.totalCnt) {
            // リジューム終了
            this.resume.hasNext = false;
            this.resume.isFinish = true;
        }
        
        return null;
    }

    /**
     * リジューム終了処理
     */
    public PageReference resumeFinish() {
    	
   	    this.resume.isFinish = false;
    	 
        // 完了メッセージ
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求作成処理が完了しました。'));
        // エラーメッセージ
        for (String msg : this.resume.msgList) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, msg));
        }
        // 再検索
        this.shList = this.getSeikyuHeader(this.shimeGroup, this.shimebi);

    	return null;
    }

    /**
     * PDF生成
     *
     * @param shid 請求ヘッダId
     * @return Attachmentオブジェクト
     */
    private Attachment getAttachmentPdf(String shid) {

        // 請求書作成
        PageReference pdf = Page.Seikyusyo;
        pdf.getParameters().put('shid', shid);

        // 既存請求書を取得
        Attachment att = null;
        List<Attachment> attList = [SELECT Id, parentId, Name, Body FROM Attachment WHERE parentId = :shid AND Name = :System.Label.SeikyusyoName ORDER BY CreatedDate DESC];
        if (attList.size() > 0) {
            // update（既存請求書を更新）
            att = attList[0];
            att.Body = pdf.getContent();

        } else {
            // insert（新規請求書を登録）
            att = new Attachment(parentId = shid, Name = System.Label.SeikyusyoName, Body = pdf.getContent());
        }

        return att;
    }

    /**
     * リジューム用クラス
     */
    public class Resume {

        /** 対象レコード */
        private List<sObject> records; 
        
        /** １回ごとの処理件数 */
        private Integer processCnt;

        /** メッセージ */
        private List<String> msgList; 

        /** 処理対象件数 */
        public Integer totalCnt {
            get;
            private set;
        }

        /** 処理件数 */
        public Integer execCnt {
            get;
            private set;
        }

        /** 次回の処理対象があるかどうか */
        public Boolean hasNext {
            get;
            private set;
        }

        /** 終了処理を実行するかどうか */
        public Boolean isFinish {
            get;
            private set;
        }

        /** 進捗率 */
        public Integer progress {
            get {
            	Integer ret = 0;
            	if (this.totalCnt > 0) {
            		ret = (this.execCnt * 100 / this.totalCnt);
            	}
            	return ret;
            }
            private set;
        }

        /** デフォルトコンストラクタ */
        public Resume() {

            // 各パラメータ初期化
            this.processCnt = 0;
            this.totalCnt = 0;
            this.execCnt = 0;
            this.hasNext = false;
            this.isFinish = false;
            this.msgList = new List<String>();
        }

        /** 処理対象レコード取得 */
        public List<sObject> next() {

            // １回ごとの処理対象レコードを取得する
            List<sObject> targetList = new List<sObject> ();
            for (Integer i = this.execCnt; i < this.execCnt + this.processCnt && i < this.records.size(); i ++) {
                targetList.add(this.records[i]);
            }
            
            // 処理件数加算
            this.execCnt += targetList.size();
            
            return targetList;
        }
    }

}