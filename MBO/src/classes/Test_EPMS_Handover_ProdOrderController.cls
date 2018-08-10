/**********************************************************************************
*   Class               :       Test_EPMS_Handover_ProdOrderController            *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_Handover_ProdOrderController  *
**********************************************************************************/
@isTest
public class Test_EPMS_Handover_ProdOrderController {
    static testMethod void testProductionhandover() {
        PageReference pageRef = Page.EPMS_Production_Admin_Handover;
    
        Profile p2 = [select id from profile where name='System Administrator'];

        User u2= new User(alias = 'user1', email='userguestno2@test.com',
        emailencodingkey='UTF-8', lastname='Testing78', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p2.Id,  country='India',Country__c='India', CommunityNickname = 'user2',
        timezonesidkey='America/Los_Angeles', username='userguestno2@test.com');      

        insert u2;
    
        system.runas(u2){    
    
            Location__c location = new Location__c();
            location.Name = 'mbo test-xxxx';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='mbo test-xxxx';
            insert location;
            
            Location__c location2 = new Location__c();
            location2.Name = 'mbo test-yyy';
            location2.Location_Country__c='India';
            location2.Location_Status__c ='Active';
            location2.Group_Name__c='mbo test-yyy';
            insert location2;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='vikram07@gmail.com';
            insert usermail;
    
            
            Member__c member =new Member__c();
            member.Name='testQC';     
            member.Location_id__c=location.id;
            member.Last_Name__c='testlastQC';
            member.Email__c='mboxxx@test.com';
            member.Country__c='India';
            member.Designation__c='Production Administrator';
            member.Status__c='Active';
            //insert member;
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            po.Location_For_Sharing__c=location.Name;
            insert po;
            
            
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;            
            insert fc;
    
            
            Files__c file= new Files__c();
            file.Name ='testFile';
            file.Production_Order__c =po.id;
            file.File_Category_Code__c =fc.id;
            file.Status__c ='New';
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            insert file; 
            
            Test.StartTest(); 
            
            string basepath='Order';
                
            Test.setCurrentPage(pageRef);  
            pageRef.getParameters().put('ids',po.id);
            pageRef.getParameters().put('type',basepath);
    
            EPMS_Handover_ProductionOrder_Controller handoverpro2=new EPMS_Handover_ProductionOrder_Controller();
          
            handoverpro2.strSelCountry=po.Mbo_Location__r.Location_Country__c; 
            handoverpro2.selectvalue=location2.Id;
            handoverpro2.selectLocationCode=po.MBO_Location__c;
            handoverpro2.basepath=basepath;
            handoverpro2.Handover(); 
            
            handoverpro2.Userlocation = location.Id;
            handoverpro2.Handover();            
        } 
            Test.stopTest();
    }
}