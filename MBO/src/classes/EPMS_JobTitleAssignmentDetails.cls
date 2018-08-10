/**********************************************************************************
*   Class               :       EPMS_JobTitleAssignmentDetails                    *
*   Created Date        :       20/12/2017                                        *           
*   Description         :       EPMSMS-521 Changes                                * 
*                               This Web service is used to send JobTitle
                                from Salesforce to Tracker                        *
**********************************************************************************/
 
@RestResource(urlMapping='/JobTitle_Assignments/*') //https://cs58.salesforce.com/services/apexrest/JobTitle_Assignments
global without sharing class EPMS_JobTitleAssignmentDetails {
    
    @HttpGet
    global static  void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        JobTitleWrapper response = new JobTitleWrapper();
        List<Bean> jobTitles = new List<Bean>();
        List<Job_Titles__c> result = new List<Job_Titles__c>();
        WS_FileDetailService serv = new WS_FileDetailService(); 
       
       
         string userId = String.valueOf(userinfo.getuserid());
         system.debug('$$$$$$$$$$$$$$$$$$: userId : ' + userId);
          result = serv.getJobTitles();
          system.debug('$$$$$$$$$$$$$$$$$$: result : ' + result);
         if(result != null && result.size() > 0) {
            for(Job_Titles__c jt: result){
            
             /*Add JobTitles to a new bean class  which is wrapped  to send responce*/
                jobTitles.add(new Bean(jt)); 
                response.JobTitleDetails = jobTitles;   
            }
         }
         else {          
            res.StatusCode = 404;// sending response as 404 if it Fails to Communicate with Tracker
         
        }  
        
        system.debug('$$$$$$$$$$$$$$$$$$: response : ' + response);
       
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serializePretty(response));  
       
    }
    
     //wrapping Bean 
    global class JobTitleWrapper {
        public list<Bean> JobTitleDetails;
       
        public JobTitleWrapper(){
           
        }
    }
   //Bean class for JobTitleWrapper
    global class Bean{
        public  string  id = '';
        public  string  jobTitle = '';
        public  string  jobType ='';
      
        //Intilating the Object Values      
        Bean(SObject sob){
        this.id         = (string) sob.get('Id');// Job Title id
        this.jobTitle   = (string) sob.get('Name'); // Job Title
        this.jobType    = (string) sob.get('Job_Type__c');
        }                                                                            
   }
}