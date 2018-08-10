/**
 * SitesFeedbackControllerクラス用テストクラス
 */
@isTest
private class TestSitesFeedbackController {

    static testMethod void myUnitTest() {

         // テスト開始
        Test.startTest();

        // Sitesフィードバック
        SitesFeedbackController controller = new SitesFeedbackController();
        // 初期化処理
        controller.init();
        // 入力チェック：必須チェック
        controller.confirm();
        // 入力チェック：形式チェック
        controller.email = 'xxxx';
        controller.confirm();
        // プライバシーポリシー、利用規約チェック：必須チェック
        controller.CompanyName = 'テスト会社';
        controller.name = 'テストユーザ';
        controller.email = 'test@test.com';
        controller.detail = 'フィードバック内容';
        controller.isAgree = false;
        controller.confirm();
        // 確認
        controller.CompanyName = 'テスト会社';
        controller.name = 'テストユーザ';
        controller.email = 'test@test.com';
        controller.detail = 'フィードバック内容';
        controller.isAgree = true;
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
}