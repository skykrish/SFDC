/**
 * AnkenMeisaiRegisterControllerクラス用テストクラス
 */
@isTest
private class TestAnkenMeisaiRegisterController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

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
        List<Sagyo__c> testSagyo = [SELECT Id FROM Sagyo__c WHERE Name='00000001'];
        if(testSagyo == null){
            testSagyo[0] = New Sagyo__c(Name = '001A',Nanido__c='G',SagyoBunrui__c='メイン作業',SagyoName__c='作業名001G',SagyoNaiyo__c='作業内容001G',Teika__c=180);
            insert testSagyo;
        }

        // テスト用割引データ作成
        Waribiki__c testWaribiki = new Waribiki__c(Kokyaku__c=testAcc.Id, Sagyo__c=testSagyo[0].Id, Waribikiritsu__c=10);
        insert testWaribiki;

        // テスト用顧客別作業データ作成
        Sagyo__c[] testKobetuSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = 'Test-001', Nanido__c='A', Kokyaku__c=testAnken.KokyakuName__c, SagyoBunrui__c='個別作業', SagyoName__c='作業名Test-001A', SagyoNaiyo__c='作業内容001A', Teika__c=70)
        };
        insert testKobetuSagyo;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);

        // 案件明細登録：初期化処理
        AnkenMeisaiRegisterController controller = new AnkenMeisaiRegisterController();
        controller.init();

        // 案件明細登録：登録処理
        controller.save();

        // 案件明細登録：キャンセル処理
        controller.cancel();

        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='楽天', TorihikiKbn__c='掛売上', ShimeGroup__c='楽天', KaisyuCycle__c='翌月', KaisyuDate__c='25日');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注');
        insert testAnken;

        // テスト用作業データ作成
        List<Sagyo__c> testSagyo = [SELECT Id FROM Sagyo__c WHERE Name='00000001'];
        if(testSagyo == null){
            testSagyo[0] = New Sagyo__c(Name = '001A',Nanido__c='G',SagyoBunrui__c='メイン作業',SagyoName__c='作業名001G',SagyoNaiyo__c='作業内容001G',Teika__c=180,Kokyaku__c=testAcc.Id);
            insert testSagyo;
        }

        // テスト用割引データ作成
        Waribiki__c testWaribiki = new Waribiki__c(Kokyaku__c=testAcc.Id, Sagyo__c=testSagyo[0].Id, Waribikiritsu__c=10);
        insert testWaribiki;

        // テスト用顧客別作業データ作成
        Sagyo__c[] testKobetuSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = 'Test-001', Nanido__c='A', Kokyaku__c=testAnken.KokyakuName__c, SagyoBunrui__c='個別作業', SagyoName__c='作業名Test-001A', SagyoNaiyo__c='作業内容001A', Teika__c=70)
        };
        insert testKobetuSagyo;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        // 20180412 追加
        ApexPages.currentPage().getParameters().put('param', 'InputClassification');

        // 案件明細登録：初期化処理
        AnkenMeisaiRegisterController controller = new AnkenMeisaiRegisterController();
        controller.init();

        // 案件明細登録：登録処理
        controller.saveRms();

        // 案件明細登録：キャンセル処理
        controller.cancel();

        // テスト終了
        Test.stopTest();
    }
}