/**********************************************************************************
*   Class               :       Test_EPMS_updateOrderStatus                    *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_updateOrderStatus             *
**********************************************************************************/
@isTest
public class Test_EPMS_updateOrderStatus {
    
    @testSetup static void setupTestData(){ 
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO_22';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        insert po; 
        
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='testFC';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;            
        insert fc;            
        
        Files__c file= new Files__c();
        file.Name ='testFile1';
        file.Production_Order__c =po.id;
        file.File_Category_Code__c =fc.id;               
        file.Status__c ='New';             
        file.File_Location__c=location.id;
        file.Current_Extension__c ='.jpg';
        file.File_Type__c = 'Image';
        insert file;
        
        Files__c file1= new Files__c();
        file1.Name ='testFile2';
        file1.Production_Order__c =po.id;
        file1.File_Category_Code__c =fc.id;               
        file1.Status__c ='New';             
        file1.File_Location__c=location.id;
        file1.Current_Extension__c ='.jpg';
        file1.File_Type__c = 'Image';
        insert file1;
      
        Production_Order__c po2=new Production_Order__c();
        po2.Name ='testPO_2';
        po2.Production_Order_Status__c ='New';
        po2.MBO_Location__c=location.Id;
        insert po2;
              
        Files__c file2= new Files__c();
        file2.Name ='testFile3';
        file2.Production_Order__c =po2.id;
        file2.File_Category_Code__c =fc.id;               
        file2.Status__c ='Estimation Request';             
        file2.File_Location__c=location.id;
        file2.Current_Extension__c ='.jpg';
        file2.File_Type__c = 'Image';
        insert file2;
       
        Production_Order__c po3=new Production_Order__c();
        po3.Name ='testPO_3';
        po3.Production_Order_Status__c ='New';
        po3.MBO_Location__c=location.Id;
        insert po3;
                
        Files__c file3 = new Files__c();
        file3.Name ='testFile4';
        file3.Production_Order__c =po3.id;
        file3.File_Category_Code__c =fc.id;               
        file3.Status__c ='Estimator Assigned';
        file3.File_Location__c=location.id;
        file3.Current_Extension__c ='.jpg';
        file3.File_Type__c = 'Image';
        insert file3;

        Production_Order__c po4=new Production_Order__c();
        po4.Name ='testPO_4';
        po4.Production_Order_Status__c ='New';
        po4.MBO_Location__c=location.Id;
        insert po4;
                
        Files__c file4 = new Files__c();
        file4.Name ='testFile5';
        file4.Production_Order__c =po4.id;
        file4.File_Category_Code__c =fc.id;               
        file4.Status__c ='Approved';
        file4.File_Location__c=location.id;
        file4.Current_Extension__c ='.jpg';
        file4.File_Type__c = 'Image';
        file4.FTP_Upload_Status__c = true;
        insert file4;
        
        /*Files__c file5 = new Files__c();
        file5.Name ='testFile6';
        file5.Production_Order__c =po.id;
        file5.File_Category_Code__c =fc.id;               
        file5.Status__c ='Assigned';
        file5.File_Location__c=location.id;
        file5.Current_Extension__c ='.jpg';
        file5.File_Type__c = 'Image';
        insert file5;*/
        
        Production_Order__c po5=new Production_Order__c();
        po5.Name ='testPO_5';
        po5.Production_Order_Status__c ='New';
        po5.MBO_Location__c=location.Id;
        insert po5; 
        
        Files__c file5 = new Files__c();
        file5.Name ='testFile6';
        file5.Production_Order__c =po5.id;
        file5.File_Category_Code__c =fc.id;               
        file5.Status__c ='New';             
        file5.File_Location__c=location.id;
        file5.Current_Extension__c ='.jpg';
        file5.File_Type__c = 'Image';
        insert file5;
        
        Files__c file6= new Files__c();
        file6.Name ='testFile7';
        file6.Production_Order__c =po5.id;
        file6.File_Category_Code__c =fc.id;               
        file6.Status__c ='Assigned';             
        file6.File_Location__c=location.id;
        file6.Current_Extension__c ='.jpg';
        file6.File_Type__c = 'Image';
        insert file6;
        
        Production_Order__c po6=new Production_Order__c();
        po6.Name ='testPO_6';
        po6.Production_Order_Status__c ='New';
        po6.MBO_Location__c=location.Id;
        insert po6; 
        
        Files__c file7 = new Files__c();
        file7.Name ='testFile8';
        file7.Production_Order__c =po6.id;
        file7.File_Category_Code__c =fc.id;               
        file7.Status__c ='On-Hold';             
        file7.File_Location__c=location.id;
        file7.Current_Extension__c ='.jpg';
        file7.File_Type__c = 'Image';
        insert file7;
        
        Files__c file8= new Files__c();
        file8.Name ='testFile9';
        file8.Production_Order__c =po6.id;
        file8.File_Category_Code__c =fc.id;               
        file8.Status__c ='Assigned';             
        file8.File_Location__c=location.id;
        file8.Current_Extension__c ='.jpg';
        file8.File_Type__c = 'Image';
        insert file8;

        Production_Order__c po7=new Production_Order__c();
        po7.Name ='testPO_7';
        po7.Production_Order_Status__c ='New';
        po7.MBO_Location__c=location.Id;
        insert po7; 
        
        Files__c file9 = new Files__c();
        file9.Name ='testFile10';
        file9.Production_Order__c =po7.id;
        file9.File_Category_Code__c =fc.id;               
        file9.Status__c ='Estimation Request';             
        file9.File_Location__c=location.id;
        file9.Current_Extension__c ='.jpg';
        file9.File_Type__c = 'Image';
        insert file9;
        
        Files__c file10= new Files__c();
        file10.Name ='testFile11';
        file10.Production_Order__c =po7.id;
        file10.File_Category_Code__c =fc.id;               
        file10.Status__c ='Awaiting Approval';             
        file10.File_Location__c=location.id;
        file10.Current_Extension__c ='.jpg';
        file10.File_Type__c = 'Image';
        insert file10;                        

        Production_Order__c po8=new Production_Order__c();
        po8.Name ='testPO_8';
        po8.Production_Order_Status__c ='New';
        po8.MBO_Location__c=location.Id;
        insert po8; 
        
        Files__c file11 = new Files__c();
        file11.Name ='testFile12';
        file11.Production_Order__c =po8.id;
        file11.File_Category_Code__c =fc.id;               
        file11.Status__c ='Estimator Assigned';             
        file11.File_Location__c=location.id;
        file11.Current_Extension__c ='.jpg';
        file11.File_Type__c = 'Image';
        insert file11;
        
        Files__c file12= new Files__c();
        file12.Name ='testFile13';
        file12.Production_Order__c =po8.id;
        file12.File_Category_Code__c =fc.id;               
        file12.Status__c ='Awaiting Approval';             
        file12.File_Location__c=location.id;
        file12.Current_Extension__c ='.jpg';
        file12.File_Type__c = 'Image';
        insert file12;                        

        Production_Order__c po9=new Production_Order__c();
        po9.Name ='testPO_9';
        po9.Production_Order_Status__c ='New';
        po9.MBO_Location__c=location.Id;
        insert po9; 
        
        Files__c file13 = new Files__c();
        file13.Name ='testFile14';
        file13.Production_Order__c =po9.id;
        file13.File_Category_Code__c =fc.id;               
        file13.Status__c ='Assigned';
        file13.File_Location__c=location.id;
        file13.Current_Extension__c ='.jpg';
        file13.File_Type__c = 'Image';
        insert file13;
 
    }   
    
