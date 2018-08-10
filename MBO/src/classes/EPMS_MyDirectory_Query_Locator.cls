/**********************************************************************************
*   Class               :       EPMS_MyDirectory_Query_Locator                    *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Query locator for Mydirectory and QCCheckSearch   *
**********************************************************************************/

public with sharing class EPMS_MyDirectory_Query_Locator {

    public List<Files__c> FileList = null;
    public List<member__c> memDetails = null;
    public Profile profile = null;
    public Integer productionOrderCount = 0;
    public List<Production_Order__c> ProdOrderDetails = null;
    public Integer CountTotalRecords = 0;
    public Member__c memberHolder = null;
    public List<Production_Order__c> ProdOrderDetailsForLoggedUser = null;
    public List<Files__c> relatedFilesList = null;
    public List<File_Categories__c> fileCategory = null;    
    public List<Production_Order__c> ProdOrderDetailsForSalesRegion = null;
    public List<Files__c> qcFileList = null;
    public List<Files__c> qcFileInfoList = null;
    public List<Files__c> qcChildFileInfoList = null;   
    public Member__c member = null;  
    
    public User getLoggedUserInformation(){
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        return UserId;
    }
    
    public Profile getLoggedUserProfileInformation(){
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        return profile;
    }
    
    public List<Shift__c> getAllShiftList(){
        List<Shift__c> shiftList = [select Id, Name from Shift__c];
        return shiftList;
    }
    public List<Member__c> getMemberTeamInformation(Set<Id> teamIds){
        List<Member__c> memberTeamDetails = [select Team_id__c from Member__c where id IN:teamIds];
        return memberTeamDetails;
    }    
    
    public Production_Order__c getOrderLocationOfSelectedOrder(Id orderID){
        Production_Order__c productionOrderInfo = null;
        if(orderID != null){
            productionOrderInfo = [SELECT Id, Mbo_Location__c FROM Production_Order__c WHERE Id =: orderID]; 
        }
        return productionOrderInfo;
    }
    
    public List<Member__c> getMemberListExistInLocation(Id locationId){
        List<Member__c> memberTL_QC_List = null;
        if(locationId != null){
            memberTL_QC_List = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Location_id__c =: locationId AND Status__c = :EPMS_UTIL.EPMS_ACTIVE_STATUS];    
        }
        return memberTL_QC_List;
    }
    
    public List<files__c> getFileDetailInformation(List<id> FileIDsList){
        
        List<files__c> fl = null;
        if(FileIDsList != null && FileIDsList.size() > 0){
            fl = [select id,Name,File_Type__c,Current_Extension__c,Parent_Id__r.Instruction__c,Job_List__c,File_Category_Code__c,Status__c from Files__c where id =: FileIDsList];
        }
        return fl;
    }
    
    public List<files__c> getFileExtensionInformation(Set<id> FileIDSet){
        List<files__c> filesList = null;
        if(FileIDSet != null && FileIDSet.size() > 0){
            filesList  =  [select id,Name,File_Type__c,Current_Extension__c,Parent_Id__r.Instruction__c,Job_List__c,Delivery_Extension__c from Files__c where id IN :FileIDSet];
        }
        return filesList;
    }
    
   
    public List<Files__c> getFileInstructionDetails(Set<Id> fileIds){
    
        if(fileIds != null && fileIds.size() > 0){
            FileList = [select id,Name,Total_Work_Time__c,File_Type__c,File_Location__c, Member__c, Tracker_handover__c, Current_Extension__c,Job_List__c,Parent_Id__r.Instruction__c,Instruction__c, Files_To_open__c,Status__c, File_Category_Code__c, Category_Modified__c from Files__c where id IN :fileIds];
        }
        
        return FileList;
    }
    
    public List<Member__c> getMemberDesignation(Id userId){
        
        memDetails = new List<Member__c>();
        if(userId != null){
            memDetails = [select Designation__c from Member__c where User_Id__c =:userId];
        }
        return memDetails;
    }
    
    public Profile getUserProfileInfo(Id profileId){
        
        if(profileId != null){
            profile = [Select Id,Name from Profile where Id =: profileId];
        }
        return profile;
    }
    
    // Getting production order count for all location : Used only System Administrator user
    public Integer getProductionOrderCount(){
        //productionOrderCount = [Select count() from Production_Order__c ];
        productionOrderCount = [Select count() from Production_Order__c WHERE Id IN (SELECT Production_Order__c FROM Files__c) AND Production_Order_Status__c NOT IN ('Cancelled', 'Uploaded') ];
        return productionOrderCount;
    }
    
    // Getting no of production order details mentioned in query limit for system administrator user
    public List<Production_Order__c> getProductionOrderListOrderByName(Integer QueryLimit,Integer OffsetSize){
            
        ProdOrderDetails = [Select id,Name,QC_Incharge__c, TL_Incharge__c,Production_Order_Status__c from Production_Order__c  WHERE Id IN (SELECT Production_Order__c FROM Files__c) AND Production_Order_Status__c NOT IN ('Cancelled', 'Uploaded') ORDER BY Name DESC limit :QueryLimit offset :OffsetSize];
       
        return ProdOrderDetails;
    }   
    
    // Getting production order count for all location : Used only System Administrator user
    public Integer getProductionOrderCountByQC_Or_TL(Id memberId){       
        // Based on Member Designation display orders in My Directory
        /*
        if(memberId != null){
            member = [SELECT Id, Name, Designation__c FROM Member__c WHERE Id =: memberId];
        }
        if(member != null && member.Designation__c == 'Team Leader'){
            CountTotalRecords = [Select count() from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c) AND TL_Incharge__c =: memberId AND Production_Order_Status__c IN ('New', 'Assigned','WIP','Redo')];
        } else if(member != null && member.Designation__c == 'Quality Control'){
            CountTotalRecords = [Select count() from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c) AND QC_Incharge__c =:memberId AND Production_Order_Status__c IN ('WIP', 'QCIP')];
        } else {
            CountTotalRecords = [Select count() from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c) AND (QC_Incharge__c =:memberId  or TL_Incharge__c =: memberId) AND Production_Order_Status__c NOT IN ('Cancelled', 'Uploaded')];
        }*/
        CountTotalRecords = [Select count() from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c) AND (QC_Incharge__c =:memberId  or TL_Incharge__c =: memberId) AND Production_Order_Status__c NOT IN ('Cancelled', 'Uploaded')];
        return CountTotalRecords;
    }
        
    public Member__c getActiveMemberInfo(Id userId){ 
        
        //User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }              
        //if(userId != null){
        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && proflieName !='Country Administrator' && proflieName != 'Full-time Employees (Japan)'){
            memberHolder = [select id from Member__c where Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND  User_Id__c=:userId limit 1];
        }
        return memberHolder;
    }
    
    public List<Production_Order__c> getProductionOrderForSaleRegion(Id userId, Integer QueryLimit,Integer OffsetSize){

        ProdOrderDetailsForSalesRegion = [Select id,Name, QC_Incharge__c, TL_Incharge__c from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c) AND User__c =:userId AND Production_Order_Status__c NOT IN ('Cancelled', 'Uploaded') ORDER BY Name DESC limit :QueryLimit offset :OffsetSize];
        return ProdOrderDetailsForSalesRegion;
        
    }
    
    public List<Production_Order__c> getProductionOrderAssigedTO_QC_OR_TL(Id memberId, Integer QueryLimit,Integer OffsetSize){
        
        // Based on Member Designation display orders in My Directory
        /*
        if(memberId != null){
            member = [SELECT Id, Name, Designation__c FROM Member__c WHERE Id =: memberId];
        }
        if(member != null && member.Designation__c == 'Team Leader'){
            ProdOrderDetailsForLoggedUser = [Select id,Name,QC_Incharge__c, TL_Incharge__c,Production_Order_Status__c from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c where (QCIncharge__c=: memberId or TLInCharge__c=: memberId)) AND (QC_Incharge__c =: memberId or TL_Incharge__c =: memberId) AND Production_Order_Status__c IN ('New', 'Assigned','WIP','Redo') ORDER BY Name DESC limit :QueryLimit offset :OffsetSize];
        } else if(member != null && member.Designation__c == 'Quality Control'){
            ProdOrderDetailsForLoggedUser = [Select id,Name,QC_Incharge__c, TL_Incharge__c,Production_Order_Status__c from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c where (QCIncharge__c=: memberId or TLInCharge__c=: memberId)) AND (QC_Incharge__c =: memberId or TL_Incharge__c =: memberId) AND Production_Order_Status__c IN ('WIP','QCIP') ORDER BY Name DESC limit :QueryLimit offset :OffsetSize];
        }*/
        
        //ProdOrderDetailsForLoggedUser = [Select id,Name,QC_Incharge__c, TL_Incharge__c from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c where (QCIncharge__c=: memberId or TLInCharge__c=: memberId)) AND (QC_Incharge__c =: memberId or TL_Incharge__c =: memberId) ORDER BY Name DESC limit :QueryLimit offset :OffsetSize];
        ProdOrderDetailsForLoggedUser = [Select id,Name,QC_Incharge__c, TL_Incharge__c,Production_Order_Status__c from Production_Order__c where Id IN (SELECT Production_Order__c FROM Files__c where (QCIncharge__c=: memberId or TLInCharge__c=: memberId)) AND (QC_Incharge__c =: memberId or TL_Incharge__c =: memberId) AND Production_Order_Status__c NOT IN ('Cancelled', 'Uploaded') ORDER BY Name DESC limit :QueryLimit offset :OffsetSize];
       
        return ProdOrderDetailsForLoggedUser;
    }
    

    public List<Files__c> getRelatedFileListForProductionOrders(Id orderId){

        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;

        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && proflieName !='Country Administrator' && proflieName != 'Full-time Employees (Japan)'){

            //if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME){
            if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME && proflieName !='Country Administrator' && proflieName != 'Full-time Employees (Japan)'){
                member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id];
            }
        }
        system.debug('Current Time 1 : ' + system.now());
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like '%.db' OR Name like '%.DS_store' OR Name Like '%.BridgeSort')];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        system.debug('Current Time 2 : ' + system.now());

        if(orderId != null){
            if(member != null && (member.Designation__c == EPMS_UTIL.EPMS_QC_DES || member.Designation__c == EPMS_UTIL.EPMS_TEAM_DES)){
            relatedFilesList = [SELECT id, File_Type__c,Parent_Id__r.Instruction__c,Job_List__c,Name,Parent_Id__c,Splitted_Parent_id__c,Status__c,Production_Order__c,QCIncharge__c,TLInCharge__c FROM Files__c where Production_Order__c = : orderId  AND Id NOT IN : unWantedFileIds Order By File_Auto_Number__c];
            } else {
                relatedFilesList = [SELECT id, File_Type__c,Name,Parent_Id__c,Parent_Id__r.Instruction__c,Job_List__c,Splitted_Parent_id__c,Status__c,Production_Order__c,QCIncharge__c,TLInCharge__c FROM Files__c where Production_Order__c = :orderId AND Id NOT IN : unWantedFileIds Order By File_Auto_Number__c]; //Order By Production_Order__r.Name ASC           
            }
        }

        return relatedFilesList;
    }
    
    
    
    public List<File_Categories__c> getFileCategoryList(){
        fileCategory = [select Id,Name from File_Categories__c ORDER BY Name ASC];
        return fileCategory;
    }   

   public List<Files__c> getQCFilesRelatedToProductionOrder(String orderID){

        fileList = new List<Files__c>();
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;

        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME){

            if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME){
                member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id];
            }
            
        }
        
        if(orderID != null){
            if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                qcFileList = [Select id, Name, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,
                File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,QCIncharge__c,QCIncharge__r.Name,
                Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' and Tracker_Handover__c=false AND QCIncharge__c =: member.id  Order By Name]; // AND QCIncharge__c =: member.Id
            } else {
            
                qcFileList = [Select id, Name, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,
                File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,QCIncharge__c,QCIncharge__r.Name,
                Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' and Tracker_Handover__c=false Order By Name];
            }
               
        }
        
        return qcFileList;
    }      

    public List<Files__c> getQCFileDetailsForUpdate(Set<Id> fileIds){
        
        if(fileIds != null && fileIds.size() > 0){
            qcFileInfoList = [select id,Name,Member__c,Splitted_Parent_id__c,IsSplitedFile__c,File_Type__c,Current_Extension__c,Job_List__c,Status__c,Parent_Id__r.Instruction__c, QC_Comments__c,Total_Break_Time__c,Total_Work_Time__c,No_of_Breaks__c
 from Files__c where id IN :fileIds AND File_Type__c != 'Instruction'];
        }
        
        return qcFileInfoList;
    }
    
    public List<Files__c> getQCChildFileDetailsForUpdate(Set<Id> fileIds){
        
        if(fileIds != null && fileIds.size() > 0){    
            qcChildFileInfoList = [select id,Name,File_Type__c,Current_Extension__c,Status__c,Job_List__c, Parent_Id__r.Instruction__c,QC_Comments__c from Files__c where Parent_Id__c IN : fileIds AND File_Type__c != 'Instruction'];
        }        
        return qcChildFileInfoList;
    }
    
    public List<Production_Order__c> getAssignedFileListWithoutProductionOrders(Integer QueryLimitNew,Integer OffsetSizeNew){

        relatedFilesList = new List<Files__c>();
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;

        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME){

            //if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME){
            if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME && proflieName !='Country Administrator' && proflieName != 'Full-time Employees (Japan)'){
                member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id and Status__c =:EPMS_UTIL.EPMS_ACTIVE_STATUS];
            }
            
        }
        system.debug('Current Time 3 : ' + system.now());
        Set<Id> unWantedFileIds = new Set<Id>();
        /*List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like '%.db' OR Name like '%.DS_store' OR Name Like '%.BridgeSort')];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }*/
        system.debug('Current Time 4 : ' + system.now());
        List<Production_Order__c> assignedFilesOrderDetails = null;

        if(member != null){
            if (member.Designation__c == EPMS_UTIL.EPMS_QC_DES){

                //relatedFilesList = [SELECT Id, File_Type__c, Name, Parent_Id__c,Job_List__c,Parent_Id__r.Instruction__c,Splitted_Parent_id__c,Status__c, Production_Order__c FROM Files__c WHERE Production_Order__c IN (SELECT Id FROM Production_Order__c WHERE QC_Incharge__c !=: member.Id) AND QCIncharge__c=: member.Id AND Status__c IN ('Redo','Redo Re-Assigned','QC','QCIP')  AND Id NOT IN : unWantedFileIds Order By File_Auto_Number__c];
                relatedFilesList = [SELECT Id, File_Type__c, Name, Parent_Id__c,Job_List__c,Parent_Id__r.Instruction__c,Splitted_Parent_id__c,Status__c, Production_Order__c FROM Files__c WHERE Production_Order__c IN (SELECT Id FROM Production_Order__c WHERE QC_Incharge__c !=: member.Id) AND QCIncharge__c=: member.Id AND Status__c IN ('Redo','Redo Re-Assigned','QC','QCIP') Order By File_Auto_Number__c];
            } else if (member.Designation__c == EPMS_UTIL.EPMS_TEAM_DES){

                //relatedFilesList = [SELECT Id, File_Type__c, Name, Parent_Id__c,Job_List__c, Parent_Id__r.Instruction__c,Status__c,Splitted_Parent_id__c, Production_Order__c FROM Files__c WHERE Production_Order__c IN (SELECT Id FROM Production_Order__c WHERE TL_InCharge__c !=: member.Id) AND TLInCharge__c=: member.Id AND Status__c IN ('Assigned','New','Redo','Handover','Redo Re-Assigned','WIP') AND Id NOT IN : unWantedFileIds Order By File_Auto_Number__c];
                relatedFilesList = [SELECT Id, File_Type__c, Name, Parent_Id__c,Job_List__c, Parent_Id__r.Instruction__c,Status__c,Splitted_Parent_id__c, Production_Order__c FROM Files__c WHERE Production_Order__c IN (SELECT Id FROM Production_Order__c WHERE TL_InCharge__c !=: member.Id) AND TLInCharge__c=: member.Id AND Status__c IN ('Assigned','New','Redo','Handover','Redo Re-Assigned','WIP') Order By File_Auto_Number__c];
            }

        } 
        


        Set<Id> orderInfo = new Set<Id>();
        
        if(relatedFilesList != null && relatedFilesList.size() > 0){
            for(Files__c file :relatedFilesList){
                orderInfo.add(file.Production_Order__c);
            }
        }
        
        
        if(orderInfo.size() > 0 && member != null){
             assignedFilesOrderDetails = [SELECT Id, Name, Production_Order_Status__c FROM Production_Order__c WHERE Id IN : orderInfo limit: QueryLimitNew offset : OffsetSizeNew];

        }
        
        return assignedFilesOrderDetails;
    }
    
    
    public List<Files__c> getAssignedFileListWithProductionOrdersFor_QC_Or_TL(Id orderId){

        relatedFilesList = new List<Files__c>();
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;

        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME){

            if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME && proflieName !='Country Administrator' && proflieName != 'Full-time Employees (Japan)'){
                member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id];
            }
            
        }
        system.debug('Current Time 5 : ' + system.now());
        Set<Id> unWantedFileIds = new Set<Id>();
        List<Files__c> unWantedFileList = [select Id from Files__c where Production_Order__c =:orderID AND (name like '%.db' OR Name like '%.DS_store' OR Name Like '%.BridgeSort')];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }
        system.debug('Current Time 6 : ' + system.now());

        if(member != null){
            if (member.Designation__c == EPMS_UTIL.EPMS_QC_DES){

                relatedFilesList = [SELECT Id, File_Type__c, Name, Job_List__c,Parent_Id__c,Parent_Id__r.Instruction__c,Splitted_Parent_id__c,Status__c, Production_Order__c, TLInCharge__c, QCIncharge__c FROM Files__c WHERE Production_Order__c IN (SELECT Id FROM Production_Order__c WHERE QC_Incharge__c !=: member.Id)  AND Production_Order__c =: orderId AND QCIncharge__c=: member.Id AND Status__c IN ('Redo','Redo Re-Assigned','QC','QCIP') AND Id NOT IN : unWantedFileIds Order By File_Auto_Number__c];
            } else if (member.Designation__c == EPMS_UTIL.EPMS_TEAM_DES){

                relatedFilesList = [SELECT Id, File_Type__c, Name,Job_List__c, Parent_Id__c,Parent_Id__r.Instruction__c,Splitted_Parent_id__c,Status__c, Production_Order__c, TLInCharge__c, QCIncharge__c FROM Files__c WHERE Production_Order__c IN (SELECT Id FROM Production_Order__c WHERE TL_InCharge__c !=: member.Id)  AND Production_Order__c =: orderId AND TLInCharge__c=: member.Id AND Status__c IN ('Assigned','New','Redo','Handover','Redo Re-Assigned','WIP') AND Id NOT IN : unWantedFileIds Order By File_Auto_Number__c];
            }
            // if parent id not retreived in QC files   
            List<Files__c> relatedFilesListParent = new List<Files__c>();
            Set<Id> allFileIds = new Set<Id>();
            if(relatedFilesList != null && relatedFilesList.size() > 0){
                for(Files__c file : relatedFilesList){
                    allFileIds.add(file.Id);
                }
                for(Files__c files : relatedFilesList){
                    if(!allFileIds.isEmpty()){
                        if(!allFileIds.contains(files.Parent_Id__c)){
                            files.Parent_Id__c = null;
                            relatedFilesListParent.add(files);
                        } else {
                            relatedFilesListParent.add(files);
                        }
                    }
                }
                
                return relatedFilesListParent;
            }                      
            
        } 
             
        return relatedFilesList;
        
    }
    
    
    public Integer getOrderCountFromFilesList(Id memberId){
    
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName = null;
        if(profile != null){
            proflieName= profile.Name;
        }
        system.debug('Current Time 7 : ' + system.now());
        Set<Id> unWantedFileIds = new Set<Id>();
        /*List<Files__c> unWantedFileList = [select Id from Files__c where name like '%.db' OR Name like '%.DS_store' OR Name Like '%.BridgeSort'];
        if(unWantedFileList != null && unWantedFileList.size() > 0){
            for(Files__c file : unWantedFileList){
                unWantedFileIds.add(file.Id);            
            }
        }*/
        system.debug('Current Time 8 : ' + system.now());
        List<Files__c> filesList = null;
        Set<Id> productionOrderSet = new Set<Id>();
        if(proflieName == EPMS_UTIL.EPMS_QC_PROFILE_NAME){
            //filesList = [SELECT Id, Name, Production_Order__c FROM Files__c where QCIncharge__c=: memberId AND Status__c IN ('Redo','Redo Re-Assigned','QC','QCIP') AND Id NOT IN : unWantedFileIds];
            filesList = [SELECT Id, Name, Production_Order__c FROM Files__c where QCIncharge__c=: memberId AND Status__c IN ('Redo','Redo Re-Assigned','QC','QCIP')];
        } else if (proflieName == EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME){
            //filesList = [SELECT Id, Name, Production_Order__c FROM Files__c where TLInCharge__c=: memberId AND Status__c IN ('Assigned','New','Redo','Redo Re-Assigned','WIP') AND Id NOT IN : unWantedFileIds];
            filesList = [SELECT Id, Name, Production_Order__c FROM Files__c where TLInCharge__c=: memberId AND Status__c IN ('Assigned','New','Redo','Redo Re-Assigned','WIP')];
        }
                
        if(filesList != null && filesList.size() > 0){
            for(Files__c newFile : filesList){
                productionOrderSet.add(newFile.Production_Order__c);
            }
        }
        
        return productionOrderSet.size();
    }
    
      public List<Files__c> getQCFilesRelatedToProductionOrder(String orderID, Integer QueryLimit,Integer OffsetSize, String sortChoice, String sortType,Boolean OnHoldCheck){
     
	   fileList = new List<Files__c>();
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;

        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && proflieName !='Country Administrator' && proflieName != 'Full-time Employees (Japan)'){

            if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME){
                member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id];
            }
            
        }
        
        if(sortType == null){
            sortType = 'ASC';
        }
        
        
       if(orderID != null ){
            if(OnHoldCheck==false){ 
       
                if(sortChoice != null && sortChoice != 'Name'){
               
                    if(sortChoice == 'Status' && sortType == 'ASC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c,Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false  AND QCIncharge__c =: member.id Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }                
                    } else if(sortChoice == 'Status' && sortType == 'DESC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];   //AND QCIncharge__c =: member.Id          
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                          
                        }                                
                    
                    } else if(sortChoice == 'Operator' && sortType == 'ASC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ]; //AND QCIncharge__c =: member.Id           
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }  
                        
                    
                    } else if(sortChoice == 'Operator' && sortType == 'DESC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ]; //AND QCIncharge__c =: member.Id           
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c, Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }
                                   
                    }else if(sortChoice == 'Extension' && sortType == 'ASC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }  
                        
                    
                    } else if(sortChoice == 'Extension' && sortType == 'DESC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }
                                   
                    } 
                    else if(sortChoice == 'Category' && sortType == 'ASC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }  
                        
                    } else if(sortChoice == 'Category' && sortType == 'DESC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c, File_Copy_Number__c, File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                        }  
                    }
                } else {
                
                    if(sortType == 'ASC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c, File_Copy_Number__c, File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        } 
                    
                    } else {
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                        } 

                    }
                
                }
            
            }
        else{
            if(sortChoice != null && sortChoice != 'Name'){
               
                    if(sortChoice == 'Status' && sortType == 'ASC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Status__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }                
                    } else if(sortChoice == 'Status' && sortType == 'DESC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Status__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                          
                        }                                
                    
                    } else if(sortChoice == 'Operator' && sortType == 'ASC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }  
                        
                    
                    } else if(sortChoice == 'Operator' && sortType == 'DESC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name,File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Member__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }
                                   
                    }else if(sortChoice == 'Extension' && sortType == 'ASC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }  
                        
                    
                    } else if(sortChoice == 'Extension' && sortType == 'DESC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Current_Extension__c DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }
                                   
                    } 
                    else if(sortChoice == 'Category' && sortType == 'ASC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        }  
                        
                    } else if(sortChoice == 'Category' && sortType == 'DESC'){
                    
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name,File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By File_Category_Code__r.Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                        }  
                    }
                } else {
                
                    if(sortType == 'ASC'){
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name ASC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                           
                        } 
                    
                    } else {
                        
                        if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                            qcFileList = [Select id, Name,File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];            
                        } else {
                        
                            qcFileList = [Select id, Name, File_Copy_Number__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,Current_Extension__c,
                            File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                            Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','Redo Re-Assigned') AND File_Type__c='Image' AND Tracker_Handover__c=false AND QCIncharge__c =: member.id Order By Name DESC NULLS LAST limit :QueryLimit offset :OffsetSize ];
                        } 

                    }
                
                }
            
            
        }
        
        }
        return qcFileList;
        
    }   
    
    public Integer getQCFilesCountRelatedToProductionOrder(String orderID){

        fileList = new List<Files__c>();
        User UserId = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName= null;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        Member__c member = null;

        if(UserId != null && proflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && proflieName !='Country Administrator' && proflieName != 'Full-time Employees (Japan)'){

            if (UserId != null && proflieName != EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME){
                member = [SELECT Id, Name, Designation__c FROM Member__c WHERE User_Id__c =: UserId.Id];
            }
            
        }
        
        if(orderID != null){
            
            if(member != null && member.Designation__c == EPMS_UTIL.EPMS_QC_DES){
                qcFileList = [Select id, Name, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,
                File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' Order By Name ];            
            } else {
            
                qcFileList = [Select id, Name, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, QC_Comments__c,
                File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,
                Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where Production_Order__c =:orderID AND Status__c IN ('QCIP','On-Hold','Redo Re-Assigned') AND File_Type__c='Image' Order By Name ];
            }                
        
        }
        
        if(qcFileList != null && qcFileList.size() > 0){
            return qcFileList.size();
        } else {
            return 0;
        }
      
    }
}