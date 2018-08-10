/**********************************************************************************
*   Class               :       Test_EPMS_Depute_Member_New                       *
*   Created Date        :       01/09/2016                                        *           
*   Description         :       Test class for EPMS_Depute_Member_New             *
**********************************************************************************/
@isTest(seeAllData=true)
public class Test_EPMS_Depute_Member_New {
    
    static testMethod void epms_Depute_Member_case_1(){
        
        PageReference pageRef = Page.EPMS_Depute;
        Test.startTest();
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'MBOI Phase-1'];
        Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'MBOI Phase-2'];
        Member__c memberNoPerfGrp = [SELECT Id, Name,User_Id__c FROM Member__c WHERE Designation__c = 'Team Leader' AND Status__c = 'Active' 
                                        AND Current_Shift__c!=null  AND Location_id__c =: location.Id LIMIT 1]; 
        ApexPages.currentPage().getParameters().put('ids',memberNoPerfGrp.Id);

        EPMS_Depute_Member dep = new EPMS_Depute_Member();
        dep.selectedLocId= location.id;
        dep.getListOfLocations();
        dep.selectedLocId= location2.id;
        dep.getListOfLocations();     
        dep.save();
        
        User u=[select id from user where id=:memberNoPerfGrp.User_Id__c];
        
        system.runas(u){
        EPMS_Depute_Member depTL = new EPMS_Depute_Member();
        depTL.selectedLocId= location.id;
        depTL.getListOfLocations();
        depTL.selectedLocId= location2.id;
        depTL.getListOfLocations();     
        depTL.save();
        }

    }
    
}