    static testMethod void test_EPMS_updateOrderStatus() {        
        
        Files__c file = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile1'];
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile2'];
        
        Test.StartTest();
        if(file != null){
            file.Status__c='Assigned';
            update file;
        }
        
        if(file1 != null){
            file1.Status__c='Assigned';
            update file1;
        }
        
        Test.StopTest();
    }
    
    static testMethod void test_EPMS_updateOrderStatus_to_QC() { 
        
        Files__c file = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile1'];
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile2'];
        
        Test.StartTest();
        if(file != null){
            file.Status__c='QC';
            update file;
        }
        
        if(file1 != null){
            file1.Status__c='QC';
            update file1;
        }
        
        Test.StopTest();
    }
    
    static testMethod void test_EPMS_updateOrderStatus_to_QCIP() { 
        
        Files__c file = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile1'];
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile2'];
        
        Test.StartTest();
        if(file != null){
            file.Status__c='QCIP';
            update file;
        }
        
        if(file1 != null){
            file1.Status__c='QCIP';
            update file1;
        }
        
        Test.StopTest();
    }
    
    
    
    static testMethod void test_EPMS_updateOrderStatus_to_WIP() { 
        
        Files__c file = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile1'];
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile2'];
        
        Test.StartTest();
        if(file != null){
            file.Status__c='WIP';
            update file;
        }
        
        if(file1 != null){
            file1.Status__c='WIP';
            update file1;
        }
        
        Test.StopTest();
    }   
    
    
    
    static testMethod void test_EPMS_updateOrderStatus_to_redo() { 
        
        Files__c file = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile1'];
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile2'];
        
        Test.StartTest();
        if(file != null){
            file.Status__c='Redo';
            update file;
        }
        
        if(file1 != null){
            file1.Status__c='Redo';
            update file1;
        }
        
        Test.StopTest();
    }   
    
    
    static testMethod void test_EPMS_updateOrderStatus_to_approved() { 
        
        Files__c file = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile1'];
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile2'];
        
        Test.StartTest();
        if(file != null){
            file.Status__c='Approved';
            update file;
        }
        
        if(file1 != null){
            file1.Status__c='Approved';
            update file1;
        }
        
        Test.StopTest();
    }
    
