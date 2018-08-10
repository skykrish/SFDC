/**
 * SitesLoginControllerクラス用テストクラス
 */
@isTest
private class TestSitesLoginController {

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
        SitesLoginController controller = new SitesLoginController();
        // 初期化処理
        controller.init();
        // 入力チェック
        controller.login();
        // ログインNG
        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('userId', 'testuser');
        ApexPages.currentPage().getParameters().put('password', 'wrongpassword');
        ApexPages.currentPage().getParameters().put('isAutoset', 'false');
        controller.login();
        // ログインOK
        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('userId', 'testuser');
        ApexPages.currentPage().getParameters().put('password', 'password');
        ApexPages.currentPage().getParameters().put('isAutoset', 'true');
        controller.login();
        
        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest2() {

        // テスト開始
        Test.startTest();

        // Sitesログイン
        SitesLoginController controller = new SitesLoginController();
        // 初期化処理
        controller.init();
        // 遷移：パスワードリマインド
        controller.forget();

        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest3() {

        // テスト開始
        Test.startTest();

        // Sitesログイン
        SitesLoginController controller = new SitesLoginController();
        // 初期化処理
        controller.init();
        // 遷移：会員登録
        controller.register();

        // テスト終了
        Test.stopTest();
    }

    // ログインページへ遷移ボタンテスト
    static testMethod void myUnitTest4() {

        // テスト開始
        Test.startTest();

        // Sitesログイン
        SitesLoginController controller = new SitesLoginController();
        // 初期化処理
        controller.init();
        // 遷移：ログインページ
        controller.back();

        // テスト終了
        Test.stopTest();
    }

    /** SitesAbstructControllerのテスト */
    static testMethod void myUnitTest5() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // Sitesログイン
        SitesLoginController controller = new SitesLoginController();
        // 初期化処理
        controller.init();
        // ログインOK
        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('userId', 'testuser');
        ApexPages.currentPage().getParameters().put('password', 'password');
        ApexPages.currentPage().getParameters().put('isAutoset', 'true');
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