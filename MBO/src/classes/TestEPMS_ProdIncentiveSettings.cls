/**********************************************************************************
*   Class               :       TestEPMS_ProdIncentiveSettings                    *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_ProdIncentiveSettings         *
**********************************************************************************/
@isTest(seeAllData=true)
public class TestEPMS_ProdIncentiveSettings {    
    
    static testMethod void testsaveChanges() {
        Profile  ps = [select id, name from Profile where name =:EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];

        User StdThis = new User(alias = 'TEU',
        email='TestThisUser@testorg1.com',
        emailencodingkey='UTF-8',
        lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = ps.id,
        timezonesidkey='America/Los_Angeles',
        username='TestThisUser@testorg.com');
        insert StdThis; 
        
        system.runas(StdThis){
        
            Location__c locObj1=[select Id,Name,Standard_Regular_Cost__c from Location__c where Name='MBOI Phase-1' limit 1];
            
            Member__c memObj=[select User_Id__c from Member__C WHERE Designation__c='Production Administrator' AND Location_Id__c=:locObj1.Id AND User_Id__c!=null limit 1];        
            
            List<File_Categories__c> categoryList = new List<File_Categories__c>();
            
            File_Categories__c  catObj12 = new File_Categories__c();
            catObj12.Name = 'TestCat';
            catObj12.Standard_Time_per_File_Min__c = 4;
            catObj12.Standard_Time_per_File_Max__c = 10;
            catObj12.Standard_Regular_Cost_per_File__c = 23;
            catObj12.Standard_OptionalCost_Per_file__c = 45; 
            insert catObj12;                
       
            List<File_Categories__c> prodIncentiveList = new List<File_Categories__c>();
            prodIncentiveList.add(catObj12);       
           
            Test.StartTest();       
            user user=[select id,Name from User where id=:memObj.User_Id__c limit 1];
        
            //system.runas(user){
                
                PageReference pageRef = Page.EPMS_ProdIncentiveSettings;
                Test.setCurrentPage(pageRef); 
                List<File_Categories__c> prodIncentiveList2 = [SELECT Id, Name FROM File_Categories__c]; //WHERE Name = 'TestCat'
                system.debug('--- $$ Test File Categories List : ' + prodIncentiveList2);
                ApexPages.StandardController sc = new ApexPages.StandardController(prodIncentiveList2[0]);
                EPMS_ProdIncentiveSettings   epmsPis = new EPMS_ProdIncentiveSettings(sc); 

                epmsPis.locationid=locObj1.Id;
                epmsPis.selLoc=locObj1.Id;
                epmsPis.locObj=locObj1;
                epmsPis.incentiveList = prodIncentiveList2;
                epmsPis.getCost();
                epmsPis.SetCost(Double.Valueof(locObj1.Standard_Regular_Cost__c));
                epmsPis.incentiveList[0].Standard_Time_per_File_Min__c = 5;
                epmsPis.incentiveList[0].Standard_Time_per_File_Max__c = 9;
                epmsPis.locObj.Standard_Regular_Cost__c=5987;
                epmsPis.reset();
                exception e;
                try{
                    string convertedcost='A1567';
                    epmsPis.incentiveList[0].Standard_Time_per_File_Min__c = 15;
                    epmsPis.incentiveList[0].Standard_Time_per_File_Max__c = 9;
                    epmsPis.locObj.Standard_Regular_Cost__c=Integer.valueof(convertedcost);
                }catch(Exception ex){
                    e = ex;
                }                   
           // }      
        }      
    }
    
    static testMethod void testsaveChanges1() {
        Profile  ps = [select id, name from Profile where name = :EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];

        User StdThis = new User(alias = 'TEU',
        email='TestThisUser@testorg1.com',
        emailencodingkey='UTF-8',
        lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = ps.id,
        timezonesidkey='America/Los_Angeles',
        username='TestThisUser@testorg.com');
        insert StdThis; 
        
        system.runas(StdThis){

            Location__c locObj1=[select Id,Name,Standard_Regular_Cost__c from Location__c where Name='MBOI Phase-1' limit 1];

            List<File_Categories__c> categoryList = new List<File_Categories__c>();

            File_Categories__c  catObj12 = new File_Categories__c();
            catObj12.Name = 'TestCat';
            catObj12.Standard_Time_per_File_Min__c = 4;
            catObj12.Standard_Time_per_File_Max__c = 10;
            catObj12.Standard_Regular_Cost_per_File__c = 23;
            catObj12.Standard_OptionalCost_Per_file__c = 45; 
            insert catObj12;

            List<File_Categories__c> prodIncentiveList = new List<File_Categories__c>();
            prodIncentiveList.add(catObj12);

            Test.StartTest();
            PageReference pageRef = Page.EPMS_ProdIncentiveSettings;
            Test.setCurrentPage(pageRef);  
            pageRef.getParameters().put('nid',locObj1.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(prodIncentiveList[0]);
            EPMS_ProdIncentiveSettings   epmsPis = new EPMS_ProdIncentiveSettings(sc);
            string cost='789898'; 

            epmsPis.locationid=locObj1.Id;
            epmsPis.locObj=locObj1;
            epmsPis.incentiveList = prodIncentiveList;
            epmsPis.selLoc=locObj1.Id;
            epmsPis.getCost();
            epmsPis.SetCost(Double.Valueof(cost));
            epmsPis.ConvertedCost = String.valueOf(Cost);
            epmsPis.incentiveList[0].Standard_Time_per_File_Min__c = 25;
            epmsPis.incentiveList[0].Standard_Time_per_File_Max__c = 50;
            epmsPis.locObj.Standard_Regular_Cost__c=Decimal.valueof(cost);
            epmsPis.reset();

            exception e;
            try{
                epmsPis.saveChanges();
            }catch(Exception ex){
                e = ex;
            }
            epmsPis.reset();   

        }      
    }
}