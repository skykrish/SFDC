/**
 * NyukinKeshikomiControllerクラス用テストクラス
 */
@isTest
private class TestNyukinKeshikomiController {

	// 定数
	private static String SEIKYU_STATUS_SEIKYUZUMI = '請求済み';
	private static String NYUKIN_STATUS_MINYUKIN = '未入金';
	private static String NYUKIN_STATUS_NYUKINZUMI = '入金済み';
	private static String STATUS_SHINKI = '新規';
	private static String STATUS_KESHIKOMIZUMI = '消し込み済み';

    static testMethod void myUnitTest() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
			new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_KESHIKOMIZUMI, NyukinDate__c = Date.today(), Nyukingaku__c = 5000),
			new Nyukin__c(Nyukinsaki__c = testAcc[1].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 6000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '未請求', NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_NYUKINZUMI, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = true),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[1].Id, FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[4].id, DenpyoNo__c = testAnken[4].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[5].id, DenpyoNo__c = testAnken[5].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[6].id, DenpyoNo__c = testAnken[6].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[7].id, DenpyoNo__c = testAnken[7].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[4].id, Tanka__c = 5000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[5].id, Tanka__c = 6000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[7].id, Tanka__c = 7000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[6].id, Tanka__c = 8000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// テスト終了
		Test.stopTest();

/*		// アサーション
		system.assertEquals(4, controller.nyukinList.size());
		system.assertEquals(testNyukin[3].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(!controller.nyukinList[0].checked);

		system.assertEquals(testNyukin[2].Id, controller.nyukinList[1].nyukin.Id);
		system.assert(!controller.nyukinList[1].checked);

		system.assertEquals(testNyukin[1].Id, controller.nyukinList[2].nyukin.Id);
		system.assert(!controller.nyukinList[2].checked);

		system.assertEquals(testNyukin[0].Id, controller.nyukinList[3].nyukin.Id);
		system.assert(!controller.nyukinList[3].checked);

		system.assertEquals(4, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[3].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[2].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[1].checked);

		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[2].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[2].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[3].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[3].checked);

//		system.assertEquals(0, controller.checkedNyukingakuTotal);
//		system.assertEquals(0, controller.checkedSeikyugakuTotal);

		system.assertEquals(0, Apexpages.getMessages().size());
*/
    }

    static testMethod void myUnitTest2() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// 入金データにチェック
		controller.nyukinList[0].checked = true;
		controller.nyukinList[2].checked = true;
		controller.nyukinList[3].checked = true;

		// 請求ヘッダデータにチェック
		controller.seikyuHeaderList[0].checked = true;
		controller.seikyuHeaderList[1].checked = true;

		controller.keshikomi();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Status__c,
												Keshikomibi__c
												FROM Nyukin__c
												WHERE Nyukinsaki__c = :testAcc[0].Id];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE Seikyusaki__c = :testAcc[0].Id];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

/*		// アサーション
		for(Integer i= 0; i < testNyukin.size(); i++){
			if(resultNyukinMap.containsKey(testNyukin[i].Id)){
				Nyukin__c nyukin = resultNyukinMap.get(testNyukin[i].Id);
				if(i != 2){
					system.assertEquals(STATUS_KESHIKOMIZUMI, nyukin.Status__c);
					system.assertNotEquals(null, nyukin.Keshikomibi__c);
				}else{
					system.assertEquals(STATUS_SHINKI, nyukin.Status__c);
					system.assertEquals(null, nyukin.Keshikomibi__c);
				}
			}else{
				system.assert(false);
			}
		}

		for(Integer i= 0; i < testSeikyuHeader.size(); i++){
			if(resultShMap.containsKey(testSeikyuHeader[i].Id)){
				SeikyuHeader__c seikyuHeader = resultShMap.get(testSeikyuHeader[i].Id);
				if(i > 1){
					system.assertEquals(NYUKIN_STATUS_NYUKINZUMI, seikyuHeader.NyukinStatus__c);
					system.assertNotEquals(null, seikyuHeader.Keshikomibi__c);
				}else{
					system.assertEquals(NYUKIN_STATUS_MINYUKIN, seikyuHeader.NyukinStatus__c);
					system.assertEquals(null, seikyuHeader.Keshikomibi__c);
				}
			}else{
				system.assert(false);
			}
		}

		system.assertEquals(1, controller.nyukinList.size());
		system.assertEquals(testNyukin[2].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(!controller.nyukinList[0].checked);

		system.assertEquals(2, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[1].checked);

//		system.assertEquals(0, controller.checkedNyukingakuTotal);
//		system.assertEquals(0, controller.checkedSeikyugakuTotal);

		system.assertEquals(1, Apexpages.getMessages().size());
		system.assertEquals('選択された消し込み対象のデータの消し込みが完了しました。', Apexpages.getMessages()[0].getSummary());
*/
    }

    static testMethod void myUnitTest3() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// 請求ヘッダデータにチェック
		controller.seikyuHeaderList[0].checked = true;
		controller.seikyuHeaderList[1].checked = true;

		controller.keshikomi();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Status__c,
												Keshikomibi__c
												FROM Nyukin__c
												WHERE Nyukinsaki__c = :testAcc[0].Id];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE Seikyusaki__c = :testAcc[0].Id];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

