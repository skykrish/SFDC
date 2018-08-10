/**************************************************************************************
*   Trigger             :       EPMS_Chatter_Notification                             *
*   Created Date        :       31/07/2016                                            *           
*   Description         :       This trigger will send chatter notification to 
assigned members(Photo Artists)                       *     

****************************************************************************************/
trigger EPMS_Chatter_Notification on Files__c (after insert,before update,after update,after delete) { 
    
    // Sends Chatter Notification for Spilt Files scenarios 
    Integer count1 = 0;
    Integer count2 = 0;
    Id member1 = null;
    Id member2 = null;
    Id chattMember = null;
    Id redoAssignedMember = null;
    String flowStatus = null;
    String filesNames = '';
    Id orderlocation = null;
    Map<Integer, Id> memberNoIds = new Map<Integer, Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        Integer i=0;
        for(Files__c newFileValue : Trigger.new){
            
            if(newFileValue.Status__c == label.EPMS_FileStatus_Assigned){
                flowStatus = newFileValue.Status__c;
                String stringName  = newFileValue.Name;
                String extension  = newFileValue.Current_Extension__c;
                String[] SplitedName = new String[]{};
                    if(stringName != null && extension!=null){
                        SplitedName = stringName.split(extension);
                    }
                boolean isCopyFiles = stringName.contains('_copy');
                if(isCopyFiles && SplitedName != null){
                    String[] array1 = SplitedName[0].split('_copy');
                    if(i==0){
                        if(array1.size() == 2){
                            String[] countFiles = array1[1].split('\\.');
                            count1 = Integer.valueOf(countFiles[0]);
                            member1 = newFileValue.Member__c;
                        }    
                    }
                    if(i == 1){
                        if(array1.size() == 2){
                            String[] countFiles = array1[1].split('\\.');
                            system.debug(' COUNT FILES 11 ------ > ' + countFiles);
                            //count1 = Integer.valueOf(array1[1]);
                            count2 = Integer.valueOf(countFiles[0]);
                            member2 = newFileValue.Member__c;
                        }
                    }
                    i++;
                }
            }
            if(newFileValue.Status__c == label.EPMS_FileStatus_Assigned && member1 == null && member2 == null){
                redoAssignedMember = newFileValue.Member__c;
            }
        }
        if(count2 > count1){
            chattMember = member2; 
        } else {
            chattMember = member1; 
        }
        if(chattMember == null && redoAssignedMember != null){
            chattMember = redoAssignedMember ;
        }
        Map<String, Object> params = new Map<String, Object>();
        for(Files__c newFile : Trigger.new){
            if(newFile.Status__c == label.EPMS_FileStatus_Assigned || newFile.Status__c == label.EPMS_FileStatus_Redo_Re_Assigned ){
                flowStatus = newFile.Status__c;
                if(Trigger.isInsert && chattMember != null){
                    params.put('TL_Incharge_Id', chattMember);
                }
                
                // Add the production order name to single string
                if(filesNames == '' && newFile.Member__c == chattMember){
                    filesNames = newFile.Name;
                    orderlocation = newFile.File_Location__c;
                }
                
            } 
        }
        // Adding Order Names into flow parameters
        params.put('PrdOrderName', filesNames);
        
        // Adding Location into flow parameters
        params.put('ProdOrdLocation', orderlocation);
        
        // Adding Chatter Notification into flow parameters
        if(flowStatus == label.EPMS_FileStatus_Assigned || flowStatus == label.EPMS_FileStatus_Redo_Re_Assigned){
            params.put('displayChatterMessage', 'Following Files are assigned to you. Please View these file(s) :  ');
        }                
        // Call the Flow                
        //Flow.Interview.TL_QC_LookUp chatterFlow = new Flow.Interview.TL_QC_LookUp(params);
        Flow.Interview.Operator_File_Assignment_Notification chatterFlow = new Flow.Interview.Operator_File_Assignment_Notification(params);
        chatterFlow.start();
        
    }  
    
    // File Basic Validation Starts
    
    boolean doJobTitleChange = false;
    if(Trigger.isAfter && Trigger.isUpdate){
        
        for(Files__c file : Trigger.new){
            Files__c oldFile = Trigger.oldMap.get(file.ID);
            if(oldFile != null){
                if(oldFile.File_Job_Titles__c != file.File_Job_Titles__c){
                    doJobTitleChange = true;
                    system.debug('JOB TITLE IS CHANGED -IN CHATTER TRIGGER - '+ doJobTitleChange);
                }
            }
        }
    }                
    if(!doJobTitleChange){
        List<Location__c> locationList = [SELECT Id, Name FROM Location__c WHERE Location_Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS];
        
        //system.debug('NO JOB TITLE HAS CHANGED -INSIDE CHATTER TRIGGER -'+ doJobTitleChange);
        if(Trigger.isBefore&&Trigger.isUpdate){
            
            //if(EPMS_CheckRecursiveChatterNotify.runOnce()){ 
            List<Files__c> newValues = Trigger.new;      
            Set<Id> memberIds = new Set<Id>();
            Map<Id, Id> locationMap = new Map<Id, Id>();
            Map<Id, String> locationNameMap = new Map<Id, String>();
            Map<Id, String> memberDesignationMap = new Map<Id, String>();
            // Keep the member ids for member related validation
            for(Files__c newvalue : newValues){
                memberIds.add(newvalue.Member__c);
            }        
            // Keep the location and location Id
            if(locationList != null && locationList.size() > 0){
                for(Location__c location : locationList){
                    locationNameMap.put(location.Id, location.Name);
                }
            }
            // Check the member designation and member location validation
            if(memberIds.size() > 0){
                List<Member__c> memberList = [SELECT Id, Name, Location_id__c, Designation__c FROM Member__c WHERE Id IN : memberIds];
                if(memberList != null && memberList.size() > 0){
                    for(Member__c member : memberList){
                        // Create the member designation map for designation validation
                        memberDesignationMap.put(member.Id, member.Designation__c);
                        // Create the member designation map for designation validation
                        locationMap.put(member.Id, member.Location_id__c);
                    }
                }
            }
            // File Validation - Starts
            for(Files__c newvalue : newValues){
                
                // Check the file type instruction and status is New, If Member is specified
                if(newvalue.Member__c != null){
                    
                    if((newvalue.Status__c == label.EPMS_FileStatus_New || newvalue.Status__c == label.EPMS_FileStatus_Handover) && newvalue.File_Type__c == null){
                        Trigger.new[0].addError(label.EPMS_FileType_NotAvailable_Error);
                    }                
                    if((newvalue.Status__c == label.EPMS_FileStatus_Assigned || newvalue.Status__c == label.EPMS_FileStatus_New || newvalue.Status__c == label.EPMS_FileStatus_Handover) && newvalue.File_Type__c == label.EPMS_File_Type_Instruction){
                        Trigger.new[0].addError(label.EPMS_FileInsType_Assigned_Error);
                    }
                    
                    // Check the member designation : Shouldn't Sale Region, File Manager, Production Administrator
                    Id fileLocation = newvalue.File_Location__c;
                    Id memberLocation = null;
                    if(newvalue.Member__c != null && newvalue.Status__c != label.EPMS_FileStatus_New){                    
                        
                        String memberDesignation = null;
                        if(memberDesignationMap.size() > 0){
                            memberDesignation = memberDesignationMap.get(newvalue.Member__c);
                            if(memberDesignation != null){
                                if(memberDesignation != EPMS_UTIL.EPMS_ARTIST_DES){
                                    if(memberDesignation != EPMS_UTIL.EPMS_TEAM_DES){
                                        if(memberDesignation !=EPMS_UTIL.EPMS_QC_DES){
                                            if(memberDesignation != EPMS_UTIL.EPMS_SHIFT_ADMIN_DES){
                                                Trigger.new[0].addError(label.EPMS_Files_InvalidDesg_ToAssign);
                                            }    
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            
            // File Validation - Ends
            
            // Processing the File Assignment if re-assign to another user
            //} 
        }
        
        if(Trigger.isAfter){
            if(Trigger.isupdate || Trigger.isDelete){            
                Set <ID> prodSet = new Set <ID>();
                Set<Id> oldFileTLs = new Set<Id>();
                Set<Id> oldFileOperators = new Set<Id>();
                Map<Id, String> oldFileStatusMap = new Map<Id, String>();
                for(Files__c fil : Trigger.old)
                {
                    oldFileTLs.add(fil.TLInCharge__c)  ;
                    oldFileOperators.add(fil.Member__c);
                    prodSet.add(fil.Production_Order__c);
                    oldFileStatusMap.put(fil.Id, fil.Status__c);
                }
                
                //   List <Production_Order__c> proList = [SELECT Id, Production_Order_Status__c, (SELECT Id, Status__c FROM Files__r) FROM Production_Order__c WHERE Id IN : prodSet];
                List <Production_Order__c> proupdate = new List <Production_Order__c>();
                
                
                if(Trigger.isupdate || Trigger.isInsert){
                    // Chatter Notification for Operator Assignments (Operators) && Handover Notification (Team Leader)
                    
                    // Sends Chatter Nottification for Spilt Files scenarios 
                    Integer count11 = 0;
                    Integer count22 = 0;
                    Id member11 = null;
                    Id member22 = null;
                    Id chattMember2 = null;
                    Id redoAssignMember = null;
                    //Map<Integer, Id> memberNoIds1 = new Map<Integer, Id>();
                    if(Trigger.isInsert){
                        Integer i=0;
                        for(Files__c newFileValue : Trigger.new){
                            String stringName  = newFileValue.Name;
                            String[] array1 = stringName.split('_copy');
                            if(i==0){
                                count11 = Integer.valueOf(array1[1]);
                                member11 = newFileValue.Member__c;
                            }
                            if(i == 1){
                                count22 = Integer.valueOf(array1[1]);
                                member22 = newFileValue.Member__c;
                            }
                            i++;
                            if(newFileValue.Status__c == label.EPMS_FileStatus_Redo_Re_Assigned){
                                redoAssignMember = newFileValue.Member__c;
                            }
                        }
                        if(count22 > count11){
                            chattMember2 = member22; 
                        }else {
                            chattMember2 = member11; 
                        }
                        if(chattMember == null && redoAssignMember != null){
                            chattMember2 = redoAssignMember;
                        }
                    }
                    Map<String, Object> params = new Map<String, Object>();
                    String filesNames2 = '';
                    Id orderlocation2 = null;
                    String flowStatus2 = null;
                    for(Files__c newFile : Trigger.new){
                        if(newFile.Status__c == label.EPMS_FileStatus_Handover){
                            flowStatus2 = newFile.Status__c;
                            if(oldFileTLs.size() > 0){
                                // Scenario -> If Team leader is changed from old value 
                                if(oldFileTLs.contains(newFile.TLInCharge__c) && oldFileStatusMap.get(newFile.Id) != label.EPMS_FileStatus_Handover){
                                    params.put('TL_Incharge_Id', newFile.TLInCharge__c);
                                }
                            } else {
                                // Scenario -> First Time : When TL is assigned 
                                params.put('TL_Incharge_Id', newFile.TLInCharge__c);
                            }
                            
                            // Add the production order name to single string
                            if(filesNames2 == ''){
                                filesNames2 = newFile.Name;
                                orderlocation2 = newFile.File_Location__c;
                            } else{
                                filesNames2 = filesNames2 + ' , ' + newFile.Name;
                            }
                        } 
                        
                        if(newFile.Status__c == label.EPMS_FileStatus_Assigned || newFile.Status__c == label.EPMS_FileStatus_Redo_Re_Assigned ){
                            flowStatus2 = newFile.Status__c;
                            if(oldFileOperators.size() > 0){
                                // Scenario -> If Team leader is changed from old value 
                                if(!oldFileOperators.contains(newFile.Member__c)){
                                    params.put('TL_Incharge_Id', newFile.Member__c);
                                } 
                            } else {
                                // Scenario -> First Time : When TL is assigned 
                                params.put('TL_Incharge_Id', newFile.Member__c);
                            }
                            
                            if(Trigger.isInsert && chattMember != null){
                                params.put('TL_Incharge_Id', chattMember2);
                            }
                            
                            // Add the production order name to single string
                            if(filesNames2 == ''){
                                filesNames2 = newFile.Name;
                                orderlocation2 = newFile.File_Location__c;
                            } else{
                                filesNames2 = filesNames2 + ' , ' + newFile.Name;
                            }
                            
                            
                        } 
                        
                    }
                    
                    // Adding Order Names into flow parameters
                    params.put('PrdOrderName', filesNames2);            
                    // Adding Location into flow parameters
                    params.put('ProdOrdLocation', orderlocation2);            
                    // Adding Chatter Notification into flow parameters
                    if(flowStatus2 == label.EPMS_FileStatus_Handover){
                        params.put('displayChatterMessage', 'Following Files are in handover status : ');
                    }   
                    if(flowStatus2 == label.EPMS_FileStatus_Assigned || flowStatus2 == label.EPMS_FileStatus_Redo_Re_Assigned){
                        params.put('displayChatterMessage', 'Following Files are assigned to you. Please View these file(s) :  ');
                    }            
                    // Call the Flow           
                    Flow.Interview.Operator_File_Assignment_Notification chatterFlow = new Flow.Interview.Operator_File_Assignment_Notification(params);
                    chatterFlow.start();
                }        
            }
            
        }
        
    }
    
}