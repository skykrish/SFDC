public class EPMS_Report {
    
    public List<AggregateResult> listAEr{get;set;} 
    public List<AggregateResult> listFJr{get;set;} 
    public List<AggregateResult> listKOr{get;set;} 
    public List<AggregateResult> listPTr{get;set;} 
    public List<AggregateResult> listUYr{get;set;} 
    public List<AggregateResult> listAEo{get;set;} 
    public List<AggregateResult> listFJo{get;set;} 
    public List<AggregateResult> listKOo{get;set;} 
    public List<AggregateResult> listPTo{get;set;} 
    public List<AggregateResult> listUYo{get;set;}
     


   
    
    
    
    
   public Map<id,List<AggregateResult>> MapCaregoryr{get;set;} 
   public Map<id,List<AggregateResult>> MapCaregoryo{get;set;} 
   public Map<id,Map<string,Integer>> finalrMap{get;set;} 
    
    
    public EPMS_Report(){
    listAEr = new List<AggregateResult>();
    listFJr = new List<AggregateResult>();
    listKOr = new List<AggregateResult>();
    listPTr = new List<AggregateResult>();
    listUYr = new List<AggregateResult>();
    listAEo = new List<AggregateResult>();
    listFJo = new List<AggregateResult>();
    listKOo = new List<AggregateResult>();
    listPTo = new List<AggregateResult>();
    listUYo = new List<AggregateResult>();


   
        MapCaregoryr = new Map<id,List<AggregateResult>>();
        MapCaregoryo = new Map<id,List<AggregateResult>>();
        finalrMap = new  Map<id,Map<string,Integer>>();

        
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='A' or File_Category_Code__r.name ='B' or File_Category_Code__r.name ='C' or File_Category_Code__r.name ='D' or File_Category_Code__r.name ='E') and Job_Type__c ='Regular' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
  group by member__c,File_Category_Code__r.name,member__r.name]){
                listAEr.add(result);
                
                
            }   
        
        for(AggregateResult ar:listAEr){
            if(MapCaregoryr.get((id)ar.get('mem')) != null){
                MapCaregoryr.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryr.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        system.debug('---------------------'+listAEr);
        
        
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='F' or File_Category_Code__r.name ='G' or File_Category_Code__r.name ='H' or File_Category_Code__r.name ='I' or File_Category_Code__r.name ='J')  and Job_Type__c ='Regular' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
  group by member__c,File_Category_Code__r.name,member__r.name]){
                listFJr.add(result);
                
            }
        for(AggregateResult ar:listFJr){
            if(MapCaregoryr.get((id)ar.get('mem')) != null){
                MapCaregoryr.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryr.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='K' or File_Category_Code__r.name ='L' or File_Category_Code__r.name ='M' or File_Category_Code__r.name ='N' or File_Category_Code__r.name ='O') and Job_Type__c ='Regular' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
 group by member__c,File_Category_Code__r.name,member__r.name]){
                listKOr.add(result);
                
            }
        for(AggregateResult ar:listKOr){
            if(MapCaregoryr.get((id)ar.get('mem')) != null){
                MapCaregoryr.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryr.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='P' or File_Category_Code__r.name ='Q' or File_Category_Code__r.name ='R' or File_Category_Code__r.name ='S' or File_Category_Code__r.name ='T')  and Job_Type__c ='Regular' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
 group by member__c,File_Category_Code__r.name,member__r.name]){
                listPTr.add(result);
                
            }
        for(AggregateResult ar:listPTr){
            if(MapCaregoryr.get((id)ar.get('mem')) != null){
                MapCaregoryr.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryr.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='U' or File_Category_Code__r.name ='V' or File_Category_Code__r.name ='W' or File_Category_Code__r.name ='X' or File_Category_Code__r.name ='Y') and  Job_Type__c ='Regular' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
 group by member__c,File_Category_Code__r.name,member__r.name]){
                listUYr.add(result);
                
            }
        for(AggregateResult ar:listUYr){
            if(MapCaregoryr.get((id)ar.get('mem')) != null){
                MapCaregoryr.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryr.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        system.debug('---------------------'+MapCaregoryr);

        Map<String,Integer> nmeMap = new Map<string,Integer>();
/*         
        for(File_Categories__c fc:[select name from File_categories__c]){
                for(String mapId:MapCaregoryr.keyset()){
             
                    for(AggregateResult ar:MapCaregoryr.get(mapId)){
                    System.debug(MapCaregoryr.get((string)ar.get('nme')));
                    System.debug(MapCaregoryr.get((string)ar.get('cnt')));
                    
                     }
                    }

                  
                }
               
         */
          

        




        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='A' or File_Category_Code__r.name ='B' or File_Category_Code__r.name ='C' or File_Category_Code__r.name ='D' or File_Category_Code__r.name ='E')  and Job_Type__c ='Optional' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
 group by member__c,File_Category_Code__r.name,member__r.name]){
                
                listAEo.add(result);
            }
        for(AggregateResult ar:listAEo){
            if(MapCaregoryo.get((id)ar.get('mem')) != null){
                MapCaregoryo.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryo.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='F' or File_Category_Code__r.name ='G' or File_Category_Code__r.name ='H' or File_Category_Code__r.name ='I' or File_Category_Code__r.name ='J') and Job_Type__c ='Optional' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
  group by member__c,File_Category_Code__r.name,member__r.name]){
                listFJo.add(result);
                
            }
        for(AggregateResult ar:listFJo){
            if(MapCaregoryo.get((id)ar.get('mem')) != null){
                MapCaregoryo.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryo.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='K' or File_Category_Code__r.name ='L' or File_Category_Code__r.name ='M' or File_Category_Code__r.name ='N' or File_Category_Code__r.name ='O') and Job_Type__c ='Optional' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
  group by member__c,File_Category_Code__r.name,member__r.name]){
                
                listKOo.add(result);
            }
        
        for(AggregateResult ar:listKOo){
            if(MapCaregoryo.get((id)ar.get('mem')) != null){
                MapCaregoryo.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryo.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        for (AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='P' or File_Category_Code__r.name ='Q' or File_Category_Code__r.name ='R' or File_Category_Code__r.name ='S' or File_Category_Code__r.name ='T')  and Job_Type__c ='Optional' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
 group by member__c,File_Category_Code__r.name,member__r.name]){
                
                listPTo.add(result);
            }
        for(AggregateResult ar:listPTo){
            if(MapCaregoryo.get((id)ar.get('mem')) != null){
                MapCaregoryo.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryo.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
     
        
        for(AggregateResult result : [
            SELECT member__c mem,member__r.name mname, COUNT(Id) cnt,File_Category_Code__r.name nme  FROM files__c where member__r.status__c ='Active' and (File_Category_Code__r.name ='U' or File_Category_Code__r.name ='V' or File_Category_Code__r.name ='W' or File_Category_Code__r.name ='X' or File_Category_Code__r.name ='Y')  and Job_Type__c ='Optional' and Status__c='Approved' and  CreatedDate = LAST_N_DAYS:75 
 group by member__c,File_Category_Code__r.name,member__r.name]){
                listUYo.add(result);
                
            }
        for(AggregateResult ar:listUYo){
            if(MapCaregoryo.get((id)ar.get('mem')) != null){
                MapCaregoryo.get((id)ar.get('mem')).add(ar);
            }else{
                MapCaregoryo.put((id)ar.get('mem'),new List<AggregateResult> {ar});
            }
        }
        
        system.debug('---------------------'+MapCaregoryo);
      
     
      

    }

 

  
}