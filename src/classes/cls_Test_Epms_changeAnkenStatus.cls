@isTest(SeeAllData=true)
public class cls_Test_Epms_changeAnkenStatus {
    
    
  static testmethod void testSetupData(){
      //create an Anken Order
      Anken__c ank = new Anken__c();
      ank.KokyakuName__c ='00110000012k294';
      //ank.KokyakuName__c ='001p0000005mgoR';
      ank.Status__c ='見積受付';
      insert ank;
     
      
      
    
        // Create Location
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        // Create Location
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='Agartha';
        testRecord.Country_Initial_Letter__c='T';
        insert testRecord;
        
        // Create Production Order 
        Production_Order__c po=new Production_Order__c();
        po.Name ='00520146';
        po.Production_Order_Status__c ='New';
      	po.Anken_Order__c = ank.id;
        po.MBO_Location__c=location.Id;
        insert po;
          production_order__c pored = [select id,Production_Order_Status__c from production_order__c where id=:po.id limit 1];
      		pored.Production_Order_Status__c ='Uploaded';
      update pored;
      
      
      
      
        List<production_order__c> POList = new  List<production_order__c>();
      
         List<production_order__c> uploadPO = [SELECT Id, Name, Production_Order_Status__c  FROM production_order__c  WHERE Name = '00520146'];
        for(production_order__c pos:uploadPO){
            po.Production_Order_Status__c = 'Uploaded';
            POList.add(pos);
                
        }
        update POList;
      
      

      
     
      
        
    }
    
     static testmethod void testSetupData1(){
      //create an Anken Order
      Anken__c ank = new Anken__c();
      ank.KokyakuName__c ='00110000012k294';
      //ank.KokyakuName__c ='001p0000005mgoR';
      ank.Status__c ='見積受付';
      insert ank;
     
      
      
    
        // Create Location
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        // Create Location
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='Agartha';
        testRecord.Country_Initial_Letter__c='T';
        insert testRecord;
        
        // Create Production Order 
        Production_Order__c po=new Production_Order__c();
        po.Name ='00520147';
        po.Production_Order_Status__c ='New';
      	po.Anken_Order__c = ank.id;
        po.MBO_Location__c=location.Id;
        insert po;
          production_order__c pored = [select id,Production_Order_Status__c from production_order__c where id=:po.id limit 1];
      		pored.Production_Order_Status__c ='WIP';
      update pored;
         po.MBO_Location__c=location.Id;
         update pored;
         
         
         
         
      
      
      
      
        List<production_order__c> POList = new  List<production_order__c>();
      
         List<production_order__c> uploadPO = [SELECT Id, Name, Production_Order_Status__c  FROM production_order__c  WHERE Name = '00520147'];
        for(production_order__c pos:uploadPO){
            po.Production_Order_Status__c = 'WIP';
            POList.add(pos);
                
        }
        update POList;
      
      

      
     
      
        
    }

  
  
   
    

}