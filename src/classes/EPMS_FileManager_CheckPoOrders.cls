/**********************************************************************************
*   Class               :       EPMS_FileManager_CheckPoOrders                    *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Webservice to get orders based on file manager    *
**********************************************************************************/ 

@RestResource(urlMapping='/FileManager/CheckPO/*')
global with sharing class EPMS_FileManager_CheckPoOrders{
    
   // public String returnType {get;set;}  
    
    @HttpPost
    global static void getProductionOrders() {
        JSONGenerator gen = JSON.createGenerator(false);        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String requestType = RestContext.request.params.get('data');
        List<production_order__C> reUploadedOrders = new List<production_order__C>();
        List<production_order__C> cancelledOrders = new List<production_order__C>();
        List<production_order__C> alreadyUploadedOrders = new List<production_order__C>();
        List<production_order__C> uploadedOrders = new List<production_order__C>();
        String POdownload;
        String POReupload;
        String POuploaded;
        String POCancelled;
        String POUpload;
        String fileReDownload;
        Set<String> ProductionID = new Set<String>() ;
        String PoNoumber;
       // String returnType;
        String returnData;
        EPMS_RestAPIService servObj = new EPMS_RestAPIService(); 
        PoNoumber=servObj.ProductionOrderParser(requestType);
        List<Production_Order__c> Productionrecords = new List<Production_Order__c>();
        String[] OrderNO=null;
    if(requestType.contains('download')){
        if(PoNoumber.contains(',') &&  PoNoumber!=NULL){
            OrderNO = PoNoumber.split(',');                           
        }else{
            OrderNO = PoNoumber.split(',');
        }

        if(OrderNO!=null){
            for(String ResponseID :OrderNO){
                ProductionID.add(ResponseID);
            }
            system.debug('Production Order Names : ' + ProductionID);
           // Productionrecords = servObj.getProductionOrder_ForDownload(ProductionID);
            
            Productionrecords=[Select id,Name,Production_Order_TAT__c  FROM Production_Order__c where Name IN : ProductionID AND (Production_Order_Status__c='New' OR Production_Order_Status__c='Pending' OR Production_Order_Status__c='Estimation Request') AND FTP_Upload_Status__c=FALSE AND Production_Order_Status__c!='Cancelled' and Production_Order_Status__c!='Completed' and Production_Order_Status__c!='Uploaded' and FTP_Download_Status__c=false and Production_Order_Old_Status__c!='Awaiting Approval' ORDER BY Production_Order_TAT__c ASC ];
            
            //reUploadedOrders = [select id,name from production_order__c where ReUpload__c=true AND (Production_Order_Status__c ='New' OR Production_Order_Status__c ='Assigned' OR Production_Order_Status__c ='Pending') ];
            reUploadedOrders = [select id,name from production_order__c where ReUpload__c=true AND (Production_Order_Status__c ='New' OR Production_Order_Status__c ='Assigned' OR Production_Order_Status__c ='Pending' OR Production_Order_Status__c ='Estimation Request') ];
            system.debug('$$ reUploadedOrders are : ' + reUploadedOrders);
            //cancelledOrders = [select id,Name,Production_Order_TAT__c,Production_Order_Status__c FROM Production_Order__c where Name IN :ProductionID AND (Production_Order_Status__c ='Uploaded' OR Production_Order_Status__c ='Cancelled' OR IsDeleted = true) AND LastModifiedDate < YESTERDAY ORDER BY Production_Order_TAT__c ASC ALL ROWS ];
            cancelledOrders = [select id,Name,Production_Order_TAT__c,Production_Order_Status__c FROM Production_Order__c where Name IN :ProductionID AND (Production_Order_Status__c ='Uploaded' OR ((Production_Order_Status__c ='Cancelled'  OR IsDeleted = true) AND LastModifiedDate < YESTERDAY)) ORDER BY Production_Order_TAT__c ASC ALL ROWS ];
            Set<Id> cancellOrderSet = new Set<Id>();
            if(cancelledOrders != null && cancelledOrders.size() > 0){
                for(Production_Order__c orderIgnore : cancelledOrders){
                    cancellOrderSet.add(orderIgnore.Id);
                }
            }
            

            //alreadyUploadedOrders = [select id,Name,Production_Order_TAT__c,Production_Order_Status__c FROM Production_Order__c where Name IN :ProductionID AND Production_Order_Status__c ='Uploaded' ];
            //alreadyUploadedOrders = servObj.retrieveUploadedOrders(ProductionID);
            alreadyUploadedOrders = EPMS_RestAPIService_WO_SRule.retrieveUploadedOrders(ProductionID);
            system.debug('$$ Uploaded Orders are : ' + alreadyUploadedOrders);
            if(alreadyUploadedOrders != null && alreadyUploadedOrders.size() > 0){
                for(Production_Order__c orderIgnore : alreadyUploadedOrders){
                    cancellOrderSet.add(orderIgnore.Id);
                }
            }
            system.debug('## Uploaded Orders are : ' + cancellOrderSet);
            
            List<Production_Order__c> cancelledOrders2 = new List<Production_Order__c>();
            system.debug(' ORDER EXISTS WITH SAME NAME WITH DIFFERENT STATUS : ' + cancellOrderSet);
            List<Production_Order__c> orderExistsWithAnotherStatus = new List<Production_Order__c>();
            Set<Id> orderExists = new Set<Id>();
            Set<Id> finalCancelledIds = new Set<Id>();
            if(cancellOrderSet != null && cancellOrderSet.size() > 0){
                orderExistsWithAnotherStatus = [select id,Name,Production_Order_TAT__c,Production_Order_Status__c FROM Production_Order__c where Name IN :cancellOrderSet AND (Production_Order_Status__c !='Uploaded' AND Production_Order_Status__c !='Cancelled' AND IsDeleted = false) ORDER BY Production_Order_TAT__c ASC ALL ROWS];
                if(orderExistsWithAnotherStatus != null && orderExistsWithAnotherStatus.size() > 0){
                    for(Production_Order__c newOrd : orderExistsWithAnotherStatus){
                        orderExists.add(newOrd.Id);
                    }
                }
                system.debug(' ORDER EXISTS WITH SAME NAME WITH DIFFERENT STATUS : ' + orderExists);
                
                if(orderExists != null && orderExists.size() > 0){
                    for(Id existsId : orderExists){
                        if(cancellOrderSet.contains(existsId)){
                            cancellOrderSet.remove(existsId);
                        }
                    }
                }
                system.debug('Final Cancelled List : ' + cancellOrderSet);
                
                
            }
            system.debug('Cancelled Order is : ' + cancelledOrders);
            // Retrieve the reload order files [Delete Old files]
            if(reUploadedOrders.size()>0){
                for(Production_Order__c order:reUploadedOrders){
                    if(POReupload == NULL){
                        POReupload = order.Name+',';
                    }else{
                        POReupload = POReupload+order.Name+',';
                    }
                    system.debug('PO Re-download Order : ' + POReupload);
                }
                
                if(POReupload != null){
                    POReupload = POReupload.substring(0,POReupload.length()-1);  
                }
                system.debug('PO Re-download Order After Sub-string: ' + POReupload);
                
            }

            List<Production_Order__c> alreadyCompletedOrders = EPMS_RestAPIService_WO_SRule.retrieveCancelledOrders(cancellOrderSet);
            // Retrieve the Cancelled Order from input orders
            if(orderExists.size() == 0){
                if(alreadyCompletedOrders!= null && alreadyCompletedOrders.size()>0){
                    for(Production_Order__c order:alreadyCompletedOrders){
                        if(POCancelled == NULL){
                            POCancelled = order.Name+',';
                        }else{
                            POCancelled = POCancelled+order.Name+',';
                        }
                        system.debug('PO Cancelled Order : ' + POCancelled);
                    }
                    
                    if(POCancelled != null){
                        POCancelled = POCancelled.substring(0,POCancelled.length()-1);  
                    }
                    system.debug('PO Cancelled Order After Sub-string: ' + POCancelled);
                    
                }
            } else if(cancellOrderSet.size() > 0){
                cancelledOrders2 = [select id,Name,Production_Order_TAT__c,Production_Order_Status__c FROM Production_Order__c where Name IN :cancellOrderSet ORDER BY Production_Order_TAT__c ASC ALL ROWS];
                if(cancelledOrders2 != null && cancelledOrders2.size()>0){
                    for(Production_Order__c order:cancelledOrders2){
                        if(POCancelled == NULL){
                            POCancelled = order.Name+',';
                        }else{
                            POCancelled = POCancelled+order.Name+',';
                        }
                        system.debug('PO Cancelled Order : 2 ' + POCancelled);
                    }
                    
                    if(POCancelled != null){
                        POCancelled = POCancelled.substring(0,POCancelled.length()-1);  
                    }
                    system.debug('PO Cancelled Order After Sub-string: 2 ' + POCancelled);
                    
                }
            }
            
            
            
            system.debug('Test the re-download order :' + POReupload);
            // Retrieve the re-download files independent from re-download orders
            List<Files__c> ExistReDownloadFiles = new List<Files__c>();
            List<Files__c> FileUpdate = new List<Files__c>();
            //ExistReDownloadFiles = [Select id,Name,File_URL__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Production_Order__c,ReUpload__c From Files__c where ReUpload__c = true AND File_Type__c = 'Image' AND FTP_Upload_Status__c != true AND Status__c = 'New' AND Production_Order__r.Production_Order_Status__c != 'Uploaded'];
            ExistReDownloadFiles = [Select id,Name,File_URL__c,FTP_Upload_Status__c,FTP_Upload_Time__c,Production_Order__c,ReUpload__c From Files__c where ReUpload__c = true AND File_Type__c = 'Image' AND FTP_Upload_Status__c != true AND (Status__c = 'New' OR Status__c = 'Estimation Request') AND Production_Order__r.Production_Order_Status__c != 'Uploaded'];
            //Production_Order_Status__c ='Estimation Request'
            system.debug('$$ ExistReDownloadFiles are : ' + ExistReDownloadFiles);
            
            Set<String> fileNameWithUrl = new Set<String>();
            if(ExistReDownloadFiles.size()>0){
                for(Files__c file : ExistReDownloadFiles){
                    system.debug('File URL :' + fileNameWithUrl);
                    system.debug('Current File URL :' + file.File_URL__c);
                    if(fileReDownload==NULL){
                        fileReDownload=file.File_URL__c+',';
                    }else{
                        fileReDownload=fileReDownload+file.File_URL__c+',';
                    }
                    /*if(file.File_URL__c != null ){
                        system.debug('Current File URL :' + file.File_URL__c);
                        fileNameWithUrl.add(file.File_URL__c);
                    }*/
                    file.ReUpload__c=false;
                    FileUpdate.add(file);
                }
            }
            system.debug('Files to be re-downloaded from FTP is ::: ' + fileReDownload);
            if(fileReDownload != null){
                 fileReDownload = fileReDownload.substring(0,fileReDownload.length()-1);  
            }
            
            if(Productionrecords.size() >0){
                for(Production_Order__c orders:Productionrecords){
                    if(POdownload==NULL){
                        POdownload=orders.Name+',';
                    }else{
                        POdownload=POdownload+orders.Name+',';
                    }                       
            }
            POdownload=POdownload.substring(0,POdownload.length()-1);   
            }
        }
        
        returnData='{"download":{"poNumber":"'+POdownload+'"},"cancelledpo":{"poNumber":"'+POCancelled+'"},"redownloadpo":{"poNumber":"'+POReupload+'"},"redownloadfiles":{"filelist":"'+fileReDownload+'"}}'; 
        system.debug('Test the return data [re-download order]: ' + returnData);
    }else if(requestType.contains('upload')){        
        if(PoNoumber.contains(',') &&  PoNoumber!=NULL){
            OrderNO = PoNoumber.split(',');                
        }else{
            OrderNO = PoNoumber.split(',');
        }          

        if(OrderNO!=null){
            for(String ResponseID :OrderNO){
                ProductionID.add(ResponseID);
            }
            Productionrecords= servObj.getProductionOrder_Forupload(ProductionID);
            if(Productionrecords.size()>0 ){
                for(Production_Order__c orders:Productionrecords){
                    if(POUpload==NULL){
                        POUpload=orders.Name+',';
                    }else{
                        POUpload=POUpload+orders.Name+',';
                    }
            }            
                POUpload=POUpload.substring(0,POUpload.length()-1); 
            }   

        }

        returnData='{"upload":{"poNumber":"'+POUpload+'"}}';     
    }    
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(returnData);    
    }    
}