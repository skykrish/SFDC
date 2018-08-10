/**
 * SitesBillingControllerクラス用テストクラス
 */
@isTest
private class TestSitesBillingController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        //ユーザ取得
        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND IsActive = true];

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test1', AccountId = testAcc.Id, Email = 'test1@test.com');
        insert testCon;

        // テスト用案件データ作成
        Anken__c testAnken = new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み', StatusLock__c=true);
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c testSagyo = New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999);
        insert testSagyo;

        // テスト用案件明細データ作成
        AnkenMeisai__c testAnkenMeisai = New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo.Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true);
        insert testAnkenMeisai;

        //テスト用請求ヘッダデータ作成
        SeikyuHeader__c testSeikyuHeader = New SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='請求済み', NyukinStatus__c='未入金');
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c testSeikyu = new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader.Id, DenpyoNo__c=testAnken.Id, AnkenName__c='案件名１', AnkenTantosya__c='担当者1');
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c testSeikyuMeisai = New SeikyuMeisai__c(SeikyuNo__c=testSeikyu.Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05);
        insert testSeikyuMeisai;

        // Sites請求履歴
        SitesBillingController controller = new SitesBillingController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();
        // 請求書ダウンロード
        ApexPages.currentPage().getParameters().put('shid', testSeikyuHeader.Id);
        controller.print();
        
        // ページング
        controller.paginator.dispPage = 0;
        controller.paging();
        
        // 発注フォーム
        controller.order();

        // テスト終了
        Test.stopTest();
    }
}