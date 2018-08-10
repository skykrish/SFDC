/****************************************************************************
*   Class               :       Rest WEB Service                            *
*   Created Date        :       11/09/2015                                  *           
*   Description         :       To Communicate with the  query locator      *
*                               and return the fetched result set           *
*                                                                           *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/

public without sharing class EPMS_RestAPIService_WO_SRule{

    public static List<Production_Order__c> retrieveUploadedOrders(Set<String> ProductionID){
        system.debug('I/P for Uploaded Orders matched in Salesforce records are : WOS ' + ProductionID);
        List<Production_Order__c> orderUploadedList = new List<Production_Order__c>();
        // Retrive all the uploaded orders in given input order Name
        orderUploadedList = [select id,Name,Production_Order_TAT__c,Production_Order_Status__c FROM Production_Order__c where Name IN :ProductionID AND Production_Order_Status__c ='Uploaded' ];
        system.debug('Uploaded Orders matched in Salesforce records are : WOS ' + orderUploadedList );
        return orderUploadedList;
        
    }
    
    public static List<Production_Order__c> retrieveCancelledOrders(Set<Id> cancellOrderSet){
        system.debug('I/P for Cancelled Orders matched in Salesforce records are : WOS ' + cancellOrderSet);
        List<Production_Order__c> orderCancelledList = new List<Production_Order__c>();
        // Retrive all the uploaded orders in given input order Name
        orderCancelledList = [select id,Name,Production_Order_TAT__c,Production_Order_Status__c FROM Production_Order__c where Id IN :cancellOrderSet ];
        system.debug('Cancelled Orders matched in Salesforce records are : WOS ' + orderCancelledList );
        return orderCancelledList ;
        
    }

}