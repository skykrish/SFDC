/**********************************************************************************
*   Class               :       EPMS_PerformanceRatingClass                       *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       To display performance rating                     *
**********************************************************************************/

public without sharing class EPMS_PerformanceRatingClass {

    public String inputValuemax { get; set; } 
    public String inputValuemin { get; set; } 
    public String inputValue { get; set; }  
    public List<Performance_Rating__c> PerformanceList {get;set;}
    public List<Performance_Rating__c> PerformanceCatList {get;set;}
    public List<File_Categories__c> Fielcats {get;set;}
    public transient List<Performance_Rating__c> CatListPerformance{get;set;}
    public List<Performance_Rating__c> MapListPefrc{get;set;}
    public list<Wrapperformance> WrapcategoryList{get;set;}
    public set<String> perName {get;set;}
    public set<Performance_Rating__c> FileCategoryset{get;set;}
    public boolean ErrorFlag {get;set;}
    PageReference pg = null;
    public Map<String,String[]> perNameToList {get;set;}
    public list<String>  catHold {get;set;}
    EPMS_PerformanceRating_Service serv = new EPMS_PerformanceRating_Service();
 
    public EPMS_PerformanceRatingClass(ApexPages.StandardController controller) {

        WrapcategoryList = new List<WrapPerformance>();
        CatListPerformance = serv.getCatList();
        Fielcats=serv.getAllCategory();      
        Set<Id> fileCatIds =  new Set<Id>();
        Map<Id, String> fileCatNameMap = new Map<Id, String>();
        if(Fielcats != null && Fielcats.size() > 0){
            for(File_Categories__c fileCat : Fielcats){
                fileCatNameMap.put(fileCat.Id, fileCat.Name);
                fileCatIds.add(fileCat.Id);
            }
        }
           
        perName= new set<String>(); 
        PerformanceList=serv.getAllPerformName();
        for(Performance_Rating__c perfHolder:PerformanceList){
            perName.add(perfHolder.Name);
        }
         perNameToList = new  Map<String,String[]>();
        for(Performance_Rating__c a: CatListPerformance)
        {         
            WrapcategoryList.add(new WrapPerformance(a));
        }     
        
        Map<String, List<String>> performanceGroupMap = new Map<String, List<String>>();
        List<Performance_Rating__c> newMapListPefrc =serv.getPerform(perName);
        
        if(newMapListPefrc != null && newMapListPefrc.size() > 0){
            if(perName.size() > 0){
                for(String value : perName){
                    List<String> newPerrateList = new List<String>();
                    List<String> newPerrateList2 = new List<String>();
                    Map<Id, String> existCategoryNameMap = new Map<Id, String> ();
                    Map<Id, Decimal> existCategoryMinMap = new Map<Id, Decimal> ();
                    Map<Id, Decimal> existCategoryMaxMap = new Map<Id, Decimal> ();
                    Set<Id> existCategorySet = new Set<Id>();
                    for(Performance_Rating__c ratingValue :newMapListPefrc){                       
                        if(value == ratingValue.Name){
                            newPerrateList.add(ratingValue.File_category__c);
                            existCategorySet.add(ratingValue.File_category__c);
                            if(ratingValue.File_Performance_Stf_Min__c != null && ratingValue.File_Performance_Stf_Max__c != null && ratingValue.File_category__r.Name !=null){
                                string strValue = ratingValue.File_category__r.Name+'='+ratingValue.File_Performance_Stf_Min__c+'##'+ratingValue.File_Performance_Stf_Max__c;
                                existCategoryNameMap.put(ratingValue.File_category__c, ratingValue.File_category__r.Name);
                                existCategoryMinMap.put(ratingValue.File_category__c, ratingValue.File_Performance_Stf_Min__c);
                                existCategoryMaxMap.put(ratingValue.File_category__c, ratingValue.File_Performance_Stf_Max__c);
                            }
                        }
                    }
                   
                    if(newPerrateList.size() > 0){                     
                        if(fileCatIds.size() > 0){                           
                            for (File_Categories__c fileCatId : Fielcats){
                                if(existCategorySet.contains(fileCatId.Id)){
                                    Decimal min = existCategoryMinMap.get(fileCatId.Id);
                                    Decimal max = existCategoryMaxMap.get(fileCatId.Id);
                                    Decimal scaledMin = min.setScale(3);
                                    Decimal scaledMax = max.setScale(3);
                                    String minVal = String.valueOf(min); 
                                    String maxVal = String.valueOf(max);
                                    string strValue = existCategoryNameMap.get(fileCatId.Id)+'='+minVal+'##'+maxVal;
                                    newPerrateList2.add(strValue);
                                } else {
                                    String catName = fileCatNameMap.get(fileCatId.Id);
                                   String strVal =catName +'='+''+'##'+'';
                                    newPerrateList2.add(strVal);
                                }
                            }
                        }
                        // Adding all the null value categories into performance group map
                         performanceGroupMap.put(value,newPerrateList2);  
                         perNameToList.put(value,newPerrateList2);
                    }
                }
            }
        }
       
        if(perName.Size() > 0 ){
            PerformanceCatList=serv.getPerform(perName);
        }
    }

    public class Wrapperformance {
        public Performance_Rating__c acc {get; set;}  
            public Wrapperformance( Performance_Rating__c a) {
            this.acc = a;  
            
        }
        public WrapPerformance()
        {
            
        }
    }
    
    public class Wrapfilecatcode {
        public File_Categories__c codeval {get; set;}       

        public Wrapfilecatcode(File_Categories__c b) {
            codeval = b;
        }
    }
    
    public void saveRating(){
         
        String Ratings=String.valueOf(Apexpages.currentpage().getparameters().get('rating'));
        String[] splitedRate =Ratings.split('@@');
        String[] GNames=null;         
        String Groupname=splitedRate[0];
        String[] splitedMinMaxRate= splitedRate[1].split('##');
        String [] Filecategory = new String[]{};
        String [] MincommaSplitted;
        String [] MaxcommaSplitted;
        Map<String,String> MinFilecategoryHolder = new Map<String,String>();
        Map<String,String> MaxFilecategoryHolder = new Map<String,String>();
        Set<String> tobeDeletedIds = new Set<String>();
        
        if(splitedMinMaxRate!=NULL && splitedMinMaxRate.size()>0){
            if(splitedMinMaxRate[0].contains(',')){
                String[] splitedMin=splitedMinMaxRate[0].split(',');
                for(String minsplit:splitedMin){
                    String[] splitedMinvalue=minsplit.split(',');
                    
                    for(String minvalues :splitedMinvalue){
                        MincommaSplitted=minvalues.split('--');
                      
                        if(MincommaSplitted.size() > 1){
                            String fcats=MincommaSplitted[0].replace('Min-','');
                            Filecategory.add(fcats);
                            MinFilecategoryHolder.put(MincommaSplitted[0].replace('Min-',''),MincommaSplitted[1]);
                        } else {
                            tobeDeletedIds.add(MincommaSplitted[0].replace('Min-',''));
                        }
                    }
                }
                             
            }else{
                MincommaSplitted=splitedMinMaxRate[0].split('--');
                if(MincommaSplitted.size() > 1){
                    String fcats=MincommaSplitted[0].replace('Min-','');
                    Filecategory.add(fcats);
                    String filscats=MincommaSplitted[0].replace('Min-','');
                    MinFilecategoryHolder.put(MincommaSplitted[0].replace('Min-',''),MincommaSplitted[1]);
                }
            }
            if(splitedMinMaxRate[1].contains(',')){
                 String[] splitedMax=splitedMinMaxRate[1].split(',');
                 for(String maxsplit:splitedMax){
                     String[] splitedMaxvalue=maxsplit.split(',');                     
                     for(String maxvalues :splitedMaxvalue){
                        MaxcommaSplitted=maxvalues.split('--');                       
                         if(MaxcommaSplitted.size() > 1){
                            MaxFilecategoryHolder.put(MaxcommaSplitted[0].replace('Max-',''),MaxcommaSplitted[1]);
                         }else {
                            system.debug('TEST THE UPDATED VALUES MMAAXX');
                            
                        }
                     }
                 }   
            }else{
                MaxcommaSplitted=splitedMinMaxRate[1].split('--');
                if(MaxcommaSplitted.size() > 1){
                    MaxFilecategoryHolder.put(MaxcommaSplitted[0].replace('Max-',''),MaxcommaSplitted[1]);
                }
            }
        }                
       
        List<Performance_Rating__c> deletePerformanceList = serv.getCategoryDeleteList(Groupname, tobeDeletedIds);
        List<Performance_Rating__c> ExistingperList = new List<Performance_Rating__c>();
        List<Performance_Rating__c> NewperList = new List<Performance_Rating__c>();
        List<Performance_Rating__c> AddNewperList = new List<Performance_Rating__c>();
        List<Performance_Rating__c> perList= serv.getAllPerformanceRatingList(Groupname);
        List<File_Categories__c> catList=serv.getAllCategory();
        map<String,Id> Catmap =new map<String,Id>();
        for(File_Categories__c loopCatList :catList){
            Catmap.put(loopCatList.Name,loopCatList.Id);    
        }
        Integer ing=0;   
        String allCats='';
        String allCatsFromPerformance='';
         
        for(Performance_Rating__c listper:perList){
            allCatsFromPerformance+=listper.File_category__r.Name+',';
            for(String fileCats :Filecategory){
                if(listper.File_category__r.Name==fileCats){
                    listper.Id=listper.Id;
                    listper.File_category__c=listper.File_category__c;
                    listper.File_Performance_Stf_Min__c=Decimal.valueOf(MinFilecategoryHolder.get(fileCats));
                    listper.File_Performance_Stf_Max__c=Decimal.valueOf(MaxFilecategoryHolder.get(fileCats));
                }
            }
        }
        set<id> filecatid = new set<id>();
        
        for(String comparePage:Filecategory){
            if(!allCatsFromPerformance.contains(comparePage)){
                Decimal min = Decimal.valueOf(MinFilecategoryHolder.get(comparePage));
                Decimal max = Decimal.valueOf(MaxFilecategoryHolder.get(comparePage));
                Performance_Rating__c NewperforManceList = new Performance_Rating__c();
                NewperforManceList.Name=Groupname;                
                NewperforManceList.File_category__c=Catmap.get(comparePage);                    
                NewperforManceList.File_Performance_Stf_Min__c=Decimal.valueOf(MinFilecategoryHolder.get(comparePage));
                NewperforManceList.File_Performance_Stf_Max__c=Decimal.valueOf(MaxFilecategoryHolder.get(comparePage));
                AddNewperList.add(NewperforManceList);
            }
        }  
        
        try{     
        if(perList.size() > 0){
            update perList;
        }
        if(AddNewperList.size() > 0){
            insert AddNewperList;
        }
        
        if(deletePerformanceList != null && deletePerformanceList.size() > 0){
            delete deletePerformanceList;
            // check the record count of performance name and its categories
            Integer performanceRecordCount = serv.checkPerformanceExists(Groupname);  
            if(performanceRecordCount == 0){
                // Creating new Record if all the category are deleted 
                Performance_Rating__c newperforManceRecord = new Performance_Rating__c();
                newperforManceRecord.Name=Groupname; 
                if(newperforManceRecord != null){
                    insert newperforManceRecord;
                }
            }
        }
        }
        catch (DMLException e){
        //Added check for FIELD_CUSTOM_VALIDATION_EXCEPTION to return user friendly error.
            String errorMsg = e.getMessage();
            if(errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                errorMsg = errorMsg.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION','You are not the owner of this record.Please Contact the owner of the record to delete');
            }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,errorMsg));
        }
        
    }
    
    
    // navigate to page performance rating
    public pageReference gotoAddPerformanceRating(){
        pg = new PageReference('/apex/EPMS_AddPerformanceRating');
        pg.setRedirect(true);
        return pg; 
    }
        
    public pagereference reset(){
            return null;
        }
    }