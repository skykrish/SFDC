/***********************************************************************************
*   Class               :       Test_Epms_checkFileQC                              *
*   Created Date        :       28/09/2016                                         *           
*   Description         :       Test class for Test_Epms_checkFileQC               *
************************************************************************************/

@isTest(SeeAlldata=true)
public class Test_Epms_checkFileQC {   

    static testMethod void testPositive() {
  
        Profile profile = [select id from Profile where Name = 'System Administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@shinsei.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;  


        Location__c location = new Location__c();
        location.Name='Asia-Japan';
        location.Location_Country__c = 'India';
        location.Group_Name__c ='INDIA PVT LTD -Phase2';
        insert location;

        Team__c team2 = new Team__c();
        team2.Name='testname2';
        team2.Location__c=location.id;        
        insert team2; 


        Member__c Member = new Member__c();
        Member.First_Name__c='Test1';
        Member.Last_Name__c='testlast';       
        Member.Name='testname';
        Member.Status__c= 'Active';
        Member.Team_Id__c =team2.id;
        Member.Country__c='India';
        Member.Location_id__c=location.id;         
        Member.Designation__c='Team Leader';
        Member.User_Id__c = user.id;
        Member.Email__c='test0987@gmail.com';
        insert Member;

        File_Categories__c fileCategory = new File_Categories__c();
        fileCategory.Name = 'Test';
        fileCategory.Standard_Time_per_File_Min__c=11;
        fileCategory.Standard_Time_per_File_Max__c=20;
        fileCategory.Standard_Regular_Cost_per_File__c=3;
        fileCategory.Standard_OptionalCost_Per_file__c=1;
        insert fileCategory;


        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO';
        po.Production_Order_Status__c ='TBI';
        po.MBO_Location__c=location.Id;
        po.Location_For_Sharing__c=location.Name;
        PO.Production_Order_Status__c='Assigned';
        insert po;
     
            Files__c file = new Files__c();
            file.Production_Order__c=po.id;
            file.Name='TestFA';
            file.File_Category_Code__c=fileCategory.id;
            file.Status__c='Assigned';
            file.File_Location__c=location.Id;
            file.Member__c=Member.Id;
            file.QCIncharge__c=Member.Id;
            //file.File_Auto_Number__c = 'F0000020999';
            file.TLInCharge__c=Member.id;
            file.Current_Extension__c='.jpg';
            file.Files_To_open__c = 1;
            file.File_type__c='image';
             insert file;  

            Files__c file2 = new Files__c();
            file2.Production_Order__c=po.id;
            file2.Name='TestFA2';
            file2.File_Category_Code__c=fileCategory.id;
            file2.Status__c='Assigned';
            file2.File_Location__c=location.Id;
            file2.Member__c=Member.Id;
            file2.QCIncharge__c=Member.Id;
            //file2.File_Auto_Number__c = 'F0000021000';
            file2.TLInCharge__c=Member.id;
            file2.Current_Extension__c='.jpg';
            file2.Files_To_open__c = 1;
            file2.File_type__c='image';
            insert file2;  

             
       
        //system.debug('----------file2.File_Auto_Number__c------------'+fl.File_Auto_Number__c);
        //system.debug('----------file.File_Auto_Number__c------------'+fl2.File_Auto_Number__c);

               
                 Test.startTest();
        
        if(user!=null){
            System.runAs(user){
                
                 Files__c fl = [select id,File_Auto_Number__c from files__c where id=:file.id];
              Files__c fl2 = [select id,File_Auto_Number__c from files__c where id=:file2.id];
               
            string JsonMsg ='{"fileIDs":"'+fl.File_Auto_Number__c+','+fl2.File_Auto_Number__c +'"}';
                    RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();

                req.requestURI = 'https://ap3.salesforce.com/services/apexrest/CurrentOwnerOfFiles';  
                req.httpMethod = 'POST';
                req.requestBody = Blob.valueof(JsonMsg);
                RestContext.request = req;
                RestContext.response = res;
                Epms_checkFileQC.doPost();
                
               
                   
          
        }
         Test.stopTest(); 
    }
    
    
    }
    
     /*static testMethod void testPositive2() {
  
        Profile profile = [select id from Profile where Name = 'System Administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser123456@shinsei.com';
        user.Email='test123456@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;                
               
                 Test.startTest();     
    
    
        if(user!=null){
           // System.runAs(user){
                 Files__c fl = [select id,File_Auto_Number__c from files__c where id=:file.id];
              Files__c fl2 = [select id,File_Auto_Number__c from files__c where id=:file2.id];
           
            string JsonMsg='{"fileIDs":"'+fl.File_Auto_Number__c+','+fl2.File_Auto_Number__c +'"}';
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                
                req.requestURI = 'https://ap3.salesforce.com/services/apexrest/CurrentOwnerOfFiles';  
                req.httpMethod = 'POST';
                req.requestBody = Blob.valueof(JsonMsg);
                RestContext.request = req;
                RestContext.response = res;
                Epms_checkFileQC.doPost();
                
               
                    
          
        //}
        
        
    }
    Test.stopTest(); 
    }*/
    
    
    
}