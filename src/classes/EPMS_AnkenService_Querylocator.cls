/****************************************************************************
*   Class               :       EPMS_AnkenService_Querylocator              *
*   Created Date        :       27/07/2016                                  *           
*   Description         :       Providing queries for EPMS_AnkenService     *
/***************************************************************************/

public class EPMS_AnkenService_Querylocator
{

    public Anken__c getankenrecord(string orderid)
    {
        Anken__c ankenquery = new Anken__c();
        ankenquery = [select id,Name from anken__c where id=:Orderid ];
        return ankenquery;
    }
    
    public Production_order__c getPOrecord(string orderName)
    {
           Production_order__c POquery = null;
        system.debug('-entered getporecord');
        //Production_order__c POquery = new Production_order__c();
        try{
            
      
        Anken__c ankenquery = [select id,Name from anken__c where Name=:orderName ];
        system.debug('-----------'+ankenquery);
     
        try{
            if(ankenquery != null){
                POquery = [Select id,Name,Total_Anken_Count__c from Production_order__c where Name=:orderName];
            }
        } catch(Exception de){
            POquery = null;
        }
        }catch(exception e){
            
        }
        return POquery;
    }
    
    public Production_order__c getProductionOrderrecord(string orderid)
    {
        Production_order__c POquery = new Production_order__c();
        POquery = [Select id,Name,Total_Anken_Count__c from Production_order__c where id=:orderid];
        return POquery;
    }
    
    
    public list<Files__c> getallFiles(string orderid)
    {
        list<Files__c> filequery = new list<Files__c>();
        filequery =     [Select id,Name,File_Category_Code__r.Name from Files__c where Production_Order__c =:orderid and File_Category_Code__c != null and Status__c='Approved' ]; // and Status__c!='On-Hold'
        return filequery;
    }
    
    public list<Files__c> getallFilesEXCEL(string orderid)
    {
        list<Files__c> filequery = new list<Files__c>();
        filequery =  [Select id,Name,File_Category_Code__r.Name,Dir_File_name__c from Files__c where Production_Order__c =:orderid and  File_Category_Code__c != null and File_type__c='image' and Status__c='Approved'];
        return filequery;
    }
    
    public list<Files__c> getdirFiles(string DirName,string orderid)
    {
        list<Files__c> filequery = new list<Files__c>();
        filequery =  [select Dir_File_name__c,File_URL__c from Files__c where Name=:DirName and Production_Order__c=:orderid and Dir_File_name__c!=null Limit 1 ];
        return filequery;
    }
    
    public list<Files__c> getCatFiles(string CatName,string orderid)
    {
        list<Files__c> filequery = new list<Files__c>();
        filequery =  [select File_Category_Code__r.Name from Files__c where Name=:CatName and Production_Order__c = :orderid and File_Category_Code__c!=null Limit 1 ];
        return filequery;
    }
    /*
    public list<Files__c> getAllCategory(set<string> filecat,string orderId)
    {
        list<Files__c> filecatgeory = new list<Files__c>();
        filecatgeory =  [Select id,Name,File_Category_Code__r.Name from Files__c where File_Category_Code__r.Name IN : filecat and Production_Order__c = :orderid AND File_Type__c='Image'];  
        return filecatgeory;
    }
    
   */ 
}