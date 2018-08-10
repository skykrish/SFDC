/**********************************************************************************
*   Class               :       EPMS_FileManager_SettingsTracker                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Webservice to get tracker settings                *
**********************************************************************************/

@RestResource(urlMapping='/FileManager/settingTracker/*')    
global with sharing class EPMS_FileManager_SettingsTracker{    
   // public String returnType {get;set;}    
    @HttpPost
    global static List<Settings__c> getFileManagerDetails() {
        List<Settings__c> SettingDetails;
      //  String returnType; 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String requestType = RestContext.request.params.get('type');   
        String DataSet=null;           
       // returnType ='Settings__c';
        List<Member__c> member;
        
        // Retrieve setting details for request
        if(userinfo.getuserid()!= null){
            
            member = [SELECT Id,Name,Location_id__c FROM Member__c WHERE User_Id__c=:String.valueOf(userinfo.getuserid()) limit 1];
            // Retrieve the setting details 
            EPMS_RestAPIService servObj = EPMS_RestAPIService.getInstance(); 
            if(requestType!=null && requestType=='Tracker'){
                SettingDetails=servObj.getSettingsTracker(member[0].Location_id__c);  
                if(member[0].id!=null)
                    {
                      updateFiles(member[0].id);
       
                    }          
            }else{
                SettingDetails=servObj.getSettings(member[0].Location_id__c);          
            }


            if(requestType!=null && requestType=='Tracker'){
                for(Settings__c SettingData : SettingDetails){
                    SettingData.Samba_File_Input_Location__c=SettingData.Samba_File_Input_Location__c.replace('cifs://','');
                    SettingData.Samba_File_Output_Location__c=SettingData.Samba_File_Output_Location__c.replace('cifs://','');
                }
            }

            // Convert the query result into JSON Format
            if(SettingDetails != null && SettingDetails.size() > 0){
                return SettingDetails;
            }
        }  
        return SettingDetails;    
    }
    
    
    public static void updateFiles(id memid){

        List<files__c> updateList = new List<files__c>();
        List<files__c> filesToUpdate = [Select Name,File_Auto_Number__c,QC_Comments__c,File_Job_Titles__c,Production_Order_Name__c,Parent_Id__c,No_of_the_file__c,Delivery_Extension__c,File_Location__c,File_category_id__c,File_Category_Code__c,File_Type__c,Status__c,File_old_Status__c,File_Proccessing_Status__c,TLInCharge__c,
           File_Thumbnail_URL__c,File_Preview_URL__c,Tracker_Crashed__c,File_URL__c,Files_To_open__c,Instruction__c,File_HandOver_Instructions__c,Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c,File_Copy_number__c,Original_File_Id__c,Is_File_Redo__c,Member__c,Member__r.Name,Member_Assigned__c,Current_Extension__c,File_PS_Version__c, QCIncharge__c
           from Files__c where   Member__c=:memid  AND Status__c ='WIP' AND Files_To_open__c=0 and file_type__c='image'];
        if(filesToUpdate.size()>0){
        for(Files__c fls:filesToUpdate){
            fls.Status__c ='Assigned';
            fls.Files_To_open__c = 1;
            fls.Tracker_Crashed__c = true;
            updateList.add(fls);           
        }
        }
        try{
            if(updateList.size()>0){
                 update updateList;
            }
           
        }catch(exception e){
                system.debug('----------errors------'+e);            
        }
        
    }
    
    
}