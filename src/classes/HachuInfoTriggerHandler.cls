public with sharing class HachuInfoTriggerHandler {

    private boolean m_isExecuting = false;
    private integer batchSize = 0;

    /**
     * コンストラクタ
     */
    public HachuInfoTriggerHandler(boolean isExecuting, integer size){
        this.m_isExecuting = isExecuting;
        this.batchSize = size;
    }

    public void OnAfterInsert(HachuInfo__c[] oldObjs){
/* 2012/02/02 DELETE START
		// 案件ステータス更新
		this.updateAnkenStatus(oldObjs);
2012/02/02 DELETE END */
    }

    public void OnAfterUpdate(HachuInfo__c[] oldObjs, HachuInfo__c[] updatedObjs, Map<ID, HachuInfo__c> ObjMap){

        // 案件の仕入金額合計を再集計
		for (Integer i = 0; i < oldObjs.size(); i ++) {
			// 仕入金額が変更されたときのみ実行
			if (oldObjs[i].ShiireTotalKingaku__c != updatedObjs[i].ShiireTotalKingaku__c) {
				// 案件の仕入金額合計を再集計
				this.calcShiireKingaku(oldObjs[i].Anken__c);
			}
		}
		
/* 2012/02/02 DELETE START
		// 案件ステータス更新
		List<HachuInfo__c> hachuInfoList = new List<HachuInfo__c> ();
		for (Integer i = 0; i < oldObjs.size(); i ++) {
			// 発注ステータスが作業完了に変更されたもののみ処理対象とする
			if (oldObjs[i].HachuStatus__c != updatedObjs[i].HachuStatus__c) {
				hachuInfoList.add(updatedObjs[i]);
			}
		}
		this.updateAnkenStatus(hachuInfoList);
2012/02/02 DELETE END */
    }

    public void OnAfterDelete(HachuInfo__c[] deletedObjs, Map<ID, HachuInfo__c> ObjMap){

        // 案件の仕入金額合計を再集計
		for (Integer i = 0; i < deletedObjs.size(); i ++) {
			this.calcShiireKingaku(deletedObjs[i].Anken__c);
		}

/* 2012/02/02 DELETE START
		// 案件ステータス更新
		this.updateAnkenStatus(deletedObjs);
2012/02/02 DELETE END */
    }

    public void OnUndelete(HachuInfo__c[] restoredObjs){

        // 案件の仕入金額合計を再集計
		for (Integer i = 0; i < restoredObjs.size(); i ++) {
			this.calcShiireKingaku(restoredObjs[i].Anken__c);
		}

/* 2012/02/02 DELETE START
		// 案件ステータス更新
		this.updateAnkenStatus(restoredObjs);
2012/02/02 DELETE END */
    }
    
    /**
     * 案件の仕入金額合計を再集計
     *
     * @param aid 案件Id
     */
    private void calcShiireKingaku(String aid) {
    	
    	List<Anken__c> anken = [SELECT
    	                            Id,
    	                            Name,
    	                            ShiireTotalKingaku__c,
                                    (SELECT
                                         Id,
                                         Name,
                                         ShiireTotalKingaku__c
                                     FROM
                                         HachuInfoes__r)
    	                        FROM
    	                            Anken__c
    	                        WHERE
    	                            Id = :aid];

        // 発注情報の仕入金額を再集計
        if (!anken.isEmpty()) {
            Decimal shiireTotal = 0;
            for (HachuInfo__c item : anken[0].HachuInfoes__r) {
            	shiireTotal += item.ShiireTotalKingaku__c;
            }
        
            // 案件の仕入金額合計を更新
            anken[0].ShiireTotalKingaku__c = shiireTotal;
            update anken[0];
        }
    }

    /**
     * 案件ステータス変更
     *
     * @param objs 発注情報
     */
/* 2012/02/02 DELETE START
    private void updateAnkenStatus(HachuInfo__c[] objs) {
    	
        Map<String, List<HachuInfo__c>> hachuInfoMap = new Map<String, List<HachuInfo__c>> ();
        List<String> aidList = new List<String> ();

    	// 処理対象の案件、発注情報を取得する
    	for(HachuInfo__c item : objs) {
    		// 案件に紐付くすべての発注情報取得
			List<HachuInfo__c> hachuInfoList = [SELECT Id, Name, HachuStatus__c FROM HachuInfo__c WHERE Anken__c = :item.Anken__c];
			// 案件IDをキーに発注情報を格納
			// 案件IDリスト作成
			if (!hachuInfoMap.containsKey(item.Anken__c)) {
				hachuInfoMap.put(item.Anken__c, hachuInfoList);
				aidList.add(item.Anken__c);
			}
    	}

    	// 処理対象の案件取得
		List<Anken__c> ankenList = [SELECT Id, Name, Status__c FROM Anken__c WHERE Id = :aidList];
    	for(Anken__c item : ankenList) {
    		// 案件に紐付くすべての発注情報取得
    		List<HachuInfo__c> hachuInfoList = hachuInfoMap.get(item.Id);
    		// 案件ステータスを発注情報から判定
    		String status = '受注作業完了';
    		for (HachuInfo__c hachuInfo : hachuInfoList) {
    		    if (Strings.isNullOrEmpty(hachuInfo.HachuStatus__c) || hachuInfo.HachuStatus__c == '依頼済み') {
    		    	status = '受注委託済み';
    		    	break;
    		    }
    		}
    		// 案件ステータスを設定
    		item.Status__c = status;
    	}
    	
    	// 案件更新
    	update ankenList;
    }
2012/02/02 DELETE END */

}