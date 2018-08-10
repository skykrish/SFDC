/**
 * SendNokiTsuchiControllerクラス用テストクラス
 */
@isTest
private class TestSendNokiTsuchiController {

	/**
	 * 詳細用（正常）
	 */
    static testMethod void myUnitTest1() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email='test@test.com');
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon.Id, KokyakuTantosya_CC1__c=testCon.Id, KokyakuTantosya_CC2__c=testCon.Id, KokyakuTantosya_CC3__c=testCon.Id, KokyakuTantosya_CC4__c=testCon.Id, SendImmediateFlag__c=true);
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 納期通知処理
        SendNokiTsuchiController controller = new SendNokiTsuchiController();
        controller.initCheck();
        controller.sendNokiTsuchi();

        // テスト終了
        Test.stopTest();
    }
    
    // 案件の「即時送信フラグ」がfalseの場合
    static testMethod void myUnitTest1_02() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email='test@test.com');
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon.Id, KokyakuTantosya_CC1__c=testCon.Id, KokyakuTantosya_CC2__c=testCon.Id, KokyakuTantosya_CC3__c=testCon.Id, KokyakuTantosya_CC4__c=testCon.Id, SendImmediateFlag__c=false);
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 納期通知処理
        SendNokiTsuchiController controller = new SendNokiTsuchiController();
        controller.initCheck();
        controller.sendNokiTsuchi();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * 詳細用（異常：顧客担当者（主）が未設定）
	 */
    static testMethod void myUnitTest2() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', SendImmediateFlag__c=true);
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 納期通知処理
        SendNokiTsuchiController controller = new SendNokiTsuchiController();
        controller.initCheck();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * 詳細用（異常：顧客担当者（主）のメールアドレスが未設定）
	 */
    static testMethod void myUnitTest3() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon.Id, KokyakuTantosya_CC1__c=testCon.Id, KokyakuTantosya_CC2__c=testCon.Id, KokyakuTantosya_CC3__c=testCon.Id, KokyakuTantosya_CC4__c=testCon.Id, SendImmediateFlag__c=true);
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 納期通知処理
        SendNokiTsuchiController controller = new SendNokiTsuchiController();
        controller.initCheck();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * 詳細用（異常：納期が未設定、ステータスロックがtrue）
	 */
    static testMethod void myUnitTest4() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email='test@test.com');
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', StatusLock__c = true, KokyakuTantosya_Main__c=testCon.Id, KokyakuTantosya_CC1__c=testCon.Id, KokyakuTantosya_CC2__c=testCon.Id, KokyakuTantosya_CC3__c=testCon.Id, KokyakuTantosya_CC4__c=testCon.Id, SendImmediateFlag__c=true);
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken.Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 納期通知処理
        SendNokiTsuchiController controller = new SendNokiTsuchiController();
        controller.initCheck();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * リストビュー用（正常）
	 */
    static testMethod void myUnitTest5() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
        	new Account(Name='Test1'),
        	new Account(Name='Test2')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[]{
        	new Contact(LastName='Test1', AccountId = testAcc[0].Id, Email='test@test.co.jp'),
        	new Contact(LastName='Test2', AccountId = testAcc[1].Id, Email='test@test.co.jp')
        };
        insert testCon;

        // ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true)
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

        // 納期通知処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        SendNokiTsuchiController controller = new SendNokiTsuchiController(ssc);
        controller.initCheckAll();
        controller.sendNokiTsuchi();
        controller.cancel();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * リストビュー用（異常：選択件数が0件）
	 */
    static testMethod void myUnitTest6() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
        	new Account(Name='Test1'),
        	new Account(Name='Test2')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[]{
        	new Contact(LastName='Test1', AccountId = testAcc[0].Id, Email='test@test.co.jp'),
        	new Contact(LastName='Test2', AccountId = testAcc[1].Id, Email='test@test.co.jp')
        };
        insert testCon;

        // ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true)
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

        // 納期通知処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        SendNokiTsuchiController controller = new SendNokiTsuchiController(ssc);
        controller.initCheckAll();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * リストビュー用（異常：選択件数が上限以上）
	 */
    static testMethod void myUnitTest7() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
        	new Account(Name='Test1'),
        	new Account(Name='Test2')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[]{
        	new Contact(LastName='Test1', AccountId = testAcc[0].Id, Email='test@test.co.jp'),
        	new Contact(LastName='Test2', AccountId = testAcc[1].Id, Email='test@test.co.jp')
        };
        insert testCon;

        //ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true)
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[3].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[4].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[5].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[6].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[7].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[8].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[9].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[10].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[11].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[12].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[13].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[14].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[15].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[16].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[17].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[18].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[19].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[20].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[21].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[22].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[23].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[24].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[25].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

        // 納期通知処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        SendNokiTsuchiController controller = new SendNokiTsuchiController(ssc);
        controller.initCheckAll();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * リストビュー用（異常：顧客担当者（主）が未設定）
	 */
    static testMethod void myUnitTest8() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
        	new Account(Name='Test1'),
        	new Account(Name='Test2')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[]{
        	new Contact(LastName='Test1', AccountId = testAcc[0].Id, Email='test@test.co.jp'),
        	new Contact(LastName='Test2', AccountId = testAcc[1].Id, Email='test@test.co.jp')
        };
        insert testCon;

        //ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true)
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

        // 納期通知処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        SendNokiTsuchiController controller = new SendNokiTsuchiController(ssc);
        controller.initCheckAll();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * リストビュー用（異常：納期が未設定、ステータスロックがtrue）
	 */
    static testMethod void myUnitTest9() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
        	new Account(Name='Test1'),
        	new Account(Name='Test2')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[]{
        	new Contact(LastName='Test1', AccountId = testAcc[0].Id, Email='test@test.co.jp'),
        	new Contact(LastName='Test2', AccountId = testAcc[1].Id, Email='test@test.co.jp')
        };
        insert testCon;

        //ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', StatusLock__c = true, KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', Nouki_Date__c = Date.newInstance(2012, 1, 6), Nouki_Time__c = '15:00', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true)
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

        // 納期通知処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        SendNokiTsuchiController controller = new SendNokiTsuchiController(ssc);
        controller.initCheckAll();

        // テスト終了
        Test.stopTest();
    }
}