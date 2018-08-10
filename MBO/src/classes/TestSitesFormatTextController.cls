/**
 * SitesFormatTextControllerクラス用テストクラス
 */
@isTest
private class TestSitesFormatTextController {

    static testMethod void myUnitTest() {

         // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Phone='03-1111-1111');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email='test@test.com');
        insert testCon;

        // Sites定型テキスト
        SitesFormatTextController controller = new SitesFormatTextController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        // 定型テキスト１の登録
        controller.saveFormatText1();
        // 定型テキスト２の登録
        controller.saveFormatText2();
        // 定型テキスト３の登録
        controller.saveFormatText3();

        // テスト終了
        Test.stopTest();
    }
}