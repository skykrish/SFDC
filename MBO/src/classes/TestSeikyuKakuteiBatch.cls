/**
 * SeikyuKakuteiBatchクラス用テストクラス
 */
@isTest
private class TestSeikyuKakuteiBatch {

    static testMethod void myUnitTest_15() {

        // テスト開始
        Test.StartTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            //201601 add
            new Account(Name='Test2', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ', FurikomiBankName_SMBC__c='テスト銀行', FurikomiShitenName_SMBC__c='テスト支店', FurikomiShitenCd_SMBC__c='000', FurikomiKozaType_SMBC__c='普通', FurikomiKozaNo_SMBC__c='1234567', FurikomiKozaName_SMBC__c='ﾃｽﾄ')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp'),
            //201601 add
            new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='test@test.co.jp')
        };
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            //201601 add
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0))
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
            //201601 add
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 10, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // テスト用入金データ作成
        Nyukin__c[] testNyukin = New Nyukin__c[]{
            New Nyukin__c(Nyukinsaki__c = testAcc[0].Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 10, Status__c = '新規', Offset_Flg__c = true),
            //201601 add
            New Nyukin__c(Nyukinsaki__c = testAcc[1].Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 10, Status__c = '新規', Offset_Flg__c = true)
        };
        insert testNyukin;

        // バッチ実行日付設定
        BatchExecDate__c[] testExecDate = [SELECT Id, Name, ShimeGroup__c, Shimebi__c FROM BatchExecDate__c WHERE ShimeGroup__c='15日'];
        if(testExecDate != null){
            testExecDate[0].Shimebi__c = Date.newInstance(2011, 1, 15);
            update testExecDate;
        }else {
            testExecDate[0] = New BatchExecDate__c(Name = '15日', ShimeGroup__c = '15日', Shimebi__c = Date.newInstance(2011, 1, 15));
            insert testExecDate;
        }

        // 請求確定バッチ起動（15日締め）
        SeikyuKakuteiBatch batch_15 = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_15);
        Database.executebatch(batch_15, 200);

        // テスト終了
        Test.StopTest();
    }

    static testMethod void myUnitTest_15_2() {

        // テスト開始
        Test.StartTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp')
        };
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0))
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 10, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // テスト用入金データ作成
        Nyukin__c[] testNyukin = New Nyukin__c[]{
            New Nyukin__c(Nyukinsaki__c = testAcc[0].Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 1000, Status__c = '新規', Offset_Flg__c = true)
        };
        insert testNyukin;

        // バッチ実行日付設定
        BatchExecDate__c[] testExecDate = [SELECT Id, Name, ShimeGroup__c, Shimebi__c FROM BatchExecDate__c WHERE ShimeGroup__c='15日'];
        if(testExecDate != null){
            testExecDate[0].Shimebi__c = Date.newInstance(2011, 1, 15);
            update testExecDate;
        }else {
            testExecDate[0] = New BatchExecDate__c(Name = '15日', ShimeGroup__c = '15日', Shimebi__c = Date.newInstance(2011, 1, 15));
            insert testExecDate;
        }

        // 請求確定バッチ起動（15日締め）
        SeikyuKakuteiBatch batch_15 = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_15);
        Database.executebatch(batch_15, 200);

        // テスト終了
        Test.StopTest();
    }

    static testMethod void myUnitTest_20() {

        // テスト開始
        Test.StartTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='20日', KaisyuCycle__c='翌月', KaisyuDate__c='10日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp')
        };
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0))
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 10, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // バッチ実行日付設定
        BatchExecDate__c[] testExecDate = [SELECT Id, Name, ShimeGroup__c, Shimebi__c FROM BatchExecDate__c WHERE ShimeGroup__c='20日'];
        if(testExecDate != null){
            testExecDate[0].Shimebi__c = Date.newInstance(2011, 1, 20);
            update testExecDate;
        }else {
            testExecDate[0] = New BatchExecDate__c(Name = '20日', ShimeGroup__c = '20日', Shimebi__c = Date.newInstance(2011, 1, 20));
            insert testExecDate;
        }

        // 請求確定バッチ起動（20日締め）
        SeikyuKakuteiBatch batch_20 = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_20);
        Database.executebatch(batch_20, 200);

        // テスト終了
        Test.StopTest();
    }


    static testMethod void myUnitTest_25() {

        // テスト開始
        Test.StartTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='25日', KaisyuCycle__c='翌月', KaisyuDate__c='10日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp')
        };
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0))
        };
        insert testAnken;

        // テスト用作業データ作成
        Sagyo__c[] testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',SagyoNaiyo__c='作業内容999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 0, Suryo__c = 1, TaxRate__c = 0.05, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;
        
        // バッチ実行日付設定
        BatchExecDate__c[] testExecDate = [SELECT Id, Name, ShimeGroup__c, Shimebi__c FROM BatchExecDate__c WHERE ShimeGroup__c='25日'];
        if(testExecDate != null){
            testExecDate[0].Shimebi__c = Date.newInstance(2011, 1, 25);
            update testExecDate;
        }else {
            testExecDate[0] = New BatchExecDate__c(Name = '25日', ShimeGroup__c = '25日', Shimebi__c = Date.newInstance(2011, 1, 25));
            insert testExecDate;
        }

        // 請求確定バッチ起動（25日締め）
        SeikyuKakuteiBatch batch_25 = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_25);
        Database.executebatch(batch_25, 200);

        // テスト終了
        Test.StopTest();
    }
    static testMethod void myUnitTest_end() {

        // テスト開始
        Test.StartTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='末日', KaisyuCycle__c='翌々月', KaisyuDate__c='15日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            new Account(Name='Test2', TorihikiKbn__c='掛売上', ShimeGroup__c='末日', KaisyuCycle__c='翌々々月', KaisyuDate__c='末日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp'),
            new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='test@test.co.jp')
        };
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0))
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
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 20, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // バッチ実行日付設定
        BatchExecDate__c[] testExecDate = [SELECT Id, Name, ShimeGroup__c, Shimebi__c FROM BatchExecDate__c WHERE ShimeGroup__c='末日'];
        if(testExecDate != null){
            testExecDate[0].Shimebi__c = Date.newInstance(2011, 1, 31);
            update testExecDate;
        }else {
            testExecDate[0] = New BatchExecDate__c(Name = '末日', ShimeGroup__c = '末日', Shimebi__c = Date.newInstance(2011, 1, 31));
            insert testExecDate;
        }

        // 請求確定バッチ起動（末日締め）
        SeikyuKakuteiBatch batch_end = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_END);
        Database.executebatch(batch_end, 200);

        // テスト終了
        Test.StopTest();
    }
    
    // 請求先送り日対象案件
    static testMethod void myUnitTest01() {

        // テスト開始
        Test.StartTest();

        // テスト用顧客データ作成
        Account[] testAcc = new Account[] {
            new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='末日', KaisyuCycle__c='翌々月', KaisyuDate__c='15日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ'),
            new Account(Name='Test2', TorihikiKbn__c='掛売上', ShimeGroup__c='末日', KaisyuCycle__c='翌々々月', KaisyuDate__c='末日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
            new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp'),
            new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='test@test.co.jp')
        };
        insert testCon;

        // テスト用案件データ
        Anken__c[] testAnken = New Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0)),
            
            // 請求先送り日設定
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='受注納品済み', NohinDateTime__c=Datetime.newInstance(2011, 1, 1, 0, 0, 0),SeikyuSkipDate__c=Date.newInstance(2014,1,1))
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
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 20, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // バッチ実行日付設定
        BatchExecDate__c[] testExecDate = [SELECT Id, Name, ShimeGroup__c, Shimebi__c FROM BatchExecDate__c WHERE ShimeGroup__c='末日'];
        if(testExecDate != null){
            testExecDate[0].Shimebi__c = Date.newInstance(2011, 1, 31);
            update testExecDate;
        }else {
            testExecDate[0] = New BatchExecDate__c(Name = '末日', ShimeGroup__c = '末日', Shimebi__c = Date.newInstance(2011, 1, 31));
            insert testExecDate;
        }

        // 請求確定バッチ起動（末日締め）
        SeikyuKakuteiBatch batch_end = new SeikyuKakuteiBatch(SeikyuKakuteiBatch.SHIME_GROUP_END);
        Database.executebatch(batch_end, 200);

        // テスト終了
        Test.StopTest();
    }
}