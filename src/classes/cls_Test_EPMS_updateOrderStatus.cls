/**********************************************************************************
*   Class               :       cls_Test_EPMS_updateOrderStatus                   *
*   Created Date        :       03/08/2016                                        *
*   Description         :       Test Class for cls_Test_EPMS_updateOrderStatus    *
**********************************************************************************/
@isTest
public class cls_Test_EPMS_updateOrderStatus{

    @testSetup static void testSetupData(){
    
        // Create Location
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        // Create Location
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='N';
        insert testRecord;
        
        // Create Production Order 
        Production_Order__c po=new Production_Order__c();
        po.Name ='00520146';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        insert po;
          // Create Production Order 2
        Production_Order__c po1=new Production_Order__c();
        po1.Name ='00520147';
        po1.Production_Order_Status__c ='Assigned';
        po1.MBO_Location__c=location.Id;
        insert po1;
        
        // File Category
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='DC';
        fc.Standard_Time_per_File_Min__c =20;
        fc.Standard_Time_per_File_Max__c =50;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        insert fc;
        
        // Creation File 
        List<Files__c> fileList = new List<Files__c>();
        for(Integer i=1;i<=4;i++){
            Files__c file= new Files__c();
            file.Name ='testFile'+i;
            file.Production_Order__c =po.id;
            file.File_Category_Code__c =fc.id;
            if(i==1){
                file.Status__c ='Assigned';
            } else if(i==2){
                file.Status__c ='WIP';
            } else if(i==3){
                file.Status__c ='Redo Re-Assigned';
            } else if(i==4){
                file.Status__c ='New';
            }
            
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            file.File_Type__c = 'Image';
            file.Tracker_handover__c = false;
            //file.Member__c = member.Id;
            fileList.add(file);
        }
        
        insert fileList; 
        
    
     List<Files__c> fileListA = new List<Files__c>();
     for(Integer i=1;i<=5;i++){
            Files__c file1= new Files__c();
            file1.Name ='testFile'+i;
            file1.Production_Order__c =po1.id;
            file1.File_Category_Code__c =fc.id;
            
             file1.Status__c ='QCIP';
            
            
            file1.File_Location__c=location.id;
            file1.FTP_Upload_Status__c = true;
            file1.Current_Extension__c ='.jpg';
            file1.File_Type__c = 'Image';
           file1.Tracker_handover__c = false;
            //file.Member__c = member.Id;
            fileListA.add(file1);
        }
        
        insert fileListA; 
        
        
    }
    
    
    
    static testmethod void make_all_files_to_qcip(){
        
        List<Files__c> assignedFiles = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__r.Name =: '00520146' limit 2];
        List<Files__c> newUpdateList = new List<Files__c>();
        if(assignedFiles != null && assignedFiles.size() > 0){
            for(Files__c newFile : assignedFiles){
                newFile.Status__c = 'QCIP';
                newUpdateList.add(newFile);
            }
        }
        if(newUpdateList != null && newUpdateList.size() > 0){
            update newUpdateList;
        }
        
           List<Files__c> assignedFiles1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__r.Name =: '00520146'];
        List<Files__c> newUpdateList1 = new List<Files__c>();
        if(assignedFiles1 != null && assignedFiles1.size() > 0){
            for(Files__c newFile : assignedFiles1){
                newFile.Status__c = 'On-Hold';
                newUpdateList1.add(newFile);
            }
        }
        if(newUpdateList1 != null && newUpdateList1.size() > 0){
            update newUpdateList1;
        }
        
           
    }
   
    static testmethod void make_all_files_approved(){
        
        List<Files__c> qcipFiles = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__r.Name =: '00520147'];
        List<Files__c> newUpdateList2 = new List<Files__c>();
        if(qcipFiles != null && qcipFiles.size() > 0){
            for(Files__c newFile2 : qcipFiles){
                newFile2.Status__c = 'Approved';
                newUpdateList2.add(newFile2);
            }
        }
        if(newUpdateList2 != null && newUpdateList2.size() > 0){
            update newUpdateList2;
        }
    }
    
    static testmethod void make_all_files_uploaded(){
        
        List<Files__c> appFiles = [SELECT Id, Name, Status__c,FTP_Upload_Status__c,file_type__c FROM Files__c WHERE Production_Order__r.Name =: '00520147'];
        List<Files__c> newUpdateList3 = new List<Files__c>();
        if(appFiles != null && appFiles.size() > 0){
            for(Files__c newFile3 : appFiles){
                newFile3.FTP_Upload_Status__c = true;
                newFile3.Status__c = 'On-Hold';
                newFile3.File_Type__c ='Image';
                newUpdateList3.add(newFile3);
            }
        }
        if(newUpdateList3 != null && newUpdateList3.size() > 0){
            update newUpdateList3;
        }
    }
       
       
}