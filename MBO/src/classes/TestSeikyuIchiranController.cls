/**
 * SeikyuIchiranControllerクラス用テストクラス
 */
@isTest
private class TestSeikyuIchiranController {

  /** テスト用顧客データ */
  private static Account[] testAcc;

  /** テスト用請案件データ */
  private static Anken__c[] testAnken;

  /** テスト用請求ヘッダデータ */
  private static SeikyuHeader__c[] testSeikyuHeader;

  /** テスト用作業データ */
  private static Sagyo__c[] testSagyo;

  /** テスト用Attachmentデータ */
  private static Attachment[] testAttachment;

    /** ページ数上限 */
    private static integer MAX_PAGE = 10;

    /** １ページの表示請求ヘッダ数 */
    private static integer MAX_SHEAD_LINE = 100;

    static testMethod void myUnitTest01() {

        //テストデータ作成
        insertDate();

        List<SeikyuHeader__c> updateSeikyuHeaderList = new List<SeikyuHeader__c>();
        for(Integer i = 0; i < testAttachment.size(); i++){
            if(i != 0){
                testSeikyuHeader[i + 1].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i + 1]);
            }else{
                testSeikyuHeader[i].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i]);
            }
        }
        update updateSeikyuHeaderList;

        // テスト開始
        Test.startTest();

        // 請求一覧
        SeikyuIchiranController controller = new SeikyuIchiranController();
        // 条件なしで検索
        controller.seikyuSearch();
        // 条件ありで検索１
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索２
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索３
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = Date.today();
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索４
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索５
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索６
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索７
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索８
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = '20日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索９
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = '末日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索１０
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = '都度';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '1';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索１１
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = 'クレジットカード';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '1';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索１２：入力チェックエラー（不正な日付）
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '0';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索１３
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = true;
        controller.seikyuSearch();
        // 条件ありで検索１４
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.today();
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = true;
        controller.seikyuSearch();
        // 条件ありで検索１５
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = '25日';
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // 条件ありで検索１６
        controller.criteria.Seikyusaki__c = null;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = '25日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // ソート１
        controller.sortData();
        // ソート２
        controller.sortExpression = 'SeikyuStatus__c';
        controller.sortData();
        // 請求書送付１：入力チェックエラー（処理対象チェックなし）
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.sendPdf();
        // 請求書送付２：入力チェックエラー（請求先担当者なし）
        controller.criteria.Seikyusaki__c = testAcc[5].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.sendPdf();
        // 請求書送付３：入力チェックエラー（請求先担当者の宛先未設定）
        controller.criteria.Seikyusaki__c = testAcc[2].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.sendPdf();
        // 請求書送付４：入力チェックエラー（PDF未設定）
        controller.criteria.Seikyusaki__c = testAcc[1].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.sendPdf();
        // 請求書送付５：入力チェックエラー（既に取消済みでないかどうか）
        controller.criteria.Seikyusaki__c = testAcc[4].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '請求済み';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = true;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.sendPdf();
        // 請求書送付６：正常
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.sendPdf();
        testSeikyuHeader[0].SeikyuStatus__c = '未請求';
        testSeikyuHeader[0].SeikyuDateTime__c = null;
        update testSeikyuHeader[0];
        // 請求ステータス変更１：入力チェックエラー（処理対象チェックなし）
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.seikyuStatusUpdate();
        // 請求ステータス変更２：入力チェックエラー（既に取消済みでないかどうか）
        controller.criteria.Seikyusaki__c = testAcc[4].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '請求済み';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = true;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.seikyuStatusUpdate();
        // 請求ステータス変更３：正常
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.seikyuStatusUpdate();
        testSeikyuHeader[0].SeikyuStatus__c = '未請求';
        testSeikyuHeader[0].SeikyuDateTime__c = null;
        update testSeikyuHeader[0];
        // 請求取消１：入力チェックエラー（処理対象チェックなし）
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.deleteSeikyu();
        // 請求取消２：入力チェックエラー（既に入金済みでないかどうか）
        controller.criteria.Seikyusaki__c = testAcc[3].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '請求済み';
        controller.criteria.NyukinStatus__c = '入金済み';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.deleteSeikyu();
        // 請求取消３：入力チェックエラー（既に取消済みでないかどうか）
        controller.criteria.Seikyusaki__c = testAcc[4].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '請求済み';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = true;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.deleteSeikyu();
        // 請求取消４：正常
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
      //  controller.deleteSeikyu();
        testSeikyuHeader[0].Del_Flg__c = false;
        testSeikyuHeader[0].Del_Date__c = null;
        update testSeikyuHeader[0];
        testAnken[0].Status__c = '請求確定済み';
        update testAnken[0];
        // 送付状印刷１：入力チェックエラー（処理対象チェックなし）
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.printSoufujoPdf();
        // 請求書送付２：入力チェックエラー（請求先担当者なし）
        controller.criteria.Seikyusaki__c = testAcc[5].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.printSoufujoPdf();
        // 請求書送付３：入力チェックエラー（既に取消済みでないかどうか）
        controller.criteria.Seikyusaki__c = testAcc[4].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '請求済み';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = true;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.printSoufujoPdf();
        // 請求書送付４：正常
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.printSoufujoPdf();
        // 請求書印刷１：入力チェックエラー（処理対象チェックなし）
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.printPdf();
        // 請求書印刷２：入力チェックエラー（既に取消済みでないかどうか）
        controller.criteria.Seikyusaki__c = testAcc[4].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '請求済み';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = true;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.printPdf();
        // 請求書印刷３：正常
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.printPdf();

        // テスト終了
        Test.stopTest();
    }

    static testMethod void myUnitTest02() {
/*
        //テストデータ作成
        insertDate();

        List<SeikyuHeader__c> updateSeikyuHeaderList = new List<SeikyuHeader__c>();
        for(Integer i = 0; i < testAttachment.size(); i++){
            if(i != 0){
                testSeikyuHeader[i + 1].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i + 1]);
            }else{
                testSeikyuHeader[i].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i]);
            }
        }
        update updateSeikyuHeaderList;

        // 各種処理上限テスト用データ作成
        List<Anken__c> testAnkenList = new List<Anken__c>();
        for(Integer i = 0; i <= MAX_PAGE * MAX_SHEAD_LINE ; i++){
          testAnkenList.add(new Anken__c(KokyakuName__c=testAcc[6].Id, Status__c='請求確定済み', StatusLock__c=true));
        }
        insert testAnkenList;

        List<AnkenMeisai__c> testAnkenMeisaiList = new List<AnkenMeisai__c>();
        for(Integer i = 0; i <= MAX_PAGE * MAX_SHEAD_LINE ; i++){
          testAnkenMeisaiList.add(New AnkenMeisai__c(Anken__c = testAnkenList[i].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true));
        }
        insert testAnkenMeisaiList;

        List<SeikyuHeader__c> testSeikyuHeaderList = new List<SeikyuHeader__c>();
        for(Integer i = 0; i <= MAX_PAGE * MAX_SHEAD_LINE ; i++){
          if(i <= MAX_PAGE * MAX_SHEAD_LINE / 2){
            testSeikyuHeaderList.add(New SeikyuHeader__c(Seikyusaki__c=testAcc[6].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'));
          }else{
            testSeikyuHeaderList.add(New SeikyuHeader__c(Seikyusaki__c=testAcc[6].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='請求済み', NyukinStatus__c='未入金'));
          }
        }
        insert testSeikyuHeaderList;

        List<Seikyu__c> testSeikyuList = new List<Seikyu__c>();
        for(Integer i = 0; i <= MAX_PAGE * MAX_SHEAD_LINE ; i++){
          testSeikyuList.add(new Seikyu__c(SeikyusyoNo__c=testSeikyuHeaderList[i].Id, DenpyoNo__c=testAnkenList[i].Id, AnkenName__c='案件名' + i, AnkenTantosya__c='担当者' + i));
        }
        insert testSeikyuList;

        List<SeikyuMeisai__c> testSeikyuMeisaiList = new List<SeikyuMeisai__c>();
        for(Integer i = 0; i <= MAX_PAGE * MAX_SHEAD_LINE ; i++){
          testSeikyuMeisaiList.add(New SeikyuMeisai__c(SeikyuNo__c=testSeikyuList[i].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05));
        }
        insert testSeikyuMeisaiList;

        List<Attachment> testAttachmentList = new List<Attachment>();
        for(Integer i = 0; i <= Integer.valueOf(System.Label.ExecuteLimitCount_Seikyusyo) ; i++){
          testAttachmentList.add(New Attachment(Name='請求書.pdf', parentId=testSeikyuHeaderList[i].Id, Body=Blob.valueOf('sample')));
        }
        insert testAttachmentList;

        updateSeikyuHeaderList = new List<SeikyuHeader__c>();
        for(Integer i = 0; i <= Integer.valueOf(System.Label.ExecuteLimitCount_Seikyusyo) ; i++){
            testSeikyuHeaderList[i].SeikyusyoId__c = testAttachmentList[i].Id;
            updateSeikyuHeaderList.add(testSeikyuHeaderList[i]);
        }
        update updateSeikyuHeaderList;

        // テスト開始
        Test.startTest();

        // 請求一覧
        SeikyuIchiranController controller = new SeikyuIchiranController();

        // 条件ありで検索１５：検索結果の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        // ソート３：再検索結果の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.sortData();
        // 請求書送付７：請求書送付処理の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i <= Integer.valueOf(System.Label.ExecuteLimitCount_Seikyusyo); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.sendPdf();
        // 請求書送付８：再検索結果の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.sendPdf();
        testSeikyuHeader[0].SeikyuStatus__c = '未請求';
        testSeikyuHeader[0].SeikyuDateTime__c = null;
        update testSeikyuHeader[0];
        // 請求確定４：再検索結果の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuStatusUpdate();
        testSeikyuHeader[0].SeikyuStatus__c = '未請求';
        testSeikyuHeader[0].SeikyuDateTime__c = null;
        update testSeikyuHeader[0];
        // 請求取消５：請求取消処理の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = '請求済み';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i <= Integer.valueOf(System.Label.ExecuteLimitCount_Seikyusyo); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.deleteSeikyu();
        // 請求取消６：再検索結果の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.deleteSeikyu();
        testSeikyuHeader[0].Del_Flg__c = false;
        testSeikyuHeader[0].Del_Date__c = null;
        update testSeikyuHeader[0];
        testAnken[0].Status__c = '請求確定済み';
        update testAnken[0];
        // ページング１：正常
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = '未入金';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.dispPage = 2;
        controller.paging();
        // ページング２：再検索結果の上限エラー
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = '未入金';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        controller.dispPage = 2;
        controller.criteria.Seikyusaki__c = testAcc[6].Id;
        controller.criteria.TorihikiKbn__c = null;
        controller.criteria.KaisyuScheduledDate__c = null;
        controller.criteria.SeikyuStatus__c = null;
        controller.criteria.NyukinStatus__c = null;
        controller.criteria.ShimeGroup__c = null;
        controller.criteria.SeikyuYear__c = null;
        controller.criteria.SeikyuMonth__c = null;
        controller.criteria.SeikyuDay__c = null;
        controller.criteria.Del_Flg__c = false;
        controller.paging();

        // テスト終了
        Test.stopTest();
*/
    }
    
    static testMethod void myUnitTest03() {

        //テストデータ作成
        insertDate();

        List<SeikyuHeader__c> updateSeikyuHeaderList = new List<SeikyuHeader__c>();
        for(Integer i = 0; i < testAttachment.size(); i++){
            if(i != 0){
                testSeikyuHeader[i + 1].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i + 1]);
            }else{
                testSeikyuHeader[i].SeikyusyoId__c = testAttachment[i].Id;
                updateSeikyuHeaderList.add(testSeikyuHeader[i]);
            }
        }
        update updateSeikyuHeaderList;

        // テスト開始
        Test.startTest();
        
        //パラメータ設定
        PageReference pageRef = Page.SeikyuIchiran;
        //パラメータをセット
        pageRef.getParameters().put('shcon', testAcc[0].Id + ',掛売上,2016-05-01,未請求,未入金,15日,2016,05,01,false');
        Test.setCurrentPage(pageRef);
        
         // 請求一覧
        SeikyuIchiranController controller = new SeikyuIchiranController();
        // 条件なしで検索
        controller.seikyuSearch();
        
        controller.criteria.Seikyusaki__c = testAcc[0].Id;
        controller.criteria.TorihikiKbn__c = '掛売上';
        controller.criteria.KaisyuScheduledDate__c = Date.newInstance(2011,1,1);
        controller.criteria.SeikyuStatus__c = '未請求';
        controller.criteria.NyukinStatus__c = '未入金';
        controller.criteria.ShimeGroup__c = '15日';
        controller.criteria.SeikyuYear__c = '2011';
        controller.criteria.SeikyuMonth__c = '1';
        controller.criteria.SeikyuDay__c = '15';
        controller.criteria.Del_Flg__c = false;
        controller.seikyuSearch();
        for (Integer i = 0; i < controller.seikyuHeaderList.size(); i ++) {
          controller.seikyuHeaderList[i].checked = true;
        }
        
        // 取りまとめ
        controller.compiledSeikyu();
        
        // テスト終了
        Test.stopTest();
    }

  /**
   * テストデータ作成
   */
  private static void insertDate(){

        List<User> testUser = [SELECT id, UserName FROM User WHERE UserRoleId != '00E10000000Zwco' AND IsActive = true];

        // テスト用顧客データ作成
        testAcc = new Account[] {
          new Account(Name='Test1', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ1'),
          new Account(Name='Test2', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ2'),
          new Account(Name='Test3', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ3'),
          new Account(Name='Test4', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ4'),
          new Account(Name='Test5', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ5'),
          new Account(Name='Test6', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ6'),
          new Account(Name='Test7', TorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuCycle__c='当月', KaisyuDate__c='05日', FurikomiBankName__c='テスト銀行', FurikomiShitenName__c='テスト支店', FurikomiShitenCd__c='000', FurikomiKozaType__c='普通', FurikomiKozaNo__c='1234567', FurikomiKozaName__c='ﾃｽﾄ7')
        };
        insert testAcc;

        // テスト用担当者データ作成
        Contact[] testCon = new Contact[] {
          new Contact(LastName='Test1', AccountId=testAcc[0].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
          new Contact(LastName='Test2', AccountId=testAcc[1].Id, email='test@test.co.jp', SeikyuTantoFlg__c=false),
          new Contact(LastName='Test3', AccountId=testAcc[2].Id, email=null, SeikyuTantoFlg__c=true),
          new Contact(LastName='Test4', AccountId=testAcc[3].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
          new Contact(LastName='Test5', AccountId=testAcc[4].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true),
          new Contact(LastName='Test7', AccountId=testAcc[6].Id, email='test@test.co.jp', SeikyuTantoFlg__c=true)
        };
        insert testCon;

        // テスト用案件データ作成
        testAnken = New Anken__c[]{
          new Anken__c(KokyakuName__c=testAcc[0].Id, Status__c='請求確定済み', StatusLock__c=true),
          new Anken__c(KokyakuName__c=testAcc[1].Id, Status__c='請求確定済み', StatusLock__c=true),
          new Anken__c(KokyakuName__c=testAcc[2].Id, Status__c='請求確定済み', StatusLock__c=true),
          new Anken__c(KokyakuName__c=testAcc[3].Id, Status__c='請求確定済み', StatusLock__c=true),
          new Anken__c(KokyakuName__c=testAcc[4].Id, Status__c='請求確定済み', StatusLock__c=true),
          new Anken__c(KokyakuName__c=testAcc[5].Id, Status__c='請求確定済み', StatusLock__c=true)
        };
        insert testAnken;

        // テスト用作業データ作成
        testSagyo = New Sagyo__c[]{
            New Sagyo__c(Name = '999',Nanido__c='Z',SagyoBunrui__c='メイン作業',SagyoName__c='作業名999Z',Teika__c=999)
        };
        insert testSagyo;

        // テスト用案件明細データ作成
        AnkenMeisai__c[] testAnkenMeisai = New AnkenMeisai__c[]{
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[0].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[1].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[2].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[3].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[3].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[4].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[4].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[5].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-01', Tanka__c = 1999, Suryo__c = 1, TaxRate__c = 0.05, Waribikiritsu__c = 10, MitsumoriFlg__c = true),
            New AnkenMeisai__c(Anken__c = testAnken[5].Id, SagyoCd__c = testSagyo[0].Id, SagyoName__c = '作業名999Z-02', Tanka__c = 2999, Suryo__c = 2, TaxRate__c = 0.05, Waribikiritsu__c = 15, MitsumoriFlg__c = true)
        };
        insert testAnkenMeisai;

        // テスト用入金データ作成
        Nyukin__c[] testNyukin = New Nyukin__c[]{
            New Nyukin__c(Nyukinsaki__c = testAcc[0].Id, NyukinType__c = '現金', NyukinDate__c = system.today(), Nyukingaku__c = 2000, Status__c = '相殺済み', Offset_Flg__c = true)
        };
        insert testNyukin;

        //テスト用請求ヘッダデータ作成
        testSeikyuHeader = new SeikyuHeader__c[] {
          New SeikyuHeader__c(Seikyusaki__c=testAcc[0].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[1].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[2].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[3].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='請求済み', NyukinStatus__c='入金済み'),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[4].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='請求済み', NyukinStatus__c='未入金', Del_Flg__c=true),
          New SeikyuHeader__c(Seikyusaki__c=testAcc[5].Id, SeikyusakiTorihikiKbn__c='掛売上', ShimeGroup__c='15日', KaisyuScheduledDate__c=Date.newInstance(2011,1,1), Shimebi__c=Date.newInstance(2011,1,15), SeikyuStatus__c='未請求', NyukinStatus__c='未入金')
        };
        insert testSeikyuHeader;

        // テスト用請求データ作成
        Seikyu__c[] testSeikyu = New Seikyu__c[]{
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, DenpyoNo__c=testAnken[0].Id, AnkenName__c='案件名１', AnkenTantosya__c='担当者1'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[1].Id, DenpyoNo__c=testAnken[1].Id, AnkenName__c='案件名２', AnkenTantosya__c='担当者2'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[2].Id, DenpyoNo__c=testAnken[2].Id, AnkenName__c='案件名３', AnkenTantosya__c='担当者3'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[3].Id, DenpyoNo__c=testAnken[3].Id, AnkenName__c='案件名４', AnkenTantosya__c='担当者4'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[4].Id, DenpyoNo__c=testAnken[4].Id, AnkenName__c='案件名５', AnkenTantosya__c='担当者5'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[5].Id, DenpyoNo__c=testAnken[5].Id, AnkenName__c='案件名６', AnkenTantosya__c='担当者6'),
          new Seikyu__c(SeikyusyoNo__c=testSeikyuHeader[0].Id, OffsetNyukin__c=testNyukin[0].Id, Offset_Flg__c=true)
        };
        insert testSeikyu;

        // テスト用請求明細データ作成
        SeikyuMeisai__c[] testSeikyuMeisai = New SeikyuMeisai__c[]{
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[0].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[1].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[1].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[2].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[2].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[3].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[3].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[4].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[4].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[5].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-01', Tanka__c=1999, Suryo__c=1, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[5].Id, SagyoCd__c='999', Nanido__c='Z', SagyoName__c='作業名999Z-02', Tanka__c=2999, Suryo__c=2, TaxRate__c=0.05),
            New SeikyuMeisai__c(SeikyuNo__c=testSeikyu[6].Id, Tanka__c=-2000, Suryo__c=1, TaxRate__c=0)
        };
        insert testSeikyuMeisai;

        // テスト用Attachmentデータ作成
        testAttachment = New Attachment[]{
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[0].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[2].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[3].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[4].Id, Body=Blob.valueOf('sample')),
            New Attachment(Name='請求書.pdf', parentId=testSeikyuHeader[5].Id, Body=Blob.valueOf('sample'))
        };
        insert testAttachment;
  }
}