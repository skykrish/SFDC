/**********************************************************************************
*   Class               :       clsTestEPMS_AddPerformanceRating                  *
*   Created Date        :       05/04/2016                                        *          
*   Description         :       Test Class for EPMS_AddPerformanceRating          *
**********************************************************************************/
@istest
Public class clsTestEPMS_AddPerformanceRating{


    public static testMethod void PerformanceRatingMethod() {
   
        File_Categories__c FileCat = new File_Categories__c();
        FileCat.Name ='A';
        FileCat.Standard_OptionalCost_Per_file__c=20.45;
        FileCat.Standard_Regular_Cost_per_File__c=230.45;
        FileCat.Standard_Time_per_File_Max__c=2.0;
        FileCat.Standard_Time_per_File_Min__c=0.0;
        insert FileCat;


        Performance_Rating__c pt1= new Performance_Rating__c();
        pt1.name='Test';
        pt1.File_Category__c=FileCat.id;
        pt1.File_Performance_Stf_Min__c= 2.00 ;
        pt1.File_Performance_Stf_Max__c= 4.00 ;
        insert pt1;

        Test.StartTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(pt1);

        EPMS_AddPerformanceRating epms1 = new EPMS_AddPerformanceRating(sc);
        epms1.valueName = pt1.name;
        epms1.saveChanges();
        epms1.Reset();

        epms1.performWrap[0].valuemin = '10';
        epms1.performWrap[0].valuemax = '18';

        epms1.valueName = 'CLASS-VI';
        epms1.saveChanges();
        epms1.Reset();

        epms1.performWrap[0].valuemin = null;
        epms1.performWrap[0].valuemax = '18';
        epms1.valueName = 'CLASS-XII';
        epms1.saveChanges();
        epms1.Reset();

        epms1.performWrap[0].valuemin = '10';
        epms1.performWrap[0].valuemax = null;
        epms1.valueName = 'CLASS-X';
        epms1.saveChanges();
        epms1.Reset();

        File_Categories__c FileCatB = new File_Categories__c();
        FileCatB.Name ='B';
        FileCatB.Standard_OptionalCost_Per_file__c=20.45;
        FileCatB.Standard_Regular_Cost_per_File__c=230.45;
        FileCatB.Standard_Time_per_File_Max__c=4.0;
        FileCatB.Standard_Time_per_File_Min__c=2.0;
        insert FileCatB;

        Performance_Rating__c pt2= new Performance_Rating__c();
        pt2.name='Test';
        pt2.File_Category__c=FileCatB.id;
        pt2.File_Performance_Stf_Min__c= 2.00 ;
        pt2.File_Performance_Stf_Max__c= 4.00 ;
        insert pt2;


        ApexPages.StandardController sc2 = new ApexPages.StandardController(pt2);

        EPMS_AddPerformanceRating epms2 = new EPMS_AddPerformanceRating(sc2);
        epms2.saveChanges();
        epms2.Reset();
        
        // Both Minimum and Maximum is equal
        epms2.performWrap[0].valuemin = '18';
        epms2.performWrap[0].valuemax = '18';
        epms2.valueName = 'CLASS-II';
        epms2.saveChanges();
        epms2.Reset();
        
        // Both Minimum is greater than Maximum    
        epms2.performWrap[0].valuemin = '18';
        epms2.performWrap[0].valuemax = '10';
        epms2.valueName = 'CLASS-III';
        epms2.saveChanges();
        epms2.Reset();

        epms2.performWrap[0].valuemin = '';
        epms2.performWrap[0].valuemax = '';
        epms2.valueName = 'CLASS_B';
        epms2.saveChanges();
        epms2.Reset();

        epms2.performWrap[0].valuemin = 'AAAA';
        epms2.performWrap[0].valuemax = 'BBB';
        epms2.valueName = 'CLASS_BA';
        epms2.saveChanges();
        epms2.Reset();

        epms2.performWrap[0].valuemin = null;
        epms2.performWrap[0].valuemax = null;
        epms2.valueName = 'aaaaaaaaa';
        epms2.saveChanges();
        epms2.Reset();
        
        Test.StopTest();

     }
}