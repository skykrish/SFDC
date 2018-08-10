/**********************************************************************************
*   Class               :       Test_EPMS_CheckEstimatorAssigned                     *
*   Created Date        :       18/01/2018                                           *           
*   Description         :       Test class for EPMS_CheckEstimatorAssigned           *
**********************************************************************************/
@istest
public class Test_EPMS_CheckEstimatorAssigned {
    
    static testMethod void testCheckEstimator() {
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist1222222@mbo.in';
        insert usermail;
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c anken=new Anken__c(KokyakuName__c=acc.Id,Status__c='Open',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                                    Nouki_Date__c=System.Today());
        insert anken;
        
        System.debug('--Before PO insert--');
        Production_Order__c prodOrder = new Production_Order__c();
        prodOrder.Anken_Order__c = anken.id;
        prodOrder.Name = 'TestPO';
        ProdOrder.Mbo_Location__c=location.id;
        ProdOrder.FTP_Download_Status__c=true;
        ProdOrder.Production_Order_Status__c = 'Estimator Assigned';
        insert prodOrder;
        
        Member__c qcmember =new Member__c();
        qcmember.Name='TONY';     
        qcmember.Location_id__c=location.id;
        qcmember.Last_Name__c='ABBOTT';
        qcmember.Email__c='tonyabboott@gmail.com';
        qcmember.Country__c='India';
        qcmember.Designation__c='Quality Control';
        qcmember.Status__c='Active';
        qcmember.Is_Estimator__c = True;
        insert qcmember; 
        
        /*Files__c file = new Files__c();
        file.Production_Order__c=prodOrder.id;
        file.Name='TestFA';
        file.Status__c='Estimator Assigned';          
        file.Current_Extension__c='.jpg';
        file.File_Type__c = 'Image';
        file.File_Job_Titles__c='Alpha,Cripping';           
        file.Estimator__c = qcmember.id;        
        insert file;*/        
        
        Test.startTest();
        qcmember.Is_Estimator__c = false;        
        update qcmember;
        Test.stopTest();        
        
    }
}