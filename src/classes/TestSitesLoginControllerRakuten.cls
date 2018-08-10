/**
 * SitesLoginControllerRakutenクラス用テストクラス
 */
@isTest
private class TestSitesLoginControllerRakuten {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // Sitesログイン
        SitesLoginControllerRakuten controller = new SitesLoginControllerRakuten();
        // 初期化処理
        controller.init();
        // ログインNG
        controller.userId = 'testuser';
        controller.password = 'wrongpassword';
        controller.isAutoset = false;
        // 入力チェック
        controller.login();
        
        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest1() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // Sitesログイン
        SitesLoginControllerRakuten controller = new SitesLoginControllerRakuten();
        // 初期化処理
        controller.init();
        // ログインOK
        controller.userId = 'testuser';
        controller.password = 'password';
        controller.isAutoset = false;
        controller.login();
        
        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest2() {

        // テスト開始
        Test.startTest();

        // Sitesログイン
        SitesLoginControllerRakuten controller = new SitesLoginControllerRakuten();
        // 初期化処理
        controller.init();
        // 遷移：パスワードリマインド
        controller.forget();

        // テスト終了
        Test.stopTest();
    }

    // ログインページへ遷移ボタンテスト
    static testMethod void myUnitTest3() {

        // テスト開始
        Test.startTest();

        // Sitesログイン
        SitesLoginControllerRakuten controller = new SitesLoginControllerRakuten();
        // 初期化処理
        controller.init();
        // 遷移：ログインページ
        controller.back();

        // テスト終了
        Test.stopTest();
    }

    /** SitesAbstructControllerのテスト */
    static testMethod void myUnitTest4() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // Sitesログイン
        SitesLoginControllerRakuten controller = new SitesLoginControllerRakuten();
        // 初期化処理
        controller.init();
        // ログインOK
        controller.userId = 'testuser';
        controller.password = 'password';
        controller.isAutoset = false;
        controller.login();
        // リストオプション取得：都道府県
        List<SelectOption> list1 = controller.getPrefSelectOptions();
        // リストオプション取得：PC環境
        List<SelectOption> list2 = controller.getPcSelectOptions();
        // リストオプション取得：締日（締めグループ）
        List<SelectOption> list3 = controller.getShimeGroupSelectOptions();
        // リストオプション取得：支払サイクル
        List<SelectOption> list4 = controller.getKaisyuCycleSelectOptions();
        // リストオプション取得：支払日
        List<SelectOption> list5 = controller.getKaisyuDateSelectOptions();
        // リストオプション取得：カード会社
        List<SelectOption> list6 = controller.getCardCompanySelectOptions();
        // リストオプション取得：年
        List<SelectOption> list7 = controller.getMonthOptions();
        // リストオプション取得：日
        List<SelectOption> list8 = controller.getYearOptions();
        // マイページ
        controller.mypage();
        // ログアウト
        controller.logout();
        
        // テスト終了
        Test.stopTest();
    }
}