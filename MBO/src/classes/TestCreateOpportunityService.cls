@isTest
public class TestCreateOpportunityService {

    /**
     * 商談レコード作成 正常系01
     */
    static testMethod void createOpportunity_normal01() {
        
        // 顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;
        
        // 案件データ作成
        Anken__c testAnken = new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み',JuchuDateTime__c=Date.today());
        insert testAnken;
        
        // テスト開始
        Test.startTest();
        
        // 商談作成
        CreateOpportunityService.createOpportunity(testAnken.Id);
        
        // テスト終了
        Test.stopTest();
    }
    
    /**
     * 商談レコード作成 異常系01
     */
    static testMethod void createOpportunity_errl01() {
        
        // 顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;
        
        // 案件データ作成
        Anken__c testAnken = new Anken__c(KokyakuName__c=testAcc.Id, Status__c='請求確定済み',JuchuDateTime__c=Date.today());
        insert testAnken;
        
        // テスト開始
        Test.startTest();
        
        delete testAnken;
        
        // 商談作成
        CreateOpportunityService.createOpportunity(testAnken.Id);
        
        // テスト終了
        Test.stopTest();
    }

}