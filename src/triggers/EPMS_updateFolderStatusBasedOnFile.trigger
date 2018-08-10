trigger EPMS_updateFolderStatusBasedOnFile on Files__c (after update){
    List<Files__c> orderFilesList = new List<Files__c>();
    List<Files__c> filesList = Trigger.new;
    Set<String> fileOrderStatusList = new Set<String>();
    String orderStatus = null;
    String orderId = null;
    Set<Id> parentIds = new Set<Id>();
    Set<Id> parentDirIds = new Set<Id>();
    boolean doStatusCheck = false;
    boolean doChangeTLCheck = false;
    
    system.debug('-------Recursivevalue3------'+EPMS_CheckRecursive_UpdateFileStatus.runOnce());
    
    // if(EPMS_CheckRecursive_UpdateFileStatus.runOnce()){
    //  if(EPMS_CheckRecursive.fileBasedFolderTrigger == true){
    
    system.debug('--%%$%$--- SELECTED FILES STATIC VARIBALE :' + EPMS_CheckRecursive.FileStatusTrigger);
    EPMS_CheckRecursive.fileBasedFolderTrigger = true;
    for(Files__c file : Trigger.new){
        Files__c oldFile = Trigger.oldMap.get(file.ID);
            if((oldFile.TLInCharge__c != file.TLInCharge__c) || (oldFile.QCIncharge__c != file.QCIncharge__c) || (oldFile.Order_Instructions__c != file.Order_Instructions__c)){
                doChangeTLCheck = true;
                system.debug('=== TL Change Process ===' + doChangeTLCheck);
                break;
            }            
        break;
    }   
    
    if(!doChangeTLCheck){
        for(Files__c file : Trigger.new){
            Files__c oldFiles = Trigger.oldMap.get(file.ID);
            if(file.Status__c != oldFiles.Status__c){
                doStatusCheck = true;
                if(file.Parent_Id__c != null){
                    parentIds.add(file.Parent_Id__c);
                }
                if(file.Parent_Id__c != null && file.File_Type__c == 'Directory'){
                    parentDirIds.add(file.Parent_Id__c);
                }
            }
        }
        
        List<Files__c> orderFolderList = new List<Files__c>();
        if(doStatusCheck){
            if(filesList != null && filesList.size() > 0){
                Map<Id, List<Files__c>> folderFileMap = new Map<Id, List<Files__c>>();
                orderFolderList = [SELECT Id, Name, Status__c FROM Files__c WHERE Id =: parentIds];
                
                List<Files__c> allfileListForFolders = [SELECT Id, Name, Status__c, Parent_Id__c FROM Files__c WHERE Parent_Id__c IN : parentIds AND File_Type__c = 'Image' AND Status__c != 'On-Hold'];
                if(allfileListForFolders != null && allfileListForFolders.size() > 0){
                    if(parentIds != null && parentIds.size() > 0){
                        for(Id parentFileId : parentIds){
                            List<Files__c> folderFileList = new List<Files__c>();
                            for(Files__c files : allfileListForFolders){
                                if(files.Parent_Id__c == parentFileId){
                                    folderFileList.add(files);
                                }
                            }
                            system.debug('Folder Id : [' + parentFileId + '] : File List : [ ' + folderFileList +' ]');
                            folderFileMap.put(parentFileId, folderFileList);
                        }
                    }
                }
                system.debug('Folder File Map : ' + folderFileMap);
                List<Files__c> newFolderFileList = new List<Files__c>();
                
                if(filesList != null && filesList.size() > 0){
                    for(Files__c folderFile : orderFolderList){
                        String folderStatus = folderFile.Status__c;
                        //orderFilesList = [SELECT Id, Name, Status__c FROM Files__c WHERE Parent_Id__c =: folderFile.Id AND File_Type__c = 'Image' AND Status__c != 'On-Hold'];
                        if(folderFileMap != null && folderFileMap.size() > 0){
                            orderFilesList = folderFileMap.get(folderFile.Id);
                        }
                        
                        if(orderFilesList != null && orderFilesList.size() > 0){
                            for(Files__c file : orderFilesList){
                                fileOrderStatusList.add(file.Status__c);
                            }
                        }
                        
                        
                        String fileStatus = null;
                        if(fileOrderStatusList.size() == 1){
                            for(String status :fileOrderStatusList){
                                fileStatus = status;
                                break;
                            }
                        }
                        
                        
                        if(fileOrderStatusList.size() == 1 && fileStatus != folderStatus && fileStatus != 'On-Hold' && fileStatus != 'WIP'){
                            // Update the file status into production order status
                            folderFile.Status__c = fileStatus;
                            newFolderFileList.add(folderFile);
                        }
                    }
                    
                }   
                
                if(newFolderFileList.size() > 0){
                    update newFolderFileList;
                }
                
                List<Files__c> orderrootFolderList2 = new List<Files__c>();
                List<Files__c> ordersubFolderList2 = new List<Files__c>();
                List<Files__c> ordersubFolderFilesList2 = new List<Files__c>();
                Set<String> directoryOrderStatusList = new Set<String>();
                Set<String> rootOrderStatusList = new Set<String>();
                // For Directory the status to be updated
                if(parentDirIds != null && parentDirIds.size() > 0){
                    orderrootFolderList2 = [SELECT Id, Name, Status__c FROM Files__c WHERE Id =:parentDirIds ];
                    if(orderrootFolderList2 != null && orderrootFolderList2.size() > 0){
                        for(Files__c file : orderrootFolderList2){
                            system.debug('-- #### CASE 1 ## FILE DETAILS IN ORDER RESULT:::-- ' + file);
                            rootOrderStatusList.add(file.Status__c);
                        }
                    }
                    
                    
                    //ordersubFolderList2 = orderFilesList = [SELECT Id, Name, Status__c FROM Files__c WHERE Parent_Id__c IN: parentDirIds AND File_Type__c = 'Directory' ];
                    ordersubFolderList2 =  [SELECT Id, Name, Status__c FROM Files__c WHERE Parent_Id__c IN: parentDirIds AND File_Type__c = 'Directory' ];
                    ordersubFolderFilesList2 =  [SELECT Id, Name, Status__c FROM Files__c WHERE Parent_Id__c IN: parentDirIds AND File_Type__c = 'Image' AND Status__c != 'On-Hold' ]; // 
                    
                    
                    if(ordersubFolderList2 != null && ordersubFolderList2.size() > 0){
                        for(Files__c file : ordersubFolderList2){
                            system.debug('-- #### CASE 2 ## FILE DETAILS IN ORDER RESULT:::-- ' + file);
                            directoryOrderStatusList.add(file.Status__c);
                        }
                    }
                    
                    
                    Set<String> filesInsideDirectory = new Set<String>();
                    if(ordersubFolderFilesList2 != null && ordersubFolderFilesList2.size() > 0){
                        for(Files__c file : ordersubFolderFilesList2){
                            system.debug('-- #### CASE 3 ## FILE DETAILS IN ORDER RESULT:::-- ' + file);
                            filesInsideDirectory.add(file.Status__c);
                            directoryOrderStatusList.add(file.Status__c);
                        }
                    }
                    
                    
                    if(rootOrderStatusList.size() == 1 && directoryOrderStatusList.size() == 1 && directoryOrderStatusList.size() > 0){
                        
                        if(!rootOrderStatusList.equals(directoryOrderStatusList)){
                            String finalStatus = '';
                            for(String statusFinal : directoryOrderStatusList){
                                finalStatus = statusFinal;
                            }
                            orderrootFolderList2[0].Status__c = finalStatus;
                            
                        }
                        if(orderrootFolderList2.size() > 0){
                            update orderrootFolderList2;
                        }
                        
                    }
                    
                    // }
                    
                }
                
            }
        }
    }
}