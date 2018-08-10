/***************************************************************************
*   Class               :       EPMS_ViewClassification_QueryLocator        *
*   Created Date        :       09/08/2016                                  *           
*   Description         :       To return the requested Result              *
*                               based on the request by service class       *
*                               will be used as the Common Class            *
*   Modification        :       28/03/18 - Modified for View Estimation
/***************************************************************************/

public without sharing class EPMS_ViewClassification_QueryLocator {
    
    public Production_Order__c productionOrderList = null;
    public List<Files__c> fileList = null;
    public List<Files__c> fileStatusList = null;
    public List<Files__c> fileToOpenList = null;
    public List<Files__c> relatedfileList = null;
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
    
    public List<Files__c> getChildFilesRecordsInfo(List<id> FileIDsList){
        
        List<Files__c> relatedFileRecordsListInfo = new List<Files__c>();
        if(FileIDsList != null && FileIDsList.size() > 0){
            relatedFileRecordsListInfo = [select Id, Name, Instruction__c, Files_To_open__c, File_Type__c from Files__c where Parent_Id__c IN :FileIDsList];
        }
        return relatedFileRecordsListInfo;
    }
    
    public List<Files__c> getFilesRelatedToProductionOrder(String orderID,Integer QueryLimit,Integer OffsetSize, String sortChoice, String sortType,string catName,string Status){
        /*system.debug('##### orderID : ' + orderID);
system.debug('##### sortChoice : ' + sortChoice);
system.debug('##### sortType : ' + sortType);
system.debug('##### Status : ' + Status);
system.debug('##### QueryLimit : ' + QueryLimit);
system.debug('##### OffsetSize : ' + OffsetSize);
system.debug('##### catName : ' + catName);*/
        
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
        
        if(sortChoice != null && sortChoice != 'Name' ){
            system.debug('$$$$$$$ sortChoice : ' + sortChoice);
            if(sortChoice == 'Status' & orderID != null && sortType == 'ASC'){
                if(Status=='Approved'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                } else if(status=='All'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name, QCIncharge__r.Name,TLInCharge__r.Name,Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c!='null' AND File_Category_Code__r.Name=:catName) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                } else if (status=='Estimation') {
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c, Estimated_File_Category__r.Name  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Estimated_File_Category__r.Name=:catName) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                }
                
                return fileList;
                
            } else if(sortChoice == 'Status' & orderID != null && sortType == 'DESC'){
                if(Status=='Approved'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name, QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                } else if(status=='All'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c,Member__r.Name, QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c!='null' AND File_Category_Code__r.Name=:catName) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize];              
                } else if (status=='Estimation') {
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c, Estimated_File_Category__r.Name  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Estimated_File_Category__r.Name=:catName) Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                }                           
                
                return fileList;
            } else if(sortChoice == 'Operator' & orderID != null && sortType == 'ASC'){                
                if(Status=='Approved'){              
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c
                                from Files__c where (File_Type__c =:label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];                
                } else if(status=='All'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c
                                from Files__c where (File_Type__c =:label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID AND File_Category_Code__r.Name=:catName) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];                
                } else if (status=='Estimation') {
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c, Estimated_File_Category__r.Name  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Estimated_File_Category__r.Name=:catName) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                }
                
                return fileList;
            } else if(sortChoice == 'Operator' & orderID != null && sortType == 'DESC'){                
                if(Status=='Approved'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                                Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                    system.debug(' ####### [CASE 4] getFilesRelatedToProductionOrder #######' + fileList);                      
                } else if(status=='All'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                                Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND File_Category_Code__r.Name=:catName) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                } else if (status=='Estimation') {
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c, Estimated_File_Category__r.Name  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Estimated_File_Category__r.Name=:catName) Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                }
                
                return fileList;
            }  
        } 
        String userSortChoice = 'Name';
        
        fileList = new List<Files__c>();
        if(orderID != null){
            if(sortType == 'ASC'){
                if(Status=='Approved'){
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Name ASC NULLS FIRST limit :QueryLimit offset :OffsetSize ];
                } else if(status=='All'){
                    system.debug(' ####### [CASE 7  ELSE] getFilesRelatedToProductionOrder #######');
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND File_Category_Code__r.Name=:catName) Order By Name ASC NULLS FIRST limit :QueryLimit offset :OffsetSize ]; // AND Status__c='null'
                    system.debug(' ####### [CASE 7  ELSE] getFilesRelatedToProductionOrder #######' + fileList);
                } else if (status=='Estimation') {
                    system.debug(' ####### [CASE 9  ELSE Estimation] getFilesRelatedToProductionOrder #######');
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c, Estimated_File_Category__r.Name  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Estimated_File_Category__r.Name=:catName) Order By Name ASC NULLS FIRST limit :QueryLimit offset :OffsetSize ]; // AND Status__c='null'
                    system.debug(' ####### [CASE 9  ELSE Estimation] getFilesRelatedToProductionOrder #######' + fileList);
                }
            } else {
                if(Status=='Approved'){
                    system.debug(' ####### [CASE 8] getFilesRelatedToProductionOrder #######');
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Name DESC NULLS FIRST limit :QueryLimit offset :OffsetSize ];
                    system.debug(' ####### [CASE 8] getFilesRelatedToProductionOrder #######' + fileList);
                } else if(status=='All'){
                    system.debug(' ####### [CASE 8  ELSE] getFilesRelatedToProductionOrder #######');
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND File_Category_Code__r.Name=:catName) Order By Name DESC NULLS FIRST limit :QueryLimit offset :OffsetSize ];
                    system.debug(' ####### [CASE 8  ELSE] getFilesRelatedToProductionOrder #######' + fileList);
                } else if (status=='Estimation') {
                    system.debug(' ####### [CASE 9  ELSE Estimation] getFilesRelatedToProductionOrder #######');
                    fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                                File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,
                                File_Type__c, Estimated_File_Category__r.Name  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Estimated_File_Category__r.Name=:catName) Order By Name DESC NULLS FIRST limit :QueryLimit offset :OffsetSize ]; 
                    system.debug(' ####### [CASE 9  ELSE Estimation] getFilesRelatedToProductionOrder #######' + fileList);
                }           
            }
            
        }
        return fileList;
    }   
    
    
    public Production_Order__c getProdOrderDetails(String orderID){
        try{
            productionOrderList = new Production_Order__c();
            if(orderID != null){
                productionOrderList = [SELECT Id,Name, Production_Order_TAT__c,Mbo_Location__c,User__c  FROM Production_Order__c where Name= : orderID LIMIT 1];
            }
        } catch(Exception e){
            
        }
        
        return productionOrderList;
    }
    
    public List<Files__c> getFilesRelatedToProductionOrder(String orderID,Integer QueryLimit,Integer OffsetSize, String sortChoice,string catName){
        
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
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            } else {                
                
                fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize  ];
                
                return fileList;
            }
        } 
        String userSortChoice = 'Name';
        
        fileList = new List<Files__c>();
        if(orderID != null){
            fileList = [Select id, Name, Files_To_open__c,File_Job_Titles__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__c, Parent_Id__r.Instruction__c,Instruction__c, QC_Comments__c,
                        File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,
                        Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c from Files__c where (File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName) Order By Name limit :QueryLimit offset :OffsetSize ];
        }
        
        return fileList;
    }   
    
    
    
    public List<Files__c> getFilesStatusList(List<Files__c> filePopList){
        
        fileStatusList = new List<Files__c>();
        if(filePopList != null && filePopList.size() > 0){
            fileStatusList = [SELECT id,File_Type__c,Status__c,FTP_Upload_Status__c FROM Files__c where Id = : filePopList];
        }
        return fileStatusList;
    }   
    
    
    
    public List<Files__c> getFilesListRelatedToProductionOrder(String orderID,string catName){
        
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;
        
        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME){
            if(proflieName != 'システム管理者'){
                member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
            }
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
            relatedfileList = [SELECT id,File_Type__c,Name,File_Auto_Number__c,Status__c,Parent_Id__c,Splitted_Parent_id__c,Parent_Id__r.Instruction__c, Production_Order__c FROM Files__c where Production_Order__c = :orderID  AND Status__c='Approved' AND File_Category_Code__r.Name=:catName Order by File_Auto_Number__c ]; // Order by File_Auto_Number__c, Name, , Name ,Parent_Id__c //   
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
    
    
    
    
    public Integer getFilesRelatedToProductionOrderCount(String orderID,string catName,string status){
        
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);
            }
        }
        if(status=='Approved'){
            CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID AND Status__c='Approved' AND File_Category_Code__r.Name=:catName ];
        } else if(status=='All'){
            CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID AND File_Category_Code__r.Name=:catName ]; // Status__c='null'
        } else if(status=='Estimation'){
            CountTotalRecords = [Select count() from Files__c where File_Type__c = :label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID AND Status__c =: Label.EPMS_Status_Awaiting_Approval AND Estimated_File_Category__r.Name=:catName ];
        }
        return CountTotalRecords;
    }   
    
    public List<Files__c> getFilesRelatedToProductionOrder(String orderID,string catName,string status){
        
        fileList = new List<Files__c>();
        system.debug(' SELECTED Category : ' + status);
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like :EPMS_UTIL.EPMS_DB OR Name like :EPMS_UTIL.EPMS_STORE OR Name Like :EPMS_UTIL.EPMS_BRIDGE)];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        
        if(orderID != null){
            if(status=='Approved'){
                fileList = [Select id, Name, Parent_Id__c, Files_To_open__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__r.Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,
                            Total_Break_Time__c, Instruction__c, order_instructions__c,File_Type__c  from Files__c where File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID AND Status__c='Approved' AND File_Category_Code__r.Name=:catName ];
            }
            else if(status=='All'){
                fileList = [Select id, Name, Parent_Id__c, Files_To_open__c, Member__c, Member__r.Name,QCIncharge__r.Name,TLInCharge__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Parent_Id__r.Instruction__c, QC_Comments__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c , Production_Order__r.Production_Order_Instruction__c,Total_Break_Time_File__c,Total_WorkTime_for_File__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Total_Work_Time__c,
                            Total_Break_Time__c, Instruction__c, order_instructions__c,File_Type__c  from Files__c where File_Type__c =: label.EPMS_File_Type_Image AND Production_Order__r.Name =:orderID AND File_Category_Code__r.Name=:catName ];
            }   
        }
        
        return fileList;
    } 
    
}