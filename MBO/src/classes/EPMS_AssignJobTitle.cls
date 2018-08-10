/********************************************************************************** 
*   Class               :       EPMS_AssignJobTitle                               *
*   Created Date        :       28/11/2017                                        *           
*   Description         :       Controller to update PO Job Title                 *
**********************************************************************************/

public class EPMS_AssignJobTitle{

    public List<WrapperClass> jobTitleListWrapper {get;set;}
    public String[] SelectJobList = new string[]{};
    private  list<String> Afteraplit;
    public list<Anken__c> ankenList;
    public string basepath {get;set;}
    
    private set<String> avoiddup;
    private  list<string> voided;
    private string Id{get;set;}
    private  list<String> idList {get; set;}
    public boolean ErrorflagstatusCheck {get;set;}
    public List<String> SelectedJobId {public get;public set;}
    public string fileRecord {get; set;}
    private String defaultJob = 'Clipping';
    public List<Anken_Background_Update__c> jobTitlesInCustomSettings=new List<Anken_Background_Update__c>();
    public Map<String,String> FinalMapForJobtitles=new Map<String,String>();
    public String Background;
 
    public EPMS_AssignJobTitle() {

        jobTitleListWrapper = new List<WrapperClass>();
        ankenList = new list<Anken__c>();
        idList = new list<String>();
        Id = ApexPages.currentPage().getParameters().get('id');
        basepath = ApexPages.currentPage().getParameters().get('type');
        system.debug('---------------- Anken Id ----------------'+Id);
        ErrorflagstatusCheck=false;
            //idList = convertList(Ids);
            //system.debug('-----****** idList = ' + idList);
        // Select file list to update JobTitle
        ankenList = [select id, Name, Job_Titles__c,Background__c  from Anken__c where Id =:Id];
        system.debug('---------------- ankenList ----------------'+ankenList);
        boolean checked = false;        
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
        
        SelectJobList = getSelectJobList(orderJobSet);
        system.debug('---**** SelectJobList = ' + SelectJobList);
        for(String jb : orderJobSet){
            for (integer i=0;i<SelectJobList.size();i++){
                if (SelectJobList[i] == jb)
                    checked = true;
            }                 
        jobTitleListWrapper.add(new WrapperClass(jb,checked));
        checked = false;
        }
            
    }
  
    /**
    * Get Job Title from Files__c and make it as String Array
    *
    **/ 
    public string[] getSelectJobList(Set<String> orderJobSet) {
          
        SelectJobList  = new String[0];       
        Afteraplit = new list<String>();
        if(ankenList.size()>0){
            for(integer i = 0 ; i<ankenList.size();i++ )
            {        
                if(ankenList[i].Job_Titles__c!=null){
                    Afteraplit = ankenList[i].Job_Titles__c.split(',');
                } else {
                    Afteraplit.add(this.defaultJob);
                }        
            }     
        }
        avoiddup = new set<String>();
        avoiddup.addall(Afteraplit);
        voided = new list<string>();
        voided.addall(avoiddup);                   
        SelectJobList.addall(voided);

        return SelectJobList ;
    }  
  
    /**
    * Save selected JobTitle to PO
    *
    **/ 
    public PageReference saveObject(){
        system.debug('xxxxxxxxxxxxxxxx Calling saveObject ***********************');
        
        //Update PO list
        //wrapper list
        String selectedJobTitle = '';
        boolean first = true;
        String newStatus = Label.EPMS_FileStatus_New;
        String pendingStatus = Label.EPMS_FileStatus_Pending;
        String estimationRequestStatus = Label.EPMS_FileStatus_Estimation_Request;
        String awaitingApprovalStatus = Label.EPMS_Status_Awaiting_Approval;
        
        List<Production_Order__c> poList = new List<Production_Order__c>();
        
        
         jobTitlesInCustomSettings = [select id, Job_Titles__c from Anken_Background_Update__c];
        system.debug('------jobTitlesInCustomSettings------'+jobTitlesInCustomSettings);
        
        for(Anken_Background_Update__c job:jobTitlesInCustomSettings){
   
           FinalMapForJobtitles.put(job.Job_Titles__c,job.Job_Titles__c);
        }
        
        system.debug('------FinalMapForJobtitles-----'+FinalMapForJobtitles);
        
        for(WrapperClass wrap : jobTitleListWrapper){
            if(wrap.isSelected){
                if(first){ 
                
                system.debug('---map----'+FinalMapForJobtitles.containsKey(wrap.jobTitle));
                
                    if(FinalMapForJobtitles.containsKey(wrap.jobTitle)){
                    system.debug('---entered into map-----');
                    String JobTitle=FinalMapForJobtitles.get(wrap.jobTitle);
                    if(JobTitle.equals(wrap.jobTitle)){
                      Background='変更なし'; 
                      }
                    }                   
                    selectedJobTitle += wrap.jobTitle; 
                    first = false; 
                }else{ 
                
                system.debug('---map----'+FinalMapForJobtitles.containsKey(wrap.jobTitle));
                
                 if(FinalMapForJobtitles.containsKey(wrap.jobTitle)){
                    system.debug('---entered into map-----'+FinalMapForJobtitles.get(wrap.jobTitle));
                    String JobTitle=FinalMapForJobtitles.get(wrap.jobTitle);
                    
                    if(JobTitle.equals(wrap.jobTitle)){
                    system.debug('---entered into map-----');
                      Background='変更なし'; 
                      }
                    }
                    
                    selectedJobTitle += ',' + wrap.jobTitle; 
                    system.debug('---Background----'+Background);
                }  
            }
        }
        system.debug('----------------selectedJobTitle------------------'+selectedJobTitle);
        
        //Add Jobtitle to Anken__c object
        for(Anken__c echAnken : ankenList){
           if(Background=='変更なし'){
            echAnken.Background__c=Background;
            }
            echAnken.Job_Titles__c = selectedJobTitle;
        }
        //Update to Anken__c object
        
        try{        
            UPDATE ankenList;                     
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Job Titles Assigned Successfully')); 
            //poList = [select id, Name, Anken_Order__c, Production_Order_Status__c from Production_Order__c where Production_Order_Status__c =: newStatus and Anken_Order__c =: Id];
            poList = [select id, Name, Anken_Order__c, Production_Order_Status__c from Production_Order__c where Anken_Order__c =: Id and (Production_Order_Status__c =: newStatus or Production_Order_Status__c =: pendingStatus or Production_Order_Status__c =: estimationRequestStatus or Production_Order_Status__c =: awaitingApprovalStatus)];
            
            
            
            
           
            if (poList != null && poList.size() > 0) {
                
                //Copy Job Titles to Production Order
                for (Production_Order__c po : poList) {
                    po.Job_List__c = selectedJobTitle;
                }
                
                //Update PO
                UPDATE poList;
                
                Database.executeBatch(new EPMS_BatchAssignJobTitle_Files(poList[0].Name, selectedJobTitle),100);
            }
                                  
        } catch (Exception ex) {
            system.debug(ex);
        }
                
        return null;        
            
    }  

    /**
    * Wrapper class used for linking between Visual force and apex class for selected values
    *
    **/    
    public class WrapperClass {
        public Boolean isSelected {get;set;}
        public String jobTitle {get;set;}
        public WrapperClass(String jobTitle, Boolean isSelected) {
            this.jobTitle = jobTitle;
            this.isSelected = isSelected;
        }        
    }
}