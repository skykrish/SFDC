/**********************************************************************************
*   Class               :       EPMS_NewFTPSettings                                *
*   Created Date        :       13/04/2016                                         *           
*   Description         :       Controller for New FTP Settings creation           *
**********************************************************************************/

public class EPMS_NewFTPSettings
{
    public String basepath {get;set;}
    public String SettingName {get;set;}
    public String HostName {get;set;}
    public String FtpPort {get;set;}
    public String FtpUserName {get;set;}
    public String FtpPassword {get;set;}
    public String ClientFTPFileInputLocation {get;set;}
    public String ClientFTPFileOutputLocation {get;set;}
    public String SambaUsername {get;set;}
    public String SambaPassword {get;set;}
    public String SambaFileInputLocation {get;set;}
    public String SambaFileOutputLocation {get;set;}
    public String fileserversambafolderlocation {get;set;}
    public String fileservernodejsportthumbnailaccess {get;set;}
    public String fileservernodejsportinsfileaccess {get;set;}
    public string selectvalue{get;set;}
    public string selectgroupname{get;set;}
    public String redirectShift { get; set; }
    Public String fileServerHost {get;set;}
    public Map<Id, String> saleRegionGroupNames {get;set;}
    
    //constructor
    public EPMS_NewFTPSettings()
    {
        Schema.DescribeSObjectResult result = Shift_Assignments__c.SObjectType.getDescribe();
        basepath = ApexPages.currentPage().getParameters().get('type');     
        String sfUrl=URL.getSalesforceBaseUrl().getHost();
        redirectShift = 'https://'+sfUrl+'/'+result.getKeyPrefix();
        saleRegionGroupNames = new Map<Id, String>();
    }
    
    //instance for shift assignment service 
    EPMS_Shift_Assignment_Service_New newService = new EPMS_Shift_Assignment_Service_New();
    
    //Querying public groups
    public List<SelectOption> getlocationgroup(){       
         List <SelectOption> options  = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         list<Group> grt    = new list<Group>();
         grt = [SELECT Id, Name FROM Group WHERE Name IN ('Sales Region Africa','Sales Region India','Sales Region Japan','Sales Region US')];
         if(grt != null && grt.size() > 0){
             for(Group group2 :grt){
                options.add(new SelectOption(group2.Id,group2.Name));
                saleRegionGroupNames.put(group2.Id,group2.Name);
             }
         }
         
        return options;
    }
    
    //Querying locations
    public List<SelectOption> getlocation(){         
         List <SelectOption> options  = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         for(Location__c locations:newService.getAllLocations()){
            options.add(new SelectOption(locations.Id,locations.Name));
         }
        return options;
    }

    //getting existing FTP Settings
    public void displayExistingSetting(){
        if(selectgroupname != null && selectvalue != null){
          
            if(saleRegionGroupNames != null ){
                String groupNameSelected = saleRegionGroupNames.get(selectgroupname);
            
                List<Settings__c> existingSettingList = null;
                if(groupNameSelected != null){
                    existingSettingList = [SELECT Id, Name , Host_Name__c, Ftp_Port__c,Ftp_User_Name__c, Ftp_Password__c, Client_FTP_File_Input_Location__c, Client_FTP_File_Output_Location__c,
                                        Samba_Username__c,Samba_Password__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,file_server_samba_folder_location__c,file_server_nodejs_port_thumbnail_access__c,file_server_nodejs_port_ins_file_access__c,Service_File_Assignments__c,Service_File_Categories__c,Service_File_AssignmentsQC__c,Service_FileManager_setting__c,Service_FileManager_settingTracker__c,Service_UpdateForFiles__c, file_server_host__c, Group_Name__c, Location__c FROM Settings__c WHERE Group_Name__c =: groupNameSelected AND Location__c=: selectvalue];
                
                }
              
                if(existingSettingList != null  && existingSettingList.size() > 0){             
                    
                    SettingName = existingSettingList[0].Name;
                    HostName = existingSettingList[0].Host_Name__c;
                    FtpPort = existingSettingList[0].Ftp_Port__c;
                    FtpUserName = existingSettingList[0].Ftp_User_Name__c;
                    FtpPassword = '********';
                    ClientFTPFileInputLocation = existingSettingList[0].Client_FTP_File_Input_Location__c;
                    ClientFTPFileOutputLocation = existingSettingList[0].Client_FTP_File_Output_Location__c;
                    SambaUsername = existingSettingList[0].Samba_Username__c;
                    SambaPassword = existingSettingList[0].Samba_Password__c;
                    SambaFileInputLocation = existingSettingList[0].Samba_File_Input_Location__c;
                    SambaFileOutputLocation = existingSettingList[0].Samba_File_Output_Location__c;
                    fileserversambafolderlocation = existingSettingList[0].file_server_samba_folder_location__c;
                    fileservernodejsportthumbnailaccess = existingSettingList[0].file_server_nodejs_port_thumbnail_access__c;
                    fileservernodejsportinsfileaccess = existingSettingList[0].file_server_nodejs_port_ins_file_access__c;
                    selectvalue = existingSettingList[0].Location__c;
                    selectgroupname = selectgroupname;
                    fileServerHost = existingSettingList[0].file_server_host__c;

                } else {
                    
                    SettingName = '';
                    HostName = '';
                    FtpPort = '';
                    FtpUserName = '';
                    FtpPassword = '';
                    ClientFTPFileInputLocation = '';
                    ClientFTPFileOutputLocation = '';
                    SambaUsername = '';
                    SambaPassword = '';
                    SambaFileInputLocation = '';
                    SambaFileOutputLocation = '';
                    fileserversambafolderlocation = '';
                    fileservernodejsportthumbnailaccess = '';
                    fileservernodejsportinsfileaccess = '';
                    selectvalue = selectvalue;
                    selectgroupname = selectgroupname;
                    fileServerHost = '';
                
                }
            }
        } else {
            SettingName = '';
            HostName = '';
            FtpPort = '';
            FtpUserName = '';
            FtpPassword = '';
            ClientFTPFileInputLocation = '';
            ClientFTPFileOutputLocation = '';
            SambaUsername = '';
            SambaPassword = '';
            SambaFileInputLocation = '';
            SambaFileOutputLocation = '';
            fileserversambafolderlocation = '';
            fileservernodejsportthumbnailaccess = '';
            fileservernodejsportinsfileaccess = '';
            selectvalue = selectvalue;
            selectgroupname = selectgroupname;
            fileServerHost = '';
        }
        
    }