/*		// アサーション
		for(Integer i= 0; i < testNyukin.size(); i++){
			if(resultNyukinMap.containsKey(testNyukin[i].Id)){
				Nyukin__c nyukin = resultNyukinMap.get(testNyukin[i].Id);
				system.assertEquals(STATUS_SHINKI, nyukin.Status__c);
				system.assertEquals(null, nyukin.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i= 0; i < testSeikyuHeader.size(); i++){
			if(resultShMap.containsKey(testSeikyuHeader[i].Id)){
				SeikyuHeader__c seikyuHeader = resultShMap.get(testSeikyuHeader[i].Id);
				system.assertEquals(NYUKIN_STATUS_MINYUKIN, seikyuHeader.NyukinStatus__c);
				system.assertEquals(null, seikyuHeader.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		system.assertEquals(4, controller.nyukinList.size());
		system.assertEquals(testNyukin[3].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(!controller.nyukinList[0].checked);

		system.assertEquals(testNyukin[2].Id, controller.nyukinList[1].nyukin.Id);
		system.assert(!controller.nyukinList[1].checked);

		system.assertEquals(testNyukin[1].Id, controller.nyukinList[2].nyukin.Id);
		system.assert(!controller.nyukinList[2].checked);

		system.assertEquals(testNyukin[0].Id, controller.nyukinList[3].nyukin.Id);
		system.assert(!controller.nyukinList[3].checked);

		system.assertEquals(4, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[3].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[2].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(controller.seikyuHeaderList[1].checked);

		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[2].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[2].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[3].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[3].checked);

		system.assertEquals(0, controller.checkedNyukingakuTotal);
		system.assertEquals(7000, controller.checkedSeikyugakuTotal);

		system.assertEquals(1, Apexpages.getMessages().size());
		system.assertEquals('入金データが選択されていません。', Apexpages.getMessages()[0].getSummary());
*/
    }

    static testMethod void myUnitTest4() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// 入金データにチェック
		controller.nyukinList[0].checked = true;
		controller.nyukinList[2].checked = true;

		controller.keshikomi();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Status__c,
												Keshikomibi__c
												FROM Nyukin__c
												WHERE Nyukinsaki__c = :testAcc[0].Id];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE Seikyusaki__c = :testAcc[0].Id];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

