/**********************************************************************************
*   Class               :       EPMS_HandoverProductionOrder                      *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to handover Production order           *
**********************************************************************************/
public class EPMS_HandoverProductionOrder{
    public boolean diableButton{public get;set;}
    public List<Production_Order__c> productionOrders{public get;set;}
    public string selectedShiftId{get;set;}
    public string selectedTeamId{get;set;}
    public  List<Team__c> Teams = new List<Team__C>();
    public List<Shift_Assignments__c> Assigments = new List<Shift_Assignments__c>();
    public List<string> reqids = new List<string>();
    public Id locationId {get;set;}
    public string basepath {get;set;}
    
    public EPMS_ProductionOrder_Query_Locator queryloc = new EPMS_ProductionOrder_Query_Locator();
    
   
    public EPMS_HandoverProductionOrder(ApexPages.StandardController controller) {
    selectedShiftId=null;
    selectedTeamId=null;
    string ids = ApexPages.currentPage().getParameters().get('ids');
      basepath = ApexPages.currentPage().getParameters().get('type');
    diableButton = false;
    
//get the all the comma seperated values from the calling visualforce page 
    for(String key:ids.split(',')){
     reqids.add(key);
    }
       productionOrders = [select id,Name,TL_Incharge__c,QC_Incharge__c, Production_Order_Old_Status__c,Mbo_Location__c from Production_Order__c where id in: reqids];
       
       // Seperate the location from production orders
       if(productionOrders != null && productionOrders.size() > 0){
           locationId = productionOrders[0].Mbo_Location__c;
       } 
   }
  
    // method to get all the shift values and pass to vf page 
    public List<SelectOption> getListOfShifts()
    {
        List<Shift__c> Shifts = [select id ,name from Shift__c WHERE Status__c =:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Shift_Location__c = : locationId];
        List<SelectOption> ShiftOptionList = new List<SelectOption>();
        shiftOptionList.add(new SelectOption( ' ' ,'---Select---'));
        for(Shift__c S : Shifts)
        {
           ShiftOptionList.add(new SelectOption(S.Id , S.Name));
        }
        return ShiftOptionList;
    }
    
    
    //method to get all the team values 
    public List<SelectOption> getListOfTeams()
    {
        list<id> teamIds = new list<id>();

        if(selectedShiftId != null){
            Assigments = [select id ,Name,Member__c, FromTime__c,ToTime__c, Location__c,Member__r.Team_Id__c from Shift_Assignments__c where Shift_Code__c =: selectedShiftId];
        }
        for(Shift_Assignments__c sa:Assigments){
            teamIds.add(sa.Member__r.Team_Id__c);            
        }
        List<Team__c> Teams = [select id ,Name from Team__c where id =:teamIds];
        List<SelectOption> TeamOptionList = new List<SelectOption>();
        TeamOptionList.add(new SelectOption( ' ' ,'---Select---'));
        for(Team__c T : Teams)
        {
            TeamOptionList.add(new SelectOption(T.Id , T.Name));
        }
        return TeamOptionList;
    }
    
    //update method 
    public PageReference updateorder(){
       ID TLid;
       ID QCid;
       
        List<Production_Order__c> updateproductionOrders = new  List<Production_Order__c>();
        List<Files__c> UpdateFilesList = new List<Files__c>();
        List<Files__c> OrderFilesList = new List<Files__c>();

        if(String.isBlank(selectedShiftId)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_SHIFT));
            return null;
        }
        if(String.isBlank(selectedTeamId)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_TEAM));
            return null;
        
        }
        if(productionOrders !=null && productionOrders.size()>0){        
            for(Member__c member:[select id ,Name,Team_Id__c,Designation__c,Location_id__c from Member__c where Team_Id__c =: selectedTeamId AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS] ){
            
                if(member.Designation__c==EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME){                    
                    TLid= member.id;
                }
                
                if(member.Designation__c==EPMS_UTIL.EPMS_QC_PROFILE_NAME){                    
                    QCid= member.id;
                }
            }
            
            for(Production_Order__c production: productionOrders){            
                production.TL_Incharge__c=TLid;
                production.QC_Incharge__c=QCid;
                production.Production_Order_Status__c=label.EPMS_HandoverStatus_Order;
                updateproductionOrders.add(production);                
            }
            
            OrderFilesList = queryloc.getFilesDetailsList(reqids);
            for(Files__c PObj1 : OrderFilesList){
                PObj1.Status__c = label.EPMS_HandoverStatus_Order;
                UpdateFilesList.add(PObj1);
            }
            
            if(updateproductionOrders.size()>0 && updateproductionOrders!=null){
            
             try{
                    update updateproductionOrders;                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_GN_RECORD_UPDATED));
                    selectedShiftId=null;
                    selectedTeamId=null;
             }catch(exception ex){             
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));             
             }       
            }
        }     
        return null;
    }
}