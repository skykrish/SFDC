/********************************************************************************
*   Trigger             :       Filecategory_Old_file_updation             *
*   Created Date        :       26/03/2018                                 *
*   Description         :       Test Class for File Category updation      *
**********************************************************************************/

@isTest
    public class Test_EPMS_Filectgry_Old_file_updation {
        
        static testMethod void Test_EPMS_Filectgry_Old_file_updation1(){    
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x2';
            insert location;
            
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            
            insert fc;
                        
            Performance_Rating__c newPerGroup = new Performance_Rating__c();
            newPerGroup.File_Category__c = fc.Id;
            newPerGroup.Name = 'Group A';
            newPerGroup.File_Performance_Stf_Max__c = 150;
            newPerGroup.File_Performance_Stf_Max__c = 125;
            insert newPerGroup;
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO_22';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            insert po;
            
            List<Files__c> fileList = new List<Files__c>();
            
            //for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='testFile';
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                file.Status__c ='New';
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                
                //fileList.add(file);
            //}
            //insert fileList;

            insert file;
            update file;
 
        }
      }