    //save settings
    public void SaveChanges()
    {

        if(String.isEmpty(SettingName)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Setting is Required To Process the Request'));
        }else{
            list<Settings__c> existingservices = new List<settings__c>();
            existingservices = [select id,Name,Service_File_Assignments__c,Service_File_Categories__c,Service_File_AssignmentsQC__c,Service_FileManager_setting__c,Service_FileManager_settingTracker__c,
                                Service_UpdateForFiles__c from Settings__c where (Service_File_Assignments__c!=null AND Service_File_Categories__c!=null AND Service_File_AssignmentsQC__c!=null AND 
                                Service_FileManager_setting__c!=null AND Service_FileManager_settingTracker__c!=null AND Service_UpdateForFiles__c!=null  ) ];
                
                if(selectgroupname != null && selectvalue != null){           
                    if(saleRegionGroupNames != null ){
                        String groupNameSelected = saleRegionGroupNames.get(selectgroupname);                  
                        List<Settings__c> existingSettingList = null;
                        if(groupNameSelected != null){
                            existingSettingList = [SELECT Id, Name , Host_Name__c, Ftp_Port__c,Ftp_User_Name__c, Ftp_Password__c, Client_FTP_File_Input_Location__c, Client_FTP_File_Output_Location__c,
                                                    Samba_Username__c,Samba_Password__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,file_server_samba_folder_location__c,
                                                    file_server_nodejs_port_thumbnail_access__c,file_server_nodejs_port_ins_file_access__c,Service_File_Assignments__c,Service_File_Categories__c,
                                                    Service_File_AssignmentsQC__c,Service_FileManager_setting__c,Service_FileManager_settingTracker__c,Service_UpdateForFiles__c, file_server_host__c,
                                                    Group_Name__c, Location__c FROM Settings__c WHERE Group_Name__c =: groupNameSelected AND Location__c=: selectvalue];
                        
                        }
                  
                        List<Settings__c> updateSettingRecords = new List<Settings__c>();
                        if(existingSettingList != null  && existingSettingList.size() > 0){
                            existingSettingList[0].Name  = SettingName;
                            existingSettingList[0].Host_Name__c = HostName;
                            existingSettingList[0].Ftp_Port__c =FtpPort;
                            existingSettingList[0].Ftp_User_Name__c =FtpUserName;
                            if(existingSettingList[0].Ftp_Password__c!=FtpPassword)
                            {
                                existingSettingList[0].Ftp_Password__c = EncryptedString(FtpPassword) ;
                            }
                            existingSettingList[0].Client_FTP_File_Input_Location__c = ClientFTPFileInputLocation;
                            existingSettingList[0].Client_FTP_File_Output_Location__c  =ClientFTPFileOutputLocation;
                            existingSettingList[0].Samba_Username__c = SambaUsername;
                            existingSettingList[0].Samba_Password__c  = SambaPassword;
                            existingSettingList[0].Samba_File_Input_Location__c= SambaFileInputLocation;
                            existingSettingList[0].Samba_File_Output_Location__c = SambaFileOutputLocation;
                            existingSettingList[0].file_server_samba_folder_location__c = fileserversambafolderlocation;
                            existingSettingList[0].file_server_nodejs_port_thumbnail_access__c = fileservernodejsportthumbnailaccess;
                            existingSettingList[0].file_server_nodejs_port_ins_file_access__c  = fileservernodejsportinsfileaccess ;
                            existingSettingList[0].Service_File_Assignments__c = existingservices[0].Service_File_Assignments__c;
                            existingSettingList[0].Service_File_Categories__c = existingservices[0].Service_File_Categories__c;
                            existingSettingList[0].Service_File_AssignmentsQC__c = existingservices[0].Service_File_AssignmentsQC__c;
                            existingSettingList[0].Service_FileManager_setting__c = existingservices[0].Service_FileManager_setting__c;
                            existingSettingList[0].Service_FileManager_settingTracker__c = existingservices[0].Service_FileManager_settingTracker__c;
                            existingSettingList[0].Service_UpdateForFiles__c = existingservices[0].Service_UpdateForFiles__c;
                            existingSettingList[0].Location__c= selectvalue;
                            existingSettingList[0].Group_Name__c = groupNameSelected;
                            existingSettingList[0].file_server_host__c = fileServerHost;
                            updateSettingRecords.add(existingSettingList[0]);
                            if(updateSettingRecords.size() > 0){
                                try{                                
                                    update updateSettingRecords;
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Setting has been Updated SuccessFully.'));
                                    return;
                                } catch(DmlException e){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Setting Updation has been Failed.'));
                                    return;
                                }    
                            }
                        } else {
                            String groupNameSelect = '';
                            if(saleRegionGroupNames != null ){
                                groupNameSelect = saleRegionGroupNames.get(selectgroupname);
                            }    
                            Settings__c Newsets = new Settings__c();
                            Newsets.Name  = SettingName;
                            Newsets.Host_Name__c = HostName;
                            Newsets.Ftp_Port__c =FtpPort;
                            Newsets.Ftp_User_Name__c =FtpUserName;
                            Newsets.Ftp_Password__c = EncryptedString(FtpPassword);
                            Newsets.Client_FTP_File_Input_Location__c = ClientFTPFileInputLocation;
                            Newsets.Client_FTP_File_Output_Location__c  =ClientFTPFileOutputLocation;
                            Newsets.Samba_Username__c = SambaUsername;
                            Newsets.Samba_Password__c  = SambaPassword;
                            Newsets.Samba_File_Input_Location__c= SambaFileInputLocation;
                            Newsets.Samba_File_Output_Location__c = SambaFileOutputLocation;
                            Newsets.file_server_samba_folder_location__c = fileserversambafolderlocation;
                            Newsets.file_server_nodejs_port_thumbnail_access__c = fileservernodejsportthumbnailaccess;
                            Newsets.file_server_nodejs_port_ins_file_access__c  = fileservernodejsportinsfileaccess ;
                            Newsets.Service_File_Assignments__c = existingservices[0].Service_File_Assignments__c;
                            Newsets.Service_File_Categories__c = existingservices[0].Service_File_Categories__c;
                            Newsets.Service_File_AssignmentsQC__c = existingservices[0].Service_File_AssignmentsQC__c;
                            Newsets.Service_FileManager_setting__c = existingservices[0].Service_FileManager_setting__c;
                            Newsets.Service_FileManager_settingTracker__c = existingservices[0].Service_FileManager_settingTracker__c;
                            Newsets.Service_UpdateForFiles__c = existingservices[0].Service_UpdateForFiles__c;
                            Newsets.Location__c= selectvalue;
                            NewSets.Group_Name__c = groupNameSelect;
                            NewSets.file_server_host__c = fileServerHost;
                            
                            if(NewSets!= null)
                            { 
                                try {
                                    insert NewSets;
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Setting is SuccessFully Created '));
                                    return;
                                } catch(DmlException e){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                                    return;
                                }    
                                
                            }
                        }
                    }
                }           
            }
    }
    
    
    //PASSWORD Encryption
    public String EncryptedString(string enteredPassword )
    {
        String str = enteredPassword;
        list<integer> combined = new list<integer>();
        list<integer> FinalValues = new list<integer>();
        for(integer i=0;i<str.length();i++)
        { 
         combined.add(integer.valueOf(str.charAt(i)));     
        }
        for(integer k=0;k<combined.size();k++)
        {
            FinalValues.add(integer.valueOf(combined[k]+2));    
        }
        String myChar = String.fromCharArray(FinalValues);

        return myChar;

    }
}