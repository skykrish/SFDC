/**********************************************************************************
*   Class               :       Test_FileQeue                                  *
*   Created Date        :       28/05/2018                                     *           
*   Description         :       Test class for FileQeue                       * 
**********************************************************************************/

@isTest
public class Test_FileQeue {
    static testMethod void TestUpdateFStatus8() {
        Test.StartTest();
        Profile profile = [select id from Profile where Name ='system administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@mbo.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        system.runAs(user){ 
            Location__c location = new Location__c();
            location.Name = 'INDIAN MBO';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIAN MBO';
            insert location;
            
            Account acc=new Account(Name='TEST ACC');
            insert acc;
            
            Anken__c anken=new Anken__c();
            anken.KokyakuName__c=acc.Id;
            anken.Status__c='Open';
            anken.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
            anken.Nouki_Date__c=System.Today();
            insert anken;
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO_22';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            po.FTP_Upload_Status__c = false;
            po.Location_For_Sharing__c = location.Name;
            po.Anken_Order__c = anken.Id;
            po.User__c = user.id;
            insert po;
            
            List<Files__c> fileList = new List<Files__c>();
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;            
            insert fc; 
            
            Files__c file1= new Files__c();
            file1.Name ='testFile';
            file1.Production_Order__c =po.id;
            file1.File_Category_Code__c =fc.id;
            file1.Status__c ='New';
            file1.File_Location__c=location.id;
            file1.Current_Extension__c ='.jpg';
            file1.File_Type__c = 'Image';
            insert file1;
            
            po.Production_Order_Status__c ='Estimation Request';
            update po; 
            
            List<Files__c> updateFileList = new List<Files__c>();
            List<files__C> files = [SELECT Id, Name, Status__c,Production_Order__c FROM Files__c WHERE Production_Order__c =: po.id];            
            for(Files__C f:files){
                f.Status__c = 'Estimation Request';
                updateFileList.add(f);
            }
            update updateFileList;
        }
        Test.StopTest();
    } 
    static testMethod void TestUpdateFStatus88() {
        Test.StartTest();
        Profile profile = [select id from Profile where Name ='system administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@mbo.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        system.runAs(user){ 
            Location__c location = new Location__c();
            location.Name = 'INDIAN MBO';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIAN MBO';
            insert location;
            
            Account acc=new Account(Name='TEST ACC');
            insert acc;
            
            Anken__c anken=new Anken__c();
            anken.KokyakuName__c=acc.Id;
            anken.Status__c='Open';
            anken.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
            anken.Nouki_Date__c=System.Today();
            insert anken;
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO_22';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            po.FTP_Upload_Status__c = false;
            po.Location_For_Sharing__c = location.Name;
            po.Anken_Order__c = anken.Id;
            po.User__c = user.id;
            insert po;
            
            List<Files__c> fileList = new List<Files__c>();
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;            
            insert fc; 
            
            Files__c file1= new Files__c();
            file1.Name ='testFile';
            file1.Production_Order__c =po.id;
            file1.File_Category_Code__c =fc.id;
            file1.Status__c ='New';
            file1.File_Location__c=location.id;
            file1.Current_Extension__c ='.jpg';
            file1.File_Type__c = 'Image';
            insert file1;
            
            po.Production_Order_Status__c ='Redo';
            update po;       
            List<Files__c> updateFileList = new List<Files__c>();
            List<files__C> files = [SELECT Id, Name, Status__c,Production_Order__c FROM Files__c WHERE Production_Order__c =: po.id];            
            for(Files__C f:files){
                f.Status__c = 'Redo';
                updateFileList.add(f);
            }
            update updateFileList;
        }
        Test.StopTest();
    }  
}