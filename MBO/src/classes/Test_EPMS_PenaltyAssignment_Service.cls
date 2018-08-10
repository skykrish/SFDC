/**********************************************************************************
*   Class               :       Test_EPMS_PenaltyAssignment_Service                  *
*   Created Date        :       11/01/2018                                           *
*   Description         :       Test Class for EPMS_PenaltyAssignment_Service        *
**********************************************************************************/
@isTest
private class Test_EPMS_PenaltyAssignment_Service {
    
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
        
        Mistakes__c mistake = new Mistakes__c();
        mistake.Penalty_for_Artist__c = 50;
        mistake.Penalty_for_QC__c = 25;
        mistake.Mistake_Description__c = 'Test Creation of mistake :::';
        mistake.MIstake_Category__c = 'COMMON MISTAKES';
        mistake.Mistake__c = 'HOLES REMAINING';
        mistake.Location__c = location.Id;
        insert mistake;         
        
        Production_Order__c po = new Production_Order__c();
        po.Name ='MD-0091201';
        po.Anken_Order__c = anken.id;
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        insert po;
            
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='testFC';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        insert fc;
            
        Member__c member =new Member__c();
        member.Name='TestQCMember';     
        member.Location_id__c=location.id;
        member.Last_Name__c='testlastQC';
        member.Email__c='testFirsttestlastQC@gmail.com';
        member.Country__c='India';
        member.Designation__c='Quality Control';
        member.Status__c='Active';
        insert member;        

        Files__c file= new Files__c();
        file.Name ='AssignPenaltyFile';
        file.Production_Order__c =po.id;
        file.File_Category_Code__c =fc.id;
        file.Status__c ='Redo';
        file.File_Location__c=location.id;
        file.Current_Extension__c ='.jpg';
        file.File_Type__c = 'Image';
        file.Member__c = member.Id;
        file.IsSplitedFile__c = true;
        file.Total_Work_time__c = 220;
        insert file;
        
    }
    static testMethod void testDoPost1() {
        
        Files__c fileObj  =  [Select id, Name, File_Auto_Number__c From Files__c where Name = 'AssignPenaltyFile' Limit 1];      
        Location__c location = [select Id, Name from Location__c where Name = 'INDIA PRIVATE LIMITED'];
        Mistakes__c mistake = [Select id, Name, MIstake_Category__c, Mistake__c From Mistakes__c where Location__c =: location.Id];
        Member__c member = [select Id, Name from Member__c where Name='TestQCMember'];

        Test.startTest();
        
        String fileid = fileObj.File_Auto_Number__c;
        String locationName = location.Name;
        String mistakeNo = mistake.Name; 
        String SkipPenalty1 = '0';
        String SkipPenalty2 = '1';
        String QCComments1 = mistake.MIstake_Category__c + '|' + mistake.Mistake__c + '|' + 'Test Comments';
        String QCComments2 = mistake.MIstake_Category__c + '|' + mistake.Mistake__c;
        String memberId = member.Id;
            
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/PenaltyAssignment_Service';
        req2.httpMethod = 'POST';
        
        RestContext.request = req2;
        RestContext.response = res2;
        
        EPMS_PenaltyAssignment_Service.doPost(fileid,mistakeNo,locationName,SkipPenalty1,QCComments1,memberId);
        EPMS_PenaltyAssignment_Service.doPost(fileid,mistakeNo,locationName,SkipPenalty2,QCComments2,memberId);
        Test.stopTest(); 
    }    
}