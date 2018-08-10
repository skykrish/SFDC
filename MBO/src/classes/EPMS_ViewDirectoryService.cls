/**********************************************************************************
*   Class               :       EPMS_ViewDirectoryService                         *
*   Created Date        :       13/04/2016                                        *
*   Description         :       Used as service layer class for getting records   *
**********************************************************************************/

public with sharing class EPMS_ViewDirectoryService{

    EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
 
    List<Files__c> orderInfoDet  = new List<Files__c>();
    
    public List<Files__c> getOrderInfoDetails(Id orderId){
        orderInfoDet  = queryObj.getOrderInfoDetails(orderId);
        return orderInfoDet;
    }

   
}