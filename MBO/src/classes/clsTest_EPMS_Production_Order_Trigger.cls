/**********************************************************************************
*   Class               :       clsTest_EPMS_Production_Order_Trigger             *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_Production_Order_Trigger      *
**********************************************************************************/
@isTest
private class clsTest_EPMS_Production_Order_Trigger {
    
    @testSetup static void setupTestData(){ 
    
        List<Production_Order__c> poList = new List<Production_Order__c>();
        List<File_Categories__c> fileCategoryList = new List<File_Categories__c>();
        List<Files__c> fileList = new List<Files__c>();
        
        Location__c location5 = new Location__c();
        location5.Name = 'INDIA PRIVATE LIMITED - Phase3';
        location5.Location_Country__c='India';
        location5.Location_Status__c ='active';
        location5.Group_Name__c='INDIA PVT LTD -Phase3';
        insert location5;
        
        for(Integer i=1;i<=5;i++){
            Production_Order__c po= new Production_Order__c();
            po.Name ='testPO'+i;
            po.Production_Order_Status__c ='New';
            po.Mbo_Location__c =location5.id;
            poList.add(po);
        }
        insert poList;
        
       
        String[] categoryNames = new String[] {'FA','FB','FC','FD','FE','FG'};

            
                for(Integer i=1;i<=5;i++){
            File_Categories__c fc= new File_Categories__c();
            fc.Name =categoryNames[i];
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            fileCategoryList.add(fc);
        }
        insert fileCategoryList;

        
        
        for(Integer i=1;i<=5;i++){
            Files__c file= new Files__c();
            file.Name ='testFile'+i;
            file.Production_Order__c =poList[0].id;
            file.File_Category_Code__c =fileCategoryList[0].id;
            file.Status__c ='WIP';
            file.Current_Extension__c ='.jpg';
            fileList.add(file);
        }
        insert fileList;


        // Test Data Type - 2
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phase2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2';
        insert location;

        Location__c location2 = new Location__c();
        location2.Name = 'INDIA  LIMITED - Phase1';
        location2.Location_Country__c='India';
        location2.Location_Status__c ='active';
        location2.Group_Name__c='INDIA LTD -Phase1';
        insert location2;          
            
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='rvikram07@gmail.com';
        insert usermail;
            
        Member__c member = new Member__c(); 
        member.Name='test';     
        member.Location_id__c=location.id;
        member.First_Name__c='testFirst';
        member.Last_Name__c='testlast';
        member.Email__c='testsalesforce123@gmail.com';
        member.Country__c='India';
        member.Designation__c='Team Leader';
        member.Status__c='Active';
        
        try{
            insert member;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        Member__c member2 = new Member__c(); 
        member2.Name='test2';     
        member2.Location_id__c=location.id;
        member2.First_Name__c='testFirst2';
        member2.Last_Name__c='testlast2';
        member2.Email__c='testsalesforce1232@gmail.com';
        member2.Country__c='India';
        member2.Designation__c='Quality Control';
        member2.Status__c='Active';
        
        try{
            insert member2;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        Member__c member3 = new Member__c(); 
        member3.Name='test3';     
        member3.Location_id__c=location2.id;
        member3.First_Name__c='testFirst3';
        member3.Last_Name__c='testlast3';
        member3.Email__c='testsalesforce1233@gmail.com';
        member3.Country__c='India';
        member3.Designation__c='Team Leader';
        member3.Status__c='Active';
        try{
            insert member3;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        Member__c member4 = new Member__c(); 
        member4.Name='test33';     
        member4.Location_id__c=location2.id;
        member4.First_Name__c='testFirst33';
        member4.Last_Name__c='testlast33';
        member4.Email__c='testsalesforce12333@gmail.com';
        member4.Country__c='India';
        member4.Designation__c='Quality Control';
        member4.Status__c='Active';
        try{
            insert member4;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        
        Production_Order__c poTLQC= new Production_Order__c();
        poTLQC.Name ='testPO1';
        poTLQC.Production_Order_Status__c ='New';
        poTLQC.TL_Incharge__c = member.Id;
        poTLQC.QC_Incharge__c = member2.Id;
        poTLQC.Mbo_Location__c =location.id;
        poTLQC.Production_Order_Status__c='New'; 
        try{
            insert poTLQC;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        Production_Order__c cOrder = new Production_Order__c();
        cOrder.Name ='00607852';
        cOrder.Production_Order_Status__c ='Completed';
        cOrder.Mbo_Location__c =location2.id;
        cOrder.TL_Incharge__c = member3.Id;
        cOrder.QC_Incharge__c = member4.Id;
        insert cOrder;
        
        List<Files__c> fileListApp = new List<Files__c>();
        for(Integer i=1;i<=5;i++){
            Files__c file= new Files__c();
            file.Name ='Sample_Image'+i;
            file.Production_Order__c =cOrder.id;
            file.File_Category_Code__c =fileCategoryList[0].id;
            file.Status__c ='Approved';
            file.Current_Extension__c ='.jpg';
            fileListApp.add(file);
        }
        insert fileListApp;


    
    
    
    }
    
    static testMethod void testProductionStatus() {
    
        Test.startTest();

        List<Production_Order__c> oldPOList = [select id,Name,Production_Order_Status__c,TL_Incharge__c,QC_Incharge__c from Production_Order__c];

        List<Production_Order__c> updatePOList = new List<Production_Order__c>();
        Integer i=1;
        for(Production_Order__c po:oldPOList){
            po.Production_Order_Status__c='Completed';          
            updatePOList.add(po);
        }
        try{
            update updatePOList;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        Test.stopTest();
    }
    
    
    static testMethod void testProductionTLQC() {
    
        List<Production_Order__c> poList = new List<Production_Order__c>();
        
        Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA  LIMITED - Phase1'];
        Member__c member3 =  [SELECT Id, Name FROM Member__c WHERE Name='Henry' OR Email__c='testsalesforce1233@gmail.com' LIMIT 1];
        Test.startTest();
        
        
        List<Production_Order__c> oldPOList =[select id,Name,Mbo_Location__c,TL_Incharge__c,QC_Incharge__c from Production_Order__c];

        List<Production_Order__c> updatePOList = new List<Production_Order__c>();
        
        for(Production_Order__c po:oldPOList){
            po.Production_Order_Status__c='Assigned'; 
            po.TL_Incharge__c = null;
            po.QC_Incharge__c = null;
            updatePOList.add(po);
        }
        try{
            update updatePOList;
        }catch(Exception e){
            System.debug('--Assigned validation --Error Block---'+e);
        }
        
        List<Production_Order__c> oldPOListForTl =[select id,Name,Mbo_Location__c,TL_Incharge__c,QC_Incharge__c from Production_Order__c];

        List<Production_Order__c> updatePOListforTl = new List<Production_Order__c>();
        
        for(Production_Order__c po: oldPOListForTl){
            po.TL_Incharge__c=member3.id;
            updatePOListforTl.add(po);           
        }
        try{
            update updatePOListforTl;
        }catch(Exception e){
            System.debug('---for update--TL--Incharge-Error Block---'+e);
        }
        
        List<Production_Order__c> oldPOListForQc =[select id,Name,Mbo_Location__c,TL_Incharge__c,QC_Incharge__c from Production_Order__c];

        List<Production_Order__c> updatePOListforQc = new List<Production_Order__c>();
        
        for(Production_Order__c po: oldPOListForQc){
            po.QC_Incharge__c=member3.id;
            updatePOListforQc.add(po);           
        }
        try{
            update updatePOListforQc;
        }catch(Exception e){
            System.debug('---for update--QC Incharge--Error Block---'+e);
        }
        
        
        List<Production_Order__c> oldPOListForLoc =[select id,Name,Mbo_Location__c,TL_Incharge__c,QC_Incharge__c from Production_Order__c];

        List<Production_Order__c> updatePOListforLoc = new List<Production_Order__c>();
        for(Production_Order__c po: oldPOListForLoc){
            po.Mbo_Location__c=location2.id;
            updatePOListforLoc.add(po);           
        }
        try{
            update updatePOListforLoc;
        }catch(Exception e){
            System.debug('---for update--Location -Error Block---'+e);
        }
       
        Test.stopTest();
    }
    
    static testMethod void testProductionTL() {
    
        List<Production_Order__c> poList = new List<Production_Order__c>();
    
        Test.startTest();
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phase12';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase12';
        insert location;

        Location__c location2 = new Location__c();
        location2.Name = 'INDIA PRIVATE LIMITED - Phase1';
        location2.Location_Country__c='India';
        location2.Location_Status__c ='active';
        location2.Group_Name__c='INDIA PVT LTD -Phase1';
        insert location2;           
            
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        Member__c member3 = new Member__c(); 
        member3.Name='Henry';     
        member3.Location_id__c=location.id;
        member3.First_Name__c='testFirst3';
        member3.Last_Name__c='testlast3';
        member3.Email__c='testsalesforce1233@gmail.com';
        member3.Country__c='India';
        member3.Designation__c='Team Leader';
        member3.Status__c='Active';
        try{
            insert member3;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
         List<File_Categories__c> fileCategoryList = new List<File_Categories__c>();
        String[] categoryNames = new String[] {'F1','F2','F3','F4','F5','F6'};

            
                for(Integer i=1;i<=5;i++){
            File_Categories__c fc= new File_Categories__c();
            fc.Name =categoryNames[i];
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            fileCategoryList.add(fc);
        }
        insert fileCategoryList;
        
        Member__c member4 = new Member__c(); 
        member4.Name='test33';     
        member4.Location_id__c=location.id;
        member4.First_Name__c='testFirst33';
        member4.Last_Name__c='testlast33';
        member4.Email__c='testsalesforce12333@gmail.com';
        member4.Country__c='India';
        member4.Designation__c='Quality Control';
        member4.Status__c='Active';
        try{
            insert member4;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        Member__c member5 = new Member__c(); 
        member5.Name='Justin';     
        member5.Location_id__c=location.id;
        member5.First_Name__c='Webber';
        member5.Last_Name__c='David';
        member5.Email__c='davidJustin@gmail.com';
        member5.Country__c='India';
        member5.Designation__c='Team Leader';
        member5.Status__c='Active';
        try{
            insert member5;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        Member__c member6 = new Member__c(); 
        member6.Name='Stephen';     
        member6.Location_id__c=location.id;
        member6.First_Name__c='Kipling';
        member6.Last_Name__c='Henry';
        member6.Email__c='henrykipling@gmail.com';
        member6.Country__c='India';
        member6.Designation__c='Quality Control';
        member6.Status__c='Active';
        try{
            insert member6;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        List<Production_Order__c> orderList = new List<Production_Order__c>();
        Production_Order__c poTL= new Production_Order__c();
        poTL.Name ='testPO2';
        poTL.Production_Order_Status__c ='New';
        poTL.Mbo_Location__c =location2.id;
        poTL.TL_Incharge__c = member3.Id;
        poTL.QC_Incharge__c = member4.Id;
        orderList.add(poTL);
        
        Production_Order__c poTL1= new Production_Order__c();
        poTL1.Name ='testPO4';
        poTL1.Production_Order_Status__c ='New';
        poTL1.Mbo_Location__c =location2.id;
        poTL1.TL_Incharge__c = member5.Id;
        poTL1.QC_Incharge__c = member6.Id;
        orderList.add(poTL1);
        
        //
        Production_Order__c cOrder = [SELECT Id, Name, Production_Order_Status__c FROM Production_Order__c WHERE Name = '00607852'];
        
        try{
            insert orderList;
            //insert fileListApp;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        
        try{
            cOrder.Production_Order_Status__c ='Uploaded';
            update cOrder;
        }catch(Exception e){
            System.debug('----Error Block---'+e);
        }
        

        Test.stopTest();
    }
    
    
}