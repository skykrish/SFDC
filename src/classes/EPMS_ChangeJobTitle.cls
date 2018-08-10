/****************************************************************************
*   Class               :       EPMS_ChangeJobTitle                         *
*   Created Date        :       24/11/2017                                  *           
*   Description         :       Display Job Title                           *
*                               Files                                       *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/
global  class EPMS_ChangeJobTitle{
    public List<WrapperClass> jobTitleListWrapper {get;set;}    
    public String[] EPMSJobList = new string[]{};
    public  list<String> Afteraplit;
    public list<Files__c> getFilesCheckedJobs;
    public list<Production_Order__c> getPOCheckedJobs;
    public string basepath {get;set;}
    public set<String> avoiddup;
    public  list<string> voided;
    public string fileRecord {get; set;}
    public string Ids{get;set;}
    public  list<String> idList {get; set;}
    public boolean ErrorflagstatusCheck {get;set;}
    public boolean isPOList {get;set;}
    public boolean isPODetail {get;set;}
    
    public List<Anken_Background_Update__c> jobTitlesInCustomSettings=new List<Anken_Background_Update__c>();
    public Map<String,String> FinalMapForJobtitles=new Map<String,String>();
    public String Background;

    public EPMS_ChangeJobTitle() {
        jobTitleListWrapper = new List<WrapperClass>();
        getFilesCheckedJobs = new list<Files__c>();
        getPOCheckedJobs = new list<Production_Order__c>();
        idList = new list<String>();
        Ids = ApexPages.currentPage().getParameters().get('ids');
        basepath = ApexPages.currentPage().getParameters().get('type');
        ErrorflagstatusCheck=false;
        idList = convertList(Ids);
        system.debug('-----****** idList = ' + idList);
        system.debug('-----****** basepath = ' + basepath);
        
        boolean checked = false;
        isPOList = false;
        isPODetail = false;        
        Set<String> orderJobSet= new Set<String>();
        list<Job_Titles__c> JobTitles = new list<Job_Titles__c>();
        //Select all JobTitles to show in popup screen
        //JobTitles = [Select id,Name from Job_Titles__c ORDER BY Name];
        JobTitles = [Select id,Name from Job_Titles__c where Disabled__c = false ORDER BY Name ASC];
        List<SelectOption> options = new List<SelectOption>();        
        for(Job_Titles__c jobOption:JobTitles){    
            orderJobSet.add(jobOption.Name);
            options.add(new SelectOption(jobOption.Name,jobOption.Name));
        }

        if (basepath != null && basepath == 'polistpage') {
            // Select PO list to update JobTitle
            getPOCheckedJobs = [Select id, Name, Anken_Order__c, Job_List__c from Production_Order__c where id =:idList];
            system.debug('---**** getPOCheckedJobs = ' + getPOCheckedJobs);
            isPOList = true;
            EPMSJobList = getEPMSJobList();                
        } else if (basepath != null && basepath == 'podetailpage') {
            // Select PO detail page to update JobTitle
            getPOCheckedJobs = [Select id, Name, Anken_Order__c, Job_List__c from Production_Order__c where id =:idList];
            system.debug('---**** getPOCheckedJobs = ' + getPOCheckedJobs);
            isPODetail = true;
            EPMSJobList = getEPMSJobList();
        } else {
            // Select file list to update JobTitle
            getFilesCheckedJobs = [Select id, Name,File_Job_Titles__c from Files__c where id =:idList];
            system.debug('---**** getFilesCheckedJobs = ' + getFilesCheckedJobs);
            EPMSJobList = getEPMSJobList();
        }   
        
        
        system.debug('---**** EPMSJobList size = ' + EPMSJobList.size());
        for(String jb : orderJobSet){
            for (integer i=0;i<EPMSJobList.size();i++){
                if (EPMSJobList[i] == jb)
                    checked = true;
            }                 
        jobTitleListWrapper.add(new WrapperClass(jb,checked));
        checked = false;
        }    
    }
    
    /**
    * Convert String Ids separated by comma(,) to List   
    *
    **/  
    public List<String> convertList(String Ids) {
        return Ids.split(',');
    }

    /**
    * Get Job Title from Files__c and make it as String Array
    *
    **/ 
    public string[] getEPMSJobList() {
          
        EPMSJobList  = new String[0];       
        Afteraplit = new list<String>();
        
        if (isPOList) {
            if(getPOCheckedJobs.size()>0){
                for(integer f = 0 ; f<getPOCheckedJobs.size();f++ )
                {        
                    if(getPOCheckedJobs[f].Job_List__c!=null){
                    Afteraplit = getPOCheckedJobs[f].Job_List__c.split(',');
                    }        
                }     
            }
        
        } else if (isPODetail) {
            if(getPOCheckedJobs.size()>0){
                for(integer f = 0 ; f<getPOCheckedJobs.size();f++ )
                {        
                    if(getPOCheckedJobs[f].Job_List__c!=null){
                    Afteraplit = getPOCheckedJobs[f].Job_List__c.split(',');
                    }        
                }     
            }
        
        } else {        
            if(getFilesCheckedJobs.size()>0){
                for(integer f = 0 ; f<getFilesCheckedJobs.size();f++ )
                {        
                    if(getFilesCheckedJobs[f].File_Job_Titles__c!=null){
                    Afteraplit = getFilesCheckedJobs[f].File_Job_Titles__c.split(',');
                    }        
                }     
            }
        }
        
        
        avoiddup = new set<String>();
        avoiddup.addall(Afteraplit);
        voided = new list<string>();
        voided.addall(avoiddup);                   
        EPMSJobList.addall(voided);

        return EPMSJobList ;
    }
     
    /* Thid method is called when jobTitle pop up is submitted */
    public void updateObject() {
            
        //Get selected Job Titles from wrapper list
        
        jobTitlesInCustomSettings = [select id, Job_Titles__c from Anken_Background_Update__c];
        system.debug('------jobTitlesInCustomSettings------'+jobTitlesInCustomSettings);
        
        for(Anken_Background_Update__c job:jobTitlesInCustomSettings){
   
           FinalMapForJobtitles.put(job.Job_Titles__c,job.Job_Titles__c);
        }
        
        
        String selectedJobTitle = '';
        boolean first = true;
        for(WrapperClass wrap : jobTitleListWrapper){
            if(wrap.checkBool){
                if (first) {
                
                if(FinalMapForJobtitles.containsKey(wrap.jobTitle)){
                    system.debug('---entered into map-----');
                    String JobTitle=FinalMapForJobtitles.get(wrap.jobTitle);
                    if(JobTitle.equals(wrap.jobTitle)){
                      Background='変更なし'; 
                      }
                    }   
                
                
                    selectedJobTitle += wrap.jobTitle;
                    first = false;
                } else {
                
                if(FinalMapForJobtitles.containsKey(wrap.jobTitle)){
                    system.debug('---entered into map-----');
                    String JobTitle=FinalMapForJobtitles.get(wrap.jobTitle);
                    if(JobTitle.equals(wrap.jobTitle)){
                      Background='変更なし'; 
                      }
                    }   
                
                    selectedJobTitle += ',' + wrap.jobTitle;
                } 
            }
        }
        
        system.debug('****** selectedJobTitle : ' + selectedJobTitle);
        
        if (isPOList) {
            system.debug('PO List Page = ' + isPOList);         
            if (getPOCheckedJobs != null && getPOCheckedJobs.size() > 0) {
                updatePOAnkenFiles(selectedJobTitle);                           
            }
        } else if (isPODetail) {
            system.debug('PO Detail Page = ' + isPOList);
            if (getPOCheckedJobs != null && getPOCheckedJobs.size() > 0) {
                updatePOAnkenFiles(selectedJobTitle);                           
            }           
        } else {
            system.debug('File List Page');
            //Add Jobtitle to Files__c object
            for(Files__c echfile : getFilesCheckedJobs){
                echfile.File_Job_Titles__c = selectedJobTitle;
            }     
            //Update to Files__c object
            UPDATE getFilesCheckedJobs;
        }  
              
    }
    
    public void updatePOAnkenFiles(String selectedJobTitle) {
        List<String> ankenIdList = new List<String>();
        
        try{
            for(Production_Order__c echpo : getPOCheckedJobs){
                echpo.Job_List__c = selectedJobTitle;
                ankenIdList.add(echpo.Anken_Order__c);
            }
                 
            system.debug('****** getPOCheckedJobs : ' + getPOCheckedJobs);
            //Update Job Titles to PO object
            UPDATE getPOCheckedJobs;
            
            
      
            
            
            
            List<Anken__c> ankenList = [select id, Name, Job_Titles__c  from Anken__c where Id IN:ankenIdList];
            
            if (ankenList != null && ankenList.size() > 0) {
                for (Anken__c ank : ankenList) {
                
                if(Background=='変更なし'){
               ank.Background__c=Background;
               }
                
                    ank.Job_Titles__c = selectedJobTitle;
                }
                
                system.debug('****** ankenList : ' + ankenList);
                //Update Job Titles to Anken object
                UPDATE ankenList;
            }
        
            for(Production_Order__c echpo : getPOCheckedJobs){
                Database.executeBatch(new EPMS_BatchAssignJobTitle_Files(echpo.Name, selectedJobTitle),100);
            }
        } catch (Exception ex) {
            system.debug('Error in updating Job Title : ' + ex);
        }               
    }

    /**
    * Wrapper class used for linking between Visual force and apex class for selected values
    *
    **/    
    public class WrapperClass {
        public Boolean checkBool {get;set;}
        public String jobTitle {get;set;}
        public WrapperClass(String jobTitle, Boolean checkBool) {
            this.jobTitle = jobTitle;
            this.checkBool = checkBool;
        }        
    }
}