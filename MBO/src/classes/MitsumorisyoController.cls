public with sharing class MitsumorisyoController {

    /** 案件ID */
    private String ankenId;

    /** 呼出元がSitesかどうか */
    private Boolean isSites;

    /** １ページの表示数 */
    private static integer MAX_LINE = 24;

    /** 備考のの表示行数 */
    private static integer REMARK_LINE = 5;

    /** 有効期限日数 */
    private static integer LIMIT_DATE = 30;

    /** 見積書データ */
    public List<PageData> pageDataList {
        get;
        private set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public MitsumorisyoController() {
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.isSites = ApexPages.currentPage().getParameters().containsKey('sites');
    }

    /**
     * 初期化処理
     */
    public PageReference init() {

        // 案件データ取得
        Anken__c anken = this.getAnkenData(this.ankenId);

        // 案件明細データ取得
        List<AnkenMeisai__c> ankenMeisaiList = this.getAnkenMeisai(this.ankenId);

        // 見積書データ生成
        PageData pageItem = null;
        Integer pageNo = 0;
        this.pageDataList = new List<PageData> ();

        // 案件明細データの存在チェック
        if (ankenMeisaiList.size() == 0) {
            // 案件明細がない場合は、0円の見積書を作成する
            pageItem = new PageData(anken, this.isSites);
            pageItem.pageNo = 1;
            pageItem.isFirst = true;
            pageItem.isLast = true;
            this.pageDataList.add(pageItem);

        } else {

            Integer maxTmpLine = 0;
            // 1ページに収まらない場合
            if (ankenMeisaiList.size() > MAX_LINE) {
                maxTmpLine = MAX_LINE;
                Integer tmpPageNum = ankenMeisaiList.size()/MAX_LINE;
                Integer lastPageLineNum = ankenMeisaiList.size() - tmpPageNum*MAX_LINE;
                // 終わりのページが21行～24行だと1ページに収まらない為、空行を追加し調整する。
                if (lastPageLineNum > (MAX_LINE -REMARK_LINE) || lastPageLineNum == 0) {
                    for (Integer i = 0; i < REMARK_LINE; i ++) {
                        ankenMeisaiList.add(new AnkenMeisai__c());
                    } 
                }
                
            // 1ページに収まらないが案件リストは1ページに収まる場合
            }else if(ankenMeisaiList.size() > MAX_LINE -REMARK_LINE){
                maxTmpLine = MAX_LINE; 
                for (Integer i = 0; i < REMARK_LINE; i ++) {
                    ankenMeisaiList.add(new AnkenMeisai__c());
                }
            // 1ページに収まる場合
            }else{
                maxTmpLine = MAX_LINE -REMARK_LINE; 
            }

            // 案件明細がある場合
            for (Integer i = 0; i < ankenMeisaiList.size(); i ++) {
                // １ページに対する明細行Index
                Integer row = Math.mod(i, maxTmpLine);

                // １ページに対する基本情報を生成
                if (row == 0) {
                    // ページデータを追加
                    pageItem = new PageData(anken, this.isSites);
                    pageItem.pageNo = (++ pageNo);
                    this.pageDataList.add(pageItem);

                    // １ページ目かどうか
                    if (i == 0) {
                        pageItem.isFirst = true;
                    }

                    // 最終ページかどうか
                    if (ankenMeisaiList.size() <= pageItem.pageNo * maxTmpLine) {
                        pageItem.isLast = true;
                    }
                }

                // 案件明細データを設定
                pageItem.ankenMeisaiList.add(ankenMeisaiList[i]);
            }
        }
        // MAX_LINEに満たない行に空白行を設定
        for (Integer i = pageItem.ankenMeisaiList.size(); i < MAX_LINE -REMARK_LINE; i ++) {
             pageItem.ankenMeisaiList.add(new AnkenMeisai__c());
         }

        return null;
    }

    /**
     * 案件データを取得する。
     *
     * @param aid 案件ID
     * @return 案件データ
     */
    private Anken__c getAnkenData(String aid) {

        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        KokyakuName__c,
                                        KokyakuName__r.Name,
                                        KokyakuName__r.KokyakuCd__c,
                                        KokyakuName__r.Phone,
                                        KokyakuName__r.Fax,
                                        AnkenName__c,
                                        KokyakuTantosya_Main__r.Name,
                                        KokyakuName__r.TorihikiKbn__c,
                                        MitsumoriTantosya__r.Name,
                                        MitsumoriTantosya__r.TantosyaImageId__c,
                                        /** start add 2016/02/29 **/
                                        MitsumoriTantosya__r.Alias,
                                        /** end add 2016/02/29 **/
                                        MitsumoriTotalKingaku_Tax__c,
                                        MitsumoriTotalKingaku__c,
                                        MitsumoriTotalTax__c,
                                        MitsumoriDateTime__c,
                                        ClientOrderNumber__c,
                                        Remarks__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];
        return ankenList[0];
    }

    /**
     * 案件明細データを取得する。
     *
     * @param aid 案件ID
     */
    private List<AnkenMeisai__c> getAnkenMeisai (String aid) {

        List<AnkenMeisai__c> ankenMeisaiList = [SELECT
                                                    Id,
                                                    Name,
                                                    SagyoName__c,
                                                    Suryo__c,
                                                    WaribikigoTanka__c,
                                                    Kingaku__c
                                                FROM
                                                    AnkenMeisai__c
                                                WHERE
                                                    Anken__c = :aid AND
                                                    MitsumoriFlg__c = true];
        return ankenMeisaiList;
    }

    /**
     * １ページのデータを纏めたクラス
     */
    public class PageData {

        /** このページに表示する案件データ */
        public Anken__c anken {get; set;}

        /** このページに表示する案件の備考 */
        public String remarks {get; set;} 

        /** このページに表示する案件明細リスト */
        public List<AnkenMeisai__c> ankenMeisaiList {get; set;}

        /** 顧客名リスト */
        public List<String> kokyakumeiList {get; set;}

        /** ページ番号 */
        public Integer pageNo {get; set;}

        /** 見積日 */
        public Date mitsumoriDate {get; set;}

        /** 有効期限 */
        public Date yukokigenDate {get; set;}

        /** １ページ目かどうか */
        public boolean isFirst {get; set;}

        /** 最終ページかどうか */
        public boolean isLast {get; set;}

        /** コンストラクタ */
        public PageData(Anken__c anken, Boolean isSites) {
            this.anken = anken;
            this.remarks = Strings.convertBr2LineBreakString(anken.Remarks__c);
            this.mitsumoriDate = (isSites) ? anken.MitsumoriDateTime__c.date() : Date.today();
            this.yukokigenDate = this.mitsumoriDate.addDays(LIMIT_DATE);
            this.ankenMeisaiList = new List<AnkenMeisai__c> ();
            this.setKokyakumeiList();
            this.isFirst = false;
            this.isLast = false;
        }

        /**
         * 顧客名を分割しリストに設定
         */
        private void setKokyakumeiList(){

            this.kokyakumeiList = new List<String>();
            String kokyakumei = this.anken.KokyakuName__r.Name;

            while (kokyakumei.length() > 20){
                this.kokyakumeiList.add(kokyakumei.substring(0, 20));
                kokyakumei = kokyakumei.substring(20);
            }
            this.kokyakumeiList.add(kokyakumei);
        }

    }
}