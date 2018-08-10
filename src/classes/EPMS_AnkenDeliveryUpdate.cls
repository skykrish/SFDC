/************************************************************************************
*   Class               :       EPMS_AnkenDeliveryUpdate                            *
*   Created Date        :       07/05/2018                                          *           
*   Description         :       Webservice to update Anken status as Delivered      *
************************************************************************************/

@RestResource(urlMapping='/DeliveryUpdate/*') //https://cs58.salesforce.com/services/apexrest/DeliveryUpdate    
global with sharing class EPMS_AnkenDeliveryUpdate{    
    @HttpPost
    global static AnkenWrapper updateAnkenStatus(String start_time, String transferred_files, String remaining_files, String total_files, String total_file_size, String end_time, String time_difference, String anken, String status,List<String> failedFiles, String file_size, String file_size_long, String speed) {
        AnkenWrapper response;
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            res.addHeader('Content-Type', 'application/json');
            response = new AnkenWrapper();
            
            // Retrieve setting details for request
            if(userinfo.getuserid()!= null && anken != null){
                system.debug('*********anken*******' + anken);
                String deliveryHistory = '';
                String deliveryHistoryTemp = '';  
                String ExactDateTime;               
                List<Anken__c> ankList = [SELECT Id, Name, Status__c,Error_Log__c,Delivery_Process_Time_Long__c FROM Anken__c WHERE Name =: anken and Status__c!='受注納品済み'];
                //Delivery_Process_Time__c
                for (Anken__c ank : ankList) {                
                    ank.Delivered_File_Count__c = Integer.valueOf(transferred_files);
                    ank.Remaining_Files_Count__c = Integer.valueOf(remaining_files);
                    ank.Total_Files_Count__c = Integer.valueOf(total_files);
                    ank.Delivery_Start_Time__c = start_time;
                    ank.Delivery_End_Time__c = end_time;
                    ank.Delivery_Time_Difference__c = time_difference;
                    
                    
                   if(failedFiles!=null){
                    for(String Str:failedFiles){
                    if(ank.Error_Log__c!=null){
                    ank.Error_Log__c = Str + ',' + '\n'+ ank.Error_Log__c;
                    }else{
                    ank.Error_Log__c = Str;
                    }
                    }
                    
                    
                    }
                    
                    if (status != null && status == 'Delivered') {
                        ank.Status__c = '受注納品済み';
                    } else {
                        ank.Status__c = status;
                    }
                    
                    deliveryHistory = ank.Delivery_Process_Time_Long__c;
                    system.debug('******deliveryHistory = ' + deliveryHistory);
                    //deliveryHistory = ank.Delivery_Process_Time__c;
                    //deliveryHistoryTemp = start_time + ' - ' + end_time + ' - ' + time_difference;
                    //deliveryHistoryTemp = transferred_files + ' - ' + remaining_files + ' - ' + total_files + ' - ' + start_time + ' - ' + end_time + ' - ' + time_difference + ' - ' + file_size + ' - ' + file_size_long + ' - ' + speed;
                    deliveryHistoryTemp = 'transferred_files:' + transferred_files + ' - remaining_files:' + remaining_files + ' - total_files:' + total_files + ' - total_file_size:' + total_file_size + ' - start_time:' + start_time + ' - end_time:' + end_time + ' - time_difference:' + time_difference + ' - file_size:' + file_size + ' - file_size_long:' + file_size_long + ' - speed:' + speed;
                    system.debug('******deliveryHistoryTemp = ' + deliveryHistoryTemp);
                    if (deliveryHistory != null) {
                        //ank.Delivery_Process_Time__c = deliveryHistoryTemp + ',' + deliveryHistory;
                        ank.Delivery_Process_Time_Long__c = deliveryHistoryTemp + '\r\n' + deliveryHistory;
                    } else {
                        //ank.Delivery_Process_Time__c = deliveryHistoryTemp;
                        ank.Delivery_Process_Time_Long__c = deliveryHistoryTemp;
                    }
                    
                    system.debug('******ank.Delivery_Process_Time_Long__c = ' + ank.Delivery_Process_Time_Long__c);
                }
                
                system.debug('*********ankList*******' + ankList);
                
                update ankList;
                response.status = 'Success';      
            } 
        } catch(exception e) { 
            system.debug('-------------Exception-----------'+e);
            
           // response.status = 'Problem in updating Anken '+e;                                                 
        } 
        system.debug('-----------final response for Anken status update ---------------- : '+response);
        return response;
    }
    
    global class AnkenWrapper {        
        public String status;        
        public AnkenWrapper() {}
    }    
}