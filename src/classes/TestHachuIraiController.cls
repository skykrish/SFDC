/**
 * HachuIraiControllerクラス用テストクラス
 */
 @isTest
private class TestHachuIraiController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        //ユーザ取得
        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId = '00E10000000Zwco' AND IsActive = true];

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注');
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // テスト発注情報作成
        HachuInfo__c testHachuInfo = new HachuInfo__c(Name=testAnken.Name + '-1', Anken__c=testAnken.Id, Hachusaki__c=testUser[0].Id);
        insert testHachuInfo;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('hid', testHachuInfo.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 発注依頼
        HachuIraiController controller = new HachuIraiController();
        // 初期化
        controller.init();
        // ステータス変更
        controller.updStatus();
        // キャンセル
        controller.cancel();

        // テスト終了
        Test.stopTest();
    }

}