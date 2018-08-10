/**
 * NyukinJidoRegisterControllerクラス用テストクラス
 */
@isTest
private class TestNyukinJidoRegisterController {

    private static String LINE_SEPARATOR_CR = '\r';
    private static String LINE_SEPARATOR_LF = '\n';

    static testMethod void myUnitTest() {

        // 顧客データ削除
//      delete [SELECT Id FROM Account];

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
            new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444'),
            new Account(Name = 'Test3', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444')
        };
        insert testAcc;

        // CSV取込データ作成
        String[] datas = new String[]{
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"3334444444\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"5556666666\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"23070\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"23070a\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"999999\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"1234567890123456789\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"12345678a\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"a23456789012345678\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"12345678901234567a\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"111\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"a234567890\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"123456789a\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"1112222222\",\"\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\"'
        };
        String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
        for(Integer i = 0; i < datas.size(); i++){
            data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + datas[i];
        }

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterController controller = new NyukinJidoRegisterController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();

        // アサーション
        system.assertEquals(18, controller.getNyukinList().size());
        system.assertEquals(1, controller.getNyukinList()[0].no);
        system.assertEquals(testAcc[0].Id, controller.getNyukinList()[0].id);
        system.assertEquals('230701', controller.getNyukinList()[0].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[0].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[0].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[0].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[0].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[0].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[0].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[0].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[0].torikomi);
        system.assertEquals('', controller.getNyukinList()[0].hikiate);

        system.assertEquals(2, controller.getNyukinList()[1].no);
        system.assertEquals(null, controller.getNyukinList()[1].id);
        system.assertEquals('230701', controller.getNyukinList()[1].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[1].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[1].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[1].nyukinkingakuDisp);
        system.assertEquals('3334444444', controller.getNyukinList()[1].furikomiiraininNo);
        system.assertEquals('333', controller.getNyukinList()[1].furikomiShitenCd);
        system.assertEquals('4444444', controller.getNyukinList()[1].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[1].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[1].torikomi);
        system.assertEquals('', controller.getNyukinList()[1].hikiate);

        system.assertEquals(3, controller.getNyukinList()[2].no);
        system.assertEquals(null, controller.getNyukinList()[2].id);
        system.assertEquals('230701', controller.getNyukinList()[2].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[2].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[2].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[2].nyukinkingakuDisp);
        system.assertEquals('5556666666', controller.getNyukinList()[2].furikomiiraininNo);
        system.assertEquals('555', controller.getNyukinList()[2].furikomiShitenCd);
        system.assertEquals('6666666', controller.getNyukinList()[2].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[2].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[2].torikomi);
        system.assertEquals('', controller.getNyukinList()[2].hikiate);

        system.assertEquals(4, controller.getNyukinList()[3].no);
        system.assertEquals(null, controller.getNyukinList()[3].id);
        system.assertEquals('', controller.getNyukinList()[3].torihikiDate);
        system.assertEquals('', controller.getNyukinList()[3].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[3].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[3].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[3].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[3].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[3].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[3].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[3].torikomi);
        system.assertEquals('', controller.getNyukinList()[3].hikiate);

        system.assertEquals(5, controller.getNyukinList()[4].no);
        system.assertEquals(null, controller.getNyukinList()[4].id);
        system.assertEquals('23070', controller.getNyukinList()[4].torihikiDate);
        system.assertEquals('23070', controller.getNyukinList()[4].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[4].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[4].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[4].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[4].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[4].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[4].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[4].torikomi);
        system.assertEquals('', controller.getNyukinList()[4].hikiate);

        system.assertEquals(6, controller.getNyukinList()[5].no);
        system.assertEquals(null, controller.getNyukinList()[5].id);
        system.assertEquals('23070a', controller.getNyukinList()[5].torihikiDate);
        system.assertEquals('23070a', controller.getNyukinList()[5].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[5].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[5].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[5].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[5].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[5].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[5].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[5].torikomi);
        system.assertEquals('', controller.getNyukinList()[5].hikiate);

        system.assertEquals(7, controller.getNyukinList()[6].no);
        system.assertEquals(null, controller.getNyukinList()[6].id);
        system.assertEquals('999999', controller.getNyukinList()[6].torihikiDate);
        system.assertEquals('999999', controller.getNyukinList()[6].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[6].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[6].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[6].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[6].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[6].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[6].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[6].torikomi);
        system.assertEquals('', controller.getNyukinList()[6].hikiate);

        system.assertEquals(8, controller.getNyukinList()[7].no);
        system.assertEquals(null, controller.getNyukinList()[7].id);
        system.assertEquals('230701', controller.getNyukinList()[7].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[7].torihikiDateDisp);
        system.assertEquals('', controller.getNyukinList()[7].nyukinkingaku);
        system.assertEquals('', controller.getNyukinList()[7].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[7].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[7].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[7].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[7].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[7].torikomi);
        system.assertEquals('', controller.getNyukinList()[7].hikiate);

        system.assertEquals(9, controller.getNyukinList()[8].no);
        system.assertEquals(null, controller.getNyukinList()[8].id);
        system.assertEquals('230701', controller.getNyukinList()[8].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[8].torihikiDateDisp);
        system.assertEquals('1234567890123456789', controller.getNyukinList()[8].nyukinkingaku);
        system.assertEquals('1234567890123456789', controller.getNyukinList()[8].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[8].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[8].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[8].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[8].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[8].torikomi);
        system.assertEquals('', controller.getNyukinList()[8].hikiate);

        system.assertEquals(10, controller.getNyukinList()[9].no);
        system.assertEquals(null, controller.getNyukinList()[9].id);
        system.assertEquals('230701', controller.getNyukinList()[9].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[9].torihikiDateDisp);
        system.assertEquals('12345678a', controller.getNyukinList()[9].nyukinkingaku);
        system.assertEquals('12345678a', controller.getNyukinList()[9].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[9].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[9].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[9].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[9].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[9].torikomi);
        system.assertEquals('', controller.getNyukinList()[9].hikiate);

        system.assertEquals(11, controller.getNyukinList()[10].no);
        system.assertEquals(null, controller.getNyukinList()[10].id);
        system.assertEquals('230701', controller.getNyukinList()[10].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[10].torihikiDateDisp);
        system.assertEquals('a23456789012345678', controller.getNyukinList()[10].nyukinkingaku);
        system.assertEquals('a23456789012345678', controller.getNyukinList()[10].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[10].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[10].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[10].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[10].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[10].torikomi);
        system.assertEquals('', controller.getNyukinList()[10].hikiate);

        system.assertEquals(12, controller.getNyukinList()[11].no);
        system.assertEquals(null, controller.getNyukinList()[11].id);
        system.assertEquals('230701', controller.getNyukinList()[11].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[11].torihikiDateDisp);
        system.assertEquals('12345678901234567a', controller.getNyukinList()[11].nyukinkingaku);
        system.assertEquals('12345678901234567a', controller.getNyukinList()[11].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[11].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[11].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[11].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[11].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[11].torikomi);
        system.assertEquals('', controller.getNyukinList()[11].hikiate);

        system.assertEquals(13, controller.getNyukinList()[12].no);
        system.assertEquals(null, controller.getNyukinList()[12].id);
        system.assertEquals('230701', controller.getNyukinList()[12].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[12].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[12].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[12].nyukinkingakuDisp);
        system.assertEquals('', controller.getNyukinList()[12].furikomiiraininNo);
        system.assertEquals(null, controller.getNyukinList()[12].furikomiShitenCd);
        system.assertEquals(null, controller.getNyukinList()[12].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[12].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[12].torikomi);
        system.assertEquals('', controller.getNyukinList()[12].hikiate);

        system.assertEquals(14, controller.getNyukinList()[13].no);
        system.assertEquals(null, controller.getNyukinList()[13].id);
        system.assertEquals('230701', controller.getNyukinList()[13].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[13].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[13].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[13].nyukinkingakuDisp);
        system.assertEquals('111', controller.getNyukinList()[13].furikomiiraininNo);
        system.assertEquals(null, controller.getNyukinList()[13].furikomiShitenCd);
        system.assertEquals(null, controller.getNyukinList()[13].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[13].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[13].torikomi);
        system.assertEquals('', controller.getNyukinList()[13].hikiate);

        system.assertEquals(15, controller.getNyukinList()[14].no);
        system.assertEquals(null, controller.getNyukinList()[14].id);
        system.assertEquals('230701', controller.getNyukinList()[14].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[14].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[14].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[14].nyukinkingakuDisp);
        system.assertEquals('a234567890', controller.getNyukinList()[14].furikomiiraininNo);
        system.assertEquals(null, controller.getNyukinList()[14].furikomiShitenCd);
        system.assertEquals(null, controller.getNyukinList()[14].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[14].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[14].torikomi);
        system.assertEquals('', controller.getNyukinList()[14].hikiate);

        system.assertEquals(16, controller.getNyukinList()[15].no);
        system.assertEquals(null, controller.getNyukinList()[15].id);
        system.assertEquals('230701', controller.getNyukinList()[15].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[15].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[15].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[15].nyukinkingakuDisp);
        system.assertEquals('123456789a', controller.getNyukinList()[15].furikomiiraininNo);
        system.assertEquals(null, controller.getNyukinList()[15].furikomiShitenName);
        system.assertEquals(null, controller.getNyukinList()[15].furikomiShitenCd);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[15].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[15].torikomi);
        system.assertEquals('', controller.getNyukinList()[15].hikiate);

