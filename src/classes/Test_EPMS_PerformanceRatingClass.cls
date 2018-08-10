/**********************************************************************************
*   Class               :       Test_EPMS_PerformanceRatingClass                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_PerformanceRatingClass        *
**********************************************************************************/
@istest(seeAlldata=true)
Public class Test_EPMS_PerformanceRatingClass{
    public static testMethod void PerformanceRatingMethod() {
   
      
        File_Categories__c FileCat = new File_Categories__c();
        FileCat.Name ='MB';
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
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(pt1);
       
       
        string inputValuemax ='';
        string inputValuemin ='';
        string inputValue ='';
        string values = 'Group D@@Min-A--0.00,Min-B--2.6025##Max-A--2.00,Max-B--4';
        EPMS_PerformanceRatingClass epms1 = new EPMS_PerformanceRatingClass(sc);
        ApexPages.currentPage().getParameters().put('rating',values);
        epms1.saveRating();
        epms1.Reset();
        epms1.gotoAddPerformanceRating();
        list<EPMS_PerformanceRatingClass.Wrapfilecatcode> tu = new list<EPMS_PerformanceRatingClass.Wrapfilecatcode>();
    }
        
    Public static testMethod void negativePerformanceRatingMethod() {
       
          
        File_Categories__c FileCat = new File_Categories__c();
        FileCat.Name ='QB';
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
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(pt1);
        string inputValuemax ='';
        string inputValuemin ='';
        string inputValue ='';
        string values = 'Group C@@Min-A--0.00,Min-B--2.6025,Min-C--##Max-A--2.00,Max-B--4,Max-C--';
        EPMS_PerformanceRatingClass epms1 = new EPMS_PerformanceRatingClass(sc);
        ApexPages.currentPage().getParameters().put('rating',values);
        epms1.saveRating();
        epms1.Reset();
        epms1.gotoAddPerformanceRating();
        list<EPMS_PerformanceRatingClass.Wrapfilecatcode> tu = new list<EPMS_PerformanceRatingClass.Wrapfilecatcode>();
    }     
}