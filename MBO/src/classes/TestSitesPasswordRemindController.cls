/**
 * SitesPasswordRemindControllerクラス用テストクラス
 */
@isTest
private class TestSitesPasswordRemindController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Phone='03-1111-1111');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email='test@test.com');
        insert testCon;

        // Sitesパスワードリマインド
        SitesPasswordRemindController controller = new SitesPasswordRemindController();
        // 初期化処理
        controller.init();
        // 入力チェック１：必須チェック
        controller.send();
        // 入力チェック２：形式チェック
        controller.email = 'xxx';
        controller.phone1 = '03';
        controller.phone2 = 'yyyy';
        controller.phone3 = 'zzzz';
        controller.send();
        // 担当者データなし
        controller.email = 'wrongtest@test.com';
        controller.phone1 = '03';
        controller.phone2 = '1111';
        controller.phone3 = '1111';
        controller.send();
        // 顧客データなし
        controller.email = 'test@test.com';
        controller.phone1 = '03';
        controller.phone2 = '2222';
        controller.phone3 = '2222';
        controller.send();
        // 正常
        controller.email = 'test@test.com';
        controller.phone1 = '03';
        controller.phone2 = '1111';
        controller.phone3 = '1111';
        controller.send();

        // テスト終了
        Test.stopTest();
    }
}