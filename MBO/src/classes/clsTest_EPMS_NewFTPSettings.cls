/**********************************************************************************
*   Class               :       clsTest_EPMS_NewFTPSettings                       *
*   Created Date        :       19/04/2016                                        *
*   Description         :       Test Class for EPMS_NewFTPSettings                *
**********************************************************************************/

@isTest
private class clsTest_EPMS_NewFTPSettings {
    static testMethod void testEPMS_NewFTPSettings() {

        PageReference pageRef = Page.EPMS_New_FTP_Settings;

        Location__c loc= new Location__c();
        loc.Name='Test Location';
        loc.Location_Status__c='Active';
        loc.Location_Country__c='India';
        loc.Group_Name__c='TestgroupName';
        test.starttest();
        try{
            insert loc;
        }catch(Exception e){
            System.debug(e);
        }
        List<Group> groupList = new List<Group>();
        Group newgroup = new Group();
        newgroup.Name = 'Sales Region Africa';
        groupList.add(newgroup);
        Group newgroup2 = new Group();
        newgroup2.Name = 'Sales Region India';
        groupList.add(newgroup2);
        if(groupList.size() > 0){
            try{
                insert groupList;
            }catch(Exception e){
                System.debug(e);
            }
        }
        
        List<Settings__c> settingList= new List<Settings__c>();
        for(Integer i=0;i<2;i++){
            Settings__c setting = new Settings__c();
            setting.Name ='Test setting name'+i;
            setting.Location__c = loc.Id;
            setting.Service_File_Assignments__c = 'services/apexrest/File_Assignments';
            setting.Service_File_Categories__c = 'services/apexrest/File_Categories';
            setting.Service_File_AssignmentsQC__c = 'services/apexrest/File_AssignmentsQC';
            setting.Service_FileManager_setting__c = 'services/apexrest/FileManager/setting';
            setting.Service_FileManager_settingTracker__c = 'services/apexrest/FileManager/settingTracker';
            setting.Service_UpdateForFiles__c = 'services/apexrest/NewFileCopyDetails';
            settingList.add(setting);
        }
        try{
            insert settingList;
        }catch(Exception e){
            System.debug(e);
        }
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('type','assign');
        Group gr=[select Id,Name from Group where Name=:'Sales Region India' limit 1];
        
        EPMS_NewFTPSettings settings=new EPMS_NewFTPSettings();
        settings.getlocationgroup();
        settings.getlocation();
        settings.selectvalue=loc.Id;
        settings.selectgroupname=gr.Id;
        
        settings.SettingName  = 'MBOI-PH1-JAPAN FTP';
        settings.HostName = 'http://221.241.241.52';
        settings.FtpPort ='21';
        settings.FtpUserName ='mboi';
        settings.FtpPassword = 'XXXX4CsJ';
        settings.ClientFTPFileInputLocation = '/INPUT';
        settings.ClientFTPFileOutputLocation  ='/OUTPUT';
        settings.SambaUsername = '';
        settings.SambaPassword  = '';
        settings.SambaFileInputLocation= 'cifs://117.239.57.206:445/share/MBOI/Input/';
        settings.SambaFileOutputLocation = 'cifs://117.239.57.206:445/share/MBOI/Output/';
        settings.fileserversambafolderlocation = '/home/Shared';
        settings.fileservernodejsportthumbnailaccess = '8002';
        settings.fileservernodejsportinsfileaccess  = '8003' ;
        settings.selectvalue = loc.Id;
        settings.selectgroupname = gr.Id;
        settings.fileServerHost = '117.239.57.206';
        settings.SaveChanges();
       
        settings.displayExistingSetting();
        
        EPMS_NewFTPSettings settings2=new EPMS_NewFTPSettings(); 
        settings2.getlocationgroup();
        settings2.getlocation(); 
        settings2.selectvalue=loc.Id;
        settings2.selectgroupname=gr.Id;      
        Settings__c oldSetting = [select id, Name , Host_Name__c, Ftp_Port__c,Ftp_User_Name__c, Ftp_Password__c, Client_FTP_File_Input_Location__c, Client_FTP_File_Output_Location__c,
    Samba_Username__c,Samba_Password__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,file_server_samba_folder_location__c,file_server_nodejs_port_thumbnail_access__c,file_server_nodejs_port_ins_file_access__c,Service_File_Assignments__c,Service_File_Categories__c,Service_File_AssignmentsQC__c,Service_FileManager_setting__c,Service_FileManager_settingTracker__c,Service_UpdateForFiles__c, file_server_host__c, Group_Name__c, Location__c from Settings__c where Name  ='MBOI-PH1-JAPAN FTP'];

        if(oldSetting != null){
            settings2.SettingName  = oldSetting.Name;
            settings2.HostName = oldSetting.Host_Name__c;
            settings2.FtpPort = oldSetting.Ftp_Port__c;
            settings2.FtpUserName = oldSetting.Ftp_User_Name__c;
            settings2.FtpPassword= oldSetting.Ftp_Password__c;
            settings2.ClientFTPFileInputLocation  = oldSetting.Client_FTP_File_Input_Location__c;
            settings2.ClientFTPFileOutputLocation = oldSetting.Client_FTP_File_Output_Location__c;
            settings2.SambaUsername = oldSetting.Samba_Username__c;
            settings2.SambaPassword = oldSetting.Samba_Password__c;
            settings2.SambaFileInputLocation = oldSetting.Samba_File_Input_Location__c;
            settings2.SambaFileOutputLocation = oldSetting.Samba_File_Output_Location__c;
            settings2.fileserversambafolderlocation = oldSetting.file_server_samba_folder_location__c;
            settings2.fileservernodejsportthumbnailaccess = oldSetting.file_server_nodejs_port_thumbnail_access__c;
            settings2.fileservernodejsportinsfileaccess = oldSetting.file_server_nodejs_port_ins_file_access__c;
            settings2.selectvalue = oldSetting.Location__c;
            settings2.selectgroupname = gr.Id;
            settings2.fileServerHost = oldSetting.file_server_host__c;
            settings2.FtpUserName = 'mboi2';
            settings2.FtpPassword = '1234567';
            settings2.SambaUsername = 'TestRTWQ';
            settings2.fileservernodejsportthumbnailaccess = '6002';
            settings2.fileservernodejsportinsfileaccess  = '6003'; 
            settings2.displayExistingSetting();
            settings2.SaveChanges();
        }
        test.stoptest();
    }
}