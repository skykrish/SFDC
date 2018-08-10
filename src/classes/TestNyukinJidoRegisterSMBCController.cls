/**
 * NyukinJidoRegisterSMBCControllerクラス用テストクラス
 */
@isTest
private class TestNyukinJidoRegisterSMBCController {

    /**
     * 正常系
     */
    static testMethod void myUnitTest01() {
        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name = 'Test1', FurikomiShitenCd_SMBC__c = '111', FurikomiShitenName_SMBC__c = 'テスト支店1', FurikomiKozaNo_SMBC__c = '1111111'),
            new Account(Name = 'Test2', FurikomiShitenCd_SMBC__c = '222', FurikomiShitenName_SMBC__c = 'テスト支店2', FurikomiKozaNo_SMBC__c = '2222222'),
            new Account(Name = 'Test3', FurikomiShitenCd_SMBC__c = '333', FurikomiShitenName_SMBC__c = 'テスト支店2', FurikomiKozaNo_SMBC__c = '3333333')
        };
        insert testAcc;
        
        // テスト用案件データ
        Anken__c[] testAnken = new Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
        };
        insert testAnken;

        // テスト用請求ヘッダデータ作成
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
            new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = new Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id)
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0)
        };
        insert testSeikyuMeisai;


        // テスト用ドキュメントデータ作成
        StaticResource staticResource = [SELECT Id,Name,Body FROM StaticResource WHERE Name = 'TestNyukin_SMBC' LIMIT 1];
        Document document = new Document(Body = staticResource.Body);

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterSMBCController controller = new NyukinJidoRegisterSMBCController(sController);
        controller.check();
        controller.register();

        // テスト終了
        Test.stopTest();
        
        system.assertEquals(3, controller.getNyukinList().size());
        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());
    }
    /**
     * 異常系（ファイル未選択）
     */
    static testMethod void myUnitTest02() {
        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = null);

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterSMBCController controller = new NyukinJidoRegisterSMBCController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();
    }
    /**
     * 異常系（データ行無し）
     */
    static testMethod void myUnitTest03() {
        // テスト用ドキュメントデータ作成
        StaticResource staticResource = [SELECT Id,Name,Body FROM StaticResource WHERE Name = 'TestNyukin_SMBC_Err02' LIMIT 1];
        Document document = new Document(Body = staticResource.Body);

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterSMBCController controller = new NyukinJidoRegisterSMBCController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();
    }
    /**
     * 異常系（上限超過）
     */
    static testMethod void myUnitTest04() {
        // テスト用ドキュメントデータ作成
        StaticResource staticResource = [SELECT Id,Name,Body FROM StaticResource WHERE Name = 'TestNyukin_SMBC_Err04' LIMIT 1];
        Document document = new Document(Body = staticResource.Body);

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterSMBCController controller = new NyukinJidoRegisterSMBCController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();
    }
    /**
     * 異常系（項目エラーその１）
     */
    static testMethod void myUnitTest05() {
        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name = 'Test1', FurikomiShitenCd_SMBC__c = '111', FurikomiShitenName_SMBC__c = 'テスト支店1', FurikomiKozaNo_SMBC__c = '1111111'),
            new Account(Name = 'Test2', FurikomiShitenCd_SMBC__c = '222', FurikomiShitenName_SMBC__c = 'テスト支店2', FurikomiKozaNo_SMBC__c = '2222222'),
            new Account(Name = 'Test3', FurikomiShitenCd_SMBC__c = '333', FurikomiShitenName_SMBC__c = 'テスト支店2', FurikomiKozaNo_SMBC__c = '3333333')
        };
        insert testAcc;
        
        // テスト用案件データ
        Anken__c[] testAnken = new Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
        };
        insert testAnken;

        // テスト用請求ヘッダデータ作成
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
            new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = new Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id)
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0)
        };
        insert testSeikyuMeisai;


        // テスト用ドキュメントデータ作成
        StaticResource staticResource = [SELECT Id,Name,Body FROM StaticResource WHERE Name = 'TestNyukin_SMBC_Err01' LIMIT 1];
        Document document = new Document(Body = staticResource.Body);

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterSMBCController controller = new NyukinJidoRegisterSMBCController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();
    }
    /**
     * 異常系（項目エラーその２）
     */
    static testMethod void myUnitTest06() {
        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name = 'Test1', FurikomiShitenCd_SMBC__c = '111', FurikomiShitenName_SMBC__c = 'テスト支店1', FurikomiKozaNo_SMBC__c = '1111111'),
            new Account(Name = 'Test2', FurikomiShitenCd_SMBC__c = '222', FurikomiShitenName_SMBC__c = 'テスト支店2', FurikomiKozaNo_SMBC__c = '2222222'),
            new Account(Name = 'Test3', FurikomiShitenCd_SMBC__c = '333', FurikomiShitenName_SMBC__c = 'テスト支店2', FurikomiKozaNo_SMBC__c = '3333333')
        };
        insert testAcc;
        
        // テスト用案件データ
        Anken__c[] testAnken = new Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
        };
        insert testAnken;

        // テスト用請求ヘッダデータ作成
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
            new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = new Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id)
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0)
        };
        insert testSeikyuMeisai;


        // テスト用ドキュメントデータ作成
        StaticResource staticResource = [SELECT Id,Name,Body FROM StaticResource WHERE Name = 'TestNyukin_SMBC_Err03' LIMIT 1];
        Document document = new Document(Body = staticResource.Body);

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterSMBCController controller = new NyukinJidoRegisterSMBCController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();
    }
}