        system.assertEquals(17, controller.getNyukinList()[16].no);
        system.assertEquals(null, controller.getNyukinList()[16].id);
        system.assertEquals('230701', controller.getNyukinList()[16].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[16].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[16].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[16].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[16].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[16].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[16].furikomiKozaNo);
        system.assertEquals('', controller.getNyukinList()[16].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[16].torikomi);
        system.assertEquals('', controller.getNyukinList()[16].hikiate);

        system.assertEquals(18, controller.getNyukinList()[17].no);
        system.assertEquals(null, controller.getNyukinList()[17].id);
        system.assertEquals(null, controller.getNyukinList()[17].torihikiDate);
        system.assertEquals(null, controller.getNyukinList()[17].torihikiDateDisp);
        system.assertEquals(null, controller.getNyukinList()[17].nyukinkingaku);
        system.assertEquals(null, controller.getNyukinList()[17].nyukinkingakuDisp);
        system.assertEquals(null, controller.getNyukinList()[17].furikomiiraininNo);
        system.assertEquals(null, controller.getNyukinList()[17].furikomiShitenCd);
        system.assertEquals(null, controller.getNyukinList()[17].furikomiKozaNo);
        system.assertEquals(null, controller.getNyukinList()[17].furikomiiraininName);
        system.assertEquals('NG', controller.getNyukinList()[17].torikomi);
        system.assertEquals('', controller.getNyukinList()[17].hikiate);

