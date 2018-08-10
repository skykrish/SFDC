/*************************************************************************************
*   Class               :       Test_EPMS_Anken_ClassificationExcel                  *
*   Created Date        :       13/04/2016                                           *           
*   Description         :       Test class for EPMS_AnkenClassificationsExportExcel  *
*************************************************************************************/

@isTest
public class Test_EPMS_Anken_ClassificationExcel {
   
    static testmethod void EPMS_AnkenClassificationsExportExcel(){
    
        Account testAcc = new Account();
        testAcc.Name='Test';
        insert testAcc;

        Anken__c firstOrder = new Anken__c();
        firstOrder.KokyakuName__c =testAcc.Id;
        insert firstOrder;

        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;

        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testsubra@mbo.in';
        insert usermail;

        Employee_Country_Code__c tRecord= new Employee_Country_Code__c();
        tRecord.Name='India';
        tRecord.Country_Initial_Letter__c='M';
        insert tRecord;    


        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists@gmail.com';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        member.Status__c='Active';
        insert member; 


        File_Categories__c fc= new File_Categories__c();
        fc.Name ='A';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        insert fc;
        
        set<string> filecat = new set<string>();
        filecat.add(fc.Name);
        
        Production_Order__c firstPo = new Production_Order__c();
        firstPo.Name ='O0002530';
        firstPo.Production_Order_Status__c ='New';
        firstPo.Anken_Order__c=firstOrder.id;
        firstPo.Client_Name__c  = firstOrder.KokyakuName__c;
        firstPo.Production_Order_TAT__c=system.now()+10;
        firstPo.Mbo_Location__c = location.Id;
        insert firstPo;

        List<Files__c> fileList = new List<Files__c>();
        for(Integer i=1;i<=5;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_'+i;
            file.Production_Order__c =firstPo.id;
            file.File_Category_Code__c =fc.id;
            file.Status__c ='Approved';
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            file.File_Type__c = 'Image';
            file.Dir_File_name__c = '/share/JavaDev/Input/20160322/O0002530/4._t.jpg';
            file.File_URL__c ='/share/JavaDev/Input/20160322/O0002530/4._t.jpg';  
            file.Member__c = member.Id;
            
            fileList.add(file);
        }
        insert fileList;

        Test.startTest();
        apexpages.currentpage().getparameters().put('id',firstPo.id);
        EPMS_AnkenClassificationsExportExcel ankExportExcel = new EPMS_AnkenClassificationsExportExcel();
        // Call the service class method
        EPMS_AnkenService_Class serviceAnken = new EPMS_AnkenService_Class();
        /*
        
        */
        //serviceAnken.getPOrecord(firstPo.Name);
        serviceAnken.getProductionOrderrecord(firstPo.Id);
        serviceAnken.getallFiles(firstPo.Id);
        serviceAnken.getdirFiles(fileList[0].Name,firstPo.Id);
        //serviceAnken.getAllCategory(filecat);
        serviceAnken.getCatFiles(fc.Name,firstPo.Id);
        
        
    }
}