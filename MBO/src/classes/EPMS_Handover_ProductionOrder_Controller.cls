/**********************************************************************************
*   Class               :       EPMS_Handover_ProductionOrder_Controller          *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to handover Production order from 
location to location                                                              *
**********************************************************************************/
public class EPMS_Handover_ProductionOrder_Controller {
    
    public List<Production_Order__c> prodOrderList {get;set;}
    public List<Files__c> filesList {get;set;}
    public List<Location__c> location {get;set;}
    public List<Anken__c> Ankenlist {get; set;}
    public string strSelCountry {get; set;}
    public List<SelectOption> LocOptionList {get; set;}
    
    public string selectvalue{get;set;}
    public String redirectPage { get; set; }
    public string selectLocationCode {get;set;}
    public string selectLocationname {get;set;}
    public string basepath{get;set;}
    public Id Userlocation {get;set;}
    Map<string,string> AnkenNames {get;set;}
    public List<string> reqids = new List<string>();        
    
    public EPMS_ProductionOrder_Query_Locator queryloc = new EPMS_ProductionOrder_Query_Locator();
    
    //constructor
    public EPMS_Handover_ProductionOrder_Controller() {
        AnkenNames = new Map<string,string>();
        
        
        User UserInformation = [SELECT Id, Name FROM User WHERE Id =: userInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(UserInformation != null && (profile.Name != 'System Administrator' && profile.Name!='Country Administrator')){
            Member__c memberInfo = [SELECT Id, Name, Location_id__c FROM Member__c WHERE User_Id__c =: UserInformation.Id];
            if(memberInfo != null){
                Userlocation = memberInfo.Location_id__c;
            }
        }
        system.debug(' Production Administration : Location ' + Userlocation);
        Schema.DescribeSObjectResult result = Shift_Assignments__c.SObjectType.getDescribe();       
        String sfUrl=URL.getSalesforceBaseUrl().getHost();
        redirectPage = 'https://'+sfUrl+'/'+result.getKeyPrefix();
        basepath= ApexPages.currentPage().getParameters().get('type'); 
        string ids = ApexPages.currentPage().getParameters().get('ids'); 
        
        for(String key:ids.split(',')){
            reqids.add(key);
        }
        
        
        
        // get PO details
        prodOrderList = [select id,Name,TL_Incharge__c, ReUpload__c,QC_Incharge__c,Mbo_Location__r.Name,Production_Order_Status__c, Mbo_Location__r.Location_Country__c, Mbo_Location__c,Anken_Order__c,Anken_Order__r.HachusakiText__c from Production_Order__c where id in: reqids];
        system.debug(' Production Order List : ' + prodOrderList);
        //getting PO files with New
        filesList = [Select Production_Order__C,Id,File_Auto_Number__c,Name,File_Location__c,Status__c from Files__c where Production_Order__c IN:reqids and Status__c=:label.EPMS_NewStatus_Order];
        
        // Get parent location name and country
        if(prodOrderList != null && prodOrderList.size() > 0){
            strSelCountry = prodOrderList[0].Mbo_Location__r.Location_Country__c;
            selectLocationCode= prodOrderList[0].Mbo_Location__c;
            selectLocationname= prodOrderList[0].Mbo_Location__r.Name;       
            system.debug(' Production Order List Select Country : ' + strSelCountry );           
            system.debug(' Production Order List Country : ' + selectLocationCode);           
        }
        
        //get current country PO location list other than current PO location
        LocOptionList = new List<SelectOption>();
        LocOptionList.add(new SelectOption('' ,'---Select---'));
        for(Location__c Loc :[select Id, Name from Location__c where Location_Country__c =:strSelCountry ]){
            if(selectLocationCode != Loc.Id) {
                LocOptionList.add(new SelectOption(Loc.Id, Loc.Name));
                system.debug(' Every Location ' + Userlocation);
            }
        }     
    }   
    
    Public Pagereference Handover(){
        
        User UserInformation = [SELECT Id, Name FROM User WHERE Id =: userInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        
        // show error message if no location is selected
        boolean locationError = false;
        if(selectvalue=='' || selectvalue=='---Select---' || selectvalue==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.EPMS_MBO_Select_Location));
        } 
        
        // else part to handover PO to another location
        else
        { 
            if(selectvalue!='' || selectvalue!='---Select---'){
                location =[select id,Name from Location__c where Id=:selectvalue limit 1];      
            }
            
            List<Production_Order__c> HandoverPoList=new List<Production_Order__c>(); 
            List<Files__c> HandoverfileList=new List<Files__c>();   
            List<Files__c> OrderFilesList = new List<Files__c>();
            
            if(prodOrderList.Size()>0 && prodOrderList!=null){
                
                for(Production_Order__c handoverPO:prodOrderList){
                    if(Userlocation != handoverPO.Mbo_Location__c  && profile.Name != 'System Administrator' && profile.Name!='Country Administrator' ){
                        locationError = true;
                        break;
                    }
                    if(handoverPO.Production_Order_Status__c==label.EPMS_NewStatus_Order){
                        handoverPO.Mbo_Location__c=selectvalue;
                        //updating PO location name for sharing rules
                        handoverPO.Location_For_Sharing__c=location[0].Name; 
                        //updating PO parent location field
                        handoverPO.ReUpload__c= true;
                        handoverPO.TL_Incharge__c= null;
                        handoverPO.QC_Incharge__c = null;
                        handoverPO.Production_Order_Qc_Assignment_Time__c=null;
                        handoverPO.Production_Order_TL_Assignment_Time__c=null;
                        handoverPO.Parent_Locarion__c=selectLocationname; 
                        handoverPO.FTP_Download_Status__c=false;    
                        
                        HandoverPoList.add(handoverPO);
                    }  
                    AnkenNames.put(handoverPO.Name,handoverPO.Location_For_Sharing__c);
                }
                
                OrderFilesList = queryloc.getFilesDetailsList(reqids);
                for(Files__c PObj1 : filesList){
                    PObj1.Status__c = label.EPMS_NewStatus_Order;
                    HandoverfileList.add(PObj1);
                }  
                
                if(locationError){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_HANDOVER_PADMIN_SELECT_ORDER_IN_SAME_LOCATION));
                    return null;
                }
            }
            // EPMSSF-525 Update "Dispatched To " in the Anken whenever the Location Changes - Modified by Lavanya P
            Ankenlist = [select id,Name,HachusakiText__c from Anken__c where Name =:AnkenNames.keyset()];
            if(Ankenlist.size()>0){
                for (Anken__c anken:Ankenlist){
                    anken.HachusakiText__c = AnkenNames.get(anken.name);
                }
            }
            try {  
                // Order Updation                
                if(HandoverPoList.size()>0){
                    update HandoverPoList;
                }
                //Production Order updation
                if(Ankenlist.size()>0){
                    update Ankenlist;
                }
                
                 if(HandoverfileList.size()>0 && HandoverfileList!=null) {
                  //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_HANDOVER_PADMIN_ORDER_DELETE_FILES));
                  Delete HandoverfileList;  
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_HANDOVER_PADMIN_ORDER_HANDOVER_SUCCESSFULLY));
                return null;
                
            } catch(DmlException me) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                return null;
            }  
          
        }
        return null;
    }
}