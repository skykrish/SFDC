/**********************************************************************************
*   Class               :       clsTest_EPMS_Trg_DeleteMistake                    *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_Trg_DeleteMistake             *
**********************************************************************************/

@isTest
private class  clsTest_EPMS_Trg_DeleteMistake{


   static testMethod void DeleteMistakeFail()
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
            
            
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;     
            
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist123@mbo.in';
        insert usermail;

        Test.StartTest();

        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists@gmail.com';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        member.Status__c='Active';
        insert member;     
            
            
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='QCIP';
        po.MBO_Location__c=location.Id;
        insert po;




        File_Categories__c fc= new File_Categories__c();
        fc.Name ='AB';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;

        insert fc;

        Files__c folderfile = new Files__c();
        folderfile.Name ='Ordinary_Folder_Test_1';
        folderfile.Production_Order__c =po.id;
        folderfile.File_Category_Code__c =fc.id;
        folderfile.Status__c ='QCIP';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Image';
        folderfile.Member__c = member.Id;
        insert folderfile;  
        
        
       
        
        Mistakes__c mistake=new Mistakes__c();
        mistake.Location__c=location.id;      
        mistake.Mistake__c='HOLES REMAINING';
        mistake.MIstake_Category__c='COMMON MISTAKES';
        mistake.Penalty_for_QC__c=10;
        mistake.Penalty_for_Artist__c=5;
        insert mistake;
        
        
        Penalty_Assignment__c penalty=new Penalty_Assignment__c();
        penalty.Member__c=folderfile.Member__c;
        penalty.File_Name__c=folderfile.Id;
        penalty.Mistake_Id__c=mistake.id;
        penalty.Is_Skipped_File__c=false;
        insert penalty;
            
           

            
            Exception e;
           
            
            try{
                delete mistake;
               } catch(Exception ex){
                e = ex;
            }           
            
            
            system.assertNotEquals(null, e);
            system.assert(e instanceOf system.Dmlexception);
            system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));

            Test.StopTest();

       
    }
    
}

 static testMethod void updateMistake()
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
            location.Name = 'INDIA PRIVATE LIMITED - Phase5';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase5';
            insert location;
            
             Location__c location1 = new Location__c();
            location1 .Name = 'INDIA1 PRIVATE LIMITED - Phase5';
            location1 .Location_Country__c='India';
            location1 .Location_Status__c ='Active';
            location1 .Group_Name__c='INDIA1 PVT LTD -Phase5';
            insert location1 ;
            

            

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;     
                
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testphotoartist123@mbo.in';
            insert usermail;
            
             Test.StartTest();

        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists@gmail.com';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        member.Status__c='Active';
        insert member;     
            
            
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='QCIP';
        po.MBO_Location__c=location.Id;
        insert po;


        List<Files__c> fileList = new List<Files__c>();

        File_Categories__c fc= new File_Categories__c();
        fc.Name ='AB';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;

        insert fc;

        Files__c folderfile = new Files__c();
        folderfile.Name ='Ordinary_Folder_Test_1';
        folderfile.Production_Order__c =po.id;
        folderfile.File_Category_Code__c =fc.id;
        folderfile.Status__c ='QCIP';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Image';
        folderfile.Member__c = member.Id;
        insert folderfile;  
        
        
       
        
        Mistakes__c mistake=new Mistakes__c();
        mistake.Location__c=location.id;      
        mistake.Mistake__c='HOLES REMAINING';
        mistake.MIstake_Category__c='COMMON MISTAKES';
        mistake.Penalty_for_QC__c=10;
        mistake.Penalty_for_Artist__c=5;
        insert mistake;
        
        
        Penalty_Assignment__c penalty=new Penalty_Assignment__c();
        penalty.Member__c=folderfile.Member__c;
        penalty.File_Name__c=folderfile.Id;
        penalty.Mistake_Id__c=mistake.id;
        penalty.Is_Skipped_File__c=false;
        insert penalty;     
                        
           

            
            Exception e;
            

            try{
                mistake.Mistake__c='Path Incompleted';
                mistake.MIstake_Category__c='SERIOUS MISTAKES';
                mistake.Penalty_for_QC__c=15;
                mistake.Location__c=location1.id;      
                update mistake;
               } catch(Exception ex){
                e = ex;
            }           
            
            system.assertNotEquals(null, e);
            system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));

            Test.StopTest();

       
    }
    
}


}