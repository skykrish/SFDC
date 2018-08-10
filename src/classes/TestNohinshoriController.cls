/**
 * NohinshoriControllerクラス用テストクラス
 */
@isTest
private class TestNohinshoriController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='見積受付', InvoicePersonnel__c = null);
        insert testAnken;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 納品書送付：PDF送付処理
        NohinshoriController controller = new NohinshoriController();
        controller.init();
        controller.updateAnken();
        controller.closeCompiled();

        // テスト終了
        Test.stopTest();

    }
    
    static testMethod void myUnitTest1_2() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='見積受付', InvoicePersonnel__c=null, StatusLock__c=true);
        insert testAnken;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

        // 納品書送付：PDF送付処理
        NohinshoriController controller = new NohinshoriController();
        controller.init();
        controller.updateAnken();
        controller.closeCompiled();

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
            new Account(Name='Test'),
            new Account(Name='Test2')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[]{
            new Contact(LastName='Test', AccountId = testAcc[0].Id,Email='test@test.co.jp'),
            new Contact(LastName='Test2', AccountId = testAcc[1].Id,Email='test@test.co.jp')
        };
        insert testCon;

        //ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='納品処理中',KokyakuTantosya_Main__c=testCon[0].Id
                                        ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id
                                        ,NohinTantosya__c=user[0].Id,NohinDateTime__c=datetime.now(), SendImmediateFlag__c=true),
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中',KokyakuTantosya_Main__c=testCon[1].Id
                                        ,KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id
                                        ,NohinTantosya__c=user[0].Id,NohinDateTime__c=datetime.now(), SendImmediateFlag__c=true)
        };
        insert testAnken;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

        // 納品書送付：PDF送付処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        NohinshoriController controller = new NohinshoriController(ssc);
        controller.initCheckAll();
        controller.updateAnken();
        controller.closeCompiled();

        // テスト終了
        Test.stopTest();
    }
    
        /**
    * リストビュー用
    */
    static testMethod void myUnitTest2_2() {
        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name='Test'),
            new Account(Name='Test2')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[]{
            new Contact(LastName='Test', AccountId = testAcc[0].Id,Email='test@test.co.jp'),
            new Contact(LastName='Test2', AccountId = testAcc[1].Id,Email='test@test.co.jp')
        };
        insert testCon;

        //ユーザ取得
        User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='納品処理中',KokyakuTantosya_Main__c=testCon[0].Id
                                        ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id
                                        ,NohinTantosya__c=user[0].Id,NohinDateTime__c=datetime.now(), SendImmediateFlag__c=true, StatusLock__c=true),
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中',KokyakuTantosya_Main__c=testCon[1].Id
                                        ,KokyakuTantosya_CC1__c=testCon[1].Id, KokyakuTantosya_CC2__c=testCon[1].Id, KokyakuTantosya_CC3__c=testCon[1].Id, KokyakuTantosya_CC4__c=testCon[1].Id
                                        ,NohinTantosya__c=user[0].Id,NohinDateTime__c=datetime.now(), SendImmediateFlag__c=true, StatusLock__c=true)
        };
        insert testAnken;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

        // 納品書送付：PDF送付処理
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
        ssc.setSelected(testAnken);
        NohinshoriController controller = new NohinshoriController(ssc);
        controller.initCheckAll();
        controller.updateAnken();
        controller.closeCompiled();

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
                new Account(Name='Test'),
                new Account(Name='Test2')
            };
            insert testAcc;

            // テスト用担当者データ作成
            Contact[] testCon = new Contact[]{
                new Contact(LastName='Test', AccountId = testAcc[0].Id),
                new Contact(LastName='Test2', AccountId = testAcc[1].Id)
            };
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true)
            };
            insert testAnken;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

            // 納品書送付：PDF送付処理
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
            NohinshoriController controller = new NohinshoriController(ssc);
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
                new Account(Name='Test'),
                new Account(Name='Test2')
            };
            insert testAcc;

            // テスト用担当者データ作成
            Contact[] testCon = new Contact[]{
                new Contact(LastName='Test', AccountId = testAcc[0].Id),
                new Contact(LastName='Test2', AccountId = testAcc[1].Id)
            };
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中', SendImmediateFlag__c=true)
            };
            insert testAnken;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

            // 納品書送付：PDF送付処理
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
            ssc.setSelected(testAnken);
            NohinshoriController controller = new NohinshoriController(ssc);
            controller.initCheckAll();
            controller.closeCompiled();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
            //
            Test.stopTest();
        }

    }

    /**
    * リストビュー用(事前チェックエラー)
    */
    static testMethod void myUnitTest5() {

        try{
            // テスト開始
            Test.startTest();

            // テスト用顧客データ作成
            Account[] testAcc = new Account[]{
                new Account(Name='Test'),
                new Account(Name='Test2')
            };
            insert testAcc;

            // テスト用担当者データ作成
            Contact[] testCon = new Contact[]{
                new Contact(LastName='Test', AccountId = testAcc[0].Id),
                new Contact(LastName='Test2', AccountId = testAcc[1].Id)
            };
            insert testCon;

            // ユーザ取得
            User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='納品処理中',KokyakuTantosya_Main__c=testCon[0].Id
                                            ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id
                                            , SendImmediateFlag__c=true),
                new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='納品処理中',KokyakuTantosya_Main__c=testCon[0].Id
                                            ,KokyakuTantosya_CC1__c=testCon[0].Id, KokyakuTantosya_CC2__c=testCon[0].Id, KokyakuTantosya_CC3__c=testCon[0].Id, KokyakuTantosya_CC4__c=testCon[0].Id
                                            , SendImmediateFlag__c=true)
            };
            insert testAnken;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken[0].Id);

            // 納品書送付：PDF送付処理
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(testAnken);
            ssc.setSelected(testAnken);
            NohinshoriController controller = new NohinshoriController(ssc);
            controller.initCheckAll();
            controller.updateAnken();
            controller.closeCompiled();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
            //
            Test.stopTest();
        }

    }

    /**
    * 案件詳細用(事前チェックエラー)
    */
    static testMethod void myUnitTest6() {

        try{
            // テスト開始
            Test.startTest();

            // テスト用顧客データ作成
            Account testAcc = new Account(Name='Test');
            insert testAcc;

            // テスト用担当者データ作成
            Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
            insert testCon;

            // ユーザ取得
            User[] user = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND UserRoleId != null AND IsActive = true];

            // テスト用案件データ
            Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='納品処理中',KokyakuTantosya_Main__c=testCon.Id
                                            ,KokyakuTantosya_CC1__c=testCon.Id, KokyakuTantosya_CC2__c=testCon.Id, KokyakuTantosya_CC3__c=testCon.Id, KokyakuTantosya_CC4__c=testCon.Id
                                            , SendImmediateFlag__c=true);
            insert testAnken;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('aid', testAnken.Id);
            ApexPages.currentPage().getParameters().put('retURL', '/' + testAnken.Id);

            // 納品書送付：PDF送付処理
            NohinshoriController controller = new NohinshoriController();
            controller.initCheckAll();
            controller.updateAnken();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
            //
            Test.stopTest();
        }

    }

}