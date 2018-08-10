/****************************************************************************
*   Class               :       EPMS_PO_Assignment_Estimator_Controller     * 
*                               Controller Class                            *
*   Created Date        :       27/12/2017                                  *           
*   Description         :       Allow Estimator to assign PO and files for 
                                Estimation                                  *
/***************************************************************************/
 
public with sharing class EPMS_PO_Assignment_Estimator_Controller {

    public  List<string> reqids = new List<string>();
    public String locationId {get;set;} 
    public string selectedEstimator {get;set;}
    public SelectOption[] Estimators{get;set;}
    public List<Files__c> fileList {get; set;}
    public string productionLocation {get;set;}
    public string fileRecord {get; set;}
        
    public List<Profile> profilelist {get;set;}
    public string userProfileName {get;set;}
    public boolean errorFlag {get; set;}
    public boolean diableButton{get; set;}
    public list<Production_order__c> poList {get; set;}
    public Id batchProcessId {get;set;}    
    public String batchStatus {get;set;}
    public boolean isBulkUpdate {get;set;}
        
    // File Operator Assignment service
    EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();
    EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();    
    public EPMS_ProductionOrder_Query_Locator queryloc = new EPMS_ProductionOrder_Query_Locator();
    
    public string basepath {
         get{
             String basepath = ApexPages.currentPage().getParameters().get('source');
             return basepath;
         }
         set;
    }    
    
    public EPMS_PO_Assignment_Estimator_Controller(){
        profilelist  = shiftService.getProfiles();
        poList = new list<Production_order__c>();
        isBulkUpdate = false;
        errorFlag = true;
        if(profilelist.size() > 0){
            userProfileName = profilelist[0].Name;
        }
      
       string ids = ApexPages.currentPage().getParameters().get('ids');
       
        if(ids != null){
            for(String key:ids.split(',')){
                reqids.add(key);
            }
        }       

       system.debug('******* reqids : ' + reqids);
              
        //poList = queryloc.getPOCheck(reqids);
        poList = [Select Mbo_location__c ,id, Mbo_location__r.Name from Production_order__c where id IN:reqids];     
        system.debug('Production Order Info : ' + poList);
        if(reqids!= null){
            if(poList != null && poList.size() > 0){
                locationId = poList[0].Mbo_location__c;
                productionLocation = poList[0].Mbo_location__r.Name;
            }                
        }

    system.debug('*** locationId : ' + locationId);
    getEstimators();

    }

    public Pagereference Cancel(){
        return null;
    }
    
    public string getSelectedEstimator(){
        return this.selectedEstimator;              
    }
    
    public void setSelectedEstimator(string selectEstimator){
        this.selectedEstimator= selectEstimator;
    }    
    
     // Selection for list of Estimator associated with location    
    public Pagereference getEstimators(){

        Estimators = new List<SelectOption>();
        List<Member__c> estimatorDetails= new List<Member__c>();
        Estimators.add(new SelectOption('','--None--'));
       
       system.debug('userProfileName ********$ : ' + userProfileName);
        // Retrieve the shift list from service
        //if(userProfileName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName != 'Country Administrator'){
        system.debug('locationId ********$ : ' + locationId);   
           estimatorDetails= fileService.getAllEstimator(locationId);
        system.debug('estimatorDetails ********$ : ' + estimatorDetails);   
        //}
        String performanceRating = null;
        if(estimatorDetails != null){
            for(Member__c member: estimatorDetails){
                if (member.Performance_Rating__r.Name != null) {
                    performanceRating = ' - ' + member.Performance_Rating__r.Name;
                } else {
                    performanceRating = '';
                }
                Estimators.add(new SelectOption(member.Id,member.Name + performanceRating));

            }
        }
       
     system.debug('Estimators Estimators ********$ : ' + Estimators);   
            
        return null;
    }

    
    // Method to handle the team lead assignments 
    public Pagereference assignPO(){        
        boolean updatefile = false;
        //boolean updatePO = false;
        Set<String> poset = new Set<String>();    
        if(selectedEstimator == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ESTIMATOR_ASSGNMENT));
            return null;
        }    
   
       try {
            system.debug('********reqids');
            
            for (String poid: reqids){
                poset.add(poid);        
            }
            system.debug('poset ******** : ' + poset);
            
            if (poset.size() > 0)
                fileList = fileService.getFileList(poset);
                
             system.debug('fileList ******** : ' + fileList);   
            
            if(fileList != null && fileList.size() > 200){
                isBulkUpdate = true;        
                batchProcessId = Database.executeBatch(new EPMS_Batch_AssignEstimator(reqids, selectedEstimator),100);
                diableButton = true;
                batchStatus = 'Started';
                system.debug(' Batch Process Id : ' + batchProcessId);
            } else {
                for(Files__c fileObj : fileList){
                   fileObj.Estimator__c = selectedEstimator;
                   fileObj.Status__c =  Label.EPMS_Status_Estimator_Assigned;
                   updatefile = true;
                }
            
                system.debug('Updation files ******** : ' + fileList);
    
                if (updatefile) {
                    UPDATE fileList;
                }
            
            }
        } catch (Exception ex){
            ApexPages.Addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Problem in assigning Estimator. Please contact support team'));
            errorFlag = true;       
        }
        
        if(isBulkUpdate){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Estimator Assignment is in-progress. Order contains more files. The process will take some time to complete.')); 
        } else {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Production Order and File(s) assigned for Estimation successfully.'));
            diableButton = true;        
        }        
        
        return null;   
    }
    
    
    public PageReference checkJobStatus() {
    
        if(batchProcessId != null){
            AsyncApexJob result = [SELECT Id, NumberOfErrors, JobItemsProcessed, Status, TotalJobItems FROM AsyncApexJob WHERE Id =: batchProcessId];
            system.debug('$$ Result : ' + result);
            if(result != null){
                batchStatus = result.Status;
                if(batchStatus == 'Completed'){                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Production Order and File(s) assigned for Estimation successfully.'));
                }
            } else {
                batchStatus = ''; 
            }            
        }
        return null;
    }        
}