@istest
public class Test_EPMS_UpdateAnkenAndPOStatusBatch{
    
    public static testmethod void teststatus() {
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='Active';
        location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
        insert location;
        
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
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO';
        po.File_Count_Delay__c = false;
        po.Production_Order_Instruction__c = '･Clipping + Cropping -1200px square';
        po.Anken_Order__c = anken.Id;
        po.Production_Order_Status__c ='Awaiting Approval';
        po.MBO_Location__c=location.Id;
        po.Location_For_Sharing__c=location.Name;
        insert po;
        
        Production_Order__c po1=new Production_Order__c();
        po1.Name ='testPO1';
        po1.File_Count_Delay__c = false;
        po1.Production_Order_Instruction__c = '･Clipping + Cropping -1200px square';
        po1.Anken_Order__c = anken.Id;
        po1.Production_Order_Status__c ='New';
        po1.MBO_Location__c=location.Id;
        po1.Location_For_Sharing__c=location.Name;
        insert po1;
        List<Files__c> FileList = new List<Files__c>();
        Files__c file = new Files__c();
        file.Name ='Testfile_1001';
        file.Production_Order__c =po.id;
        file.Status__c ='Awaiting Approval';
        file.File_Location__c=location.id;
        file.Current_Extension__c ='.jpg';
        file.File_Type__c = 'Image';
        file.File_Job_Titles__c = 'Clipping,Cropping';
        FileList.add(file);
        insert FileList;  
        
        Test.startTest();
        EPMS_UpdateAnkenAndPOStatusBatch UpdateStatus=new EPMS_UpdateAnkenAndPOStatusBatch('PoName1');
        UpdateStatus.start(null);
        UpdateStatus.execute(null, FileList);
        UpdateStatus.finish(null);        
        Test.stopTest();
    }
}