/*		// アサーション
		for(Integer i= 0; i < testNyukin.size(); i++){
			if(resultNyukinMap.containsKey(testNyukin[i].Id)){
				Nyukin__c nyukin = resultNyukinMap.get(testNyukin[i].Id);
				system.assertEquals(STATUS_SHINKI, nyukin.Status__c);
				system.assertEquals(null, nyukin.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i= 0; i < testSeikyuHeader.size(); i++){
			if(resultShMap.containsKey(testSeikyuHeader[i].Id)){
				SeikyuHeader__c seikyuHeader = resultShMap.get(testSeikyuHeader[i].Id);
				system.assertEquals(NYUKIN_STATUS_MINYUKIN, seikyuHeader.NyukinStatus__c);
				system.assertEquals(null, seikyuHeader.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		system.assertEquals(4, controller.nyukinList.size());
		system.assertEquals(testNyukin[3].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(controller.nyukinList[0].checked);

		system.assertEquals(testNyukin[2].Id, controller.nyukinList[1].nyukin.Id);
		system.assert(!controller.nyukinList[1].checked);

		system.assertEquals(testNyukin[1].Id, controller.nyukinList[2].nyukin.Id);
		system.assert(controller.nyukinList[2].checked);

		system.assertEquals(testNyukin[0].Id, controller.nyukinList[3].nyukin.Id);
		system.assert(!controller.nyukinList[3].checked);

		system.assertEquals(4, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[3].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[2].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[1].checked);

		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[2].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[2].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[3].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[3].checked);

		system.assertEquals(5000, controller.checkedNyukingakuTotal);
		system.assertEquals(0, controller.checkedSeikyugakuTotal);

		system.assertEquals(1, Apexpages.getMessages().size());
		system.assertEquals('請求データが選択されていません。', Apexpages.getMessages()[0].getSummary());
*/
    }

    static testMethod void myUnitTest5() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// 入金データにチェック
		controller.nyukinList[0].checked = true;
		controller.nyukinList[2].checked = true;

		// 請求ヘッダデータにチェック
		controller.seikyuHeaderList[0].checked = true;
		controller.seikyuHeaderList[1].checked = true;

		controller.keshikomi();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Status__c,
												Keshikomibi__c
												FROM Nyukin__c
												WHERE Nyukinsaki__c = :testAcc[0].Id];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE Seikyusaki__c = :testAcc[0].Id];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

/*		// アサーション
		for(Integer i= 0; i < testNyukin.size(); i++){
			if(resultNyukinMap.containsKey(testNyukin[i].Id)){
				Nyukin__c nyukin = resultNyukinMap.get(testNyukin[i].Id);
				system.assertEquals(STATUS_SHINKI, nyukin.Status__c);
				system.assertEquals(null, nyukin.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i= 0; i < testSeikyuHeader.size(); i++){
			if(resultShMap.containsKey(testSeikyuHeader[i].Id)){
				SeikyuHeader__c seikyuHeader = resultShMap.get(testSeikyuHeader[i].Id);
				system.assertEquals(NYUKIN_STATUS_MINYUKIN, seikyuHeader.NyukinStatus__c);
				system.assertEquals(null, seikyuHeader.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		system.assertEquals(4, controller.nyukinList.size());
		system.assertEquals(testNyukin[3].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(controller.nyukinList[0].checked);

		system.assertEquals(testNyukin[2].Id, controller.nyukinList[1].nyukin.Id);
		system.assert(!controller.nyukinList[1].checked);

		system.assertEquals(testNyukin[1].Id, controller.nyukinList[2].nyukin.Id);
		system.assert(controller.nyukinList[2].checked);

		system.assertEquals(testNyukin[0].Id, controller.nyukinList[3].nyukin.Id);
		system.assert(!controller.nyukinList[3].checked);

		system.assertEquals(4, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[3].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[2].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(controller.seikyuHeaderList[1].checked);

		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[2].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[2].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[3].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[3].checked);

		system.assertEquals(5000, controller.checkedNyukingakuTotal);
		system.assertEquals(7000, controller.checkedSeikyugakuTotal);

		system.assertEquals(1, Apexpages.getMessages().size());
		system.assertEquals('入金額の合計と請求額の合計が一致しません。', Apexpages.getMessages()[0].getSummary());
*/
    }

    static testMethod void myUnitTest6() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// 入金データにチェック
		controller.nyukinList[0].checked = true;
		controller.nyukinList[2].checked = true;

		// 請求ヘッダデータにチェック
		controller.seikyuHeaderList[0].checked = true;
		controller.seikyuHeaderList[1].checked = true;

		testNyukin[3].Status__c = STATUS_KESHIKOMIZUMI;
		testNyukin[3].Keshikomibi__c = System.now();
		update testNyukin[3];

		controller.keshikomi();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Status__c,
												Keshikomibi__c
												FROM Nyukin__c
												WHERE Nyukinsaki__c = :testAcc[0].Id];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE Seikyusaki__c = :testAcc[0].Id];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

