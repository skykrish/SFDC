/**
 * SeikyuKakuteiBatchScheduler_Rakutenクラス用テストクラス
 */
@isTest
private class TestSeikyuKakuteiBatchScheduler_Rakuten {

    static testMethod void myUnitTest1() {
        // テスト開始
        Test.startTest();
        
        BatchExecDate__c batchDate = new BatchExecDate__c();
        batchDate.ShimeGroup__c = '楽天';
        batchDate.Shimebi__c = DATE.TODAY();
        insert batchDate;
        
        String jobId = System.schedule('TestSeikyuKakuteiBatchScheduler_Rakuten', '0 0 * * * ?', new SeikyuKakuteiBatchScheduler_Rakuten());
        
        // テスト終了
        Test.stopTest();
    }
}