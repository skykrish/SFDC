public with sharing class NyukinJidoRegisterController {

    // オブジェクト
    private Document d;

    // コントローラ
    private ApexPages.StandardController controller;

    // CSVカラムインデックス
    private Integer torihikiDateIndex;
    private Integer nyukinkingakuIndex;
    private Integer furikomiiraininNoIndex;
    private Integer furikomiiraininNameIndex;

    // データ保持リスト
    private List<List<String>> csvDataList;
    private List<NyukinDummy> nyukinList;
    transient Map<String,Id> accountIdMap;
    transient Map<String,Integer> accountAmountMap;

    public List<NyukinDummy> getNyukinList() {
        return this.NyukinList;
    }

    // 自動取込ボタン非表示フラグ
    private boolean disabledTorikomiBtnFlag;

    public boolean getDisabledTorikomiBtnFlag() {
        return this.disabledTorikomiBtnFlag;
    }

    // 定数
    private static String TITLE_TORIHIKI_DATE = '取引日';
    private static String TITLE_NYUKINGAKU = '入金金額';
    private static String TITLE_FURIKOMIIRAININ_NO = '振込依頼人番号';
    private static String TITLE_FURIKOMIIRAININ_NAME = '振込依頼人名';
    private static String ERROR_MESSAGE_HEADER = '行数';
    private static String ERROR_MESSAGE_TORIHIKI_DATE = '　：　取引日が不正です。';
    private static String ERROR_MESSAGE_NYUKINGAKU = '　：　入金金額が不正です。';
    private static String ERROR_MESSAGE_FURIKOMIIRAININ_NO = '　：　振込依頼人番号が不正です。';
    private static String ERROR_MESSAGE_FURIKOMIIRAININ_NAME = '　：　振込依頼人名が不正です。';
    private static Integer TORIHIKI_DATE_LENGTH = 6;
    private static Integer NYUKINGAKU_LENGTH = 18;
    private static Integer FURIKOMIIRAININ_NO_LENGTH = 10;
    private static String SLASH = '/';
    private static String SEIKYU_STATUS_SEIKYUZUMI = '請求済み';
    private static String NYUKIN_STATUS_MINYUKIN = '未入金';
    private static String NYUKIN_STATUS_NYUKINZUMI = '入金済み';
    private static String NYUKIN_TYPE_GINKOFURIKOMI = '銀行振り込み';
    private static String STATUS_SHINKI = '新規';
    private static String STATUS_KESHIKOMIZUMI = '消し込み済み';
    private static String DISPLAY_OK = 'OK';
    private static String DISPLAY_NG = 'NG';
    private static String INSERT_METHOD_AUTO = 'AUTO';

    /**
     * コンストラクタ
     */
    public NyukinJidoRegisterController (ApexPages.StandardController controller) {
        this.controller = controller;
        this.d = (Document) controller.getRecord();
        this.disabledTorikomiBtnFlag = true;
    }

    /**
     * チェックボタン押下時のCSVデータのチェック
     */
    public PageReference check() {

        this.disabledTorikomiBtnFlag = false;

        // ドキュメントを取得
        this.d = (Document) this.controller.getRecord();

        // nyukinListを初期化
        this.nyukinList = new List<NyukinDummy>();

        // CSVが空の場合
        if(d.Body == null){
            this.disabledTorikomiBtnFlag = true;
            return null;
        }

        // CSVをList<List<String>>に変換
        String strBody = d.Body.toString();
        this.csvDataList = Csv2List.getListEasy(strBody);

        // ヘッダーの必要項目存在チェック
        if(!titleValidation(this.csvDataList[0])){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CSVファイルに必要な項目が存在しないか、またはCSVファイルがUTF-8以外の形式の可能性があります。'));
            this.disabledTorikomiBtnFlag = true;
            return null;
        }

        // CSVが空もしくはヘッダーのみの場合
        if(this.csvDataList == null || this.csvDataList.size() <= 1){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CSVファイルにタイトル行しか存在しません。'));
            this.disabledTorikomiBtnFlag = true;
            return null;
        }

        // CSVのデータが上限を超えていた場合
        if(this.csvDataList.size() > Integer.valueOf(System.Label.ExecuteLimitCount_NyukinJidoRegister) + 1){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '入金自動登録処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_NyukinJidoRegister + '件です。'));
            this.disabledTorikomiBtnFlag = true;
            return null;
        }

        // 顧客オブジェクトの取得
        List<AggregateResult> accounts = [SELECT Max(Id)id,
                                                Count(id)amount,
                                                FurikomiShitenCd__c,
                                                FurikomiKozaNo__c
                                            FROM Account
                                            GROUP BY FurikomiShitenCd__c, FurikomiKozaNo__c];

        // 取得した値をMAPに格納
        accountIdMap = new Map<String,Id>();
        accountAmountMap = new Map<String,Integer>();
        for(AggregateResult result : accounts){
            String kye = String.valueOf(result.get('FurikomiShitenCd__c')) + String.valueOf(result.get('FurikomiKozaNo__c'));
            accountIdMap.put(kye, String.valueOf(result.get('id')));
            accountAmountMap.put(kye, Integer.valueOf(result.get('amount')));
        }

        // CSVデータを入金オブジェクト挿入用クラスに変換
        for(Integer i = 1; i < this.csvDataList.size() ; i++){
            NyukinDummy nyukinData = new NyukinDummy();

            if(this.csvDataList[i].size() == this.csvDataList[0].size()){
                nyukinData.no = i;
                nyukinData.torihikiDate = this.csvDataList[i][this.torihikiDateIndex];
                nyukinData.nyukinkingaku = this.csvDataList[i][this.nyukinkingakuIndex];
                nyukinData.furikomiiraininNo = this.csvDataList[i][this.furikomiiraininNoIndex];
                nyukinData.furikomiiraininName = this.csvDataList[i][this.furikomiiraininNameIndex];
                if(!this.validation(nyukinData)){
                    nyukinData.torikomi = DISPLAY_NG;
                    this.disabledTorikomiBtnFlag = true;
                }
            }else{
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ERROR_MESSAGE_HEADER + i + '　：　カラム数が不正です。'));
                nyukinData.no = i;
                nyukinData.torikomi = DISPLAY_NG;
                this.disabledTorikomiBtnFlag = true;
            }
            this.nyukinList.add(nyukinData);
        }

        return null;
    }

    /**
     * 自動取込ボタン押下時の入金データ自動取込
     */
    public PageReference register() {

        // 入金挿入リスト
        List<Nyukin__c> insertNyukinList = new List<Nyukin__c>();
        // 請求ヘッダ更新リスト
        List<SeikyuHeader__c> updateShList = new List<SeikyuHeader__c>();

        // 請求ヘッダを取得
        List<SeikyuHeader__c> seikyuHeaders = [SELECT id,
                                                    Seikyusaki__r.Id,
                                                    FurikomiKozaNo__c,
                                                    Seikyugaku_Tax__c,
                                                    NyukinStatus__c,
                                                    Keshikomibi__c
                                                FROM SeikyuHeader__c
                                                WHERE SeikyuStatus__c = :SEIKYU_STATUS_SEIKYUZUMI
                                                    AND NyukinStatus__c = :NYUKIN_STATUS_MINYUKIN
                                                    AND Del_Flg__c = FALSE
                                                ORDER BY SeikyuDateTime__c ASC];

        // 取得した請求ヘッダをMAPに格納
        Map<String, List<SeikyuHeader__c>> seikyuHeaderMap = new Map<String, List<SeikyuHeader__c>>();
        for(Integer i = 0; i < seikyuHeaders.size(); i++){
            SeikyuHeader__c seikyuHeader = seikyuHeaders[i];
            String key = seikyuHeader.Seikyusaki__r.Id + String.valueOf(seikyuHeader.Seikyugaku_Tax__c);
            if(!seikyuHeaderMap.containsKey(key)){
                List<SeikyuHeader__c> shTmpList = new List<SeikyuHeader__c>();
                shTmpList.add(seikyuHeader);
                seikyuHeaderMap.put(key ,shTmpList);
            }else{
                seikyuHeaderMap.get(key).add(seikyuHeader);
            }

        }

        // CSVデータごとに入金登録と請求ヘッダの消し込み
        for(NyukinDummy dummy: nyukinList){

            // 入金オブジェクト挿入用クラスの引当を設定
            dummy.hikiate = DISPLAY_NG;

            List<String> torihikiDateList = dummy.torihikiDateDisp.split(SLASH);
            Integer year = Integer.valueOf(torihikiDateList[0]);
            Integer month = Integer.valueOf(torihikiDateList[1]);
            Integer day = Integer.valueOf(torihikiDateList[2]);
            Decimal nyukinkingaku = Decimal.valueOf(dummy.nyukinkingaku);

            // 入金作成
            Nyukin__c nyukin = new Nyukin__c();
            nyukin.Nyukinsaki__c = dummy.id;
            nyukin.NyukinType__c = NYUKIN_TYPE_GINKOFURIKOMI;
            nyukin.NyukinDate__c = Date.newInstance(year, month, day);
            nyukin.Nyukingaku__c = nyukinkingaku;
            nyukin.TegataKijitsu__c = null;
            nyukin.Tekiyo__c = null;
            nyukin.FurikomiIraininNo__c = dummy.furikomiiraininNo;
            nyukin.Status__c = STATUS_SHINKI;
            nyukin.InsertMethod__c = INSERT_METHOD_AUTO;

            String key = dummy.id + String.valueOf(nyukinkingaku);

            if(seikyuHeaderMap.containsKey(key)){
                List<SeikyuHeader__c> shTmpList = seikyuHeaderMap.get(key);
                for(Integer j = 0; j < shTmpList.size(); j++){
                    SeikyuHeader__c seikyuHeader = shTmpList[j];
                    // 請求ヘッダの消し込み
                    if(seikyuHeader.NyukinStatus__c.equals(NYUKIN_STATUS_MINYUKIN)){
                        seikyuHeader.NyukinStatus__c = NYUKIN_STATUS_NYUKINZUMI;
                        seikyuHeader.Keshikomibi__c = System.now();
                        updateShList.add(seikyuHeader);

                        // 入金のステータスと消し込み日を設定
                        nyukin.Status__c = STATUS_KESHIKOMIZUMI;
                        nyukin.Keshikomibi__c = System.now();

                        // 入金オブジェクト挿入用クラスの引当を設定
                        dummy.hikiate = DISPLAY_OK;
                        break;
                    }
                }
            }

            insertNyukinList.add(nyukin);
        }

        insert insertNyukinList;
        if(updateShList.size() != 0){
            update updateShList;
        }
        this.disabledTorikomiBtnFlag = true;
        if(insertNyukinList.size() == updateShList.size()){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, '入金自動登録処理が完了しました。'));
        }else{
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '入金自動登録処理が完了しました。消し込みされていないデータが存在します。'));
        }
        return null;

    }

    /**
     * ヘッダーの必要項目存在チェック
     *
     * @param titleData CSVデータのヘッダー行
     * @return true:OK, false:NG
     */
    private boolean titleValidation(List<String> titleData){

        // 必要項目存在フラグ
        boolean torihikiDateFlag = false;
        boolean nyukinkingakuFlag = false;
        boolean furikomiiraininNoFlag = false;
        boolean furikomiiraininNameFlag = false;

        for(Integer i = 0; i < titleData.size(); i++){
            // カラム名が空の場合
            if(Strings.isNullOrEmpty(titleData[i])){
                continue;
            }

            // カラム名が「取引日」の場合
            if(titleData[i].equals(TITLE_TORIHIKI_DATE)){
                torihikiDateIndex = i;
                torihikiDateFlag = true;
            // カラム名が「入金金額」の場合
            }else if(titleData[i].equals(TITLE_NYUKINGAKU)){
                nyukinkingakuIndex = i;
                nyukinkingakuFlag = true;
            // カラム名が「振込依頼人番号」の場合
            }else if(titleData[i].equals(TITLE_FURIKOMIIRAININ_NO)){
                furikomiiraininNoIndex = i;
                furikomiiraininNoFlag = true;
            // カラム名が「振込依頼人名」の場合
            }else if(titleData[i].equals(TITLE_FURIKOMIIRAININ_NAME)){
                furikomiiraininNameIndex = i;
                furikomiiraininNameFlag = true;
            }
        }

        // 必須項目がすべて存在する場合
        if(torihikiDateFlag && nyukinkingakuFlag && furikomiiraininNoFlag && furikomiiraininNameFlag){
            return true;
        // 必須項目が一つでも存在しない場合
        }else {
            return false;
        }
    }

    /**
     * CSVデータチェック
     *
     * @param nyukinData CSVデータの値を代入した入金オブジェクト挿入用クラス
     * @return true:OK, false:NG
     */
    private boolean validation(NyukinDummy nyukinData){

        boolean ret = true;
        boolean tmp = true;

        // 取引日チェック
        // 必須チェック
        if(Strings.isNullOrEmpty(nyukinData.torihikiDate, true)){
            ret = false;
            tmp = false;
        // 文字数チェック
        }else if(nyukinData.torihikiDate.length() != TORIHIKI_DATE_LENGTH){
            ret = false;
            tmp = false;
        // 数値チェック
        }else if(!Strings.isInteger(nyukinData.torihikiDate)){
            ret = false;
            tmp = false;
        // 日付チェック
        }else if(!Strings.isDate(createTorihikiDateDisp(nyukinData.torihikiDate))){
            ret = false;
            tmp = false;
        }

        // エラーメッセージ設定
        if(!tmp){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ERROR_MESSAGE_HEADER + nyukinData.No + ERROR_MESSAGE_TORIHIKI_DATE));
            nyukinData.torihikiDateDisp = nyukinData.torihikiDate;
        }else{
            nyukinData.torihikiDateDisp = createTorihikiDateDisp(nyukinData.torihikiDate);
        }

        // テンプフラグの初期化
        tmp = true;

        // 入金金額チェック
        // 必須チェック
        if(Strings.isNullOrEmpty(nyukinData.nyukinkingaku, true)){
            ret = false;
            tmp = false;
        // 桁数チェック
        }else if(nyukinData.nyukinkingaku.length() > NYUKINGAKU_LENGTH){
            ret = false;
            tmp = false;
        // 数値チェック(桁数が9桁以内)
        }else if(nyukinData.nyukinkingaku.length() <= 9 && !Strings.isInteger(nyukinData.nyukinkingaku)){
            ret = false;
            tmp = false;
        // 数値チェック(桁数が10桁以上の前半9桁)
        }else if(nyukinData.nyukinkingaku.length() >= 10 && !Strings.isInteger(nyukinData.nyukinkingaku.substring(0,9))){
            ret = false;
            tmp = false;
        // 数値チェック(桁数が10桁以上の後半9桁)
        }else if(nyukinData.nyukinkingaku.length() >= 10 && !Strings.isInteger(nyukinData.nyukinkingaku.substring(9))){
            ret = false;
            tmp = false;
        }

        // エラーメッセージ設定
        if(!tmp){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ERROR_MESSAGE_HEADER + nyukinData.No + ERROR_MESSAGE_NYUKINGAKU));
            nyukinData.nyukinkingakuDisp = nyukinData.nyukinkingaku;
        }else{
            nyukinData.nyukinkingakuDisp = createNyukinkingakuDisp(nyukinData.nyukinkingaku);
        }

        // テンプフラグの初期化
        tmp = true;

        // 振込依頼人番号チェック
        // 必須チェック
        if(Strings.isNullOrEmpty(nyukinData.furikomiiraininNo, true)){
            ret = false;
            tmp = false;
        // 桁数チェック
        }else if(nyukinData.furikomiiraininNo.length() != FURIKOMIIRAININ_NO_LENGTH){
            ret = false;
            tmp = false;
        // 数値チェック(前半3桁)
        }else if(!Strings.isInteger(nyukinData.furikomiiraininNo.substring(0,3))){
            ret = false;
            tmp = false;
        // 数値チェック(後半7桁)
        }else if(!Strings.isInteger(nyukinData.furikomiiraininNo.substring(3))){
            ret = false;
            tmp = false;
        }


        // エラーメッセージ設定
        if(!tmp){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ERROR_MESSAGE_HEADER + nyukinData.No + ERROR_MESSAGE_FURIKOMIIRAININ_NO));
        }else{
            nyukinData.furikomiShitenCd = nyukinData.furikomiiraininNo.substring(0,3);
            nyukinData.furikomiKozaNo = nyukinData.furikomiiraininNo.substring(3);
        }

        // テンプフラグの初期化
        tmp = true;

        // 振込依頼人名チェック
        // 必須チェック
        if(Strings.isNullOrEmpty(nyukinData.furikomiiraininName, true)){
            ret = false;
            tmp = false;
        }

        // エラーメッセージ設定
        if(!tmp){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ERROR_MESSAGE_HEADER + nyukinData.No + ERROR_MESSAGE_FURIKOMIIRAININ_NAME));
        }

        // 顧客オブジェクト検索
        if(ret){
            // 顧客情報が存在しない
            if(!accountAmountMap.containsKey(nyukinData.furikomiiraininNo)){
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ERROR_MESSAGE_HEADER + nyukinData.No + '　：　顧客情報が存在しません。'));
                ret = false;
            }else{
                // 顧客情報が複数存在する
                if(accountAmountMap.get(nyukinData.furikomiiraininNo) > 1){
                    Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ERROR_MESSAGE_HEADER + nyukinData.No + '　：　顧客情報が複数存在します。'));
                    ret = false;
                // 顧客情報を入金オブジェクト挿入用クラスに設定
                }else{
                    nyukinData.id = accountIdMap.get(nyukinData.furikomiiraininNo);
                }
            }
        }
        return ret;
    }

    /**
     * 取引日(表示用)作成
     *
     * @param torihikiDate 取引日
     * @return 取引日(表示用)
     */
    private String createTorihikiDateDisp(String torihikiDate){
        return Integer.valueOf(torihikiDate.substring(0,2)) + Integer.valueOf(System.Label.WarekiYear)
                                    + SLASH + torihikiDate.substring(2,4)
                                    + SLASH + torihikiDate.substring(4);
    }

    /**
     * 入金金額(表示用)作成
     *
     * @param nyukinkingaku 入金金額
     * @return 入金金額(表示用)
     */
    private String createNyukinkingakuDisp(String nyukinkingaku){

        return '\\' + Decimal.valueOf(nyukinkingaku).format();

    }

    /**
     * 入金オブジェクト挿入用クラス
     */
    public class NyukinDummy {

        /** 行数 */
        public Integer no {get; set;}

        /** Id */
        public Id id {get; set;}

        /** 取引日 */
        public String torihikiDate {get; set;}

        /** 取引日(表示用) */
        public String torihikiDateDisp {get; set;}

        /** 入金金額 */
        public String nyukinkingaku {get; set;}

        /** 入金金額(表示用) */
        public String nyukinkingakuDisp {get; set;}

        /** 振込依頼人番号 */
        public String furikomiiraininNo {get; set;}

        /** 振込先支店コード */
        public String furikomiShitenCd {get; set;}

        /** 振込先口座番号 */
        public String furikomiKozaNo {get; set;}

        /** 振込先支店名 */
        public String furikomiShitenName {get; set;}

        /** 振込依頼人名 */
        public String furikomiiraininName {get; set;}

        /** 取込 */
        public String torikomi {get; set;}

        /** 引当 */
        public String hikiate {get; set;}

        /** デフォルトコンストラクタ */
        public NyukinDummy() {
            this.torikomi = DISPLAY_OK;
            this.hikiate = '';
        }
    }

}