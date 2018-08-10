public with sharing class HachuRegisterController {

	/** 案件の発注先（テキスト）のデリミタ */
	private static String HACHUSAKI_DELIMITER = '/';
    /** 更新元：発注情報登録 */
    private static String UPDATED_BY_HACHU_REGISTER = 'hachu-register';

    /** 案件ID */
    private String ankenId;

    /** 戻り先URL */
    private String retUrl;

    /** 発注情報 */
    public HachuInfo__c hachuInfo {
        get;
        set;
    }

    /** 表示用案件明細データリスト */
    public List<AnkenMeisaiDummy> ankenMeisaiList {
        get;
        set;
    }

    /** 初期表示チェック結果 */
    public Boolean isInitCheck {
    	get;
    	private set;
    }

    /**
     * デフォルトコンストラクタ
     */
    public HachuRegisterController() {

        // リクエストパラメータ取得
        this.ankenId = ApexPages.currentPage().getParameters().get('aid');
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');
    }

    /**
     * 初期化処理
     */
    public PageReference init() {

        this.isInitCheck = true;

        // 初期表示チェック
        if (!this.initCheck(this.ankenId)) {
        	this.isInitCheck = false;
        	return null;
        }

        // 案件、案件明細情報取得
        Anken__c anken = this.getAnkenData(this.ankenId);
        List<AnkenMeisai__c> ankenMeisaiList = this.getAnkenMeisaiData(this.ankenId);

        // 発注情報生成
        this.hachuInfo = new HachuInfo__c(Anken__c = anken.Id, Sagyoshiji_Renrakujiko__c = anken.Sagyoshiji_Renrakujiko__c, ItemCnt__c = anken.ItemCnt__c);

        // 案件明細情報生成
        this.ankenMeisaiList = new List<AnkenMeisaiDummy> ();
        for (AnkenMeisai__c item : ankenMeisaiList) {
            AnkenMeisaiDummy ankenMeisai = new AnkenMeisaiDummy();
            ankenMeisai.ankenMeisai = item;
            if (item.HachuInfo__c == null) {
            	ankenMeisai.checked = true;
            }
            this.ankenMeisaiList.add(ankenMeisai);
        }

        return null;
    }

    /**
     * 初期表示チェック
     *
     * @param aid 案件ID
     * @return true:OK, false:NG
     */
    private Boolean initCheck(String aid) {

        Boolean ret = true;

        // ステータスが請求確定済み以降となっていないかチェック
        List<Anken__c> ankenList = [SELECT Id, Name, StatusLock__c FROM Anken__c WHERE Id = :aid];
        if (ankenList[0].StatusLock__c) {
            ret = false;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + ankenList[0].Name + '　　' + '請求確定済みの案件です。'));
        }

        return ret;
    }

    /**
     * 案件情報取得
     *
     * @param aid 案件Id
     * @return 案件情報
     */
    private Anken__c getAnkenData(String aid) {

        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        HachuNoKanri__c,
                                        HachusakiText__c,
                                        ItemCnt__c,
                                        Sagyoshiji_Renrakujiko__c,
                                        StatusLock__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id = :aid];
        return ankenList[0];
    }

    /**
     * 案件明細情報取得
     *
     * @param aid 案件Id
     * @return 案件明細情報
     */
    private List<AnkenMeisai__c> getAnkenMeisaiData(String aid) {

        List<AnkenMeisai__c> ankenMeisaiList = [SELECT
                                                    Id,
                                                    Name,
                                                    Anken__c,
                                                    SagyoCd__c,
                                                    SagyoName__c,
                                                    Suryo__c,
                                                    Tanka__c,
                                                    Waribikiritsu__c,
                                                    Kingaku__c,
                                                    TaxRate__c,
                                                    Tax__c,
                                                    Kingaku_Tax__c,
                                                    MitsumoriFlg__c,
                                                    WaribikigoTanka__c,
                                                    HachuInfo__c,
                                                    Hachusaki__c,
                                                    WhoUpdated__c
                                                FROM
                                                    AnkenMeisai__c
                                                WHERE
                                                    Anken__r.Id = :aid
                                                ORDER BY
                                                    Name];
        return ankenMeisaiList;
    }

    /**
     * 登録処理
     * 登録にチェックされている案件明細を登録する。
     * 登録後は案件画面へ遷移する。
     */
    public PageReference save() {

        // 入力チェック
        if (!this.validate(this.hachuInfo, this.ankenMeisaiList)) {
        	return null;
        }

        // 案件情報更新（発注番号採番, 発注先更新）
        Anken__c anken = this.getAnkenData(this.ankenId);
        anken.HachuNoKanri__c = (anken.HachuNoKanri__c != null) ? anken.HachuNoKanri__c + 1 : 1;
        anken.HachusakiText__c = this.getHachusakiText(this.hachuInfo.Hachusaki__c, anken.HachusakiText__c);
        update anken;

        // 発注情報登録
        this.hachuInfo.Name = anken.Name + '-' + anken.HachuNoKanri__c;
        this.hachuInfo.OwnerId = this.hachuInfo.Hachusaki__c;
        insert this.hachuInfo;

        // 案件明細更新
        List<AnkenMeisai__c> updAnkenMeisaiList = new List<AnkenMeisai__c> ();
        for(AnkenMeisaiDummy item : this.ankenMeisaiList) {
            // チェックされているかどうか
            if (item.checked) {
                item.ankenMeisai.HachuInfo__c = this.hachuInfo.Id;
                item.ankenMeisai.WhoUpdated__c = UPDATED_BY_HACHU_REGISTER;
                updAnkenMeisaiList.add(item.ankenMeisai);
            }
        }
        update updAnkenMeisaiList;

        // 発注依頼画面へ遷移
        PageReference next = Page.HachuIrai;
        next.getParameters().put('hid', this.hachuInfo.Id);
        next.getParameters().put('retURL', this.retUrl);

        return next;
    }

    /**
     * 入力チェック
     *
     * @param HachuInfo__c 入力された発注情報
     * @param List<AnkenMeisaiDummy> 入力された案件明細情報
     * @return true:OK, false:NG
     */
    private Boolean validate(HachuInfo__c hachuInfo, List<AnkenMeisaiDummy> ankenMeisaiList) {

    	Boolean ret = true;

/* 2012/01/13 案件明細チェック削除 (βテスト課題管理_ver.2.0.xls　- No.46対応)

    	// 最低１件でもチェックされているか
    	Boolean isCheck = false;
        for(AnkenMeisaiDummy item : ankenMeisaiList) {
            if (item.checked) {
            	isCheck = true;
            }
        }
        if (!isCheck) {
        	ret = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '案件明細が選択されていません。'));
        }
*/

    	return ret;
    }

    /**
     * 案件に登録する発注先（テキスト）を取得する。
     *
     * @param hachusaki 画面上で入力された発注先Id
     * @param hachusakiText 現在案件に登録されている発注先（テキスト）
     * @param 案件に登録する発注先（テキスト）
     */
    private String getHachusakiText(String hid, String hachusakiText) {

    	String ret = '';

    	// 発注先名称を取得
    	List<User> hachusakiList = [SELECT Id, Name FROM User WHERE Id = :hid];

    	if (!Strings.isNullOrEmpty(hachusakiText)) {
    		// 現在案件に登録されている発注先（テキスト）をリスト化
    		Boolean isExsit = false;
    		List<String> hachusakiTextList = hachusakiText.split(HACHUSAKI_DELIMITER);
    		for (String item : hachusakiTextList) {
    			if (item == hachusakiList[0].Name) {
    				isExsit = true;
    				break;
    			}
    		}
    		// 新規発注先の場合、発注先（テキスト）に追加する。
    		hachusakiTextList.add(hachusakiList[0].Name);
    		// 発注先（テキスト）を再作成
    		for (String item : hachusakiTextList) {
    			if (ret.length() > 0) {
    				ret += HACHUSAKI_DELIMITER;
    			}
    			ret += item;
    		}
    	} else {
    		ret = hachusakiList[0].Name;
    	}

    	return ret;
    }

    /**
     * キャンセル処理
     * 案件画面へ遷移する。
     */
    public PageReference cancel() {
        return new PageReference(this.retUrl);
    }

    /**
     * 画面表示用クラス
     */
    public class AnkenMeisaiDummy {

        /** 案件明細データ */
        public AnkenMeisai__c ankenMeisai {get; set;}

        /** 選択用チェックボックス */
        public boolean checked {get; set;}

        /** デフォルトコンストラクタ */
        public AnkenMeisaiDummy() {
            this.checked = false;
        }
    }
}