/************************************************************************************
*   Class               :       Test_EPMS_Update_SRCF_SOCF                          *
*   Created Date        :       23/01/2018                                          *
*   Description         :       Test Class for EPMS_Update_SRCF_SOCF                *
************************************************************************************/
@isTest
private class Test_EPMS_Update_SRCF_SOCF {
    
    @testSetup static void setupTestData(){
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2';
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
        
        Production_Order__c po = new Production_Order__c();
        po.Name ='MD-0091201';
        po.Anken_Order__c = anken.id;
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        insert po;
            
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='TestFC';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        insert fc;

        Files__c file1= new Files__c();
        file1.Name ='SRCF_SOCF1';
        file1.Production_Order__c =po.id;
        file1.File_Category_Code__c =fc.id;
        file1.Individual_Performance_Category__c = fc.id;
        file1.Status__c ='Redo';
        file1.File_Location__c=location.id;
        file1.Current_Extension__c ='.jpg';
        file1.File_Type__c = 'Image';
        file1.IsSplitedFile__c = true;
        file1.Total_Work_time__c = 220;
        file1.File_Job_Titles__c='Alpha,Cripping';
        insert file1;
        
        Files__c file2= new Files__c();
        file2.Name ='SRCF_SOCF2';
        file2.Production_Order__c =po.id;
        file2.File_Category_Code__c =fc.id;
        file2.Individual_Performance_Category__c = fc.id;
        file2.Status__c ='Redo';
        file2.File_Location__c=location.id;
        file2.Current_Extension__c ='.jpg';
        file2.File_Type__c = 'Image';
        file2.IsSplitedFile__c = true;
        file2.Total_Work_time__c = 220;
        file2.File_Job_Titles__c='Alpha,Cripping';
        insert file2;        
   
        Files__c file3= new Files__c();
        file3.Name ='SRCF_SOCF3';
        file3.Production_Order__c =po.id;
        file3.File_Category_Code__c =fc.id;
        file3.Individual_Performance_Category__c = fc.id;
        file3.Status__c ='QC';
        file3.File_Location__c=location.id;
        file3.Current_Extension__c ='.jpg';
        file3.File_Type__c = 'Image';
        file3.IsSplitedFile__c = true;
        file3.Total_Work_time__c = 220;
        file3.File_Job_Titles__c='Alpha,Cripping';
        insert file3;
        
        Files__c file4= new Files__c();
        file4.Name ='SRCF_SOCF4';
        file4.Production_Order__c =po.id;
        file4.File_Category_Code__c =fc.id;
        //file4.Individual_Performance_Category__c = fc.id;
        file4.Status__c ='QC';
        file4.File_Location__c=location.id;
        file4.Current_Extension__c ='.jpg';
        file4.File_Type__c = 'Image';
        file4.IsSplitedFile__c = true;
        file4.Total_Work_time__c = 220;
        file4.File_Job_Titles__c='Alpha,Cripping';
        insert file4;     

        Files__c file5= new Files__c();
        file5.Name ='SRCF_SOCF5';
        file5.Production_Order__c =po.id;
        file5.File_Category_Code__c =fc.id;
        file5.Individual_Performance_Category__c = fc.id;
        file5.Status__c ='QC';
        file5.File_Location__c=location.id;
        file5.Current_Extension__c ='.jpg';
        file5.File_Type__c = 'Image';
        file5.IsSplitedFile__c = true;
        file5.Total_Work_time__c = 220;
        file5.File_Job_Titles__c='Clipping';
        insert file5;     

        Files__c file6= new Files__c();
        file6.Name ='SRCF_SOCF6';
        file6.Production_Order__c =po.id;
        file6.File_Category_Code__c =fc.id;
        file6.Status__c ='QC';
        file6.File_Location__c=location.id;
        file6.Current_Extension__c ='.jpg';
        file6.File_Type__c = 'Image';
        file6.IsSplitedFile__c = true;
        file6.Total_Work_time__c = 220;
        file6.File_Job_Titles__c='Clipping';
        insert file6; 
                     
    }
    static testMethod void testDoPost1() {
        
        List<Files__c> fileList = new List<Files__c>();
        
        Files__c fileObj1  =  [select Id, Name, Status__c, Individual_Performance_Category__c, Job_Type__c, File_Job_Titles__c, SRCF__c, SOCF__c from Files__c where Name = 'SRCF_SOCF1' Limit 1];
        Files__c fileObj2  =  [select Id, Name, Status__c, Individual_Performance_Category__c, Job_Type__c, File_Job_Titles__c, SRCF__c, SOCF__c from Files__c where Name = 'SRCF_SOCF2' Limit 1];      
        Files__c fileObj3  =  [select Id, Name, Status__c, Individual_Performance_Category__c, Job_Type__c, File_Job_Titles__c, SRCF__c, SOCF__c from Files__c where Name = 'SRCF_SOCF6' Limit 1];
        File_Categories__c fCategory = [select Id, Name, Standard_Regular_Cost_per_File__c, Standard_OptionalCost_Per_file__c from File_Categories__c where Name ='TestFC' Limit 1];

        File_Categories__c fc2= new File_Categories__c();
        fc2.Name ='TestFC2';
        fc2.Standard_Time_per_File_Min__c =11;
        fc2.Standard_Time_per_File_Max__c =20;
        fc2.Standard_Regular_Cost_per_File__c =934;
        fc2.Standard_OptionalCost_Per_file__c =5;
        insert fc2;  

        File_Categories__c fc3= new File_Categories__c();
        fc3.Name ='TestFC3';
        fc3.Standard_Time_per_File_Min__c =11;
        fc3.Standard_Time_per_File_Max__c =20;
        fc3.Standard_Regular_Cost_per_File__c =934;
        fc3.Standard_OptionalCost_Per_file__c =5;
        insert fc3;  

        Test.startTest();        
        
        
        fileObj1.Status__c = 'Approved';
        fileObj1.File_Job_Titles__c = 'Clipping';
        fileObj1.Individual_Performance_Category__c = fc2.id;

        fileObj2.Status__c = 'Approved';
        fileObj2.File_Job_Titles__c = 'Alpha,Cripping';
        fileObj2.Individual_Performance_Category__c = fc3.id;
        
        fileObj3.File_Job_Titles__c = 'Alpha,Cripping';
        
        fileList.add(fileObj1);
        fileList.add(fileObj2);
        fileList.add(fileObj3);
                
        UPDATE fileList;

        Test.stopTest(); 
    }    
      
}