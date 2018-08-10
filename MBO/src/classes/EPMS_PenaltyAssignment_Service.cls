/*******************************************************************************************
*   Class               :       EPMS_PenaltyAssignment_Service                              *
*   Created Date        :       14/12/2017                                                  *           
*   Description         :       This Web service is used to send Penalty information        * 
*                               from Tracker to Salesforce and update it in salesforce side *
*                       :       EPMSSF-522, EPMSSF-519                                      *
*********************************************************************************************/

@RestResource(urlMapping='/PenaltyAssignment_Service/*') //https://cs58.salesforce.com/services/apexrest/PenaltyAssignment_Service
global with sharing class EPMS_PenaltyAssignment_Service {
 
    @HttpPost
    global static FileWrapper doPost(String fileid, String mistakeNo, String locationName, String SkipPenalty, String QCComments, String memberId) {
                                        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        FileWrapper response = new FileWrapper();
        
        system.debug('************ fileid ********* :' + fileid);
        system.debug('************ mistakeNo ********* :' + mistakeNo);
        system.debug('************ locationName *********' + locationName);
        system.debug('************ SkipPenalty *********' + SkipPenalty);
        system.debug('************ QCComments *********' + QCComments);
        system.debug('************ memberId *********' + memberId);
        
        Mistakes__c mistakeObj = new Mistakes__c();
        Penalty_Assignment__c penaltyObj = new Penalty_Assignment__c();
        Files__c fileObj = new Files__c();
        Member__c member = new Member__c();
        String memberEmpId = '';//Emp_ID__c
        boolean insertPenalty = false;
        List<String> qcCommentsList = new list<String>();
        //String PIPE_SEPARATOR = '&#124;';
        String PIPE_SEPARATOR = '\\|';
        
        if (mistakeNo != null) {
            mistakeObj = [select Id, Name from Mistakes__c where Name =: mistakeNo Limit 1];
                
            if (fileid != null) {
                fileObj = [select Id from Files__c where File_Auto_Number__c =: fileid Limit 1];
            }
            
            if (memberId != null){
                member = [select Id, Emp_ID__c from Member__c where Id =: memberId];
            }           
                 
            if (mistakeObj != null) {    
                if (SkipPenalty != null){
                    if (SkipPenalty == '1') {
                        penaltyObj.Is_Skipped_File__c = true;
                    } else if (SkipPenalty == '0') {
                        penaltyObj.Is_Skipped_File__c = false;
                    }
                }
                
                if (fileObj != null) {
                    penaltyObj.File_Name__c = fileObj.Id;
                }
                
                if (memberId != null){
                    penaltyObj.Member__c = memberId;
                }
                
                if (QCComments != null) {
                    qcCommentsList = QCComments.split(PIPE_SEPARATOR);
                }
                
                system.debug('********* qcCommentsList Size : ' + qcCommentsList.size());
                system.debug('********* qcCommentsList : ' + qcCommentsList);
                
                if (qcCommentsList != null & qcCommentsList.size() > 2) {
                    QCComments = qcCommentsList.get(0) + '<BR>' + qcCommentsList.get(1) + '<BR>QC Comments:-<BR>' + qcCommentsList.get(2);
                    //QCComments = qcCommentsList.get(0) + '<BR>' + qcCommentsList.get(1) + '<BR>Qc Comments:-<BR>' + qcCommentsList.get(2);                    
                } else if (qcCommentsList != null & qcCommentsList.size() == 2) {
                    QCComments = qcCommentsList.get(0) + '<BR>' + qcCommentsList.get(1);
                }
                
                system.debug('********* Formated QCComments : ' + QCComments);
                
                penaltyObj.Mistake_Id__c = mistakeObj.id;
                penaltyObj.Member_Location__c = locationName;
                penaltyObj.Comments__c = QCComments;
                //penaltyObj.Is_Penalty_for_Artist__c = true;
                insertPenalty = true;
            }
        }   
            
        try {
            if (insertPenalty) {
                system.debug('************ penaltyObj *********' + penaltyObj);             
                insert penaltyObj;
                response.status = 'Success';
            }        
        
        } catch(Exception e) {
                system.debug('-------------Exception-----------'+e);
                response.status = 'Problem in inserting Penalty';                                                 
        }
        
        system.debug('-----------final response for Insert Penalty ---------------- : '+response);
        return response;
    }
    
    global class FileWrapper {        
        public String status;        
        public FileWrapper() {}
    }    
}