/**
 * NotCreateSeikyusyoControllerクラス用テストクラス
 */
@isTest
private class TestNotCreateSeikyusyoController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        //ユーザ取得
        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND IsActive = true];

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ1')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true)
        };
        insert testCon;

        // テスト用案件データ作成
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み', StatusLock__c=true)
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ作成
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        //テスト用請求ヘッダデータ作成
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[] {
            New SeikyuHeader__c(Seikyusaki__c=testAcc[0].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金')
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = New Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken[0].Id, AnkenName__c='案件名１', AnkenTantosya__c='担当者1')
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05)
        };
        insert testSeikyuMeisai;

        // 請求書作成
        NotCreateSeikyusyoController controller = new NotCreateSeikyusyoController();
        // 初期化処理
        controller.init();
        // 請求書作成
        controller.createPdf();
        // リジューム処理
        controller.resumeProcess();
        // リジューム終了処理
        controller.resumeFinish();

        // テスト終了
        Test.stopTest();
    }
}