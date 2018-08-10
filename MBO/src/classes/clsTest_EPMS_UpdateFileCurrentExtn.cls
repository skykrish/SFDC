/**********************************************************************************
*   Class               :       clsTest_EPMS_UpdateFileCurrentExtension           *
*   Created Date        :       01/04/2016                                        *
*   Description         :       Test Class for EPMS_UpdateFileCurrentExtension    *
**********************************************************************************/
@istest
Public class clsTest_EPMS_UpdateFileCurrentExtn{
    
    public static testMethod void EPMS_file_extn_update() {
    
    Location__c location = new Location__c();
    location.Name = 'INDIA PRIVATE LTD - Phase-25';
    location.Location_Country__c='India';
    location.Location_Status__c ='Active';
    location.Group_Name__c='INDIA PRIVATE LTD - Phase-25';
    insert location;
    
    Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
    testRecord.Name='India';
    testRecord.Country_Initial_Letter__c='I';
    insert testRecord;
        
    UserEmail__c usermail=new UserEmail__c();
    usermail.Name='New User Email';
    usermail.Email__c='rvikram07@gmail.com';
    insert usermail;
    
    Production_Order__c po2=new Production_Order__c();
    po2.Name ='O0002540';
    po2.Production_Order_Status__c ='New';
    po2.MBO_Location__c=location.Id;
    insert po2;
        
    File_Categories__c fc= new File_Categories__c();
    fc.Name ='B';
    fc.Standard_Time_per_File_Min__c =11;
    fc.Standard_Time_per_File_Max__c =20;
    fc.Standard_Regular_Cost_per_File__c =934;
    fc.Standard_OptionalCost_Per_file__c =5;
    
    insert fc;
        
        
    Files__c newFile = new Files__c();
    newFile.Name = 'Test_C_Image.jpg';
    newFile.Production_Order__c =po2.id;
    newFile.File_Category_Code__c =fc.id;
    newFile.Status__c ='Assigned';
    newFile.File_Location__c=location.id;
    newFile.Current_Extension__c ='.jpg';
    newFile.File_Type__c = 'Directory';  
    insert newFile;
    
    newFile.Current_Extension__c ='.psd';
    update newFile;
    
    }
    

}