/*		// アサーション
		for(Integer i= 0; i < testNyukin.size(); i++){
			if(resultNyukinMap.containsKey(testNyukin[i].Id)){
				Nyukin__c nyukin = resultNyukinMap.get(testNyukin[i].Id);
				if(i == 3){
					system.assertEquals(STATUS_KESHIKOMIZUMI, nyukin.Status__c);
					system.assertNotEquals(null, nyukin.Keshikomibi__c);
				}else{
					system.assertEquals(STATUS_SHINKI, nyukin.Status__c);
					system.assertEquals(null, nyukin.Keshikomibi__c);
				}
			}else{
				system.assert(false);
			}
		}

		for(Integer i= 0; i < testSeikyuHeader.size(); i++){
			if(resultShMap.containsKey(testSeikyuHeader[i].Id)){
				SeikyuHeader__c seikyuHeader = resultShMap.get(testSeikyuHeader[i].Id);
				system.assertEquals(NYUKIN_STATUS_MINYUKIN, seikyuHeader.NyukinStatus__c);
				system.assertEquals(null, seikyuHeader.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		system.assertEquals(3, controller.nyukinList.size());
		system.assertEquals(testNyukin[2].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(!controller.nyukinList[0].checked);

		system.assertEquals(testNyukin[1].Id, controller.nyukinList[1].nyukin.Id);
		system.assert(!controller.nyukinList[1].checked);

		system.assertEquals(testNyukin[0].Id, controller.nyukinList[2].nyukin.Id);
		system.assert(!controller.nyukinList[2].checked);

		system.assertEquals(4, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[3].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[2].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[1].checked);

		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[2].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[2].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[3].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[3].checked);

		system.assertEquals(0, controller.checkedNyukingakuTotal);
		system.assertEquals(0, controller.checkedSeikyugakuTotal);

		system.assertEquals(1, Apexpages.getMessages().size());
		system.assertEquals('選択された消し込み対象のデータが他のユーザに更新された可能性があります。', Apexpages.getMessages()[0].getSummary());
*/
    }

    static testMethod void myUnitTest7() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// 入金データにチェック
		controller.nyukinList[0].checked = true;
		controller.nyukinList[2].checked = true;

		// 請求ヘッダデータにチェック
		controller.seikyuHeaderList[0].checked = true;
		controller.seikyuHeaderList[1].checked = true;

		testNyukin[3].Nyukingaku__c = 100;
		update testNyukin[3];

		controller.keshikomi();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Status__c,
												Keshikomibi__c
												FROM Nyukin__c
												WHERE Nyukinsaki__c = :testAcc[0].Id];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE Seikyusaki__c = :testAcc[0].Id];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

/*		// アサーション
		for(Integer i= 0; i < testNyukin.size(); i++){
			if(resultNyukinMap.containsKey(testNyukin[i].Id)){
				Nyukin__c nyukin = resultNyukinMap.get(testNyukin[i].Id);
				system.assertEquals(STATUS_SHINKI, nyukin.Status__c);
				system.assertEquals(null, nyukin.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i= 0; i < testSeikyuHeader.size(); i++){
			if(resultShMap.containsKey(testSeikyuHeader[i].Id)){
				SeikyuHeader__c seikyuHeader = resultShMap.get(testSeikyuHeader[i].Id);
				system.assertEquals(NYUKIN_STATUS_MINYUKIN, seikyuHeader.NyukinStatus__c);
				system.assertEquals(null, seikyuHeader.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		system.assertEquals(4, controller.nyukinList.size());
		system.assertEquals(testNyukin[3].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(!controller.nyukinList[0].checked);

		system.assertEquals(testNyukin[2].Id, controller.nyukinList[1].nyukin.Id);
		system.assert(!controller.nyukinList[1].checked);

		system.assertEquals(testNyukin[1].Id, controller.nyukinList[2].nyukin.Id);
		system.assert(!controller.nyukinList[2].checked);

		system.assertEquals(testNyukin[0].Id, controller.nyukinList[3].nyukin.Id);
		system.assert(!controller.nyukinList[3].checked);

		system.assertEquals(4, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[3].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[2].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[1].checked);

		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[2].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[2].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[3].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[3].checked);

		system.assertEquals(0, controller.checkedNyukingakuTotal);
		system.assertEquals(0, controller.checkedSeikyugakuTotal);

		system.assertEquals(1, Apexpages.getMessages().size());
		system.assertEquals('選択された消し込み対象のデータが他のユーザに更新された可能性があります。', Apexpages.getMessages()[0].getSummary());
*/
    }

    static testMethod void myUnitTest8() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c = 'テスト支店1', FurikomiShitenCd__c = '111', FurikomiKozaType__c='普通', FurikomiKozaNo__c = '2222222', FurikomiKozaName__c='ﾃｽﾄ1')
		};
		insert testAcc;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 2000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today(), Nyukingaku__c = 1000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-1), Nyukingaku__c = 3000),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].Id, Status__c = STATUS_SHINKI, NyukinDate__c = Date.today().addDays(-2), Nyukingaku__c = 4000)
		};
		insert testNyukin;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = SEIKYU_STATUS_SEIKYUZUMI, NyukinStatus__c = NYUKIN_STATUS_MINYUKIN, Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 2000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 1000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 3000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 4000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト開始
		Test.startTest();

		// リクエストパラメータ設定
		ApexPages.currentPage().getParameters().put('kokyakuId', testAcc[0].Id);

		// 案件明細登録：初期化処理
		NyukinKeshikomiController controller = new NyukinKeshikomiController();
		controller.init();

		// 入金データにチェック
		controller.nyukinList[0].checked = true;
		controller.nyukinList[2].checked = true;

		// 請求ヘッダデータにチェック
		controller.seikyuHeaderList[0].checked = true;
		controller.seikyuHeaderList[1].checked = true;

		testSeikyuMeisai[3].Tanka__c = 100;
		update testSeikyuHeader[3];
		update testSeikyuMeisai[3];
		update testSeikyu[3];

		controller.keshikomi();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Status__c,
												Keshikomibi__c
												FROM Nyukin__c
												WHERE Nyukinsaki__c = :testAcc[0].Id];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE Seikyusaki__c = :testAcc[0].Id];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

