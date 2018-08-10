/**********************************************************************************
*   Class               :       TEST_EPMS_UTIL                                    *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_UTIL                          * 
**********************************************************************************/

@isTest
global class TEST_EPMS_UTIL{

   static testMethod void testutil()
   {
        EPMS_UTIL util = new EPMS_UTIL();
        util.sampleTestMethod();
		EPMS_UTIL.ignoreFileNameSpecialCharacters('abcd12sf123$hg&q*!z');
        string test1=EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME;
        string test2=EPMS_UTIL.EPMS_SALES_REGION_PROFILE_NAME;
        string test3=EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME;
        string test4=EPMS_UTIL.EPMS_SHIFT_ADMIN_PROFILE_NAME;
        string test5=EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME;
        string test6=EPMS_UTIL.EPMS_QC_PROFILE_NAME;
        string test7=EPMS_UTIL.EPMS_ARTIST_PROFILE_NAME;
        string test8=EPMS_UTIL.EPMS_SALES_REGION_ROLE_NAME;
        string test9=EPMS_UTIL.EPMS_ACTIVE_STATUS;
        string test10=EPMS_UTIL.EPMS_INACTIVE_STATUS;
        string test11=EPMS_UTIL.EPMS_SALES_REGION_DES;
        string test12=EPMS_UTIL.EPMS_PRO_ADMIN_DES;
        string test13=EPMS_UTIL.EPMS_SHIFT_ADMIN_DES;
        string test14=EPMS_UTIL.EPMS_TEAM_DES;
        string test15=EPMS_UTIL.EPMS_QC_DES;
        string test16=EPMS_UTIL.EPMS_ARTIST_DES;
        string test17=EPMS_UTIL.EPMS_PHASE1_USERGROUP_NAME;
        string test18=EPMS_UTIL.EPMS_PHASE2_USERGROUP_NAME;
        string test19=EPMS_UTIL.EPMS_SHIFT_SETTING_TYPE;
        string test20=EPMS_UTIL.EPMS_TEAM_SETTING_TYPE;
        string test21=EPMS_UTIL.EPMS_SHIFT_ASSIGNMENT_TYPE;
        string test22=EPMS_UTIL.EPMS_ASSIGNED_TYPE;
        string test23=EPMS_UTIL.EPMS_UNASSIGNED_TYPE;
        string test24=EPMS_UTIL.EPMS_US_TimeZoneSidKey;
        string test25=EPMS_UTIL.EPMS_INDIA_TimeZoneSidKey;
        string test26=EPMS_UTIL.EPMS_JAPAN_TimeZoneSidKey;
        string test27=EPMS_UTIL.EPMS_AFRICA_TimeZoneSidKey;
        string test28=EPMS_UTIL.EPMS_US_LocaleSidKey;
        string test29=EPMS_UTIL.EPMS_JAPAN_LocaleSidKey;
        string test30=EPMS_UTIL.EPMS_JAPAN_LanguageLocaleKey;
        string test31=EPMS_UTIL.EPMS_US_LanguageLocaleKey;
        string test32=EPMS_UTIL.EPMS_EmailEncodingKey; 
        
        
    }
}