/**********************************************************************************
*   Class               :       Test_EPMS_CreateProductionOrderRedo               *
*   Created Date        :       19/01/2018                                        *
*   Description         :       Test Class for EPMS_CreateProductionOrderRedo     *
**********************************************************************************/
@isTest
public class Test_EPMS_CreateProductionOrderRedo {
    
    static testMethod void test_CreatePORedo() {
        
        PageReference pageRef = Page.EPMS_CreateProductionOrderRedo;        
        Account acc=new Account(Name='TEST ACC');        
        insert acc;       
        
        Anken__c anken=new Anken__c(KokyakuName__c=acc.Id,Status__c='アップロード完了',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                                    Nouki_Date__c=System.Today());
        Insert anken;
        
        Location__c location = new Location__c();
        location.Name = 'INDIAN MBO';
        location.Location_Country__c='India';
        location.Location_Status__c ='Active';
        location.Group_Name__c='INDIAN MBO';
        insert location;        
        
        Production_Order__c po=new Production_Order__c();
        po.Anken_Order__c = anken.id;
        po.Name ='testPO-1';
        po.Production_Order_Status__c ='New';
        Po.Production_Order_Instruction__c = 'Test data for PO instruction';
        po.MBO_Location__c=location.Id;
        po.Redo__c = True;
        insert po;
        
        List<Production_Order__c> JobList=new List<Production_Order__c>();
       
        Production_Order__c po1=new Production_Order__c();
        po1.Anken_Order__c = anken.id;
        po1.Name ='testPO-2';
        po1.Production_Order_Status__c ='New';
        Po1.Production_Order_Instruction__c = 'Test data for instruction';
        po1.MBO_Location__c=location.Id;
        po1.Redo__c = True;
        JobList.add(po1); 
        insert JobList;
        
        
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('ids',anken.Id);
        anken.Status__c='Redo';
        update anken;
        pageRef.getParameters().put('ids',anken.Id);

        EPMS_CreateProductionOrderRedo porder1 = new EPMS_CreateProductionOrderRedo();
        porder1.save();
        test.stopTest();        
    }
}