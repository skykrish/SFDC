/**
 * SeikyuKakuteiControllerクラス用テストクラス
 */
@isTest
private class TestSeikyuKakuteiController {

    static testMethod void myUnitTest() {

        // テスト開始
        Test.startTest();

        //ユーザ取得
        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND IsActive = true];

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            new Account(Name='Test2', TorihikiKbn__c='掛売上', ShimeGroup__c='20日', KaisyuCycle__c='翌月', KaisyuDate__c='10日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            new Account(Name='Test3', TorihikiKbn__c='掛売上', ShimeGroup__c='末日', KaisyuCycle__c='翌々月', KaisyuDate__c='15日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            new Account(Name='Test4', TorihikiKbn__c='掛売上', ShimeGroup__c='都度', KaisyuCycle__c='翌々々月', KaisyuDate__c='末日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            new Account(Name='Test5', TorihikiKbn__c='クレジットカード', ShimeGroup__c='クレジットカード'),
            new Account(Name='Test6', TorihikiKbn__c=null, ShimeGroup__c='15日'),
            new Account(Name='Test7', TorihikiKbn__c='掛売上', ShimeGroup__c='25日', KaisyuCycle__c='当月', KaisyuDate__c='末日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            //*201501 add
            new Account(Name='Test8', TorihikiKbn__c='掛売上', ShimeGroup__c='末日', KaisyuCycle__c='翌月', KaisyuDate__c='末日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            //201601 add
            new Account(Name='Test9', TorihikiKbn__c='掛売上', ShimeGroup__c='末日', KaisyuCycle__c='翌月', KaisyuDate__c='末日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ', FurikomiBankName_SMBC__c='テスト銀行', FurikomiShitenName_SMBC__c='テスト支店', FurikomiShitenCd_SMBC__c='000', FurikomiKozaType_SMBC__c='普通', FurikomiKozaNo_SMBC__c='1234567', FurikomiKozaName_SMBC__c='ﾃｽﾄ')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp'),
            new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='test@test.co.jp'),
            new Contact(LastName='Test3', AccountId=testAcc[2].Id, email='test@test.co.jp'),
            new Contact(LastName='Test4', AccountId=testAcc[3].Id, email='test@test.co.jp'),
            new Contact(LastName='Test5', AccountId=testAcc[4].Id, email='test@test.co.jp'),
            new Contact(LastName='Test6', AccountId=testAcc[4].Id, email='test@test.co.jp'),
            new Contact(LastName='Test7', AccountId=testAcc[6].Id, email='test@test.co.jp'),
            //*201501 add
            new Contact(LastName='Test8', AccountId=testAcc[7].Id, email='test@test.co.jp'),
            //201601 add
            new Contact(LastName='Test9', AccountId=testAcc[8].Id, email='test@test.co.jp')
            
        };
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            new Anken__c(KokyakuName__c=testAcc[2].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            new Anken__c(KokyakuName__c=testAcc[3].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            new Anken__c(KokyakuName__c=testAcc[4].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            new Anken__c(KokyakuName__c=testAcc[5].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            new Anken__c(KokyakuName__c=testAcc[6].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            //*201501 add
            new Anken__c(KokyakuName__c=testAcc[7].Id, Status__c='受注納品済み',SeikyuSkipDate__c=Date.newInstance(2015, 1, 21) , NohinDateTime__c=Datetime.newInstance(2015, 1, 20, 0, 0, 0)),
            //201601 add
            new Anken__c(KokyakuName__c=testAcc[8].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0))
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 10, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 20, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-03', Tanka__c = 30, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[3].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-04', Tanka__c = 40, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[4].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-05', Tanka__c = 50, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[5].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-05', Tanka__c = 50, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[6].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-05', Tanka__c = 50, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            //201601 add
            New AnkenMeisai__c(Anken__c = testAnken[8].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-05', Tanka__c = 50, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // テスト用入金データ作成
        Nyukin__c[] testNyukin = New Nyukin__c[]{
            New Nyukin__c(Nyukinsaki__c = testAcc[0].Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 10, Status__c = '新規', Offset_Flg__c = true)
        };
        insert testNyukin;

        // 請求確定
        SeikyuKakuteiController controller = new SeikyuKakuteiController();
        // 条件ありで検索１
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索２
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索３
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索４
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索５
        controller.criteria.Seikyusaki__c = testAcc[1].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '20日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索６
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '25日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索７
        controller.criteria.Seikyusaki__c = testAcc[2].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '末日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索８
        controller.criteria.Seikyusaki__c = testAcc[3].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '都度';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索９
        controller.criteria.Seikyusaki__c = testAcc[3].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = 'クレジットカード';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        // 条件ありで検索１０
        controller.criteria.Seikyusaki__c = testAcc[3].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '都度';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '13';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        //*201501 add start
        // 条件ありで検索１１
        controller.criteria.Seikyusaki__c = testAcc[7].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '末日';
        controller.criteria.SeikyuYear__c = '2015';
        controller.criteria.SeikyuMonth__c = '01';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        //*201501 add end
        
        //201601 add start
        // 条件ありで検索１２
        controller.criteria.Seikyusaki__c = testAcc[8].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.ShimeGroup__c = '末日';
        controller.criteria.SeikyuYear__c = '2015';
        controller.criteria.SeikyuMonth__c = '01';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        //*201601 add end

        // ソート１
        controller.sortData();
        // ソート２
        controller.sortExpression = 'KokyakuName__r.ShimeGroup__c';
        controller.sortData();
        // 請求確定１：入力チェックエラー（チェックなし）
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        controller.seikyuFix();
        // 請求確定２：入力チェックエラー（請求情報なし）
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        // 請求確定３：正常（15日）
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();

        // 請求確定４：正常（20日）
        controller.criteria.Seikyusaki__c = testAcc[1].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '20日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();

        // 請求確定５：正常（25日）
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '25日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();

        // 請求確定６：正常（末日）
        controller.criteria.Seikyusaki__c = testAcc[2].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '末日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();

        // 請求確定７：正常（都度）
        controller.criteria.Seikyusaki__c = testAcc[3].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '都度';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();

        // 請求確定７：正常（クレジットカード）
        controller.criteria.Seikyusaki__c = testAcc[4].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = 'クレジットカード';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '10';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();

         //*201501 add start
        // 請求確定６：正常（末日）
        controller.criteria.Seikyusaki__c = testAcc[7].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '末日';
        controller.criteria.SeikyuYear__c = '2015';
        controller.criteria.SeikyuMonth__c = '01';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();
        //*201501 add end
        
         //*201601 add start
        // 請求確定９：正常（末日）SMBC入力あり
        controller.criteria.Seikyusaki__c = testAcc[8].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.ShimeGroup__c = '末日';
        controller.criteria.SeikyuYear__c = '2015';
        controller.criteria.SeikyuMonth__c = '01';
        controller.criteria.SeikyuDay__c = '1';
        controller.ankenSearch();
        for (Integer i = 0; i < controller.ankenList.size(); i ++) {
            controller.ankenList[i].checked = true;
        }
        controller.seikyuFix();
        controller.createPdf();
        //*201601 add end
        
        // テスト終了
        Test.stopTest();
    }
}