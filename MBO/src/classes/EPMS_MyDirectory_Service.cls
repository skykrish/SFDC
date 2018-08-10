/**********************************************************************************
*   Class               :       EPMS_MyDirectory_Service                           *
*   Created Date        :       13/04/2016                                         *           
*   Description         :       Service class for MYDirectory,QCCheckSearch    *
**********************************************************************************/

public with sharing class EPMS_MyDirectory_Service {
    
    EPMS_MyDirectory_Query_Locator queryObj = new EPMS_MyDirectory_Query_Locator();
    public List<Files__c> FileList = null;
    public List<Member__c> memDetails = new List<Member__c>();
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
    public List<Files__c> qcFileLimitList = null;
    
    
    //getting logged user info
    public User getLoggedUserInformation(){
        User UserId = queryObj.getLoggedUserInformation();
        return UserId;
    }
    
        //getting logged user profile info

    public Profile getLoggedUserProfileInformation(){
        Profile profile = queryObj.getLoggedUserProfileInformation();
        return profile;
    }
        //getting shift info
    public List<Shift__c> getAllShiftList(){
        List<Shift__c> shiftList = queryObj.getAllShiftList();
        return shiftList;
    }
    
    //get member teams
    public List<Member__c> getMemberTeamInformation(Set<Id> teamIds){
        List<Member__c> memberTeamDetails =  queryObj.getMemberTeamInformation(teamIds);
        return memberTeamDetails;
    }
    
   //getting production order info
    public Production_Order__c getOrderLocationOfSelectedOrder(Id orderID){
        Production_Order__c productionOrderInfo = queryObj.getOrderLocationOfSelectedOrder(orderID);
        return productionOrderInfo;
    }
    
    //getting member list 
    public List<Member__c> getMemberListExistInLocation(Id locationId){
        List<Member__c> memberTL_QC_List = queryObj.getMemberListExistInLocation(locationId);
        return memberTL_QC_List;
    }
    
    //get file info
    public List<files__c> getFileDetailInformation(List<id> FileIDsList){
        List<files__c> fl = queryObj.getFileDetailInformation(FileIDsList);
        return fl;
    }
    
    //get file extension info
    public List<files__c> getFileExtensionInformation(Set<id> FileIDSet){
        List<files__c> filesList = queryObj.getFileExtensionInformation(FileIDSet);
        return filesList;
    }
    
    //get instruction file details
    public List<Files__c> getFileInstructionDetails(Set<Id> fileIds){
        FileList = queryObj.getFileInstructionDetails(fileIds);
        return FileList;
    }
       
    
    public List<Member__c> getMemberDesignation(Id userId){
        memDetails = queryObj.getMemberDesignation(userId);
        return memDetails;
    }
    
    public Profile getUserProfileInfo(Id profileId){
        profile =  queryObj.getUserProfileInfo(profileId);
        return profile;
    }
    
    public Integer getProductionOrderCount(){
        productionOrderCount = queryObj.getProductionOrderCount();
        return productionOrderCount;
    }
    
    // Getting all production order details for system administrator user
    public List<Production_Order__c> getProductionOrderListOrderByName(Integer QueryLimit,Integer OffsetSize){
        ProdOrderDetails = queryObj.getProductionOrderListOrderByName(QueryLimit,OffsetSize);
        return ProdOrderDetails;
    }   
    
    public Integer getProductionOrderCountByQC_Or_TL(Id memberId){
        CountTotalRecords = queryObj.getProductionOrderCountByQC_Or_TL(memberId);
        return CountTotalRecords;
    }
    
    //get member 
    public Member__c getActiveMemberInfo(Id userId){
        memberHolder = queryObj.getActiveMemberInfo(userId);
        return memberHolder;
    }
    
    //Get files assigned to QC/TL
    public List<Production_Order__c> getProductionOrderAssigedTO_QC_OR_TL(Id memberId, Integer QueryLimit,Integer OffsetSize){
        ProdOrderDetailsForLoggedUser = queryObj.getProductionOrderAssigedTO_QC_OR_TL(memberId,QueryLimit,OffsetSize);
        return ProdOrderDetailsForLoggedUser;
    }
    
    //get files related to PO
    public List<Files__c> getRelatedFileListForProductionOrders(Id orderId){
        relatedFilesList = queryObj.getRelatedFileListForProductionOrders(orderId);
        return relatedFilesList;
    }
    
    //Get categories
    public List<File_Categories__c> getFileCategoryList(){
        fileCategory = queryObj.getFileCategoryList();
        return fileCategory;
    }
    
    public List<Production_Order__c> getProductionOrderForSaleRegion(Id userId, Integer QueryLimit,Integer OffsetSize){
        ProdOrderDetailsForSalesRegion = queryObj.getProductionOrderForSaleRegion(userId,QueryLimit,OffsetSize);
        return ProdOrderDetailsForSalesRegion;
    }
    
     public List<Files__c> getQCFilesRelatedToProductionOrder(String orderID){
        qcFileList = queryObj.getQCFilesRelatedToProductionOrder(orderID);
        return qcFileList;
    }  
    
    
    public List<Files__c> getQCFileDetailsForUpdate(Set<Id> fileIds){
        qcFileInfoList = queryObj.getQCFileDetailsForUpdate(fileIds);
        return qcFileInfoList;
    }
    
    public List<Files__c> getQCChildFileDetailsForUpdate(Set<Id> fileIds){
        
        qcChildFileInfoList = queryObj.getQCChildFileDetailsForUpdate(fileIds);
        return qcChildFileInfoList;
    }
    
    public List<Production_Order__c> getAssignedFileListWithoutProductionOrders(Integer QueryLimitNew,Integer OffsetSizeNew){
         List<Production_Order__c> assignedFilesOrderDetails = null;
         assignedFilesOrderDetails = queryObj.getAssignedFileListWithoutProductionOrders(QueryLimitNew,OffsetSizeNew);
         return assignedFilesOrderDetails;
    }
    
    //Get files assigned to QC/TL
    public List<Files__c> getAssignedFileListWithProductionOrdersFor_QC_Or_TL(Id orderId){
        List<Files__c> relatedFileInfoList = new List<Files__c>();
        relatedFileInfoList = queryObj.getAssignedFileListWithProductionOrdersFor_QC_Or_TL(orderId);
        return relatedFileInfoList;
    }
    
    public Integer getOrderCountFromFilesList(Id memberId){
        Integer fileOrderCount = queryObj.getOrderCountFromFilesList(memberId);
        return fileOrderCount;
    }
    
    //get files related to PO 
    public List<Files__c> getQCFilesRelatedToProductionOrder(String orderID, Integer QueryLimit,Integer OffsetSize,String sortChoice, String sortType,Boolean OnHoldCheck){
        qcFileLimitList = queryObj.getQCFilesRelatedToProductionOrder(orderID,QueryLimit,OffsetSize,sortChoice,sortType,OnHoldCheck);
        return qcFileLimitList;
    }  
    
    public Integer getQCFilesCountRelatedToProductionOrder(String orderID){
        Integer qcFileCount = queryObj.getQCFilesCountRelatedToProductionOrder(orderID);
        return qcFileCount;
    }     
       
}