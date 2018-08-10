/**
 * SoufujoControllerクラス用テストクラス
 */
@isTest
private class TestSoufujoController {

    static testMethod void myUnitTest() {

        try{
            // テスト開始
            Test.startTest();

            // テスト用顧客データ作成
            Account testAcc = new Account(Name='Test');
            insert testAcc;

            // テスト用担当者データ作成
            Contact testCon = new Contact(LastName='Test', AccountId=testAcc.Id,email='test@test.co.jp', SeikyuTantoFlg__c=true);
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み')
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
                New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
            };
            insert testAnkenMeisai;

            //テスト用請求ヘッダデータ
            SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
                new SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiName__c='テスト請求先'),
                new SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiName__c='テスト請求先７８９０１２３４５６７８９０１')
            };
            insert testSeikyuHeader;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('shid', testSeikyuHeader[0].Id + ',' + testSeikyuHeader[1].Id);

            // 送付状：初期化処理
            SoufujoController controller = new SoufujoController();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
            //
            Test.stopTest();
        }
    }
}