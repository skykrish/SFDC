/**
 * AnkenRegisterControllerクラス用テストクラス
 */
@isTest
private class TestAnkenRegisterController {

    static testMethod void myUnitTest1() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAcc.Id);
        ApexPages.currentPage().getParameters().put('cid', testCon.Id);
        ApexPages.currentPage().getParameters().put('retUrl', '/' + testAcc.Id);

        // 案件登録
        AnkenRegisterController controller = new AnkenRegisterController();
        // 初期化処理
        controller.init();
		// 保存
		controller.save();

        // テスト終了
        Test.stopTest();

    }

    static testMethod void myUnitTest2() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAcc.Id);
        ApexPages.currentPage().getParameters().put('cid', testCon.Id);
        ApexPages.currentPage().getParameters().put('retUrl', '/' + testAcc.Id);

        // 案件登録
        AnkenRegisterController controller = new AnkenRegisterController();
        // 初期化処理
        controller.init();
		// 保存&新規
		controller.saveNew();

        // テスト終了
        Test.stopTest();

    }

    static testMethod void myUnitTest3() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAcc.Id);
        ApexPages.currentPage().getParameters().put('cid', testCon.Id);
        ApexPages.currentPage().getParameters().put('retUrl', '/' + testAcc.Id);

        // 案件登録
        AnkenRegisterController controller = new AnkenRegisterController();
        // 初期化処理
        controller.init();
		// キャンセル
		controller.cancel();

        // テスト終了
        Test.stopTest();
    }
}