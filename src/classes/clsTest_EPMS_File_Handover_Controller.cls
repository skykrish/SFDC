/**********************************************************************************
*   Class               :       clsTest_EPMS_File_Handover_Controller             *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_File_Handover_Controller      *
**********************************************************************************/

@isTest
    public class clsTest_EPMS_File_Handover_Controller {
        static testMethod void test_Files_Handover() {
            PageReference pageRef = Page.EPMS_File_Handover_Page;
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testphotoartist@mbo.in';
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
                file.Status__c ='Assigned';
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

            EPMS_File_Handover_Controller handoverObj = new EPMS_File_Handover_Controller();
            handoverObj.handoverInstruction = 'THIS IS TEST INSTRUCTION FOR FILE HANDOVER';
            handoverObj.handover_save();
            EPMS_File_Handover_Controller handoverObj2 = new EPMS_File_Handover_Controller();
            pageRef.getParameters().put('ids',null);
            handoverObj2.handoverInstruction = 'THIS IS TEST INSTRUCTION FOR FILE HANDOVER NUULL';
            handoverObj2.handover_save();
            // Finally
            handoverObj.Cancel();
            
            Test.stopTest();
        }
    }