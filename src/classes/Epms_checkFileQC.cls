/**********************************************************************************
*   Class               :       Epms_checkFileQC                                  *
*   Created Date        :       20/09/2016                                        *           
*   Description         :       This Web service is invoke to send files from 
                                Salesforce to Tracker when Artist Clicks getFiles *
**********************************************************************************/

@RestResource(urlMapping='/CurrentOwnerOfFiles/*')
global without sharing class Epms_checkFileQC {


   
    
    @httppost
    global static CategoryWrapper   doPost() {

        CategoryWrapper response = new CategoryWrapper();
        List<Bean> Files = new List<Bean>();   
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Member__c> mem= new List<Member__c>();
        List<files__c> requiredFiles = new List<files__c>();
        string jsonstring = req.requestBody.toString();
        JSONParser parser = System.JSON.createParser(jsonstring);

        
        string fileValues;
        string ownStatus;
        List<String> reqids = new List<String>();

         string userId = String.valueOf(userinfo.getuserid());

         mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId and status__c='Active' limit 1];


           while(parser.nextToken() != JSONToken.END_OBJECT){
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                String text = parser.getText();
                system.debug(' [ JSON STRING KEY ] ' +  text);
                if(parser.nextToken() != JSONToken.VALUE_NULL){
                    if(text == 'fileIDs'){
                        fileValues = parser.getText();
                        system.debug('-------------------Files values-------------------'+fileValues);
                        
                        
                    }
                }

                
            }
        }
            

        for(String key:fileValues.split(',')){
         reqids.add(key);
        } 
             requiredFiles =[select id,name,File_Auto_Number__c,QCIncharge__c from files__c where File_Auto_Number__c =:reqids];

    if(requiredFiles != null && requiredFiles.size() > 0) {
     
            for(Files__c f: requiredFiles){

                if(!(f.QCIncharge__c == mem[0].id)){

                    ownStatus = 'Quit';
                }else{
                    ownStatus = 'Own';
                }

            
             /*Add files to a new bean class  which is wrapped  to send response*/
                Files.add(new Bean(f,ownStatus)); 
               
            }
        }
          response.Filedetails = Files;   

       system.debug('-------------------response-------------------'+response);
        
        return response;

                                                               
   }

     global class CategoryWrapper {
        public list<Bean> Filedetails;
       
        public CategoryWrapper(){
           
        }
    }




      //Bean class for CategoryWrapper
    global class Bean{
        public  string  fileID = '';
        public  string  fileStatus = '';
       
      
        //Intilating the Object Values      
        Bean(SObject sob,string status){
        this.fileID                    =    (string) sob.get('File_Auto_Number__c');// sending Name as string
        this.fileStatus                =    status; // sending Production order as String
          
      
        }                                                                            
   }


}