/****************************************************************************
*   Class               :     EPMS_ViewClassification_Service              *
*   Created Date        :      21/01/2016                                  *           
*   Description         :      To Communicate with the  query locator      *
*                               and return the fetched result set          *
*                                                                          *
*   Created By          :                                                  *                       
*   Version             :      1.0                                         *            
/***************************************************************************/


public with sharing class EPMS_ViewClassification_Service{

    public Production_Order__c prodOrderInformation = null;
    public List<Files__c> fileList = null;
    public List<Files__c> fileStatusList = null;   
    public List<Files__c> fileToOpenList = null;
    public List<Files__c> relatedfileList = null;
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
    
    EPMS_ViewClassification_QueryLocator poQueryObj = new EPMS_ViewClassification_QueryLocator();
    
    
    // Method to retrieve all files related to input order id
    public List<Files__c> getFilesRelatedToProductionOrder(string orderId,Integer QueryLimit,Integer OffsetSize, String sortChoice, String sortType,string catName,string status){
        fileList = poQueryObj.getFilesRelatedToProductionOrder(orderId,QueryLimit,OffsetSize,sortChoice,sortType,catName,status);
        return fileList;
    }
    
    
    
    // Method to retrieve the production order information for input order ids
    
    public Production_Order__c getProdOrderDetails(string orderId){
    system.debug('-----POName-----'+orderId);
        prodOrderInformation = poQueryObj.getProdOrderDetails(orderId);
        return prodOrderInformation;
    }
    
    // Method to retrieve all files related to input order id
    public List<Files__c> getFilesRelatedToProductionOrder(string orderId,Integer QueryLimit,Integer OffsetSize, String sortChoice,String catName){
        fileList = poQueryObj.getFilesRelatedToProductionOrder(orderId,QueryLimit,OffsetSize,sortChoice,catName);
        return fileList;
    }
    
    // Method to retrieve all files status information
    
    public List<Files__c> getFilesStatusList(List<Files__c> filePopList){
        fileStatusList = poQueryObj.getFilesStatusList(filePopList);
        return fileStatusList;
    }   
    
      
    
    // Method to retrieve the files list related to particular order
    
    public List<Files__c> getFilesListRelatedToProductionOrder(String orderID,string catName){
        relatedfileList = poQueryObj.getFilesListRelatedToProductionOrder(orderID,catName);
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
        
    public List<Files__c> getFilesRecords(List<Id> FileIDsList){
        relatedFileRecordsList = poQueryObj.getFilesRecords(FileIDsList);
        return relatedFileRecordsList;
    }
    
    public List<Files__c> getFilesRecordsInfo(List<Files__c> FileList){
        relatedFileRecordsListInfo = poQueryObj.getFilesRecordsInfo(FileList);
        return relatedFileRecordsListInfo;
    }
    
   
    
    public Integer getFilesRelatedToProductionOrderCount(string orderId,string catName,string status){
        CountTotalRecords = poQueryObj.getFilesRelatedToProductionOrderCount(orderId,catName,status);
        return CountTotalRecords;
    }
    
      // Method to retrieve all files related to input order id
    public List<Files__c> getFilesRelatedToProductionOrder(string orderId,string catName,string status){
        fileList = poQueryObj.getFilesRelatedToProductionOrder(orderId,catName,status);
        return fileList;
    }
    
    public List<Files__c> getChildFilesRecordsInfo(List<id> FileIDsList){
        fileList2 = poQueryObj.getChildFilesRecordsInfo(FileIDsList);
        return fileList2;
    }

}