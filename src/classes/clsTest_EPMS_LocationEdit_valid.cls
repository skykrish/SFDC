/**********************************************************************************
*   Class               :       clsTest_EPMS_LocationEdit_valid                   *
*   Created Date        :       25/03/2016                                        *
*   Description         :       Test Class for EPMS_LocationEdit_valid            *
**********************************************************************************/

@isTest
private class clsTest_EPMS_LocationEdit_valid {
    static testMethod void testUpdate() {
        
        List<Location__c> locList = new List<Location__c>();
        List<Location__c> updateLocList = new List<Location__c>();
        for(Integer i=0;i<10;i++){
            Location__c loc = new Location__c();
            loc.Name='Test Location Name';
            loc.Location_Country__c='India';
            loc.Group_Name__c='Test Location Name';
            locList.add(loc);
        }
        
        insert locList;
        test.starttest();
        
        List<Location__c> existLocList =[select Id,Name,Location_Country__c from Location__c];
        for(Location__c loc:existLocList ){
            loc.Name='testName';
            updateLocList.add(loc);
        }
        try{
            update updateLocList;
        }catch(Exception e){
            System.debug('Working');
        }
        test.stoptest();
        
    }
       
    
}