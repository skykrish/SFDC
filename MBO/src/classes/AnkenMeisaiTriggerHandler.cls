public with sharing class AnkenMeisaiTriggerHandler {

    /** 更新元：発注情報登録 */
    private static String UPDATED_BY_HACHU_REGISTER = 'hachu-register';
    /** 更新元：発注情報登録 */
    private static String UPDATED_BY_HACHU_REGISTER_ALL = 'hachu-register-all';

    private boolean m_isExecuting = false;
    private integer batchSize = 0;
    private Map<Id, Anken__c> ankenMap;

    /**
     * コンストラクタ
     */
    public AnkenMeisaiTriggerHandler(boolean isExecuting, integer size){
        this.m_isExecuting = isExecuting;
        this.batchSize = size;
    }

    /**
     * BeforeInsert
     */
    public void OnBeforeInsert(AnkenMeisai__c[] newObjs){

        for (AnkenMeisai__c obj : newObjs) {
        	//割引率、作業名、単価、消費税率を設定
/** mod start 2017-08-07 */
/** 請求取り纏め時には処理しないように修正 */
			if (obj.AnkenStatus__c != '請求確定済み' && obj.AnkenStatus__c != '取り纏め処理済み'){
	        	this.setWaribiki_Sagyo_TaxRate(obj);
			}
//        	this.setWaribiki_Sagyo_TaxRate(obj);
/** mod start 2017-08-07 */
        }

        // 案件の更新
        updateAnken(newObjs, true);
    }

    /**
     * BeforeUpdate
     */
    public void OnBeforeUpdate(AnkenMeisai__c[] newObjs){

        // 案件の更新
        updateAnken(newObjs, true);
    }

    /**
     * BeforeDelete
     */
    public void OnBeforeDelete(AnkenMeisai__c[] oldObjs){

        // 案件の更新
        updateAnken(oldObjs, false);
    }

    /**
     * Undelete
     */
    public void OnUndelete(AnkenMeisai__c[] newObjs){

        // 案件の更新
        updateAnken(newObjs, false);
    }

	/**
     * 「案件明細」オブジェクトの登録時に以下の処理をするメソッド
     * ・「作業」オブジェクトから作業名、単価を取得し設定。
     * ※画面上既に値が設定済みの場合は画面上の値を優先。
     * ・「割引」オブジェクトから割引率を取得し設定。
     * ※画面上既に値が設定済みの場合は画面上の値を優先。
     * ※該当する「割引」オブジェクトが存在しない場合は割引無し。
     * ・「消費税率」カスタムラベルから消費税率を取得し設定。
     */
    private void setWaribiki_Sagyo_TaxRate(AnkenMeisai__c obj) {
		//「割引率」が未設定か判定
		if(obj.Waribikiritsu__c == null){
			//案件に紐付く顧客を取得
			Anken__c Anken = [select KokyakuName__c from Anken__c where Id=:obj.Anken__c];
			//該当する「割引」オブジェクトを取得
			List<Waribiki__c> wList = [
								select Waribikiritsu__c
								from Waribiki__c
								where Kokyaku__c=:Anken.KokyakuName__c
								and Sagyo__c = :obj.SagyoCd__c
								];
			//「割引」オブジェクトが取得できたら設定
			if(!wList.isEmpty()){
				obj.Waribikiritsu__c = wList[0].Waribikiritsu__c;
			}
		}

		//「消費税率」を設定
		obj.TaxRate__c = decimal.valueOf(Label.TaxRate);

		//「作業名」または「単価」が未設定か判定
		if(obj.SagyoName__c == null || obj.Tanka__c == null){
			//「作業」オブジェクトを取得
			Sagyo__c s = [select SagyoName__c,Teika__c from Sagyo__c where Id=:obj.SagyoCd__c];
			//「作業名」を設定(画面で未設定の場合のみ)
			if(obj.SagyoName__c == null){
				obj.SagyoName__c = s.SagyoName__c;
			}
			//「単価」を設定(画面で未設定の場合のみ)
			if(obj.Tanka__c == null){
				obj.Tanka__c = s.Teika__c;
			}
		}
    }

    /**
     * 「案件明細」オブジェクトの作成、更新、削除、復元時に以下の処理をするメソッド
     * ・「案件」オブジェクトの見積もり担当者、見積日時にログインユーザ、システム日時を取得し設定。
     */
    private void updateAnken(AnkenMeisai__c[] objs, Boolean isClear){

        // 案件マップ作成
        this.ankenMap = new Map<Id, Anken__c>();
        for (AnkenMeisai__c obj : objs) {
        	// 更新元が発注情報登録の場合、見積もり担当者、見積日時を更新しない
        	if (obj.WhoUpdated__c != UPDATED_BY_HACHU_REGISTER &&
        	    obj.WhoUpdated__c != UPDATED_BY_HACHU_REGISTER_ALL
        	) {
        		// 更新対象とする
                if(!this.ankenMap.containsKey(obj.Anken__c)){
                    this.ankenMap.put(obj.Anken__c, null);
                }
        	}
        	// 更新元クリア
        	if (isClear) {
            	obj.WhoUpdated__c = null;
        	}
        }

        // 案件取得
        List<Anken__c> ankenList = [SELECT Id, MitsumoriTantosya__c, MitsumoriDateTime__c
                                    FROM Anken__c
                                    WHERE Id IN :this.ankenMap.keySet()];

        // 案件の項目を設定
        for(Anken__c obj: ankenList){
        	//「見積もり担当者」を設定
            obj.MitsumoriTantosya__c = Userinfo.getUserId();
            //「見積日時」を設定
            obj.MitsumoriDateTime__c = system.now();
        }

        // 案件の更新
        update ankenList;
    }
}