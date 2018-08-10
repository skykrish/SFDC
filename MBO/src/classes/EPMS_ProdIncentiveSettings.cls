/****************************************************************************
*   Class               :       ProdIncentiveSettings                       *
*   Created Date        :       09/09/2016                                  *           
*   Description         :       To display the production Settings          *
*                               based on the location and  the user         *
*                               settings done Global Admin/Production admin *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/

public class EPMS_ProdIncentiveSettings{
    
    //Variable Declaration
    public string locationId {get;set;}
    public string locname{get;set;}
    public List<File_Categories__c> incentiveList{public get;public set;}

    public list<Location__c> locList = new list<Location__c>();
    public SelectOption[] LocationList{get;set;}
    public string selLoc{public get;public set;}
    public String MyProflieName{get;set;} 
    List<profile> profileList = null;
    public Member__c member {get;set;}
    public Location__c locObj {get;set;}
    public Double cost{public get;public set;}
    Public string ConvertedCost {get;set;}
    PageReference pg  = null;   
    public Boolean ErrorFlag{get; set;}   
    
    //Create Instance/ Call service Class
    EPMS_ProductionIncentiveService serviceObj = new EPMS_ProductionIncentiveService();
    
    
    //Get Production order Setting based on Profiles Using the Service Class
    public EPMS_ProdIncentiveSettings(ApexPages.StandardController controller) {
        member  = serviceObj.getMember();
        profileList = serviceObj.getProfiles();
        MyProflieName = profileList[0].Name;
        Locationlist = new SelectOption[]{};
       if(MyProflieName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME || MyProflieName == 'Country Administrator' ){
        Locationlist.add(new SelectOption('',''));
        }
        locList = serviceObj.getLocations();
        for(Location__c locObj : locList ){
           Locationlist.add(new SelectOption(locObj.id, locObj.Name)); 
        }
          locationId = ApexPages.currentPage().getParameters().get('nid');
        
             if(MyProflieName == EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME){            
             locname= member.location_id__r.Name;
             }           
          
        if(locationId != null){
            if(MyProflieName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME || MyProflieName == 'Country Administrator' ){
                incentiveList = serviceObj.getIncentiveList();
                locObj  =  serviceObj.getCostByLoc(locationId );
                cost = locObj.Standard_Regular_Cost__c;
                locationId  = locationId;
            }
        }
        else if(locationId == null){
            if(MyProflieName == EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME){
                incentiveList = serviceObj.getIncentiveList();
                locObj  =  serviceObj.getCostByLoc(member.location_id__c );
                locationId = member.location_id__c;
                cost = locObj.Standard_Regular_Cost__c;
            }
        }
    }
    
  
    
    public Double getCost(){
        return cost;
    }
    
    public void setCost(Double Cost){
        this.Cost= Cost;
    }
    
    // Redirect to page After Save based profiles    
    public pagereference saveChanges(){
        ErrorFlag=false;
        ConvertedCost = String.valueOf(cost);
        
        if(MyProflieName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME || MyProflieName == 'Country Administrator' ) {           
            pg = new PageReference('/apex/EPMS_ProdIncentiveSettings?nid='+locationId);
        }
        
        if(MyProflieName == EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME){
            pg = new PageReference('/apex/EPMS_ProdIncentiveSettings');
        }
        
        for(File_Categories__c Filecategory : incentiveList){
            if(Filecategory.Standard_Time_per_File_Min__c > Filecategory.Standard_Time_per_File_Max__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.EPMS_MBO_ERR_FILECATEGORY_MIN_MAX_VALIDATION));
                ErrorFlag=true;
            }
                   
        }
        
        if(ConvertedCost.isAlphanumeric()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.EPMS_MBO_ERR_FILECATEGORY_COST_VALIDATION));
            ErrorFlag=true;
        }
        
        if(ErrorFlag==false){
            if(incentiveList!=null || incentiveList.size()>0 )
            update incentiveList;
            system.debug('cost'+cost);
            system.debug('cost'+locObj.Standard_Regular_Cost__c);
            if(cost!=null)
            locObj.Standard_Regular_Cost__c=cost;
            update locObj;
            system.debug('cost'+cost);
            system.debug('cost'+locObj.Standard_Regular_Cost__c);
            pg.setRedirect(true);
            return pg; 
        }else{
           return null;
        }        
    }
    
    //reset values in visualforce page
     public pagereference reset(){
        return null;
    }
}