/*		// アサーション
		for(Integer i= 0; i < testNyukin.size(); i++){
			if(resultNyukinMap.containsKey(testNyukin[i].Id)){
				Nyukin__c nyukin = resultNyukinMap.get(testNyukin[i].Id);
				system.assertEquals(STATUS_SHINKI, nyukin.Status__c);
				system.assertEquals(null, nyukin.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i= 0; i < testSeikyuHeader.size(); i++){
			if(resultShMap.containsKey(testSeikyuHeader[i].Id)){
				SeikyuHeader__c seikyuHeader = resultShMap.get(testSeikyuHeader[i].Id);
				system.assertEquals(NYUKIN_STATUS_MINYUKIN, seikyuHeader.NyukinStatus__c);
				system.assertEquals(null, seikyuHeader.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

		system.assertEquals(4, controller.nyukinList.size());
		system.assertEquals(testNyukin[3].Id, controller.nyukinList[0].nyukin.Id);
		system.assert(!controller.nyukinList[0].checked);

		system.assertEquals(testNyukin[2].Id, controller.nyukinList[1].nyukin.Id);
		system.assert(!controller.nyukinList[1].checked);

		system.assertEquals(testNyukin[1].Id, controller.nyukinList[2].nyukin.Id);
		system.assert(!controller.nyukinList[2].checked);

		system.assertEquals(testNyukin[0].Id, controller.nyukinList[3].nyukin.Id);
		system.assert(!controller.nyukinList[3].checked);

		system.assertEquals(4, controller.seikyuHeaderList.size());
		system.assertEquals(testSeikyuHeader[3].Id, controller.seikyuHeaderList[0].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[0].checked);

		system.assertEquals(testSeikyuHeader[2].Id, controller.seikyuHeaderList[1].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[1].checked);

		system.assertEquals(testSeikyuHeader[1].Id, controller.seikyuHeaderList[2].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[2].checked);

		system.assertEquals(testSeikyuHeader[0].Id, controller.seikyuHeaderList[3].seikyuHeader.Id);
		system.assert(!controller.seikyuHeaderList[3].checked);

//		system.assertEquals(0, controller.checkedNyukingakuTotal);
//		system.assertEquals(0, controller.checkedSeikyugakuTotal);

		system.assertEquals(1, Apexpages.getMessages().size());
		system.assertEquals('選択された消し込み対象のデータが他のユーザに更新された可能性があります。', Apexpages.getMessages()[0].getSummary());
*/
    }

}