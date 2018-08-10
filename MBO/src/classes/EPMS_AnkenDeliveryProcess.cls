/****************************************************************************************
*   Class               :       EPMS_AnkenDeliveryProcess                               *
*   Created Date        :       07/05/2018                                              *           
*   Description         :       EPMSMS-572 Changes                                      * 
*                               This Web service is used to Send PO in Uploaded status  *
from Salesforce to Tracker                              *
****************************************************************************************/

@RestResource(urlMapping='/DeliveryProcess/*') //https://cs58.salesforce.com/services/apexrest/DeliveryProcess
global with sharing class EPMS_AnkenDeliveryProcess {
    
    @HttpPost
    global static  List<DeliveryProcessWrapper> getAnkenList() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<DeliveryProcessWrapper> delvWrapperList;
        List<Bean> ankenBeanList;
        List<Anken__c> ankenList = new List<Anken__c>();
        List<Member__c> member = new List<Member__c>();
        List<Settings__c> SettingDetails;
        Settings__c settingsValue = new Settings__c();   
        EPMS_RestAPIService servObj = EPMS_RestAPIService.getInstance(); 
        
        if(userinfo.getuserid()!= null) {
            
            string userId = String.valueOf(userinfo.getuserid());
            
            system.debug('$$$$$$$$$$$$$$$$$$: userinfo.getuserid() : ' + userinfo.getuserid());
            //   member = [SELECT Id,Name,Location_id__c FROM Member__c WHERE User_Id__c=:String.valueOf(userinfo.getuserid()) limit 1];
            
          member =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId and Status__c='Active' limit 1];
            
            system.debug('$$$$$$$$$$$$$$$$$$: userId : ' + userId);
            system.debug('$$$$$$$$$$$$$$$$$$: member : ' + member);
            ankenList = servObj.getOrder_ForTransfer();
            
            if (member != null & member.size() > 0) {    
                SettingDetails = servObj.getSettings(member[0].Location_id__c);
            }    
            system.debug('$$$$$$$$$$$$$$$$$$: SettingDetails : ' + SettingDetails);
            if (SettingDetails != null && SettingDetails.size() > 0) {
                settingsValue = SettingDetails[0];                
            }    
            
            //settingList
            system.debug('$$$$$$$$$$$$$$$$$$: ankenList : ' + ankenList);
            
        /*    for(Anken__c Ank:ankenList) {
            
            system.debug('-----Gloabalip------'+Ank.KokyakuName__r.KokyakuId__c);
            system.debug('-----userid------'+Ank.KokyakuName__r.KokyakuPw__c);
            system.debug('-----userpwd------'+Ank.KokyakuName__r.GlobalIP__c);
            
            
            } */
            
            
            
            system.debug('$$$$$$$$$$$$$$$$$$: SettingValue : ' + settingsValue);
            String status;
            if(ankenList != null && ankenList.size() > 0 ) {              
                status = 'Success';   // respond success            
            } else {          
               // res.StatusCode = 404;// sending response as 404 if it Fails to Communicate with Tracker
                status = ''; // respond failure
              
            }  
            
        }
        delvWrapperList = new List<DeliveryProcessWrapper>();
        String procType = 'Transfer';
        ankenBeanList = new List<Bean>();
        
        for(Anken__c ank :  ankenList) {
        
        
         system.debug('-----Gloabalip------'+Ank.KokyakuName__r.KokyakuId__c);
            system.debug('-----userid------'+Ank.KokyakuName__r.KokyakuPw__c);
            system.debug('-----userpwd------'+Ank.KokyakuName__r.GlobalIP__c);
        
       String Gloabalip =Ank.KokyakuName__r.GlobalIP__c;
       String  Userid=Ank.KokyakuName__r.KokyakuId__c;
       String userpwd=Ank.KokyakuName__r.KokyakuPw__c;
        
            ankenBeanList.add(new Bean(ank, settingsValue,Gloabalip,userid,userpwd)); 
        }
        
        //ankenBeanList.add(new Bean(ank));
        //delvWrapperList.add(new DeliveryProcessWrapper(new Bean(ank), procType));  
        
        system.debug('------ankenBeanList: ' + ankenBeanList);
        
        if (ankenBeanList != null && ankenBeanList.size() > 0) {
            delvWrapperList.add(new DeliveryProcessWrapper(ankenBeanList, procType));
        }        
        
        system.debug('------delvWrapperList: ' + delvWrapperList);
        
        return delvWrapperList;
    }
    
    //wrapping Bean 
    global class DeliveryProcessWrapper {
        //public list<Bean> DeliveryProcessDetails;
        public String processType;
        public List<Bean> ankenBean;
        public DeliveryProcessWrapper(List<Bean> ankBean, String procType){
            ankenBean       = ankBean;
            processType     = procType;
        }
    }
    //Bean class for DeliveryProcessWrapper
    global class Bean{
        public  string  Name                = '';
        public  string  Status              = '';
        public  string  CustomerName        = '';
        public  string  ClientID            = '';
        public  string  ClientPWD           = '';
        public  string  ClientIP            = '';
        public  string  FileServerType      = '';
        //public  string  Host                = '';
        //public  string  UserName            = '';
        //public  string  Password            = '';
        public  string  OutputPath          = '';
        public  string  PortNumber          = '';
        
        //Intilating the Object Values      
        Bean(SObject sob, Settings__c settingsValue,String Gloabalip,String userid,String userpwd){
            this.Name                       = (string) sob.get('Name');// Anken
            this.Status                     = (string) sob.get('Status__c'); // Anken Status
            this.CustomerName               = (string) sob.get('Client_Name__c'); // Customer Name  
            this.ClientID                   = userid; 
            this.ClientPWD                  = userpwd;
            this.ClientIP                   = Gloabalip;
            this.FileServerType             = 'FTP';
            //this.FileServerType           = Label.FILE_SERVER_URL_TYPE;
            //this.Host                       = settingsValue.Delivery_Host_Name__c; 
            //this.UserName                   = settingsValue.Delivery_Ftp_User_Name__c;
            //this.Password                   = settingsValue.Delivery_Ftp_Password__c;
            this.OutputPath                 = settingsValue.Delivery_Output_Path__c;
            this.PortNumber                 = settingsValue.Delivery_Ftp_Port__c;
        }
    }
}