/**
 * NyukinTriggerHandlerクラス用テストクラス
 */
@isTest
private class TestNyukinTriggerHandler {

	private static String LINE_SEPARATOR_CR = '\r';
	private static String LINE_SEPARATOR_LF = '\n';

	static testMethod void myUnitTest() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
			new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444')
		};
		insert testAcc;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[1].Id, FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 200000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].id, NyukinType__c = '銀行振り込み', NyukinDate__c = System.today(), Nyukingaku__c = 100000, FurikomiIraininNo__c = '2222222', Status__c = '新規')
		};

		// テスト開始
		Test.startTest();

		// 入金登録
		insert testNyukin;

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Nyukinsaki__c ,
												NyukinType__c ,
												NyukinDate__c ,
												Nyukingaku__c ,
												TegataKijitsu__c ,
												Tekiyo__c ,
												FurikomiIraininNo__c ,
												Status__c,
												Keshikomibi__c,
												InsertMethod__c
												FROM Nyukin__c];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

		// アサーション
		for(Integer i = 0; i < testNyukin.size(); i++){
			Nyukin__c nyukin = testNyukin[i];
			if(resultNyukinMap.containsKey(nyukin.Id)){
				Nyukin__c resultNyukin = resultNyukinMap.get(nyukin.Id);
				system.assertEquals(testacc[0].Id, resultNyukin.Nyukinsaki__c);
				system.assertEquals(100000, resultNyukin.Nyukingaku__c);
				system.assertEquals('消し込み済み', resultNyukin.Status__c);
				system.assertNotEquals(null, resultNyukin.Keshikomibi__c);
				system.assertEquals('銀行振り込み', resultNyukin.NyukinType__c);
				system.assertEquals(null, resultNyukin.TegataKijitsu__c);
				system.assertEquals(null, resultNyukin.Tekiyo__c);
				system.assertEquals('MANUAL', resultNyukin.InsertMethod__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i = 0; i < testSeikyuHeader.size(); i++){
			SeikyuHeader__c sh = testSeikyuHeader[i];
			if(resultShMap.containsKey(sh.id)){
				SeikyuHeader__c resultSh = resultShMap.get(sh.id);
				if(i == 0){
					system.assertEquals('入金済み', resultSh.NyukinStatus__c);
					system.assertNotEquals(null, resultSh.Keshikomibi__c);
				}else{
					system.assertEquals('未入金', resultSh.NyukinStatus__c);
					system.assertEquals(null, resultSh.Keshikomibi__c);
				}
			}else{
				system.assert(false);
			}
		}

    }

	static testMethod void myUnitTest2() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
			new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444')
		};
		insert testAcc;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[1].Id, FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 200000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].id, NyukinType__c = '銀行振り込み', NyukinDate__c = System.today(), Nyukingaku__c = 100000, FurikomiIraininNo__c = '2222222', Status__c = '新規')
		};

		// テスト開始
		Test.startTest();

		// 入金登録
		insert testNyukin;

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Nyukinsaki__c ,
												NyukinType__c ,
												NyukinDate__c ,
												Nyukingaku__c ,
												TegataKijitsu__c ,
												Tekiyo__c ,
												FurikomiIraininNo__c ,
												Status__c,
												Keshikomibi__c,
												InsertMethod__c
												FROM Nyukin__c];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

		// アサーション
		for(Integer i = 0; i < testNyukin.size(); i++){
			Nyukin__c nyukin = testNyukin[i];
			if(resultNyukinMap.containsKey(nyukin.Id)){
				Nyukin__c resultNyukin = resultNyukinMap.get(nyukin.Id);
				system.assertEquals(testacc[0].Id, resultNyukin.Nyukinsaki__c);
				system.assertEquals(100000, resultNyukin.Nyukingaku__c);
				system.assertEquals('消し込み済み', resultNyukin.Status__c);
				system.assertNotEquals(null, resultNyukin.Keshikomibi__c);
				system.assertEquals('銀行振り込み', resultNyukin.NyukinType__c);
				system.assertEquals(null, resultNyukin.TegataKijitsu__c);
				system.assertEquals(null, resultNyukin.Tekiyo__c);
				system.assertEquals('MANUAL', resultNyukin.InsertMethod__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i = 0; i < testSeikyuHeader.size(); i++){
			SeikyuHeader__c sh = testSeikyuHeader[i];
			if(resultShMap.containsKey(sh.id)){
				SeikyuHeader__c resultSh = resultShMap.get(sh.id);
				if(i == 1){
					system.assertEquals('入金済み', resultSh.NyukinStatus__c);
					system.assertNotEquals(null, resultSh.Keshikomibi__c);
				}else{
					system.assertEquals('未入金', resultSh.NyukinStatus__c);
					system.assertEquals(null, resultSh.Keshikomibi__c);
				}
			}else{
				system.assert(false);
			}
		}

    }

    static testMethod void myUnitTest3() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
			new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444')
		};
		insert testAcc;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[1].Id, FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 200000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].id, NyukinType__c = '銀行振り込み', NyukinDate__c = System.today(), Nyukingaku__c = 300000, FurikomiIraininNo__c = '2222222', Status__c = '新規')
		};

		// テスト開始
		Test.startTest();

		// 入金登録
		insert testNyukin;

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Nyukinsaki__c ,
												NyukinType__c ,
												NyukinDate__c ,
												Nyukingaku__c ,
												TegataKijitsu__c ,
												Tekiyo__c ,
												FurikomiIraininNo__c ,
												Status__c,
												Keshikomibi__c,
												InsertMethod__c
												FROM Nyukin__c];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

		// アサーション
		for(Integer i = 0; i < testNyukin.size(); i++){
			Nyukin__c nyukin = testNyukin[i];
			if(resultNyukinMap.containsKey(nyukin.Id)){
				Nyukin__c resultNyukin = resultNyukinMap.get(nyukin.Id);
				system.assertEquals(testacc[0].Id, resultNyukin.Nyukinsaki__c);
				system.assertEquals(300000, resultNyukin.Nyukingaku__c);
				system.assertEquals('新規', resultNyukin.Status__c);
				system.assertEquals(null, resultNyukin.Keshikomibi__c);
				system.assertEquals('銀行振り込み', resultNyukin.NyukinType__c);
				system.assertEquals(null, resultNyukin.TegataKijitsu__c);
				system.assertEquals(null, resultNyukin.Tekiyo__c);
				system.assertEquals('MANUAL', resultNyukin.InsertMethod__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i = 0; i < testSeikyuHeader.size(); i++){
			SeikyuHeader__c sh = testSeikyuHeader[i];
			if(resultShMap.containsKey(sh.id)){
				SeikyuHeader__c resultSh = resultShMap.get(sh.id);
				system.assertEquals('未入金', resultSh.NyukinStatus__c);
				system.assertEquals(null, resultSh.Keshikomibi__c);
			}else{
				system.assert(false);
			}
		}

    }

	static testMethod void myUnitTest4() {

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
			new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444')
		};
		insert testAcc;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[1].Id, FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 200000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// テスト用入金データ作成
		Nyukin__c[] testNyukin = new Nyukin__c[]{
			new Nyukin__c(Nyukinsaki__c = testAcc[0].id, NyukinType__c = '銀行振り込み', NyukinDate__c = System.today(), Nyukingaku__c = 100000, FurikomiIraininNo__c = '2222222', Status__c = '新規'),
			new Nyukin__c(Nyukinsaki__c = testAcc[0].id, NyukinType__c = '銀行振り込み', NyukinDate__c = System.today(), Nyukingaku__c = 100000, FurikomiIraininNo__c = '2222222', Status__c = '新規')
		};

		// テスト開始
		Test.startTest();

		// 入金登録
		insert testNyukin;

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Nyukinsaki__c ,
												NyukinType__c ,
												NyukinDate__c ,
												Nyukingaku__c ,
												TegataKijitsu__c ,
												Tekiyo__c ,
												FurikomiIraininNo__c ,
												Status__c,
												Keshikomibi__c,
												InsertMethod__c
												FROM Nyukin__c];
		Map<Id, Nyukin__c> resultNyukinMap = new Map<Id, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.Id, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

		// アサーション
		for(Integer i = 0; i < testNyukin.size(); i++){
			Nyukin__c nyukin = testNyukin[i];
			if(resultNyukinMap.containsKey(nyukin.Id)){
				Nyukin__c resultNyukin = resultNyukinMap.get(nyukin.Id);
				if(i == 0){
					system.assertEquals('消し込み済み', resultNyukin.Status__c);
					system.assertNotEquals(null, resultNyukin.Keshikomibi__c);
				}else{
					system.assertEquals('新規', resultNyukin.Status__c);
					system.assertEquals(null, resultNyukin.Keshikomibi__c);
				}
				system.assertEquals(testacc[0].Id, resultNyukin.Nyukinsaki__c);
				system.assertEquals(100000, resultNyukin.Nyukingaku__c);
				system.assertEquals('銀行振り込み', resultNyukin.NyukinType__c);
				system.assertEquals(null, resultNyukin.TegataKijitsu__c);
				system.assertEquals(null, resultNyukin.Tekiyo__c);
				system.assertEquals('MANUAL', resultNyukin.InsertMethod__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i = 0; i < testSeikyuHeader.size(); i++){
			SeikyuHeader__c sh = testSeikyuHeader[i];
			if(resultShMap.containsKey(sh.id)){
				SeikyuHeader__c resultSh = resultShMap.get(sh.id);
				if(i == 0){
					system.assertEquals('入金済み', resultSh.NyukinStatus__c);
					system.assertNotEquals(null, resultSh.Keshikomibi__c);
				}else{
					system.assertEquals('未入金', sh.NyukinStatus__c);
					system.assertEquals(null, sh.Keshikomibi__c);
				}
			}else{
				system.assert(false);
			}
		}

    }

	static testMethod void myUnitTest5() {

        // 顧客データ削除
//      delete [SELECT Id FROM Account];

		// テスト用顧客データ作成
		Account[] testAcc = new Account[]{
			new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
			new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444')
		};
		insert testAcc;

		// テスト用案件データ
		Anken__c[] testAnken = new Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
		};
		insert testAnken;

		// テスト用請求ヘッダデータ作成
		SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
			new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
		};
		insert testSeikyuHeader;

		// テスト用請求データ作成
		Seikyu__c[] testSeikyu = new Seikyu__c[]{
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id),
			new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[1].id)
		};
		insert testSeikyu;

		// テスト用請求明細データ作成
		SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0),
			new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0)
		};
		insert testSeikyuMeisai;

		// CSV取込データ作成
		String[] datas = new String[]{
			'\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"100000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
			'\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230702\",\"200000\",\"0\",\"3334444444\",\"ｶ)ｻﾝﾌﾟﾙ2                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"'
		};
		String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
		for(Integer i = 0; i < datas.size(); i++){
			data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + datas[i];
		}

		// テスト用ドキュメントデータ作成
		Document document = new Document(Body = Blob.valueOf(data));

		// 入金データの削除
