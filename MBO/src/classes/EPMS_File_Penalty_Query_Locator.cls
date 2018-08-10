/****************************************************************************
*   Class               :       File Penalty Assignment Query Locator       *
*   Created Date        :       15/12/2015                                  *           
*   Description         :       To return the requested Result              *
*                               based on the request by service class       *
*                               will be used as the Common Class            *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/

public class EPMS_File_Penalty_Query_Locator{

    public List<Files__c> fileInformation = null;
    public List<Mistakes__c> mistakeInformation = null;
    
    // Method to retrieve the file information for input file ids
    
    public List<Files__c> getFileInformation(List<string> ids){
        if(ids != null && ids.size() > 0){
            fileInformation = [SELECT id,Name,Production_Order_Name__c,QCIncharge__c,File_Auto_Number__c,File_Location__c,Member__c,
                Production_Order__r.Mbo_Location__c,Member_Assigned__c,Penalty__c,Mistake__c FROM Files__c WHERE Id = :ids];
        }
        return fileInformation;
    }
    
    public List<Mistakes__c> getMistakeInformation(string mistakeCategory, string mistake, Id fileLocationId){
        if(mistake != null && mistakeCategory != null && fileLocationId != null){
            mistakeInformation = [select id,Name,Location__c from Mistakes__c where MIstake_Category__c =: mistakeCategory AND Mistake__c=:mistake AND Location__c=: fileLocationId];
        }
        return mistakeInformation;
    }
    

}