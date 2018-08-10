public with sharing class SeikyusyoController {
    /** 請求ヘッダID */
    private List<String> seikyuHeaderId;

    /** 請求ヘッダ区切り文字 */
    private static String DELIMITER = ',';

    /** １ページの表示数 */
    private static integer MAX_LINE = 15;

    /** 2ページ目以降の表示数 */
    private static integer MAX_LINE_2 = 19;

    /** 小計タイトル */
    private static String SUBTOTAL_TITLE = '<小計>';

    /** スタイルクラス（明細） */
    private static String STYLE_CLASS_MEISAI = 'meisai';
    
    /** スタイルクラス（明細ヘッダ行） */
    private static String STYLE_CLASS_HEAD = 'head';

    /** スタイルクラス（小計） */
    private static String STYLE_CLASS_SUBTOTAL = 'subtotal';

    /** 請求書データ */
    public List<List<PageData>> seikyusyoList {
        get;
        private set;
    }

    /** 案件名 */
    public String AnkenName {get; set;}

    /** 案件担当者 */
    public String AnkenTantosya {get; set;}

    /** お客様番号 */
    public String ClientOrderNumber {get; set;}

    /** 売上日時 */
    public Datetime uriage {get; set;}

    /** 伝票番号 */
    public String denpyo {get; set;}

    /**
     * デフォルトコンストラクタ
     */
    public SeikyusyoController() {
        this.seikyuHeaderId = ApexPages.currentPage().getParameters().get('shid').split(DELIMITER);
        this.init();
    }

    /**
     * 初期化処理
     */
    public PageReference init() {
        // 請求ヘッダデータ取得
        List<SeikyuHeader__c> sHead = this.getSeikyuHeaderData(this.seikyuHeaderId);

        // 請求明細データ取得
        List<SeikyuMeisai__c> sMeisaiList = this.getSeikyuMeisai(this.seikyuHeaderId);

        //
        AnkenName = sMeisaiList[0].SeikyuNo__r.AnkenName__c;
        AnkenTantosya = sMeisaiList[0].SeikyuNo__r.AnkenTantosya__c;
        ClientOrderNumber = sMeisaiList[0].SeikyuNo__r.DenpyoNo__r.ClientOrderNumber__c;

        // 請求ヘッダマップ作成
        Map<Id, SeikyuHeader__c> sHeadMap = new Map<Id, SeikyuHeader__c>();
        for(Integer i = 0; i < sHead.size(); i++){
            sHeadMap.put(sHead[i].Id, sHead[i]);
        }

        // 明細データマップ作成
        Map<Id, List<MeisaiData>> sMeisaiMap = new Map<Id, List<MeisaiData>>();
        Map<Id, Decimal> suryoMap = new Map<Id, Decimal>();
        Map<Id, Decimal> kingakuMap = new Map<Id, Decimal>();
        Map<Id, Decimal> taxMap = new Map<Id, Decimal>();
        Map<Id, Decimal> kurikoshigakuMap = new Map<Id, Decimal>();
        // 小計明細データ
        MeisaiData subtotalMeisaiData = null;
        // 前明細の伝票番号
        String denpyoNoBef = null;
        // 前明細の請求書番号
        Id seikyusyoNoBef = null;
        // 合計数量
        Decimal totalSuryo = 0;
        // 合計金額（税抜き）
        Decimal totalKingaku = 0;
        // 消費税
        Decimal totalTax = 0;

        for(Integer j = 0; j < sMeisaiList.size(); j++){
            // 請求明細取得
            SeikyuMeisai__c seikyuMeisai = sMeisaiList[j];

            if(seikyuMeisai.SeikyuNo__r.DenpyoNo__c != null){

                // 伝票番号取得
                String denpyoNo = seikyuMeisai.SeikyuNo__r.DenpyoNo__r.Name;
                Id seikyusyoNo = seikyuMeisai.SeikyuNo__r.SeikyusyoNo__c;
                // 売上日時取得
                Datetime uriageDate = seikyuMeisai.SeikyuNo__r.UriageDateTime__c;
                // 明細データ作成
                MeisaiData meisaiData = new MeisaiData(STYLE_CLASS_MEISAI);                
                meisaiData.seikyuMeisai = seikyuMeisai;

                // 明細ヘッダ行作成
                MeisaiData meisaiDataHead = new MeisaiData(STYLE_CLASS_HEAD);
                meisaiDataHead.seikyuMeisai = seikyuMeisai;                

                if(denpyoNoBef != denpyoNo){     
                    meisaiDataHead.denpyoNo = denpyoNo;
                    meisaiDataHead.uriageDate = uriageDate;

                    
                    if(denpyoNoBef != null){
                        sMeisaiMap.get(seikyusyoNoBef).add(subtotalMeisaiData);
                        if(seikyusyoNoBef != seikyusyoNo){
                            suryoMap.put(seikyusyoNoBef, totalSuryo);
                            kingakuMap.put(seikyusyoNoBef, totalKingaku);
                            taxMap.put(seikyusyoNoBef, totalTax);
                            totalSuryo = 0;
                            totalKingaku = 0;
                            totalTax = 0;
                        } 
                        
                    }
                    // 明細ヘッダ行ータを追加
                    if(sMeisaiMap.containsKey(seikyusyoNo)){
                        sMeisaiMap.get(seikyusyoNo).add(meisaiDataHead);
                    }else{
                        List<MeisaiData> mdList = new List<MeisaiData>();
                        mdList.add(meisaiDataHead);
                        sMeisaiMap.put(seikyusyoNo, mdList);
                    }
                    
                    // 小計作成
                    subtotalMeisaiData = new MeisaiData(STYLE_CLASS_SUBTOTAL);
                }

                // 小計を計算
                subtotalMeisaiData.subtotalSuryo += seikyuMeisai.Suryo__c;
                subtotalMeisaiData.subtotalSeikyugaku += seikyuMeisai.Kingaku__c;
                subtotalMeisaiData.subtotalTax += seikyuMeisai.Tax__c;

                // 合計を計算
                totalSuryo += seikyuMeisai.Suryo__c;
                totalKingaku += seikyuMeisai.Kingaku__c;
                totalTax += seikyuMeisai.Tax__c;

                // 明細データを追加
                if(sMeisaiMap.containsKey(seikyusyoNo)){
                    sMeisaiMap.get(seikyusyoNo).add(meisaiData);
                }else{
                    List<MeisaiData> mdList = new List<MeisaiData>();
                    mdList.add(meisaiData);
                    sMeisaiMap.put(seikyusyoNo, mdList);
                }

                // 伝票番号を更新
                denpyoNoBef = denpyoNo;
                // 請求書番号を更新
                seikyusyoNoBef = seikyusyoNo;

            }else if(seikyuMeisai.SeikyuNo__r.OffsetNyukin__c != null){

                // 前回繰越額マップを初期化
                if(!kurikoshigakuMap.containsKey(seikyuMeisai.SeikyuNo__r.SeikyusyoNo__c)){
                    kurikoshigakuMap.put(seikyuMeisai.SeikyuNo__r.SeikyusyoNo__c, 0);
                }

                // 前回繰越額を加算
                if(seikyuMeisai.Kingaku_Tax__c != null){
                    Decimal kurikoshigakuTemp = kurikoshigakuMap.get(seikyuMeisai.SeikyuNo__r.SeikyusyoNo__c);
                    kurikoshigakuMap.put(seikyuMeisai.SeikyuNo__r.SeikyusyoNo__c, kurikoshigakuTemp + seikyuMeisai.Kingaku_Tax__c);
                }
            }
        }

        // 最後の小計データ,合計を登録
        if(subtotalMeisaiData != null){
            sMeisaiMap.get(seikyusyoNoBef).add(subtotalMeisaiData);
            suryoMap.put(seikyusyoNoBef, totalSuryo);
            kingakuMap.put(seikyusyoNoBef, totalKingaku);
            taxMap.put(seikyusyoNoBef, totalTax);
        }

        // 請求書データリストを作成
        this.seikyusyoList = new List<List<PageData>>();
        for(Id shid :this.seikyuHeaderId){
            this.createSeikyusyoList(sHeadMap.get(shid), sMeisaiMap.get(shid), suryoMap.get(shid), kingakuMap.get(shid), taxMap.get(shid), kurikoshigakuMap.get(shid));
        }

        // 最終ヘッダフラグを更新
        List<PageData> lastSeikyusyo = this.seikyusyoList[this.seikyusyoList.size() - 1];
        lastSeikyusyo[lastSeikyusyo.size() - 1].isLastHead = true;

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
                                        KaisyuScheduledDate__c, //回収予定日
                                        Shimebi__c
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
                                            Suryo__c, //数量
                                            Tanka__c, //単価（割引後）
                                            Kingaku__c, //金額
                                            Tax__c, //消費税
                                            Kingaku_Tax__c, //金額（税込み）
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
     * 請求書データを作成する。
     *
     * @param sHead 請求ヘッダデータ
     * @param meisaiDataList 請求明細データ
     * @param suryo 数量
     * @param kurikoshigaku 前回繰越額
     */
    private void createSeikyusyoList(SeikyuHeader__c sHead, List<MeisaiData> meisaiDataList, Decimal suryo, Decimal kingaku, Decimal tax, Decimal kurikoshigaku){

        // 請求書データ生成
        PageData pageItem = null;
        Integer pageNo = 0;
        List<PageData> pageDataList = new List<PageData>();
        //2ページ目以降のフラグ
        Boolean twoPageFlg = false;

        // 請求明細データの存在チェック
        if (meisaiDataList == null || meisaiDataList.size() == 0) {
            // 請求明細がない場合は、0円の請求書を作成する
            pageItem = new PageData();
            pageItem.sHead = sHead;
            pageItem.setSeikyusakiNameList();
            if(kurikoshigaku != null){
                pageItem.kurikoshigaku = -kurikoshigaku;
            }
            pageItem.pageNo = 1;
            pageItem.isFirst = true;
            pageItem.isLast = true;
            pageDataList.add(pageItem);
        } else {
            // 請求明細がある場合
            for (Integer i = 0; i < meisaiDataList.size(); i ++) {

                // １ページに対する明細行Index
                Integer row;
                Integer diffLine = MAX_LINE_2 - MAX_LINE;
                if(!twoPageFlg){
                    row = Math.mod(i, MAX_LINE);
                }else{
                    row = Math.mod(i + diffLine, MAX_LINE_2);
                }

                // １ページに対する基本情報を生成
                if (row == 0) {
                    // ページデータを追加
                    pageItem = new PageData();
                    pageItem.pageNo = (++ pageNo);
                    pageDataList.add(pageItem);

                    // 請求ヘッダデータ を設定（各ページ共通）
                    pageItem.sHead = sHead;
                    pageItem.setSeikyusakiNameList();

                    // １ページ目かどうか
                    if (i == 0) {
                        pageItem.isFirst = true;
                    }

                    // 最終ページかどうか
                    if(pageItem.pageNo == 1 && meisaiDataList.size() <= MAX_LINE){
                        pageItem.isLast = true;
                        pageItem.suryo = suryo;
                        pageItem.kingaku = kingaku;
                        pageItem.tax = tax;
                        if(kurikoshigaku != null){
                            pageItem.kurikoshigaku = -kurikoshigaku;
                        }
                    }else if(pageItem.pageNo != 1 && meisaiDataList.size() <= ((pageItem.pageNo - 1) * MAX_LINE_2 + MAX_LINE)){
                        pageItem.isLast = true;
                        pageItem.suryo = suryo;
                        pageItem.kingaku = kingaku;
                        pageItem.tax = tax;
                        if(kurikoshigaku != null){
                            pageItem.kurikoshigaku = -kurikoshigaku;
                        }
                    }
                }

                // ２ページ目以降のフラグを立てる
                if(i >= MAX_LINE){
                    twoPageFlg = true;
                }

                // 請求明細データを設定
                pageItem.meisaiList.add(meisaiDataList[i]);
            }
        }

        // MAX_LINEに満たない行に空白行を設定
        if(!twoPageFlg){
            for (Integer i = pageItem.meisaiList.size(); i < MAX_LINE; i ++) {
                pageItem.meisaiList.add(new MeisaiData(STYLE_CLASS_MEISAI));
            }
        }else{
            for (Integer i = pageItem.meisaiList.size(); i < MAX_LINE_2; i ++) {
                pageItem.meisaiList.add(new MeisaiData(STYLE_CLASS_MEISAI));
            }
        }

        this.seikyusyoList.add(pageDataList);

    }

    /**
     * 明細のデータを纏めたクラス
     */
    public class MeisaiData {

        /** 請求明細 */
        public SeikyuMeisai__c seikyuMeisai {get; set;}

        /** 売上日時 */
        public Datetime uriageDate {get; set;}

        /** 伝票番号 */
        public String denpyoNo {get; set;}

        /** 小計タイトル */
        public String subtotalTitle {get; set;}

        /** 小計数量 */
        public Decimal subtotalSuryo {get; set;}

        /** 小計金額（税抜き） */
        public Decimal subtotalSeikyugaku {get; set;}

        /** 小計消費税 */
        public Decimal subtotalTax {get; set;}

        /** スタイルクラス */
        public String styleClass {get; set;}

        /** デフォルトコンストラクタ */
        public MeisaiData(String styleClass) {
            this.subtotalTitle = SUBTOTAL_TITLE;
            this.subtotalSuryo = 0;
            this.subtotalSeikyugaku = 0;
            this.subtotalTax = 0;
            this.styleClass = styleClass;
        }
    }

    /**
     * １ページのデータを纏めたクラス
     */
    public class PageData {

        /** このページに表示する請求データ */
        public SeikyuHeader__c sHead {get; set;}

        /** このページに表示する請求明細リスト */
        public List<MeisaiData> meisaiList {get; set;}

        /** 請求先名リスト */
        public List<String> seikyusakiNameList {get; set;}

        /** 数量 */
        public Decimal suryo {get; set;}

        /** 合計（税抜き） */
        public Decimal kingaku {get; set;}

        /** 消費税 */
        public Decimal tax {get; set;}

        /** 前回繰越額 */
        public Decimal kurikoshigaku {get; set;}

        /** ページ番号 */
        public Integer pageNo {get; set;}

        /** １ページ目かどうか */
        public boolean isFirst {get; set;}

        /** 最終ページかどうか */
        public boolean isLast {get; set;}

        /** 最終請求ヘッダかどうか */
        public boolean isLastHead {get; set;}

        /** デフォルトコンストラクタ */
        public PageData() {
            this.meisaiList = new List<MeisaiData> ();
            this.seikyusakiNameList = new List<String>();
            this.suryo = 0;
            this.kingaku = 0;
            this.tax = 0;
            this.kurikoshigaku = 0;
            this.isFirst = false;
            this.isLast = false;
            this.isLastHead = false;
        }

        /**
         * 請求先名を分割しリストに設定
         */
        private void setSeikyusakiNameList(){

            String seikyusakiName = this.sHead.SeikyusakiName__c;

            while (seikyusakiName.length() > 20){
                this.seikyusakiNameList.add(seikyusakiName.substring(0, 20));
                seikyusakiName = seikyusakiName.substring(20);
            }
            this.seikyusakiNameList.add(seikyusakiName);
        }

    }
}