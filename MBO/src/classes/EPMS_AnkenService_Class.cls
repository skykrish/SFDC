/*******************************************************************************************
*   Class               :       EPMS_AnkenService_Class                                    *
*   Created Date        :       13/04/2016                                                 *           
*   Description         :       service class to communicate with EPMS_AnkenService_Class  *
/*******************************************************************************************/

Public class EPMS_AnkenService_Class
{

    //create instance for EPMS_AnkenService_Querylocator  
    EPMS_AnkenService_Querylocator queryloc = new EPMS_AnkenService_Querylocator();
    
    //get anken records
    public Anken__c getankenrecord(string orderid)
    {
        Anken__c ankenquery = queryloc.getankenrecord(orderid);
        return ankenquery;
    }
    
    //get Production order record based on order name
    public Production_order__c getPOrecord(string orderName)
    {
        Production_order__c POquery = queryloc.getPOrecord(orderName);
        return POquery;
    }
    
    
    //get production order record 
    public Production_order__c getProductionOrderrecord(string orderName)
    {
        Production_order__c POquery = queryloc.getProductionOrderrecord(orderName);
        return POquery;
    }
    
    //get files related with production order
    public list<Files__c> getallFiles(string orderid)
    {
        list<Files__c> Filequery = queryloc.getallFiles(orderid);
        return Filequery;
    }
    
    //get files to download as excel
    public list<Files__c> getallFilesEXCEL(string orderid)
    {
        list<Files__c> Filequery = queryloc.getallFilesEXCEL(orderid);
        return Filequery;
    }
    
    
    //get files based on directory
    public list<Files__c> getdirFiles(string DirName,string orderid)
    {
        list<Files__c> Filequery = queryloc.getdirFiles(DirName,orderid);
        return Filequery;
    }
    
    //get files based on categories
    public list<Files__c> getCatFiles(string CatName,string orderid)
    {
        list<Files__c> Filequery = queryloc.getCatFiles(CatName,orderid);
        return Filequery;
    }
    
   /* 
    // get categories
    public list<Files__c> getAllCategory(set<string> filecat)
    {
        list<Files__c> Filecategory = queryloc.getAllCategory(filecat);
        return Filecategory;
    } */
    
}