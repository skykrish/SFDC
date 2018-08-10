/**********************************************************************************
*   Class               :       Test_EPMS_EnhancedViewFilesController                  *
*   Created Date        :       12/01/2018                                            *           
*   Description         :       Test class for EPMS_EnhancedViewFilesController      *
**********************************************************************************/
@istest
private class Test_EPMS_EnhancedViewFilesController {
    
    @testSetup static void setupTestData(){ 
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c ank=new Anken__c(KokyakuName__c=acc.Id,Status__c='Open',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                                  Nouki_Date__c=System.Today());
        insert ank;
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;        
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist123@mbo.in';
        insert usermail;        
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        Team__c team3 = new Team__c();
        team3.Name='Team C';
        team3.Location__c=location.id;             
        insert team3;
        system.debug('TEAM 3 ::' + team3);
        
        system.debug('Email ::' + usermail);
        Member__c qcmember2 =new Member__c();
        qcmember2.Name='BENZ';     
        qcmember2.Location_id__c=location.id;
        qcmember2.Last_Name__c='PARK';
        qcmember2.Email__c='testmbotestuser@mbo.in';
        qcmember2.Country__c='India';
        qcmember2.Designation__c='Quality Control';
        qcmember2.Status__c='Active';
        qcmember2.Team_Id__c = team3.Id;
        
        Member__c mem2 =new Member__c();
        mem2.Name='BENZ';     
        mem2.Location_id__c=location.id;
        mem2.Last_Name__c='PARK';
        mem2.Email__c='testmbotestuser@mbo.in';
        mem2.Country__c='India';
        mem2.Designation__c='Team Leader';
        mem2.Status__c='Active';
        mem2.Team_Id__c = team3.Id;
        
        Member__c mem21 =new Member__c();
        mem21.Name='BENZ';     
        mem21.Location_id__c=location.id;
        mem21.Last_Name__c='PARK';
        mem21.Email__c='testmbotestuser@mbo.in';
        mem21.Country__c='India';
        mem21.Designation__c=Label.EPMS_MEMBER_DESIG_OPERATOR_PS;
        mem21.Status__c='Active';
        mem21.Team_Id__c = team3.Id;
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='New';
        po.Anken_Order__c=ank.id;
        po.MBO_Location__c=location.Id;
        po.QC_InCharge__c = qcmember2.Id;
        insert po;
        system.debug('PRODUCTION ORDER 2 ::' + po);
        
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
        folderfile.QCIncharge__c=qcmember2.Id;
        folderfile.TLInCharge__c=mem2.id;
        folderfile.Files_To_open__c=1;
        folderfile.Delivery_Extension__c ='NewTest123';
        folderfile.FTP_Upload_Status__c=True;
        folderfile.File_HandOver_Instructions__c='Testdata768745746387';
        folderfile.FTP_Upload_Time__c=datetime.newInstance(2017, 5, 15, 12, 30, 0);
        folderfile.Instruction__c='TestNewEX34576865764';
        folderfile.QC_Comments__c='Test784545375';
        folderfile.Order_Instructions__c='TestOne233545468756';
        folderfile.File_Thumbnail_URL__c='/00790422/2017-0913-style502/2017.jpg';
        folderfile.Production_Order__c =po.id;
        folderfile.File_Category_Code__c =fc.id;
        folderfile.Status__c ='Assigned';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Directory';
        folderfile.InstructionNames__c = 'THIS IS SAMPLE FOLDER INSTRUCTION';
        folderfile.Member__c = mem21.Id;
        fileList.add(folderfile);
        insert fileList;        
    } 
    
