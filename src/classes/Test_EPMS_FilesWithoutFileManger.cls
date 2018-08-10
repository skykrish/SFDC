/**********************************************************************************
*   Class               :       Test_EPMS_FilesWithoutFileManger                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_FilesWithoutFileManger        *
**********************************************************************************/

@isTest
Public class Test_EPMS_FilesWithoutFileManger{

    @testSetup static void setupTestData(){
        Pagereference pg = Page.EPMS_FilesWithoutFileManger;
    
        File_Categories__c FileCat = new File_Categories__c();
        FileCat.Name ='A';
        FileCat.Standard_OptionalCost_Per_file__c=20.45;
        FileCat.Standard_Regular_Cost_per_File__c=230.45;
        FileCat.Standard_Time_per_File_Max__c=2.0;
        FileCat.Standard_Time_per_File_Min__c=0.0;
        insert FileCat;

        Location__c location = new Location__c();
        location.Name = 'mbo test-21032016';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-21032016';
        insert location;

        Settings__c sets = new Settings__c();
        sets.Name='mbo test settings';
        sets.file_server_nodejs_port_thumbnail_access__c='8002';
        sets.Location__c =location.id;
        sets.Samba_File_Input_Location__c='cifs://172.16.6.100:445/share/JavaDev/Input/';
        sets.Samba_File_Output_Location__c='cifs://172.16.6.100:445/share/JavaDev/Output/';
        sets.file_server_host__c='172.16.6.100';
        insert sets;

        Account newAccount = new Account();
        newAccount.Name = 'SRM Test';
        insert newAccount;

        Anken__c newOrder = new Anken__c();
        newOrder.KokyakuName__c = newAccount.Id;
        insert newOrder;

        Production_Order__c po=new Production_Order__c();

        Anken__c testAnkenOrder = [SELECT Id, Name FROM Anken__c WHERE Id =: newOrder.Id];

        po.Name =testAnkenOrder.Name;
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.Location_For_Sharing__c=location.Name;
        insert po;

        Files__c file = new Files__c();
        file.File_Location__c=location.Id;
        file.Production_Order__c=po.id;
        file.Dir_File_name__c='20160411/PO-21032016/folder/pq/file-21032016.jpg';
        file.Name='file-21032016';
        file.File_Category_Code__c=FileCat.id;
        file.Status__c='New';
        file.Current_Extension__c='.jpg';
        insert file;

        EPMS_FilesWithoutFileManger epms1 = new EPMS_FilesWithoutFileManger();
          
        Files__c file1 = new Files__c();
        file1.File_Location__c=location.Id;
        file1.Production_Order__c=po.id;
        file1.Dir_File_name__c='20160411/PO-21032016/folder/pq/file-2103201612.jpg';
        file1.Name='file-2103201612';
        file1.File_Category_Code__c=FileCat.id;
        file1.Status__c='New';
        file1.Current_Extension__c='.jpg';
        insert file1;

    }
  
    public static testMethod void FilesDownloadwithoutMethod() {
    
        Test.startTest();
        
        String stringToBlob = '0032016,'+'20160411/PO-21032016/folder/pq/,'+'file-21032016,'+'.jpeg,'+'\n,'+'PO-21032016,'+'20160411/PO-21032016/folder/pq/,'+'file-21032017,'+'jpeg';
        Blob newData = Blob.valueOf(stringToBlob);
        
        Account newAccount = [SELECT Id, Name FROM Account WHERE Name = 'SRM Test'];
        
        
        Anken__c newDataAnken = [SELECT Id, Name FROM Anken__c WHERE KokyakuName__c =: newAccount.Id ];
        Production_Order__c orderInfo = [SELECT Id, Name FROM Production_Order__c WHERE Name=: newDataAnken.Name];
        String orderName2 = newDataAnken.Name;
        
        String newAnkenName = '';
        if(orderName2 != null){
            newAnkenName = orderName2.substring(2);
        }
        String stringToBlob2 =  newAnkenName +','+'folder/pq/'+ ','+'file-21032016'+','+'jpeg'+','+'\\n'+'\n'+newAnkenName+','+'folder/pq/'+','+'file-21032017'+','+'jpeg'+','+'\\n'+'\n';
        Blob newData2 = Blob.valueOf(stringToBlob2);
        EPMS_FilesWithoutFileManger epms2 = new EPMS_FilesWithoutFileManger();
        epms2.importCSVFile();
        epms2.csvFileBody = newData2;
        epms2.importCSVFile();
        Test.stopTest();
          
    }
    
    public static testMethod void FilesDownloadwithoutMethod2() {
    
        Test.startTest();
        
        Account newAccount = [SELECT Id, Name FROM Account WHERE Name = 'SRM Test'];
        
        Anken__c newDataAnken = [SELECT Id, Name FROM Anken__c WHERE KokyakuName__c =: newAccount.Id ];
        Production_Order__c orderInfo = [SELECT Id, Name FROM Production_Order__c WHERE Name=: newDataAnken.Name];
        
        String orderName2 = newDataAnken.Name;
        
        String newAnkenName = '';
        if(orderName2 != null){
            newAnkenName = orderName2.substring(2);
        }
        
        String stringToBlob2 =  newAnkenName +','+''+ ','+'file-21032028'+','+'jpeg'+','+'\\n'+'\n'+newAnkenName+','+''+','+'file-21032019'+','+'jpeg'+','+'\\n'+'\n';
        Blob newData2 = Blob.valueOf(stringToBlob2);
        EPMS_FilesWithoutFileManger epms3 = new EPMS_FilesWithoutFileManger();
        epms3.importCSVFile();
        epms3.csvFileBody = newData2;
        epms3.importCSVFile();
        Test.stopTest();
      
    }
    
    public static testMethod void FilesDownloadwithoutMethod3() {
    
        Test.startTest(); 
        
        Account newAccount = [SELECT Id, Name FROM Account WHERE Name = 'SRM Test'];        
        Anken__c newDataAnken = [SELECT Id, Name FROM Anken__c WHERE KokyakuName__c =: newAccount.Id ];
        Production_Order__c orderInfo = [SELECT Id, Name FROM Production_Order__c WHERE Name=: newDataAnken.Name];
        String orderName2 = newDataAnken.Name;
        String newAnkenName = '';
        if(orderName2 != null){
            newAnkenName = orderName2.substring(2);
        }
        
        String stringToBlob2 =  newAnkenName +','+'folder3'+ ','+'file-21032038'+','+'jpeg'+','+'\\n'+'\n'+newAnkenName+','+'folder3'+','+'file-21032119'+','+'jpeg'+','+'\\n'+'\n';
        Blob newData2 = Blob.valueOf(stringToBlob2);
        EPMS_FilesWithoutFileManger epms4 = new EPMS_FilesWithoutFileManger();
        epms4.importCSVFile();
        epms4.csvFileBody = newData2;
        epms4.importCSVFile();
        Test.stopTest();
        
    }
    
     public static testMethod void FilesDownloadwithoutMethod4() {
    
        Test.startTest();
        
        Account newAccount = [SELECT Id, Name FROM Account WHERE Name = 'SRM Test'];
        
        Anken__c newDataAnken = [SELECT Id, Name FROM Anken__c WHERE KokyakuName__c =: newAccount.Id ];
        Production_Order__c orderInfo = [SELECT Id, Name FROM Production_Order__c WHERE Name=: newDataAnken.Name];
        String orderName2 = newDataAnken.Name;
        String newAnkenName = '';
        if(orderName2 != null){
            newAnkenName = orderName2.substring(2);
        }
        
        String stringToBlob2 =  newAnkenName +','+'folder3'+ ','+'file-21032047'+','+'jpeg'+','+'\\n'+'\n'+newAnkenName+','+'folder3'+','+'file-21032137'+','+'jpeg'+','+'\\n'+'\n';
        Blob newData2 = Blob.valueOf(stringToBlob2);
        EPMS_FilesWithoutFileManger epms4 = new EPMS_FilesWithoutFileManger();
        epms4.importCSVFile();
        epms4.csvFileBody = newData2;
        epms4.importCSVFile();
        Test.stopTest();
          
    }    
}