/****************************************************************************************************************/
/* Class Name          :  EPMS_EnhancedViewPOController                                                          */
/*  Created Date       :  20/12/2017                                                                             */
/* Description         :  Responsive "row" [vertical height] based on height of text field in all PO list view   */
/* Version              : 1.0                                                                                     */
/*****************************************************************************************************************/

public with sharing class EPMS_EnhancedViewPOController {
    
    public String POFilterId {get; set;}
    // public List<Production_Order__c> polist {get; set;}
    public List<WrapperClass> wrapList {get;set;}
    public string recordid{get;set;}
    public Set<Id> selectedFileIds;
    //public String contextItem{get;set;} 
    public Integer noOfRecords{get; set;}
    public Integer size {get;set;}
    public Integer setUserChoice { get; set; }
    private Integer CountTotalRecords = 0;
    public Long noOfPages {get; set;}
    public Boolean selectedAllProperties {get;set;} 
    public list<ListView> ListViews{get;set;}
    public List<SelectOption> ListViewOptions{get;set;}
    public List<ListView> ListViewOfFilterId{get;set;}
    public String sortByStatus{get;set;}
    
    Map<integer,List<WrapperClass>> mapwrapperpages = new Map<integer,List<WrapperClass>>(); 
    
    //Sorting 
    public String sortingChoice {get; set;}
    public String sortType {get;set;}
    public List<SelectOption> sortingoptions {get;set;}
    public List<SelectOption> sortingTypeoptions {get;set;}
    public integer POCountList {get; set;}
    
    public ApexPages.StandardSetController setPO {
        get{
            if(setPO == null){
                string baseQuery = 'select id,name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,lastmodifieddate,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c order by Createddate limit 10000';
                setPO = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                //setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id,name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,lastmodifieddate,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));
                setPO.setpageNumber(1);
                setPO.setPageSize(Size);
                noOfRecords = setPO.getResultSize();
                
                if(POFilterId != null) {
                    System.debug('----------POFilterId---------'+POFilterId);
                    setPO.setFilterId(POFilterId);
                } else {                    
                    Id profileId=userinfo.getProfileId();
                    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                    if(profileName=='Quality Control' || profileName=='Team Leader') {                        
                        ListView MyOrder=new ListView();
                        MyOrder=[select id,name from listview where sobjecttype='Production_Order__c' AND Name='MY ORDERS' Limit 1];
                        POFilterId=MyOrder.id;
                        setPO.setFilterId(POFilterId);
                    } else  if(profileName=='System Administrator' || profileName=='Country Administrator'||profileName=='Shift Administrator'||profileName=='Assignor') {                        
                        ListView MyOrder=new ListView();
                        MyOrder=[select id,name from listview where sobjecttype='Production_Order__c' AND Name='All Production Orders' Limit 1];
                        POFilterId=MyOrder.id;
                        setPO.setFilterId(POFilterId);
                    }
                }
            }
            return setPO;
        }
        set;
    }    
    
    public EPMS_EnhancedViewPOController() {
        
        ListViews=new list<ListView>(); 
        recordid = ApexPages.currentPage().getParameters().get('id');
        selectedFileIds = new set<id>();
        size= 20; 
        setUserChoice = 20;
        noOfPages = 1;
        if(CountTotalRecords > setUserChoice){              
            //Decimal pageCount = (Decimal.valueOf(CountTotalRecords) / Decimal.valueOf(setUserChoice));
            //noOfPages = pageCount.round(System.RoundingMode.UP); 
        }else {
            noOfPages = 1;
        } 
        
        sortingoptions = new List<SelectOption>();
        sortingoptions.add(new SelectOption('None','None'));
        sortingoptions.add(new SelectOption('TAT','TAT'));
        sortingoptions.add(new SelectOption('STATUS','STATUS')); 
        if(sortingoptions.size() > 0){
            sortingChoice = 'None';
        }        
        sortingTypeoptions = new List<SelectOption>();
        sortingTypeoptions.add(new SelectOption('ASC','ASC'));
        sortingTypeoptions.add(new SelectOption('DESC','DESC'));       
        if(sortingTypeoptions.size() > 0){
            sortType = 'ASC';
        }
    }
    
    public void sortmethod(){
        
        //Modified by Udayasri to gt records based on selected criteria        
        ListViewOfFilterId =new list<ListView>();
        ListViewOfFilterId=[select id,Name from ListView where id=:POFilterId limit 1];
        if(ListViewOfFilterId.size()>0){
            sortByStatus=ListViewOfFilterId[0].Name;
            system.debug('-----id----'+ListViewOfFilterId[0].id);
            system.debug('-----status----'+sortByStatus);
        }      
        
        if(sortingChoice==null){
            sortingChoice='None';
        }
        if(sortType==null){
            sortType='ASC';
        }
        // end
        
        if(sortByStatus== 'All Production Orders' && sortType == 'ASC' && sortingChoice == 'TAT'){
            size=20;
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Estimation Request','Handover') and Name != null order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            
        } else if(sortByStatus== 'All Production Orders' && sortType == 'DESC' && sortingChoice == 'TAT'){  
            size=20;
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Estimation Request','Handover') and Name != null order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));       
            
        } else if(sortByStatus== 'All Production Orders' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Estimation Request','Handover') AND name!=Null order by Production_Order_Status__c limit 10000]));       
            size=20;
        } else if(sortByStatus== 'All Production Orders' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Estimation Request','Handover') AND name!=Null order by Production_Order_Status__c DESC  limit 10000]));       
            size=20;
        } else  if(sortByStatus== 'ASSIGNED' && sortType == 'ASC' && sortingChoice == 'TAT'){                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Assigned' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        } else if(sortByStatus== 'ASSIGNED' && sortType == 'DESC' && sortingChoice == 'TAT'){      
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Assigned' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));       
            size=20;
        } else if(sortByStatus== 'ASSIGNED' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Assigned' AND name!=Null order by Production_Order_Status__c limit 10000]));       
            size=20;
        } else if(sortByStatus== 'ASSIGNED' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Assigned' AND name!=Null order by Production_Order_Status__c DESC  limit 10000]));       
            size=20;
        } else if(sortByStatus== 'Assignor View' && sortType == 'ASC' && sortingChoice == 'TAT'){                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover') and Current_User_Profile__c='Assignor' and New_Files_Count__c > 0 and current_assignor__c='TRUE' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        } else if(sortByStatus== 'Assignor View' && sortType == 'DESC' && sortingChoice == 'TAT'){      
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover') and Current_User_Profile__c='Assignor' and New_Files_Count__c > 0 and current_assignor__c='TRUE' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));       
            size=20;
        } else if(sortByStatus== 'Assignor View' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover') AND Current_User_Profile__c='Assignor' and New_Files_Count__c > 0 and current_assignor__c='TRUE' order by Production_Order_Status__c limit 10000]));       
            size=20;
        } else if(sortByStatus== 'Assignor View' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover') AND Current_User_Profile__c='Assignor' and New_Files_Count__c > 0 and current_assignor__c='TRUE' order by Production_Order_Status__c DESC  limit 10000]));       
            size=20;
        } else if(sortByStatus== 'Awaiting Approval' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Awaiting Approval' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)') order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Awaiting Approval' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Awaiting Approval' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)') order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Awaiting Approval' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Awaiting Approval' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)') order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Awaiting Approval' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Awaiting Approval' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)') order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'CANCELLED' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Cancelled' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'CANCELLED' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Cancelled' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'CANCELLED' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Cancelled' order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'CANCELLED' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Cancelled' order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'COMPLETED' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where (Production_Order_Status__c='Completed' AND (FTP_Upload_Status__c=True OR FTP_Upload_Status__c=False)) order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'COMPLETED' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where (Production_Order_Status__c='Completed' AND (FTP_Upload_Status__c=True OR FTP_Upload_Status__c=False)) order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'COMPLETED' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where (Production_Order_Status__c='Completed' AND (FTP_Upload_Status__c=True OR FTP_Upload_Status__c=False)) order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'COMPLETED' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where (Production_Order_Status__c='Completed' AND (FTP_Upload_Status__c=True OR FTP_Upload_Status__c=False)) order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimation Request' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimation Request' AND Estimation_User__c=True) OR (Production_Order_Status__c='Estimation Request' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimation Request' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimation Request' AND Estimation_User__c=True) OR (Production_Order_Status__c='Estimation Request' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimation Request' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimation Request' AND Estimation_User__c=True) OR (Production_Order_Status__c='Estimation Request' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimation Request' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimation Request' AND Estimation_User__c=True) OR (Production_Order_Status__c='Estimation Request' AND Current_User_Profile__c IN ('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimator Assigned' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimator Assigned' AND Current_Estimator__c='True') OR (Production_Order_Status__c='Estimator Assigned' AND Current_User_Profile__c IN ('System Administrator','システム管理者'))) order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimator Assigned' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimator Assigned' AND Current_Estimator__c='True') OR (Production_Order_Status__c='Estimator Assigned' AND Current_User_Profile__c IN ('System Administrator','システム管理者'))) order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimator Assigned' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimator Assigned' AND Current_Estimator__c='True') OR (Production_Order_Status__c='Estimator Assigned' AND Current_User_Profile__c IN ('System Administrator','システム管理者'))) order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Estimator Assigned' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Production_Order_Status__c='Estimator Assigned' AND Current_Estimator__c='True') OR (Production_Order_Status__c='Estimator Assigned' AND Current_User_Profile__c IN ('System Administrator','システム管理者'))) order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'MY ORDERS' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Current_User_Profile__c =:'Production Administrator' OR Current_User_Profile__c =:'Shift Administrator') OR (Team_Leader__c=:'True' AND Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover')) OR (Quality_Checker__c=:'True' AND Production_Order_Status__c IN ('QCIP','WIP')) OR (Current_User_Profile__c =:'Sales Region' AND Production_Order_Status__c IN ('New','Completed'))) order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus== 'MY ORDERS' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Current_User_Profile__c =:'Production Administrator' OR Current_User_Profile__c =:'Shift Administrator') OR (Team_Leader__c=:'True' AND Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover')) OR (Quality_Checker__c=:'True' AND Production_Order_Status__c IN ('QCIP','WIP')) OR (Current_User_Profile__c =:'Sales Region' AND Production_Order_Status__c IN ('New','Completed'))) order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));
            size=20;
        }else if(sortByStatus== 'MY ORDERS' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Current_User_Profile__c =:'Production Administrator' OR Current_User_Profile__c =:'Shift Administrator') OR (Team_Leader__c=:'True' AND Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover')) OR (Quality_Checker__c=:'True' AND Production_Order_Status__c IN ('QCIP','WIP')) OR (Current_User_Profile__c =:'Sales Region' AND Production_Order_Status__c IN ('New','Completed'))) order by Production_Order_Status__c limit 10000]));
            size=20;
        } else if(sortByStatus== 'MY ORDERS' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where ((Current_User_Profile__c =:'Production Administrator' OR Current_User_Profile__c =:'Shift Administrator') OR (Team_Leader__c=:'True' AND Production_Order_Status__c IN ('New','Assigned','WIP','Redo','Handover')) OR (Quality_Checker__c=:'True' AND Production_Order_Status__c IN ('QCIP','WIP')) OR (Current_User_Profile__c =:'Sales Region' AND Production_Order_Status__c IN ('New','Completed'))) order by Production_Order_Status__c DESC limit 10000]));
            size=20;
        } else if(sortByStatus== 'NEW' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'NEW' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'NEW' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'NEW' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'PENDING' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Pending' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'PENDING' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Pending' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'PENDING' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Pending' order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'PENDING' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Pending' order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'QCIP' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='QCIP' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'QCIP' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='QCIP' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'QCIP' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='QCIP' order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'QCIP' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='QCIP' order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Redo' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Redo' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Redo' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Redo' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Redo' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Redo' order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Redo' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='Redo' order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'Specific Customer PO' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,lastmodifieddate ,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where lastmodifieddate=Today order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));    
            size=20;
        } else if(sortByStatus== 'Specific Customer PO' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,lastmodifieddate ,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where lastmodifieddate=Today order by Production_Order_TAT__c  DESC NULLS LAST limit 10000]));    
            size=20;
        } else if(sortByStatus== 'Specific Customer PO' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,lastmodifieddate ,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where lastmodifieddate=Today order by Production_Order_Status__c limit 10000]));    
            size=20;
        } else if(sortByStatus== 'Specific Customer PO' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,lastmodifieddate ,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where lastmodifieddate=Today order by Production_Order_Status__c DESC limit 10000]));    
            size=20;
        } else if(sortByStatus== 'UPLOADED' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and Production_Order_Status__c='Uploaded' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'UPLOADED' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and  Production_Order_Status__c='Uploaded' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'UPLOADED' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and Production_Order_Status__c='Uploaded' order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'UPLOADED' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and Production_Order_Status__c='Uploaded' order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus=='UPLOADED Within 24 Hours' && sortingChoice == 'TAT' && sortType == 'ASC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and Production_Order_Status__c='Uploaded' and lastmodifieddate >= LAST_N_DAYS:1 order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus=='UPLOADED Within 24 Hours' && sortingChoice == 'TAT' && sortType == 'DESC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and Production_Order_Status__c='Uploaded' and lastmodifieddate >= LAST_N_DAYS:1 order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus=='UPLOADED Within 24 Hours' && sortingChoice == 'STATUS' && sortType == 'ASC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and Production_Order_Status__c='Uploaded' and lastmodifieddate >= LAST_N_DAYS:1 order by Production_Order_Status__c limit 10000]));
            size=20;
        } else if(sortByStatus=='UPLOADED Within 24 Hours' && sortingChoice == 'STATUS' && sortType == 'DESC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where FTP_Upload_Status__c=True and Production_Order_Status__c='Uploaded' and lastmodifieddate >= LAST_N_DAYS:1 order by Production_Order_Status__c DESC limit 10000]));
            size=20;
        } else if(sortByStatus== 'WIP' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='WIP' order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'WIP' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='WIP' order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'WIP' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='WIP' order by Production_Order_Status__c limit 10000]));                  
            size=20;
        }else if(sortByStatus== 'WIP' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='WIP' order by Production_Order_Status__c DESC limit 10000]));                  
            size=20;
        }else if(sortByStatus== '送られていない案件' && sortingChoice == 'TAT' && sortType == 'ASC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' and New_Files_Count__c=0 order by Production_Order_TAT__c  ASC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus== '送られていない案件' && sortingChoice == 'TAT' && sortType == 'DESC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' and New_Files_Count__c=0 order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus== '送られていない案件' && sortingChoice == 'STATUS' && sortType == 'ASC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' and New_Files_Count__c=0 order by Production_Order_Status__c limit 10000]));
            size=20;
        } else if(sortByStatus== '送られていない案件' && sortingChoice == 'STATUS' && sortType == 'DESC'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c, Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c='New' and New_Files_Count__c=0 order by Production_Order_Status__c DESC limit 10000]));
            size=20;
        } else if(sortByStatus== 'All Production Orders_CA' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Handover') order by Production_Order_TAT__c ASC NULLS LAST limit 10000]));                  
            size=20;
        } else if(sortByStatus== 'All Production Orders_CA' && sortType == 'DESC' && sortingChoice == 'TAT'){      
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Handover') order by Production_Order_TAT__c DESC NULLS LAST limit 10000]));       
            size=20;
        } else if(sortByStatus== 'All Production Orders_CA' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c, Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Handover') order by Production_Order_Status__c limit 10000]));       
            size=20;
        } else if(sortByStatus== 'All Production Orders_CA' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setPO = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name, Parent_Locarion__c,Location_For_Sharing__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Handover_File_Count__c,Redo_Files_Count__c,Production_Order_TAT__c,Anken_Order__c,Anken_Order__r.name,Anken_Order__r.id,Production_Order_Status__c, Jobs_List__c,Total_Anken_Count__c,New_Files_Count__c,Total_Files_Assigned__c,WIP_Files_Count__c,No_of_QC_Files__c,Approved_File_Count__c, TL_Incharge__c, QC_Incharge__c, Production_Order_Instruction__c, Mbo_Location__c, Order_Attachments__c from Production_Order__c where Production_Order_Status__c IN ('New','Assigned','WIP','QCIP','Pending','Redo','Handover') order by Production_Order_Status__c DESC  limit 10000]));       
            size=20;
        }
        
    }
    
    public PageReference refreshPageS() {
        setPO.setPageSize(size);
        return null;
    }
    
    public void isSelectedAll() {
        for (sObject record : setPO.getRecords()){
            Production_Order__c p = (Production_Order__c) record;
            if(selectedAllProperties){
                this.selectedFileIds.add(p.id);
            }else{
                this.selectedFileIds.remove(p.id);
            }
        }
    }
    
    public Integer getSelectedCount() {
        return this.selectedFileIds.size();
    } 
    
    public Integer pageNumber {
        get {
            return setPO.getPageNumber();
        }
        set;
    }
    
    public List<WrapperClass> getAllPOrders() {
        wrapList =  new List<WrapperClass>();
        for(Production_Order__c po : (List<Production_Order__c>) setPO.getRecords()){     
            wrapList.add(new WrapperClass(po)); 
        }
        return wrapList;
    }
    
    
    public SelectOption[] getPOExistingViews(){
        
        //Modified by udayasri to get list views in sequence
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        ListViews=[select id,name from listview where sobjecttype='Production_Order__c' order by name Asc];
        System.debug('-----------------'+ListViews);
        
        ListViewOptions = new List<SelectOption>();
        
        if(profileName=='Country Administrator') {
            for(ListView View: ListViews){ 
                
                if(View.Name=='All Production Orders'||View.Name=='All Production Orders_CA'||View.Name=='CANCELLED'|| View.Name=='COMPLETED' || View.Name=='NEW' || View.Name=='PENDING' || View.Name=='QCIP' || View.Name=='REDO' || View.Name=='UPLOADED' || View.Name=='UPLOADED within 24 hours' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name)); 
                    POCountList = setpo.getResultSize();
                }
                
            }
        } else if(profileName=='Quality Control'){
            for(ListView View: ListViews){ 
                
                if(View.Name=='All Production Orders'|| View.Name=='Awaiting Approval' ||View.Name =='Estimation Request'||View.Name =='Estimator Assigned'|| View.Name=='MY ORDERS' ||View.Name=='CANCELLED'|| View.Name=='COMPLETED' || View.Name=='NEW' || View.Name=='PENDING' || View.Name=='QCIP' || View.Name=='UPLOADED' || View.Name=='UPLOADED within 24 hours' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));    
                    POCountList = setpo.getResultSize();
                }
            }
        } else if(profileName=='Shift Administrator'){
            for(ListView View: ListViews){ 
                
                if(View.Name=='All Production Orders'|| View.Name=='MY ORDERS'||View.Name=='CANCELLED'|| View.Name=='COMPLETED' || View.Name=='NEW' || View.Name=='PENDING' || View.Name=='QCIP' || View.Name=='UPLOADED' || View.Name=='UPLOADED within 24 hours' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));  
                    POCountList = setpo.getResultSize();
                }
            }
        }else if(profileName=='Assignor'){
            for(ListView View: ListViews){ 
                
                if(View.Name=='All Production Orders'|| View.Name=='CANCELLED' || View.Name=='COMPLETED' ||View.Name=='Assignor View'|| View.Name=='NEW' || View.Name=='PENDING' || View.Name=='QCIP' || View.Name=='WIP'|| View.Name=='UPLOADED' || View.Name=='UPLOADED Within 24 Hours'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));  
                    POCountList = setpo.getResultSize();
                }
            }
        }else if(profileName=='Team Leader'){
            for(ListView View: ListViews){ 
                
                if( View.Name=='MY ORDERS'|| View.Name=='Assignor View' ||View.Name=='CANCELLED'|| View.Name=='COMPLETED' || View.Name=='NEW' || View.Name=='PENDING' || View.Name=='QCIP' || View.Name=='REDO' || View.Name=='UPLOADED' || View.Name=='UPLOADED within 24 hours' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name)); 
                    POCountList = setpo.getResultSize();
                }
            }
        }else if(profileName=='Production Administrator'){
            for(ListView View: ListViews){ 
                if(View.Name=='All Production Orders'||View.Name=='CANCELLED'|| View.Name=='COMPLETED' || View.Name=='NEW' || View.Name=='PENDING' || View.Name=='QCIP' || View.Name=='REDO' || View.Name=='UPLOADED' || View.Name=='UPLOADED within 24 hours' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name)); 
                    POCountList = setpo.getResultSize();
                }
            }
            
        }else{ 
            for(ListView View: ListViews){ 
                ListViewOptions.add(new SelectOption(View.id,View.Name));   
                POCountList = setpo.getResultSize();
            }
        }
        return ListViewOptions;
        
    }
    public PageReference resetFilter()
    {
        setPO = null;
        setPO.setPageNumber(1);
        return null;
    }
    
    public void doNext(){        
        setPO.Next();
        
    }
    
    public void doPrevious(){        
        setPO.Previous();
        
    }
    
    public void doFirst(){        
        setPO.First();
        
    }
    
    public void doLast(){        
        setPO.Last();
        
    }
    public Boolean getHasPrevious(){             
        return setPO.getHasPrevious(); 
    }
    
    public Boolean getHasNext(){         
        return setPO.getHasNext();    
    }
    
    /*public string delid {get; set;}
public void deletePO(){
polist = [Select id,Name from Production_Order__c where id =:delid];
if(polist.size() > 0 || polist[0].Id != ''){
delete polist;
}
} */
    
    public pagereference refresh() {
        setPO = null;
        getAllPOrders();
        sortingChoice='None';
        //size= 20; 
        
        //setFiles.setPageNumber(1);
        
        return null;
    }
    
    public pagereference MyDirectories() {
        pagereference pg = page.EPMS_MyDirectory;
        pg.setRedirect(True);
        return pg;
    }
    
    //wrapper class
    public class WrapperClass{
        public Boolean chkBox {get; set;}
        public Production_Order__c prOrd {get; set;}
        
        public WrapperClass(Production_Order__c prOrd){
            this.prOrd = prOrd;
            this.chkBox = false;
            
        }
    }
}