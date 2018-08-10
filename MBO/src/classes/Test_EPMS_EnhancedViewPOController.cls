/**********************************************************************************
*   Class               :       Test_EPMS_EnhancedViewPOController                    *
*   Created Date        :       12/01/2018                                           *           
*   Description         :       Test class for EPMS_EnhancedViewPOController        *
**********************************************************************************/
@istest
private class Test_EPMS_EnhancedViewPOController {
    
    @testSetup static void setupTestData(){ 
        
        integer size=20;
        
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
        
        Member__c qcmember21 =new Member__c();
        qcmember21.Name='Test784';     
        qcmember21.Location_id__c=location.id;
        qcmember21.Last_Name__c='New';
        qcmember21.Email__c='Tesr45678@mbo.in';
        qcmember21.Country__c='India';
        qcmember21.Designation__c='Team Leader';
        qcmember21.Status__c='Active';
        qcmember21.Team_Id__c = team3.Id;        
        
        Member__c qcmember2 =new Member__c();
        qcmember2.Name='BENZ';     
        qcmember2.Location_id__c=location.id;
        qcmember2.Last_Name__c='PARK';
        qcmember2.Email__c='testmbotestuser@mbo.in';
        qcmember2.Country__c='India';
        qcmember2.Designation__c='Quality Control';
        qcmember2.Status__c='Active';
        qcmember2.Team_Id__c = team3.Id;
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Parent_Locarion__c = 'Location Phase2';
        po.Production_Order_Status__c ='New';
        po.Anken_Order__c=ank.id;
        po.MBO_Location__c=location.Id;
        po.QC_InCharge__c = qcmember2.Id;
        PO.Location_For_Sharing__c = 'MBOI Phase-212345';
        po.FTP_Upload_Status__c = false;
        po.FTP_Upload_Time__c = datetime.newInstance(2017, 9, 15, 12, 30, 0);
        po.Production_Order_TAT__c = datetime.newInstance(2017, 9, 15, 13, 30, 0);
        po.TL_Incharge__c = qcmember21.id;
        po.Production_Order_Instruction__c ='New EX one New Field';
        insert po;   
    } 
    
