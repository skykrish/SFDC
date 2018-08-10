@isTest(seeAllData=true)
    public class Epms_Test_UpdateFileStatus  {
    
         static testMethod void test_CreatePO() {
              Location__c location = new Location__c();
            location.Name = 'INDIAN MBO';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIAN MBO';
            insert location;
            
 
            
                     
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO_22';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            insert po;
             
            List<Files__c> fileList = new List<Files__c>();
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;            
            insert fc; 
            
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='testFile'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                file.Status__c ='New';
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                fileList.add(file);
            }
            insert fileList; 
             
             
             
             
            po.Production_Order_Status__c ='Redo';
			update po;             
             
      }
    
    

}