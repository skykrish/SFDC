/**********************************************************************************
*   Class               :       clsTest_EPMS_File_On_Hold_Controller              *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_File_On-Hold_Controller       *
**********************************************************************************/

@isTest
    public class clsTest_EPMS_File_On_Hold_Controller {
        static testMethod void test_Files_OnHold() {
            PageReference pageRef = Page.EPMS_File_OnHold_Page;
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - PhaseexM2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - PhaseexM2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='W';
            insert testRecord;
            
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='mbosample2016@mbo.in';
            insert usermail;
            
            Member__c member =new Member__c();
            member.Name='MARK';     
            member.Location_id__c=location.id;
            member.Last_Name__c='PHILIPS';
            member.Email__c='testphotoartists@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            insert member; 

            
            Production_Order__c po=new Production_Order__c();
            po.Name ='O0002530';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            insert po;
            

            
            List<Files__c> fileList = new List<Files__c>();

            File_Categories__c fc= new File_Categories__c();
            fc.Name ='AB';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            
            insert fc;
            
             for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Handover_FILE_Test_'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                file.Status__c ='QCIP';
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                file.Member__c = member.Id;
                fileList.add(file);
            }
            insert fileList;
        
            
            String fileIds = '';
            for(Files__c newFile : fileList){
                if(fileIds == ''){
                    fileIds = newFile.Id; 
                } else {
                    fileIds += ',' + newFile.Id;
                }
            }
            
            Test.StartTest();  
    
            string basepath='file';
            string type = 'assign';
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put('ids',fileIds);
            pageRef.getParameters().put('source',basepath);

            EPMS_File_OnHold_Controller onholdObj = new EPMS_File_OnHold_Controller();
            onholdObj.qcCommentsForFiles = 'THIS IS TEST COMMENTS FOR FILE ON-HOLD';
            onholdObj.onhold_save();
            EPMS_File_OnHold_Controller onholdObj2 = new EPMS_File_OnHold_Controller();
            pageRef.getParameters().put('ids',null);
            onholdObj2.qcCommentsForFiles = 'THIS IS TEST COMMENTS FOR FILE ON-HOLD NUULL';
            onholdObj2.onhold_save();
            EPMS_File_OnHold_Controller onholdObj3 = new EPMS_File_OnHold_Controller();
            onholdObj3.qcCommentsForFiles = 'THIS IS TEST COMMENTS FOR FILE ON-HOLD';
            onholdObj3.onhold_save();
            // Finally
            onholdObj3.Cancel();
            
            Test.stopTest();
        }
    }