/**
 * SitesTrialControllerクラス用テストクラス
 */
@isTest
public with sharing class TestSitesTrialController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // Sitestトライアル
        SitesTrialController controller = new SitesTrialController();
        controller.init();

        // 確認
        // 会社名：必須チェック
        controller.customer.KokyakuName = null;
        controller.confirm();
        // 会社名（全角カナ）：必須チェック
        controller.customer.KokyakuNameKana = null;
        controller.confirm();
        // 会社名（全角カナ）：形式チェック
        controller.customer.KokyakuNameKana = 'ﾃｽﾄ';
        controller.confirm();
        // 郵便番号：必須チェック
        controller.customer.PostalCode1 = null;
        controller.customer.PostalCode2 = null;
        controller.confirm();
        // 郵便番号：形式チェック
        controller.customer.PostalCode1 = 'aaaa';
        controller.customer.PostalCode2 = 'bbb';
        controller.confirm();
        // 住所：必須チェック
        controller.customer.State = null;
        controller.customer.City = null;
        controller.customer.Street1 = null;
        controller.customer.Street2 = null;
        controller.confirm();
        // 電話番号：必須チェック
        controller.customer.Phone1 = null;
        controller.customer.Phone2 = null;
        controller.customer.Phone3 = null;
        controller.confirm();
        // 電話番号：形式チェック
        controller.customer.Phone1 = 'aaa';
        controller.customer.Phone2 = 'bbbb';
        controller.customer.Phone3 = 'cccc';
        controller.confirm();
        // メールアドレス：必須チェック
        controller.customer.Email = null;
        controller.confirm();
        // メールアドレス：形式チェック
        controller.customer.Email = 'mail';
        controller.confirm();
        // 担当者名：必須チェック
        controller.customer.TantosyaName = null;
        controller.confirm();
        // PC環境：必須チェック
        controller.customer.Pc = null;
        controller.confirm();

        // プライバシーポリシー、利用規約チェック：必須チェック
        // 確認
        controller.customer.KokyakuName = 'テスト会社';
        controller.customer.KokyakuNameKana = 'テストカイシャ';
        controller.customer.PostalCode1 = '100';
        controller.customer.PostalCode2 = '0001';
        controller.customer.State = '東京都';
        controller.customer.City = '千代田区';
        controller.customer.Street1 = '１－１－１';
        controller.customer.Street2 = '';
        controller.customer.Phone1 = '03';
        controller.customer.Phone2 = '1111';
        controller.customer.Phone3 = '1111';
        controller.customer.Email = 'test@test.com';
        controller.customer.TantosyaName = 'テスト担当者';
        controller.customer.Pc = 'Windows';
        controller.isAgree = false;
        controller.confirm();

        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest2() {

        // テスト開始
        Test.startTest();

        // Sitestトライアル
        SitesTrialController controller = new SitesTrialController();
        controller.init();
        
        // 確認
        controller.customer.KokyakuName = 'テスト会社';
        controller.customer.KokyakuNameKana = 'テストカイシャ';
        controller.customer.PostalCode1 = '100';
        controller.customer.PostalCode2 = '0001';
        controller.customer.State = '東京都';
        controller.customer.City = '千代田区';
        controller.customer.Street1 = '１－１－１';
        controller.customer.Street2 = '';
        controller.customer.Phone1 = '03';
        controller.customer.Phone2 = '1111';
        controller.customer.Phone3 = '1111';
        controller.customer.Email = 'test@test.com';
        controller.customer.TantosyaName = 'テスト担当者';
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