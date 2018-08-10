/**
 * SitesContactControllerクラス用テストクラス
 */
@isTest
private class TestSitesContactController {

    static testMethod void myUnitTest() {

         // テスト開始
        Test.startTest();

        // Sites問い合わせ
        SitesContactController controller = new SitesContactController();
        // 初期化処理
        controller.init();
        // 入力チェック：必須チェック
        controller.confirm();
        // 入力チェック：形式チェック
        controller.contact.Email__c = 'xxxx';
        controller.phone1 = 'xxx';
        controller.phone2 = 'xxxx';
        controller.phone3 = 'xxxx';
        controller.confirm();
        // プライバシーポリシー、利用規約チェック：必須チェック
        controller.contact.CompanyName__c = 'テスト会社';
        controller.contact.ContactName__c = 'テストユーザ';
        controller.contact.Email__c = 'test@test.com';
        controller.phone1 = '03';
        controller.phone2 = '1111';
        controller.phone3 = '1111';
        controller.contact.Detail__c = '問い合わせ内容';
        controller.isAgree = false;
        controller.confirm();
        // 確認
        controller.contact.CompanyName__c = 'テスト会社';
        controller.contact.ContactName__c = 'テストユーザ';
        controller.contact.Email__c = 'test@test.com';
        controller.phone1 = '03';
        controller.phone2 = '1111';
        controller.phone3 = '1111';
        controller.contact.Detail__c = '問い合わせ内容';
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