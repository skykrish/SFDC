/**********************************************************************************
*   Class               :       clsTestEPMS_NextTAT                               *
*   Created Date        :       05/04/2016                                        *
*   Description         :       Test Class for EPMS_NextTAT                       *
**********************************************************************************/

@isTest(SeeAllData=true)
Public class clsTestEPMS_NextTAT{
   public static testMethod void epms_NextTATMethod() {
   
       Profile profile = [select id from Profile where Name ='system administrator']; 
            User user = new User();
            user.FirstName ='test';
            user.LastName ='data';
            user.Alias ='cust'; 
            user.Username ='testuser@mbo.com';
            user.Email='test@gmail.com';
            user.ProfileId  = profile.id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.LocaleSidKey='en_US';
            user.EmailEncodingKey='UTF-8';
            user.LanguageLocaleKey='en_US';
            insert user;

    system.runAs(user){     
   
        Location__c location = new Location__c();
        location.Name ='Media BackOffice Test';
        location.Location_Country__c='india';
        location.Location_Status__c='Active';
        location.Group_Name__c='Media Backoffice Test';
        insert location;
            
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India1';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
    
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email1';
        usermail.Email__c='testMBO111@mbo.in';
        insert usermail;
    
            
        Member__c Member = new Member__c();        
        Member.Name='testname';
        Member.Location_id__c=location.id;            
        Member.Designation__c='Quality Control';
        member.Email__c='testQC@gmail.com';
        member.country__C='India';
        member.First_Name__c='TEST';
        member.Last_Name__c='QC TEST';
        insert Member;
   
        production_order__c po = new production_order__C();
        po.Name='test order1';
        po.Production_Order_Status__c ='New';
        po.Mbo_Location__c =Member.Location_id__c;
        po.Production_Order_TAT__c=System.now().addHours(1);
        insert po;
        
        production_order__c po1 = new production_order__C();
        po1.Name='test order2';
        po1.Production_Order_Status__c ='New';
        po1.Mbo_Location__c =Member.Location_id__c;
        po1.Production_Order_TAT__c=System.now().addDays(2);
        insert po1;
        
        production_order__c po2 = new production_order__C();
        po2.Name='test order3';
        po2.Production_Order_Status__c ='New';
        po2.Mbo_Location__c =Member.Location_id__c;
        po2.Production_Order_TAT__c=System.now().addDays(3);
        insert po2 ; 
        
        List<Production_Order__c> lstpron=new List<Production_Order__c>(); 
        lstpron.add(po1);
        lstpron.add(po2);      
        lstpron.add(po); 
             
        Map<string,List<Production_Order__c>> mapTimewiseOrders=new Map<string,List<Production_Order__c>>();
         
        mapTimewiseOrders.put(string.valueof(lstpron[0].Production_Order_TAT__c),lstpron);      
        mapTimewiseOrders.put(string.valueof(lstpron[1].Production_Order_TAT__c),lstpron); 
        mapTimewiseOrders.put(string.valueof(lstpron[2].Production_Order_TAT__c),lstpron); 
        
             
        Test.StartTest();  
        EPMS_NextTAT tat1 = new EPMS_NextTAT();
        tat1.mapTimewiseOrders=mapTimewiseOrders;   
        tat1.getCurrentOrder();
        Test.StopTest();  

       
  }  
   
}


static testMethod void epms_NextTATMethod2() {


    Location__c loc=[select Id,Name from Location__c where Name='MBOI Phase-1' limit 1];
    Member__c Member=[select id,Name,User_Id__c,Location_Id__c from Member__c where Location_Id__c=:loc.Id AND Designation__c='Production Administrator' limit 1];
    User PAuser=[select id,Name from User where Id=:Member.User_Id__c];

   
    system.runAs(PAuser){ 
   
        production_order__c po = new production_order__C();
        po.Name='test order';
        po.Production_Order_Status__c ='New';
        po.Mbo_Location__c =Member.Location_id__c;
        po.Production_Order_TAT__c=null;
        insert po;
        
        production_order__c po2 = new production_order__C();
        po2.Name='test order1';
        po2.Production_Order_Status__c ='New';
        po2.Mbo_Location__c =Member.Location_id__c;
        po2.Production_Order_TAT__c=System.now().addHours(1);
        insert po2;
        
        production_order__c po1 = new production_order__C();
        po1.Name='test order2';
        po1.Production_Order_Status__c ='New';
        po1.Mbo_Location__c =Member.Location_id__c;
        po1.Production_Order_TAT__c=System.now().addDays(2);
        insert po1;
        
        List<Production_Order__c> lstpron=new List<Production_Order__c>(); 
        lstpron.add(po1);
        lstpron.add(po2);      
        lstpron.add(po); 
             
        Map<string,List<Production_Order__c>> mapTimewiseOrders=new Map<string,List<Production_Order__c>>();
         
        mapTimewiseOrders.put(string.valueof(lstpron[0].Production_Order_TAT__c),lstpron);      
        mapTimewiseOrders.put(string.valueof(lstpron[1].Production_Order_TAT__c),lstpron); 
        mapTimewiseOrders.put(string.valueof(lstpron[2].Production_Order_TAT__c),lstpron); 
        
  
        Test.StartTest();  
        EPMS_NextTAT tat1 = new EPMS_NextTAT();
        tat1.mapTimewiseOrders=mapTimewiseOrders;   
        tat1.getCurrentOrder();
        Test.StopTest();
    } 

    }
    
    static testMethod void epms_NextTATMethod3() {


    Location__c loc=[select Id,Name from Location__c where Name='MBOI Phase-1' limit 1];
    Member__c Member=[select id,Name,User_Id__c,Location_Id__c from Member__c where Location_Id__c=:loc.Id AND Designation__c='Production Administrator' limit 1];
    User PAuser=[select id,Name from User where Id=:Member.User_Id__c];

   
    system.runAs(PAuser){ 
   
        Test.StartTest();  
        EPMS_NextTAT tat1 = new EPMS_NextTAT();
        tat1.mapTimewiseOrders=null;   
        tat1.getCurrentOrder();
        Test.StopTest();
    } 

    }
    

}