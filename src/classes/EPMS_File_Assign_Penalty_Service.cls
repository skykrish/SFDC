/****************************************************************************
*   Class               :       EPMS File Assign Penalty Service            *
*   Created Date        :       21/01/2016                                  *           
*   Description         :       To Communicate with the  query locator      *
*                               and return the fetched result set           *
*                                                                           *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/


public class EPMS_File_Assign_Penalty_Service{

    public List<Files__c> fileInformation = null;
    public List<Mistakes__c> mistakeInformation = null;
    
    // Call the File : Assign Penalty & Skip Penalty Query Locator
    
    EPMS_File_Penalty_Query_Locator penaltyQueryObj = new EPMS_File_Penalty_Query_Locator();
    
    // Method to retrieve the file information for input file ids
    
    public List<Files__c> getFileInformation(List<string> ids){
        fileInformation = penaltyQueryObj.getFileInformation(ids);
        return fileInformation;
    }
    
    public List<Mistakes__c> getMistakeInformation(string mistakeCategory, string mistake, Id fileLocationId){
        mistakeInformation = penaltyQueryObj.getMistakeInformation(mistakeCategory,mistake,fileLocationId);
        return mistakeInformation;
    }
}