/**********************************************************************************
*   Class               :       clsTest_EPMS_LocationQueryLocator                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Query locator for location service class          *
**********************************************************************************/
@isTest
private class clsTest_EPMS_LocationQueryLocator{

    @testSetup static void setupTestData(){
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='E';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testmbomql@mbo.in';
            insert usermail;
            
            List<Member__c> memberList= new List<Member__c>();
            
            Member__c tlMemberTest =new Member__c();
            tlMemberTest.Name='Alexandar';     
            tlMemberTest.Location_id__c=location.id;
            tlMemberTest.Last_Name__c='Fleming';
            tlMemberTest.Email__c='alexfleming@gmail.com';
            tlMemberTest.Country__c='India';
            tlMemberTest.Designation__c='Team Leader';
            tlMemberTest.Status__c='Active';
            memberList.add(tlMemberTest);
            
            Member__c qcMemberTest =new Member__c();
            qcMemberTest.Name='Ramkumar S';     
            qcMemberTest.Location_id__c=location.id;
            qcMemberTest.Last_Name__c='Sundaresan';
            qcMemberTest.Email__c='ramkumars@gmail.com';
            qcMemberTest.Country__c='India';
            qcMemberTest.Designation__c='Quality Control';
            qcMemberTest.Status__c='Active';
            memberList.add(qcMemberTest);
            
            if(memberList.size() > 0){
                insert memberList;
            }
            
            Production_Order__c productionTest = new Production_Order__c();
            productionTest.Name ='OrderProduction_1';
            productionTest.Production_Order_Status__c ='New';
            productionTest.MBO_Location__c= location.Id;
            productionTest.TL_Incharge__c = tlMemberTest.Id;
            productionTest.QC_Incharge__c = qcMemberTest.Id;
            insert productionTest;
            
            File_Categories__c fcTest= new File_Categories__c();
            fcTest.Name ='testEB';
            fcTest.Standard_Time_per_File_Min__c =11;
            fcTest.Standard_Time_per_File_Max__c =20;
            fcTest.Standard_Regular_Cost_per_File__c =1000;
            fcTest.Standard_OptionalCost_Per_file__c =6;
            insert fcTest;
            
            // Files for Order_1
            Files__c parentfileTest= new Files__c();
            parentfileTest.Name ='Order_1_File_Directory';
            parentfileTest.Production_Order__c =productionTest.id;
            parentfileTest.File_Category_Code__c =fcTest.id;
            parentfileTest.Status__c ='QCIP';
            parentfileTest.File_Location__c=location.id;
            parentfileTest.Current_Extension__c ='.jpg';
            parentfileTest.File_Type__c = 'Directory';
            parentfileTest.TLInCharge__c = tlMemberTest.Id;
            parentfileTest.QCIncharge__c = qcMemberTest.Id;
            insert parentfileTest;
            
            
            
            List<Files__c> fileListTest = new List<Files__c>();
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='OrderTest_File_'+i;
                file.Production_Order__c =productionTest.id;
                file.File_Category_Code__c =fcTest.id;
                if(i==1){
                    file.Name ='Test.db';
                    file.Status__c ='QCIP';
                    file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = qcMemberTest.Id;
                } else if(i==2){
                    file.Status__c ='QC';
                    file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = qcMemberTest.Id;
                } else if(i==3){
                    file.Status__c ='WIP';
                    file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = qcMemberTest.Id;
                } else {
                    file.Status__c ='New';
                    file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = qcMemberTest.Id;
                }
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
               
                file.instruction__c = 'Test File Instructions ::';
                file.parent_Id__c = parentfileTest.Id;
                fileListTest.add(file);
            }
            insert fileListTest; 
            
        }
        
        static testmethod void locationTestCoverage(){
            Set<Id> locSetId = new Set<Id>();
            Set<String> locNameSet = new Set<String>();
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            string groupname = 'INDIA PRIVATE LIMITED - Phaseex2';
            Test.startTest();
            EPMS_LocationQueryLocator locationObj = new EPMS_LocationQueryLocator();
            if(location != null){
                locSetId.add(location.Id);
                locNameSet.add(groupname);
            }
            locationObj.getMemberlist(locSetId);
            locationObj.getTeamlist(locSetId);
            locationObj.getShiftlist(locSetId);
            locationObj.getShiftASS(locSetId);
            locationObj.getSettings(locSetId);
            locationObj.getFiles(locSetId);
            locationObj.getPO(locSetId);
            locationObj.getMistake(locSetId);
            locationObj.getGroupName(locNameSet);
            locationObj.getGroup(groupname);
            
            Test.stopTest();
            
        
        }
        
        
}