        system.assertEquals(17, Apexpages.getMessages().size());
        system.assertEquals('行数2　：　顧客情報が複数存在します。', Apexpages.getMessages()[0].getSummary());
        system.assertEquals('行数3　：　顧客情報が存在しません。', Apexpages.getMessages()[1].getSummary());
        system.assertEquals('行数4　：　取引日が不正です。', Apexpages.getMessages()[2].getSummary());
        system.assertEquals('行数5　：　取引日が不正です。', Apexpages.getMessages()[3].getSummary());
        system.assertEquals('行数6　：　取引日が不正です。', Apexpages.getMessages()[4].getSummary());
        system.assertEquals('行数7　：　取引日が不正です。', Apexpages.getMessages()[5].getSummary());
        system.assertEquals('行数8　：　入金金額が不正です。', Apexpages.getMessages()[6].getSummary());
        system.assertEquals('行数9　：　入金金額が不正です。', Apexpages.getMessages()[7].getSummary());
        system.assertEquals('行数10　：　入金金額が不正です。', Apexpages.getMessages()[8].getSummary());
        system.assertEquals('行数11　：　入金金額が不正です。', Apexpages.getMessages()[9].getSummary());
        system.assertEquals('行数12　：　入金金額が不正です。', Apexpages.getMessages()[10].getSummary());
        system.assertEquals('行数13　：　振込依頼人番号が不正です。', Apexpages.getMessages()[11].getSummary());
        system.assertEquals('行数14　：　振込依頼人番号が不正です。', Apexpages.getMessages()[12].getSummary());
        system.assertEquals('行数15　：　振込依頼人番号が不正です。', Apexpages.getMessages()[13].getSummary());
        system.assertEquals('行数16　：　振込依頼人番号が不正です。', Apexpages.getMessages()[14].getSummary());
        system.assertEquals('行数17　：　振込依頼人名が不正です。', Apexpages.getMessages()[15].getSummary());
        system.assertEquals('行数18　：　カラム数が不正です。', Apexpages.getMessages()[16].getSummary());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest2() {

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = null);

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterController controller = new NyukinJidoRegisterController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();

        // アサーション
        system.assertEquals(0, controller.getNyukinList().size());

