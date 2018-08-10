/**
 * SitesMyPageControllerクラス用テストクラス
 */
@isTest
private class TestSitesMyPageController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test1', AccountId = testAcc.Id, Email = 'test1@test.com');
        insert testCon;

        // Sitesマイページ
        SitesMyPageController controller = new SitesMyPageController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        // 利用履歴
        controller.orderlist();
        // 請求履歴
        controller.billing();
        // お客様情報変更
        controller.useredit();
        // クレジットカード情報変更
        controller.creditcardedit();
        // パスワード変更
        controller.password();
        // 発注フォーム
        controller.order();

        // テスト終了
        Test.stopTest();
    }
}