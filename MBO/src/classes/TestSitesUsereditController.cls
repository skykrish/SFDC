/**
 * SitesUsereditControllerクラス用テストクラス
 */
@isTest
private class TestSitesUsereditController {

    static testMethod void myUnitTest() {

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='不要');
        insert testAcc;

        // テスト用担当者データ作成
        List<Contact> testCon = new List<Contact> {
        	new Contact(LastName='Test1', AccountId = testAcc.Id, Email = 'test1@test.com'),
        	new Contact(LastName='Test2', AccountId = testAcc.Id, Email = 'test2@test.com')
        };
        insert testCon;

        // テスト開始
        Test.startTest();

        // Sitesお客様情報変更
        SitesUsereditController controller = new SitesUsereditController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        
        // 確認
        // 会社名：必須チェック
        controller.kokyaku.KokyakuName = null;
        controller.confirm();
        // 会社名（全角カナ）：必須チェック
        controller.kokyaku.KokyakuNameKana = null;
        controller.confirm();
        // 会社名（全角カナ）：形式チェック
        controller.kokyaku.KokyakuNameKana = 'ﾃｽﾄ';
        controller.confirm();
        // 郵便番号：必須チェック
        controller.kokyaku.PostalCode1 = null;
        controller.kokyaku.PostalCode2 = null;
        controller.confirm();
        // 郵便番号：形式チェック
        controller.kokyaku.PostalCode1 = 'aaaa';
        controller.kokyaku.PostalCode2 = 'bbb';
        controller.confirm();
        // 住所：必須チェック
        controller.kokyaku.State = null;
        controller.kokyaku.City = null;
        controller.kokyaku.Street1 = null;
        controller.kokyaku.Street2 = null;
        controller.confirm();
        // 電話番号：必須チェック
        controller.kokyaku.Phone1 = null;
        controller.kokyaku.Phone2 = null;
        controller.kokyaku.Phone3 = null;
        controller.confirm();
        // 電話番号：形式チェック
        controller.kokyaku.Phone1 = 'aaa';
        controller.kokyaku.Phone2 = 'bbbb';
        controller.kokyaku.Phone3 = 'cccc';
        controller.confirm();
        // FAX番号：必須チェック
        controller.kokyaku.Fax1 = null;
        controller.kokyaku.Fax2 = null;
        controller.kokyaku.Fax3 = null;
        controller.confirm();
        // FAX番号：形式チェック
        controller.kokyaku.Fax1 = 'aaa';
        controller.kokyaku.Fax2 = 'bbbb';
        controller.kokyaku.Fax3 = 'cccc';
        controller.confirm();
        // 担当者：必須チェック
        controller.confirm();
        // 担当者／名前：必須チェック
        // 担当者／メールアドレス：必須チェック
        controller.tantosyaList[0].Department = '部署';
        controller.confirm();
        // 担当者／メールアドレス：形式チェック
        controller.tantosyaList[0].Email = 'mail';
        controller.confirm();
        // 担当者／請求担当フラグ：必須チェック
        controller.tantosyaList[0].TantosyaName = 'なまえ';
        controller.tantosyaList[0].Email = 'test@test.com';
        controller.tantosyaList[0].SeikyuTantoFlg = false;
        controller.confirm();

        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest2() {

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='不要');
        insert testAcc;

        // テスト用担当者データ作成
        List<Contact> testCon = new List<Contact> {
        	new Contact(LastName='Test1', AccountId = testAcc.Id, Email = 'test1@test.com'),
        	new Contact(LastName='Test2', AccountId = testAcc.Id, Email = 'test2@test.com')
        };
        insert testCon;

        // テスト開始
        Test.startTest();

        // Sitesお客様情報変更
        SitesUsereditController controller = new SitesUsereditController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        
        // 担当者追加
        controller.addTantosya();

        // 確認
        controller.kokyaku.KokyakuName = 'テスト顧客';
        controller.kokyaku.KokyakuNameKana = 'テストコキャク';
        controller.kokyaku.PostalCode1 = '111';
        controller.kokyaku.PostalCode2 = '1111';
        controller.kokyaku.State = '東京都';
        controller.kokyaku.City = '千代田区';
        controller.kokyaku.Street1 = '１－１－１';
        controller.kokyaku.Street2 = '';
        controller.kokyaku.Phone1 = '03';
        controller.kokyaku.Phone2 = '1111';
        controller.kokyaku.Phone3 = '1111';
        controller.kokyaku.Fax1 = '03';
        controller.kokyaku.Fax2 = '2222';
        controller.kokyaku.Fax3 = '2222';
        // 確認：担当者（更新）
        controller.tantosyaList[0].TantosyaName = 'テスト担当1';
        controller.tantosyaList[0].Department = 'テスト部署1';
        controller.tantosyaList[0].Title = 'テスト役職1';
        controller.tantosyaList[0].Email = 'test1@test.com';
        controller.tantosyaList[0].SeikyuTantoFlg = true;
        // 確認：担当者（削除）
        controller.tantosyaList[1].TantosyaName = null;
        controller.tantosyaList[1].Department = null;
        controller.tantosyaList[1].Title = null;
        controller.tantosyaList[1].Email = null;
        controller.tantosyaList[1].SeikyuTantoFlg = false;
        // 確認：担当者（追加）
        controller.tantosyaList[2].TantosyaName = 'テスト担当3';
        controller.tantosyaList[2].Department = 'テスト部署3';
        controller.tantosyaList[2].Title = 'テスト役職3';
        controller.tantosyaList[2].Email = 'test3@test.com';
        controller.tantosyaList[2].SeikyuTantoFlg = false;
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