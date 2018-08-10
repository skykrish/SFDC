/**
 * SitesOrderlistCsvControllerクラス用テストクラス
 */
@isTest
private class TestSitesOrderlistCsvController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test', KokyakuId__c='testuser', KokyakuPw__c='password', Mitsumori__c='不要');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email = 'test@test.com');
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
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[] {
            New SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
            New SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金', Del_Flg__c=true)
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = New Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken.Id, AnkenName__c='案件名１', AnkenTantosya__c='担当者1'),
            new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[1].Id, DenpyoNo__c=testAnken.Id, AnkenName__c='案件名２', AnkenTantosya__c='担当者2')
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[1].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[1].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05)
        };
        insert testSeikyuMeisai;

        // テスト用Attachmentデータ作成
        Attachment[] testAttachment = New Attachment[]{
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[0].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[1].Id, Body=Blob.valueOf('sample'))
        };
        insert testAttachment;

        List<SeikyuHeader__c> updateSeikyuHeaderList = new List<SeikyuHeader__c>();
        testSeikyuHeader[0].SeikyusyoId__c = testAttachment[0].Id;
        testSeikyuHeader[1].SeikyusyoId__c = testAttachment[1].Id;
        updateSeikyuHeaderList.add(testSeikyuHeader[0]);
        updateSeikyuHeaderList.add(testSeikyuHeader[1]);
        update updateSeikyuHeaderList;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aidList', testAnken.Id);

        // Sites利用履歴CSV
        SitesOrderlistCsvController controller = new SitesOrderlistCsvController();
        // Cookie登録
        controller.createCookie(testAcc.Id);
        // 初期化処理
        controller.init();

        // テスト終了
        Test.stopTest();
    }
}