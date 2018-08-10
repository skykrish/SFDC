/***************************************************************************
*   Class               :       PO View Directory Query Locator             *
*   Created Date        :       22/01/2015                                  *           
*   Description         :       To return the requested Result              *
*                               based on the request by service class       *
*                               will be used as the Common Class            *

/***************************************************************************/

public with sharing class EPMS_POViewDirectory_QueryLocator {
    
    public Production_Order__c productionOrderList = null;
    
    public set<string> filesTitle=new set<String>();
    public list<Files__c> fileListfilter=new list<Files__c>();
    public map<id,files__c> fileMap=new map<id,files__c>();
    public List<Files__c> fileList = null;
    public List<Files__c> fileStatusList = null;
    public List<Files__c> fileToOpenList = null;
    transient  public List<Files__c> relatedfileList = null;
    public List<AggregateResult> fileCategoryCountForOrder = null;
    public List<File_Categories__c> fileCategoryInfo = null;
    public Production_Order__c productionOrderIncharge = null;
    public List<Files__c> relatedfileInstructionList = null;
    public List<Shift_Assignments__c> memberAssignedShift = null;
    public List<Member__c> memberInfo = null;
    public List<Production_Order__c> productionOrderTLIncharge = null;
    public List<Member__c> memberTeamInfo = null;
    public List<Team__c> teamNameListForQC= null;
    public List<Member__c> memberQCInTeam = null;
    public List<Production_Order__c> productionOrderQCIncharge = null;
    public List<Files__c> relatedOpenFileTypeList = null;
    public List<Files__c> relatedFileRecordsList = null;
    public List<Files__c> relatedFileRecordsListInfo = null;
    public List<Files__c> relatedOpenFileRecordsListInfo = null;
    public List<Member__c> memberDesignationList = null;
    public Integer CountTotalRecords = 0;
    public boolean Status;
    public boolean Catg;
    public boolean Title;
    
    public List<Files__c> getChildFilesRecordsInfo(List<id> FileIDsList){
        
        List<Files__c> relatedFileRecordsListInfo = new List<Files__c>();
        if(FileIDsList != null && FileIDsList.size() > 0){
            relatedFileRecordsListInfo = [select Id, Name, Instruction__c, Files_To_open__c, File_Type__c from Files__c where Parent_Id__c IN :FileIDsList];
        }
        return relatedFileRecordsListInfo;
    }
    
    // To Get Files Based On Status,Catagory and Job Title based on CR-508 ---->modified by Udayasri
    
    public list<files__c> getFilesRelatedToProductionOrder(String orderID,Integer QueryLimit,Integer OffsetSize, String sortChoice, String sortCatg,String sortTitle,String sortingChoice,String sortType)
    {
        
        system.debug('----sortingChoice---'+sortingChoice);
        system.debug('Current Time QL Method Entry 1 : ' + system.now());
        
        
        if(sortingChoice == null){
            sortingChoice = 'Name';
        }
        if(sortType == null){
            sortType = 'ASC';
        }
        
        system.debug('Current Time QL unWantedFileList 1 : ' + system.now());
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id,Status__c from Files__c where Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        system.debug('Current Time QL unWantedFileList 2 : ' + system.now());
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        
        
        
        if(OrderId!=null){
            system.debug('Current Time QL fileList 1 : ' + system.now());
            fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                        File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                        Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ]; 
            system.debug('Current Time QL fileList 2 : ' + system.now());
            if(sortTitle=='None' && sortCatg=='None' && sortChoice=='None'){
                
                system.debug('---None Block----');
                
                
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        
                        fileList=new list<Files__c>();
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        fileList=new list<Files__c>();
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){  
                        fileList=new list<Files__c>();
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){ 
                        fileList=new list<Files__c>();               
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice =='Category' & orderID != null && sortType == 'ASC'){ 
                        fileList=new list<Files__c>();
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice =='Category' & orderID != null && sortType == 'DESC'){ 
                        fileList=new list<Files__c>();
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                }
                
                if(orderID != null){
                    if(sortType == 'ASC'){
                        system.debug('Current Time QL 1 : ' + system.now());
                        fileList=new list<Files__c>();
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        system.debug('Current Time QL 2 : ' + system.now());                                    
                        return fileList;
                    }
                    else{
                        system.debug('Current Time QL 3 : ' + system.now()); 
                        fileList=new list<Files__c>();
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds) Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                                    system.debug('Current Time QL 4 : ' + system.now());   
                        return fileList;
                    }
                }
            }

            if(sortTitle!='None' && sortCatg=='None' && sortChoice=='None'){
                fileList=new list<Files__c>();
                String w='%'+','+sortTitle+','+'%';
                String x='%'+','+sortTitle+'%';
                String y='%'+sortTitle+','+'%';
                String z='%'+sortTitle+'%';
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c ASC NULLS LAST   ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c DESC NULLS LAST   ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){ 
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name ASC NULLS LAST   ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){ 
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name DESC NULLS LAST   ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name ASC NULLS LAST   ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name DESC NULLS LAST   ];
                        return fileList;
                    }
                }
                fileList = new List<Files__c>();
                if(orderID != null){
                    if(sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name ASC NULLS LAST   ];
                        return fileList;
                    }
                    else{
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name DESC NULLS LAST   ];
                        return fileList;
                    }
                }
            }
            
            
            
            
            if(sortTitle!='None' && sortCatg=='None' && sortChoice!='None'){
                fileList=new list<Files__c>();
                String w='%'+','+sortTitle+','+'%';
                String x='%'+','+sortTitle+'%';
                String y='%'+sortTitle+','+'%';
                String z='%'+sortTitle+'%';
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){                
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){                
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){     
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'DESC'){     
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                }
                
                if(orderID != null){
                    if(sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else{
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                }
            }
            
            
            
            
            if(sortTitle!='None' && sortCatg!='None' && sortChoice=='None'){
                String w='%'+','+sortTitle+','+'%';
                String x='%'+','+sortTitle+'%';
                String y='%'+sortTitle+','+'%';
                String z='%'+sortTitle+'%';
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'DESC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                }
                if(orderID != null){
                    if(sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                    else{
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return FileList;
                    }
                }
            }
            
            
            
            if(sortTitle!='None' && sortCatg!='None' && sortChoice!='None'){
                String w='%'+','+sortTitle+','+'%';
                String x='%'+','+sortTitle+'%';
                String y='%'+sortTitle+','+'%';
                String z='%'+sortTitle+'%';
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;   
                    }
                    
                    else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;   
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;   
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;   
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;   
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;   
                    }
                }
                if(orderID != null){
                    if(sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;   
                    }
                    else{ fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                      File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                      Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z)) Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                         return fileList;   
                        }
                }
            }
            
            
            if(sortTitle=='None' && sortCatg!='None' && sortChoice!='None'){
                
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){  
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){  
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'DESC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                }
                if(orderID != null){
                    if(sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else{
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                }
            }
            
            if(sortTitle=='None' && sortCatg=='None' && sortChoice!='None'){
                
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    
                    
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){ 
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    } 
                }
                if(orderID != null){
                    if(sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    } 
                    else{fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                     File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                     Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds) Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                         return fileList;
                        } 
                }
            }
            
            
            
            if(sortTitle=='None' && sortCatg!='None' && sortChoice=='None'){
                
                if(sortingChoice != null && sortingChoice != 'Name'){
                    
                    
                    if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){  
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    else if(sortingChoice == 'Category' & orderID != null && sortType == 'DESC'){  
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                    
                }
                
                fileList = new List<Files__c>();
                if(orderID != null){
                    if(sortType == 'ASC'){
                        
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    } else {
                        fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                    File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                                    Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds) Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                        return fileList;
                    }
                }
            }
            
        }
        
        system.debug('Current Time QL Method Exit 2 : ' + system.now()); 
        
        return fileList;
    }
    
    
    
    
    //To clear all the Previous data when sortCatg,sortTitle,sortChoice changes its values based on CR-508 --->Modified by Udayasri
    
    public void refresh(){
        fileListFilter.clear();
        fileList.clear();
        fileMap.clear();
        fileListfilter.clear();
        
    }
    
    
    //To get count of total number of files in files object with the sortchoice,sortcatg,sorttitle values based on CR-508--->Modified by Udayasri
    
    public Integer getFilesRelatedToProductionOrderCount(String orderID,String sortChoice,String sortCatg,String sortTitle)
    {
        
        Set<Id> unWantedFileIds = new Set<Id>();
        String w='%'+','+sortTitle+','+'%';
        String x='%'+','+sortTitle+'%';
        String y='%'+sortTitle+','+'%';
        String z='%'+sortTitle+'%';
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        
        if(sortCatg!='None' && sortTitle!='None' && sortChoice!='None'){ 
            CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z) AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
        }
        else if(sortCatg=='None' && sortTitle!='None' && sortChoice!='None'){
             CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z) AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
            
        }
        else if(sortCatg!='None' && sortTitle=='None' && sortChoice!='None'){
             CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
            
        }
        else if(sortCatg!='None' && sortTitle!='None' && sortChoice=='None'){
             CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z) AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
            
        }
        else if(sortCatg=='None' && sortTitle=='None' && sortChoice!='None'){
            CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Status__c=:sortChoice AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
            
        }
        else if(sortCatg=='None' && sortTitle!='None' && sortChoice=='None'){
             CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND (File_Job_Titles__c like :x OR File_Job_Titles__c like :y OR File_Job_Titles__c like :z) AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
            
        }
        else if(sortCatg!='None' && sortTitle=='None' && sortChoice=='None'){ 
             CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND File_Category_Code__r.Name=:sortCatg AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
        }
        else{
            CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds ];
            return CountTotalRecords;
        }
        
    }   
    
    public List<Files__c> getFilesRelatedToProductionOrder(String orderID,Integer QueryLimit,Integer OffsetSize, String sortingChoice, String sortType){
        
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        if(sortType == null){
            sortType = 'ASC';
        }
        
        
        if(sortingChoice != null && sortingChoice != 'Name'){
            if(sortingChoice == 'Status' & orderID != null && sortType == 'ASC'){
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                return fileList;
                
            } else if(sortingChoice == 'Status' & orderID != null && sortType == 'DESC'){
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            } else if(sortingChoice == 'Operator' & orderID != null && sortType == 'ASC'){                
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c from Files__c where (File_Type__c =:label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            } else if(sortingChoice == 'Operator' & orderID != null && sortType == 'DESC'){                
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            } else if(sortingChoice == 'Category' & orderID != null && sortType == 'ASC'){                
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            } else if(sortingChoice == 'File Category' & orderID != null && sortType == 'DESC'){
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            }
            
            
            /* Added filter to get the records in ASC and DESC order based on Job Titles for the issue number 508 */
            
            else if(sortingChoice == 'Job Title' & orderID != null && sortType == 'ASC'){                
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Job_List__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            } else if(sortingChoice == 'Job Title' & orderID != null && sortType == 'DESC'){
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Job_List__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            }
        } 
        String userSortChoice = 'Name';
        
        fileList = new List<Files__c>();
        if(orderID != null){
            if(sortType == 'ASC'){
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Name ASC NULLS FIRST limit :QueryLimit offset :OffsetSize ];
                
            } else {
                
                fileList = [Select id, Name, Individual_time__c, Files_To_open__c,Job_Type__c, Member_Shift__c, File_Shift__c, File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Name DESC NULLS FIRST limit :QueryLimit offset :OffsetSize ];
                
            }
            
        }
        return fileList;
    }   
    
    
    public Production_Order__c getProdOrderDetails(String orderID){
        
        productionOrderList = new Production_Order__c();
        try{
            if(orderID != null){
                productionOrderList = [SELECT Id,Name, Production_Order_TAT__c,Mbo_Location__c,User__c  FROM Production_Order__c where Id = : orderID limit 1];
                
            } 
        } catch(exception e){
            
        }
        
        return productionOrderList;
    }
    
    public List<Files__c> getFilesRelatedToProductionOrder(String orderID,Integer QueryLimit,Integer OffsetSize, String sortChoice){
        
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        
        
        if(sortChoice != null && sortChoice != 'Name'){
            if(sortChoice == 'Status' & orderID != null){                
                
                fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            } else {                
                
                fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            }
        } 
        String userSortChoice = 'Name';
        
        fileList = new List<Files__c>();
        if(orderID != null){
            fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                        File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                        Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID  AND Id NOT IN : unWantedFileIds) Order By Name limit :QueryLimit offset :OffsetSize ];
        }
        
        return fileList;
    }   
    
    public List<Files__c> getFilesRelatedToProductionOrderWithoutPage(String orderID){
        
        
        fileList = new List<Files__c>();
        if(orderID != null){
            fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c,Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c, Instruction__c, QC_Comments__c,
                        File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                        Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID ]; 
            
        }
        
        return fileList;
    }
    
    
    public List<Files__c> getFilesStatusList(List<Files__c> filePopList){
        
        fileStatusList = new List<Files__c>();
        if(filePopList != null && filePopList.size() > 0){
            fileStatusList = [SELECT id,File_Type__c,Status__c,FTP_Upload_Status__c, Files_To_open__c FROM Files__c where Id = : filePopList];
        }
        return fileStatusList;
    }   
    
    
    public List<Files__c> getFilesToOpenList(List<Id> fileIds){
        
        fileToOpenList = new List<Files__c>();
        if(fileIds != null && fileIds.size() > 0){
            fileToOpenList = [select Id,Files_To_open__c from Files__c where id IN :fileIds];
        }
        return fileToOpenList;
    }   
    
    public List<Files__c> getFilesListRelatedToProductionOrder(String orderID){
        
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;
        system.debug('Profile Name : ' + proflieName);
        if(UserId != null && !(proflieName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME || proflieName ==EPMS_UTIL.EPMS_COUNTRYADMIN_PROFILE_NAME || proflieName =='Full-time Employees (Japan)' || proflieName == 'システム管理者' || proflieName == 'Contract Employees (Japan)' || proflieName == 'Permanent Employees (Japan)' || proflieName == 'Part-time Employees (Japan)')){
            system.debug('--------------------------------'+(UserId != null && !(proflieName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME || proflieName ==EPMS_UTIL.EPMS_COUNTRYADMIN_PROFILE_NAME  || proflieName == 'システム管理者')));
            system.debug('entered for  other profile than SA: ' + proflieName);
            member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
            
        }
        
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        
        relatedfileList = new List<Files__c>();
        if(orderID != null){
            relatedfileList = [SELECT id,File_Type__c,Name,File_Auto_Number__c,Status__c,Parent_Id__c,Splitted_Parent_id__c,Parent_Id__r.Instruction__c, Production_Order__c FROM Files__c where Production_Order__c = :orderID  AND Id NOT IN : unWantedFileIds Order by File_Auto_Number__c ]; // Order by File_Auto_Number__c, Name, , Name ,Parent_Id__c //   
        }
        
        return relatedfileList;
    }   
    
    
    public List<AggregateResult> getFilesCategoryCount(String orderID){
        
        fileCategoryCountForOrder = new List<AggregateResult>();
        if(orderID != null){
            fileCategoryCountForOrder = [select Count(File_Category_Code__r.Name) total, File_Category_Code__c fileCode,Production_order__c from files__c where Production_Order__c = :orderId group by Production_order__c, File_Category_Code__c];
        }   
        return fileCategoryCountForOrder;
    }
    
    public List<File_Categories__c> getFilesCategoryInfo(List<Id> Ids){
        
        fileCategoryInfo = new List<File_Categories__c>();
        if(Ids != null && Ids.size() > 0){
            fileCategoryInfo = [select Name from File_Categories__c where id IN : Ids];
        }   
        return fileCategoryInfo;
    }
    
    public Production_Order__c getProductionOrderInchargeDetails(String orderID){
        
        productionOrderIncharge = new Production_Order__c();
        if(orderID != null){
            productionOrderIncharge = [select id, name, QC_Incharge__r.Name, TL_Incharge__r.Name from Production_Order__c where id = : orderId];
        }
        return productionOrderIncharge;
    } 
    
    public List<Files__c> getFilesInstructionList(List<Id> FileIDsList){
        
        relatedfileInstructionList = new List<Files__c>();
        if(FileIDsList != null && FileIDsList.size() > 0){
            relatedfileInstructionList = [select Files_To_open__c,Parent_Id__c,Parent_Id__r.Instruction__c,Instruction__c, File_Type__c from Files__c where id IN :FileIDsList];
        }
        return relatedfileInstructionList;
    }
    
    public List<Shift_Assignments__c> getMemberAssignedInShift(Id selShift){
        
        memberAssignedShift = new List<Shift_Assignments__c>();
        if(selShift != null){
            memberAssignedShift = [select Name,Member__c from Shift_Assignments__c where Shift_Code__c = : selShift AND Shift_Assigned__c = true AND ToTime__c=NULL];
        }
        return memberAssignedShift;
    }
    
    public List<Member__c> getMemberLocationDetails(Id selTeam){
        
        memberInfo = new List<Member__c>();
        if(selTeam != null){
            memberInfo = [select Name,id,Location_id__c from Member__c where Team_id__c =:selTeam and Designation__c='Team Leader' AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
        }
        return memberInfo;
    }   
    
    public List<Production_Order__c> getProductionOrderTLInchargeDetails(String orderID){
        
        productionOrderTLIncharge = new List<Production_Order__c>();
        if(orderID != null){
            productionOrderTLIncharge = [select id, Name, TL_InCharge__c from Production_order__c where id = :orderID];
        }
        return productionOrderTLIncharge;
    }
    
    public List<Member__c> getMemberTeamDetails(Set<Id> teamIdsForQC){
        
        memberTeamInfo = new List<Member__c>();
        if(teamIdsForQC != null && teamIdsForQC.size() > 0){
            memberTeamInfo = [select Team_id__c from Member__c where id IN:teamIdsForQC AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
        }
        return memberTeamInfo;
    }   
    
    public List<Team__c> getTeamDetails(Set<Id> memteamIdsForQC){
        
        teamNameListForQC = new List<Team__c>();
        if(memteamIdsForQC != null && memteamIdsForQC.size() > 0){
            teamNameListForQC = [select id, Name from Team__c where id in : memteamIdsForQC];
        }
        return teamNameListForQC;
    }   
    
    public List<Member__c> getQCMemberOfSelectedTeam(String selTeamForQC){
        
        memberQCInTeam = new List<Member__c>();
        if(selTeamForQC != null){
            memberQCInTeam = [select Name,id,Location_id__c from Member__c where Team_id__c =:selTeamForQC AND Designation__c='Quality Control' AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
        }
        return memberQCInTeam;
    }   
    
    public List<Production_Order__c> getProductionOrderQCInchargeDetails(String orderID){
        
        productionOrderQCIncharge = new List<Production_Order__c>();
        if(orderID != null){
            productionOrderQCIncharge = [select QC_InCharge__c from Production_order__c where id = :orderID];
        }
        return productionOrderQCIncharge;
    }
    
    public List<Files__c> getOpenFilesTypeList(List<Id> FileIDsList){
        
        relatedOpenFileTypeList = new List<Files__c>();
        if(FileIDsList != null && FileIDsList.size() > 0){
            relatedOpenFileTypeList = [select ID,Files_To_open__c,Member__c,File_Type__c,InstructionNames__c,Production_Order__c from Files__c where id IN :FileIDsList];
        }
        return relatedOpenFileTypeList;
    }
    
    public List<Files__c> getFilesRecords(List<Id> FileIDsList){
        
        relatedFileRecordsList = new List<Files__c>();
        if(FileIDsList != null && FileIDsList.size() > 0){
            relatedFileRecordsList = [select ID from Files__c where id IN :FileIDsList];
        }
        return relatedFileRecordsList;
    }
    
    public List<Files__c> getFilesRecordsInfo(List<Files__c> FileList){
        
        relatedFileRecordsListInfo = new List<Files__c>();
        if(FileList != null && FileList.size() > 0){
            relatedFileRecordsListInfo = [select ID from Files__c where id IN :FileList];
        }
        return relatedFileRecordsListInfo;
    }
    
    public List<Files__c> getOpenFilesRecordsInfo(List<id> FileIDsList){
        
        relatedOpenFileRecordsListInfo = new List<Files__c>();
        if(FileIDsList != null && FileIDsList.size() > 0){
            relatedOpenFileRecordsListInfo = [select Id, Status__c, File_PS_Version__c, Files_To_open__c from Files__c where id IN :FileIDsList];
        }
        return relatedOpenFileRecordsListInfo;
    }
    
    public List<Member__c> getMemberDesignation(String userId){
        
        memberDesignationList = new List<Member__c>();
        if(userId != null){
            memberDesignationList = [select Designation__c from Member__c where User_Id__c =:userId];
        }
        return memberDesignationList;
    }   
    
    public Integer getFilesRelatedToProductionOrderCount(String orderID){
        
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where  Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        
        CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds ];
        return CountTotalRecords;
    }   
    
    public List<Files__c> getFilesRelatedToProductionOrder(String orderID){
        
        fileList = new List<Files__c>();
        
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where  Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        
        if(orderID != null){
            fileList = [Select id, Name, Parent_Id__c, Files_To_open__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__r.Instruction__c, QC_Comments__c,
                        File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                        Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, Instruction__c, order_instructions__c,File_Type__c  from Files__c where File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__c =:orderID AND Id NOT IN : unWantedFileIds ];
        }
        
        return fileList;
    } 
    
}