    public static testMethod void Test_EnhancedViewFiles() {
        
        PageReference pageRef = Page.EPMS_EnhancedViewFiles;
        String FilesFilterId= '';
        
        Test.setCurrentPage(pageRef);
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        List<ListView> ListViewOfFilterId=[select id,Name from ListView where id=:FilesFilterId limit 1];
        
        Test.StartTest();
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(fileList);
        stdSetController.setSelected(fileList);
        stdSetController.setFilterId(FilesFilterId);
        pageRef.getParameters().put('id', String.valueOf(folderfile.Id));
        
        EPMS_EnhancedViewFilesController efc = new EPMS_EnhancedViewFilesController();
        EPMS_EnhancedViewFilesController.WrapperClass efc1 = new EPMS_EnhancedViewFilesController.WrapperClass(folderfile);
        try{
            efc.getAllFiles();        
            efc.resetFilter();
            efc.doNext();
            efc.refresh();
            efc.doFirst();
            efc.doLast();
            efc.doPrevious();
            efc.isSelectedAll();
            efc.refreshPageS();
            efc.sortmethod();
            efc.getFilesExistingViews();
            efc.getSelectedCount();
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error,'Could Not Run methods'));
        }
        test.stopTest();        
    }
    @isTest static void Test_EnhancedViewFiles1() {
        
        Profile profileId1 = [SELECT Id FROM Profile WHERE Name = 'Quality Control' LIMIT 1];
        User usr1 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'ViewTrack.live@asdf.com',
                             Username = 'TrackerEnhanced@view.com',
                             ProfileId = profileId1.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr1;
        
        Profile profileId2 = [SELECT Id FROM Profile WHERE Name = 'Country Administrator' LIMIT 1];
        User usr2 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.livon@asdf.com',
                             Username = 'jviewn@as2.com',
                             ProfileId = profileId2.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr2;
        
        
        Profile profileId4 = [SELECT Id FROM Profile WHERE Name = 'Shift Administrator' LIMIT 1];
        User usr4 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.on@asdf.com',
                             Username = 'jerTestn@as4.com',
                             ProfileId = profileId4.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr4;
        
        Profile profileId5 = [SELECT Id FROM Profile WHERE Name = 'Team Leader' LIMIT 1];
        User usr5 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.livteston@df.com',
                             Username = 'jertdon@asdf5.com',
                             ProfileId = profileId5.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr5;
        Profile profileId3 = [SELECT Id FROM Profile WHERE Name = 'Assignor' LIMIT 1];
        User usr3 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.te@asdf.com',
                             Username = 'jascggh@asdf3.com',
                             ProfileId = profileId3.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr3;
        
        
        
        Profile profileId8 = [SELECT Id FROM Profile WHERE Name =: Label.EPMS_MEMBER_DESIG_OPERATOR_PS LIMIT 1];
        User usr8 = new User(LastName = 'LIVEON',
                             FirstName='JAON',
                             Alias = 'jiv',
                             Email = 'jason.thjhon@asdf.com',
                             Username = 'jaghn@asdf7.com',
                             ProfileId = profileId8.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr8;
        
        Profile profileId9 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User usr9 = new User(LastName = 'LIhVEON',
                             FirstName='JAOhN',
                             Alias = 'jivhh',
                             Email = 'jn.listghon@asdf.com',
                             Username = 'ffghhn@asdf7.com',
                             ProfileId = profileId9.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US');
        insert usr9;
        
        string FilesFilterId;
        string sortingChoice;
        string sortType;
        
        Test.startTest();
        EPMS_EnhancedViewFilesController e7 = new EPMS_EnhancedViewFilesController();
        
        Test.stopTest();
        
        e7.getFilesExistingViews();
        e7.sortmethod();
        e7.sortType='DESC';
        e7.sortingChoice='Status';
        e7.sortType='ASC';
        e7.sortingChoice='Name';
        system.runas(usr2){
            e7.getFilesExistingViews();  
            e7.sortmethod();
        }
        system.runas(usr3){
            e7.getFilesExistingViews();  
            e7.sortmethod();
        }
        
        Account sortBy=new Account();
        sortBy.Name='Estimation Request';
        insert sortBy;
        
        e7.FilesFilterId=sortBy.Id;
        
        system.runas(usr4){
            e7.getFilesExistingViews();  
            e7.sortmethod();
        }
        system.runas(usr5){
            e7.getFilesExistingViews();
            e7.sortmethod();
        }
        
        system.runas(usr8){
            e7.getFilesExistingViews(); 
            e7.sortmethod();
        }
        system.runas(usr9){
            e7.getFilesExistingViews(); 
            e7.sortmethod();
        }
        
        system.runas(usr1){
            e7.getFilesExistingViews();     
            e7.sortmethod();
        }
        
        e7.refreshPageS();
        e7.getSelectedCount();
        e7.getHasPrevious();
        e7.getHasNext();
        e7.sortmethod();
        e7.getFilesExistingViews(); 
        e7.isSelectedAll();
    }
    @isTest static void Test_EnhancedViewFiles2() {
        
        Profile profileId1 = [SELECT Id FROM Profile WHERE Name = 'Quality Control' LIMIT 1];
        User usr10 = new User(LastName = 'LIVESTON',
                              FirstName='JASON',
                              Alias = 'jliv',
                              Email = 'jason.lhnkmjkms@asdf.com',
                              Username = 'Vihjew@epms.com',
                              ProfileId = profileId1.id,
                              TimeZoneSidKey = 'GMT',
                              LanguageLocaleKey = 'en_US',
                              EmailEncodingKey = 'UTF-8',
                              LocaleSidKey = 'en_US'
                             );
        insert usr10;
        
        Test.startTest();
        EPMS_EnhancedViewFilesController e8 = new EPMS_EnhancedViewFilesController();
        
        Test.stopTest();
        system.runas(usr10){
            e8.getFilesExistingViews();     
            e8.sortmethod();
        }
        
    }
    @isTest static void Test_EnhancedViewFiles3() {
        
        Profile profileId8 = [SELECT Id FROM Profile WHERE Name =: Label.EPMS_MEMBER_DESIG_OPERATOR_PS LIMIT 1];
        User usr11 = new User(LastName = 'LIVEON',
                              FirstName='JAON',
                              Alias = 'jiv',
                              Email = 'jason.lihjhjston@asdf.com',
                              Username = 'jan@asdhjf7.com',
                              ProfileId = profileId8.id,
                              TimeZoneSidKey = 'GMT',
                              LanguageLocaleKey = 'en_US',
                              EmailEncodingKey = 'UTF-8',
                              LocaleSidKey = 'en_US'
                             );
        insert usr11;
        
        Test.startTest();
        EPMS_EnhancedViewFilesController e9 = new EPMS_EnhancedViewFilesController();
        
        Test.stopTest();
        system.runas(usr11){
            e9.getFilesExistingViews();     
            e9.sortmethod();
        }
        
    }
    @isTest static void Test_EnhancedViewFiles4() {
        
        Profile profileId5 = [SELECT Id FROM Profile WHERE Name = 'Team Leader' LIMIT 1];
        User usr12 = new User(LastName = 'LIVESTON',
                              FirstName='JASON',
                              Alias = 'jliv',
                              Email = 'jason.lthjon@asdf.com',
                              Username = 'ja@ashjdf5.com',
                              ProfileId = profileId5.id,
                              TimeZoneSidKey = 'GMT',
                              LanguageLocaleKey = 'en_US',
                              EmailEncodingKey = 'UTF-8',
                              LocaleSidKey = 'en_US'
                             );
        insert usr12;
        
        Test.startTest();
        EPMS_EnhancedViewFilesController e10 = new EPMS_EnhancedViewFilesController();
        
        Test.stopTest();
        system.runas(usr12){
            e10.getFilesExistingViews();     
            e10.sortmethod();
        }
    }
    @isTest static void Test_EnhancedViewFiles5() { 
        
        EPMS_EnhancedViewFilesController e7 = new EPMS_EnhancedViewFilesController();
        e7.size=20;
        e7.sortByStatus='All Files';
        e7.sortingChoice='TAT';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='All Files';
        e7.sortingChoice='TAT';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='All Files';
        e7.sortingChoice='STATUS';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='All Files';
        e7.sortingChoice='STATUS';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='Approved Files';
        e7.sortingChoice='TAT';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='Approved Files';
        e7.sortingChoice='TAT';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='Approved Files';
        e7.sortingChoice='STATUS';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='Approved Files';
        e7.sortingChoice='STATUS';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='Assigned';
        e7.sortingChoice='TAT';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='Assigned';
        e7.sortingChoice='TAT';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='Assigned';
        e7.sortingChoice='STATUS';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='Assigned';
        e7.sortingChoice='STATUS';
        e7.sortType='DESC';
        e7.sortmethod();
        
    }
    
    @isTest static void Test_EnhancedViewFiles6() { 
        
        test.startTest();
        
        EPMS_EnhancedViewFilesController e8 = new EPMS_EnhancedViewFilesController();
        e8.sortByStatus='Awaiting Approval';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Awaiting Approval';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Awaiting Approval';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Awaiting Approval';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimation Request';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimation Request';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimation Request';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimation Request';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimator Assigned';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimator Assigned';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimator Assigned';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Estimator Assigned';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Handover';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Handover';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Handover';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Handover';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - QC';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - QC';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - QC';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - QC';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - SA';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - SA';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - SA';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - SA';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - TL';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - TL';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - TL';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='My Files - TL';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='New';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='New';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='New';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='New';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge Handover';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge Handover';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge Handover';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='QC Incharge Handover';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Redo';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Redo';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='Redo';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='Redo';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='TL Incharge';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='TL Incharge';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        test.stopTest();
    }
}