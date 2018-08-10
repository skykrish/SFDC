/**
 * AnkenTriggerHandlerクラス用テストクラス
 */
@isTest
private class TestAnkenTriggerHandler {

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
        Anken__c testAnken = new Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', Nouki_Date__c = Date.today(), Nouki_Time__c = '12:00',JuchuDateTime__c=Date.today());
        insert testAnken;

        // テスト発注情報作成
        HachuInfo__c testHachuInfo = new HachuInfo__c(Name=testAnken.Name + '-1', Anken__c=testAnken.Id, Hachusaki__c=testUser[0].Id, HachuStatus__c='依頼済み');
        insert testHachuInfo;

        // 案件ステータス変更
        testAnken.Status__c = '納品済み';
        update testAnken;

        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void myUnitTest1_2() {

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
        Anken__c testAnken = new Anken__c(KokyakuName__c=testAcc.Id, Status__c='納品処理中', Nouki_Date__c = Date.today(), Nouki_Time__c = '12:00', InvoicePersonnelAsain__c=testUser[0].Id,JuchuDateTime__c=Date.today());
        insert testAnken;

        // テスト発注情報作成
        HachuInfo__c testHachuInfo = new HachuInfo__c(Name=testAnken.Name + '-1', Anken__c=testAnken.Id, Hachusaki__c=testUser[0].Id, HachuStatus__c='依頼済み');
        insert testHachuInfo;

        // 案件ステータス変更
        testAnken.Status__c = '納品済み';
        update testAnken;

        // テスト終了
        Test.stopTest();
    }
    
    /**
     * 更新処理
     */
    static testMethod void myUnitTest2() {

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
        Anken__c testAnken = new Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', Nouki_Date__c = Date.today(), Nouki_Time__c = '12:00',JuchuDateTime__c=Date.today());
        insert testAnken;
        
        // 案件更新
        testAnken.InvoicePersonnel__c = testUser[0].Id;
        update testAnken;

        // テスト発注情報作成
        HachuInfo__c testHachuInfo = new HachuInfo__c(Name=testAnken.Name + '-1', Anken__c=testAnken.Id, Hachusaki__c=testUser[0].Id, HachuStatus__c='依頼済み');
        insert testHachuInfo;

        // 案件ステータス変更
        testAnken.Status__c = '納品済み';
        update testAnken;

        // テスト終了
        Test.stopTest();
    }

}