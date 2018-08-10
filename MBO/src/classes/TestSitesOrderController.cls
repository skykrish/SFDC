/**
 * SitesOrderControllerクラス用テストクラス
 */
@isTest
public with sharing class TestSitesOrderController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='見積り不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email = 'test@test.com');
        insert testCon;

        // Sites発注
        SitesOrderController controller = new SitesOrderController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        // 確認
        controller.tantosyaMain = testCon.Id;
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
    
    // FTPでアップロードする場合
    static testMethod void myUnitTest01() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='見積り不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email = 'test@test.com');
        insert testCon;

        // Sites発注
        SitesOrderController controller = new SitesOrderController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        
        // FTPでアップロードにチェック
        controller.upload = 'FTPでアップロード';
        
        // 確認
        controller.tantosyaMain = testCon.Id;
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
    
    // 納品方法がサーバーへのアップロードの場合
    static testMethod void myUnitTest02() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='見積り不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email = 'test@test.com');
        insert testCon;

        // Sites発注
        SitesOrderController controller = new SitesOrderController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        
        // サーバーへアップロードにチェック
        controller.nouhin = 'サーバーへのアップロード';
        
        // 確認
        controller.tantosyaMain = testCon.Id;
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
    
    // 納品方法がfirestorageでの納品を希望の場合
    static testMethod void myUnitTest03() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='見積り不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email = 'test@test.com');
        insert testCon;

        // Sites発注
        SitesOrderController controller = new SitesOrderController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        
        // firestorageでの納品を希望にチェック
        controller.nouhin = 'firestorageでの納品を希望';
        
        // 確認
        controller.tantosyaMain = testCon.Id;
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
    
    // PC環境が入力されている場合
    static testMethod void myUnitTest04() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='見積り不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email = 'test@test.com');
        insert testCon;

        // Sites発注
        SitesOrderController controller = new SitesOrderController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        
        // firestorageでの納品を希望にチェック
        controller.pc = 'Mac';
        
        // 確認
        controller.tantosyaMain = testCon.Id;
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
    
    // 発注のタイミング変更
    static testMethod void myUnitTest4() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='見積り不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email = 'test@test.com');
        insert testCon;

        // Sites発注
        SitesOrderController controller = new SitesOrderController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        // 発注タイミング設定
        controller.anken.Status__c = '見積受付';
        // 確認
        controller.tantosyaMain = testCon.Id;
        controller.confirm();
        // 戻る
        controller.back();
        // 送信
        controller.send();

        // テスト終了
        Test.stopTest();
    }
}