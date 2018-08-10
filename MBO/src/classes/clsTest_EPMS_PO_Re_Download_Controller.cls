/**********************************************************************************
*   Class               :       clsTest_EPMS_PO_Re_Download_Controller            *
*   Created Date        :       29/06/2016                                        *
*   Description         :       Test Class for EPMS_PO_Re_Download_Controller     *
**********************************************************************************/

@isTest
    public class clsTest_EPMS_PO_Re_Download_Controller {
    
        @testSetup static void testSetupData(){
            
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
            member.Name='KEVIN';     
            member.Location_id__c=location.id;
            member.Last_Name__c='SCOTT';
            member.Email__c='kevinscott@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            insert member; 

            List<Production_Order__c> productionOrderList = new List<Production_Order__c>();
            Production_Order__c po=new Production_Order__c();
            po.Name ='O0412530';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            productionOrderList.add(po);
            
            Production_Order__c po2=new Production_Order__c();
            po2.Name ='O0412630';
            po2.Production_Order_Status__c ='WIP';
            po2.MBO_Location__c=location.Id;
            productionOrderList.add(po2);
            
            if(productionOrderList.size() > 0){
                insert productionOrderList;
            }
            
            List<Files__c> fileList = new List<Files__c>();
            List<Files__c> fileAssignList = new List<Files__c>();

            File_Categories__c fc= new File_Categories__c();
            fc.Name ='R';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            
            insert fc;
            
            // Files for Production Order 1
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Regular_File_'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                file.Status__c ='New';
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                fileList.add(file);
            }
            insert fileList;
            
            // Files for Production Order 2
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Regular_File_'+i;
                file.Production_Order__c =po2.id;
                file.File_Category_Code__c =fc.id;
                if(i == 1){
                    file.Status__c ='QC';
                } else if(i == 2){
                    file.Status__c ='Redo';
                } else {
                    file.Status__c ='New';
                }
                if(file.Status__c != 'New'){
                    file.Member__c = member.Id;
                }
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                fileAssignList.add(file);
            }
            
            insert fileAssignList;

        }
        
        static testMethod void test_EPMS_PO_Re_Upload() {
            PageReference pageRef = Page.EPMS_PO_Re_Download;
            
            
            Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0412530'];
            Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0412630'];
            List<Files__c> orderFiles1 = [SELECT Id, Name, Member__c, Status__c FROM Files__c WHERE Production_Order__c =: order1.Id];
            List<Files__c> orderFiles2 = [SELECT Id, Name, Member__c, Status__c FROM Files__c WHERE Production_Order__c =: order2.Id];
            String fileIds = '';
            String fileIds2 = '';
            for(Files__c newFile : orderFiles1){
                if(fileIds == ''){
                    fileIds = newFile.Id; 
                } else {
                    fileIds += ',' + newFile.Id;
                }
            }
            
            for(Files__c newFile2 : orderFiles2){
                if(fileIds2 == ''){
                    fileIds2 = newFile2.Id; 
                } else {
                    fileIds2 += ',' + newFile2.Id;
                }
            }
            
            Test.StartTest();  
    
            string basepath='file';
            string type = 'assign';
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put('ids',order2.Id);
            pageRef.getParameters().put('source',basepath);
            
            // Delete the Order Scenario (Negative Scenario)
            EPMS_PO_Re_Download_Controller onReUploadObj = new EPMS_PO_Re_Download_Controller();
            onReUploadObj.getAllDetails();
            onReUploadObj.deleteSelectedOrderFiles();
            // Delete the file inside the order Scenario (Negative Scenario)
            pageRef.getParameters().put('openInstrFiles',fileIds2);
            onReUploadObj.deleteSelectedFiles();
            // Update the Re-download files for other scenario
            pageRef.getParameters().put('openInstrFiles',fileIds);
            EPMS_PO_Re_Download_Controller onReUploadObj2 = new EPMS_PO_Re_Download_Controller();
            onReUploadObj2.getAllDetails();
            onReUploadObj2.deleteSelectedFiles();
            // Delete the Order Scenario (Negative Scenario)
            pageRef.getParameters().put('ids',order1.Id);
            EPMS_PO_Re_Download_Controller onReUploadObj3 = new EPMS_PO_Re_Download_Controller();
            onReUploadObj3.getAllDetails();
            onReUploadObj3.deleteSelectedOrderFiles();
            // Finally
            
            
            Test.stopTest();
        }
    }