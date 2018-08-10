global class EPMS_Change_TL_Batch implements Database.Batchable<sObject>{
    //Database.stateful

    global final Id orderId {public get; public set;}
    global final Id teamLeaderIncharge {public get; public set;}
    global final Id qualityIncharge {public get; public set;}
    global string query {public get; public set;}
    global string type {public get; public set;}
    
    global EPMS_Change_TL_Batch(Id orderId, Id TLIncharge, Id QCIncharge, String queryStr){
        system.debug('Change TL Incharge : Order ' + orderId);
        system.debug('Change TL Incharge : TL Incharge ' + TLIncharge);
        system.debug('Change TL Incharge : QC Incharge ' + QCIncharge);
        system.debug('Query : TL/QC Incharge updation ' + queryStr);
        orderId = orderId;
        teamLeaderIncharge = TLIncharge;
        qualityIncharge = QCIncharge;
        type = queryStr;
        system.debug('orderId =[' + orderId +'] teamLeaderIncharge ['+teamLeaderIncharge +'] QC : [' + QCIncharge +']');
        query = 'SELECT Id, Name, TLIncharge__c, QCIncharge__c, Status__c, Files_To_Open__c FROM Files__c WHERE Production_Order__c =\''+orderId+'\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug(' [CHANGE TL INCHARGE] - [BATCH PROCESS] - Started : ');
        
        system.debug(' [CHANGE TL INCHARGE] - [BATCH PROCESS] - Query : '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Files__c> scope){
        
        system.debug(' [CHANGE TL INCHARGE] - [BATCH PROCESS] - Executes : '+type);
        List<Files__c> filesList = new List<Files__c>();
        
        for(Files__c currentFile : scope){
            if(type == 'Change_TL'){
                system.debug(' [CHANGE TL INCHARGE] - [BATCH PROCESS] - Executes : ');
                if(currentFile.Status__c != 'QC' && currentFile.Status__c != 'QCIP' && currentFile.Status__c != 'Approved' && currentFile.Status__c != 'On-Hold'){
                    currentFile.TLIncharge__c = teamLeaderIncharge;
                    currentFile.QCIncharge__c = qualityIncharge;
                    filesList.add(currentFile);
                } else  if(currentFile.Status__c != 'QCIP' && currentFile.Status__c != 'Approved' && currentFile.Status__c != 'On-Hold'){
                    currentFile.QCIncharge__c = qualityIncharge;
                    filesList.add(currentFile);
                }
            } else {
                system.debug(' [CHANGE QC INCHARGE] - [BATCH PROCESS] - Executes : ');            
                if((currentFile.Status__c != 'QCIP' || currentFile.Status__c != 'Approved' || currentFile.Status__c != 'On-Hold') && ( (currentFile.Status__c == 'QC' && currentFile.Files_To_Open__c != 1  ) || ( currentFile.Status__c == 'WIP'  || 
                 currentFile.Status__c == 'HandOver'  || currentFile.Status__c == 'Assigned' || currentFile.Status__c == 'Redo' || currentFile.Status__c == 'New')
                  )) {
                    
                    currentFile.QCIncharge__c = qualityIncharge;
                    filesList.add(currentFile);
                }
            }
            
        }
        
        if(filesList != null && filesList.size() > 0){
            update filesList;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug(' [CHANGE TL INCHARGE] - [BATCH PROCESS] - Finish : ');
    }
    

}