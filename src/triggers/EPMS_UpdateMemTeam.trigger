/*****************************************************************************
   Class               :   EPMS_UpdateMemTeam
   Created Date        :   13/04/2016                                                             
   Description         :   This trigger will update the current shift of the member
                           based on the member team
 ******************************************************************************/

trigger EPMS_UpdateMemTeam on Member__c(before update){

  if(Trigger.isBefore){
            if(Trigger.isUpdate){
            system.debug('<MEMBER TRIGGER> : Update Member Records : Initial');
        set<id>memberid=new set<id>();
    for(Member__c member: trigger.new){
        system.debug('<MEMBER TRIGGER> : Update Member Records[New] : ' + member);
        system.debug('<MEMBER TRIGGER> : Update Member Records[Old] : ' + Trigger.oldMap.get(member.Id));
        if(member.Team_Id__c != Trigger.oldMap.get(member.Id).Team_Id__c){
        memberid.add(member.id);

        }
        
        if(member.Designation__c != 'Shift Administrator' && member.Team_Id__c == null){
            member.Current_Shift__c = '';
            system.debug('<MEMBER TRIGGER> : Member Unassigned Case : ' + member);    
        }
    }
    if(memberid.size()>0 && memberid !=null){
        List<Member__c> memNewList=new List<Member__c>();
        Set<Id> memberIds = new Set<Id>();
        for(Member__c memNew:Trigger.New){
            memNewList.add(memNew);
            memberIds.add(memNew.Id);
        }
        Id newTeamId = Trigger.New[0].Team_Id__c;
        String memberDesignation = Trigger.New[0].Designation__c;
        Id oldTeamId = Trigger.Old[0].Team_Id__c;
        Id locationId = Trigger.Old[0].Location_id__c;
        Id newMemberLocationId = Trigger.New[0].Location_id__c;
        Location__c locationDetails = null;

        if(newMemberLocationId != null){
            locationDetails = [SELECT Id, Name FROM Location__c WHERE Id =: newMemberLocationId ];
        }
        
        Team__c teamDetails = null;
        if(newTeamId != null && Trigger.New[0].Id != null){
            if(Trigger.New[0].Status__c == 'Inactive'){
                Trigger.New[0].addError(Label.EPMS_MBO_INACTIVE_USER_NO_ASSIGNMENT); 
            }
            teamDetails = [SELECT Id, Name, Location__c  FROM Team__c WHERE Id =: newTeamId ];
            if(memberDesignation == EPMS_UTIL.EPMS_HOUSEKEEPER_DES|| memberDesignation == EPMS_UTIL.EPMS_PRO_ADMIN_DES || memberDesignation == EPMS_UTIL.EPMS_SHIFT_ADMIN_DES ||  memberDesignation == EPMS_UTIL.EPMS_FM_DES ){
                Trigger.New[0].addError(Label.EPMS_MBO_MEMBER_CHECK_TEAM_MEMBER_DESIGNATION);
            }
            // Team Leader Validations 
            if(memberDesignation == EPMS_UTIL.EPMS_TEAM_DES){
                List<Member__c> tlList = [SELECT Name, Id,Designation__c FROM Member__c WHERE Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS AND Team_Id__c = : newTeamId AND Designation__c =: EPMS_UTIL.EPMS_TEAM_DES];
                if(tlList != null && tlList.size() > 0){
                    if(tlList.size() == 1 && tlList[0].Id != Trigger.New[0].Id){
                        Trigger.New[0].addError(Label.EPMS_MBO_ONE_TL);  
                    } else if(tlList.size() > 1){
                        Trigger.New[0].addError(Label.EPMS_MBO_ONE_TL);
                    }

                }
            }
            // Quality Control Validations 
            if(memberDesignation == EPMS_UTIL.EPMS_QC_DES){
                List<Member__c> qcList = [SELECT Name, Id,Designation__c FROM Member__c WHERE Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS AND Team_Id__c = : newTeamId AND Designation__c =:EPMS_UTIL.EPMS_QC_DES ];
                if(qcList != null && qcList.size() > 0){
                    if(qcList.size() == 1 && qcList[0].Id != Trigger.New[0].Id){
                       Trigger.New[0].addError(Label.EPMS_MBO_ONE_QC);
                    } else if(qcList.size() > 1){
                       Trigger.New[0].addError(Label.EPMS_MBO_ONE_QC);
                    }
                }
            }
        }
        
        if(teamDetails != null){
            if(teamDetails.Location__c != newMemberLocationId){
               Trigger.New[0].addError(Label.EPMS_MBO_TEAM_LOCATION_MISMATCH + ' [' + locationDetails.Name +']');
            }
        }
        
        system.debug('<MEMBER TRIGGER> : newTeamId [New] : ' + newTeamId);        
        Id newTeamShiftCode = null;
        List<Shift_Assignments__c> newAssignment = null;
        
        //List<Shift_Assignments__c> newAssignment = [Select Id, Name, ToTime__c,Shift_Assigned__c,Shift_Code__c,Member__c,Member__r.Team_Id__c  from Shift_Assignments__c 
        //                                            where ToTime__c=NULL AND Shift_Assigned__c=TRUE AND Member__r.Team_Id__c =: newTeamId];

        if(newTeamId != null){
            newAssignment = [Select Id, Name, ToTime__c,Shift_Assigned__c,Shift_Code__c,Member__c,Member__r.Team_Id__c  from Shift_Assignments__c 
                                                    where ToTime__c=NULL AND Shift_Assigned__c=TRUE AND Member__r.Team_Id__c =: newTeamId];
        }                                            
        system.debug('<MEMBER TRIGGER> : Shift Assignment Records : ' + newAssignment);
        if(newAssignment != null && newAssignment.size() > 0){
            newTeamShiftCode = newAssignment[0].Shift_Code__c;
        }
        system.debug('<MEMBER TRIGGER> : New Shift Code : ' + newTeamShiftCode );
        
        Set<Shift_Assignments__c> makeRecords = new Set<Shift_Assignments__c>();
        Set<Shift_Assignments__c> shiftlist= new Set<Shift_Assignments__c>();
        
        
        Map<Id, Id> shiftMemberMap = new Map<Id, Id>();
        list<Shift_Assignments__c> MemShiftList =[Select Id, Name, ToTime__c,Shift_Assigned__c,Shift_Code__c,Member__c,Member__r.Team_Id__c, Member__r.Team_Id__r.Name  from Shift_Assignments__c 
                                                  where Member__c IN:memberIds AND ToTime__c=NULL AND Shift_Assigned__c=TRUE];

            if(MemShiftList != null && MemShiftList.size() > 0){
                for(Shift_Assignments__c assgn : MemShiftList){
                    shiftMemberMap.put(assgn.Member__c, assgn.Shift_Code__c);
                }
            }

       
        // Insert New Members which is added to existing team : Having members
        Set<Id> assignedMemberIds = new Set<Id>();
        if(newAssignment != null && newAssignment.size() > 0){
            for(Shift_Assignments__c assignment : newAssignment){
                assignedMemberIds.add(assignment.Member__c);
            }
        }
        
        list<Member__c> membershift = new list<Member__c>();
        
        if(newTeamShiftCode!=null){
            Shift__c shiftInfo =  [SELECT Id, Name, Implements_From__c, Implements_To__c, Shift_Start_Time__c, Shift_End_Time__c FROM Shift__c WHERE Id =: newTeamShiftCode];            
            system.debug('<MEMBER TRIGGER> : Shift Information : ' + shiftInfo);
            for(Member__c member:trigger.new){ 
                if(member.Team_Id__c==null){
            member.Current_Shift__c = '';
        }else if(shiftInfo != null){
                    member.Current_Shift__c = shiftInfo.Name;
                } 

                membershift.add(member);
            }
        }

    
        if(assignedMemberIds.size() > 0 && memberIds.size() > 0){
            //for(Id member : memberIds){
            for(Member__c member : Trigger.New){
                if(assignedMemberIds.contains(member.Id)){
                    // Ignore the member
                } else if(member.Status__c != EPMS_UTIL.EPMS_DEPUTED_STATUS && member.Team_Id__c !=null){
                     // Insert new shift assignment records
                    Shift_Assignments__c newRecord = new Shift_Assignments__c();
                    newRecord.Shift_Assigned__c=true;
                    newRecord.FromTime__c =system.today();
                    newRecord.Member__c= member.Id;
                    newRecord.Location__c=locationId;
                    newRecord.Shift_Code__c = newTeamShiftCode;
                    if(teamDetails != null){
                        newRecord.Team_Assignment_Id__c= teamDetails.Name;
                    }
                    makeRecords.add(newRecord);
                }   
        
            }
        }
        
       
        if(MemShiftList != null) {
            for(Member__c member:Trigger.New){ 
                for(Shift_Assignments__c shift : MemShiftList){            
                    
                  //  Teamid is null for shift assigned member  
                    if(shift.Member__r.Team_Id__c==null && member.Team_Id__c!=null){
                        shift.ToTime__c=System.Today();
                        shift.Shift_Assigned__c=false;
                        shiftlist.add(shift);  
                    }             
                  //  Teamid is null for member  
                    else if(shift.Member__r.Team_Id__c!=null && member.Team_Id__c==null){                
                        shift.ToTime__c=System.Today();
                        shift.Shift_Assigned__c=false;
                        shiftlist.add(shift);  
                    } 
                    else {
                        
                           if(shift.Member__r.Team_Id__c != member.Team_Id__c && member.Status__c==EPMS_UTIL.EPMS_ACTIVE_STATUS){
                            if(shiftMemberMap.size() > 0 && newTeamShiftCode != null){
                                if(shiftMemberMap.get(shift.Member__c) != newTeamShiftCode){
                                    shift.ToTime__c=System.Today();
                                    shift.Shift_Assigned__c=false;
                                    shiftlist.add(shift);
                                    // Insert new shift assignment records
                                    if(member.Status__c !=EPMS_UTIL.EPMS_DEPUTED_STATUS){
                                        Shift_Assignments__c newRecord = new Shift_Assignments__c();
                                        newRecord.Shift_Assigned__c=true;
                                        newRecord.FromTime__c =system.today();
                                        newRecord.Member__c=shift.Member__c;
                                        newRecord.Location__c=locationId;
                                        newRecord.Shift_Code__c = newTeamShiftCode;
                                        if(teamDetails != null){
                                            newRecord.Team_Assignment_Id__c= teamDetails.Name;
                                        }
                                        makeRecords.add(newRecord);
                                    }
                                } else {
                                     shift.ToTime__c=System.Today();
                                     shift.Shift_Assigned__c=false;
                                     shiftlist.add(shift);  
                                }
                            } else {
                                shift.ToTime__c=System.Today();
                                shift.Shift_Assigned__c=false;
                                shiftlist.add(shift);
                            }
                        }            
                    }
                }
            
        }
        List<Shift_Assignments__c> updtRecords = new List<Shift_Assignments__c>();
        updtRecords.addAll(shiftlist);
        List<Shift_Assignments__c> insertRecords = new List<Shift_Assignments__c>();
        insertRecords.addAll(makeRecords);
        
        if(updtRecords.size() > 0){         
            update updtRecords;         
        }
        
        
        if(insertRecords.size() > 0){
            insert insertRecords;
        }
        
        if(membershift.size() > 0){
          //  update membershift;   
        }


    }
    }
}
}
}