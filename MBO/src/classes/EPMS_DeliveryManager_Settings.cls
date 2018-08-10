/************************************************************************************
*   Class               :       EPMS_DeliveryManager_Settings                       *
*   Created Date        :       02/05/2018                                          *           
*   Description         :       Webservice to get DeliveryManager settings          *
************************************************************************************/

@RestResource(urlMapping='/DeliveryManager/setting/*')    
global with sharing class EPMS_DeliveryManager_Settings{    
    @HttpPost
    global static List<WrapperClass> getDeliveryManagerDetails() {
        List<Settings__c> SettingDetails;
        List<WrapperClass> tstData;
        set<String> GroupNames = new Set<String>();
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String requestType = RestContext.request.params.get('type');   
        String DataSet=null;  
        string ProductionOrderNames = null;         
        
        List<Member__c> member;
        
        // Retrieve setting details for request
        if(userinfo.getuserid()!= null){
            system.debug('userinfo.getuserid()------' + userinfo.getuserid());
            String qry = 'SELECT Id,Name,Location_id__c FROM Member__c WHERE User_Id__c = \'' + String.valueOf(userinfo.getuserid())+'\'';
            system.debug('*********DM qry*******' + qry);
            
            member = [SELECT Id,Name,Location_id__c FROM Member__c WHERE User_Id__c=:String.valueOf(userinfo.getuserid()) limit 1];              
            system.debug('$$$$$$$$$$$$$$$$$$: member : ' + member);
            // Retrieve the setting details 
            EPMS_RestAPIService servObj = EPMS_RestAPIService.getInstance();
            
            //if(requestType!=null && requestType=='Tracker'){
            //SettingDetails=servObj.getDMSettingsTracker(member[0].Location_id__c);                  
            //}else{
            
            
            SettingDetails=servObj.getDMSettings(member[0].Location_id__c); 
            system.debug('$$$$$$$$$$$$$$$$$$: SettingDetails : ' + SettingDetails);
            tstData = new list<WrapperClass>();
            
            boolean i=true;
            for(Settings__c ps :  SettingDetails) {
                GroupNames.add(ps.Group_Name__c);
            }           
            list<String> ExistedGroups = new List<String>();
            list<String> Groupids = new List<String>();
            ExistedGroups.addall(GroupNames);
            
            List<Group> Names = new List<Group>();
            Names = [Select id,Name From Group Where Name IN:ExistedGroups];
            
            for(Group TY :Names ) {
                Groupids.add(TY.id);
            }
            
            list<GroupMember> AllSalesRegion = new list<GroupMember>();
            AllSalesRegion= [Select Id, UserOrGroupId,Group.Name From GroupMember Where GroupId IN: Groupids ];
            for(Settings__c ps :  SettingDetails) {
                tstData.add(new WrapperClass(ps)); 
            }  
        }
        system.debug('********tstData : ' + tstData); 
        
        return tstData;        
    }
    
    Global  Class WrapperClass {
        public Settings__c Settings {get;set;}
        
        public WrapperClass(Settings__c pc){
            Settings = pc;
        }
    }
}