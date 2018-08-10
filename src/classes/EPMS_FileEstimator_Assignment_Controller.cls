/****************************************************************************
*   Class               :       EPMS_FileEstimator_Assignment_Controller    * 
*                               Controller Class                            *
*   Created Date        :       27/12/2017                                  *           
*   Description         :       Allow Estimator to assign files for 
                                Estimation                                  *
/***************************************************************************/
 

public with sharing class EPMS_FileEstimator_Assignment_Controller {

    public String locationId {get;set;} 
    public string selectedEstimator {get;set;}
    public SelectOption[] Estimators{get;set;}
    public List<Files__c> fileList {get; set;}
    public string productionLocation {get;set;}
    public string fileRecord {get; set;}
        
    public List<Profile> profilelist {get;set;}
    public string userProfileName {get;set;}
   // public String CurrentTeams{get; set;}
   // public String selectedTeamlead{get; set;}
   // public String ErrorflagEstimator {get; set;}
    public boolean errorFlag {get; set;}
    public boolean diableButton{get; set;}
    public Set<String> poNameSet {get; set;}
    public List<Production_Order__c> poList {get; set;}
    
    public string basepath {
         get{
             String basepath = ApexPages.currentPage().getParameters().get('source');
             return basepath;
         }
         set;
    }
    
    public String type {
         get{
             String type = ApexPages.currentPage().getParameters().get('type');

             return type;
         }
         private set;
    }
    public String[] ids {
        get {
            if (ids == null) {
                String s = ApexPages.currentPage().getParameters().get('ids');
                if (s != null) {
                    ids = s.split(',');
                } else {
                    ids = new String[] {};
                }
            }

            return ids;
        }
        private set;
    }
   
    // File Operator Assignment service
    EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();
    // Shift Assignment service
    EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();
    
    
    public EPMS_FileEstimator_Assignment_Controller(){
        profilelist  = shiftService.getProfiles();
        poNameSet = new Set<String>();
        errorFlag =false;
        if(profilelist.size() > 0){
            userProfileName = profilelist[0].Name;
        }
       system.debug('******* ids : ' + ids);
       
        fileList = fileService.getFileInformation(ids);
        
        if(fileList != null && fileList.size() > 0){        
            for(Files__c file : fileList){
                locationId = fileList[0].File_Location__c;
                productionLocation = fileList[0].File_Location__r.Name;
                poNameSet.add(fileList[0].Production_Order_Name__c);
            }
        }
        
        if (poNameSet != null) {
            poList = fileService.getPOList(poNameSet);
        }

        if(ids != null && ids.size() > 0){
               fileRecord = ids[0];
        }

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
    public Pagereference assignEstimator(){        
        boolean updatefile = false;
        boolean updatepo = true;
        List<Files__c> fList = new List<Files__c>();
            
        if(selectedEstimator == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ESTIMATOR_ASSGNMENT));
            errorFlag = true;
            return null;
        }    
   
        if(fileList != null && fileList.size() > 0){        
            for(Files__c fileObj : fileList){
               //fileObj.Member__c = selectedEstimator;   
               //fileObj.Member_Assigned__c = selectedEstimator;
               fileObj.Estimator__c = selectedEstimator;
               //fileObj.Files_To_open__c = 1;
               fileObj.Status__c =  Label.EPMS_Status_Estimator_Assigned;
               updatefile = true;
            }
        }
        system.debug('Updation files ******** : ' + fileList);
        
        try {
            if (updatefile) {
                UPDATE fileList;
            }
            
            if(!errorFlag){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'File(s) assigned for Estimation successfully.'));
                diableButton = true;
            } 
            
        
        } catch (Exception ex){
            ApexPages.Addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Problem in assigning Estimator. Please contact support team'));
            errorFlag = true;       
        } 
        
        return null;   
    }
}