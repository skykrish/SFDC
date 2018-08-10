/**********************************************************************************
*   Class               :       EPMS_FileManager_Settings                         *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Webservice to get filemanager settings            *
**********************************************************************************/

@RestResource(urlMapping='/FileManager/setting/*')    
global with sharing class EPMS_FileManager_Settings{    
    // public String returnType {get;set;}    
    @HttpPost
    global static List<WrapperClass> getFileManagerDetails() {
        List<Settings__c> SettingDetails;
        List<WrapperClass> tstData;
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String requestType = RestContext.request.params.get('type');   
        String DataSet=null;  
        string ProductionOrderNames = null;         
        
        List<Member__c> member;
        
        // Retrieve setting details for request
        if(userinfo.getuserid()!= null){               
            member = [SELECT Id,Name,Location_id__c FROM Member__c WHERE User_Id__c=:String.valueOf(userinfo.getuserid()) limit 1];              
            // Retrieve the setting details 
            EPMS_RestAPIService servObj = EPMS_RestAPIService.getInstance(); 
            if(requestType!=null && requestType=='Tracker'){
                SettingDetails=servObj.getSettingsTracker(member[0].Location_id__c);                    
                
            }else {
                SettingDetails=servObj.getSettings(member[0].Location_id__c); 
                
                list<Production_Order__c> OrderNames = new list<Production_Order__c>();
                //OrderNames = [select id , Name,User__c from Production_Order__c where FTP_Upload_Status__c=false Limit 100];
                OrderNames = [select id , Name,User__c from Production_Order__c where FTP_Upload_Status__c=false AND Production_Order_Status__c NOT IN ('Cancelled','Uploaded') AND Mbo_Location__c =:member[0].Location_id__c ];
                
                tstData = new list<WrapperClass>();
                set<String> GroupNames = new Set<String>();
                
                boolean i=true;
                for(Settings__c ps :  SettingDetails)
                {
                    GroupNames.add(ps.Group_Name__c);               
                }
                list<String> ExistedGroups = new List<String>();
                list<String> Groupids = new List<String>();
                ExistedGroups.addall(GroupNames);
                
                List<Group> Names = new List<Group>();
                Names = [Select id,Name From Group Where Name IN:ExistedGroups];
                for(Group TY :Names )
                {
                    Groupids.add(TY.id);
                }
                list<GroupMember> AllSalesRegion = new list<GroupMember>();
                AllSalesRegion= [Select Id, UserOrGroupId,Group.Name From GroupMember Where GroupId IN: Groupids ];
                for(Settings__c ps :  SettingDetails){   
                    for(GroupMember GM : AllSalesRegion){              
                        for(Production_Order__c recq: OrderNames)
                        {
                            if( GM.Group.Name==ps.Group_Name__c){
                                if(GM.UserOrGroupId==recq.User__c){
                                    if(ProductionOrderNames==null)
                                    {
                                        ProductionOrderNames = recq.Name;
                                    }
                                    else {
                                        ProductionOrderNames = ProductionOrderNames  +','+recq.Name;          
                                    }
                                }
                            }
                        }
                    }                   
                    tstData.add(new WrapperClass(ps,ProductionOrderNames)); 
                    ProductionOrderNames=null;        
                }
                
            }
            
            if(requestType!=null && requestType=='Tracker'){
                for(Settings__c SettingData : SettingDetails){
                    SettingData.Samba_File_Input_Location__c=SettingData.Samba_File_Input_Location__c.replace('cifs://','');
                    SettingData.Samba_File_Output_Location__c=SettingData.Samba_File_Output_Location__c.replace('cifs://','');
                }
                tstData = new list<WrapperClass>();
                String POTracker=null;               
                for(Settings__c ps : SettingDetails){                               
                    tstData.add(new WrapperClass(ps,POTracker));              
                }                            
            }
            
        } 
        return tstData;
        
    }
    
    
    
    Global  Class WrapperClass
    {
        public Settings__c Settings {get;set;}
        public String ProductionOrder {get; set;}
        
        public WrapperClass(Settings__c pc, String rc){
            Settings = pc;
            ProductionOrder = rc;    
        }
        
    }   
}