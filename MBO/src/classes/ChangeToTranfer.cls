public class ChangeToTranfer {
    public string startOrder{get;set;}
    public string endOrder{get;set;}
    public List<Anken__c> ankrecords{get;set;}
    
    public ChangeToTranfer(){
       
    }
    
    public void saverec(){
        
           if(startOrder != null && endOrder != null){
               try{
                      list<Anken__c> Anklist=[select id,name from Anken__c where name>=:startOrder and name<=:endOrder];
				list<Anken__c> UpdatedAnklist=new list<Anken__c>();
            for(Anken__c al:Anklist){
  		 			al.Status__c='Transferring';
   					UpdatedAnklist.add(al);
					
				}

	update UpdatedAnklist;
                   
			 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Success'));
                   
               }catch(exception e){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+e));
               }
             
            
           }else{
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'enter starting and ending numbers'));
           }
        
        
    }
	Public void displyRecords(){
		
	   ankrecords=[select id,name,Status__c,Delivery_Time_Difference__c,Delivery_Process_Time_Long__c from Anken__c where name>=:startOrder and name<=:endOrder];

		
	}

}