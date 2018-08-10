/**********************************************************************************
*   Class               :       clstest_EPMS_BatchEmailAlertstoITSupport                *
*   Created Date        :       16/01/2018                                             *           
*   Description         :       Test class for EPMS_BatchEmailAlertstoITSupport      *
**********************************************************************************/
@isTest(seealldata=True)
private class Test_EPMS_BatchEmailAlertstoITSupport {
    
    static testmethod void setupTestData1(){
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='Active';
        location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
        insert location;
        
        List<Member__c> mem = [select id,name,User_Id__r.Email from member__c where User_Id__r.Email !=null];
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India7845';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
          
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='NewEmail';
        usermail.Email__c='testmbouptch@mbo.in';
        insert usermail;
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c anken=new Anken__c();
        anken.KokyakuName__c=acc.Id;
        anken.Status__c='Open';
        anken.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
        anken.Nouki_Date__c=System.Today();
        anken.ItemCnt__c = 10;
        insert anken;
        
        List<Production_Order__c> polist=new List<Production_Order__c>();
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO';
        po.File_Count_Delay__c = false;
        po.Production_Order_Instruction__c = '･Clipping + Cropping -1200px square';
        po.Anken_Order__c = anken.Id;
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.Location_For_Sharing__c=location.Name;
        
        polist.add(po);		
        
        Production_Order__c po1=new Production_Order__c();
        po1.Name ='testPO1';
        po1.File_Count_Delay__c = false;
        po1.Production_Order_Instruction__c = '･Clipping + Cropping -1200px square';
        po1.Anken_Order__c = anken.Id;
        po1.Production_Order_Status__c ='New';
        po1.MBO_Location__c=location.Id;
        //po1.New_Files_Count__c = 5;
        po1.Location_For_Sharing__c=location.Name;
        polist.add(po1);	
        insert polist;
       
        Test.startTest();
        EPMS_BatchEmailAlertstoITSupport EmailAlert=new EPMS_BatchEmailAlertstoITSupport('MBOI Phase-2');
        EmailAlert.start(null);
        EmailAlert.execute(null, polist);
        EmailAlert.finish(null);
        Test.stopTest();
        
    }   
  /*@isTest
    private static void EPMS_BatchEmailAlert2(){
       //EPMS_BatchEmailAlertstoITSupport EmailAlert=new EPMS_BatchEmailAlertstoITSupport('MBOI Phase-2');

        Test.startTest();
        Database.executeBatch(new EPMS_BatchEmailAlertstoITSupport('MBOI Phase-2'));
        Test.stopTest();

    }*/
    
}