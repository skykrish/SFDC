/**
 * SitesPasswordControllerRakutenクラス用テストクラス
 */
@isTest
private class TestSitesPasswordControllerRakuten {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='不要');
        insert testAcc;

        // テスト用担当者データ作成
        List<Contact> testCon = new List<Contact> {
            new Contact(LastName='Test1', AccountId = testAcc.Id, Email = 'test1@test.com'),
            new Contact(LastName='Test2', AccountId = testAcc.Id, Email = 'test2@test.com')
        };
        insert testCon;

        // Sitesパスワード変更
        SitesPasswordControllerRakuten controller = new SitesPasswordControllerRakuten();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        
        // 確認
        // 現在のパスワード：必須チェック
        controller.password = null;
        controller.confirm();
        // 現在のパスワード：認証
        controller.password = 'xxxx';
        controller.confirm();
        // 新しいパスワード：必須チェック
        controller.newPassword = null;
        controller.confirm();
        // 新しいパスワード：桁数チェック
        controller.newPassword = 'abc';
        controller.confirm();
        // 新しいパスワード：形式チェック
        controller.newPassword = '!abc';
        controller.confirm();
        // パスワード：パスワード再入力チェック
        controller.newPassword = 'xxxx';
        controller.newPasswordConfirm = 'yyyy';
        controller.confirm();
        // 同一パスワードチェック
        controller.password = 'password';
        controller.newPassword = 'password';
        controller.newPasswordConfirm = 'password';
        controller.confirm();
        // 正常
        controller.password = 'password';
        controller.newPassword = 'newpassword';
        controller.newPasswordConfirm = 'newpassword';
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();
        // 発注フォーム
        controller.order();

        // テスト終了
        Test.stopTest();
    }
}