        system.assertEquals(0, Apexpages.getMessages().size());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest3() {

        // CSV取込データ作成(カラム名行のみ)
        String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterController controller = new NyukinJidoRegisterController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();

        // アサーション
        system.assertEquals(0, controller.getNyukinList().size());

        system.assertEquals(1, Apexpages.getMessages().size());
        system.assertEquals('CSVファイルにタイトル行しか存在しません。', Apexpages.getMessages()[0].getSummary());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest4() {

        // CSV取込データ作成(カラム名に必須項目が存在しない)
        List<String> datas = new List<STring>();
        String data1 = '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"';
        datas.add(data1);
        // 取引日項目が存在しない
        String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日AAA\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
        for(Integer i = 0; i < datas.size(); i++){
            data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + datas[i];
        }

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterController controller = new NyukinJidoRegisterController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();

        // アサーション
        system.assertEquals(0, controller.getNyukinList().size());

        system.assertEquals(1, Apexpages.getMessages().size());
        system.assertEquals('CSVファイルに必要な項目が存在しないか、またはCSVファイルがUTF-8以外の形式の可能性があります。', Apexpages.getMessages()[0].getSummary());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest5() {

        // 顧客データ削除
//      delete [SELECT Id FROM Account];

        // テスト用顧客データ作成
        Account testAcc = new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222');
        insert testAcc;

        // CSV取込データ作成(カラム名に空白項目が存在する)
        List<String> datas = new List<STring>();
        String data1 = '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"';
        datas.add(data1);
        String data = '\"金融機関コード\",\"金融機関名\",\"\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
        for(Integer i = 0; i < datas.size(); i++){
            data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + datas[i];
        }

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterController controller = new NyukinJidoRegisterController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();

        // アサーション
        system.assertEquals(1, controller.getNyukinList().size());
        system.assertEquals(1, controller.getNyukinList()[0].no);
        system.assertEquals(testAcc.Id, controller.getNyukinList()[0].id);
        system.assertEquals('230701', controller.getNyukinList()[0].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[0].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[0].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[0].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[0].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[0].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[0].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[0].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[0].torikomi);
        system.assertEquals('', controller.getNyukinList()[0].hikiate);

        system.assertEquals(0, Apexpages.getMessages().size());

        system.assertEquals(false, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest6() {

        // CSV取込データ作成(CSVのデータが上限を超えていた場合)
        String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
        for(Integer i = 0; i < Integer.valueOf(System.Label.ExecuteLimitCount_NyukinJidoRegister) + 1; i++){
            data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"300000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"';
        }

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));

        // テスト開始
        Test.startTest();

        // 入金自動登録：チェック処理
        ApexPages.StandardController sController = new ApexPages.StandardController(document);
        NyukinJidoRegisterController controller = new NyukinJidoRegisterController(sController);
        controller.check();

        // テスト終了
        Test.stopTest();

        // アサーション
        system.assertEquals(0, controller.getNyukinList().size());

        system.assertEquals(1, Apexpages.getMessages().size());
        system.assertEquals('入金自動登録処理の上限件数を超えています。上限件数は' + System.Label.ExecuteLimitCount_NyukinJidoRegister + '件です。', Apexpages.getMessages()[0].getSummary());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest7() {

        // 顧客データ削除
//      delete [SELECT Id FROM Account];

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222'),
            new Account(Name = 'Test2', FurikomiShitenCd__c = '333', FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444'),
            new Account(Name = 'Test3', FurikomiShitenCd__c = '555', FurikomiShitenName__c = 'テスト支店3', FurikomiKozaNo__c = '6666666'),
            new Account(Name = 'Test4', FurikomiShitenCd__c = '777', FurikomiShitenName__c = 'テスト支店4', FurikomiKozaNo__c = '8888888'),
            new Account(Name = 'Test5', FurikomiShitenCd__c = '999', FurikomiShitenName__c = 'テスト支店5', FurikomiKozaNo__c = '0000000')
        };
        insert testAcc;

        // テスト用案件データ
        Anken__c[] testAnken = new Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み'),
            new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み'),
            new Anken__c(KokyakuName__c=testAcc[2].Id, Status__c='請求確定済み'),
            new Anken__c(KokyakuName__c=testAcc[3].Id, Status__c='請求確定済み'),
            new Anken__c(KokyakuName__c=testAcc[4].Id, Status__c='請求確定済み')
        };
        insert testAnken;

        // テスト用請求ヘッダデータ作成
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
            new SeikyuHeader__c(Seikyusaki__c = testAcc[1].Id, FurikomiShitenName__c = 'テスト支店2', FurikomiKozaNo__c = '4444444', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
            new SeikyuHeader__c(Seikyusaki__c = testAcc[2].Id, FurikomiShitenName__c = 'テスト支店3', FurikomiKozaNo__c = '6666666', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
            new SeikyuHeader__c(Seikyusaki__c = testAcc[2].Id, FurikomiShitenName__c = 'テスト支店3', FurikomiKozaNo__c = '6666666', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
            new SeikyuHeader__c(Seikyusaki__c = testAcc[3].Id, FurikomiShitenName__c = 'テスト支店4', FurikomiKozaNo__c = '8888888', SeikyuDateTime__c = System.now().addDays(-1), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
            new SeikyuHeader__c(Seikyusaki__c = testAcc[3].Id, FurikomiShitenName__c = 'テスト支店4', FurikomiKozaNo__c = '8888888', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
            new SeikyuHeader__c(Seikyusaki__c = testAcc[3].Id, FurikomiShitenName__c = 'テスト支店4', FurikomiKozaNo__c = '8888888', SeikyuDateTime__c = System.now().addDays(-2), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE),
            new SeikyuHeader__c(Seikyusaki__c = testAcc[4].Id, FurikomiShitenName__c = 'テスト支店5', FurikomiKozaNo__c = '0000000', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = new Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[1].id),
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[1].id, DenpyoNo__c = testAnken[2].id),
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[2].id, DenpyoNo__c = testAnken[2].id),
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[3].id, DenpyoNo__c = testAnken[3].id),
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[4].id, DenpyoNo__c = testAnken[3].id),
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[5].id, DenpyoNo__c = testAnken[3].id),
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[6].id, DenpyoNo__c = testAnken[4].id)
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 200000, Suryo__c = 1, TaxRate__c = 0),
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[1].id, Tanka__c = 300000, Suryo__c = 1, TaxRate__c = 0),
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[2].id, Tanka__c = 300000, Suryo__c = 1, TaxRate__c = 0),
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[3].id, Tanka__c = 600000, Suryo__c = 1, TaxRate__c = 0),
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[4].id, Tanka__c = 600000, Suryo__c = 1, TaxRate__c = 0),
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[5].id, Tanka__c = 600000, Suryo__c = 1, TaxRate__c = 0),
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[6].id, Tanka__c = 700000, Suryo__c = 1, TaxRate__c = 0)
        };
        insert testSeikyuMeisai;

        // CSV取込データ作成
        String[] datas = new String[]{
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"100000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230702\",\"200000\",\"0\",\"3334444444\",\"ｶ)ｻﾝﾌﾟﾙ2                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230703\",\"300000\",\"0\",\"5556666666\",\"ｶ)ｻﾝﾌﾟﾙ3                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230704\",\"300000\",\"0\",\"5556666666\",\"ｶ)ｻﾝﾌﾟﾙ4                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230705\",\"300000\",\"0\",\"5556666666\",\"ｶ)ｻﾝﾌﾟﾙ5                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230706\",\"600000\",\"0\",\"7778888888\",\"ｶ)ｻﾝﾌﾟﾙ6                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"',
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230707\",\"600000\",\"0\",\"7778888888\",\"ｶ)ｻﾝﾌﾟﾙ7                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"'
        };
        String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
        for(Integer i = 0; i < datas.size(); i++){
            data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + datas[i];
        }

