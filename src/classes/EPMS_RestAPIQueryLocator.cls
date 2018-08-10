/********************************************************************************
*   Class               :       Rest API Query Locator                          *
*   Created Date        :       11/17/2015                                      *           
*   Description         :       To return the requested Result                  *
*                               based on the request by service class           *
*                               will be used as the Common Class                *
*   Created By          :                                                       *                       
*   Version             :       1.0                                             *
*   Modifications       :       08/05/18 - Included DeliveryManager settings    *            
/*******************************************************************************/

public with sharing class EPMS_RestAPIQueryLocator{
    
    public List<Production_Order__c> productionOrderList {get;set;}
    public List<Settings__c> SettingDetails {get;set;}
    
    /* EPMSSF-521 - Service_File_Estimation__c field and  EPMSSF-522 - Service_Penalty_Assignment__c field */
    //Return the List Of New  Production Order
    public List<Settings__c> getSettings(Id settingsID){
        try{
            SettingDetails =[select Name,Host_Name__c,file_server_nodejs_port_ins_file_access__c,Group_Name__c,Ftp_User_Name__c,Ftp_Password__c,Ftp_Port__c,Client_FTP_File_Input_Location__c,Client_FTP_File_Output_Location__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,Samba_Password__c,Samba_Username__c,file_server_nodejs_port_thumbnail_access__c,file_server_host__c,file_server_ssh_port_no__c,file_server_user_name__c,file_server_thumbnail_folder_location__c,file_server_password__c,file_server_samba_folder_location__c,Service_File_Estimation__c, Service_Penalty_Assignment__c, Service_MistakeAssignmentDetails__c, Service_Estimation_Assignment__c, Service_JobTitle_Assignment__c,  Delivery_Host_Name__c, Delivery_Ftp_User_Name__c, Delivery_Ftp_Password__c, Delivery_Output_Path__c, Delivery_Ftp_Port__c from Settings__c where location__c =:settingsID];
            
        }catch(Exception e){
            
            System.debug(e);  
        }
        return SettingDetails ;
    }
    /* EPMSSF-521 - Service_File_Estimation__c field and  EPMSSF-522 - Service_Penalty_Assignment__c field */
    public List<Settings__c> getSettingsTracker(Id settingsID){
        
        SettingDetails = [select Name,Host_Name__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,Samba_Password__c,Samba_Username__c,Service_File_Assignments__c,Service_File_Categories__c,Service_FileManager_setting__c,Service_FileManager_settingTracker__c,Service_UpdateForFiles__c,Domain_Name__c,Service_File_AssignmentsQC__c,file_server_nodejs_port_thumbnail_access__c,file_server_host__c,file_server_ssh_port_no__C,file_server_user_name__c,file_server_thumbnail_folder_location__c,file_server_password__c,file_server_samba_folder_location__c,Service_File_Estimation__c, Service_Penalty_Assignment__c, Service_MistakeAssignmentDetails__c, Service_Estimation_Assignment__c, Service_JobTitle_Assignment__c, Delivery_Host_Name__c, Delivery_Ftp_User_Name__c, Delivery_Ftp_Password__c, Delivery_Output_Path__c, Delivery_Ftp_Port__c from Settings__c where location__c =:settingsID];
        return SettingDetails ;
    }
    
    
    /* EPMSSF-572 - DeliveryManager settings details */
    public List<Settings__c> getDMSettings(Id settingsID){
        try{
            //SettingDetails =[select Name,Host_Name__c,file_server_nodejs_port_ins_file_access__c,Group_Name__c,Ftp_User_Name__c,Ftp_Password__c,Ftp_Port__c,Client_FTP_File_Input_Location__c,Client_FTP_File_Output_Location__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,Samba_Password__c,Samba_Username__c,file_server_nodejs_port_thumbnail_access__c,file_server_host__c,file_server_ssh_port_no__c,file_server_user_name__c,file_server_thumbnail_folder_location__c,file_server_password__c,file_server_samba_folder_location__c, Delivery_Host_Name__c, Delivery_Ftp_Port__c, Delivery_Ftp_User_Name__c, Delivery_Ftp_Password__c, Delivery_FTP_Input_Location__c from Settings__c where location__c =:settingsID];
            SettingDetails =[select Name, Group_Name__c, Delivery_Host_Name__c, Delivery_Ftp_Port__c,Delivery_FTP_Input_Location__c,Delivery_Ftp_User_Name__c, Delivery_Ftp_Password__c, Delivery_Output_Path__c from Settings__c where location__c =:settingsID];
        }catch(Exception e){
            
            System.debug(e);  
        }
        return SettingDetails ;
    }
    /* EPMSSF-572 - DeliveryManager settings details for Tracker */
    /*public List<Settings__c> getDMSettingsTracker(Id settingsID){

//SettingDetails = [select Name,Host_Name__c,file_server_nodejs_port_ins_file_access__c,Group_Name__c,Ftp_User_Name__c,Ftp_Password__c,Ftp_Port__c,Client_FTP_File_Input_Location__c,Client_FTP_File_Output_Location__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,Samba_Password__c,Samba_Username__c,file_server_nodejs_port_thumbnail_access__c,file_server_host__c,file_server_ssh_port_no__c,file_server_user_name__c,file_server_thumbnail_folder_location__c,file_server_password__c,file_server_samba_folder_location__c, Delivery_Host_Name__c, Delivery_Ftp_Port__c, Delivery_Ftp_User_Name__c, Delivery_Ftp_Password__c, Delivery_FTP_Input_Location__c from Settings__c where location__c =:settingsID];
SettingDetails =[select Name, Group_Name__c, Delivery_Host_Name__c, Delivery_Ftp_Port__c, Delivery_Ftp_User_Name__c, Delivery_Ftp_Password__c, Delivery_FTP_Input_Location__c, Delivery_FTP_Output_Location__c from Settings__c where location__c =:settingsID];
return SettingDetails ;
}*/    
    
    //Return the List Of New  Production Order
    public List<Production_Order__c> getProductionOrder_ForDownload(SET<String> ProductionName){
        try{
            productionOrderList = [Select id,Name,Production_Order_TAT__c  FROM Production_Order__c where Name IN : ProductionName AND (Production_Order_Status__c='New' OR Production_Order_Status__c='Pending' OR Production_Order_Status__c='Estimation Request') AND FTP_Upload_Status__c=FALSE AND Production_Order_Status__c!='Cancelled' and Production_Order_Status__c!='Completed' and Production_Order_Status__c!='Uploaded' and FTP_Download_Status__c=false and (Production_Order_Old_Status__c!='Awaiting Approval' or ReUpload__c=true) ORDER BY Production_Order_TAT__c ASC ];
            
        }catch(Exception e){
            
            System.debug(e);  
        }
        return productionOrderList ;
    }
    
    public List<Production_Order__c> getProductionOrder_Forupload(SET<String> ProductionName){
        try{
            
            productionOrderList = [Select id,Name FROM Production_Order__c where Name IN : ProductionName  AND  Production_Order_Status__c='Uploaded' and FTP_Download_Status__c=true];
            
        }catch(Exception e){
            
            System.debug(e);  
        }
        return productionOrderList ;
    }
    
    public Files__c fetchFileDetailsForUpdate(String id){
        Files__c fileRefVar = new Files__c();
        
        try{
            
            fileRefVar = [Select id, Parent_Id__c, QC_Comments__c, No_of_the_file__c,Tracker_Crashed__c,File_Job_Titles__c,TLInCharge__c,File_Category_Code__c,Status__c,File_Proccessing_Status__c,Setting__c,
                          File_Thumbnail_URL__c,Individual_Performance_Category__c,File_Preview_URL__c,Instruction__c,File_HandOver_Instructions__c,
                          File_Copy_number__c,Redo_Checked_Same_Member__c,Original_File_Id__c ,File_Type__c,File_old_Status__c,Current_Extension__c, Production_Order__c,Name,File_Auto_Number__c,  Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c, member__c, QCIncharge__c,Files_To_open__c
                          From Files__c where File_Auto_Number__c =:id Limit 1];
            system.debug('-------fileRefVar -----'+fileRefVar );            
            
        }catch(Exception e){
            
            System.debug('-------e---------'+e);  
        }
        
        return fileRefVar;
        
    }
    
    public List<Anken__c> getOrder_ForTransfer(){
        List<Anken__c> ankenList = new List<Anken__c>();
        try{
            
            //ankenList = [Select id, Name, Client_Name__c, Status__c, Anken_Box_Sync_del__c, FileServerURL_Win__c, FileServerURL_Mac__c FROM Anken__c where (Status__c =: Label.EPMS_UploadedStatus_Order OR Status__c = 'アップロード完了') Limit 2];
            ankenList = [Select id, Name, Client_Name__c, Status__c,ClientID__c,ClientPWD__c,GlobalIP__c,KokyakuName__r.KokyakuId__c,KokyakuName__r.KokyakuPw__c,KokyakuName__r.GlobalIP__c FROM Anken__c where Status__c =: Label.EPMS_ANKEN_STATUS_TRANSFERRING and KokyakuName__c='0011000000Ws2iB' and KokyakuTantosya_Main__c!=null];
            
            system.debug('---------------ankenList:' + ankenList);
            
        }catch(Exception e){
            
            System.debug('-----------restquerytest--------------'+e);  
        }
        return ankenList;
    }
    
    
}