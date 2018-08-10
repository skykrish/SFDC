/**
 * SeikyusyoControllerクラス用テストクラス
 */
@isTest
private class TestSeikyusyoController {

    /**
     * 明細あり
     */
    static testMethod void myUnitTest() {

        try{
            // テスト開始
            Test.startTest();

            // テスト用顧客データ作成
            Account testAcc = new Account(Name='Test');
            insert testAcc;

            // テスト用担当者データ作成
            Contact testCon = new Contact(LastName='Test', AccountId=testAcc.Id,email='test@test.co.jp');
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み'),
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
                New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
            };
            insert testAnkenMeisai;

            // テスト用入金データ作成
            Nyukin__c[] testNyukin = New Nyukin__c[]{
                New Nyukin__c(Nyukinsaki__c = testAcc.Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 2000, Status__c = '相殺済み', Offset_Flg__c = true)
            };
            insert testNyukin;

            //テスト用請求ヘッダデータ
            SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
                new SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiName__c='テスト請求先'),
                new SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiName__c='テスト請求先')
            };
            insert testSeikyuHeader;

            // テスト用請求データ
            Seikyu__c[] testSeikyu = New Seikyu__c[]{
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken[0].Id),
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[1].Id, DenpyoNo__c=testAnken[1].Id),
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, OffsetNyukin__c=testNyukin[0].Id, Offset_Flg__c=true)
            };
            insert testSeikyu;

            // テスト用請求明細データ
            SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[2].Id, Tanka__c=-2000, Suryo__c=1, TaxRate__c=0)
            };
            insert testSeikyuMeisai;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('shid', testSeikyuHeader[0].Id + ',' + testSeikyuHeader[1].Id);

            // 請求書：初期化処理
            SeikyusyoController controller = new SeikyusyoController();
            controller.init();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
            //
            Test.stopTest();
        }
    }

    /**
     * 明細なし
     */
    static testMethod void myUnitTest2() {
        try{
            // テスト開始
            Test.startTest();

            // テスト用顧客データ作成
            Account testAcc = new Account(Name='Test');
            insert testAcc;

            // テスト用担当者データ作成
            Contact testCon = new Contact(LastName='Test', AccountId=testAcc.Id,email='test@test.co.jp');
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み'),
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
                New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
            };
            insert testAnkenMeisai;

            // テスト用入金データ作成
            Nyukin__c[] testNyukin = New Nyukin__c[]{
                New Nyukin__c(Nyukinsaki__c = testAcc.Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 2000, Status__c = '相殺済み', Offset_Flg__c = true)
            };
            insert testNyukin;

            //テスト用請求ヘッダデータ
            SeikyuHeader__c testSeikyuHeader = new SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiName__c='テスト請求先７８９０１２３４５６７８９０１');
            insert testSeikyuHeader;

            // テスト用請求データ
            Seikyu__c[] testSeikyu = New Seikyu__c[]{
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader.Id, DenpyoNo__c=testAnken[0].Id),
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader.Id, DenpyoNo__c=testAnken[1].Id),
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader.Id, OffsetNyukin__c=testNyukin[0].Id, Offset_Flg__c=true)
            };
            insert testSeikyu;

            // テスト用請求明細データ作成
            SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
                New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[2].Id, Tanka__c=-2000, Suryo__c=1, TaxRate__c=0)
            };
            insert testSeikyuMeisai;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('shid', testSeikyuHeader.Id);

            // 請求書：初期化処理
            SeikyusyoController controller = new SeikyusyoController();
            controller.init();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
            //
            Test.stopTest();
        }
    }
    
    /**
     * 明細あり(明細数15以上)
     */
    static testMethod void myUnitTest3() {

        try{
            // テスト開始
            Test.startTest();

            // テスト用顧客データ作成
            Account testAcc = new Account(Name='Test');
            insert testAcc;

            // テスト用担当者データ作成
            Contact testCon = new Contact(LastName='Test', AccountId=testAcc.Id,email='test@test.co.jp');
            insert testCon;

            // テスト用案件データ
            Anken__c[] testAnken = New Anken__c[]{
                new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み'),
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
                New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-04', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-05', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
                New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-06', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05, Waribikiritsu__c = 20, MitsumoriFlg__c = true)
            };
            insert testAnkenMeisai;

            // テスト用入金データ作成
            Nyukin__c[] testNyukin = New Nyukin__c[]{
                New Nyukin__c(Nyukinsaki__c = testAcc.Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 2000, Status__c = '相殺済み', Offset_Flg__c = true)
            };
            insert testNyukin;

            //テスト用請求ヘッダデータ
            SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
                new SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiName__c='テスト請求先'),
                new SeikyuHeader__c(Seikyusaki__c=testAcc.Id, SeikyusakiName__c='テスト請求先')
            };
            insert testSeikyuHeader;

            // テスト用請求データ
            Seikyu__c[] testSeikyu = New Seikyu__c[]{
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken[0].Id),
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[1].Id, DenpyoNo__c=testAnken[1].Id),
                new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, OffsetNyukin__c=testNyukin[0].Id, Offset_Flg__c=true)
            };
            insert testSeikyu;

            // テスト用請求明細データ
            SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].Id, SagyoCd__c='999', SagyoName__c = '作業名999Z-03', Tanka__c = 2999, Suryo__c = 3, TaxRate__c = 0.05),
                New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[2].Id, Tanka__c=-2000, Suryo__c=1, TaxRate__c=0)
            };
            insert testSeikyuMeisai;

            // リクエストパラメータ設定
            ApexPages.currentPage().getParameters().put('shid', testSeikyuHeader[0].Id + ',' + testSeikyuHeader[1].Id);

            // 請求書：初期化処理
            SeikyusyoController controller = new SeikyusyoController();
            controller.init();

        }catch(exception e){
            System.debug('システム例外' + e.getMessage());
        }finally{
            //
            Test.stopTest();
        }
    }
}