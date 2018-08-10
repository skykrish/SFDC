/**********************************************************************************
*   Class               :       clsTest_EPMS_Location_Trigger                     *
*   Created Date        :       27/09/2016                                        *
*   Description         :       Test Class for EPMS_Location_Trigger              *
**********************************************************************************/

@isTest
private class clsTest_EPMS_Location_Trigger {
    static testMethod void testLocationPostive() {
        
        
        List<Location__c> locList = new List<Location__c>();
        List<Location__c> updateLocList = new List<Location__c>();
        List<Location__c> deleteLocList = new List<Location__c>();
        Set<String> groupNameSet = new Set<String>();
        
        
        Test.startTest();
        //For insert operation
        
        for(Integer i=1;i<5;i++){
            Location__c loc = new Location__c();
            loc.Name='Test Location'+i;
            loc.Location_Status__c='Active';
            loc.Location_Country__c='India';
            loc.Group_Name__c='TestgroupName'+i;
            locList.add(loc);
        }
        
        try{
            insert locList;
        }catch(Exception e){
            System.debug(e);
        }
        
       
        
        //for update operation
        List<Location__c> oldLocList = [select id,Name,Group_Name__c from Location__c];
        Integer i=1;
        for(Location__c oldLoc:oldLocList ){
            oldLoc.Group_Name__c='groupName'+i;         
            updateLocList.add(oldLoc);
            i++;            
        }
        try{
            update updateLocList;
        }catch(Exception e){
            System.debug(e);
        }
        
        
        
        
        Test.stopTest();
        
        
    }
    static testMethod void testLocationDelete() {
        
        Profile profile = [select id from Profile where Name = 'System Administrator'];
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@shinsei.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        System.runAs(user){
            List<Location__c> locList = new List<Location__c>();
            List<Location__c> updateLocList = new List<Location__c>();
            List<Location__c> deleteLocList = new List<Location__c>();
            Set<String> groupNameSet = new Set<String>();
            
            
            Test.startTest();
            //For insert operation
            
            for(Integer i=1;i<5;i++){
                Location__c loc = new Location__c();
                loc.Name='Test Location'+i;
                loc.Location_Status__c='Active';
                loc.Location_Country__c='India';
                loc.Group_Name__c='TestgroupName'+i;
                locList.add(loc);
            }
            
            try{
                insert locList;
            }catch(Exception e){
                System.debug(e);
            }
            
            //for delete operation
            List<Group> oldGroupList2 = [select id,Name from Group  ];
            List<Location__c> oldLocList1 = [select id,Name,Group_Name__c from Location__c];
            
            for(Location__c location: oldLocList1){
                groupNameSet.add(location.Group_Name__c);
            }
           
            List<Group> oldGroupList = [select id,Name from Group where Name IN:groupNameSet];
            
            try{    
                delete oldGroupList;
                delete oldLocList1;
            }catch(Exception e){
                System.debug(e);
            }
            
            
            Test.stopTest();
        }
        
        
        
    }
    
    static testMethod void testLocationError() {
        List<Location__c> locList = new List<Location__c>();
        List<Location__c> updateLocList = new List<Location__c>();
        
        Test.startTest();
        //Code coverage for error message

        Location__c locError = new Location__c();
        locError.Name='Test Location Name';
        locError.Location_Status__c='Active';
        locError.Location_Country__c='India';
        locError.Group_Name__c='Testgroup';
        insert locError;
        
        Location__c locError1 = new Location__c();
        locError1.Name='Test Location Name1';
        locError1.Location_Status__c='Active';
        locError1.Location_Country__c='India';
        locError1.Group_Name__c='Testgroup1';
        try{
            insert locError1;
        }catch(Exception e){
            System.debug(e);
        }
        
        
        Location__c locError2 = new Location__c();
        locError2.Name='Test Location Name';
        locError2.Location_Status__c='Active';
        locError2.Location_Country__c='India';
        locError2.Group_Name__c='Testgroup';
        try{
            insert locError2;
        }catch(Exception e){
            System.debug(e);
        }
               
        
        
        List<Location__c> oldLocList2 = [select id,Name,Group_Name__c from Location__c];
        for(Location__c oldLocation:oldLocList2 ){
            oldLocation.Group_Name__c='Testgroup1';         
            updateLocList.add(oldLocation);         
        }
        try{
            update updateLocList;
        }catch(Exception e){
            System.debug(e);
        }
        
        List<Location__c> oldLocList3 = [select id,Name,Group_Name__c from Location__c];
        try{    
            delete oldLocList3;
        }catch(Exception e){
            System.debug(e);
        }
        
        Test.stopTest();
    }
    static testMethod void testLocationInsertException() {
        List<Location__c> locList = new List<Location__c>();
        List<Location__c> updateLocList = new List<Location__c>();
        
        for(Integer i=1;i<5;i++){
            Location__c loc = new Location__c();
            loc.Name='testRecordtestRecordtestRecordtestRecordtestRecordtestRecordtestRecordtestRecordtestRecord';
            loc.Location_Status__c='Active';
            loc.Location_Country__c=null;
            loc.Group_Name__c='groupName test groupName test groupName test groupName test groupName test groupName test groupName test groupName test ';
            locList.add(loc);
        }
        Test.startTest();
        try{
            locList.clear();
            insert locList;
        }catch(Exception e){
            System.debug(e);
        }
        
        Test.stopTest();
    }
    
    static testMethod void testLocationUpdateException() {
        List<Location__c> locList = new List<Location__c>();
        List<Location__c> updateLocList = new List<Location__c>();
        
        Test.startTest();
        //code coverage for exception part
        for(Integer i=1;i<5;i++){
            Location__c loc = new Location__c();
            loc.Name='record'+i;
            loc.Location_Status__c='Active';
            loc.Location_Country__c='India';
            loc.Group_Name__c='group'+i;
            locList.add(loc);
        }

        try{

            insert locList;
        }catch(Exception e){
            System.debug(e);
        }
        

        List<Location__c> oldLocList4 = [select id,Name,Group_Name__c from Location__c];
        for(Location__c oldLoc1:oldLocList4 ){
            oldLoc1.Group_Name__c='Test groupNameTestgroupNameTest groupNameTest groupNameTest groupNameTest groupNameTest groupName';          
            updateLocList.add(oldLoc1);                        
        }
        try{
            update updateLocList;
        }catch(Exception e){
            System.debug(e);
        }
        Test.stopTest();
    }
}