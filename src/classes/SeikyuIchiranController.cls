public with sharing class SeikyuIchiranController {

    /** 検索用基本クエリ */
    private static String BASIC_QUERY = 'SELECT Id, Name, Seikyusaki__c, ShimeGroup__c, Shimebi__c, Seikyusaki__r.Name, SeikyusakiTorihikiKbn__c, Seikyugaku__c, Tax__c, Seikyugaku_Tax__c, SeikyuTantosya__c, SeikyuDateTime__c, KaisyuScheduledDate__c, SeikyuStatus__c, NyukinStatus__c, Del_Flg__c, Del_Date__c, MeisaiLineAmount__c, SeikyusyoId__c, SoufujoPDF__c, PDFDowload__c,CompiledSeikyuHeaderFlg__c FROM SeikyuHeader__c';

    /** ソート順：昇順 */
    private static String SORT_DIRECTION_ASC = 'ASC';

    /** ソート順：降順 */
    private static String SORT_DIRECTION_DESC = 'DESC';

    /** ページ数上限 */
    private static integer MAX_PAGE = 10;

    /** １ページの表示請求ヘッダ数 */
    private static integer MAX_SHEAD_LINE = 100;

    /** １ページの表示数 */
    private static integer MAX_LINE = 15;

    /** 請求ヘッダ区切り文字 */
    private static String DELIMITER = ',';

    // 20170303 NSD遠藤保持用の変数追加
    /** 請求データの検索結果超えたかどうかのフラグ */
    private Boolean searchCountMAXFlg;

    /** 請求クライテリア */
    public SeikyuCriteria__c criteria {
        get;
        set;
    }

    /** 表示用請求ヘッダデータリスト */
    public List<SeikyuHeaderDummy> seikyuHeaderList {
        get;
        set;
    }

    /** ソート項順 */
    public String sortDirection {
        get;
        set;
    }

    /** ソート項目 */
    public String sortExpression {
        get;
        set;
    }

    /** 現在のソート項目 */
    private String sortExpressionNow;

    /** ソート項目 */
    public String checkedShId {
        get;
        private set;
    }

    /** 印刷フラグ */
    public boolean isPrint {
        get;
        set;
    }

    /** 送付状印刷フラグ */
    public boolean isSoufujoPrint {
        get;
        set;
    }
    
    /** 請求書取り纏めフラグ */
    public boolean isCompiled {
        get;
        set;
    }
    
    /** 検索条件(ページ遷移用) */
    public String searchCondition {
        get;
        set;
    }
    
    /** 検索条件(受信用) */
    public List<String> ConditionsReception {
        get;
        set;
    }

    /** 表示ページ */
    public Integer dispPage {
        get;
        set;
    }

    /** ラストページ */
    public Integer lastPage {
        get;
        set;
    }

    /** 印刷総ページ数 */
    public Integer totalPage {
        get;
        set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public SeikyuIchiranController() {

        // 請求クライテリア初期化
        this.criteria = new SeikyuCriteria__c();

        // ソート項目のデフォルト設定
        this.sortDirection = SORT_DIRECTION_ASC;
        this.sortExpression = 'KaisyuScheduledDate__c';
        this.sortExpressionNow = this.sortExpression;

        // 印刷フラグの初期化
        this.isPrint = false;

        // 送付状印刷フラグの初期化
        this.isSoufujoPrint = false;
        
        // 請求書取り纏めフラグの初期化
        this.isCompiled = false;
        
        // 検索条件(ページ遷移用)の初期化
        this.searchCondition = '';

        // 20170303 NSD遠藤保持用の変数追加
        this.searchCountMAXFlg = false;

        // 表示ページの初期化
        this.dispPage = 1;

        // 印刷総ページ数の初期化
        this.totalPage = 0;
        
        // 初期検索(請求書取り纏め画面より遷移した場合)
        if(ApexPages.currentPage().getParameters().get('shcon') != null && ApexPages.currentPage().getParameters().get('shcon') != ''){
            this.ConditionsReception = ApexPages.currentPage().getParameters().get('shcon').split(DELIMITER);
            
            if(this.ConditionsReception.size() != 0){
                //検索条件設定
                //顧客
                if(this.ConditionsReception[0] != 'null'){
                    criteria.Seikyusaki__c = this.ConditionsReception[0];
                }
                //取引区分
                if(this.ConditionsReception[1] != 'null'){
                    criteria.TorihikiKbn__c = this.ConditionsReception[1];
                }
                //回収予定日
                if(this.ConditionsReception[2] != 'null'){
                    List<String> str = this.ConditionsReception[2].split('-');
                    Date d = Date.newInstance(Integer.valueOf(this.ConditionsReception[2].substring(0,4)),Integer.valueOf(this.ConditionsReception[2].substring(5,7)),Integer.valueOf(this.ConditionsReception[2].substring(8,10)));
                    criteria.KaisyuScheduledDate__c = d;
                }
                //請求ステータス
                if(this.ConditionsReception[3] != 'null'){
                    criteria.SeikyuStatus__c = this.ConditionsReception[3];
                }
                //入金ステータス
                if(this.ConditionsReception[4] != 'null'){
                    criteria.NyukinStatus__c = this.ConditionsReception[4];
                }
                //締めグループ
                if(this.ConditionsReception[5] != 'null'){
                    criteria.ShimeGroup__c = this.ConditionsReception[5];
                }
                //年
                if(this.ConditionsReception[6] != 'null'){
                    criteria.SeikyuYear__c = this.ConditionsReception[6];
                }
                //月
                if(this.ConditionsReception[7] != 'null'){
                    criteria.SeikyuMonth__c = this.ConditionsReception[7];
                }
                //日
                if(this.ConditionsReception[8] != 'null'){
                    criteria.SeikyuDay__c = this.ConditionsReception[8];
                }
                //削除フラグ
                if(this.ConditionsReception[9] != 'null'){
                    Boolean bool;
                    if(this.ConditionsReception[9] == 'true'){
                        bool = true;
                    }else{
                        bool = false;
                    }
                    criteria.Del_Flg__c = bool;
                }
                
                // 検索
                this.seikyuHeaderList = this.getSeikyuHeaderList(this.criteria, this.sortExpression, this.sortDirection);
                
                // 2017/03/03 NSD遠藤追加　start
                // 上限件数を超えた場合、Wornningを出し、検索結果を出す
                if (this.searchCountMAXFlg) {
                    Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索処理の上限件数を超えています。内' + MAX_PAGE * MAX_SHEAD_LINE +'件を表示します。'));
                }
                // 2017/03/03 NSD遠藤追加 end
                // @todo 後で削除
                //if(this.seikyuHeaderList == null){
                    //Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '検索処理の上限件数を超えています。上限件数は' + MAX_PAGE * MAX_SHEAD_LINE + '件です。検索条件を指定して再検索してください。'));
                //}
            }
        }
        
        // 検索条件(ページ遷移用)の設定
        this.searchCondition = criteria.Seikyusaki__c //顧客
                               + ',' + criteria.TorihikiKbn__c //取引区分
                               + ',' + criteria.KaisyuScheduledDate__c //回収予定日
                               + ',' + criteria.SeikyuStatus__c //請求ステータス
                               + ',' + criteria.NyukinStatus__c //入金ステータス
                               + ',' + criteria.ShimeGroup__c //締めグループ
                               + ',' + criteria.SeikyuYear__c //年
                               + ',' + criteria.SeikyuMonth__c //月
                               + ',' + criteria.SeikyuDay__c //日
                               + ',' + criteria.Del_Flg__c; //削除フラグ
        
    }

    /**
     * 検索
     */
    public PageReference seikyuSearch() {

        // 入力チェック
        if (!this.validation(this.criteria)) {
            return null;
        }

        // 表示ページの初期化
        this.dispPage = 1;

        // 印刷総ページ数の初期化
        this.totalPage = 0;
        
        // 検索条件(ページ遷移用)の設定
        this.searchCondition = criteria.Seikyusaki__c //顧客
                               + ',' + criteria.TorihikiKbn__c //取引区分
                               + ',' + criteria.KaisyuScheduledDate__c //回収予定日
                               + ',' + criteria.SeikyuStatus__c //請求ステータス
                               + ',' + criteria.NyukinStatus__c //入金ステータス
                               + ',' + criteria.ShimeGroup__c //締めグループ
                               + ',' + criteria.SeikyuYear__c //年
                               + ',' + criteria.SeikyuMonth__c //月
                               + ',' + criteria.SeikyuDay__c //日
                               + ',' + criteria.Del_Flg__c; //削除フラグ

        // 検索
        this.seikyuHeaderList = this.getSeikyuHeaderList(this.criteria, this.sortExpression, this.sortDirection);
        // 2017/03/03 NSD遠藤追加　start
        // 上限件数を超えた場合、Wornningを出し、検索結果を出す
        if (this.searchCountMAXFlg) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索処理の上限件数を超えています。内' + MAX_PAGE * MAX_SHEAD_LINE +'件を表示します。'));
        }
        // 2017/03/03 NSD遠藤追加 end

        return null;
    }

    /**
     * ソート
     */
    public PageReference sortData() {

        // 指定されたソート項目をチェック
        if (this.sortExpression == this.sortExpressionNow) {
            // 現在のソート項目と一致すれば、ソート順を入れ替える
            this.sortDirection = (this.sortDirection == SORT_DIRECTION_ASC) ? SORT_DIRECTION_DESC : SORT_DIRECTION_ASC;

        } else {
            // 一致しなければ、指定されたソート項目を昇順で設定
            this.sortDirection = SORT_DIRECTION_ASC;
            this.sortExpressionNow = this.sortExpression;
        }

        // 表示ページの初期化
        this.dispPage = 1;

        // 印刷総ページ数の初期化
        this.totalPage = 0;

        // 再検索
        this.seikyuHeaderList = this.getSeikyuHeaderList(this.criteria, this.sortExpression, this.sortDirection);
        // 2017/03/03 NSD遠藤追加　start
        // 上限件数を超えた場合、Wornningを出し、検索結果を出す
        if (this.searchCountMAXFlg) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索処理の上限件数を超えています。内' + MAX_PAGE * MAX_SHEAD_LINE +'件を表示します。'));
        }
        // 2017/03/03 NSD遠藤追加 end

        return null;
    }

    /**
     * 入力チェック
     *
     * @param criteria 請求クライテリア
     * @return true:OK, false:NG
     */
    private Boolean validation(SeikyuCriteria__c criteria) {

        Boolean ret = true;

        if (!Strings.isNullOrEmpty(criteria.SeikyuYear__c)) {
            // 請求年月を生成
            String seikyuYear = criteria.SeikyuYear__c;
            String seikyuMonth = criteria.SeikyuMonth__c;
            String seikyuDay = '01';
            if (criteria.ShimeGroup__c == null || criteria.ShimeGroup__c == '都度' || criteria.ShimeGroup__c == 'クレジットカード') {
                seikyuDay = criteria.SeikyuDay__c;
            }

            // 請求年月チェック
            String seikyuDate = seikyuYear + '/' + seikyuMonth + '/' + seikyuDay;
            if (!Strings.isDate(seikyuDate)) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求年月の日付が正しくありません。'));
            }
        }

        return ret;
    }

    /**
     * 請求ヘッダ検索処理
     *
     * @param criteria 請求クライテリア
     * @param sortExpression ソート項目
     * @param sortDeirection ソート順
     * @return 請求ヘッダのリスト
     */
    private List<SeikyuHeaderDummy> getSeikyuHeaderList (SeikyuCriteria__c criteria, String sortExpression, String sortDeirection) {

        // 検索用クエリ生成
        String query = BASIC_QUERY;
        query += this.getConditionQuery(criteria);
        query += this.getOrderQuery(sortExpression, sortDeirection);
        query += ' LIMIT ' + String.valueOf(MAX_PAGE * MAX_SHEAD_LINE + 1);

        // 検索
        List<SeikyuHeader__c> searchResult = database.query(query);

        if(searchResult.size() > MAX_PAGE * MAX_SHEAD_LINE){
            //@todo 後で削除
            //return null;
        // 2017/03/03 NSD遠藤追加　start
            // 検索結果が上限を超えていた場合フラグを更新
            this.searchCountMAXFlg = true;
        } else {
            this.searchCountMAXFlg = false;
        }
        // 2017/03/03 NSD遠藤追加　end

        // 表示用データ作成
        List<SeikyuHeaderDummy> seikyuHeaderList = new List<SeikyuHeaderDummy>();
        Integer startIndex = (this.dispPage - 1) * MAX_SHEAD_LINE;
        Integer endIndex = Math.min(this.dispPage * MAX_SHEAD_LINE - 1, searchResult.size() - 1);
        for(Integer i = startIndex; i <= endIndex; i++ ){
            SeikyuHeader__c item = searchResult[i];
            SeikyuHeaderDummy seikyuHeader = new SeikyuHeaderDummy();
            seikyuHeader.seikyuHeader = item;
            if(item.MeisaiLineAmount__c != 0){
                seikyuHeader.pageAmount = Math.ceil(item.MeisaiLineAmount__c / MAX_LINE).intValue();
            }
            seikyuHeaderList.add(seikyuHeader);
        }

        // 最終ページ数を設定
        this.lastPage = (searchResult.size() - 1) / MAX_SHEAD_LINE + 1;

        return seikyuHeaderList;
    }

    /**
     * 検索条件生成
     *
     * @param criteria 請求クライテリア
     * @return 検索条件
     */
    private String getConditionQuery(SeikyuCriteria__c criteria) {

        Boolean isFirst = true;
        String ret = '';

        // 検索条件：顧客（請求先）
        if (!Strings.isNullOrEmpty(criteria.Seikyusaki__c)) {
            ret += ' WHERE ';
            ret += 'Seikyusaki__c = \'' + criteria.Seikyusaki__c + '\'';
            isFirst = false;
        }

        // 検索条件：取引区分
        if (!Strings.isNullOrEmpty(criteria.TorihikiKbn__c)) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'SeikyusakiTorihikiKbn__c = \'' + criteria.TorihikiKbn__c + '\'';
        }

        // 検索条件：回収予定日
        if (criteria.KaisyuScheduledDate__c != null) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'KaisyuScheduledDate__c <= ' + String.valueOf(criteria.KaisyuScheduledDate__c).replace('/','-');
        }

        // 検索条件：請求ステータス
        if (!Strings.isNullOrEmpty(criteria.SeikyuStatus__c)) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'SeikyuStatus__c = \'' + criteria.SeikyuStatus__c + '\'';
        }

        // 検索条件：入金ステータス
        if (!Strings.isNullOrEmpty(criteria.NyukinStatus__c)) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'NyukinStatus__c = \'' + criteria.NyukinStatus__c + '\'';
        }

        // 検索条件：締めグループ
        if (!Strings.isNullOrEmpty(criteria.ShimeGroup__c)) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'ShimeGroup__c = \'' + criteria.ShimeGroup__c + '\'';
        }

        // 検索条件：請求年月
        if (!Strings.isNullOrEmpty(criteria.SeikyuYear__c)) {
            Integer seikyuYear = Integer.valueOf(criteria.SeikyuYear__c);
            Integer seikyuMonth = Integer.valueOf(criteria.SeikyuMonth__c);
            Integer seikyuDay = 1;
            if (criteria.ShimeGroup__c == '15日') {
                seikyuDay = 15;
            }
            else if (criteria.ShimeGroup__c == '20日') {
                seikyuDay = 20;
            }
            else if (criteria.ShimeGroup__c == '25日') {
                seikyuDay = 25;
            }
            else  if (criteria.ShimeGroup__c == '末日' || criteria.ShimeGroup__c == '楽天') {
                seikyuDay = Date.daysInMonth(seikyuYear, seikyuMonth);
            }
            else  if (criteria.ShimeGroup__c == null || criteria.ShimeGroup__c == '都度' || criteria.ShimeGroup__c == 'クレジットカード') {
                seikyuDay = Integer.valueOf(criteria.SeikyuDay__c);
            }
            Date seikyuDate = Date.newInstance(seikyuYear, seikyuMonth, seikyuDay);
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'Shimebi__c = ' + String.valueOf(seikyuDate).replace('/','-') + ' AND Shimebi__c != null';
        }

        // 検索条件：削除フラグ
        if (!criteria.Del_Flg__c) {
            if (isFirst) {
                ret += ' WHERE ';
                isFirst = false;
            } else {
                ret += ' AND ';
            }
            ret += 'Del_Flg__c = FALSE' ;
        }

        return ret;
    }

    /**
     * ソート指定生成
     *
     * @param sortExpression ソート項目
     * @param sortDeirection ソート順
     * @return ソート指定
     */
    private String getOrderQuery(String sortExpression, String sortDeirection) {

        return ' ORDER BY ' + sortExpression + ' ' + sortDeirection;
    }

    /**
     * 請求書送付
     */
    public PageReference sendPdf() {

        // 顧客（請求先）IDをキーとした請求担当者のマップを取得
        Map<String, Contact> tantosyaMap = this.getTantosyaMap(this.seikyuHeaderList);

        // 請求書送付メールテンプレート取得
        EmailTemplate mailTemplate = this.getMailTemplate();

        // 組織のメールアドレス取得
        OrgWideEmailAddress orgAddress = this.getOrgAddress();

        // 入力チェック
        if (!this.sendValidation(this.seikyuHeaderList, this.criteria, tantosyaMap)) {
            return null;
        }

        // メール生成
        List<Messaging.SingleEmailMessage> sendMailList = new List<Messaging.SingleEmailMessage> ();
        for (SeikyuHeaderDummy item : this.seikyuHeaderList) {
            // チェックされているもののみ作成
            if (item.checked) {
                // PDF取得
                Attachment att = this.getAttachmentPdf(item.seikyuHeader.SeikyusyoId__c);
                // メール生成
                Contact seikyuTantosya = tantosyaMap.get(item.seikyuHeader.Seikyusaki__c);
                sendMailList.add(this.getEmail(item.seikyuHeader.Id, att, seikyuTantosya.Id, mailTemplate, orgAddress));
            }
        }
        Messaging.sendEmail(sendMailList);

        // 請求ヘッダ更新（請求ステータス、請求日時）
        List<SeikyuHeader__c> updShList = new List<SeikyuHeader__c> ();
        for (SeikyuHeaderDummy item : this.seikyuHeaderList) {
            // チェックされているもののみ更新
            if (item.checked) {
                // 請求ステータス、請求日時設定
                item.seikyuHeader.SeikyuStatus__c = '請求済み';
                item.seikyuHeader.SeikyuDateTime__c = Datetime.now();
                updShList.add(item.seikyuHeader);
            }
        }
        update updShList;

        // 表示ページの初期化
        this.dispPage = 1;

        // 印刷総ページ数の初期化
        this.totalPage = 0;

        // 再検索
        this.seikyuHeaderList = this.getSeikyuHeaderList(this.criteria, this.sortExpression, this.sortDirection);

        // 2017/03/03 NSD遠藤追加　start
        // 上限件数を超えた場合、Wornningを出し、検索結果を出す
        if (this.searchCountMAXFlg) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索処理の上限件数を超えています。内' + MAX_PAGE * MAX_SHEAD_LINE +'件を表示します。'));
        }
        // 2017/03/03 NSD遠藤追加 end

        // 完了メッセージを表示
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求書を送付しました。'));

        return null;
    }

    /**
     * 入力チェック（請求書送付時）
     *
     * @param shList 表示用請求ヘッダデータリスト
     * @param criteria 請求クライテリア
     * @param tantosyaMap 顧客（請求先）IDをキーとした請求担当者のマップ
     * @return true:OK, false:NG
     */
    private Boolean sendValidation(List<SeikyuHeaderDummy> shList, SeikyuCriteria__c criteria, Map<String, Contact> tantosyaMap) {

        Boolean ret = true;

        // 最低１件でもチェックされているか
        Integer checkNum = 0;
        List<String> shidList = new List<String> ();
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                checkNum ++;
                shidList.add(item.seikyuHeader.Id);
            }
        }
        if (checkNum == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書送付対象が選択されていません。'));
        }

        // 選択レコード件数が上限以上
        if (checkNum > Integer.valueOf(System.Label.ExecuteLimitCount_Seikyusyo)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書送付処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Seikyusyo + '件です。'));
        }

        // 宛先、PDFチェック
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                // 請求担当者が設定されているか
                if (!tantosyaMap.containsKey(item.seikyuHeader.Seikyusaki__c)) {
                    ret = false;
                    Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求先：' + item.seikyuHeader.Seikyusaki__r.Name + '　　' + '請求担当者が設定されていません。'));

                } else {
                    // 請求担当者のメールアドレスが設定されているか
                    Contact con = tantosyaMap.get(item.seikyuHeader.Seikyusaki__c);
                    if (Strings.isNullOrEmpty(con.Email)) {
                        ret = false;
                        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求先：' + item.seikyuHeader.Seikyusaki__r.Name + '　　' + '請求担当者のメールアドレスが設定されていません。'));
                    }
                }
                // PDFが添付されているか
                if(Strings.isNullOrEmpty(item.seikyuHeader.SeikyusyoId__c)){
                    ret = false;
                    Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.seikyuHeader.Name + '　　' + 'PDFが添付されていません。'));
                }
            }
        }

        // 取消し済みのチェック
        List<SeikyuHeader__c> checkShList = [SELECT Id, Name, NyukinStatus__c, Del_Flg__c FROM SeikyuHeader__c WHERE Id = :shidList];
        for (SeikyuHeader__c item : checkShList) {
            // 既に取消し済みでないかどうか
            if (item.Del_Flg__c) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + '請求取消し済みです。'));
            }
        }

        return ret;
    }

    /**
     * 顧客（請求先）IDをキーとした請求担当者のマップを取得する。
     *
     *　@param 表示用請求ヘッダデータリスト
     *　@return 請求担当者マップ
     */
    private Map<String, Contact> getTantosyaMap(List<SeikyuHeaderDummy> shList) {

        // 顧客（請求先）IDリストを作成
        Map<String, String> kokyakuIdMap = new Map<String, String> ();
        for (SeikyuHeaderDummy item : shList) {
            // チェックされているもののみ更新
            if (item.checked) {
                // 重複排除
                if (!kokyakuIdMap.containsKey(item.seikyuHeader.Seikyusaki__c)) {
                    kokyakuIdMap.put(item.seikyuHeader.Seikyusaki__c, item.seikyuHeader.Seikyusaki__c);
                }
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
     * 請求書送付メールテンプレートを取得する
     *
     * @return 請求書送付メールテンプレート
     */
    private EmailTemplate getMailTemplate() {

        List<EmailTemplate> templateList = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :System.Label.SeikyusyoMailTemplate AND IsActive = :true];
        return templateList[0];
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
     * @param shid 請求ヘッダId
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
     * 請求ステータス変更
     */
    public PageReference seikyuStatusUpdate() {

        // 入力チェック
        if (!this.updateValidation(this.seikyuHeaderList)) {
            return null;
        }

        // 請求ヘッダ更新（請求ステータス、請求日時）
        List<SeikyuHeader__c> updShList = new List<SeikyuHeader__c> ();
        for (SeikyuHeaderDummy item : this.seikyuHeaderList) {
            // チェックされているもののみ更新
            if (item.checked && item.seikyuHeader.SeikyuStatus__c == '未請求') {
                // 請求ステータス、請求日時設定
                item.seikyuHeader.SeikyuStatus__c = '請求済み';
                item.seikyuHeader.SeikyuDateTime__c = Datetime.now();
                updShList.add(item.seikyuHeader);
            }
        }
        update updShList;

        // 表示ページの初期化
        this.dispPage = 1;

        // 印刷総ページ数の初期化
        this.totalPage = 0;

        // 再検索
        this.seikyuHeaderList = this.getSeikyuHeaderList(this.criteria, this.sortExpression, this.sortDirection);

        // 2017/03/03 NSD遠藤追加　start
        // 上限件数を超えた場合、Wornningを出し、検索結果を出す
        if (this.searchCountMAXFlg) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索処理の上限件数を超えています。内' + MAX_PAGE * MAX_SHEAD_LINE +'件を表示します。'));
        }
        // 2017/03/03 NSD遠藤追加 end

        // 完了メッセージを表示
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求ステータスを変更しました。'));

        return null;
    }

    /**
     * 入力チェック（請求ステータス変更時）
     *
     * @param shList 表示用請求ヘッダデータリスト
     * @return true:OK, false:NG
     */
    private Boolean updateValidation(List<SeikyuHeaderDummy> shList) {

        Boolean ret = true;

        // 最低１件でもチェックされているか
        Integer checkNum = 0;
        List<String> shidList = new List<String> ();
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                checkNum ++;
                shidList.add(item.seikyuHeader.Id);
            }
        }
        if (checkNum == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求ステータス変更対象が選択されていません。'));
        }

        // 取消し済みのチェック
        List<SeikyuHeader__c> checkShList = [SELECT Id, Name, NyukinStatus__c, Del_Flg__c FROM SeikyuHeader__c WHERE Id = :shidList];
        for (SeikyuHeader__c item : checkShList) {
            // 既に取消し済みでないかどうか
            if (item.Del_Flg__c) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + '請求取消し済みです。'));
            }
        }

        return ret;
    }

    /**
     * 請求取消
     */
    public PageReference deleteSeikyu() {

        // 入力チェック
        if (!this.deleteValidation(this.seikyuHeaderList)) {
            return null;
        }

        // 請求ヘッダ更新（削除フラグ、削除日時）
        List<SeikyuHeader__c> updShList = new List<SeikyuHeader__c> ();
        List<String> shidList = new List<String> ();
        
        // 取り纏め請求ヘッダIdのリスト
        List<String> compiledSeikyuHeaderIdList = new List<String> ();
        
        for (SeikyuHeaderDummy item : this.seikyuHeaderList) {
            // チェックされているもののみ更新
            if (item.checked) {
                item.seikyuHeader.Del_Flg__c = true;
                item.seikyuHeader.Del_Date__c = Datetime.now();
                updShList.add(item.seikyuHeader);
                
                // 取り纏め請求ヘッダかを判定
                if(item.seikyuHeader.CompiledSeikyuHeaderFlg__c == true){
                    compiledSeikyuHeaderIdList.add(item.seikyuHeader.Id);
                }else{
                    shidList.add(item.seikyuHeader.Id);
                }
            }
        }
        update updShList;
        
        // 取り纏め後の請求ヘッダの取り消す
        if(compiledSeikyuHeaderIdList.size() > 0){
            
            List<Seikyu__c> compiledSeikyuList = [SELECT Id, Name, DenpyoNo__c, OffsetNyukin__c, SeikyusyoNo__c FROM Seikyu__c WHERE SeikyusyoNo__c = :compiledSeikyuHeaderIdList];
            // 請求に紐づく案件ID
            List<String> ankenIdList = new List<String> ();
            for(Seikyu__c seikyu : compiledSeikyuList){
                if(seikyu.DenpyoNo__c != null){
                    ankenIdList.add(seikyu.DenpyoNo__c);
                }
            }
            
            // 取り纏め後案件データを取得
            List<Anken__c> compiledAnkenList = [SELECT Id, OriginalAnkenId__c,Status__c FROM Anken__c WHERE Id = :ankenIdList];
            
            // 取り纏め後の案件のステータスを「キャンセル」に変更
            List<String> originalAnkenIdList = new List<String> ();
            for(Anken__c anken : compiledAnkenList){
                originalAnkenIdList.add(anken.OriginalAnkenId__c);
                anken.StatusLock__c = false;
                anken.Status__c = 'キャンセル';
            }
            update compiledAnkenList;
            
            // 取り纏め元の案件のステータスを「受注納品済み」に変更
            List<Anken__c> originalAnkenList = [SELECT Id, Status__c FROM Anken__c WHERE Id = :originalAnkenIdList];
            for(Anken__c anken : originalAnkenList){
                anken.StatusLock__c = false;
                anken.Status__c = '受注納品済み';
            }
            update originalAnkenList;
        }
        
        // 非取り纏め請求ヘッダの取り消す
        if(shidList.size() > 0){
            // 更新対象案件ID,更新対象入金IDを取得
            List<Seikyu__c> sList = [SELECT Id, Name, DenpyoNo__c, OffsetNyukin__c, SeikyusyoNo__c FROM Seikyu__c WHERE SeikyusyoNo__c = :shidList];
            List<String> aidList = new List<String> ();
            List<String> nidList = new List<String> ();
            for (Seikyu__c item : sList) {
                // 更新対象案件ID
                if(item.DenpyoNo__c != null){
                    aidList.add(item.DenpyoNo__c);
                }
                // 更新対象入金ID
                if(item.OffsetNyukin__c != null){
                    nidList.add(item.OffsetNyukin__c);
                }
            }
    
            // 案件更新（ステータス）
            List<Anken__c> aList = [SELECT Id, Name, Status__c, StatusLock__c FROM Anken__c WHERE Id = :aidList];
            for (Anken__c item : aList) {
                item.Status__c = '受注納品済み';
                item.StatusLock__c = false;
            }
            update aList;
    
            // 入金更新（ステータス）
            List<Nyukin__c> nList = [SELECT Id, Name, Status__c FROM Nyukin__c WHERE Id = :nidList];
            for (Nyukin__c item : nList) {
                item.Status__c = '新規';
                item.Keshikomibi__c = null;
            }
            update nList;
        }
        
        
        // 表示ページの初期化
        this.dispPage = 1;

        // 印刷総ページ数の初期化
        this.totalPage = 0;

        // 再検索
        this.seikyuHeaderList = this.getSeikyuHeaderList(this.criteria, this.sortExpression, this.sortDirection);
        // 2017/03/03 NSD遠藤追加　start
        // 上限件数を超えた場合、Wornningを出し、検索結果を出す
        if (this.searchCountMAXFlg) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索処理の上限件数を超えています。内' + MAX_PAGE * MAX_SHEAD_LINE +'件を表示します。'));
        }
        // 2017/03/03 NSD遠藤追加 end

        // 完了メッセージを表示
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '請求を取消しました。'));

        return null;
    }

    /**
     * 入力チェック（請求取消時）
     *
     * @param shList 表示用請求ヘッダデータリスト
     * @return true:OK, false:NG
     */
    private Boolean deleteValidation(List<SeikyuHeaderDummy> shList) {

        Boolean ret = true;

        // 最低１件でもチェックされているか
        Integer checkNum = 0;
        List<String> shidList = new List<String> ();
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                checkNum ++;
                shidList.add(item.seikyuHeader.Id);
            }
        }
        if (checkNum == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求取消対象が選択されていません。'));
        }

        // 選択レコード件数が上限以上
        if (checkNum > Integer.valueOf(System.Label.ExecuteLimitCount_Seikyusyo)) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求取消処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_Seikyusyo + '件です。'));
        }

        // 入金ステータス、取消し済みのチェック
        List<SeikyuHeader__c> checkShList = [SELECT Id, Name, NyukinStatus__c, Del_Flg__c FROM SeikyuHeader__c WHERE Id = :shidList];
        for (SeikyuHeader__c item : checkShList) {
            // 既に入金済みでないかどうか
            if (item.NyukinStatus__c == '入金済み') {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + '入金ステータスが入金済みの場合、請求取消しできません。'));
            }
            // 既に取消し済みでないかどうか
            if (item.Del_Flg__c) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + '請求取消し済みです。'));
            }
        }

        return ret;
    }

    /**
     * 送付状印刷
     */
    public PageReference printSoufujoPdf() {

        // 顧客（請求先）IDをキーとした請求担当者のマップを取得
        Map<String, Contact> tantosyaMap = this.getTantosyaMap(this.seikyuHeaderList);

        // 入力チェック
        if (!this.printSoufujoValidation(this.seikyuHeaderList, tantosyaMap)) {
            return null;
        }

        // 送付状印刷フラグの設定
        this.isSoufujoPrint = true;

        return null;
    }

    /**
     * 入力チェック（送付状印刷時）
     *
     * @param shList 表示用請求ヘッダデータリスト
     * @return true:OK, false:NG
     */
    private Boolean printSoufujoValidation(List<SeikyuHeaderDummy> shList, Map<String, Contact> tantosyaMap) {

        Boolean ret = true;

        // 請求IDの初期化
        this.checkedShId = '';

        // 最低１件でもチェックされているか
        Integer checkNum = 0;
        List<String> shidList = new List<String> ();
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                checkNum ++;
                shidList.add(item.seikyuHeader.Id);
                this.checkedShId += DELIMITER + item.seikyuHeader.Id;
            }
        }

        if(this.checkedShId.length () != 0){
                this.checkedShId = this.checkedShId.substring(1);
        }
        if (checkNum == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '送付状印刷対象が選択されていません。'));
        }

        // 請求担当者チェック
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                // 請求担当者が設定されているか
                if (!tantosyaMap.containsKey(item.seikyuHeader.Seikyusaki__c)) {
                    ret = false;
                    Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求先：' + item.seikyuHeader.Seikyusaki__r.Name + '　　' + '請求担当者が設定されていません。'));

                }
            }
        }

        // 取消し済みのチェック
        List<SeikyuHeader__c> checkShList = [SELECT Id, Name, NyukinStatus__c, Del_Flg__c FROM SeikyuHeader__c WHERE Id = :shidList];
        for (SeikyuHeader__c item : checkShList) {
            // 既に取消し済みでないかどうか
            if (item.Del_Flg__c) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + '請求取消し済みです。'));
            }
        }

        return ret;
    }

    /**
     * 請求書印刷
     */
    public PageReference printPdf() {

        // 入力チェック
        if (!this.printValidation(this.seikyuHeaderList)) {
            return null;
        }

        // 印刷フラグの設定
        this.isPrint = true;

        return null;
    }

    /**
     * 入力チェック（請求書印刷時）
     *
     * @param shList 表示用請求ヘッダデータリスト
     * @return true:OK, false:NG
     */
    private Boolean printValidation(List<SeikyuHeaderDummy> shList) {

        Boolean ret = true;

        // 請求IDの初期化
        this.checkedShId = '';

        // 最低１件でもチェックされているか
        Integer checkNum = 0;
        List<String> shidList = new List<String> ();
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                checkNum ++;
                shidList.add(item.seikyuHeader.Id);
                this.checkedShId += DELIMITER + item.seikyuHeader.Id;
            }
        }

        if(this.checkedShId.length () != 0){
                this.checkedShId = this.checkedShId.substring(1);
        }
        if (checkNum == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書印刷対象が選択されていません。'));
        }

        // 取消し済みのチェック
        List<SeikyuHeader__c> checkShList = [SELECT Id, Name, NyukinStatus__c, Del_Flg__c FROM SeikyuHeader__c WHERE Id = :shidList];
        for (SeikyuHeader__c item : checkShList) {
            // 既に取消し済みでないかどうか
            if (item.Del_Flg__c) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + '請求取消し済みです。'));
            }
        }

        return ret;
    }
    
    /**
     * 請求書取り纏め
     */
    public PageReference compiledSeikyu() {

        // 入力チェック
        if (!this.compiledSeikyuValidation(this.seikyuHeaderList)) {
            return null;
        }

        // 取り纏めフラグの設定
        this.isCompiled = true;

        return null;
    }
    
    /**
     * 入力チェック（請求書印刷時）
     *
     * @param shList 表示用請求ヘッダデータリスト
     * @return true:OK, false:NG
     */
    private Boolean compiledSeikyuValidation(List<SeikyuHeaderDummy> shList) {

        Boolean ret = true;

        // 請求IDの初期化
        this.checkedShId = '';

        // 最低１件でもチェックされているか
        Integer checkNum = 0;
        List<String> shidList = new List<String> ();
        for(SeikyuHeaderDummy item : shList) {
            if (item.checked) {
                checkNum ++;
                shidList.add(item.seikyuHeader.Id);
                this.checkedShId += DELIMITER + item.seikyuHeader.Id;
            }
        }

        if(this.checkedShId.length () != 0){
                this.checkedShId = this.checkedShId.substring(1);
        }
        if (checkNum == 0) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書取り纏め対象が選択されていません。'));
        }

        // 取消し済みのチェック・締日チェック
        List<SeikyuHeader__c> checkShList = [SELECT Id, Name, NyukinStatus__c, Del_Flg__c, Shimebi__c, ShimeGroup__c FROM SeikyuHeader__c WHERE Id = :shidList];
        Date simeDate = checkShList[0].Shimebi__c;
        for (SeikyuHeader__c item : checkShList) {
            // 既に取消し済みでないかどうか
            if (item.Del_Flg__c) {
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求書番号：' + item.Name + '　　' + '請求取消し済みです。'));
            }
            
            //締めグループが同じかどうか
            if(checkShList[0].ShimeGroup__c != item.ShimeGroup__c){
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '締めグループが同じ請求を選択してください。'));
            }
            
            //締日が同じかどうか
            if(simeDate != item.Shimebi__c){
                ret = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '締め日が同じ請求を選択してください。'));
            }
        }

        return ret;
    }

    /**
     * ページング
     */
    public PageReference paging() {

        // 印刷総ページ数の初期化
        this.totalPage = 0;

        // 検索
        this.seikyuHeaderList = this.getSeikyuHeaderList(this.criteria, this.sortExpression, this.sortDirection);
        // 2017/03/03 NSD遠藤追加　start
        // 上限件数を超えた場合、Wornningを出し、検索結果を出す
        if (this.searchCountMAXFlg) {
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '検索処理の上限件数を超えています。内' + MAX_PAGE * MAX_SHEAD_LINE +'件を表示します。'));
        }
        // 2017/03/03 NSD遠藤追加 end

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

        /** 選択用チェックボックス */
        public boolean checked {get; set;}

        /** デフォルトコンストラクタ */
        public SeikyuHeaderDummy() {
            this.pageAmount = 1;
            this.checked = false;
        }
    }
}