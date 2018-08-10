/**
 * TokusokuControllerクラス用テストクラス
 */
@isTest
private class TestTokusokuController {

	/* 正常系 */
    static testMethod void myUnitTest_Nomal() {
        try{
	        // テスト開始
	        Test.startTest();

	        //ユーザ取得
	        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND IsActive = true];

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
	        	new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[2].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[3].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[4].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[5].Id, Status__c='請求確定済み', StatusLock__c=true)
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

	        //テスト用請求ヘッダデータ作成
	        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[] {
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[0].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[1].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[2].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[3].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[4].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
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
	        	new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[5].Id, DenpyoNo__c=testAnken[5].Id, AnkenName__c='案件名６', AnkenTantosya__c='担当者6')
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
	            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[5].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05)
	        };
	        insert testSeikyuMeisai;

	        // テスト用Attachmentデータ作成
	        Attachment[] testAttachment = New Attachment[]{
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[0].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[1].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[2].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[3].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[4].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[5].Id, Body=Blob.valueOf('sample'))
	        };
	        insert testAttachment;

	        List<SeikyuHeader__c> updateSeikyuHeaderList = new List<SeikyuHeader__c>();
            testSeikyuHeader[0].SeikyusyoId__c = testAttachment[0].Id;
            testSeikyuHeader[1].SeikyusyoId__c = testAttachment[1].Id;
            testSeikyuHeader[2].SeikyusyoId__c = testAttachment[2].Id;
            testSeikyuHeader[3].SeikyusyoId__c = testAttachment[3].Id;
            testSeikyuHeader[4].SeikyusyoId__c = testAttachment[4].Id;
            testSeikyuHeader[5].SeikyusyoId__c = testAttachment[5].Id;
            updateSeikyuHeaderList.add(testSeikyuHeader[0]);
            updateSeikyuHeaderList.add(testSeikyuHeader[1]);
            updateSeikyuHeaderList.add(testSeikyuHeader[2]);
            updateSeikyuHeaderList.add(testSeikyuHeader[3]);
            updateSeikyuHeaderList.add(testSeikyuHeader[4]);
            updateSeikyuHeaderList.add(testSeikyuHeader[5]);
            update updateSeikyuHeaderList;

            System.debug('==============================================================================');
            System.debug('テスト開始');
            System.debug('==============================================================================');
	        // リクエストパラメータ設定
	        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');
	        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testSeikyuHeader);
            System.debug('==============================================================================');
            System.debug('パラメータセット');
            System.debug('==============================================================================');
	        // 全選択
	        ssc.setSelected(testSeikyuHeader);
            System.debug('==============================================================================');
            System.debug('全選択');
            System.debug('==============================================================================');
	        // TokusokuController
	        TokusokuController controller = new TokusokuController(ssc);
            System.debug('==============================================================================');
            System.debug('コントローラ定義');
            System.debug('==============================================================================');
	        //
	        controller.initCheck();
            System.debug('==============================================================================');
            System.debug('initCheck');
            System.debug('==============================================================================');
	        //
	        controller.sendPdf();
            System.debug('==============================================================================');
            System.debug('sendPdf');
            System.debug('==============================================================================');
	        //
	        controller.NyukinStatusUpdate();
            System.debug('==============================================================================');
            System.debug('NyukinStatusUpdate');
            System.debug('==============================================================================');
            //
	        controller.cancel();
            System.debug('==============================================================================');
            System.debug('cancel');
            System.debug('==============================================================================');

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
        	//
	        Test.stopTest();
        }
    }
	/* エラー系 */
    static testMethod void myUnitTest_Err() {
        try{
	        // テスト開始
	        Test.startTest();

	        //ユーザ取得
	        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND IsActive = true];

	        // テスト用顧客データ作成
	        Account[] testAcc = new Account[] {
	        	new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ1'),
	        	new Account(Name='Test2', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ2'),
	        	new Account(Name='Test3', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ3'),
	        	new Account(Name='Test4', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ4'),
	        	new Account(Name='Test5', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ5'),
	        	new Account(Name='Test6', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ6'),
	        	new Account(Name='Test7', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ7'),
	        	new Account(Name='Test8', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ8')
	        };
	        insert testAcc;

	        // テスト用担当者データ作成
	        Contact[] testCon = new Contact[] {
	        	new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
	        	new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='', SeikyuTantoFlg__c=true),
	        	new Contact(LastName='Test3', AccountId=testAcc[2].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
	        	new Contact(LastName='Test4', AccountId=testAcc[3].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
	        	new Contact(LastName='Test6', AccountId=testAcc[5].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
	        	new Contact(LastName='Test7', AccountId=testAcc[6].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true)
	        };
	        insert testCon;

	        // テスト用案件データ作成
	        Anken__c[] testAnken = New Anken__c[]{
	        	new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[2].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[3].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[4].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[5].Id, Status__c='請求確定済み', StatusLock__c=true),
	        	new Anken__c(KokyakuName__c=testAcc[6].Id, Status__c='請求確定済み', StatusLock__c=true)
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
	            New AnkenMeisai__c(Anken__c = testAnken[5].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
	            New AnkenMeisai__c(Anken__c = testAnken[6].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
	            New AnkenMeisai__c(Anken__c = testAnken[6].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true)
	        };
	        insert testAnkenMeisai;

	        //テスト用請求ヘッダデータ作成
	        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[] {
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[0].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[1].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[2].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[3].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[4].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[5].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金')
	        };
	        insert testSeikyuHeader;

	        SeikyuHeader__c[] testDelSeikyuHeader = new SeikyuHeader__c[] {
	        	New SeikyuHeader__c(Seikyusaki__c=testAcc[6].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金', Del_Flg__c=true)
	        };
	        insert testDelSeikyuHeader;

	        // テスト用請求データ作成
	        Seikyu__c[] testSeikyu = New Seikyu__c[]{
	        	new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken[0].Id, AnkenName__c='案件名１', AnkenTantosya__c='担当者1'),
	        	new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[1].Id, DenpyoNo__c=testAnken[1].Id, AnkenName__c='案件名２', AnkenTantosya__c='担当者2'),
	        	new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[2].Id, DenpyoNo__c=testAnken[2].Id, AnkenName__c='案件名３', AnkenTantosya__c='担当者3'),
	        	new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[3].Id, DenpyoNo__c=testAnken[3].Id, AnkenName__c='案件名４', AnkenTantosya__c='担当者4'),
	        	new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[4].Id, DenpyoNo__c=testAnken[4].Id, AnkenName__c='案件名５', AnkenTantosya__c='担当者5'),
	        	new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[5].Id, DenpyoNo__c=testAnken[5].Id, AnkenName__c='案件名６', AnkenTantosya__c='担当者6'),
	        	new Seikyu__c(SeikyusyoNo__c=testDelSeikyuHeader[0].Id, DenpyoNo__c=testAnken[6].Id, AnkenName__c='案件名７', AnkenTantosya__c='担当者7')
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
	            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[6].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
	            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[6].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05)
	        };
	        insert testSeikyuMeisai;

	        // テスト用Attachmentデータ作成
	        Attachment[] testAttachment = New Attachment[]{
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[0].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[1].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[2].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[3].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[4].Id, Body=Blob.valueOf('sample')),
	            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[5].Id, Body=Blob.valueOf('sample'))
	        };
	        insert testAttachment;

	        List<SeikyuHeader__c> updateSeikyuHeaderList = new List<SeikyuHeader__c>();
            testSeikyuHeader[0].SeikyusyoId__c = testAttachment[0].Id;
            testSeikyuHeader[1].SeikyusyoId__c = testAttachment[1].Id;
            testSeikyuHeader[2].SeikyusyoId__c = testAttachment[2].Id;
            testSeikyuHeader[3].SeikyusyoId__c = testAttachment[3].Id;
            testSeikyuHeader[4].SeikyusyoId__c = testAttachment[4].Id;
            updateSeikyuHeaderList.add(testSeikyuHeader[0]);
            updateSeikyuHeaderList.add(testSeikyuHeader[1]);
            updateSeikyuHeaderList.add(testSeikyuHeader[2]);
            updateSeikyuHeaderList.add(testSeikyuHeader[3]);
            updateSeikyuHeaderList.add(testSeikyuHeader[4]);
            update updateSeikyuHeaderList;

	        // リクエストパラメータ設定
	        ApexPages.currentPage().getParameters().put('retURL', null);
	        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testSeikyuHeader);
	        // 選択ゼロ件
	        TokusokuController controller = new TokusokuController(ssc);
	        controller.initCheck();
	        // 請求取消された請求ヘッダを選択
	        ApexPages.StandardSetController ssc2 = new ApexPages.StandardSetController(testDelSeikyuHeader);
	        ssc2.setSelected(testDelSeikyuHeader);
	        TokusokuController controller2 = new TokusokuController(ssc2);
            controller2.initCheck();
	        // 全選択
	        ssc.setSelected(testSeikyuHeader);
	        // TokusokuController
	        TokusokuController controller3 = new TokusokuController(ssc);
	        controller3.initCheck();
	        controller3.sendPdf();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
        	//
	        Test.stopTest();
        }
    }
}