/**
 * UrikakeReportControllerクラス用テストクラス
 */
@isTest
private class TestUrikakeReportController {

    /** テスト用顧客データ */
    private static Account[] testAcc;

    static testMethod void myUnitTest01() {

        // テスト開始
        Test.startTest();

        // テストデータ作成
        insertDate();
        
        List<Account> testKokyaku = [SELECT KokyakuCd__c FROM Account WHERE Name =: testAcc[0].Name];

        // 売掛レポート
        UrikakeReportController controller = new UrikakeReportController();
        Integer progress = 0;

        // 条件なしで実行
        controller.execute();

        // 条件ありで実行１
        controller.criteria.TargetDate__c = system.today();
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.KokyakuCd__c = null;
        controller.criteria.ExcludeSampleFlg__c =false;
        controller.execute();
        // progress = controller.resume.progress;
        // controller.resumeProcess();
        // controller.resumeFinish();

        // 条件ありで実行２
        controller.criteria.TargetDate__c = system.today();
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.KokyakuCd__c = testKokyaku[0].KokyakuCd__c;
        controller.criteria.ExcludeSampleFlg__c = false;
        controller.execute();
        // progress = controller.resume.progress;
        // controller.resumeProcess();
        // controller.resumeFinish();

        // 条件ありで実行３
        controller.criteria.TargetDate__c = system.today();
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.KokyakuCd__c = null;
        controller.criteria.ExcludeSampleFlg__c = true;
        controller.execute();
        // progress = controller.resume.progress;
        // controller.resumeProcess();
        // controller.resumeFinish();

        // 条件ありで実行４
        controller.criteria.TargetDate__c = system.today();
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.KokyakuCd__c = testKokyaku[0].KokyakuCd__c;
        controller.criteria.ExcludeSampleFlg__c = true;
        controller.execute();
        // progress = controller.resume.progress;
        // controller.resumeProcess();
        // controller.resumeFinish();

        // 条件ありで実行５
        controller.criteria.TargetDate__c = system.today();
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.KokyakuCd__c = null;
        controller.criteria.ExcludeSampleFlg__c = false;
        controller.execute();
        // progress = controller.resume.progress;
        // controller.resumeProcess();
        // controller.resumeFinish();

        // 条件ありで実行６
        controller.criteria.TargetDate__c = system.today();
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.KokyakuCd__c = '123456';
        controller.criteria.ExcludeSampleFlg__c = false;
        controller.execute();
        
        // ソート１
        // controller.sortData();

        // ソート２
        // controller.sortExpression = 'Uriagegaku__c';
        // controller.sortData();

        // ページング１
        // controller.paging();

        // テスト終了
        Test.stopTest();
    }

    /**
     * テストデータ作成
     */
    private static void insertDate(){

        // テスト用顧客データ作成
        testAcc = new Account[] {
            new Account(Name='Test1')
        };
        insert testAcc;

        // テスト用案件データ作成
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み', StatusLock__c=true, NohinDateTime__c = system.now())
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ作成
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        //テスト用請求ヘッダデータ作成
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[] {
            New SeikyuHeader__c(Seikyusaki__c=testAcc[0].Id, SeikyuStatus__c='請求済み', NyukinStatus__c='未入金', SeikyuDateTime__c=system.now())
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = New Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken[0].Id, AnkenName__c='案件名１', AnkenTantosya__c='担当者1')
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05)
        };
        insert testSeikyuMeisai;

        // テスト用入金データ作成
        Nyukin__c[] testNyukin = New Nyukin__c[]{
            New Nyukin__c(Nyukinsaki__c=testAcc[0].Id, NyukinDate__c=system.today(), Nyukingaku__c=1000)
        };
        insert testNyukin;
        
        // テスト用売掛レポートデータ作成
        UrikakeReport__c testUrikake = new UrikakeReport__c(Name = 'Test1');
        insert testUrikake;
    }
}