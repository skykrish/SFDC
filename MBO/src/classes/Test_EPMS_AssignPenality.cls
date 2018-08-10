/**********************************************************************************
*   Class               :       Test_EPMS_AssignPenality                       *
*   Created Date        :       04/04/2016                                        *
*   Description         :       Test Class for EPMS_AssignPenality                *
**********************************************************************************/
@isTest
public class Test_EPMS_AssignPenality {
    
    static testMethod void EPMS_AssignPenality(){
    
        PageReference pageRef = Page.AssignPenality;
    
        
        Location__c location = new Location__c();
        location.Name = 'mbo test-21032016';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-21032016';
        insert location;
        
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='PO-21032016';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.Location_For_Sharing__c=location.Name;
        insert po;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
             
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='rvikram07@gmail.com';
        insert usermail;
        
        Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
        insert team;
        
        Member__c member = new Member__c(); 
        member.Name='test';     
        member.Location_id__c=location.id;
        member.First_Name__c='testFirst';
        member.Last_Name__c='testlast';
        member.Email__c='testsalesforce21032016@mbo.in';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        member.Status__c='Active';
        member.Team_Id__c=team.id;
        insert member;     
        
        Member__c member1 = new Member__c(); 
        member1.Name='test';     
        member1.Location_id__c=location.id;
        member1.First_Name__c='testFirst';
        member1.Last_Name__c='testlastqc';
        member1.Email__c='testsalesforce21032016qc@mbo.in';
        member1.Country__c='India';
        member1.Designation__c='Quality Control';
        member1.Status__c='Active';
        member1.Team_Id__c=team.id;
        insert member1; 
        
        
        system.debug('user member1:'+member1.User_Id__c);
        
        File_Categories__c fileCategory = new File_Categories__c();
        fileCategory.Name = 'Test';
        fileCategory.Standard_Time_per_File_Min__c=11;
        fileCategory.Standard_Time_per_File_Max__c=20;
        fileCategory.Standard_Regular_Cost_per_File__c=3;
        fileCategory.Standard_OptionalCost_Per_file__c=1;
        insert fileCategory;   
        
        List<Files__c> fileList = new List<Files__c>();
        
        
        Files__c file = new Files__c();
        file.File_Location__c=location.Id;
        file.Production_Order__c=po.id;
        file.Name='file-21032016';
        file.File_Category_Code__c=fileCategory.id;
        file.Status__c='QC';
        file.Member__c=member.Id;
        file.QCIncharge__c=member1.Id;
        file.Current_Extension__c='.jpg';
        
        Files__c file1= new Files__c();
        file1.Production_Order__c=po.id;
        file1.File_Location__c=location.Id;
        file1.Name='file-210320162';
        file1.File_Category_Code__c=fileCategory.id;
        file1.Status__c='QC';
        file1.Member__c=member.Id;
        file1.QCIncharge__c=member1.Id;
        file1.Current_Extension__c='.jpg';
        fileList.add(file);
        fileList.add(file1);
        insert fileList;
        
        Mistakes__c mistake=new Mistakes__c();
        mistake.Location__c=location.Id;
        mistake.Mistake__c='HOLES REMAINING';
        mistake.MIstake_Category__c='COMMON MISTAKES';
        mistake.Penalty_for_Artist__c=25;
        mistake.Penalty_for_QC__c=35;
        insert mistake;
        
        
        Mistakes__c mistake1=new Mistakes__c();
        mistake1.Location__c=location.Id;
        mistake1.Mistake__c=null;
        mistake1.MIstake_Category__c=null;    
        insert mistake1; 
        
        
        Mistakes__c mistake2=new Mistakes__c();
        mistake2.Location__c=location.Id;
        mistake2.Mistake__c='HOLES REMAINING';
        mistake2.MIstake_Category__c=null;   
        insert mistake2;    
        
        Penalty_Assignment__c penalty=new Penalty_Assignment__c();
        penalty.Member__c=member.Id;
        penalty.File_Name__c=file.Id;
        penalty.Is_Skipped_File__c=false;
        penalty.Mistake_Id__c=mistake.Id;
        penalty.Comments__c='some text are misssing in files';
        insert penalty;
        
        
        Penalty_Assignment__c skippenalty=new Penalty_Assignment__c();
        skippenalty.Member__c=member.Id;
        skippenalty.File_Name__c=file1.Id;
        skippenalty.Is_Skipped_File__c=false;
        skippenalty.Mistake_Id__c=mistake1.Id;
        skippenalty.Comments__c='some text are misssing in files';
        insert skippenalty;
        
       
        
        Test.StartTest(); 
        
        string basepath='file';
            
        Test.setCurrentPage(pageRef);  
        pageRef.getParameters().put('ids',file1.id);
        pageRef.getParameters().put('type',basepath);
        
        EPMS_AssignPenality controller = new EPMS_AssignPenality(new ApexPages.StandardController(mistake)); 
        controller.isSkipPenalty=false;
        penalty.Is_Skipped_File__c=false;
        controller.saveList(fileList,mistake);    
        controller.Save();
       // controller.getListOfPenalities();
        
        Test.setCurrentPage(pageRef);  
        pageRef.getParameters().put('ids',file.id);
        pageRef.getParameters().put('type',basepath);
        
        EPMS_AssignPenality controller1 = new EPMS_AssignPenality(new ApexPages.StandardController(mistake1)); 
        controller1.isSkipPenalty=true;  
        penalty.Is_Skipped_File__c=true;
        controller1.saveList(fileList,mistake1);
        controller1.Save(); 
        
        
        Test.setCurrentPage(pageRef);  
        pageRef.getParameters().put('ids',file.id);
        pageRef.getParameters().put('type',basepath); 
          
        EPMS_AssignPenality controller2 = new EPMS_AssignPenality(new ApexPages.StandardController(mistake2)); 
        list<Penalty_Assignment__c> penalties=[select Penalty_Level__c from Penalty_Assignment__c where id=:penalty.Id];
        list<SelectOption> testoptions = controller2.getListOfPenalities();
        controller2.isSkipPenalty=true; 
        controller2.saveList(fileList,mistake2);
        controller2.save();
        Test.stopTest();
    
    
    }
}