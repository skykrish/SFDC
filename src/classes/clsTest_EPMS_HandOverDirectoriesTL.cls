/**********************************************************************************
*   Class               :       clsTest_EPMS_HandOverDirectoriesTL                *
*   Created Date        :       01/04/2016                                        *
*   Description         :       Test Class for EPMS_HandOverDirectoriesTL         *
**********************************************************************************/
@istest
Public class clsTest_EPMS_HandOverDirectoriesTL{
    
    
    @testSetup static void setupTestData(){ 
    
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;

        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='rvikram07@gmail.com';
        insert usermail;

        List<Member__c> memberList = new List<Member__c>();

        Member__c qcmember =new Member__c();
        qcmember.Name='TONY';     
        qcmember.Location_id__c=location.id;
        qcmember.Last_Name__c='ABBOTT';
        qcmember.Email__c='tonyabboott3@gmail.com';
        qcmember.Country__c='India';
        qcmember.Designation__c='Quality Control';
        qcmember.Status__c='Active';
        memberList.add(qcmember);


        Member__c qcmember2 =new Member__c();
        qcmember2.Name='CHRIS';     
        qcmember2.Location_id__c=location.id;
        qcmember2.Last_Name__c='MORRIS';
        qcmember2.Email__c='chrismorris@gmail.com';
        qcmember2.Country__c='India';
        qcmember2.Designation__c='Quality Control';
        qcmember2.Status__c='Active';
        memberList.add(qcmember2);
        
        Member__c tlmember2 =new Member__c();
        tlmember2.Name='BENZ';     
        tlmember2.Location_id__c=location.id;
        tlmember2.Last_Name__c='PARK';
        tlmember2.Email__c='benzpark@gmail.com';
        tlmember2.Country__c='India';
        tlmember2.Designation__c='Team Leader';
        tlmember2.Status__c='Active';
        memberList.add(tlmember2);
        
        Member__c tlmember =new Member__c();
        tlmember.Name='LOUIS';     
        tlmember.Location_id__c=location.id;
        tlmember.Last_Name__c='HAMILTON';
        tlmember.Email__c='hamiltonlouis@gmail.com';
        tlmember.Country__c='India';
        tlmember.Designation__c='Team Leader';
        tlmember.Status__c='Active';
        memberList.add(tlmember);
        
        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists@gmail.com';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        member.Status__c='Active';
        memberList.add(member);
        
        if(memberList.size() > 0){
            insert memberList;
        }
        
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'Morning Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift;
        
        Team__c team1 = new Team__c();
        team1.Name='Beta Team';
        team1.Location__c=location.id;             
        insert team1;

        Team__c team2 = new Team__c();
        team2.Name='Alpha Team';
        team2.Location__c=location.id;             
        insert team2;
        
        Member__c alphaTL = [SELECT Id, Name, Team_Id__c FROM Member__c WHERE Last_Name__c='HAMILTON'];
        Member__c alphaQC = [SELECT Id, Name, Team_Id__c FROM Member__c WHERE Last_Name__c='MORRIS'];
        Member__c betaTL = [SELECT Id, Name, Team_Id__c FROM Member__c WHERE Last_Name__c='PARK'];
        Member__c betaQC = [SELECT Id, Name, Team_Id__c FROM Member__c WHERE Last_Name__c='ABBOTT'];
        
        List<Member__c> toBeUpdatedMember = new List<Member__c>();
        
        if(alphaTL != null){
            alphaTL.Team_Id__c = team2.Id;
            toBeUpdatedMember.add(alphaTL);
        }
        
        if(alphaQC != null){
            alphaQC.Team_Id__c = team2.Id;
            toBeUpdatedMember.add(alphaQC);
        }
        
        if(betaTL != null){
            betaTL.Team_Id__c = team1.Id;
            toBeUpdatedMember.add(betaTL);
        }
        
        if(betaQC != null){
            betaQC.Team_Id__c = team1.Id;
            toBeUpdatedMember.add(betaQC);
        }
        
        if(toBeUpdatedMember.size() > 0){
            update toBeUpdatedMember;
        }
        
        List<Shift_Assignments__c> shiftList = new List<Shift_Assignments__c>();
        
        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        shiftass.Member__c=alphaTL.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        shiftList.add(shiftass);
        
        Shift_Assignments__c shiftass1=new Shift_Assignments__c();
        shiftass1.Shift_Code__c=shift.id;
        shiftass1.Member__c=alphaQC.id;
        shiftass1.Location__c=location.id;
        shiftass1.FromTime__c=system.today();
        shiftass1.Shift_Assigned__c=true;
        shiftList.add(shiftass1);
        
        Shift_Assignments__c shiftass2=new Shift_Assignments__c();
        shiftass2.Shift_Code__c=shift.id;
        shiftass2.Member__c=betaTL.id;
        shiftass2.Location__c=location.id;
        shiftass2.FromTime__c=system.today();
        shiftass2.Shift_Assigned__c=true;
        shiftList.add(shiftass2);
        
        Shift_Assignments__c shiftass3=new Shift_Assignments__c();
        shiftass3.Shift_Code__c=shift.id;
        shiftass3.Member__c=betaQC.id;
        shiftass3.Location__c=location.id;
        shiftass3.FromTime__c=system.today();
        shiftass3.Shift_Assigned__c=true;
        shiftList.add(shiftass3);
        
        if(shiftList.size() > 0){
            insert shiftList;
        }
        
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        insert po;
        
        Production_Order__c po2=new Production_Order__c();
        po2.Name ='O0002540';
        po2.Production_Order_Status__c ='New';
        po2.MBO_Location__c=location.Id;
        insert po2;
            
            
        List<Files__c> fileList = new List<Files__c>();

        File_Categories__c fc= new File_Categories__c();
        fc.Name ='AB';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        
        insert fc;
        
        files__c file1= new Files__c();
        file1.Name ='Handover_FILE_Test';
        file1.Production_Order__c =po.id;
        file1.File_Category_Code__c =fc.id;
        file1.Status__c ='Assigned';
        file1.File_Location__c=location.id;
        file1.Current_Extension__c ='.jpg';
        file1.File_Type__c = 'Directory';                
        insert file1;            
        
         for(Integer i=1;i<=5;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_'+i;
            file.Production_Order__c =po.id;
            file.File_Category_Code__c =fc.id;
            file.Status__c ='Assigned';
            file.Parent_Id__c=file.Id;
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            file.File_Type__c = 'Image'; 
            file.TLInCharge__c= alphaTL.Id;
            file.QCInCharge__c= alphaQC.Id;
            file.Member__c = member.Id;
            fileList.add(file);
        }
        insert fileList;
        
        Files__c rootFold = new Files__c();
        rootFold.Name ='Root_Folder_Test';
        rootFold.Production_Order__c =po2.id;
        rootFold.File_Category_Code__c =fc.id;
        rootFold.Status__c ='Assigned';
        rootFold.File_Location__c=location.id;
        rootFold.Current_Extension__c ='.jpg';
        rootFold.File_Type__c = 'Directory';                
        insert rootFold;   
        
        Files__c subFold = new Files__c();
        subFold.Name ='Sub_Folder_Test';
        subFold.Production_Order__c =po2.id;
        subFold.File_Category_Code__c =fc.id;
        subFold.Status__c ='Assigned';
        subFold.File_Location__c=location.id;
        subFold.Current_Extension__c ='.jpg';
        subFold.File_Type__c = 'Directory';   
        subFold.Parent_Id__c=rootFold.Id;             
        insert subFold;
        
        Files__c subFile = new Files__c();
        subFile.Name ='Sub_File_In_Sub_Folder_Test';
        subFile.Production_Order__c =po2.id;
        subFile.File_Category_Code__c =fc.id;
        subFile.Status__c ='Assigned';
        subFile.File_Location__c=location.id;
        subFile.Current_Extension__c ='.jpg';
        subFile.File_Type__c = 'Image';   
        subFile.Parent_Id__c=subFold.Id;             
        insert subFile;
    }

   public static testMethod void EPMS_HandOverDirectoriesTL() {
        PageReference pageref=Page.EPMS_HandOverDir_TL;
        
        
        Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'Morning Shift'];
        Team__c team =  [SELECT Id, Name FROM Team__c WHERE Name = 'Alpha Team'];
        Member__c betaTL = [SELECT Id, Name, Team_Id__c FROM Member__c WHERE Last_Name__c='PARK'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name = 'Handover_FILE_Test_1'];
        
        test.StartTest();
      
        Test.setCurrentPage(pageRef);
         
        pageRef.getParameters().put('ids',fileList[0].Id);
        
        EPMS_HandOverDirectoriesTL handover=new EPMS_HandOverDirectoriesTL();
        handover.selShift=shift.Id;
        handover.selTeam =betaTL.Team_Id__c;
        handover.selTL=betaTL.Id;
        handover.changeShift();
        handover.changeTeam();
        handover.saveChanges();
        
       
   
        test.StopTest();
   }
   
    public static testMethod void EPMS_HandOverDirectoriesTL_case_3() {
        PageReference pageref=Page.EPMS_HandOverDir_TL;
        
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name = 'Handover_FILE_Test_1'];
        Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'Morning Shift'];
        Team__c team =  [SELECT Id, Name FROM Team__c WHERE Name = 'Alpha Team'];
        Member__c alphaTL = [SELECT Id, Name, Team_Id__c FROM Member__c WHERE Last_Name__c='HAMILTON'];
        //pageRef.getParameters().put('ids',null);
        pageRef.getParameters().put('ids',fileList[0].Id);
        test.StartTest();
      
        Test.setCurrentPage(pageRef);
        EPMS_HandOverDirectoriesTL handoverqc=new EPMS_HandOverDirectoriesTL();
        handoverqc.selShift= shift.Id;
        handoverqc.selTeam = alphaTL.Team_Id__c;
        handoverqc.selTL = alphaTL.Id;
        handoverqc.changeShift();
        handoverqc.changeTeam();
        handoverqc.saveChanges(); 
        
        test.StopTest();
    }
    
    
    public static testMethod void EPMS_HandOverDirectoriesTL_case_4() {
        PageReference pageref=Page.EPMS_HandOverDir_TL;
        
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name = 'Handover_FILE_Test_1'];
        Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'Morning Shift'];
        Team__c team =  [SELECT Id, Name FROM Team__c WHERE Name = 'Alpha Team'];
        pageRef.getParameters().put('ids',fileList[0].Id);
        test.StartTest();
      
        Test.setCurrentPage(pageRef);
        EPMS_HandOverDirectoriesTL handoverTL4=new EPMS_HandOverDirectoriesTL();
        handoverTL4.selShift=shift.Id;
        handoverTL4.selTeam =team.Id;
        handoverTL4.selTL=null;
        handoverTL4.changeShift();
        handoverTL4.changeTeam();
        handoverTL4.saveChanges();
        
        test.StopTest();
    }
    
    public static testMethod void EPMS_HandOverDirectoriesTL_case_5() {
        PageReference pageref=Page.EPMS_HandOverDir_TL;
        
        // Test Coverage for Root Directory and Sub Directory status update [TRG : EPMS_updateFolderStatusBasedOnFile ]
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name = 'Sub_File_In_Sub_Folder_Test'];
        test.StartTest();
        List<Files__c> newUpdatedFiles = new List<Files__c>();
        if(fileList != null && fileList.size() > 0){
            for(Files__c newFile : fileList){
                newFile.Status__c = 'QC';
                newUpdatedFiles.add(newFile);
            }
        }
        
        if(newUpdatedFiles !=null && newUpdatedFiles.size() > 0){
            update newUpdatedFiles;
        }
        
        
        test.StopTest();
    }
    
    public static testMethod void EPMS_HandOverDirectoriesTL_case_6() {
        PageReference pageref=Page.EPMS_HandOverDir_TL;
        
        // Test Coverage for Root Directory and Sub Directory status update [TRG : EPMS_updateFolderStatusBasedOnFile ]
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name = 'Sub_File_In_Sub_Folder_Test'];
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
        List<Member__c> memberList = [SELECT Id, Name, Email__c FROM Member__c WHERE Location_id__c =: location.Id];
        List<Id> memberIds = new List<Id>();
        Set<Id> memids = new Set<Id>(); 
        Set<String> emailIdSet = new Set<String>();
        List<String> emailIdList = new List<String>();
        Set<Id> locationIds = new Set<Id> {location.Id};
        if(memberList != null && memberList.size() > 0){
            for(Member__c newMember : memberList){
                memberIds.add(newMember.Id);
                memids.add(newMember.Id);
                emailIdSet.add(newMember.Email__c);
            }
        }
        emailIdList.addAll(emailIdSet);
        test.StartTest();
        List<Files__c> newUpdatedFiles = new List<Files__c>();
        if(fileList != null && fileList.size() > 0){
            for(Files__c newFile : fileList){
                newFile.Status__c = 'QC';
                newUpdatedFiles.add(newFile);
            }
        }
        String Designation = 'Team Leader';
        // Coverage Code for Member_Query_Locator Class
        EPMS_MemberQueryLocator memberQueryLocator = new EPMS_MemberQueryLocator();
        memberQueryLocator.getMemberUpdateUser(memids);
        memberQueryLocator.getExistMemberList();
        memberQueryLocator.getTeamAssign(memberIds);
        memberQueryLocator.getMemberUpdateOldLoctiondetails(memberIds);
        memberQueryLocator.getUserlist(emailIdSet);
        memberQueryLocator.getUserProfile(Designation);
        memberQueryLocator.getLocationCountry(location.Id);
        //memberQueryLocator.getAutoincrementNumber()
        memberQueryLocator.getMemberOriginalLoc(emailIdList,locationIds);
        memberQueryLocator.getMemberOriginalLoc1(emailIdList,locationIds);
        memberQueryLocator.getattendance(memberList);
        test.StopTest();
    }
   
   }