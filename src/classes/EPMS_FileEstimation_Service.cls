/*******************************************************************************************
*   Class               :       EPMS_FileEstimation_Service                                 *
*   Created Date        :       14/12/2017                                                  *           
*   Description         :       This Web service is used to send files from                 * 
*                               Salesforce to Tracker when status is 'Estimation Required'  *
*                       :       EPMSSF-521 Changes                                          *
*********************************************************************************************/
 
@RestResource(urlMapping='/FileEstimation_Service/*') //https://cs58.salesforce.com/services/apexrest/FileEstimation_Service
global with sharing class EPMS_FileEstimation_Service {
    
    @HttpPost
    global static FileWrapper doPost(String fileid, String fileStatus, String orderInstructions, String fileInstructions, 
                                      String filejobtitle, String fileURL, String imageDefinition, String fileCategoryCode) {
                                        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        FileWrapper response = new FileWrapper();
        system.debug('************ fileid ********* :' + fileid);
        system.debug('************ File Status ********* :' + fileStatus);
        system.debug('************ orderInstructions *********' + orderInstructions);
        system.debug('************ fileInstructions *********' + fileInstructions);
        system.debug('************ filejobtitle *********' + filejobtitle);
        system.debug('************ fileURL *********' + fileURL);
        system.debug('************ imageDefinition *********' + imageDefinition);
        system.debug('************ fileCategoryCode *********' + fileCategoryCode);

        Files__c fileObj = new Files__c();
        List<Files__c> fileList = new List<Files__c>();
        Production_Order__c po = new Production_Order__c();
 
        EPMS_RestAPIService restobj = new EPMS_RestAPIService();
        String pOId = null;
        boolean updatePO = false;
 
        if (fileStatus == Label.EPMS_FileStatus_Estimated) { // 'Estimated'                                        
            fileObj = restobj.fetchFileDetailsForUpdate(fileid);
            if (fileObj != null) {
                pOId = fileObj.Production_Order__c;
                system.debug('************ pOId *********' + pOId);
                fileObj.Order_Instructions__c = orderInstructions;
                fileObj.Image_Definition__c = imageDefinition;
                fileObj.File_Job_Titles__c = filejobtitle;
                fileObj.Status__c = Label.EPMS_Status_Awaiting_Approval;
                fileObj.Files_To_open__c = 0;
                                
                if (fileCategoryCode != null){
                    system.debug('************ fileCategoryCode *********' + fileCategoryCode);
                    File_Categories__c filecat = [Select id, name from File_Categories__c where name =: fileCategoryCode Limit 1]; 
                    if (filecat != null)                        
                        fileObj.Estimated_File_Category__c = filecat.id;
                }

            }
    
            try {                                                    
                update fileObj;
                response.status = 'Success';      
            } catch(exception e) {
                system.debug('-------------Exception-----------'+e);
                response.status = 'Problem in updating Estimation Required files';                                                 
            } 
           
        }
        
        system.debug('-----------final response for Estimation Required files update ---------------- : '+response);
        return response;
    }
    
    global class FileWrapper {        
        public String status;        
        public FileWrapper() {}
    }
}