    static testMethod void test_EPMS_updateOrderStatus_to_PO() { 
        
        List<Files__c> pplist = new List<Files__c>();

        Files__c qcipFiles = [SELECT Id, Name, Status__c, Production_Order__r.FTP_Upload_Status__c, Production_Order__r.FTP_Upload_Time__c, Production_Order__r.Production_Order_Status__c  FROM Files__c WHERE Name = 'testFile1'];
        Files__c qcipFiles2 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile2'];

        Test.StartTest();
        if(qcipFiles != null){
            qcipFiles.Production_Order__r.FTP_Upload_Status__c = true;
            qcipFiles.Production_Order__r.FTP_Upload_Time__c = system.now();
            qcipFiles.Production_Order__r.Production_Order_Status__c='Uploaded';
            pplist.add(qcipFiles); 
        }
        update pplist;
        
        Test.StopTest();
    } 

     static testMethod void test_EPMS_updateOrderStatus_to_EstimatorAssigned() { 
        
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile3'];
        
        Test.StartTest();
        if(file1 != null){
            file1.Status__c='Estimator Assigned';
            update file1;
        }
        
        Test.StopTest();
    }
    
     static testMethod void test_EPMS_updateOrderStatus_to_AwaitingApproval() { 
        
        Files__c file1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile4'];
        
        Test.StartTest();
        if(file1 != null){
            file1.Status__c='Awaiting Approval';
            update file1;
        }

        Test.StopTest();
    }    

     static testMethod void test_EPMS_updateOrderStatus_to_New() { 

        Files__c file2 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'testFile4'];
        Test.StartTest();
        if(file2 != null){
            file2.Status__c='New';
            update file2;
        }
        
        Test.StopTest();
    }
    
     static testMethod void test_EPMS_updateOrderStatus_Approved() { 

        Files__c file2 = [SELECT Id, Name, Status__c, FTP_Upload_Status__c FROM Files__c WHERE Name = 'testFile5'];
        Test.StartTest();
        if(file2 != null){
            file2.Status__c='Approved';
            file2.FTP_Upload_Status__c = true;
            update file2;
        }
        
        Test.StopTest();
    }
    
     static testMethod void test_EPMS_updateOrderStatus_Assigned() { 

        Production_Order__c po = [SELECT Id, Name from Production_Order__c where Name = 'testPO_5'];
        List<Files__c> filesList = [SELECT Id, Name, Status__c, Production_Order_Name__c FROM Files__c WHERE Production_Order_Name__c =: po.Name];
        Test.StartTest();
        
        for(Files__c file : filesList){
            file.Status__c = 'Assigned';
        }        
        
        update filesList;        
        
        Test.StopTest();
    }
    
     static testMethod void test_EPMS_updateOrderStatus_OnHold() { 

        Production_Order__c po = [SELECT Id, Name from Production_Order__c where Name = 'testPO_6'];
        List<Files__c> filesList = [SELECT Id, Name, Status__c, Production_Order_Name__c FROM Files__c WHERE Production_Order_Name__c =: po.Name];
        Test.StartTest();
        
        for(Files__c file : filesList){
            file.Status__c = 'On-Hold';
        }        
        
        update filesList;        
        
        Test.StopTest();
    }
    
     static testMethod void test_EPMS_updateOrderStatus_AwaitingApproval() { 

        Production_Order__c po = [SELECT Id, Name from Production_Order__c where Name = 'testPO_7'];
        List<Files__c> filesList = [SELECT Id, Name, Status__c, Production_Order_Name__c FROM Files__c WHERE Production_Order_Name__c =: po.Name];
        Test.StartTest();
        
        for(Files__c file : filesList){
            file.Status__c = 'Awaiting Approval';
        }        
        
        update filesList;        
        
        Test.StopTest();
    }
                          
     static testMethod void test_EPMS_updateOrderStatus_EstimatorAssigned_AwaitingApproval() { 

        Production_Order__c po = [SELECT Id, Name from Production_Order__c where Name = 'testPO_8'];
        List<Files__c> filesList = [SELECT Id, Name, Status__c, Production_Order_Name__c FROM Files__c WHERE Production_Order_Name__c =: po.Name];
        Test.StartTest();
        
        for(Files__c file : filesList){
            file.Status__c = 'Awaiting Approval';
        }        
        
        update filesList;        
        
        Test.StopTest();
    }                      

                          
     static testMethod void test_EPMS_updateOrderStatus_Assigned_1() { 

        Production_Order__c po = [SELECT Id, Name from Production_Order__c where Name = 'testPO_9'];
        List<Files__c> filesList = [SELECT Id, Name, Status__c, Production_Order_Name__c FROM Files__c WHERE Production_Order_Name__c =: po.Name];
        Test.StartTest();
        
        for(Files__c file : filesList){
            file.Status__c = 'Assigned';
        }        
        
        update filesList;        
        
        Test.StopTest();
    }  
}