//		List<Nyukin__c> deleteNyukinList = [SELECT id FROM Nyukin__c];
//		delete deleteNyukinList;

		// テスト開始
		Test.startTest();

		// 入金自動登録：チェック処理
		ApexPages.StandardController sController = new ApexPages.StandardController(document);
		NyukinJidoRegisterController controller = new NyukinJidoRegisterController(sController);
		controller.check();
		controller.register();

		// テスト終了
		Test.stopTest();

		// 登録した入金データを取得
		List<Nyukin__c> resultNyukinList = [SELECT id ,
												Nyukinsaki__c ,
												NyukinType__c ,
												NyukinDate__c ,
												Nyukingaku__c ,
												TegataKijitsu__c ,
												Tekiyo__c ,
												FurikomiIraininNo__c ,
												Status__c,
												Keshikomibi__c,
												InsertMethod__c
												FROM Nyukin__c];
		Map<Date, Nyukin__c> resultNyukinMap = new Map<Date, Nyukin__c>();
		for(Nyukin__c resultNyukin :resultNyukinList){
			resultNyukinMap.put(resultNyukin.NyukinDate__c, resultNyukin);
		}

		// 登録した請求ヘッダデータを取得
		List<SeikyuHeader__c> resultShList = [SELECT id,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c];
		Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
		for(SeikyuHeader__c resultSh :resultShList){
			resultShMap.put(resultSh.Id, resultSh);
		}

		// アサーション
		for(Integer i = 0; i < datas.size(); i++){
			Date nyukindate = Date.newInstance(2011, 07, 01 + i);
			if(resultNyukinMap.containsKey(nyukindate)){
				Nyukin__c resultNyukin = resultNyukinMap.get(nyukindate);
				if(i == 0){
					system.assertEquals(testacc[0].Id, resultNyukin.Nyukinsaki__c);
					system.assertEquals(100000, resultNyukin.Nyukingaku__c);
					system.assertEquals('消し込み済み', resultNyukin.Status__c);
					system.assertNotEquals(null, resultNyukin.Keshikomibi__c);

				}else{
					system.assertEquals(testacc[1].Id, resultNyukin.Nyukinsaki__c);
					system.assertEquals(200000, resultNyukin.Nyukingaku__c);
					system.assertEquals('新規', resultNyukin.Status__c);
					system.assertEquals(null, resultNyukin.Keshikomibi__c);
				}
				system.assertEquals('銀行振り込み', resultNyukin.NyukinType__c);
				system.assertEquals(null, resultNyukin.TegataKijitsu__c);
				system.assertEquals(null, resultNyukin.Tekiyo__c);
				system.assertEquals('AUTO', resultNyukin.InsertMethod__c);
			}else{
				system.assert(false);
			}
		}

		for(Integer i = 0; i < testSeikyuHeader.size(); i++){
			SeikyuHeader__c sh = testSeikyuHeader[i];
			if(resultShMap.containsKey(sh.id)){
				SeikyuHeader__c resultSh = resultShMap.get(sh.id);
				if(i == 1){
					system.assertEquals('入金済み', resultSh.NyukinStatus__c);
					system.assertNotEquals(null, resultSh.Keshikomibi__c);
				}else{
					system.assertEquals('未入金', sh.NyukinStatus__c);
					system.assertEquals(null, sh.Keshikomibi__c);
				}
			}else{
				system.assert(false);
			}
		}

    }

}