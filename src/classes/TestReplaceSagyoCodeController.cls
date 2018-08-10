/**
 * ReplaceSagyoCodeControllerクラス用テストクラス
 */
@isTest
private class TestReplaceSagyoCodeController {
    
    @testSetup static void dataSetUp() {
        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ1'),
            new Account(Name='Test2', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ2'),
            new Account(Name='Test3', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ3'),
            new Account(Name='Test4', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ4'),
            new Account(Name='Test5', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ5'),
            new Account(Name='Test6', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ6'),
            new Account(Name='Test7', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ7')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
            new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
            new Contact(LastName='Test3', AccountId=testAcc[2].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
            new Contact(LastName='Test4', AccountId=testAcc[3].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
            new Contact(LastName='Test5', AccountId=testAcc[4].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
            new Contact(LastName='Test6', AccountId=testAcc[5].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true)
        };
        insert testCon;

        // テスト用案件データ作成
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
            new Anken__c(KokyakuName__c=testAcc[2].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
            new Anken__c(KokyakuName__c=testAcc[3].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
            new Anken__c(KokyakuName__c=testAcc[4].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
            new Anken__c(KokyakuName__c=testAcc[5].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today())
        };
        insert testAnken;

        // テスト用作業データ作成
        List<Sagyo__c> testSagyo = new List<Sagyo__c>();
        for(Integer i=11; i < 46 ;i++){
            Sagyo__c sagyo = new Sagyo__c(Name='300655'+String.valueOf(i),Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999);
            testSagyo.add(sagyo);
        }
        insert testSagyo;


        // テスト用案件明細データ作成
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[1].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[2].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[3].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[4].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[5].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;
    }
    
    static testMethod void testReplace01() {
        
        ReplaceSagyoCodeController controller = new ReplaceSagyoCodeController();
        
        // テスト開始
        Test.startTest();
        
        controller.init();
        
        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void testReplace02() {
        
        ReplaceSagyoCodeController controller = new ReplaceSagyoCodeController();
        controller.init();
        controller.sagyoCodeFrom = '30065511';
        controller.sagyoCodeTo = '30065518';
        controller.sagyoCodeTarget = '30065519';
        // テスト開始
        Test.startTest();
        
        controller.replaceSagyoCode();
        
        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void testReplace03() {
        
        ReplaceSagyoCodeController controller = new ReplaceSagyoCodeController();
        controller.init();
        controller.sagyoCodeFrom = '';
        controller.sagyoCodeTo = '30065518';
        controller.sagyoCodeTarget = '30065519';
        // テスト開始
        Test.startTest();
        
        controller.replaceSagyoCode();
        
        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void testReplace04() {
        
        ReplaceSagyoCodeController controller = new ReplaceSagyoCodeController();
        controller.init();
        controller.sagyoCodeFrom = '30065511';
        controller.sagyoCodeTo = '';
        controller.sagyoCodeTarget = '30065519';
        // テスト開始
        Test.startTest();
        
        controller.replaceSagyoCode();
        
        // テスト終了
        Test.stopTest();
    }
    
   static testMethod void testReplace05() {
        
        ReplaceSagyoCodeController controller = new ReplaceSagyoCodeController();
        controller.init();
        controller.sagyoCodeFrom = '30065511';
        controller.sagyoCodeTo = '30065518';
        controller.sagyoCodeTarget = '';
        // テスト開始
        Test.startTest();
        
        controller.replaceSagyoCode();
        
        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void testReplace06() {
        
        ReplaceSagyoCodeController controller = new ReplaceSagyoCodeController();
        controller.init();
        controller.sagyoCodeFrom = '70065511';
        controller.sagyoCodeTo = '30065518';
        controller.sagyoCodeTarget = '30065519';
        // テスト開始
        Test.startTest();
        
        controller.replaceSagyoCode();
        
        // テスト終了
        Test.stopTest();
    }
    
    static testMethod void testReplace07() {
        
        ReplaceSagyoCodeController controller = new ReplaceSagyoCodeController();
        controller.init();
        controller.sagyoCodeFrom = '30065511';
        controller.sagyoCodeTo = '30065518';
        controller.sagyoCodeTarget = '70065519';
        // テスト開始
        Test.startTest();
        
        controller.replaceSagyoCode();
        
        // テスト終了
        Test.stopTest();
    }

}