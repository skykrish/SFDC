/**
 * ShiireKingakuRegisterControllerクラス用テストクラス
 */
@isTest
private class TestShiireKingakuRegisterController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テストユーザ取得
        List<User> testUser = [SELECT Id, UserName FROM User WHERE UserRoleId = '00E10000000Zwco' AND IsActive = true];

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;
        
        // テスト用案件データ
        Anken__c testAnken = New Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注');
        insert testAnken;
        
        // テスト発注情報作成
        HachuInfo__c testHachuInfo = new HachuInfo__c(Name=testAnken.Name + '-1', Anken__c=testAnken.Id, Hachusaki__c=testUser[0].Id);
        insert testHachuInfo;
        
        // テスト用作業データ取得
        List<Sagyo__c> testSagyo = [SELECT Id FROM Sagyo__c WHERE Name='00000001'];
        if(testSagyo == null){
            testSagyo[0] = New Sagyo__c(Name = '001G',Nanido__c='G',SagyoBunrui__c='メイン作業',SagyoName__c='作業名001G',SagyoNaiyo__c='作業内容001G',Teika__c=180);
            insert testSagyo;
        }
        
        // 発注先仕入価格作成
        HachusakiShiireKakaku__c testShiireKakaku = new HachusakiShiireKakaku__c(Sagyo__c=testSagyo[0].Id, Hachusaki__c=testUser[0].Id, ShiireKakaku__c=100);
        insert testShiireKakaku;

        // リクエストパラメータ設定
        ApexPages.currentPage().getParameters().put('hid', testHachuInfo.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/' + testHachuInfo.Id);

        // 仕入金額登録
        ShiireKingakuRegisterController controller = new ShiireKingakuRegisterController();
        // 初期化
        controller.init();
        // 登録１：入力チェックエラー（処理対象チェックなし）
        controller.save();
        for (Integer i = 0; i < controller.shiireKingakuList.size(); i ++) {
            controller.shiireKingakuList[i].checked = true;
        }
        // 登録２：正常
        controller.save();
        // キャンセル
        controller.cancel();

        // テスト終了
        Test.stopTest();
    }
}