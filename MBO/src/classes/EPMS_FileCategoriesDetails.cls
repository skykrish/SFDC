/**********************************************************************************
*   Class               :       EPMS_FileCategoriesDetails                        *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       webservice to get all file categories             *
**********************************************************************************/

@RestResource(urlMapping='/File_Categories/*')
global with sharing class EPMS_FileCategoriesDetails {
    
    @HttpGet
    global static List<Bean> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        CategoryWrapper response = new CategoryWrapper();
        List<Bean> catgorys = new List<Bean>();
        List<File_Categories__c> result = new List<File_Categories__c>();
        WS_FileDetailService serv = new WS_FileDetailService(); 
        
        // retriving all the Categories associated with Files  
        //File_Categories__c fc = new File_Categories__c(Name='AA', Standard_Time_per_File_Max__c=0,Standard_Time_per_File_Min__c=0);
        //catgorys.add(new Bean (fc));
        
        profile profile = [SELECT Id,Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
       
        result= serv.getCategories();
        for(File_Categories__c f:result){
            catgorys.add(new Bean (f)); 
        } 
        if(result != null && result.size() > 0) {      
           response.catgory = catgorys;
           response.status = 'Success';   // respond success      
        } else {
            response.catgory = null;
            response.status = 'The user does not have any file_categories'; // respond failure
            response.message = 'The categories could not be found, please try again.';
            res.StatusCode = 204;
            res.responseBody = Blob.valueOf('{ "FileCategories" : 0}');
        }       
        return response.catgory;          
    }
    //wrapping bean as a responce object
    global class CategoryWrapper {
        public List<Bean> catgory;
        public String status;
        public String message;
        public CategoryWrapper(){        
        }  
    }
    //New Bean class for wrapper 
    global class Bean {
        public Id Id;
        public String Name;
        //public Decimal MinStf;
        //public Decimal MaxStf;
        Bean(SObject sob) { 
           this.Id = sob.Id;
           this.Name = (String) sob.get('Name');
           //this.MinStf= 0.0;
           //this.MaxStf= 0.0;
        }
    }    
}