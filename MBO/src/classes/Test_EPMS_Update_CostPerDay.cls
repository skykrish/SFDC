/**********************************************************************************
*   Class Name             :       Test_EPMS_Update_CostPerDay                   *
*   Created Date           :       17/01/2018                                    *
*   Description            :       Test Class for EPMS_Update_CostPerDay         *
**********************************************************************************/
@istest
public class Test_EPMS_Update_CostPerDay {
    
    static testMethod void Test_CostPerDay_PA() {           

        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist1222222@mbo.in';
        insert usermail;
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.Standard_Regular_Cost__c =6100;
        location.Photo_Artist_Standard_Regular_Cost__c=6100;
        location.TL_Standard_Regular_Cost__c=4575;
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.QA_Standard_Regular_Cost__c = 3050;
        
        insert location;
        
        Settings__c setting1 = new Settings__c();
        setting1.Name = 'Test';
        setting1.Percentage_SRC_PA__c = 100;
        setting1.Percentage_SRC_TL__c = 75;
        setting1.Percentage_SRC_QC__c = 50;
        setting1.Location__c = location.id;
        insert setting1;  
        
        Member__c paMember =new Member__c();
        paMember.Name='TONY';     
        paMember.Location_id__c=location.id;
        paMember.Last_Name__c='ABBOTT';
        paMember.Email__c='tonyabboott@gmail.com';
        paMember.Country__c='India';
        paMember.Designation__c=Label.EPMS_MEMBER_DESIG_OPERATOR_PS;
        paMember.Status__c='Active';
        paMember.Is_Estimator__c = True;
        //insert paMember;         
        
        //location.Location_Country__c='US';
        location.Photo_Artist_Standard_Regular_Cost__c = setting1.Percentage_SRC_PA__c;
        update location;

    }
    
    static testMethod void Test_CostPerDay_TL() {           

        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist1222222@mbo.in';
        insert usermail;
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.Standard_Regular_Cost__c =6100;
        location.Photo_Artist_Standard_Regular_Cost__c=6100;
        location.TL_Standard_Regular_Cost__c=4575;
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.QA_Standard_Regular_Cost__c = 3050;
        
        insert location;
        
        Settings__c setting1 = new Settings__c();
        setting1.Name = 'Test';
        setting1.Percentage_SRC_PA__c = 100;
        setting1.Percentage_SRC_TL__c = 75;
        setting1.Percentage_SRC_QC__c = 50;
        setting1.Location__c = location.id;
        insert setting1;  
        
        Member__c paMember =new Member__c();
        paMember.Name='TONY';     
        paMember.Location_id__c=location.id;
        paMember.Last_Name__c='ABBOTT';
        paMember.Email__c='tonyabboott@gmail.com';
        paMember.Country__c='India';
        paMember.Designation__c='Team Leader';
        paMember.Status__c='Active';
        paMember.Is_Estimator__c = True;
        //insert paMember;         
        
        //location.Location_Country__c='US';
        location.Photo_Artist_Standard_Regular_Cost__c = setting1.Percentage_SRC_PA__c;
        update location;

    }                   

    static testMethod void Test_CostPerDay_QA() {           

        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist1222222@mbo.in';
        insert usermail;
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.Standard_Regular_Cost__c =6100;
        location.Photo_Artist_Standard_Regular_Cost__c=6100;
        location.TL_Standard_Regular_Cost__c=4575;
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.QA_Standard_Regular_Cost__c = 3050;
        
        insert location;
        
        Settings__c setting1 = new Settings__c();
        setting1.Name = 'Test';
        setting1.Percentage_SRC_PA__c = 100;
        setting1.Percentage_SRC_TL__c = 75;
        setting1.Percentage_SRC_QC__c = 50;
        setting1.Location__c = location.id;
        insert setting1;  
        
        Member__c paMember =new Member__c();
        paMember.Name='TONY';     
        paMember.Location_id__c=location.id;
        paMember.Last_Name__c='ABBOTT';
        paMember.Email__c='tonyabboott@gmail.com';
        paMember.Country__c='India';
        paMember.Designation__c='Quality Control';
        paMember.Status__c='Active';
        paMember.Is_Estimator__c = True;
        insert paMember;         
        
        //location.Location_Country__c='US';
        location.Photo_Artist_Standard_Regular_Cost__c = setting1.Percentage_SRC_PA__c;
        update location;

    }                   
                        
     static testMethod void Test_CostPerDay_Error() {
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='SA';
        testRecord.Country_Initial_Letter__c='N';
        insert testRecord; 
        
        UserEmail__c emailuser= new UserEmail__c();
        String userEmail= emailuser.Email__c;
        emailuser.name='India';
        emailuser.Email__c = userEmail;
        insert emailuser;                       

        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.TL_Standard_Regular_Cost__c=4575;
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.QA_Standard_Regular_Cost__c = 3050;
        insert location;
        
        Settings__c setting1 = new Settings__c();
        setting1.Name = 'Test';
        setting1.Percentage_SRC_PA__c = 100;
        setting1.Percentage_SRC_TL__c = 75;
        setting1.Percentage_SRC_QC__c = 50;
        setting1.Location__c = location.id;
        insert setting1;  
        
        location.Location_Country__c='US';
        update location;

        }                
/*
     static testMethod void Test_CostPerDay_Member_PA() {
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.TL_Standard_Regular_Cost__c=4575;
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.QA_Standard_Regular_Cost__c = 3050;
        insert location;
        
        Member__c paMember =new Member__c();
        paMember.Name='TONY';     
        paMember.Location_id__c=location.id;
        paMember.Last_Name__c='ABBOTT';
        paMember.Email__c='tonyabboott@gmail.com';
        paMember.Country__c='India';
        paMember.Designation__c='Quality Control';
        paMember.Status__c='Active';
        paMember.Is_Estimator__c = True;
        insert paMember; 

        }                
*/  
}