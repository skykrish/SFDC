public with sharing class SeikyuTorimatomeController{
    
    /** 請求ヘッダID */
    private List<String> seikyuHeaderId;
    
    /** 検索条件 */
    public String searchCondition {get;set;}
    
    /** 請求ヘッダ区切り文字 */
    private static String DELIMITER = ',';
    
    /** 請求一覧の値 */
    public String ichiran {get;set;}
    
    /** 請求ヘッダリスト */
    public List<SeikyuHeader__c> sHead {get;set;}
    /** 請求明細リスト */
    public List<SeikyuMeisai__c> sMeisaListi {get;set;}
    /** 請求リスト */
    public List<Seikyu__c> seikyuList {get;set;}
    
    /** 請求クライテリア */
    public SeikyuCriteria__c criteria {
        get;
        set;
    } 
    /** 表示ページ */
    public Integer dispPage {
        get;
        set;
    }
    /** ページ数上限 */
    private static integer MAX_PAGE = 10;

    /** １ページの表示請求ヘッダ数 */
    private static integer MAX_SHEAD_LINE = 100;

    /** １ページの表示数 */
    private static integer MAX_LINE = 15;
    
    /** ラストページ */
    public Integer lastPage {
        get;
        set;
    }
    
    /** 表示用請求ヘッダデータリスト */
    public List<SeikyuHeaderDummy> seikyuHeaderList {
        get;
        set;
    }
      
    /** 回収サイクル：翌月 */
    public static String KAISYU_CYCLE_NEXT = '翌月';
    
    /** 回収サイクル：翌々月 */
    public static String KAISYU_CYCLE_NEXT2 = '翌々月';
    
    /** 回収サイクル：翌々々月 */
    public static String KAISYU_CYCLE_NEXT3 = '翌々々月';
    /** 回収日：末日 */
    public static String KAISYU_DATE_END = '末日';
    /** 請求ヘッダ-請求ステータス：未請求 */
    public static String SH_SEIKYU_STATUS_MISEIKYU = '未請求';
    
    /** 請求書作成リスト */
    private List<SeikyuHeader__c> createPdfList;
    
    /** 請求書作成フラグ */
    public Boolean isCreatePdf {
        get;
        private set;
    }
    
    /** 修正用旧請求リスト */
    private List<Seikyu__c> shuseiOldSeikyuList;
    
    
    /**
     * デフォルトコンストラクタ
     */
    public SeikyuTorimatomeController() {
        this.seikyuHeaderId = new List<String>();
        this.searchCondition = '';
        if(ApexPages.currentPage().getParameters().get('shid') != null){
            this.seikyuHeaderId = ApexPages.currentPage().getParameters().get('shid').split(DELIMITER);
            this.searchCondition = ApexPages.currentPage().getParameters().get('shcri');
        }
        // 請求ヘッダ初期化
        this.sHead = new List<SeikyuHeader__c>();
        // 請求ヘッダ初期化
        this.sMeisaListi = new List<SeikyuMeisai__c>();
        // 請求ヘッダ初期化
        this.seikyuList = new List<Seikyu__c>();
        // 請求クライテリア初期化
        this.criteria = new SeikyuCriteria__c();
        // 表示ページの初期化
        this.dispPage = 1;
        // 表示クラス初期化
        this.seikyuHeaderList = new List<SeikyuHeaderDummy>();
        
        // 請求書作成フラグ初期化
        this.isCreatePdf = false;
        
        this.init();
    }
    
    /**
     * 初期化処理
     */
    public PageReference init() {
        
        if(this.seikyuHeaderId.size() != 0){
            // 請求ヘッダデータ取得
            sHead = this.getSeikyuHeaderData(this.seikyuHeaderId);
            // 請求明細データ取得
            sMeisaListi = this.getSeikyuMeisai(this.seikyuHeaderId);
            // 請求データ取得
            seikyuList = this.getSeikyuData(this.seikyuHeaderId);
            // 表示クラス設定
            this.seikyuHeaderList = this.getSeikyuHeaderList();
        }
        
        return null;
    }
    
    /**
     * 請求ヘッダデータを取得する。
     *
     * @param shid 請求ヘッダID
     * @return 請求ヘッダデータ
     */
    private List<SeikyuHeader__c> getSeikyuHeaderData(List<String> shid) {

        List<SeikyuHeader__c> shList = [SELECT
                                        Id, //ID
                                        Name, //請求書番号
                                        Seikyusaki__c, //請求先
                                        ShimeGroup__c, //締めグループ
                                        Shimebi__c, //締日
                                        Seikyusaki__r.KokyakuCd__c, //顧客コード
                                        SeikyusakiName__c, //請求先名
                                        BillingPostalCode__c, //請求先郵便番号
                                        BillingState__c, //請求先都道府県
                                        BillingCity__c, //請求先市区町村
                                        BillingStreet__c, //請求先番地
                                        FurikomiBankName__c, //振込先銀行名
                                        FurikomiShitenName__c, //振込先支店名
                                        FurikomiKozaType__c, //振込先口座種類
                                        FurikomiKozaNo__c, //振込先口座番号
                                        FurikomiKozaName__c, //振込先口座名

                                        SeikyusakiTorihikiKbn__c, //請求先取引区分
                                        SeikyuDateTime__c, //請求日時
                                        SeikyuTantosya__r.Name , //請求担当者名
                                        SeikyuTantosya__r.TantosyaImageId__c , //請求担当者担当者印画像ID
                                        Seikyugaku__c, //請求額（税抜き）
                                        Tax__c, //消費税額
                                        Seikyugaku_Tax__c, //請求額（税込み）
                                        SeikyuStatus__c, //請求ステータス
                                        NyukinStatus__c, //入金ステータス
                                        KaisyuScheduledDate__c, //回収予定日
                                        Seikyusaki__r.Name, //請求先名
                                        MeisaiLineAmount__c
                                    FROM
                                        SeikyuHeader__c
                                    WHERE
                                        Id = :shid];
        
        return shList;
    }
    
    /**
     * 請求明細データを取得する。
     *
     * @param shid 請求ヘッダID
     * @return 請求明細データ
     */
    private List<SeikyuMeisai__c> getSeikyuMeisai (List<String> shid) {

        List<SeikyuMeisai__c> smList = [SELECT
                                            Id, //ID
                                            Name, //Name
                                            SagyoName__c, //作業名
                                            SagyoCd__c, //作業コード
                                            Suryo__c, //数量
                                            Tanka__c, //単価（割引後）
                                            Kingaku__c, //金額
                                            Tax__c, //消費税
                                            TaxRate__c, //消費税率
                                            Kingaku_Tax__c, //金額（税込み）
                                            Nanido__c, //難易度
                                            SeikyuNo__c, // 請求番号
                                            SeikyuNo__r.DenpyoNo__c, //伝票番号
                                            SeikyuNo__r.DenpyoNo__r.Name, //伝票番号
                                            SeikyuNo__r.UriageDateTime__c, //売上日時
                                            SeikyuNo__r.AnkenName__c, //案件名
                                            SeikyuNo__r.AnkenTantosya__c, //案件担当者名
                                            SeikyuNo__r.SeikyusyoNo__c, // 請求書番号
                                            SeikyuNo__r.OffsetNyukin__c, //相殺入金
                                            SeikyuNo__r.DenpyoNo__r.ClientOrderNumber__c // お客様番号
                                        FROM
                                            SeikyuMeisai__c
                                        WHERE
                                            SeikyuNo__r.SeikyusyoNo__c = :shid
                                        ORDER BY
                                            SeikyuNo__r.SeikyusyoNo__c,
                                            SeikyuNo__r.DenpyoNo__r.NohinDateTime__c,
                                            SeikyuNo__r.DenpyoNo__r.name,
                                            SeikyuNo__r.UriageDateTime__c,
                                            SeikyuNo__r.name,Name];
        return smList;
    }
    
    /**
     * 請求データを取得する。
     *
     * @param shid 請求ヘッダID
     * @return 請求データ
     */
    private List<Seikyu__c> getSeikyuData (List<String> shid) {

        List<Seikyu__c> sList = [SELECT
                                            Id, //ID
                                            Name, //請求番号
                                            UriageDateTime__c, //売上日時
                                            AnkenName__c, //案件名
                                            AnkenTantosya__c, //案件担当者名
                                            DenpyoNo__c, //伝票番号
                                            SeikyusyoNo__c, // 請求書番号
                                            OffsetNyukin__c, //相殺入金
                                            DenpyoNo__r.name,
                                            Offset_Flg__c //次回相殺
                                        FROM
                                            Seikyu__c
                                        WHERE
                                            SeikyusyoNo__c = :shid];
                                            
        return sList;
    }
    
    /**
     * 表示用クラス設定
     **/
    private List<SeikyuHeaderDummy> getSeikyuHeaderList (){
        
        // 表示用データ作成
        List<SeikyuHeaderDummy> seikyuHeaderList = new List<SeikyuHeaderDummy>();
        Integer startIndex = (this.dispPage - 1) * MAX_SHEAD_LINE;
        Integer endIndex = Math.min(this.dispPage * MAX_SHEAD_LINE - 1, sHead.size() - 1);
        for(Integer i = startIndex; i <= endIndex; i++ ){
            SeikyuHeader__c item = sHead[i];
            SeikyuHeaderDummy seikyuHeader = new SeikyuHeaderDummy();
            seikyuHeader.seikyuHeader = item;
            if(item.MeisaiLineAmount__c != 0){
                seikyuHeader.pageAmount = Math.ceil(item.MeisaiLineAmount__c / MAX_LINE).intValue();
            }
            seikyuHeaderList.add(seikyuHeader);
        }

        // 最終ページ数を設定
        this.lastPage = (sHead.size() - 1) / MAX_SHEAD_LINE + 1;
        
        return seikyuHeaderList;
    }
    
    
    /**
     * 取り纏め処理
     */
    public PageReference compiledSeikyu() {
        
        Boolean isError = false;
        
        Boolean isComp = false;
        
        // 顧客データ
        List<Account> accList = new List<Account>();
        
        // 更新前請求データ
        List<Seikyu__c> oldSeikyuList = new List<Seikyu__c>();
        
        // 請求ヘッダ
        SeikyuHeader__c seikyuHeader = new SeikyuHeader__c();
        
        // 請求書のコピーリスト
        List<Seikyu__c> newSeikyuList = new List<Seikyu__c>();
        
        // 請求明細のコピーリスト
        List<SeikyuMeisai__c> newSeikyuMeisaiList = new List<SeikyuMeisai__c>();
        
        // 旧請求新請求紐付けMap
        Map<Id,Id> seikyuIdMap = new Map<Id,Id>();
        
        //入力チェック
        if(this.seikyuHeaderList.size() == 0){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '取り纏める請求がありません。'));
            return null;
        }
        if(this.criteria.Seikyusaki__c == null){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '取り纏める顧客を選択してください。'));
            return null;
        }

        try{
            
            // 変更前請求データ
            oldSeikyuList = seikyuList;
            
            // 請求ヘッダ削除フラグをON
            for(SeikyuHeader__c sh : sHead ){
                sh.Del_Flg__c = true;
            }

            update sHead;
            
            // 新規請求ヘッダの作成
            // 締めグループ取得
            String shimeGroup = sHead[0].ShimeGroup__c;

            // 締め日取得
            Date shimebi = sHead[0].Shimebi__c;

            // 顧客データ取得
            accList = [SELECT
                             Id,
                             Name,
                             FurikomiBankName__c,
                             FurikomiKozaType__c,
                             FurikomiKozaNo__c,
                             FurikomiKozaName__c,
                             FurikomiShitenName__c,
                             
                             FurikomiBankName_SMBC__c, //振込先銀行名(SMBC)                                
                             FurikomiKozaType_SMBC__c, //振込先口座種類(SMBC)
                             FurikomiKozaNo_SMBC__c, //振込先口座番号(SMBC)
                             FurikomiKozaName_SMBC__c, //振込先口座名(SMBC)
                             FurikomiShitenName_SMBC__c, //振込先支店名(SMBC)
                             
                             BillingCity,
                             TorihikiKbn__c,
                             BillingState,
                             BillingStreet,
                             BillingPostalCode,
                             KaisyuCycle__c,
                             KaisyuDate__c
                         FROM
                             Account
                         WHERE
                             Id = :this.criteria.Seikyusaki__c];
            
            //SMBCがnullでない場合,振込先情報にSMBCの情報を代入
             String Bankname;
             String KozaType;
             String KozaNo;
             String KozaName;
             String ShitenName;

             If (!String.ISBLANK(accList[0].FurikomiBankName_SMBC__c)){
                 BankName = accList[0].FurikomiBankName_SMBC__c;
                 KozaType = accList[0].FurikomiKozaType_SMBC__c;
                 KozaNo = accList[0].FurikomiKozaNo_SMBC__c;
                 KozaName = accList[0].FurikomiKozaName_SMBC__c;
                 ShitenName= accList[0].FurikomiShitenName_SMBC__c;
             }else{
                 Bankname = accList[0].FurikomiBankName__c;
                 KozaType = accList[0].FurikomiKozaType__c;
                 KozaNo = accList[0].FurikomiKozaNo__c;
                 KozaName = accList[0].FurikomiKozaName__c;
                 ShitenName= accList[0].FurikomiShitenName__c;
             }
             
            // 回収予定日の取得
            // 回収予定日：計算用（月）
            Integer addMonth = 0;

            // 回収サイクルから、回収予定日：計算用（月）を加算
            if (accList[0].kaisyuCycle__c == KAISYU_CYCLE_NEXT) {
                addMonth = 1;
            }
            else if (accList[0].kaisyuCycle__c == KAISYU_CYCLE_NEXT2) {
                addMonth = 2;
            }
            else if (accList[0].kaisyuCycle__c == KAISYU_CYCLE_NEXT3) {
                addMonth = 3;
            }

            // 回収予定日を計算
            Date tmpDate = sHead[0].Shimebi__c.addMonths(addMonth);

            // 回収予定日を取得
            Integer kaisyuYear = tmpDate.year();
            Integer kaisyuMonth = tmpDate.month();
            Integer kaisyuDay = (accList[0].KaisyuDate__c == KAISYU_DATE_END) ? Date.daysInMonth(kaisyuYear, kaisyuMonth) : Integer.valueOf(accList[0].KaisyuDate__c.substring(0, 2));

            // 回収予定日設定
            Date kaisyuScheduledDate = Date.newInstance(kaisyuYear, kaisyuMonth, kaisyuDay);
            
            // 請求ヘッダ作成
            seikyuHeader.Seikyusaki__c = this.criteria.Seikyusaki__c;
            seikyuHeader.KaisyuScheduledDate__c = kaisyuScheduledDate;
            seikyuHeader.SeikyuStatus__c = SH_SEIKYU_STATUS_MISEIKYU;
            seikyuHeader.ShimeGroup__c = shimeGroup;
            seikyuHeader.Shimebi__c = shimebi;
            seikyuHeader.FurikomiBankName__c = BankName;
            seikyuHeader.FurikomiKozaType__c = KozaType;
            seikyuHeader.FurikomiKozaNo__c = KozaNo;
            seikyuHeader.FurikomiKozaName__c = KozaName;
            seikyuHeader.FurikomiShitenName__c = ShitenName;
            seikyuHeader.BillingCity__c = accList[0].BillingCity;
            seikyuHeader.SeikyusakiTorihikiKbn__c = accList[0].TorihikiKbn__c;
            seikyuHeader.BillingState__c = accList[0].BillingState;
            seikyuHeader.BillingStreet__c = accList[0].BillingStreet;
            seikyuHeader.SeikyusakiName__c = accList[0].Name;
            seikyuHeader.BillingPostalCode__c = accList[0].BillingPostalCode;
            seikyuHeader.CompiledSeikyuHeaderFlg__c = true;

            insert seikyuHeader;
            
            // 伝票番号Set
            Set<String> denpyoNoSet = new Set<String>();
            for(Seikyu__c seikyu : seikyuList){
                denpyoNoSet.add(seikyu.DenpyoNo__c);
            }
            
            // 検索用クエリ生成
            String queryString = CommonUtil.getSelectAllQuery('Anken__c');
    
            queryString += ' WHERE Id = :denpyoNoSet';
    
            // 検索実行
            List<Anken__c> oldAnkenList = database.query(queryString);
            
            // 案件コピーし作成するので、請求はコピー作成する際に、コピーし作成した案件のリレーションをやり直す
            // key:旧案件Id、value:新案件Id
            Map<String,Id> denpyoNoIdMap = new Map<String,Id>();
            Map<String,Id> idDenpyoNoMap = new Map<String,Id>();
            List<Anken__c> newAnkenList = new List<Anken__c>();
            
            List<Contact> contactList = [Select Id From Contact Where Account.Id=:accList[0].Id And MainTantoFlg__c = true];
            Id kokyakuTantosyaId = null;
            if(!contactList.isEmpty()){
                kokyakuTantosyaId = contactList[0].Id;
            }
            
            for(Anken__c oldAnken : oldAnkenList){
                Anken__c newAnken = new Anken__c();
                newAnken = oldAnken.clone(false,false,false,false);
                newAnken.OriginalAnkenId__c=oldAnken.Id;
                newAnken.KokyakuTantosya_Main__c=kokyakuTantosyaId;
                newAnken.KokyakuName__c=accList[0].Id;//顧客名
                newAnkenList.add(newAnken);
            }
            insert newAnkenList;
            
            // 旧案件のステータスを「取り纏め処理済み」に変更
            for(Anken__c oldAnken : oldAnkenList){
                oldAnken.StatusLock__c = false;
                oldAnken.Status__c='取り纏め処理済み';
            }
            update oldAnkenList;
            
            // ステータスロックをtrueに変更
            for(Anken__c oldAnken : oldAnkenList){
                oldAnken.StatusLock__c = true;
            }
            update oldAnkenList;
            
            // 取り纏め元と取り纏め先を紐づく用Mapを作成
            for(Anken__c newAnken : newAnkenList){
                denpyoNoIdMap.put(newAnken.OriginalAnkenId__c,newAnken.Id);
                idDenpyoNoMap.put(newAnken.Id,newAnken.OriginalAnkenId__c);
            }
            
            // 案件明細のコピーを作成
            String ankenMeisaiQueryString = CommonUtil.getSelectAllQuery('AnkenMeisai__c');
            ankenMeisaiQueryString += ' WHERE Anken__c = :denpyoNoSet';
            
            List<AnkenMeisai__c> oldAnkeneisaiList = Database.query(ankenMeisaiQueryString);
            
            if(!oldAnkeneisaiList.isEmpty()){
                List<AnkenMeisai__c> newAnkeneisaiList = new List<AnkenMeisai__c>();
                for(AnkenMeisai__c oldAnkenMeisai : oldAnkeneisaiList){
                    AnkenMeisai__c newAnkenMeisai = new AnkenMeisai__c();
                    newAnkenMeisai = oldAnkenMeisai.clone(false,false,false,false);
                    newAnkenMeisai.Anken__c = denpyoNoIdMap.get(oldAnkenMeisai.Anken__c);
                    newAnkeneisaiList.add(newAnkenMeisai);
                }
                insert newAnkeneisaiList;
            }
            
            // 請求のコピーを作成
            for(Seikyu__c seikyu : seikyuList){
                Seikyu__c copySeikyu = new Seikyu__c();
                copySeikyu.SeikyusyoNo__c = seikyuHeader.Id;
                copySeikyu.AnkenTantosya__c = seikyu.AnkenTantosya__c;
                copySeikyu.AnkenName__c = seikyu.AnkenName__c;
                copySeikyu.Offset_Flg__c = seikyu.Offset_Flg__c;
                copySeikyu.OffsetNyukin__c = seikyu.OffsetNyukin__c;
                copySeikyu.DenpyoNo__c = denpyoNoIdMap.get(seikyu.DenpyoNo__c);
                copySeikyu.UriageDateTime__c = seikyu.UriageDateTime__c;
                newSeikyuList.add(copySeikyu);
            }
            
            insert newSeikyuList;
            
            // 旧請求Map
            Map<Id,Id> oldSeikyuMap = new Map<Id,Id>();
            for(Seikyu__c oldSeikyu : seikyuList){
                oldSeikyuMap.put(oldSeikyu.DenpyoNo__c,oldSeikyu.Id);
            }

            // 旧請求と新請求を紐付けたMap
            for(Seikyu__c newSeikyu : newSeikyuList){
                seikyuIdMap.put(oldSeikyuMap.get(idDenpyoNoMap.get(newSeikyu.DenpyoNo__c)),newSeikyu.Id);
            }

            // 請求明細のコピーを作成       
            for(SeikyuMeisai__c oldSeikyuMeisai : sMeisaListi){
                SeikyuMeisai__c copySeikyuMeisai = new SeikyuMeisai__c();
                copySeikyuMeisai.SeikyuNo__c = seikyuIdMap.get(oldSeikyuMeisai.SeikyuNo__c);
                copySeikyuMeisai.SagyoCd__c = oldSeikyuMeisai.SagyoCd__c;
                copySeikyuMeisai.SagyoName__c = oldSeikyuMeisai.SagyoName__c;
                copySeikyuMeisai.TaxRate__c = oldSeikyuMeisai.TaxRate__c;
                copySeikyuMeisai.Suryo__c = oldSeikyuMeisai.Suryo__c;
                copySeikyuMeisai.Tanka__c = oldSeikyuMeisai.Tanka__c;
                copySeikyuMeisai.Nanido__c = oldSeikyuMeisai.Nanido__c;
                newSeikyuMeisaiList.add(copySeikyuMeisai);
            }
            insert newSeikyuMeisaiList;
            
            List<SeikyuHeader__c> sh = new List<SeikyuHeader__c>();
            sh.add(seikyuHeader);
            // 請求書作成リスト作成、請求書作成フラグON
            this.createPdfList = sh.clone();
            this.shuseiOldSeikyuList = oldSeikyuList.clone();

            if(newSeikyuMeisaiList.size() != 0){
                this.isCreatePdf = true;
            }else{
                // 旧請求と案件の紐付けをクリア
                for(Seikyu__c seikyu : seikyuList){
                    seikyu.DenpyoNo__c = null;
                }
                update seikyuList;
                
                //一覧の内容をクリア
                this.seikyuHeaderList.clear(); 
                
                isComp = true;
            }
        }catch(Exception e){
            // エラーフラグを更新
            isError = true;
            
            // 請求ヘッダ削除フラグをOFF
            for(SeikyuHeader__c sh : sHead ){
                sh.Del_Flg__c = false;
            }
            System.debug(e);
            update sHead;
            update oldSeikyuList;
            
            if(seikyuHeader != null){
                delete seikyuHeader;
            }
            
        }finally{
            
            if(isError){
                // エラーメッセージを表示
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書取り纏めに失敗しました。'));
            }
            if(isComp){
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求書取り纏め処理が完了しました。'));
            }
            if(isCreatePdf){
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求書作成中です。しばらくお待ちください。'));
            }
        }
        
        return null;
    }
    
    /**
     * 請求書作成
     * 請求取り纏め後に自動的に実行されます。
     * 請求取り纏めと処理を分けている理由は下記の通り。
     * ・同一トランザクションでPDF作成を行うと
     *  請求ヘッダ、請求、請求明細の各レコードがコミットされていないため
     *  白紙の請求書PDFが作成されてしまうことを回避するため。
     */
    public PageReference createPdf() {

        Boolean isError = false;

        // 請求書作成
        try {
            List<Attachment> upsAttList = new List<Attachment> ();
            for (SeikyuHeader__c item : this.createPdfList) {
                // PDF生成
                upsAttList.add(this.getAttachmentPdf(item.Id));
            }
            upsert upsAttList;

            // 請求ヘッダ更新（請求書ID）
            for (SeikyuHeader__c item : this.createPdfList) {
                // 請求書ID設定
                for (Attachment att : upsAttList) {
                    if (item.Id == att.parentId) {
                        item.SeikyusyoId__c = att.Id;
                        break;
                    }
                }
            }
            update this.createPdfList;
            
            // 旧請求と案件の紐付けをクリア
            for(Seikyu__c seikyu : seikyuList){
                seikyu.DenpyoNo__c = null;
            }
            
            update seikyuList;
            
            //一覧の内容をクリア
            this.seikyuHeaderList.clear(); 

        } catch(Exception e) {
            // エラーフラグを更新
            isError = true;

            // 作成された請求ヘッダ、請求、請求明細をdelete
            if(this.createPdfList.size() != 0){
                delete this.createPdfList;
            }
            
            // 請求ヘッダ削除フラグをOFF
            for(SeikyuHeader__c sh : sHead ){
                sh.Del_Flg__c = false;
            }
            
            update sHead;
            update shuseiOldSeikyuList;

        }finally{
        
            this.isCreatePdf = false;
            
            if(isError){
                // エラーメッセージを表示
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書作成に失敗しました。'));
            }else{
                // 完了メッセージを表示
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求書取り纏め処理が完了しました。'));
            } 
        }

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
     * ページング
     */
    public PageReference paging() {

        // 表示クラス設定
        this.seikyuHeaderList = this.getSeikyuHeaderList();

        return null;
    }
    
    /**
     * 画面表示用クラス
     */
    public class SeikyuHeaderDummy {

        /** 請求ヘッダデータ */
        public SeikyuHeader__c seikyuHeader {get; set;}

        /** 請求書ページ数 */
        public Integer pageAmount {get; set;}

        /** デフォルトコンストラクタ */
        public SeikyuHeaderDummy() {
            this.pageAmount = 1;
        }
    }
    
}