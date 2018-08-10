/****************************************************************************
*   Class               :      EPMS Production Order View Directory Service*
*   Created Date        :      21/01/2016                                  *           
*   Description         :      To Communicate with the  query locator      *
*                               and return the fetched result set          *
*                                                                          *
*   Created By          :                                                  *                       
*   Version             :      1.0                                         *            
/***************************************************************************/


public with sharing class EPMS_POViewDirectory_Service{

    public Production_Order__c prodOrderInformation = null;
    public List<Files__c> fileList = null;
    public List<Files__c> fileStatusList = null;   
    public List<Files__c> fileToOpenList = null;
    public transient List<Files__c> relatedfileList = null;
    public List<AggregateResult> fileCategoryCountForOrder = null;
    public List<File_Categories__c> fileCategoryInfo = null;
    public Production_Order__c productionOrderIncharge = null;
    public List<Files__c> relatedfileInstructionList = null;
    public List<Shift_Assignments__c> memberAssignedShift = null;
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
    public List<Member__c> memberInfo = null;
    public Integer CountTotalRecords = 0;
    public List<Files__c> fileList2 = new List<Files__c> ();
    
    // Call the Production Order : View Directory Query Locator
    
    EPMS_POViewDirectory_QueryLocator poQueryObj = new EPMS_POViewDirectory_QueryLocator();
    
    
    // Method to retrieve all files related to input order id
    public List<Files__c> getFilesRelatedToProductionOrder(string orderId,Integer QueryLimit,Integer OffsetSize, String sortingChoice, String sortType){
        fileList = poQueryObj.getFilesRelatedToProductionOrder(orderId,QueryLimit,OffsetSize,sortingChoice,sortType);
        return fileList;
    }
    
     public void refresh(){
    poQueryObj.refresh();
    
    
    }
    
   
    
    public List<Files__c> getFilesRelatedToProductionOrder(string orderId,Integer QueryLimit,Integer OffsetSize, String sortChoice, String sortCatg,String sortTitle,String sortingChoice,String sortType){
    
        fileList = poQueryObj.getFilesRelatedToProductionOrder(orderId,QueryLimit,OffsetSize,sortChoice,sortCatg,sortTitle,sortingChoice,sortType);
        return fileList;
    }
    
    public Integer getFilesRelatedToProductionOrderCount(string orderId,String sortChoice,String sortCatg,String sortTitle){
        CountTotalRecords = poQueryObj.getFilesRelatedToProductionOrderCount(orderId,sortChoice,sortCatg,sortTitle);
        return CountTotalRecords;
    }
    
    
    
    // Method to retrieve the production order information for input order ids
    
    public Production_Order__c getProdOrderDetails(string orderId){
        prodOrderInformation = poQueryObj.getProdOrderDetails(orderId);
        return prodOrderInformation;
    }
    
    // Method to retrieve all files related to input order id
    public List<Files__c> getFilesRelatedToProductionOrder(string orderId,Integer QueryLimit,Integer OffsetSize, String sortingChoice){
        fileList = poQueryObj.getFilesRelatedToProductionOrder(orderId,QueryLimit,OffsetSize,sortingChoice);
        return fileList;
    }
    
    // Method to retrieve all files status information
    
    public List<Files__c> getFilesStatusList(List<Files__c> filePopList){
        fileStatusList = poQueryObj.getFilesStatusList(filePopList);
        return fileStatusList;
    }   
    
    // Method to retrieve all the open to be files
    public List<Files__c> getFilesToOpenList(List<Id> fileIds){
        fileToOpenList = poQueryObj.getFilesToOpenList(fileIds);
        return fileToOpenList;
    }   
    
    // Method to retrieve the files list related to particular order
    
    public List<Files__c> getFilesListRelatedToProductionOrder(String orderID){
        relatedfileList = poQueryObj.getFilesListRelatedToProductionOrder(orderID);
        return relatedfileList;
    }   
    
    // Method to retrieve the file category count for particular order 
    public List<AggregateResult> getFilesCategoryCount(String orderID){
        fileCategoryCountForOrder = poQueryObj.getFilesCategoryCount(orderID);
        return fileCategoryCountForOrder;
    }
    
    // Method to retrieve the file category details
    public List<File_Categories__c> getFilesCategoryInfo(List<Id> Ids){
        fileCategoryInfo = poQueryObj.getFilesCategoryInfo(Ids);
        return fileCategoryInfo;
    }
    
    // Method to retrieve the Order In-charge details
    
    public Production_Order__c getProductionOrderInchargeDetails(String orderID){
        productionOrderIncharge = poQueryObj.getProductionOrderInchargeDetails(orderID);
        return productionOrderIncharge;
    } 
    
    // Method to retrieve the file's instruction details
    
    public List<Files__c> getFilesInstructionList(List<Id> FileIDsList){
        relatedfileInstructionList = poQueryObj.getFilesInstructionList(FileIDsList);
        return relatedfileInstructionList;
    }   
    
    // Method to retrieve the members assigned in shift details
    
    public List<Shift_Assignments__c> getMemberAssignedInShift(Id selShift){
        memberAssignedShift = poQueryObj.getMemberAssignedInShift(selShift);
        return memberAssignedShift;
    }
    
    // Method to retrieve the member team  details
    public List<Member__c> getMemberLocationDetails(Id selTeam){
        memberInfo = poQueryObj.getMemberLocationDetails(selTeam);
        return memberInfo;
    }

    // Method to retrieve the production order team leader details
    
    public List<Production_Order__c> getProductionOrderTLInchargeDetails(String orderID){
        productionOrderTLIncharge = poQueryObj.getProductionOrderTLInchargeDetails(orderID);
        return productionOrderTLIncharge;
    }
    
    // Method to retrieve the member's team details 
    
    public List<Member__c> getMemberTeamDetails(Set<Id> teamIdsForQC){
        memberTeamInfo = poQueryObj.getMemberTeamDetails(teamIdsForQC);
        return memberTeamInfo;
    }   
    
    // Method to retrieve team details
    
    public List<Team__c> getTeamDetails(Set<Id> memteamIdsForQC){
        teamNameListForQC = poQueryObj.getTeamDetails(memteamIdsForQC);
        return teamNameListForQC;
    }   
    
    // Method to retrieve the QC assigned in team
    
    public List<Member__c> getQCMemberOfSelectedTeam(String selTeamForQC){
        memberQCInTeam = poQueryObj.getQCMemberOfSelectedTeam(selTeamForQC);
        return memberQCInTeam;
    }
    
    
    // Method to retrieve the QC in-charge of the order
    
    public List<Production_Order__c> getProductionOrderQCInchargeDetails(String orderID){
        productionOrderQCIncharge = poQueryObj.getProductionOrderQCInchargeDetails(orderID);
        return productionOrderQCIncharge;
    }
    
    // Method to retrieve the open file type lists
    
    public List<Files__c> getOpenFilesTypeList(List<Id> FileIDsList){
        relatedOpenFileTypeList = poQueryObj.getOpenFilesTypeList(FileIDsList);
        return relatedOpenFileTypeList;
    }
    
    public List<Files__c> getFilesRecords(List<Id> FileIDsList){
        relatedFileRecordsList = poQueryObj.getFilesRecords(FileIDsList);
        return relatedFileRecordsList;
    }
    
    public List<Files__c> getFilesRecordsInfo(List<Files__c> FileList){
        relatedFileRecordsListInfo = poQueryObj.getFilesRecordsInfo(FileList);
        return relatedFileRecordsListInfo;
    }
    
    public List<Files__c> getOpenFilesRecordsInfo(List<id> FileIDsList){
        relatedOpenFileRecordsListInfo = poQueryObj.getOpenFilesRecordsInfo(FileIDsList);
        return relatedOpenFileRecordsListInfo;
    }
    
    public List<Member__c> getMemberDesignation(String userId){
        memberDesignationList = poQueryObj.getMemberDesignation(userId);
        return memberDesignationList;
    }
    
    public Integer getFilesRelatedToProductionOrderCount(string orderId){
        CountTotalRecords = poQueryObj.getFilesRelatedToProductionOrderCount(orderId);
        return CountTotalRecords;
    }
    
     public List<Files__c> getFilesRelatedToProductionOrderWithoutPage(String orderID){
         fileList = poQueryObj.getFilesRelatedToProductionOrderWithoutPage(orderID);
         return fileList;
     }
      // Method to retrieve all files related to input order id
    public List<Files__c> getFilesRelatedToProductionOrder(string orderId){
        fileList = poQueryObj.getFilesRelatedToProductionOrder(orderId);
        return fileList;
    }
    
    public List<Files__c> getChildFilesRecordsInfo(List<id> FileIDsList){
        fileList2 = poQueryObj.getChildFilesRecordsInfo(FileIDsList);
        return fileList2;
    }

}