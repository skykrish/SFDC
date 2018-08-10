/*********************************************************************************
*   Class               :       EPMS_ProductionOrderService                      *
*   Created Date        :       13/04/2016                                       *           
*   Description         :       Service class EPMS_ProductionOrder_Query_Locator *                               
/*********************************************************************************/

public class EPMS_ProductionOrderService {

    //create instance for EPMS_ProductionOrder_Query_Locator 
    EPMS_ProductionOrder_Query_Locator queryLoc = new EPMS_ProductionOrder_Query_Locator();
    
    // method to get anken records
    public List<Anken__c> getAnken( List<string> reqids)
    {
       list<Anken__c>  ankenOBj = queryLoc.getAkenObject(reqids);
       return ankenOBj;
    }
    
    //method to get production order duplicates 
    public list<production_order__c> getproductiondub()
    {
        list<production_order__c> prod = queryLoc.getProductiondublicates();
        return prod;
    }
    
    //method to get locations
    public list<location__c> getLocation()
    {
        list<location__c> locid = queryLoc.getlocationsquery();
        return locid;
    }
  


}