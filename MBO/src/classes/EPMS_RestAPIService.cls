/********************************************************************************
*   Class               :       EPMS_RestAPIService                             *
*   Created Date        :       11/09/2015                                      *           
*   Description         :       To Communicate with the  query locator          *
*                               and return the fetched result set               *
*   Created By          :                                                       *                       
*   Version             :       1.0                                             *            
*   Modifications       :       02/05/18 - Included DeliveryManager settings    *
/*******************************************************************************/

public class EPMS_RestAPIService{
    private static final EPMS_RestAPIService instance = new EPMS_RestAPIService();    
    EPMS_RestAPIQueryLocator queryObj = new EPMS_RestAPIQueryLocator();
    public  string category=null;
    public  decimal minval;
    public decimal maxval;
    
    public static EPMS_RestAPIService getInstance(){
        // lazy load the record type - only initialize if it doesn't already exist
        return instance;
    }    
    
    public String ProductionOrderParser(String jasonString){
        
        String productionOrder;
        //resp is a JSON string
        JSONParser parser = JSON.createParser(jasonString);
        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'poNumber') {
                    
                    productionOrder= parser.getText();
                }
            }
        }
        
        return productionOrder;
    } 
    
    public String getsettingsname(String jasonString){
        
        String settingsname; 
        
        //resp is a JSON string
        JSONParser parser = JSON.createParser(jasonString);
        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'Name')
                {
                    
                    settingsname= parser.getText();
                }
            }
        }
        
        return settingsname;
    } 
    
    
    public String FileidsParser(String jasonString){
        
        String fileids;
        //resp is a JSON string
        JSONParser parser = JSON.createParser(jasonString);
        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'fileId') {
                    
                    fileids = parser.getText();
                }
            }
        }
        
        return fileids;
    } 
    
    
    
    public List<Production_Order__c> ProductionOrder {get;set;}
    public List<Settings__c> settingList {get;set;} 
    public List<Files__c> ApprovedImFiles{get;set;}
    public List<Files__c> ApprovedFiles{get;set;}
    
    //Get List of New Production Order
    public List<Settings__c> getSettings(Id MemberID){
        try {
             settingList  = queryObj.getSettings(MemberID);
       
        }catch(exception e) {
            
        }
        return settingList ;
    }
    
    public List<Settings__c> getSettingsTracker(Id MemberID){
        settingList  = queryObj.getSettingsTracker(MemberID);
        return settingList ;
    }
    
    //Get List of New Production Order
    public List<Settings__c> getDMSettings(Id locationID){
        Try {
             settingList  = queryObj.getDMSettings(locationID); 
        } catch(Exception e) {
            
        }
       
        return settingList ;
    }
    
    /*public List<Settings__c> getDMSettingsTracker(Id locationID){
settingList  = queryObj.getDMSettingsTracker(locationID);
return settingList ;
}*/    
    
    //Get List of New Production Order
    public List<Production_Order__c> getProductionOrder_ForDownload(SET<String> ProductionName){
        ProductionOrder = queryObj.getProductionOrder_ForDownload(ProductionName);
        return ProductionOrder;
    }
    
    public List<Production_Order__c> getProductionOrder_Forupload(SET<String> ProductionName){
        ProductionOrder = queryObj.getProductionOrder_Forupload(ProductionName);
        return ProductionOrder;
    }
    
    Files__c fileRef = new Files__c(); 
    
    public Files__c fetchFileDetailsForUpdate(String id){
        fileRef = queryObj.fetchFileDetailsForUpdate(id);
        return fileRef;
        
    }
    
    
    public String getCategoryCode(string totalseconds,string memberid )
    {
        try {
            Member__c Memdetails = [select id,Name,Performance_Rating__c,Performance_Rating__r.Name from Member__c where id=:memberid];
            
            list<Performance_Rating__c> ratingdetails = new list<Performance_Rating__c>();
            ratingdetails = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name=:Memdetails.Performance_Rating__r.Name ];
            
            
            
            integer totalsecs = integer.valueof(totalseconds);
            decimal mins = totalsecs/60;
            integer tm = (integer) mins;
            integer sec = math.mod(totalsecs,60);
            
            string totaltm = string.valueof(tm)+'.'+string.valueof(sec);
            
            
            Decimal totalmins = decimal.valueof(totaltm);
            system.debug('-------------------totalmins---------------'+totalmins);
            
            for(Performance_Rating__c PR :ratingdetails)
            {
                
                minval = PR.File_Performance_Stf_Min__c;
                maxval = PR.File_Performance_Stf_Max__c;
                
                if(totalmins>=minval){
                    if(totalmins<=maxval){
                        
                        category = PR.File_Category__c;
                    }
                }
            }
            
        } catch(Exception e) {
            
        }
        
        return category;
    }
    
    public List<Anken__c> getOrder_ForTransfer(){
        List<Anken__c> ankenList = queryObj.getOrder_ForTransfer();
        return ankenList;
    } 
    
    
}