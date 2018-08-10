/**
 * SendNohinsyoAddURLControllerクラス用のテストクラス
 */
@isTest
private class TestSendNohinsyoAddURLController {
    
    // 正常系
    
    // 案件詳細から納品書送付を実行
    // 既存の納品書が存在しない場合
    static testMethod void myUnitTest01_01() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 1);
        
        // テスト開始
        Test.startTest();
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController();
        
        // 初期表示チェック
        controller.initCheck();
        
        // 納品書送付処理
        controller.sendPdf();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 既存の納品書が存在する場合
    static testMethod void myUnitTest01_02() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 1);
        
        // テスト開始
        Test.startTest();
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController();
        
        // 初期表示チェック
        controller.initCheck();
        
        // 納品書送付処理
        controller.sendPdf();
        
        // もう一度納品書送付を実行
        controller.sendPdf();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 即時送信フラグがfalseの場合
    static testMethod void myUnitTest01_03() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 1);
        
        // 即時送信フラグをfalseに更新
        testAnken[0].SendImmediateFlag__c = false;
        update testAnken;
        
        // テスト開始
        Test.startTest();
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController();
        
        // 初期表示チェック
        controller.initCheck();
        
        // 納品書送付処理
        controller.sendPdf();
        
        // テスト終了
        Test.stopTest();
    }
    
    
    // リストビューから納品書送付を実行
    // 2件の案件を選択して実行した場合
    static testMethod void myUnitTest02() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 2);
        
        // テスト開始
        Test.startTest();
        
        // リクエストパラメータ設定
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController(ssc);
        
        // 一括時の初期表示チェック
        controller.initCheckAll();
        
        // 納品書送付処理
        controller.sendPdf();
        
        // 一括用キャンセル実行
        controller.cancel();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 案件データ更新
    static testMethod void myUnitTest03() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 1);
        
        // テスト開始
        Test.startTest();
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController();
        controller.updateAnkenData();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 異常系
    
    // 案件詳細から納品書送付を実行
    // 案件が請求確定済みの場合
    static testMethod void errorTest01_01() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 1);
        
        // 案件を請求確定済みに更新
        testAnken[0].StatusLock__c = true;
        update testAnken;
        
        // テスト開始
        Test.startTest();
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController();
        
        // 初期表示チェック
        controller.initCheck();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 顧客担当者（主）が設定されていない場合
    static testMethod void errorTest01_02() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 1);
        
        // 案件の担当者を削除して更新
        testAnken[0].KokyakuTantosya_Main__c = null;
        update testAnken;
        
        // テスト開始
        Test.startTest();
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController();
        
        // 初期表示チェック
        controller.initCheck();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 顧客担当者（主）のメールアドレスが設定されていない場合
    static testMethod void errorTest01_03() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', null, 1);
        
        // テスト開始
        Test.startTest();
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController();
        
        // 初期表示チェック
        controller.initCheck();
        
        // テスト終了
        Test.stopTest();
    }
    
    // リストビューから納品書送付を実行した場合
    // 案件を選択せずに実行
    static testMethod void errorTest02_01() {
        
        // テストデータ作成
        List<Anken__c> testAnken = new List<Anken__c>();
        
        // テスト開始
        Test.startTest();
        
        // リクエストパラメータ設定
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController(ssc);
        
        // 一括時の初期表示チェック
        controller.initCheckAll();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 納品書一括送信の上限以上の案件を選択した場合
    static testMethod void errorTest02_02() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 30);
        
        // テスト開始
        Test.startTest();
        
        // リクエストパラメータ設定
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController(ssc);
        
        // 一括時の初期表示チェック
        controller.initCheckAll();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 合計金額が０円の案件を選択して実行した場合
    static testMethod void errorTest02_03() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 2);
        
        // テスト開始
        Test.startTest();
        
        // リクエストパラメータ設定
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController(ssc);
        
        // 一括時の初期表示チェック
        controller.initCheckAll();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 顧客担当者（主）が設定されていない案件を選択して実行した場合
    static testMethod void errorTest02_04() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', 'test123@test.co.jp', 1);
        
        // 案件の担当者を削除して更新
        testAnken[0].KokyakuTantosya_Main__c = null;
        update testAnken;
        
        // テスト開始
        Test.startTest();
        
        // リクエストパラメータ設定
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController(ssc);
        
        // 一括時の初期表示チェック
        controller.initCheckAll();
        
        // テスト終了
        Test.stopTest();
    }
    
    // 顧客担当者（主）のメールアドレスが設定されていない案件を選択して実行した場合
    static testMethod void errorTest02_05() {
        
        // テストデータ作成
        Anken__c[] testAnken = createTestDate('testUser20151112@test.co.jp', null, 1);
        
        // テスト開始
        Test.startTest();
        
        // リクエストパラメータ設定
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        
        // 納品書：初期化処理
        SendNohinsyoAddURLController controller = new SendNohinsyoAddURLController(ssc);
        
        // 一括時の初期表示チェック
        controller.initCheckAll();
        
        // テスト終了
        Test.stopTest();
    }
    
    /** テストデータ作成
     *  @param email（顧客担当者のEmailアドレス）
     *  @param userName(ユーザー名)
     *  @oaram value(案件の登録数)
    **/
    static Anken__c[] createTestDate(String userName, String email, Integer value){
        
        // テスト用顧客データ作成
        Account testAcc = new Account(Name = 'Test', IchiritsuKakakuKokyakuFkg__c=true);
        insert testAcc;
        
        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName = 'Test', AccountId = testAcc.Id, Email = email);
        insert testCon;
        
        // 委託先プロファイル取得
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Permanent Employees (Japan)' LIMIT 1];
        
        // テスト用ユーザ作成
        User user = new User(UserName = userName, LastName = 'test1', Alias = '1', Email = userName, TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', ProfileId = prof.Id, LanguageLocaleKey = 'ja', EmailEncodingKey = 'UTF-8');
        insert user;
        
        // テスト用案件データ作成
        Anken__c[] testAnken = new Anken__c[value];
        for(Integer i = 0; i < value; i++){
            testAnken[i] = new Anken__c(KokyakuName__c = testAcc.Id, KokyakuTantosya_Main__c = testCon.Id, KokyakuTantosya_CC1__c = testCon.Id, KokyakuTantosya_CC2__c = testCon.Id, KokyakuTantosya_CC3__c = testCon.Id, KokyakuTantosya_CC4__c = testCon.Id, SendImmediateFlag__c=true, firestorage__c=true);
        }
        insert testAnken;
        
        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;
        
        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;
        
        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken[0].Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);
        
        return testAnken;
    }
}