/**
 * HachuInfoTriggerHandlerクラス用テストクラス
 */
@isTest
private class TestHachuInfoTriggerHandler {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テストユーザ取得
        List<User> testUser = [SELECT Id, UserName FROM User WHERE UserRoleId = '00E10000000Zwco' AND IsActive = true];

        // テスト顧客作成
        Account testAcc = new Account(Name = 'テスト顧客');
        insert testAcc;

        // テスト作業作成
        Sagyo__c testSagyo = new Sagyo__c(Name = '999',Nanido__c='A',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999A',SagyoNaiyo__c='作業内容999A',Teika__c=70);
        insert testSagyo;

        // テスト案件作成
        Anken__c testAnken = new Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注');
        insert testAnken;

        // テスト発注情報作成
        HachuInfo__c testHachuInfo = new HachuInfo__c(Name=testAnken.Name + '-1', Anken__c=testAnken.Id, Hachusaki__c=testUser[0].Id);
        insert testHachuInfo;

        // テスト発注先仕入価格作成
        HachusakiShiireKakaku__c testSiireKakaku = new HachusakiShiireKakaku__c(Sagyo__c=testSagyo.Id, Hachusaki__c=testUser[0].Id, ShiireKakaku__c=500);
        insert testSiireKakaku;

		// 仕入金額変更
		testSiireKakaku.ShiireKakaku__c = 999;
        update testSiireKakaku;

        // 発注ステータス変更
        testHachuInfo.HachuStatus__c = '作業完了';
        update testHachuInfo;

		// テスト発注情報削除
        delete testHachuInfo;

        // テスト終了
        Test.stopTest();
    }
}