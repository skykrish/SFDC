/**********************************************************************************
*   Class               :       EPMS_UTIL                                         *
*   Created Date        :       08/08/2016                                        *           
*   Description         :       Common utility class for EPMS Applications        *
**********************************************************************************/


global with sharing class EPMS_UTIL{

    // Profiles constant variables
    public void sampleTestMethod() {}
    
    global static final String EPMS_SYS_ADMIN_PROFILE_NAME= 'System Administrator';
    global static final String EPMS_SALES_REGION_PROFILE_NAME= 'Sales Region';
    global static final String EPMS_PROD_ADMIN_PROFILE_NAME= 'Production Administrator';
    global static final String EPMS_SHIFT_ADMIN_PROFILE_NAME= 'Shift Administrator';
    global static final String EPMS_TEAM_LEAD_PROFILE_NAME= 'Team Leader';
    global static final String EPMS_QC_PROFILE_NAME= 'Quality Control';
    global static final String EPMS_ARTIST_PROFILE_NAME= Label.EPMS_MEMBER_DESIG_OPERATOR_PS; 
    global static final String EPMS_ITADMIN_PROFILE_NAME= 'IT Administrator';
    global static final String EPMS_COUNTRYADMIN_PROFILE_NAME= 'Country Administrator';
    global static final String EPMS_FILEESTIMATOR_PROFILE_NAME= 'File Estimator';
    global static final String EPMS_FULLTIMEEMPLOYEESJAPAN_PROFILE_NAME = 'Full-time Employees (Japan)';
    
    // Roles constant variables
    
    global static final String EPMS_SALES_REGION_ROLE_NAME= 'Sales Region';
    
    // member designation constant variables
    
    global static final String EPMS_ACTIVE_STATUS= 'Active';
    global static final String EPMS_INACTIVE_STATUS= 'Inactive';
    global static final String EPMS_DEPUTED_STATUS= 'Deputed';

    global static final String EPMS_SALES_REGION_DES= 'Sales Region';
    global static final String EPMS_PRO_ADMIN_DES= 'Production Administrator';
    global static final String EPMS_SHIFT_ADMIN_DES= 'Shift Administrator';
    global static final String EPMS_TEAM_DES= 'Team Leader';
    global static final String EPMS_QC_DES= 'Quality Control';
    global static final String EPMS_ARTIST_DES= Label.EPMS_MEMBER_DESIG_OPERATOR_PS;
    global static final String EPMS_FM_DES= 'File Managers';
    global static final String EPMS_HOUSEKEEPER_DES= 'House Keeper';
    global static final String EPMS_ITADMIN_DES= 'IT Administrator';
    global static final String EPMS_FILEESTIMATOR_DES = 'File Estimator';
    
    // User Group constant variables
    global static final String EPMS_PHASE1_USERGROUP_NAME= 'MBOI Phase-1';
    global static final String EPMS_PHASE2_USERGROUP_NAME= 'MBOI Phase-2';
    global static final String EPMS_PHASE3_USERGROUP_NAME= 'MBO - Phase3';
    global static final String EPMS_PHASE1_JAPAN_NAME ='MBO - Phase1-Japan';
    global static final String EPMS_PHASE_JAPAN_NAME ='Media Backoffice, Inc';
    global static final String EPMS_PHASE1_AFRICA_NAME ='MBO Phase Africa';
    
    //Shift assignment constant variables    
   
    global static final String EPMS_SHIFT_SETTING_TYPE= 'Shift';
    global static final String EPMS_TEAM_SETTING_TYPE= 'Team';
    global static final String EPMS_SHIFT_ASSIGNMENT_TYPE= 'Shift';
    global static final String EPMS_ASSIGNED_TYPE= 'Assigned';
    global static final String EPMS_UNASSIGNED_TYPE='Unassigned';
 
     // user creation constant variables
   
    
    global static final String EPMS_US_TimeZoneSidKey = 'America/Los_Angeles';
    global static final String EPMS_INDIA_TimeZoneSidKey = 'Asia/Kolkata';
    global static final String EPMS_JAPAN_TimeZoneSidKey = 'Asia/Tokyo';
    global static final String EPMS_AFRICA_TimeZoneSidKey = 'Africa/Cairo';
    
    global static final String EPMS_US_LocaleSidKey = 'en_US';
    global static final String EPMS_JAPAN_LocaleSidKey = 'ja';
    
    global static final String EPMS_JAPAN_LanguageLocaleKey = 'ja';
    global static final String EPMS_US_LanguageLocaleKey = 'en_US';
    global static final String EPMS_EmailEncodingKey='UTF-8'; 
    
    //Anken Status constants
    
    global static final String EPMS_OrderOutsourcedStatus_Anken='Order Outsourced';
    global static final String EPMS_UploadedStatus_Anken='Uploaded';
    
    global static final String EPMS_TeamAssignStatus='Not Yet Assigned';
    global static final String EPMS_NWStatus='NW';
    global static final String EPMS_AbsentStatus='A';
    global static final String EPMS_DeputedStatus='D';
    global static final String EPMS_PresentStatus='P';
    global static final String EPMS_LeaveStatus='L';
    
    global static final String EPMS_DB='%.db';
    global static final String EPMS_BRIDGE='%.BridgeSort';
    global static final String EPMS_STORE='%.DS_store';
    
    global static final String EPMS_Job_Clipping= 'Clipping';

    global static String ignoreFileNameSpecialCharacters(String filename){
        
        system.debug(' Input File Name : ' + filename);
        String ignoreSplCharInName  = filename.replace('\'','&#39;');
        ignoreSplCharInName = ignoreSplCharInName.replace('\\','\\\\');
        ignoreSplCharInName = ignoreSplCharInName.replace('\"','&#34;');
        system.debug(' Ignored Special Character File Name : ' + ignoreSplCharInName);
        return ignoreSplCharInName;
    
    }

}