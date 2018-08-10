/**
 * SendMitsumorisyoControllerクラス用テストクラス
 */
@isTest
private class TestSendMitsumorisyoController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email='test@test.com');
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', KokyakuTantosya_Main__c=testCon.Id, KokyakuTantosya_CC1__c=testCon.Id, KokyakuTantosya_CC2__c=testCon.Id, KokyakuTantosya_CC3__c=testCon.Id, KokyakuTantosya_CC4__c=testCon.Id, SendImmediateFlag__c=true);
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

        // 見積書送付：PDF送付処理
        SendMitsumorisyoController controller = new SendMitsumorisyoController();
        controller.initCheck();
        controller.sendPdf();

        // テスト終了
        Test.stopTest();
    }

	/**
	 * リストビュー用
	 */
    static testMethod void myUnitTest2() {

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
			new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', KokyakuTantosya_Main__c=testCon[0].Id ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true),
			new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', KokyakuTantosya_Main__c=testCon[1].Id, KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id, MitsumoriTantosya__c=user[0].Id, SendImmediateFlag__c=true)
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

        // 見積書送付：PDF送付処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        SendMitsumorisyoController controller = new SendMitsumorisyoController(ssc);
        controller.initCheckAll();
        controller.sendPdf();
        controller.cancel();

        // テスト終了
        Test.stopTest();
    }

    /**
     * リストビュー(選択ゼロ件)用
     */
    static testMethod void myUnitTest3() {

        try{

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
                new Contact(LastName='Test1', AccountId = testAcc[0].Id),
                new Contact(LastName='Test2', AccountId = testAcc[1].Id)
            };
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', SendImmediateFlag__c=true)
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

            // 納品書送付：PDF送付処理
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
            SendMitsumorisyoController controller = new SendMitsumorisyoController(ssc);
            controller.initCheckAll();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());

        }finally{
            //
            Test.stopTest();
        }
    }

    /**
     * リストビュー(選択MAX件超過)用
     */
    static testMethod void myUnitTest4() {

        try{

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
                new Contact(LastName='Test1', AccountId = testAcc[0].Id),
                new Contact(LastName='Test2', AccountId = testAcc[1].Id)
            };
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注', SendImmediateFlag__c=true)
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

            // 納品書送付：PDF送付処理
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
            ssc.setSelected(testAnken);
            SendMitsumorisyoController controller = new SendMitsumorisyoController(ssc);
            controller.initCheckAll();
            controller.cancel();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());

        }finally{
            //
            Test.stopTest();
        }
    }
    
    // 案件の「即時送信フラグ」がfalseの場合
    static testMethod void myUnitTest5() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id, Email='test@test.com');
        insert testCon;

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', KokyakuTantosya_Main__c=testCon.Id, KokyakuTantosya_CC1__c=testCon.Id, KokyakuTantosya_CC2__c=testCon.Id, KokyakuTantosya_CC3__c=testCon.Id, KokyakuTantosya_CC4__c=testCon.Id);
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

        // 見積書送付：PDF送付処理
        SendMitsumorisyoController controller = new SendMitsumorisyoController();
        controller.initCheck();
        controller.sendPdf();

        // テスト終了
        Test.stopTest();
    }
}