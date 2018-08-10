/**********************************************************************************
*   Class               :       Test_EPMS_instructiontree                      *
*   Created Date        :       18/04/2016                                        *
*   Description         :       Test Class for EPMS_instructiontree               *
**********************************************************************************/

@isTest
public class Test_EPMS_InstructionUpdate  {
    
    static testMethod void test_EPMS_InstructionUpdate () {
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='Active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testmbo@mbo.in';
        insert usermail;
        
        List<Member__c> memberList = new List<Member__c>();
        Member__c member =new Member__c();
        member.Name='testQC';     
        member.Location_id__c=location.id;
        member.Last_Name__c='testlastQC';
        member.Email__c='testFirsttestlastQC@gmail.com';
        member.Country__c='India';
        member.Designation__c='Team Leader';
        member.Status__c='Active';
        memberList.add(member);
        
        Member__c member2 =new Member__c();
        member2.Name='Stephen';     
        member2.Location_id__c=location.id;
        member2.Last_Name__c='Scott';
        member2.Email__c='testFirsttestlastOP@gmail.com';
        member2.Country__c='India';
        member2.Designation__c='Quality Control';
        member2.Status__c='Active';
        memberList.add(member2);
        
        Member__c member3 =new Member__c();
        member3.Name='test-Artist';     
        member3.Location_id__c=location.id;
        member3.Last_Name__c='Tiger';
        member3.Email__c='testFirsttestlastOP2@gmail.com';
        member3.Country__c='India';
        member3.Designation__c='Photo Artists';
        member3.Status__c='Active';
        memberList.add(member3);
        
        Test.StartTest();
        
        if(memberList.size() > 0){
            insert memberList;
        }
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c anken=new Anken__c(KokyakuName__c=acc.Id,Status__c='Open',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                                    Nouki_Date__c= system.Today().AddDays(1));
        insert anken;

        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO_22';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.QC_Incharge__c=memberList[1].id;
        po.TL_Incharge__c=memberList[0].id;
        PO.Production_Order_Instruction__c=ANKEN.Sagyoshiji_Renrakujiko__c;
        po.Production_Order_TAT__c= DateTime.Now().AddDays(1);
        insert po;

        List<Production_Order__c> JobList=new List<Production_Order__c>();           
        
        List<String> selectedJobId=new  List<String>();
        
        Job_Titles__c jobs=new Job_Titles__c(Name='Alpha'); 
        insert jobs;
        
        Job_Titles__c jobs1=new Job_Titles__c(Name='Alpha Channel Masking'); 
        insert jobs1;
        
        Job_Titles__c jobs2=new Job_Titles__c(Name='Clipping'); 
        insert jobs2;  
        
        selectedJobId.add(jobs2.Name);
        selectedJobId.add(jobs1.Name);
        selectedJobId.add(jobs.Name);
        
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='testFC';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;            
        insert fc; 
        
        Files__c filedirpar= new Files__c();
        filedirpar.Name ='Wild';
        filedirpar.Production_Order__c =po.id;
        filedirpar.File_Category_Code__c =fc.id;
        filedirpar.File_Preview_URL__c='http://117.239.57.206:8003/po.Name/anken.Name/Wild';
        filedirpar.Status__c ='New';
        filedirpar.File_Location__c=location.id;
        filedirpar.instruction__c='test ins';
        filedirpar.Current_Extension__c ='.jpg';
        filedirpar.File_Type__c = 'Directory';            
        
        Files__c filedir= new Files__c();
        
        filedir.Name ='wild1';
        filedir.Production_Order__c =po.id;
        filedir.File_Category_Code__c =fc.id;
        filedir.File_Preview_URL__c='http://117.239.57.206:8003/po.Name/anken.Name/Wild1';
        filedir.Status__c ='New';
        filedir.File_Location__c=location.id;
        filedir.instruction__c='test ins';
        filedir.Current_Extension__c ='.jpg';
        filedir.Parent_Id__c=filedirpar.Id;            
        filedir.File_Type__c = 'Directory';
        
        Files__c file= new Files__c();
        file.Name ='wallpaper-hd-1080p_gdzCfcM.jpg';
        file.Production_Order__c =po.id;
        file.File_Category_Code__c =fc.id;
        file.File_Preview_URL__c='http://117.239.57.206:8003/po.Name/anken.Name/Wild/wild1/wallpaper-hd-1080p_gdzCfcM.jpg';
        file.Status__c ='New';
        file.Instructionnames__c='Test Data';
        file.File_Location__c=location.id;
        file.Current_Extension__c ='.jpg';
        file.File_Type__c = 'Instruction';
        file.Parent_Id__c=filedirpar.Id;
        file.Splitted_Parent_id__c=filedir.Id;
        file.Order_Instructions__c=po.Production_Order_Instruction__c;
        file.Files_To_Open__c=0;
        
        Files__c file11= new Files__c();
        file11.Name ='wallpaper-hd-1080p_gdzCfcM1.jpg';
        file11.Production_Order__c =po.id;
        file11.File_Category_Code__c =fc.id;
        file11.File_Preview_URL__c='http://117.239.57.206:8003/po.Name/anken.Name/Wild/wild1/wallpaper-hd-1080p_gdzCfcM1.jpg';
        file11.Status__c ='New';
        file11.File_Location__c=location.id;
        file11.Current_Extension__c ='.jpg';
        file11.File_Type__c = 'Image';
        file11.Parent_Id__c=filedirpar.Id;
        file11.Splitted_Parent_id__c=filedir.Id;
        file11.Order_Instructions__c=po.Production_Order_Instruction__c;
        file11.Files_To_Open__c=0;            
        
        list<files__c> FileList=new list<Files__c>();
        FileList.add(filedirpar);
        FileList.add(filedir);     
        
        FileList.add(file); 
        FileList.add(file11); 
        insert FileList; 
        
        po.Production_Order_Instruction__c='New Instructions';
        update po;
 
    }
}