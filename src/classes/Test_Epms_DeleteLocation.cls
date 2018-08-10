@isTest(SeeAllData=true)
public class Test_Epms_DeleteLocation {
    
    static testmethod void  Test_Epms_DeleteLocation(){
         Location__c location = new Location__c();
            location.Name ='Media BackOffice Test';
            location.Location_Country__c='india';
            location.Location_Status__c='Active';
            location.Group_Name__c='Media Backoffice Test';
            insert location;
        
      location.Location_Status__c='InActive';
        update location;
    
    }

}