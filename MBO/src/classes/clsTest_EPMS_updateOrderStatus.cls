/**********************************************************************************
*   Class               :       clsTest_EPMS_updateOrderStatus                    *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_updateOrderStatus             *
**********************************************************************************/
@isTest
    public class clsTest_EPMS_updateOrderStatus {
        
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
            file.Status__c ='Approved';             
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
}