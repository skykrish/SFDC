/**
 * SitesMitsumoriKakuteiControllerクラス用テストクラス
 */
@isTest
private class TestSitesMitsumoriKakuteiController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        // テスト用顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;

        // テスト用担当者データ作成
        Contact testCon = new Contact(LastName='Test', AccountId = testAcc.Id);
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[] {
        	new Anken__c(KokyakuName__c=testAcc.Id, Status__c='受注', MitsumoriDateTime__c=Datetime.now(), MitsumoriReplyDate__c=Datetime.now()),
        	new Anken__c(KokyakuName__c=testAcc.Id, Status__c='見積回答待ち', MitsumoriDateTime__c=Datetime.now().addMonths(-2), MitsumoriReplyDate__c=null),
        	new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み', MitsumoriDateTime__c=Datetime.now(), MitsumoriReplyDate__c=null),
        	new Anken__c(KokyakuName__c=testAcc.Id, Status__c='見積回答待ち', MitsumoriDateTime__c=Datetime.now(), MitsumoriReplyDate__c=null),
        	new Anken__c(KokyakuName__c=testAcc.Id, Status__c='見積回答待ち', MitsumoriDateTime__c=Datetime.now(), MitsumoriReplyDate__c=null)
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
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 3999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[3].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-04', Tanka__c = 4999, Suryo__c = 4, TaxRate__c = 0.05, Waribikiritsu__c = 25, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[4].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-05', Tanka__c = 5999, Suryo__c = 5, TaxRate__c = 0.05, Waribikiritsu__c = 30, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // 見積自動確定：エラー（リクエストパラメータなし）
        SitesMitsumoriKakuteiController controller_err_1 = new SitesMitsumoriKakuteiController();
        controller_err_1.init();

        // 見積自動確定：エラー（復号化失敗）
        String criptKey_err2 = 'xxxxxxxxxxxxxxx';
        ApexPages.currentPage().getParameters().put('aid', criptKey_err2);
        ApexPages.currentPage().getParameters().put('type', 'commit');
        SitesMitsumoriKakuteiController controller_err_2 = new SitesMitsumoriKakuteiController();
        controller_err_2.init();

        // 見積自動確定：エラー（案件データなし）
        String criptKey_err_3 = Strings.encryptString('a0A1000000xxxxx' + '@' + 'xxxxxxxxxxxxxxx');
        ApexPages.currentPage().getParameters().put('aid', criptKey_err_3);
        ApexPages.currentPage().getParameters().put('type', 'commit');
        SitesMitsumoriKakuteiController controller_err_3 = new SitesMitsumoriKakuteiController();
        controller_err_3.init();

        // 見積自動確定：エラー（回答済み）
        String criptKey_err_4 = Strings.encryptString(testAnken[0].Id + '@' + testAnken[0].MitsumoriDateTime__c);
        ApexPages.currentPage().getParameters().put('aid', criptKey_err_4);
        ApexPages.currentPage().getParameters().put('type', 'commit');
        SitesMitsumoriKakuteiController controller_err_4 = new SitesMitsumoriKakuteiController();
        controller_err_4.init();

        // 見積自動確定：エラー（有効期限切れ）
        String criptKey_err_5 = Strings.encryptString(testAnken[1].Id + '@' + testAnken[1].MitsumoriDateTime__c);
        ApexPages.currentPage().getParameters().put('aid', criptKey_err_5);
        ApexPages.currentPage().getParameters().put('type', 'commit');
        SitesMitsumoriKakuteiController controller_err_5 = new SitesMitsumoriKakuteiController();
        controller_err_5.init();

        // 見積自動確定：エラー（ステータス不正）
        String criptKey_err_6 = Strings.encryptString(testAnken[2].Id + '@' + testAnken[2].MitsumoriDateTime__c);
        ApexPages.currentPage().getParameters().put('aid', criptKey_err_6);
        ApexPages.currentPage().getParameters().put('type', 'commit');
        SitesMitsumoriKakuteiController controller_err_6 = new SitesMitsumoriKakuteiController();
        controller_err_6.init();

        // 見積自動確定：正常（受注）
        String criptKey_ok_1 = Strings.encryptString(testAnken[3].Id + '@' + testAnken[3].MitsumoriDateTime__c);
        ApexPages.currentPage().getParameters().put('aid', criptKey_ok_1);
        ApexPages.currentPage().getParameters().put('type', 'commit');
        SitesMitsumoriKakuteiController controller_ok_1 = new SitesMitsumoriKakuteiController();
        controller_ok_1.init();

        // 見積自動確定：正常（キャンセル）
        String criptKey_ok_2 = Strings.encryptString(testAnken[4].Id + '@' + testAnken[4].MitsumoriDateTime__c);
        ApexPages.currentPage().getParameters().put('aid', criptKey_ok_2);
        ApexPages.currentPage().getParameters().put('type', 'cancel');
        SitesMitsumoriKakuteiController controller_ok_2 = new SitesMitsumoriKakuteiController();
        controller_ok_2.init();

        // テスト終了
        Test.stopTest();
    }
}