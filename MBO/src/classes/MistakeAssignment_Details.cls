/**********************************************************************************
*   Class               :       EPMS_FileAssignMentDetails                        *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       This Web service is used to send files from 
                                Salesforce to Tracker when Artist Clicks getFiles *
**********************************************************************************/

@RestResource(urlMapping='/MistakeAssignment_Details/*')
global without sharing class MistakeAssignment_Details {
    
    @HttpGet
    global static  void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        CategoryWrapper response = new CategoryWrapper();
        List<Mistakes__c> result = new List<Mistakes__c>();
        List<Member__c> member = new List<Member__c>();
        List<Bean> Mistakes = new List<Bean>();   
        List<Production_Order__c> prodOrder = new List<Production_Order__c>();
        List<Mistakes__c> fles = new List<Mistakes__c>();
        WS_FileDetailService serv = new WS_FileDetailService(); 
       
       
         string userId = String.valueOf(userinfo.getuserid());
          result = serv.getMistakes(userId);
         if(result != null && result.size() > 0) {
            for(Mistakes__c m: result){
            
             /*Add files to a new bean class  which is wrapped  to send responce*/
                 Mistakes.add(new Bean(m)); 
                response.MistakeDetails = Mistakes;   
            }
         }
         else {          
            res.StatusCode = 404;// sending response as 404 if it Fails to Communicate with Tracker
         
        }  
       
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serializePretty(response));        
    }
    
     //wrapping Bean 
    global class CategoryWrapper {
        public list<Bean> MistakeDetails;
       
        public CategoryWrapper(){
           
        }
    }
   //Bean class for CategoryWrapper
    global class Bean{
    public string id ='';
    public string   Mistake ='';
    public string   Mistake_Category = '';
    public string Mistake_Description = '';
    public Decimal Penalty_for_Artist;  
    public Decimal Penalty_for_QC;
    public Boolean Skip_Penalty_Flag;
      
        //Intilating the Object Values      
        Bean(SObject sob){
        this.id = (string)sob.get('Name');
       this.Mistake = (string)sob.get('Mistake__c');
       this.Mistake_Category = (string)sob.get('Mistake_Category__c');
       this.Mistake_Description = (string)sob.get('Mistake_Description__c');
       this.Penalty_for_Artist = (Decimal)sob.get('Penalty_for_Artist__c');
       this.Penalty_for_QC   = (Decimal)sob.get('Penalty_for_QC__c');
       this.Skip_Penalty_Flag =(Boolean)sob.get('Skip_Penalty_Flag__c');

        }                                                                            
   }
}