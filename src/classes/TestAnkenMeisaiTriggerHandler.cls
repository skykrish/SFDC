/**
 * AnkenMeisaiTriggerHandlerクラス用テストクラス
 */
@isTest
private class TestAnkenMeisaiTriggerHandler {

    /**
     * setWaribiki_Sagyo_TaxRateメソッドテスト
     */
    static testMethod void myUnitTest_setWaribiki_Sagyo_TaxRate() {
        try{
        	//
        	Test.startTest();
	        //顧客作成
	        Account[] Acc = New Account[]{
	        	New Account(Name = 'テスト顧客Ａ'),
	        	New Account(Name = 'テスト顧客Ｂ')
	        };
	        insert Acc;

	        //作業作成
	        Sagyo__c[] Sagyo = New Sagyo__c[]{
	        	New Sagyo__c(Name = '999',Nanido__c='A',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999A',SagyoNaiyo__c='作業内容999A',Teika__c=70),
	        	New Sagyo__c(Name = '999',Nanido__c='B',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999B',SagyoNaiyo__c='作業内容999B',Teika__c=100),
	        	New Sagyo__c(Name = '999',Nanido__c='C',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999C',SagyoNaiyo__c='作業内容999C',Teika__c=180)
	        };
	        insert Sagyo;

	        //割引作成
	        Waribiki__c[] Wari = New Waribiki__c[]{
	        	New Waribiki__c(Kokyaku__c=Acc[0].Id,Sagyo__c=Sagyo[0].Id,Waribikiritsu__c=10),
	        	New Waribiki__c(Kokyaku__c=Acc[0].Id,Sagyo__c=Sagyo[1].Id,Waribikiritsu__c=15)
	        };
	        insert Wari;

        	//案件作成
        	Anken__c Anken = New Anken__c(KokyakuName__c=Acc[0].Id,Status__c='受注');
        	insert Anken;

        	//案件明細作成
        	//(割引あり：割引率未設定、作業名未設定、単価未設定)
        	AnkenMeisai__c AM = New AnkenMeisai__c(
        						Anken__c=Anken.Id,
        						SagyoCd__c=Sagyo[0].Id,
        						Suryo__c=1
        						);
        	insert AM;

        	//(割引あり：割引率設定、作業名未設定、単価未設定)
        	AnkenMeisai__c AM2 = New AnkenMeisai__c(
        						Anken__c=Anken.Id,
        						SagyoCd__c=Sagyo[0].Id,
        						Suryo__c=1,
        						Waribikiritsu__c=25
        						);
        	insert AM2;

        	//(割引あり：割引率未設定、作業名設定、単価未設定)
        	AnkenMeisai__c AM3 = New AnkenMeisai__c(
        						Anken__c=Anken.Id,
        						SagyoCd__c=Sagyo[0].Id,
        						Suryo__c=1,
        						SagyoName__c='テスト作業名'
        						);
        	insert AM3;

        	//(割引あり：割引率未設定、作業名未設定、単価設定)
        	AnkenMeisai__c AM4 = New AnkenMeisai__c(
        						Anken__c=Anken.Id,
        						SagyoCd__c=Sagyo[0].Id,
        						Suryo__c=1,
        						Tanka__c=999
        						);
        	insert AM4;

        	//(割引無し：割引率未設定)
        	AnkenMeisai__c AM5 = New AnkenMeisai__c(
        						Anken__c=Anken.Id,
        						SagyoCd__c=Sagyo[2].Id,
        						Suryo__c=1
        						);
        	insert AM5;

        	//(割引無し：割引率設定)
        	AnkenMeisai__c AM6 = New AnkenMeisai__c(
        						Anken__c=Anken.Id,
        						SagyoCd__c=Sagyo[2].Id,
        						Suryo__c=1,
        						Waribikiritsu__c=25
        						);
        	insert AM6;

        	//結果確認
        	List<AnkenMeisai__c> AMList = [
	        								select
		        								Id,
		        								Name,
		        								Anken__r.Name,
		        								SagyoCd__r.Name,
		        								SagyoName__c,
		        								Suryo__c,
		        								Tanka__c,
		        								Waribikiritsu__c,
		        								Kingaku__c,
		        								TaxRate__c,
		        								Tax__c,
		        								Kingaku_Tax__c
		        							from
		        								AnkenMeisai__c
		        							where
		        								id = :AM.Id or id = :AM2.Id or id = :AM3.Id or id = :AM4.Id or id = :AM5.Id or id = :AM6.Id
	        								];
	        for(AnkenMeisai__c AnkenMeisai:AMList){
	        	system.debug(
	        		'伝票番号：' + AnkenMeisai.Anken__r.Name +
	        		' 作業コード：' + AnkenMeisai.SagyoCd__r.Name +
	        		' 作業名：' + AnkenMeisai.SagyoName__c +
	        		' 数量：' + AnkenMeisai.Suryo__c +
	        		' 単価：' + AnkenMeisai.Tanka__c +
	        		' 割引率：' + AnkenMeisai.Waribikiritsu__c +
	        		' 金額(税抜き)：' + AnkenMeisai.Kingaku__c +
	        		' 消費税率：' + AnkenMeisai.TaxRate__c +
	        		' 消費税額：' + AnkenMeisai.Tax__c +
	        		' 金額(税込み)：' + AnkenMeisai.Kingaku_Tax__c
	        	);
	        }

        	// 更新
        	AM6.Waribikiritsu__c = 20;
        	update AM6;

        	// 削除
        	delete AM6;

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
        	//
	        Test.stopTest();
        }
    }

}