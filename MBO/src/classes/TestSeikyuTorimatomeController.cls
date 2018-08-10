/**
 * SeikyuTorimatomeControllerクラス用テストクラス
 */
@isTest
private class TestSeikyuTorimatomeController {

    /** テスト用顧客データ */
    private static Account[] testAcc;

    /** テスト用請案件データ */
    private static Anken__c[] testAnken;

    /** テスト用請求ヘッダデータ */
    private static SeikyuHeader__c[] testSeikyuHeader;

    /** テスト用作業データ */
    private static Sagyo__c[] testSagyo;

    /** テスト用Attachmentデータ */
    private static Attachment[] testAttachment;

    /** ページ数上限 */
    private static integer MAX_PAGE = 10;

    /** １ページの表示請求ヘッダ数 */
    private static integer MAX_SHEAD_LINE = 100;

    static testMethod void myUnitTest1() {
        // テスト開始
        Test.startTest();
        
        //テストデータ作成
        insertDate();

        List<SeikyuHeader__c> updateSeikyuHeaderList = new List<SeikyuHeader__c>();
        for(Integer i = 0; i < testAttachment.size(); i++){
            if(i != 0){
                testSeikyuHeader[i + 1].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i + 1]);
            }else{
                testSeikyuHeader[i].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i]);
            }
        }
        update updateSeikyuHeaderList;
        
        //パラメータ設定
        PageReference pageRef = Page.SeikyuTorimatome;
        //パラメータをセット
        pageRef.getParameters().put('shid', testSeikyuHeader[0].Id);
        pageRef.getParameters().put('shcri', testAcc[0].Id + ',掛売上,2016-05-01,未請求,未入金,15日,2016,05,01,false');
        Test.setCurrentPage(pageRef);
        
        // 請求書取りまとめ
        SeikyuTorimatomeController controller = new SeikyuTorimatomeController();
        
        //取りまとめる顧客を設定
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        
        controller.init();
        controller.compiledSeikyu();
        controller.createPdf();
        
        // テスト終了
        Test.stopTest();
        
    }
    
    /**
   * テストデータ作成
   */
  private static void insertDate(){

        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND IsActive = true];

        // テスト用顧客データ作成
        testAcc = new Account[] {
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
          new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='test@test.co.jp', SeikyuTantoFlg__c=false),
          new Contact(LastName='Test3', AccountId=testAcc[2].Id, email=null, SeikyuTantoFlg__c=true),
          new Contact(LastName='Test4', AccountId=testAcc[3].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
          new Contact(LastName='Test5', AccountId=testAcc[4].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
          new Contact(LastName='Test7', AccountId=testAcc[6].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true)
        };
        insert testCon;

        // テスト用案件データ作成
        testAnken = New Anken__c[]{
          new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
          new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
          new Anken__c(KokyakuName__c=testAcc[2].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
          new Anken__c(KokyakuName__c=testAcc[3].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
          new Anken__c(KokyakuName__c=testAcc[4].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today()),
          new Anken__c(KokyakuName__c=testAcc[5].Id, Status__c='請求確定済み', StatusLock__c=true,JuchuDateTime__c=Date.today())
        };
        insert testAnken;

        // テスト用作業データ作成
        testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ作成
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[3].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[3].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[4].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[4].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[5].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[5].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // テスト用入金データ作成
        Nyukin__c[] testNyukin = New Nyukin__c[]{
            New Nyukin__c(Nyukinsaki__c = testAcc[0].Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 2000, Status__c = '相殺済み', Offset_Flg__c = true)
        };
        insert testNyukin;

        //テスト用請求ヘッダデータ作成
        testSeikyuHeader = new SeikyuHeader__c[] {
          New SeikyuHeader__c(Seikyusaki__c=testAcc[0].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[1].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[2].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[3].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='請求済み', NyukinStatus__c='入金済み'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[4].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='請求済み', NyukinStatus__c='未入金', Del_Flg__c=true),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[5].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金')
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = New Seikyu__c[]{
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken[0].Id, AnkenName__c='案件名１', AnkenTantosya__c='担当者1'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[1].Id, DenpyoNo__c=testAnken[1].Id, AnkenName__c='案件名２', AnkenTantosya__c='担当者2'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[2].Id, DenpyoNo__c=testAnken[2].Id, AnkenName__c='案件名３', AnkenTantosya__c='担当者3'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[3].Id, DenpyoNo__c=testAnken[3].Id, AnkenName__c='案件名４', AnkenTantosya__c='担当者4'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[4].Id, DenpyoNo__c=testAnken[4].Id, AnkenName__c='案件名５', AnkenTantosya__c='担当者5'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[5].Id, DenpyoNo__c=testAnken[5].Id, AnkenName__c='案件名６', AnkenTantosya__c='担当者6'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, OffsetNyukin__c=testNyukin[0].Id, Offset_Flg__c=true)
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[1].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[1].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[2].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[2].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[3].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[3].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[4].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[4].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[5].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[5].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[6].Id, Tanka__c=-2000, Suryo__c=1, TaxRate__c=0)
        };
        insert testSeikyuMeisai;

        // テスト用Attachmentデータ作成
        testAttachment = New Attachment[]{
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[0].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[2].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[3].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[4].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[5].Id, Body=Blob.valueOf('sample'))
        };
        insert testAttachment;
  }
}