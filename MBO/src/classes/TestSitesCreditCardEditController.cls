/**
 * SitesCreditCardEditControllerクラス用のテストクラス
 */
@isTest
private class TestSitesCreditCardEditController {
    
    /* 正常系 */
    // 項目に記入後、確認押下、送信した場合
    static testMethod void myUnitTest01_01() {
        
        // テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // 確認
        controller.confirm();
        
        // 送信
        controller.send();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    // 項目に記入後、確認押下、戻るを押下した場合
    static testMethod void myUnitTest01_02() {
        
        // テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // 確認
        controller.confirm();
        
        // 戻る
        controller.back();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 元々入力されていた項目を削除して、確認押下、送信した場合
    static testMethod void myUnitTest01_03() {
        
        // テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // カード会社項目削除
        controller.kokyaku.CardCompany = null;
        
        // カード番号項目削除
        controller.kokyaku.CardNo1 = null;
        controller.kokyaku.CardNo2 = null;
        controller.kokyaku.CardNo3 = null;
        controller.kokyaku.CardNo4 = null;
        
        // カード有効期限項目削除
        controller.kokyaku.CardLimitMM = null;
        controller.kokyaku.CardLimitYY = null;
        
        // カード名義項目削除
        controller.kokyaku.CardOwner = null;
        
        // 確認
        controller.confirm();
        
        // 送信
        controller.send();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    // ページ遷移
    // 発注フォームへ遷移
    static testMethod void myUnitTest02_01() {
        
        // テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 発注フォームへ遷移
        controller.order();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    /* 異常系 */
    // カード会社が指定されていない場合
    static testMethod void errorTest01_01() {
    	
    	// テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // カード会社項目削除
        controller.kokyaku.CardCompany = null;
        
        // 確認
        controller.confirm();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    // カード番号が入力されていない場合
    static testMethod void errorTest01_02() {
    	
    	// テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // カード番号１項目削除
        controller.kokyaku.CardNo1 = null;
        
        // 確認
        controller.confirm();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    // カード番号の桁数が正しくない場合
    static testMethod void errorTest01_03() {
    	
    	// テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // カード番号１項目変更
        controller.kokyaku.CardNo1 = '12';
        
        // カード番号２項目変更
        controller.kokyaku.CardNo2 = '12';
        
        // 確認
        controller.confirm();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    // カードの有効期限が入力されていない場合
    static testMethod void errorTest01_04() {
    	
    	// テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // カード有効期限月項目削除
        controller.kokyaku.CardLimitMM = null;
        
        // 確認
        controller.confirm();
        
        // テスト終了
        Test.stopTest();
    	
    
    }
    
    // カードの有効期限の形式が正しくない場合
    static testMethod void errorTest01_05() {
    	
    	// テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // カード有効期限月項目変更
        controller.kokyaku.CardLimitMM = '13';
        
        // 確認
        controller.confirm();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    // カード名義が入力されていない場合
    static testMethod void errorTest01_06() {
    	
    	// テストデータ作成
        Account testAcc = createTestDate();
        
        // テスト開始
        Test.startTest();
        
        // Sitesクレジットカード情報変更
        SitesCreditCardEditController controller = new SitesCreditCardEditController();
        
        // Cookie登録
        controller.createCookie(testAcc.Id);
        
        // 初期表示
        controller.init();
        
        // カード名義項目削除
        controller.kokyaku.CardOwner = null;
        
        // 確認
        controller.confirm();
        
        // テスト終了
        Test.stopTest();
    
    }
    
    /** テストデータ作成
     *  @return Account（顧客)
    **/
    static Account createTestDate(){
        Account testAcc = new Account(Name = 'testName',
                                      CardCompany__c = 'VISA',
                                      CardCompanySub1__c = 'VISA',
                                      CardCompanySub2__c = 'VISA',
                                      CardNo__c = '1234567890123456',
                                      CardNoSub1__c = '1234567890123456',
                                      CardNoSub2__c = '1234567890123456',
                                      CardOwner__c = 'testName',
                                      CardOwnerSub1__c = 'testName',
                                      CardOwnerSub2__c = 'testName',
                                      CardLimit__c = '11/11',
                                      CardLimitSub1__c = '11/11',
                                      CardLimitSub2__c = '11/11');
        insert testAcc;
        
        return testAcc;
    }
}