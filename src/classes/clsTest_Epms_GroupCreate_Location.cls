/**********************************************************************************
*   Class               :       clsTest_Epms_GroupCreate_Location                 *
*   Created Date        :       05/04/2016                                        *
*   Description         :       Test Class for Epms_GroupCreate_Location          *
**********************************************************************************/
@istest
Public class clsTest_Epms_GroupCreate_Location{
   public static testMethod void Epms_GroupCreate_Location() {
   
   List<Location__c> loclist=new List<Location__c>();
      List<Location__c> loclist1=new List<Location__c>();
       
    Location__c location = new Location__c();
    location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
    location.Location_Country__c='India';
    location.Location_Status__c ='Active';
    location.Group_Name__c='INDIA PVT LTD -Phase2x2';
    
    
    
    Location__c location1 = new Location__c();
    location1 .Name = 'INDIA PRIVATE LIMITED - Phaseex3';
    location1 .Location_Country__c='India';
    location1 .Location_Status__c ='Active';
    location1 .Group_Name__c='INDIA PRIVATE LIMITED - INDIA Phaseex3';
    
    loclist.add(location);
    loclist.add(location1);
    insert loclist;
    insert loclist1;
    Epms_GroupCreate_Location.createGroup(loclist);
    Epms_GroupCreate_Location.createGroup(loclist1);
    }
    }