    static testMethod void Test_EnhancedViewPO() {
        
        PageReference pageRef = Page.EPMS_EnhancedViewPOrder;        
        Test.setCurrentPage(pageRef);
        String FilesFilterId= '';
        integer size=20;
        
        Production_Order__c order2 = [SELECT Id, Name,Production_Order_Status__c FROM Production_Order__c WHERE Name ='O0002530'];
        List<Production_Order__c> polist = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002538'];
        List<ListView> ListViewOfFilterId=[select id,Name from ListView where id=:FilesFilterId limit 1];
        
        Test.StartTest();
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(polist);
        stdSetController.setSelected(polist);
        
        pageRef.getParameters().put('id', String.valueOf(order2.Id));
        
        EPMS_EnhancedViewPOController efc = new EPMS_EnhancedViewPOController();
        
        try{
            efc.getAllPOrders();        
            efc.resetFilter();
            efc.doNext();
            efc.refresh();
            efc.doFirst();
            efc.doLast();
            efc.doPrevious();
            efc.isSelectedAll();
            efc.refreshPageS();
            efc.getSelectedCount();
            efc.size=20;
            efc.sortingChoice='All Production Orders';
            efc.sortByStatus='TAT';
            efc.sortType='ASC';
            efc.sortmethod();
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error,'Could Not Run methods'));
        } 
        test.stopTest();
    }
    
    @isTest static void Test_EnhancedViewPO1() {
        
        Profile profileId1 = [SELECT Id FROM Profile WHERE Name = 'Quality Control' LIMIT 1];
        User usr1 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.epmjs784@asdf.com',
                             Username = 'Epmsvikew@asdf.com',
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
                             Email = 'jason.livejston@asdf.com',
                             Username = 'jasjkjon@asdf2.com',
                             ProfileId = profileId2.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr2;
        
        Profile profileId3 = [SELECT Id FROM Profile WHERE Name = 'Assignor' LIMIT 1];
        User usr3 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jasongon@asdf.com',
                             Username = 'jahjhjson@asdf3.com',
                             ProfileId = profileId3.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr3;
        
        Profile profileId4 = [SELECT Id FROM Profile WHERE Name = 'Shift Administrator' LIMIT 1];
        User usr4 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.livd@asdf.com',
                             Username = 'jasdfon@asdf4.com',
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
                             Email = 'jasfvdg@asdf.com',
                             Username = 'jasofgfn@asdf5.com',
                             ProfileId = profileId5.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr5;
        
        string POFilterId;
        string sortingChoice;
        string sortByStatus;
        string sortType;
        integer size=20;
        
        if(sortByStatus== 'All Production Orders' && sortType == 'ASC' && sortingChoice == 'TAT'){
            size=20;
        }
        
        Test.startTest();
        EPMS_EnhancedViewPOController e7 = new EPMS_EnhancedViewPOController();
        
        e7.getPOExistingViews();         
        e7.sortType='DESC';
        e7.sortingChoice='Status';
        
        system.runas(usr2){
            e7.getPOExistingViews();  
            
        }
        
        Account sortBy=new Account();
        sortBy.Name='CANCELLED';
        insert sortBy;
        e7.POFilterId=sortBy.Id;
        system.runas(usr3){
            e7.getPOExistingViews(); 		
        }
        
        system.runas(usr4){
            e7.getPOExistingViews();  
        }
        
        system.runas(usr5){
            e7.getPOExistingViews(); 		
        }        
        system.runas(usr1){
            e7.getPOExistingViews();     
            e7.MyDirectories();
            e7.refreshPageS();
            e7.getSelectedCount();
            e7.getHasPrevious();
            e7.getHasNext();
            e7.sortmethod();
        }
        test.stopTest();
    }
    
    @isTest static void Test_EnhancedViewPO2() {  
        Profile profileId1 = [SELECT Id FROM Profile WHERE Name = 'Quality Control' LIMIT 1];
        User usr1 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jviewn@asdf.com',
                             Username = 'TestbbView@df.com',
                             ProfileId = profileId1.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr1;
        
        Profile profileId5 = [SELECT Id FROM Profile WHERE Name = 'Team Leader' LIMIT 1];
        User usr5 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.livbvveston@asdf.com',
                             Username = 'jasbvbon@asdf5.com',
                             ProfileId = profileId5.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr5;
        
        Test.startTest();
        EPMS_EnhancedViewPOController e7 = new EPMS_EnhancedViewPOController();
        test.stopTest();
        system.runas(usr1){
            e7.getPOExistingViews();		
            e7.sortmethod();
        }
        system.runas(usr5){
            e7.getPOExistingViews();		
            e7.sortmethod();
        }
    }
    
    @isTest static void Test_EnhancedViewPO4() { 
        
        EPMS_EnhancedViewPOController e7 = new EPMS_EnhancedViewPOController();
        e7.size=20;
        e7.sortByStatus='All Production Orders';
        e7.sortingChoice='TAT';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='All Production Orders';
        e7.sortingChoice='TAT';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='All Production Orders';
        e7.sortingChoice='STATUS';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='All Production Orders';
        e7.sortingChoice='STATUS';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='ASSIGNED';
        e7.sortingChoice='TAT';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='ASSIGNED';
        e7.sortingChoice='TAT';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='ASSIGNED';
        e7.sortingChoice='STATUS';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='ASSIGNED';
        e7.sortingChoice='STATUS';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='Assignor View';
        e7.sortingChoice='TAT';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='Assignor View';
        e7.sortingChoice='TAT';
        e7.sortType='DESC';
        e7.sortmethod();
        
        e7.sortByStatus='Assignor View';
        e7.sortingChoice='STATUS';
        e7.sortType='ASC';
        e7.sortmethod();
        
        e7.sortByStatus='Assignor View';
        e7.sortingChoice='STATUS';
        e7.sortType='DESC';
        e7.sortmethod();
        
    }
    
    @isTest static void Test_EnhancedViewPO5() { 
        
        test.startTest();
        
        EPMS_EnhancedViewPOController e8 = new EPMS_EnhancedViewPOController();
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
        
        e8.sortByStatus='CANCELLED';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='CANCELLED';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='CANCELLED';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='CANCELLED';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='COMPLETED';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='COMPLETED';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='COMPLETED';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='COMPLETED';
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
        
        e8.sortByStatus='MY ORDERS';
        e8.sortingChoice='TAT';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='MY ORDERS';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='MY ORDERS';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='MY ORDERS';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        
        
        e8.sortByStatus='UPLOADED';
        e8.sortingChoice='TAT';
        e8.sortType='DESC';
        e8.sortmethod();
        
        e8.sortByStatus='UPLOADED';
        e8.sortingChoice='STATUS';
        e8.sortType='ASC';
        e8.sortmethod();
        
        e8.sortByStatus='UPLOADED';
        e8.sortingChoice='STATUS';
        e8.sortType='DESC';
        e8.sortmethod();
        
        test.stopTest();
        
    }
    
    @isTest static void Test_EnhancedViewPO6() { 
        
        test.startTest();
        
        EPMS_EnhancedViewPOController e9 = new EPMS_EnhancedViewPOController();
        
        e9.sortByStatus='WIP';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='WIP';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='WIP';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='WIP';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='UPLOADED Within 24 Hours';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='UPLOADED Within 24 Hours';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='UPLOADED Within 24 Hours';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='UPLOADED Within 24 Hours';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='送られていない案件';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='送られていない案件';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='送られていない案件';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='送られていない案件';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='All Production Orders_CA';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='All Production Orders_CA';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='All Production Orders_CA';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='All Production Orders_CA';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='NEW';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='NEW';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='NEW';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='NEW';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='PENDING';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='PENDING';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='PENDING';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='PENDING';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='QCIP';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='QCIP';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='QCIP';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='QCIP';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='Specific Customer PO';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='Specific Customer PO';
        e9.sortingChoice='TAT';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='Specific Customer PO';
        e9.sortingChoice='STATUS';
        e9.sortType='ASC';
        e9.sortmethod();
        
        e9.sortByStatus='Specific Customer PO';
        e9.sortingChoice='STATUS';
        e9.sortType='DESC';
        e9.sortmethod();
        
        e9.sortByStatus='UPLOADED';
        e9.sortingChoice='TAT';
        e9.sortType='ASC';
        e9.sortmethod();
        
        test.stopTest();
        
    }
    
}