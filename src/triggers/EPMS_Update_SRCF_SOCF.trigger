/****************************************************************************************************************************
   Trigger              : EPMS_Update_SRCF_SOCF                                                                             *   
   Created Date         : 16/01/2018                                                                                        *
   Description          : Update SRCF or SOCF based on Individual Performance category when file                            *    
                            status is QC or QCIP or Redo or On-Hold or Approved                                             *
   Version              : 2.0                                                                                               *
   Created By           : Krishna                                                                                           *
   Last Modified By     : Krishna                                                                                           *
   Last Modified        : 02/02/2018 : Included status QC or QCIP or Redo or On-Hold along with Approved                    *
   Last Modified        : 26/02/2018 : Updated SRCF or SOCF based on Individual Performance category is not null value      * 

*****************************************************************************************************************************/

trigger EPMS_Update_SRCF_SOCF on Files__c (before insert, before update) {   
    
    boolean indvPerfCatChange = false;
    List<Files__c> DBlist = new List<Files__c>();
    //List<Id> fileIdlist = new List<Id>();
    List<String> fileIdlist = new List<String>();
    List<string> fileIdlistInsert = new List<string>();
    File_Categories__c fCategory = null;
    
    Map<string,string> changedIndivPerfCategoryMap = new Map<string,string>();
    Map<string,string> changedJobTypeMap = new Map<string,string>();
    system.debug('*** trigger.new :: ' + trigger.new);

    if(Trigger.isInsert && Trigger.isBefore){       
        
        for (Files__c f:Trigger.new) {
            
            System.debug('******** f.status__c  = ' + f.status__c);
            // When Split file is happened, file will be inserted 
            if (f.status__c == 'QC' || f.status__c == 'QCIP' || f.status__c == 'On-Hold' || f.status__c == 'Handover') {
                if (f.Individual_Performance_Category__c != null) {
                    fCategory = [select Id, Standard_Regular_Cost_per_File__c, Standard_OptionalCost_Per_file__c from File_Categories__c where Id =: f.Individual_Performance_Category__c Limit 1];             
                }else {
                    f.SRCF__c = 0.00;
                    f.SOCF__c = 0.00;
                }
                System.debug('************ fCategory : '+fCategory);
                if (fCategory != null) {
                    if (f.Job_Type__c == 'Regular') {
                        f.SRCF__c = fCategory.Standard_Regular_Cost_per_File__c;
                        f.SOCF__c = 0.00;
                    } else if (f.Job_Type__c == 'Optional') {
                        f.SOCF__c = fCategory.Standard_OptionalCost_Per_file__c;
                        f.SRCF__c = 0.00;
                    }
    
                }                               
            }            
        }    
    }

    
    if(Trigger.isUpdate && Trigger.isBefore){
    
    //if(EPMS_CheckRecursive_SOCF_SRCF.runOnce()){
    
    System.debug('Trigger.isUpdate & Trigger.isBefore');    
        
        for (Files__c f:Trigger.new) {
            fileIdlist.add(f.id);
            changedIndivPerfCategoryMap.put(f.id, f.Individual_Performance_Category__c);
            changedJobTypeMap.put(f.id, f.Job_Type__c);
            //System.debug('The File Ids : '+fileIdlist);
            
        }
        
        Map<string,string> InitialIndivPerfCategoryMap = new Map<string,string>();
        Map<string,string> InitialJobTypeMap = new Map<string,string>();  
        System.debug('The File Ids : '+fileIdlist);
        if(fileIdlist != null && fileIdlist.size() > 0) { 
            DBlist = [select Id, Name, Individual_Performance_Category__c, Job_Type__c From Files__c where Id IN:fileIdlist];
        }
        System.debug('DBlist Values : '+DBlist);
      
        for(Files__c f1 : DBlist){
            InitialIndivPerfCategoryMap.put(f1.Id,f1.Individual_Performance_Category__c );
            InitialJobTypeMap.put(f1.Id,f1.Job_Type__c);
        }
        
        System.debug('************ InitialIndivPerfCategoryMap : '+InitialIndivPerfCategoryMap);
        System.debug('************ InitialJobTypeMap : '+InitialJobTypeMap);
        System.debug('************ changedIndivPerfCategoryMap : '+changedIndivPerfCategoryMap);
        System.debug('************ changedJobTypeMap : '+changedJobTypeMap);
      
        for(Files__c f2:trigger.new){
            if(InitialIndivPerfCategoryMap.containsKey(f2.Id)){
                if (f2.Individual_Performance_Category__c != InitialIndivPerfCategoryMap.get(f2.Id) || f2.Job_Type__c != InitialJobTypeMap.get(f2.Id)) {
                    if (f2.Individual_Performance_Category__c != null) {
                        fCategory = [select Id, Standard_Regular_Cost_per_File__c, Standard_OptionalCost_Per_file__c from File_Categories__c where Id =: f2.Individual_Performance_Category__c Limit 1];
                    } else {
                        f2.SRCF__c = 0.00;
                        f2.SOCF__c = 0.00;
                    }
                    System.debug('************ fCategory : '+fCategory);
                    if (fCategory != null) {
                        if (f2.Job_Type__c == 'Regular') {
                            f2.SRCF__c = fCategory.Standard_Regular_Cost_per_File__c;
                            f2.SOCF__c = 0.00;
                        } else if (f2.Job_Type__c == 'Optional') {
                            f2.SOCF__c = fCategory.Standard_OptionalCost_Per_file__c;
                            f2.SRCF__c = 0.00;
                        }
    
                    }
                    
                }
            }
        }
        
        System.debug('!!!! After Modified trigger.new::::'+trigger.new);
    //}    
    }
}