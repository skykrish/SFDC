@isTest
public class TestContractConcludeService {

    /**
     * 商談のフェーズの更新  正常系01
     */
    static testMethod void contractConclude_normal01() {
        
        // 顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;
        
        // 商談の作成
        Opportunity oppo = new Opportunity(AccountId=testAcc.Id, Name='商談のテスト名',CloseDate=Date.today(),StageName='定期フォロー');
        insert oppo;
        
        // テスト開始
        Test.startTest();
        
        // 商談作成
        ContractConcludeService.contractConclude(oppo.Id);
        
        // テスト終了
        Test.stopTest();
    }
    
    /**
     * 商談のフェーズの更新  正常系02
     */
    static testMethod void contractConclude_normal02() {
        
        // 顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;
        
        // 商談の作成
        Opportunity oppo = new Opportunity(AccountId=testAcc.Id, Name='商談のテスト名',CloseDate=Date.today(),StageName='定期フォロー');
        insert oppo;
        
        // テスト開始
        Test.startTest();
        delete oppo;
        // 商談作成
        ContractConcludeService.contractConclude(oppo.Id);
        
        // テスト終了
        Test.stopTest();
    }
    
    
    /**
     * 商談のフェーズの更新  正常系03
     */
    static testMethod void contractConclude_normal03() {
        
        // 顧客データ作成
        Account testAcc = new Account(Name='Test');
        insert testAcc;
        
        // 商談の作成
        Opportunity oppo = new Opportunity(AccountId=testAcc.Id, Name='商談のテスト名',CloseDate=Date.today(),ContractConcludeDate__c=Date.today(),StageName='定期フォロー');
        insert oppo;
        
        // テスト開始
        Test.startTest();
        // 商談作成
        ContractConcludeService.contractConclude(oppo.Id);
        
        // テスト終了
        Test.stopTest();
    }

}