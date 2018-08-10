/**
 * SitesRegisterControllerクラス用テストクラス
 */
@isTest
private class TestSitesRegisterController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // Sites会員登録
        SitesRegisterController controller = new SitesRegisterController();
        controller.init();
        
        // ユーザID利用可能チェック：入力なし
        controller.kokyaku.kokyakuId = null;
        controller.checkKokyakuId();
        // ユーザID利用可能チェック：桁数チェック
        controller.kokyaku.kokyakuId = 'abc';
        controller.checkKokyakuId();
        // ユーザID利用可能チェック：形式チェック
        controller.kokyaku.kokyakuId = '!abc';
        controller.checkKokyakuId();
        // ユーザID利用可能チェック：使用不可チェック1
        controller.kokyaku.kokyakuId = System.Label.SitesTrialUser;
        controller.checkKokyakuId();
        // ユーザID利用可能チェック：使用不可チェック2
        controller.kokyaku.kokyakuId = System.Label.SitesMitsumoriUser;
        controller.checkKokyakuId();
        // ユーザID利用可能チェック：使用済みチェック
        controller.kokyaku.kokyakuId = 'testcode';
        controller.checkKokyakuId();
        // ユーザID利用可能チェック：チェックOK
        controller.kokyaku.kokyakuId = 'newtestcode';
        controller.checkKokyakuId();

        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest2() {

        // テスト開始
        Test.startTest();

        // Sites会員登録
        SitesRegisterController controller = new SitesRegisterController();
        controller.init();
        
        //キャンペーンソース
        controller.kokyaku.Source01 = true;
        controller.kokyaku.Source02 = false;
        controller.kokyaku.Source03 = false;
		controller.kokyaku.Source04 = false;
		controller.kokyaku.Source05 = false;
		controller.kokyaku.Source06 = false;
		controller.kokyaku.Source07 = false;
		controller.kokyaku.Source08 = false;
		controller.kokyaku.Source09 = false;
		controller.kokyaku.Source10 = false;
		controller.kokyaku.Source11 = false;
		controller.kokyaku.Source12 = false;
		controller.kokyaku.Source13 = false;
		controller.kokyaku.Source14 = false;
		controller.kokyaku.Source15 = false;
		controller.kokyaku.Source16 = false;
		controller.kokyaku.Source17 = false;
		controller.kokyaku.Source18 = false;
		controller.kokyaku.Source19 = false;
		controller.kokyaku.Source20 = false;
		controller.kokyaku.otherDetail = '';

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
        // ユーザID：必須チェック
        controller.kokyaku.kokyakuId = null;
        controller.confirm();
        // ユーザID：桁数チェック
        controller.kokyaku.kokyakuId = 'abc';
        controller.confirm();
        // ユーザID：形式チェック
        controller.kokyaku.kokyakuId = '!abc';
        controller.confirm();
        // ユーザID：使用不可チェック1
        controller.kokyaku.kokyakuId = System.Label.SitesTrialUser;
        controller.confirm();
        // ユーザID：使用不可チェック2
        controller.kokyaku.kokyakuId = System.Label.SitesMitsumoriUser;
        controller.confirm();
        // ユーザID：使用済みチェック
        controller.kokyaku.kokyakuId = 'testcode';
        controller.confirm();
        // パスワード：必須チェック
        controller.kokyaku.kokyakuPw = null;
        controller.confirm();
        // パスワード：桁数チェック
        controller.kokyaku.kokyakuPw = 'abc';
        controller.confirm();
        // パスワード：形式チェック
        controller.kokyaku.kokyakuPw = '!abc';
        controller.confirm();
        // パスワード：パスワード再入力チェック
        controller.kokyaku.kokyakuPw = 'password';
        controller.kokyaku.kokyakuPwConfirm = 'password-wrong';
        controller.confirm();
        // PC環境：必須チェック
        controller.kokyaku.Pc = null;
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
        // 支払い方法：必須チェック
        controller.kokyaku.PaymentSeikyusyo = false;
        controller.kokyaku.PaymentCredit = false;
        controller.confirm();
        // 請求書払い／締日：必須チェック
        // 請求書払い／支払いサイクル：必須チェック
        // 請求書払い／支払い日：必須チェック
        controller.kokyaku.PaymentSeikyusyo = true;
        controller.kokyaku.PaymentCredit = false;
        controller.kokyaku.ShimeGroup = null;
        controller.kokyaku.KaisyuCycle = null;
        controller.kokyaku.KaisyuDate = null;
        controller.confirm();
        // クレジット払い／カード会社：必須チェック
        // クレジット払い／カード番号：必須チェック
        // クレジット払い／カード有効期限：必須チェック
        // クレジット払い／カード名義人：必須チェック
        controller.kokyaku.PaymentSeikyusyo = false;
        controller.kokyaku.PaymentCredit = true;
        controller.kokyaku.CardCompany = null;
        controller.kokyaku.CardNo1 = null;
        controller.kokyaku.CardNo2 = null;
        controller.kokyaku.CardNo3= null;
        controller.kokyaku.CardNo4 = null;
        controller.kokyaku.CardLimitMM = null;
        controller.kokyaku.CardLimitYY = null;
        controller.kokyaku.CardOwner = null;
        controller.confirm();
        // クレジット払い／カード番号：形式チェック
        controller.kokyaku.CardNo1 = '0000';
        controller.kokyaku.CardNo2 = '0000';
        controller.kokyaku.CardNo3= '0000';
        controller.kokyaku.CardNo4 = '0000';
        controller.confirm();
        // クレジット払い／カード有効期限：形式チェック
        controller.kokyaku.CardLimitMM = '13';
        controller.kokyaku.CardLimitYY = '11';
        controller.confirm();
        // プライバシーポリシー、利用規約チェック：必須チェック
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
        controller.kokyaku.kokyakuId = 'testuser';
        controller.kokyaku.kokyakuPw = 'password';
        controller.kokyaku.kokyakuPwConfirm = 'password';
        controller.kokyaku.Pc = 'Windows';
        controller.tantosyaList[0].TantosyaName = 'テスト担当';
        controller.tantosyaList[0].Department = 'テスト部署';
        controller.tantosyaList[0].Title = 'テスト役職';
        controller.tantosyaList[0].Email = 'test@test.com';
        controller.tantosyaList[0].SeikyuTantoFlg = true;
        controller.kokyaku.PaymentSeikyusyo = true;
        controller.kokyaku.PaymentCredit = false;
        controller.kokyaku.PaymentSeikyusyo = true;
        controller.kokyaku.PaymentCredit = false;
        controller.kokyaku.ShimeGroup = '末日';
        controller.kokyaku.KaisyuCycle = '翌月';
        controller.kokyaku.KaisyuDate = '末日';
        controller.isAgree = false; 
              
        controller.confirm();

        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest3() {

        // テスト開始
        Test.startTest();

        // Sites会員登録
        SitesRegisterController controller = new SitesRegisterController();
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
        controller.kokyaku.kokyakuId = 'testuser';
        controller.kokyaku.kokyakuPw = 'password';
        controller.kokyaku.kokyakuPwConfirm = 'password';
        controller.kokyaku.Pc = 'Windows';
        controller.tantosyaList[0].TantosyaName = 'テスト担当';
        controller.tantosyaList[0].Department = 'テスト部署';
        controller.tantosyaList[0].Title = 'テスト役職';
        controller.tantosyaList[0].Email = 'test@test.com';
        controller.tantosyaList[0].SeikyuTantoFlg = true;
        controller.kokyaku.PaymentSeikyusyo = true;
        controller.kokyaku.PaymentCredit = false;
        controller.kokyaku.ShimeGroup = '末日';
        controller.kokyaku.KaisyuCycle = '翌月';
        controller.kokyaku.KaisyuDate = '末日';
        controller.isAgree = true;
        controller.kokyaku.Source01 = true;
        controller.kokyaku.Source02 = false;
        controller.kokyaku.Source03 = false;
		controller.kokyaku.Source04 = false;
		controller.kokyaku.Source05 = false;
		controller.kokyaku.Source06 = false;
		controller.kokyaku.Source07 = false;
		controller.kokyaku.Source08 = false;
		controller.kokyaku.Source09 = false;
		controller.kokyaku.Source10 = false;
		controller.kokyaku.Source11 = false;
		controller.kokyaku.Source12 = false;
		controller.kokyaku.Source13 = false;
		controller.kokyaku.Source14 = false;
		controller.kokyaku.Source15 = false;
		controller.kokyaku.Source16 = false;
		controller.kokyaku.Source17 = false;
		controller.kokyaku.Source18 = false;
		controller.kokyaku.Source19 = false;
		controller.kokyaku.Source20 = false;
		controller.kokyaku.otherDetail = '';

        controller.confirm();

        // 戻る
        controller.back();

        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest4() {

        // テスト開始
        Test.startTest();

        // Sites会員登録
        SitesRegisterController controller = new SitesRegisterController();
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
        controller.kokyaku.kokyakuId = 'testuser';
        controller.kokyaku.kokyakuPw = 'password';
        controller.kokyaku.kokyakuPwConfirm = 'password';
        controller.kokyaku.Pc = 'Windows';
        controller.tantosyaList[0].TantosyaName = 'テスト担当';
        controller.tantosyaList[0].Department = 'テスト部署';
        controller.tantosyaList[0].Title = 'テスト役職';
        controller.tantosyaList[0].Email = 'test@test.com';
        controller.tantosyaList[0].SeikyuTantoFlg = true;
        controller.kokyaku.PaymentSeikyusyo = false;
        controller.kokyaku.PaymentCredit = true;
        controller.kokyaku.CardCompany = 'VISA';
        controller.kokyaku.CardNo1 = '4000';
        controller.kokyaku.CardNo2 = '1234';
        controller.kokyaku.CardNo3= '5678';
        controller.kokyaku.CardNo4 = '9012';
        controller.kokyaku.CardLimitMM = '12';
        controller.kokyaku.CardLimitYY = '2012';
        controller.kokyaku.CardOwner = 'テストコキャク';
        controller.isAgree = true;
        controller.kokyaku.Source01 = true;
        controller.kokyaku.Source02 = false;
        controller.kokyaku.Source03 = false;
		controller.kokyaku.Source04 = false;
		controller.kokyaku.Source05 = false;
		controller.kokyaku.Source06 = false;
		controller.kokyaku.Source07 = false;
		controller.kokyaku.Source08 = false;
		controller.kokyaku.Source09 = false;
		controller.kokyaku.Source10 = false;
		controller.kokyaku.Source11 = false;
		controller.kokyaku.Source12 = false;
		controller.kokyaku.Source13 = false;
		controller.kokyaku.Source14 = false;
		controller.kokyaku.Source15 = false;
		controller.kokyaku.Source16 = false;
		controller.kokyaku.Source17 = false;
		controller.kokyaku.Source18 = false;
		controller.kokyaku.Source19 = false;
		controller.kokyaku.Source20 = false;
		controller.kokyaku.otherDetail = '';
        controller.confirm();

        // 戻る
        controller.back();

        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void myUnitTest5() {

        // テスト開始
        Test.startTest();

        // Sites会員登録
        SitesRegisterController controller = new SitesRegisterController();
        controller.init();    
    
        // 確認
        // キャンペーンソース：必須チェック
        controller.kokyaku.Source01 = false;
	    controller.kokyaku.Source02 = false;
	    controller.kokyaku.Source03 = false;
	    controller.kokyaku.Source04 = false;
	    controller.kokyaku.Source05 = false;
	    controller.kokyaku.Source06 = false;
	    controller.kokyaku.Source07 = false;
	    controller.kokyaku.Source08 = false;
	    controller.kokyaku.Source09 = false;
	    controller.kokyaku.Source10 = false;
	    controller.kokyaku.Source11 = false;
	    controller.kokyaku.Source12 = false;
	    controller.kokyaku.Source13 = false;
	    controller.kokyaku.Source14 = false;
	    controller.kokyaku.Source15 = false;
	    controller.kokyaku.Source16 = false;
	    controller.kokyaku.Source17 = false;
	    controller.kokyaku.Source18 = false;
	    controller.kokyaku.Source19 = false;
	    controller.kokyaku.Source20 = false;
        controller.confirm();
        
        //キャンペーンソース：「その他」選択時のチェック
 	    controller.kokyaku.Source20 = true;
 	    controller.kokyaku.otherDetail = '';       
 	    controller.confirm();
        
        // テスト終了
        Test.stopTest();
    }  
}