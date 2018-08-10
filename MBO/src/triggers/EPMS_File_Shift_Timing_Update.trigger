trigger EPMS_File_Shift_Timing_Update on Files__c (before insert, before update) {

    List<Files__c> oldFilesList = Trigger.old;
    List<Files__c> newFilesList = Trigger.new;
    Map<Id,String> memberShiftMap = new Map<Id, String>();
    Set<String> shiftNames = new Set<String>();

        for(Files__c newFile : newFilesList){
            system.debug('New File Name   : ' + newFile.Name + ' Status : ' + newFile.Status__c);
            system.debug('New File Member : ' + newFile.Member__r.Name + ' New Member Shift : ' + newFile.Member_Shift__c);
            if(Trigger.isUpdate && Trigger.isBefore){
                Files__c oldFile = Trigger.oldMap.get(newFile.Id);
                system.debug('Old File Name : ' + oldFile.Name + ' Status : ' + oldFile.Status__c);
                system.debug('Old File Member : ' + oldFile.Member__r.Name + ' Old Member Shift : ' + oldFile.Member_Shift__c);
                if(oldFile != null && oldFile.Member__c != newFile.Member__c){
                    memberShiftMap.put(newFile.Member__c,newFile.Member_Shift__c);
                    shiftNames.add(newFile.Member_Shift__c);    
                }
            } else if(Trigger.isInsert && Trigger.isBefore){
                system.debug('New File Creation Scenario : ');
                if(newFile.Member_Shift__c != null){
                    memberShiftMap.put(newFile.Member__c,newFile.Member_Shift__c);
                    shiftNames.add(newFile.Member_Shift__c);    
                    system.debug('Inside the copy or split file case : ' + shiftNames);
                }
            }
            
        }

    
    system.debug('Shift Name Set : ' +shiftNames);
    system.debug('Member Shift Map : ' + memberShiftMap);
    
    Map<String, DateTime> shiftStartTimeMap = new Map<String, DateTime>();
    Map<String, DateTime> shiftEndTimeMap = new Map<String, DateTime>();
    
    if(shiftNames != null && shiftNames.size() > 0){
        
        List<Shift__c> shiftInfoList = [SELECT Id, Name, Shift_End_Time__c, Shift_Start_Time__c FROM Shift__c WHERE Name IN : shiftNames];
        
        if(shiftInfoList != null && shiftInfoList.size() > 0){
            for(Shift__c newShift : shiftInfoList){
                system.debug(' Existing Shift Information : Start Time $$ ' + newShift.Shift_Start_Time__c);
                system.debug(' Existing Shift Information : End Time $$ ' + newShift.Shift_End_Time__c);
                system.debug(' Existing Shift Information : Shift Name $$ ' + newShift.Name);
                shiftStartTimeMap.put(newShift.Name, newShift.Shift_Start_Time__c);
                shiftEndTimeMap.put(newShift.Name, newShift.Shift_End_Time__c); 
            }
        }
         system.debug('Shift Start Map : ' + shiftStartTimeMap);
         system.debug('Shift End Map : ' + shiftEndTimeMap);
    }
    
    
    if(shiftStartTimeMap != null && shiftEndTimeMap != null){
        
        for(Files__c newFile : newFilesList){
            if(shiftStartTimeMap.size() > 0){
                // Difference Between Shift Start Date and End Date
                Integer diff = math.round(Integer.valueOf((shiftEndTimeMap.get(newFile.Member_Shift__c).getTime() - shiftStartTimeMap.get(newFile.Member_Shift__c).getTime())/1000));
                system.debug('Shift Difference : ' + diff);
                
                // update today date and time
                Date todayDate = System.today();
                // Shift Start Time
                Integer shiftstartMinute = shiftStartTimeMap.get(newFile.Member_Shift__c).minuteGMT();
                Integer shiftstarthour = shiftStartTimeMap.get(newFile.Member_Shift__c).hourGMT();
                Integer shiftstartsecond = shiftStartTimeMap.get(newFile.Member_Shift__c).secondGMT();

                DateTime dt = DateTime.newInstanceGMT(todayDate.year(),todayDate.month(),todayDate.day(),shiftstarthour,shiftstartMinute,shiftstartsecond);
                system.debug('Case 2 = Shift start date : ' + dt);
                // Shift End Time
                Integer shiftendMinute = shiftEndTimeMap.get(newFile.Member_Shift__c).minuteGMT();
                Integer shiftendhour = shiftEndTimeMap.get(newFile.Member_Shift__c).hourGMT();
                Integer shiftendsecond = shiftEndTimeMap.get(newFile.Member_Shift__c).secondGMT();

                DateTime dt2 = DateTime.newInstanceGMT(todayDate.year(),todayDate.month(),todayDate.day(),shiftstarthour,shiftstartMinute,shiftstartsecond);
                dt2 = dt2.addSeconds(diff);
                system.debug('Case 4 = Shift End Time date : ' + dt2);
                newFile.Shift_Start_Time__c = dt;
                newFile.Shift_End_Time__c = dt2;
                newFile.File_Shift__c = memberShiftMap.get(newFile.Member__c);
                system.debug('File Member Shift : Re-Assign : ' + newFile.File_Shift__c);
            } else {
                // File Un-assignment
                if(Trigger.isUpdate && Trigger.isBefore){

                    Files__c oldFile2 = Trigger.oldMap.get(newFile.Id);
                    if(newFile.Status__c == 'New' && oldFile2.Status__c == 'Assigned'){
                        system.debug('New Member : ' + newFile.Member__c);
                        if(newFile.Member__c != null){
                            newFile.Status__c = 'Assigned';
                            system.debug(' Other Assigned Member Shift Update : File - ' + newFile);
                        } else {
                            system.debug('Un-assigned Member Shift Update');
                            newFile.Shift_Start_Time__c = shiftStartTimeMap.get(newFile.Member_Shift__c);
                            newFile.Shift_End_Time__c = shiftEndTimeMap.get(newFile.Member_Shift__c);
                            system.debug('Un-assigned Member Shift Update : File - ' + newFile);
                            newFile.File_Shift__c = '';
                            system.debug('File Member Shift : Un Assign' + newFile.File_Shift__c);
                        }
                    }
                }    
            }
            
        }
    }
    
    
}