//        List<Nyukin__c> deleteNyukinList = [SELECT id FROM Nyukin__c];
//        delete deleteNyukinList;

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));
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
                                                FROM Nyukin__c limit 10000];
        Map<Date, Nyukin__c> resultNyukinMap = new Map<Date, Nyukin__c>();
        for(Nyukin__c resultNyukin :resultNyukinList){
            resultNyukinMap.put(resultNyukin.NyukinDate__c, resultNyukin);
        }

        // 登録した請求ヘッダデータを取得
        List<SeikyuHeader__c> resultShList = [SELECT id,
                                                    NyukinStatus__c,
                                                    Keshikomibi__c
                                                FROM SeikyuHeader__c limit 10000];
        Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
        for(SeikyuHeader__c resultSh :resultShList){
            resultShMap.put(resultSh.Id, resultSh);
        }

        // アサーション
        for(Integer i = 0; i < datas.size(); i++){
            Date nyukindate = Date.newInstance(2011, 07, 01 + i);
            if(resultNyukinMap.containsKey(nyukindate)){
                Nyukin__c nyukin = resultNyukinMap.get(nyukindate);
                if(i == 0){
                    system.assertEquals(testacc[0].Id, nyukin.Nyukinsaki__c);
                    system.assertEquals(100000, nyukin.Nyukingaku__c);
                }else if(i == 1 ){
                    system.assertEquals(testacc[1].Id, nyukin.Nyukinsaki__c);
                    system.assertEquals(200000, nyukin.Nyukingaku__c);
                }else if(i < 5){
                    system.assertEquals(testacc[2].Id, nyukin.Nyukinsaki__c);
                    system.assertEquals(300000, nyukin.Nyukingaku__c);
                }else if(i < 7){
                    system.assertEquals(testacc[3].Id, nyukin.Nyukinsaki__c);
                    system.assertEquals(600000, nyukin.Nyukingaku__c);
                }

                if(i != 0 && i != 4){
                    system.assertEquals('消し込み済み', nyukin.Status__c);
                    system.assertNotEquals(null, nyukin.Keshikomibi__c);
                }else{
                    system.assertEquals('新規', nyukin.Status__c);
                    system.assertEquals(null, nyukin.Keshikomibi__c);
                }

                system.assertEquals('銀行振り込み', nyukin.NyukinType__c);
                system.assertEquals(null, nyukin.TegataKijitsu__c);
                system.assertEquals(null, nyukin.Tekiyo__c);
                system.assertEquals('AUTO', nyukin.InsertMethod__c);
//            }else{
//                system.assert(false);
            }
        }

        for(Integer i = 0; i < testSeikyuHeader.size(); i++){
            if(resultShMap.containsKey(testSeikyuHeader[i].id)){
                SeikyuHeader__c sh = resultShMap.get(testSeikyuHeader[i].id);
                if(i != 4 && i != 6){
                    system.assertEquals('入金済み', sh.NyukinStatus__c);
                    system.assertNotEquals(null, sh.Keshikomibi__c);
                }else{
                    system.assertEquals('未入金', sh.NyukinStatus__c);
                    system.assertEquals(null, sh.Keshikomibi__c);
                }
//            }else{
//                system.assert(false);
            }
        }

        system.assertEquals(7, controller.getNyukinList().size());
        system.assertEquals(1, controller.getNyukinList()[0].no);
        system.assertEquals(testAcc[0].Id, controller.getNyukinList()[0].id);
        system.assertEquals('230701', controller.getNyukinList()[0].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[0].torihikiDateDisp);
        system.assertEquals('100000', controller.getNyukinList()[0].nyukinkingaku);
        system.assertEquals('\\100,000', controller.getNyukinList()[0].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[0].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[0].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[0].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[0].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[0].torikomi);
        system.assertEquals('NG', controller.getNyukinList()[0].hikiate);

        system.assertEquals(2, controller.getNyukinList()[1].no);
        system.assertEquals(testAcc[1].Id, controller.getNyukinList()[1].id);
        system.assertEquals('230702', controller.getNyukinList()[1].torihikiDate);
        system.assertEquals('2011/07/02', controller.getNyukinList()[1].torihikiDateDisp);
        system.assertEquals('200000', controller.getNyukinList()[1].nyukinkingaku);
        system.assertEquals('\\200,000', controller.getNyukinList()[1].nyukinkingakuDisp);
        system.assertEquals('3334444444', controller.getNyukinList()[1].furikomiiraininNo);
        system.assertEquals('333', controller.getNyukinList()[1].furikomiShitenCd);
        system.assertEquals('4444444', controller.getNyukinList()[1].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ2                                 ', controller.getNyukinList()[1].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[1].torikomi);
        system.assertEquals('OK', controller.getNyukinList()[1].hikiate);

        system.assertEquals(3, controller.getNyukinList()[2].no);
        system.assertEquals(testAcc[2].Id, controller.getNyukinList()[2].id);
        system.assertEquals('230703', controller.getNyukinList()[2].torihikiDate);
        system.assertEquals('2011/07/03', controller.getNyukinList()[2].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[2].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[2].nyukinkingakuDisp);
        system.assertEquals('5556666666', controller.getNyukinList()[2].furikomiiraininNo);
        system.assertEquals('555', controller.getNyukinList()[2].furikomiShitenCd);
        system.assertEquals('6666666', controller.getNyukinList()[2].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ3                                 ', controller.getNyukinList()[2].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[2].torikomi);
        system.assertEquals('OK', controller.getNyukinList()[2].hikiate);

        system.assertEquals(4, controller.getNyukinList()[3].no);
        system.assertEquals(testAcc[2].Id, controller.getNyukinList()[3].id);
        system.assertEquals('230704', controller.getNyukinList()[3].torihikiDate);
        system.assertEquals('2011/07/04', controller.getNyukinList()[3].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[3].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[3].nyukinkingakuDisp);
        system.assertEquals('5556666666', controller.getNyukinList()[3].furikomiiraininNo);
        system.assertEquals('555', controller.getNyukinList()[3].furikomiShitenCd);
        system.assertEquals('6666666', controller.getNyukinList()[3].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ4                                 ', controller.getNyukinList()[3].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[3].torikomi);
        system.assertEquals('OK', controller.getNyukinList()[3].hikiate);

        system.assertEquals(5, controller.getNyukinList()[4].no);
        system.assertEquals(testAcc[2].Id, controller.getNyukinList()[4].id);
        system.assertEquals('230705', controller.getNyukinList()[4].torihikiDate);
        system.assertEquals('2011/07/05', controller.getNyukinList()[4].torihikiDateDisp);
        system.assertEquals('300000', controller.getNyukinList()[4].nyukinkingaku);
        system.assertEquals('\\300,000', controller.getNyukinList()[4].nyukinkingakuDisp);
        system.assertEquals('5556666666', controller.getNyukinList()[4].furikomiiraininNo);
        system.assertEquals('555', controller.getNyukinList()[4].furikomiShitenCd);
        system.assertEquals('6666666', controller.getNyukinList()[4].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ5                                 ', controller.getNyukinList()[4].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[4].torikomi);
        system.assertEquals('NG', controller.getNyukinList()[4].hikiate);

        system.assertEquals(6, controller.getNyukinList()[5].no);
        system.assertEquals(testAcc[3].Id, controller.getNyukinList()[5].id);
        system.assertEquals('230706', controller.getNyukinList()[5].torihikiDate);
        system.assertEquals('2011/07/06', controller.getNyukinList()[5].torihikiDateDisp);
        system.assertEquals('600000', controller.getNyukinList()[5].nyukinkingaku);
        system.assertEquals('\\600,000', controller.getNyukinList()[5].nyukinkingakuDisp);
        system.assertEquals('7778888888', controller.getNyukinList()[5].furikomiiraininNo);
        system.assertEquals('777', controller.getNyukinList()[5].furikomiShitenCd);
        system.assertEquals('8888888', controller.getNyukinList()[5].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ6                                 ', controller.getNyukinList()[5].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[5].torikomi);
        system.assertEquals('OK', controller.getNyukinList()[5].hikiate);

        system.assertEquals(7, controller.getNyukinList()[6].no);
        system.assertEquals(testAcc[3].Id, controller.getNyukinList()[6].id);
        system.assertEquals('230707', controller.getNyukinList()[6].torihikiDate);
        system.assertEquals('2011/07/07', controller.getNyukinList()[6].torihikiDateDisp);
        system.assertEquals('600000', controller.getNyukinList()[6].nyukinkingaku);
        system.assertEquals('\\600,000', controller.getNyukinList()[6].nyukinkingakuDisp);
        system.assertEquals('7778888888', controller.getNyukinList()[6].furikomiiraininNo);
        system.assertEquals('777', controller.getNyukinList()[6].furikomiShitenCd);
        system.assertEquals('8888888', controller.getNyukinList()[6].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ7                                 ', controller.getNyukinList()[6].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[6].torikomi);
        system.assertEquals('OK', controller.getNyukinList()[6].hikiate);

        system.assertEquals(1, Apexpages.getMessages().size());
        system.assertEquals('入金自動登録処理が完了しました。消し込みされていないデータが存在します。', Apexpages.getMessages()[0].getSummary());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest8() {

        // 顧客データ削除
//      delete [SELECT Id FROM Account];

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name = 'Test1', FurikomiShitenCd__c = '111', FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222')
        };
        insert testAcc;

        // CSV取込データ作成
        String[] datas = new String[]{
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"100000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"'
        };
        String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
        for(Integer i = 0; i < datas.size(); i++){
            data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + datas[i];
        }

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));
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
                                                FROM Nyukin__c limit 10000];
        Map<Date, Nyukin__c> resultNyukinMap = new Map<Date, Nyukin__c>();
        for(Nyukin__c resultNyukin :resultNyukinList){
            resultNyukinMap.put(resultNyukin.NyukinDate__c, resultNyukin);
        }

        // アサーション
        Date nyukindate = Date.newInstance(2011, 07, 01);
        if(resultNyukinMap.containsKey(nyukindate)){
            Nyukin__c nyukin = resultNyukinMap.get(nyukindate);
            system.assertEquals(testacc[0].Id, nyukin.Nyukinsaki__c);
            system.assertEquals(100000, nyukin.Nyukingaku__c);
            system.assertEquals('新規', nyukin.Status__c);
            system.assertEquals(null, nyukin.Keshikomibi__c);
            system.assertEquals('銀行振り込み', nyukin.NyukinType__c);
            system.assertEquals(null, nyukin.TegataKijitsu__c);
            system.assertEquals(null, nyukin.Tekiyo__c);
            system.assertEquals('AUTO', nyukin.InsertMethod__c);
//        }else{
//            system.assert(false);
        }

        system.assertEquals(1, controller.getNyukinList().size());
        system.assertEquals(1, controller.getNyukinList()[0].no);
        system.assertEquals(testAcc[0].Id, controller.getNyukinList()[0].id);
        system.assertEquals('230701', controller.getNyukinList()[0].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[0].torihikiDateDisp);
        system.assertEquals('100000', controller.getNyukinList()[0].nyukinkingaku);
        system.assertEquals('\\100,000', controller.getNyukinList()[0].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[0].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[0].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[0].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[0].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[0].torikomi);
        system.assertEquals('NG', controller.getNyukinList()[0].hikiate);

        system.assertEquals(1, Apexpages.getMessages().size());
        system.assertEquals('入金自動登録処理が完了しました。消し込みされていないデータが存在します。', Apexpages.getMessages()[0].getSummary());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }

    static testMethod void myUnitTest9() {

        // 顧客データ削除
//      delete [SELECT Id FROM Account];

        // テスト用顧客データ作成
        Account[] testAcc = new Account[]{
            new Account(Name = 'Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c = 'テスト支店1', FurikomiShitenCd__c = '111', FurikomiKozaType__c='普通', FurikomiKozaNo__c = '2222222', FurikomiKozaName__c='ﾃｽﾄ1')
        };
        insert testAcc;

        // テスト用案件データ
        Anken__c[] testAnken = new Anken__c[]{
            new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み')
        };
        insert testAnken;

        // テスト用請求ヘッダデータ作成
        SeikyuHeader__c[] testSeikyuHeader = new SeikyuHeader__c[]{
            new SeikyuHeader__c(Seikyusaki__c = testAcc[0].Id, FurikomiShitenName__c = 'テスト支店1', FurikomiKozaNo__c = '2222222', SeikyuDateTime__c = System.now(), SeikyuStatus__c = '請求済み', NyukinStatus__c = '未入金', Del_Flg__c = FALSE)
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = new Seikyu__c[]{
            new Seikyu__c(SeikyusyoNo__c = testSeikyuHeader[0].id, DenpyoNo__c = testAnken[0].id)
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = new SeikyuMeisai__c[]{
            new SeikyuMeisai__c(SeikyuNo__c = testSeikyu[0].id, Tanka__c = 100000, Suryo__c = 1, TaxRate__c = 0)
        };
        insert testSeikyuMeisai;

        // CSV取込データ作成
        String[] datas = new String[]{
            '\"5\",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"351\",\"ﾎﾝｺﾞｳ          \",\"1\",\"69532\",\"ｶ)ﾒﾃﾞｲｱﾊﾞ，ｵﾌｲｽ                         \",\"230701\",\"100000\",\"0\",\"1112222222\",\"ｶ)ｻﾝﾌﾟﾙ1                                 \",\"ﾐﾂﾋﾞｼﾄｳｷﾖｳUFJ  \",\"ﾎﾝｺﾞｳ          \",\"                    \",\"0\"'
        };
        String data = '\"金融機関コード\",\"金融機関名\",\"支店コード\",\"支店名\",\"科目\",\"口座番号\",\"口座名\",\"取引日\",\"入金金額\",\"内他店券金額\",\"振込依頼人番号\",\"振込依頼人名\",\"仕向金融機関名\",\"仕向支店名\",\"ＥＤＩ情報\",\"取消区分\"';
        for(Integer i = 0; i < datas.size(); i++){
            data += LINE_SEPARATOR_CR + LINE_SEPARATOR_LF + datas[i];
        }

        // テスト用ドキュメントデータ作成
        Document document = new Document(Body = Blob.valueOf(data));
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
                                                FROM Nyukin__c limit 10000];
        Map<Date, Nyukin__c> resultNyukinMap = new Map<Date, Nyukin__c>();
        for(Nyukin__c resultNyukin :resultNyukinList){
            resultNyukinMap.put(resultNyukin.NyukinDate__c, resultNyukin);
        }

        // 登録した請求ヘッダデータを取得
        List<SeikyuHeader__c> resultShList = [SELECT id,
                                                    NyukinStatus__c,
                                                    Keshikomibi__c
                                                FROM SeikyuHeader__c limit 10000];
        Map<Id, SeikyuHeader__c> resultShMap = new Map<Id, SeikyuHeader__c>();
        for(SeikyuHeader__c resultSh :resultShList){
            resultShMap.put(resultSh.Id, resultSh);
        }

        // アサーション
        Date nyukindate = Date.newInstance(2011, 07, 01);
        if(resultNyukinMap.containsKey(nyukindate)){
            Nyukin__c nyukin = resultNyukinMap.get(nyukindate);
            system.assertEquals(testacc[0].Id, nyukin.Nyukinsaki__c);
            system.assertEquals(100000, nyukin.Nyukingaku__c);
            system.assertEquals('消し込み済み', nyukin.Status__c);
            system.assertNotEquals(null, nyukin.Keshikomibi__c);
            system.assertEquals('銀行振り込み', nyukin.NyukinType__c);
            system.assertEquals(null, nyukin.TegataKijitsu__c);
            system.assertEquals(null, nyukin.Tekiyo__c);
            system.assertEquals('AUTO', nyukin.InsertMethod__c);
//        }else{
//            system.assert(false);
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
//            }else{
//                system.assert(false);
            }
        }

        system.assertEquals(1, controller.getNyukinList().size());
        system.assertEquals(1, controller.getNyukinList()[0].no);
        system.assertEquals(testAcc[0].Id, controller.getNyukinList()[0].id);
        system.assertEquals('230701', controller.getNyukinList()[0].torihikiDate);
        system.assertEquals('2011/07/01', controller.getNyukinList()[0].torihikiDateDisp);
        system.assertEquals('100000', controller.getNyukinList()[0].nyukinkingaku);
        system.assertEquals('\\100,000', controller.getNyukinList()[0].nyukinkingakuDisp);
        system.assertEquals('1112222222', controller.getNyukinList()[0].furikomiiraininNo);
        system.assertEquals('111', controller.getNyukinList()[0].furikomiShitenCd);
        system.assertEquals('2222222', controller.getNyukinList()[0].furikomiKozaNo);
        system.assertEquals('ｶ)ｻﾝﾌﾟﾙ1                                 ', controller.getNyukinList()[0].furikomiiraininName);
        system.assertEquals('OK', controller.getNyukinList()[0].torikomi);
        system.assertEquals('OK', controller.getNyukinList()[0].hikiate);

        system.assertEquals(1, Apexpages.getMessages().size());
        system.assertEquals('入金自動登録処理が完了しました。', Apexpages.getMessages()[0].getSummary());

        system.assertEquals(true, controller.getDisabledTorikomiBtnFlag());

    }
}