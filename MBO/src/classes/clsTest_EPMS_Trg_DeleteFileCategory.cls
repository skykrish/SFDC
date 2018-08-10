/**********************************************************************************
*   Class               :       clsTest_EPMS_Trg_DeleteFileCategory               *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_Trg_DeleteFileCategory        *
**********************************************************************************/
@isTest
private class  clsTest_EPMS_Trg_DeleteFileCategory{ 

   static testMethod void DeleteFileCategory()
   {
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
            
        System.runAs(user){
                         
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase2';
            insert location;

            
            File_Categories__c category=new File_Categories__c();
            category.Name='A';
            category.Standard_Time_per_File_Max__c=5;
            category.Standard_Time_per_File_Min__c=3;
            category.Standard_OptionalCost_Per_file__c=300;
            insert category;
            
            
            Production_Order__c pOrder= new Production_Order__c();
            pOrder.Name = 'TestPO';
            pOrder.MBO_Location__c=location.Id;
            pOrder.Production_Order_Status__c='New';
            insert pOrder;                    
            
            
            Files__c file=new Files__c();
            file.Production_Order__c=pOrder.Id;
            file.Name='file123';
            file.Status__c='New';
            file.Current_Extension__c='TIFF';
            file.File_Category_Code__c=category.Id;
            file.File_Location__c=pOrder.MBO_Location__c;
            insert file;
            
            category.Name='B';

          
            Test.StartTest();
            
            Exception e;
           
            
            try{
                
                delete category;
                update category;
                
               } catch(Exception ex){
                e = ex;
            } 
    
            system.assertNotEquals(null, e);
            system.assert(e instanceOf system.Dmlexception);
            system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));

            Test.StopTest();

       
    }
    
}
}