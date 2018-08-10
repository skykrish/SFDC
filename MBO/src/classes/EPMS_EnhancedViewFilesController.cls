/****************************************************************************************************************/
/* Class Name           :  EPMS_EnhancedViewFilesController                                                       */
/*  Created Date        :  20/12/2017                                                                             */
/* Description          :  Responsive "row" [vertical height] based on height of text field in all PO list view   */
/* Version              : 1.0                                                                                     */
/*****************************************************************************************************************/
public with sharing class EPMS_EnhancedViewFilesController {
    
    public String FilesFilterId {get; set;}
    public Integer Size {get; set;}
    //public List<Files__c> Fileslist {get; set;}
    public List<WrapperClass> wrapList {get;set;}
    // public Boolean ErrorFlag {get; set;}
    public string recordid{get;set;}
    public Set<Id> selectedFileIds;
    //public String contextItem{get;set;} 
    public Integer noOfRecords{get; set;}
    public Integer setUserChoice { get; set; }
    private Integer CountTotalRecords = 0;
    public Long noOfPages {get; set;}
    public Boolean selectedAllProperties {get;set;}
    public List<ListView> ListViews{get;set;}
    public List<SelectOption> ListViewOptions{get;set;}
    public List<ListView> ListViewOfFilterId{get;set;}
    public String sortByStatus{get;set;}
    Public ListView TLInchargeId{get;set;}
    
    //Sorting 
    public String sortingChoice {get; set;}
    public String sortType {get;set;}
    public List<SelectOption> sortingoptions {get;set;}
    public List<SelectOption> sortingTypeoptions {get;set;}
    public string baseQuery {get; set;}
    //public List<Files__c> ListFiles {get; set;}
    public Integer FileCountList {get; set;}
    
    
    public ApexPages.StandardSetController setFiles {
        get{
            if(setFiles == null){
                baseQuery = 'select name,FileTAT__c,Files_To_open__c,File_Location__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,QCIncharge__c,QC_Check_PO__c,TLInCharge__c,Status__c,File_HandOver_Instructions__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c,Production_Order_Name__c,createddate,Production_Order__r.Production_Order_TAT__c from Files__c order by Createddate limit 10000';
                setFiles = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                setFiles.setpageNumber(1);
                setFiles.setPageSize(Size);
                noOfRecords = setFiles.getResultSize();
                if(FilesFilterId != null) {
                    setFiles.setFilterId(FilesFilterId);
                } else {                    
                    Id profileId=userinfo.getProfileId();
                    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                    if(profileName=='Team Leader'){
                        TLInchargeId=new ListView();
                        TLInchargeId=[select id,name from listview where sobjecttype='Files__c' AND Name='TL Incharge' Limit 1];
                        FilesFilterId=TLInchargeId.id;
                        setFiles.setFilterId(FilesFilterId);
                    } else if(profileName=='Quality Control'){
                        TLInchargeId=new ListView();
                        TLInchargeId=[select id,name from listview where sobjecttype='Files__c' AND Name='QC Incharge' Limit 1];
                        FilesFilterId=TLInchargeId.id;
                        setFiles.setFilterId(FilesFilterId);
                    } else if(profileName==Label.EPMS_MEMBER_DESIG_OPERATOR_PS){
                        TLInchargeId=new ListView();
                        TLInchargeId=[select id,name from listview where sobjecttype='Files__c' AND Name='My Files' Limit 1];
                        FilesFilterId=TLInchargeId.id;
                        setFiles.setFilterId(FilesFilterId);                   
                    } else  if(profileName=='Country Administrator'||profileName=='Shift Administrator' ||profileName=='System Administrator'||profileName=='Assignor') {                        
                        TLInchargeId=new ListView();
                        TLInchargeId=[select id,name from listview where sobjecttype='Files__c' AND Name='All Files' Limit 1];
                        FilesFilterId=TLInchargeId.id;
                        setFiles.setFilterId(FilesFilterId);                   
                    }
                }
                
            }
            return setFiles;
        }
        set;
    }
    
    public EPMS_EnhancedViewFilesController() {
        
        wrapList = new List<WrapperClass>(); 
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
        
        ListViewOfFilterId =new List<ListView>();
        ListViewOfFilterId=[select id,Name from ListView where id=:FilesFilterId limit 1];
        if(ListViewOfFilterId.size()>0){
            sortByStatus=ListViewOfFilterId[0].Name;     
        }
        
        if(sortingChoice==null){
            sortingChoice='None';
        }
        if(sortType==null){
            sortType='ASC';
        }
        
        if(sortByStatus== 'All Files' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c IN ('New','Estimation Request','QC','QCIP','Redo','Redo Re-Assigned','WIP') and File_Type__c='Image' and createddate >= LAST_N_DAYS:60) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }  else if(sortByStatus== 'All Files' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c IN ('New','Estimation Request','QC','QCIP','Redo','Redo Re-Assigned','WIP') and File_Type__c='Image' and createddate >= LAST_N_DAYS:60) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        } else if(sortByStatus== 'All Files' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c IN ('New','Estimation Request','QC','QCIP','Redo','Redo Re-Assigned','WIP') And File_Type__c='Image' and createddate >= LAST_N_DAYS:60) Order by Status__c limit 10000]));                
            size=20;
        } else if(sortByStatus== 'All Files' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c IN ('New','Estimation Request','QC','QCIP','Redo','Redo Re-Assigned','WIP') and File_Type__c='Image' and createddate >= LAST_N_DAYS:60) Order by Status__c DESC limit 10000]));                
            size=20;
        } else if(sortByStatus== 'Approved Files' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Approved' AND File_Type__c='Image' AND createddate <= LAST_N_DAYS:10) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Approved Files' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Approved' AND File_Type__c='Image' AND createddate <= LAST_N_DAYS:10) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Approved Files' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Approved' AND File_Type__c='Image' AND createddate <= LAST_N_DAYS:10) Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Approved Files' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Approved' AND File_Type__c='Image' AND createddate <= LAST_N_DAYS:10) Order by Status__c DESC limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Assigned' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        } else if(sortByStatus== 'Assigned' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        } else  if(sortByStatus== 'Assigned' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by Status__c limit 10000]));                
            size=20;
        } else if(sortByStatus== 'Assigned' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Assigned' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by Status__c DESC limit 10000]));                
            size=20;
        } else if(sortByStatus== 'Awaiting Approval' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Awaiting Approval' AND File_Type__c='Image' AND Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)')) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Awaiting Approval' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Awaiting Approval' AND File_Type__c='Image' AND Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)')) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Awaiting Approval' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Awaiting Approval' AND File_Type__c='Image' AND Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)')) Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Awaiting Approval' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Status__c='Awaiting Approval' AND File_Type__c='Image' AND Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)')) Order by Status__c DESC limit 10000]));                
            size=20;
        } else  if(sortByStatus== 'Estimation Request' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimation Request' and File_Type__c='Image' and Estimation_User__c=True) OR (Status__c='Estimation Request' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by FileTAT__c ASC NULLS LAST limit 10000]));            
            size=20;
        } else if(sortByStatus== 'Estimation Request' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimation Request' and File_Type__c='Image' and Estimation_User__c=True) OR (Status__c='Estimation Request' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by FileTAT__c DESC NULLS LAST limit 10000]));            
            size=20;
        } else if(sortByStatus== 'Estimation Request' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimation Request' and File_Type__c='Image' and Estimation_User__c=True) OR (Status__c='Estimation Request' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by Status__c limit 10000]));            
            size=20;
        } else if(sortByStatus== 'Estimation Request' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimation Request' and File_Type__c='Image' and Estimation_User__c=True) OR (Status__c='Estimation Request' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者','Full-time Employees (Japan)'))) order by Status__c DESC limit 10000]));            
            size=20;
        } else if(sortByStatus== 'Estimator Assigned' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimator Assigned' and File_Type__c='Image' and Current_Estimator__c='True') OR (Status__c='Estimator Assigned' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者'))) order by FileTAT__c ASC NULLS LAST limit 10000]));            
            size=20;
        } else if(sortByStatus== 'Estimator Assigned' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimator Assigned' and File_Type__c='Image' and Current_Estimator__c='True') OR (Status__c='Estimator Assigned' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者'))) order by FileTAT__c DESC NULLS LAST limit 10000]));            
            size=20;
        } else if(sortByStatus== 'Estimator Assigned' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimator Assigned' and File_Type__c='Image' and Current_Estimator__c='True') OR (Status__c='Estimator Assigned' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者'))) order by Status__c limit 10000]));            
            size=20;
        } else if(sortByStatus== 'Estimator Assigned' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Estimator Assigned' and File_Type__c='Image' and Current_Estimator__c='True') OR (Status__c='Estimator Assigned' and File_Type__c='Image' and Current_User_Profile__c IN('System Administrator','システム管理者'))) order by Status__c DESC limit 10000]));            
            size=20;
        } else  if(sortByStatus== 'Handover' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }  else  if(sortByStatus== 'Handover' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        }  else  if(sortByStatus== 'Handover' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by Status__c limit 10000]));                
            size=20;
        }  else  if(sortByStatus== 'Handover' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Handover' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by Status__c DESC limit 10000]));                
            size=20;
        } else if(sortByStatus== 'My Files' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (current_user__c='True' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image') Order by FileTAT__c ASC NULLS LAST limit 10000]));           
            size=20;
        } else if(sortByStatus== 'My Files' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (current_user__c='True' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image') Order by FileTAT__c DESC NULLS LAST  limit 10000]));            
            size=20;
        } else  if(sortByStatus== 'My Files' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (current_user__c='True' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image') Order by Status__c limit 10000]));            
            size=20;
        } else if(sortByStatus== 'My Files' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (current_user__c='True' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image') Order by Status__c DESC limit 10000]));            
            size=20;
        } else if(sortByStatus== 'My Files - QC' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c IN ('Assigned','WIP') AND current_user__c='True' AND Current_User_Profile__c='Quality Control') OR (Status__c IN ('Assigned','WIP') AND Current_User_Profile__c='Quality Control')) order by FileTAT__c ASC NULLS LAST limit 10000]));            
            size=20;
        }else if(sortByStatus== 'My Files - QC' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c IN ('Assigned','WIP') AND current_user__c='True' AND Current_User_Profile__c='Quality Control') OR (Status__c IN ('Assigned','WIP') AND Current_User_Profile__c='Quality Control')) order by FileTAT__c DESC NULLS LAST  limit 10000]));            
            size=20;
        } else if(sortByStatus== 'My Files - QC' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c IN ('Assigned','WIP') AND current_user__c='True' AND Current_User_Profile__c='Quality Control') OR (Status__c IN ('Assigned','WIP') AND Current_User_Profile__c='Quality Control')) order by Status__c limit 10000]));            
            size=20;
        } else if(sortByStatus== 'My Files - QC' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c IN ('Assigned','WIP') AND current_user__c='True' AND Current_User_Profile__c='Quality Control') OR (Status__c IN ('Assigned','WIP') AND Current_User_Profile__c='Quality Control')) order by Status__c DESC limit 10000]));            
            size=20;
        } else if(sortByStatus== 'My Files - SA' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Shift Administrator' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'My Files - SA' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Shift Administrator' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by FileTAT__c DESC NULLS LAST  limit 10000]));                
            size=20;
        }  else if(sortByStatus== 'My Files - SA' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Shift Administrator' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'My Files - SA' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Shift Administrator' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by Status__c DESC limit 10000]));                
            size=20;
        }else if(sortByStatus== 'My Files - TL' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'My Files - TL' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'My Files - TL' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'My Files - TL' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((current_user__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('Assigned','WIP') AND File_Type__c='Image')) Order by Status__c DESC limit 10000]));                
            size=20;
        }else if(sortByStatus== 'New' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Country Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c=:Label.EPMS_MEMBER_DESIG_OPERATOR_PS)) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'New' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Country Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c=:Label.EPMS_MEMBER_DESIG_OPERATOR_PS)) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'New' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Country Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c=:Label.EPMS_MEMBER_DESIG_OPERATOR_PS)) Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'New' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c='Country Administrator') OR (File_Type__c='Image' AND Status__c='New' AND Current_User_Profile__c=:Label.EPMS_MEMBER_DESIG_OPERATOR_PS)) Order by Status__c DESC limit 10000]));                
            size=20;
        } else if(sortByStatus== 'QC Incharge' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Quality_Checker__c='True' AND Status__c='QC' AND File_Type__c='Image') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR  (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) order by FileTAT__c ASC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus== 'QC Incharge' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Quality_Checker__c='True' AND Status__c='QC' AND File_Type__c='Image') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR  (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) order by FileTAT__c DESC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus== 'QC Incharge' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Quality_Checker__c='True' AND Status__c='QC' AND File_Type__c='Image') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR  (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) order by Status__c limit 10000]));
            size=20;
        } else if(sortByStatus== 'QC Incharge' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Quality_Checker__c='True' AND Status__c='QC' AND File_Type__c='Image') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR  (Status__c='QC' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) order by Status__c DESC limit 10000]));
            size=20;
        }else if(sortByStatus== 'QC Incharge Handover' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QC_Check_PO__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Quality_Checker__c='True' AND QC_Check_PO__c='False' AND Status__c ='QC') Order by FileTAT__c ASC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus== 'QC Incharge Handover' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QC_Check_PO__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Quality_Checker__c='True' AND QC_Check_PO__c='False' AND Status__c ='QC') Order by FileTAT__c DESC NULLS LAST limit 10000]));
            size=20;
        } else if(sortByStatus== 'QC Incharge Handover' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QC_Check_PO__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Quality_Checker__c='True' AND QC_Check_PO__c='False' AND Status__c ='QC') Order by Status__c limit 10000]));
            size=20;
        } else if(sortByStatus== 'QC Incharge Handover' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QC_Check_PO__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,QC_Comments__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Quality_Checker__c='True' AND QC_Check_PO__c='False' AND Status__c ='QC') order by Status__c DESC limit 10000]));
            size=20;
        }  else if(sortByStatus== 'Redo' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Redo' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        } else if(sortByStatus== 'Redo' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'Redo' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Production Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Shift Administrator') OR (Status__c='Redo' AND File_Type__c='Image' AND Current_User_Profile__c='Country Administrator')) Order by Status__c DESC limit 10000]));                
            size=20;
        }else if(sortByStatus== 'TL Incharge' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Team_Leader__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('New','WIP','Redo','Assigned','Handover') AND File_Type__c='Image') Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'TL Incharge' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Team_Leader__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('New','WIP','Redo','Assigned','Handover') AND File_Type__c='Image') Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'TL Incharge' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Team_Leader__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('New','WIP','Redo','Assigned','Handover') AND File_Type__c='Image') Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'TL Incharge' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where (Team_Leader__c='True' AND Current_User_Profile__c='Team Leader' AND Status__c IN ('New','WIP','Redo','Assigned','Handover') AND File_Type__c='Image') Order by Status__c DESC limit 10000]));                
            size=20;
        }else if(sortByStatus== 'WIP' && sortType == 'ASC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c ASC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'WIP' && sortType == 'DESC' && sortingChoice == 'TAT'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Country Administrator')) Order by FileTAT__c DESC NULLS LAST limit 10000]));                
            size=20;
        }else if(sortByStatus== 'WIP' && sortType == 'ASC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Country Administrator')) Order by Status__c limit 10000]));                
            size=20;
        }else if(sortByStatus== 'WIP' && sortType == 'DESC' && sortingChoice == 'STATUS'){
            setFiles = new ApexPages.StandardSetController(Database.getQueryLocator([select name,File_Location__c,FileTAT__c,Status__c,QCIncharge__c,TLInCharge__c,FTP_Upload_Status__c,File_HandOver_Instructions__c,FTP_Upload_Time__c,Job_List__c,Instruction__c,Order_Attachments__c,QC_Comments__c,Files_To_open__c,File_Category_Code__c,Actual_Time_HH_MM_SS__c,Delivery_Extension__c,File_Auto_Number__c,File_Attachments__c,Order_Instructions__c,Thumbnail_Display__c,File_Thumbnail_URL__c,Member__c, Production_Order_Name__c, createddate from Files__c where ((File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Team Leader' AND Team_Leader__c='True') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Production Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Shift Administrator') OR (File_Type__c='Image' AND Status__c='WIP' AND Current_User_Profile__c='Country Administrator')) Order by Status__c DESC limit 10000]));                
            size=20;
        }      
    }
    
    public SelectOption[] getFilesExistingViews(){
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        ListViews=new list<ListView>();
        
        ListViews=[select id,name from listview where sobjecttype='Files__c' order by name Asc];
        ListViewOptions = new List<SelectOption>();
        
        if(profileName=='Country Administrator') {
            for(ListView View: ListViews){ 
                
                if(View.Name=='All Files'||View.Name=='Approved Files'||View.Name=='Assigned'|| View.Name=='Handover' || View.Name=='New' || View.Name=='Estimator Assigned' || View.Name=='QC Incharge' || View.Name=='Redo' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));   
                    FileCountList = setFiles.getResultSize();
                }
            }
        } else if(profileName==Label.EPMS_MEMBER_DESIG_OPERATOR_PS ) {
            for(ListView View: ListViews){ 
                
                if(View.Name=='My Files'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name)); 
                    FileCountList = setFiles.getResultSize();
                }
            }
        }  else if(profileName=='Assignor') {
            for(ListView View: ListViews){ 
                
                if(View.Name=='All Files'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));  
                    FileCountList = setFiles.getResultSize();
                }
            }
        } else if(profileName=='Quality Control') {
            for(ListView View: ListViews){ 
                
                if(View.Name =='Estimation Request' || View.Name=='Awaiting Approval' ||View.Name =='Estimator Assigned' || View.Name=='My Files - QC' ||View.Name=='QC Incharge' ||View.Name=='QC Incharge Handover'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));  
                    FileCountList = setFiles.getResultSize();
                }
            }
        } else if(profileName=='Shift Administrator' ) {
            for(ListView View: ListViews){ 
                
                if(View.Name=='All Files'||View.Name=='Assigned'||View.Name=='Handover' || View.Name=='My Files - SA' ||View.Name=='New' ||View.Name=='QC Incharge' ||View.Name=='Redo' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));  
                    FileCountList = setFiles.getResultSize();
                }
            }
        }  else if(profileName=='Team Leader' ) {
            for(ListView View: ListViews){ 
                
                if(View.Name=='Assigned'||View.Name=='Handover' ||View.Name=='My Files - TL' ||View.Name=='New' ||View.Name=='Redo' ||View.Name=='TL Incharge' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name)); 
                    FileCountList = setFiles.getResultSize();
                }
            }
        }else if(profileName=='Production Administrator'){
            for(ListView View: ListViews){ 
                if(View.Name=='All Files'||View.Name=='Assigned'|| View.Name=='Handover' || View.Name=='New' || View.Name=='QC Incharge' || View.Name=='Redo' || View.Name=='WIP'){
                    ListViewOptions.add(new SelectOption(View.id,View.Name));   
                    FileCountList = setFiles.getResultSize();
                }
            }
            
        }else{ 
            for(ListView View: ListViews){ 
                ListViewOptions.add(new SelectOption(View.id,View.Name)); 
                FileCountList = setFiles.getResultSize();
            }
        }
        
        return ListViewOptions;
    }  
    public PageReference refreshPageS() {
        setFiles.setPageSize(size);
        return null;
    }
    
    public void isSelectedAll() {
        for (sObject record : setFiles.getRecords()){
            Files__c f = (Files__c) record;
            if(selectedAllProperties){
                this.selectedFileIds.add(f.id);
            }else{
                this.selectedFileIds.remove(f.id);
            }
        }
    }
    public Integer getSelectedCount() {
        return this.selectedFileIds.size();
    } 
    
    public Integer pageNumber {
        get {
            return setFiles.getPageNumber();
        }
        set;
    }
    
    public List<WrapperClass> getAllFiles() {
        try{
            wrapList =  new List<WrapperClass>();
            for(Files__c ff : (List<Files__c>) setFiles.getRecords()){
                wrapList.add(new WrapperClass(ff));
            }
            
        }catch(Exception e){
            
        }
        return wrapList;
    }
    
    public PageReference resetFilter()
    {
        setFiles = null;
        setFiles.setPageNumber(1);
        return null;
    }
    
    public void doNext(){        
        setFiles.Next();
        
    }
    
    public pagereference refresh() {
        setFiles = null;
        getAllFiles();
        sortingChoice='None';
        //size=20;
        //setFiles.setPageNumber(1); 
        return null;
    }
    
    public Boolean getHasPrevious(){             
        return setFiles.getHasPrevious(); 
    }
    
    public Boolean getHasNext(){         
        return setFiles.getHasNext();    
    }
    
    public void doPrevious(){        
        setFiles.Previous();
        
    }
    
    public void doFirst(){        
        setFiles.First();
        
    }
    
    public void doLast(){        
        setFiles.Last();
        
    }
    /*public string delid {get; set;}
public void deleteFiles(){
Fileslist = [Select id,Name from Files__c where id =:delid];
if(Fileslist.size() > 0 || Fileslist[0].Id != ''){
delete Fileslist;
}
} */
    
    //wrapper class
    public class WrapperClass {
        public Boolean chkBox {get; set;}
        public Files__c Files {get; set;}
        
        public WrapperClass(Files__c Files){
            this.Files = Files;
            this.chkBox = false;            
        }
    }
}