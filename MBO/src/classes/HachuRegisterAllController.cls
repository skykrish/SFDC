public with sharing class HachuRegisterAllController {

    /** 更新元：発注情報登録 */
    private static String UPDATED_BY_HACHU_REGISTER_ALL = 'hachu-register-all';

    /** 戻り先URL */
    private String retUrl;

    /** 処理対象の案件IDリスト */
    private List<String> ankenIdList;

	/** リストビュー上で選択されたレコード */
    public List<Anken__c> records {
    	get;
    	private set;
    }

    /** 発注情報 */
    public HachuInfo__c hachuInfo {
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
    public HachuRegisterAllController() {
    }

    /**
     * リストビュー上から呼ばれるコンストラクタ
     */
    public HachuRegisterAllController (ApexPages.StandardSetController controller) {

		// リクエストパラメータ取得
        this.records = (List<Anken__c>)controller.getSelected();
        this.retUrl = ApexPages.currentPage().getParameters().get('retURL');

        // 処理対象の案件IDリスト生成
        this.ankenIdList = new List<String> ();
        for (Anken__c anken : this.records) {
        	this.ankenIdList.add(anken.Id);
        }

    	// 発注情報オブジェクト生成
    	this.hachuInfo = new HachuInfo__c();
    }

    /**
     * 初期化処理
     */
    public PageReference init() {

    	this.isInitCheck = true;

    	// 選択レコード件数が0件
        if (this.records.size() == 0) {
        	this.isInitCheck = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '選択されたレコードがありません。'));
        }

    	// 選択レコード件数が上限以上
        if (this.records.size() > Integer.valueOf(System.Label.ExecuteLimitCount_HachuRegister)) {
        	isInitCheck = false;
			Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '一括処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_HachuRegister + '件です。'));
        }

        // ステータスが請求確定済み以降となっていないかチェック
        List<Anken__c> ankenList = [SELECT Id, Name, StatusLock__c FROM Anken__c WHERE Id = :this.ankenIdList];
        for (Anken__c item : ankenList) {
            if (item.StatusLock__c) {
                this.isInitCheck = false;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '伝票番号：' + item.Name + '　　' + '請求確定済みの案件です。'));
            }
        }

    	return null;
    }

    /**
     * 登録処理
     * 表示されている案件のすべての案件明細を登録する。
     * 登録後は案件画面へ遷移する。
     */
    public PageReference save() {

        // 発注先名称を取得
    	List<User> hachusakiList = [SELECT Id, Name FROM User WHERE Id = :this.hachuInfo.Hachusaki__c];

        // 案件情報更新（発注番号採番）
        List<Anken__c> ankenList = [SELECT
                                        Id,
                                        Name,
                                        HachuNoKanri__c,
                                        HachusakiText__c,
                                        ItemCnt__c,
                                        Sagyoshiji_Renrakujiko__c
                                    FROM
                                        Anken__c
                                    WHERE
                                        Id IN :this.ankenIdList];

        for (Anken__c item : ankenList) {
	        item.HachuNoKanri__c = (item.HachuNoKanri__c != null) ? item.HachuNoKanri__c + 1 : 1;
	        item.HachusakiText__c = hachusakiList[0].Name;
        }
        update ankenList;

        // 発注情報登録
        List<HachuInfo__c> hachuInfoList = new List<HachuInfo__c> ();
        for (Anken__c item : ankenList) {
        	HachuInfo__c insObj = new HachuInfo__c();
	        insObj.Name = item.Name + '-' + item.HachuNoKanri__c;
	        insObj.Hachusaki__c = this.hachuInfo.Hachusaki__c;
	        insObj.ItemCnt__c = item.ItemCnt__c;
	        insObj.Sagyoshiji_Renrakujiko__c = item.Sagyoshiji_Renrakujiko__c;
	        insObj.OwnerId = this.hachuInfo.Hachusaki__c;
	        insObj.Anken__c = item.Id;
	        hachuInfoList.add(insObj);
        }
        insert hachuInfoList;

        // 案件明細更新
        List<AnkenMeisai__c> updAnkenMeisaiList = new List<AnkenMeisai__c> ();
        for (HachuInfo__c hachuInfo : hachuInfoList) {
        	// 案件明細取得
            List<AnkenMeisai__c> ankenMeisaiList = [SELECT
                                                        Id,
                                                        Name,
                                                        HachuInfo__c,
                                                        WhoUpdated__c
                                                    FROM
                                                        AnkenMeisai__c
                                                    WHERE
                                                        Anken__r.Id = :hachuInfo.Anken__c];

            // 案件明細を発注情報へ登録
            for (AnkenMeisai__c item : ankenMeisaiList) {
                item.HachuInfo__c = hachuInfo.Id;
                item.WhoUpdated__c = UPDATED_BY_HACHU_REGISTER_ALL;
                updAnkenMeisaiList.add(item);
            }
        }
        update updAnkenMeisaiList;

    	// 発注依頼画面へのリクエストパラメータ生成
    	String hids = null;
        for (HachuInfo__c item : hachuInfoList) {
        	if (hids == null) {
		    	hids = item.Id;
        	} else {
		    	hids += ',' + item.Id;
        	}
    	}

        // 発注依頼画面へ遷移
        PageReference next = Page.HachuIrai;
        next.getParameters().put('hid', hids);
        next.getParameters().put('retURL', this.retUrl);

        return next;
    }

    /**
     * キャンセル処理
     * 案件画面へ遷移する。
     */
    public PageReference cancel() {
        return new PageReference(this.retUrl);
    }
}