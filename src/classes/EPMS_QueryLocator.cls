/****************************************************************************
*   Class               :       Query Locator                               *
*   Created Date        :       11/09/2015                                  *           
*   Description         :       To return the requested Result              *
*                               based on the request by service class       *
*                               will be used as the Common Class            *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/

public with sharing class EPMS_QueryLocator{
    
    public Member__c member = null;
    public List<File_Categories__c> incentiveList = null;
    public List<Location__c> locationList = null;
    public string selLoc{public get;public set;}
    Location__c locObj = null;
    List<Profile> profile = null;
    
    // Added for shift Assignment controller
    public String MyProflieName{get;set;}
    public Shift__c shiftInfo = null;
    public List<Member__c> memberList = null;
    public List<Member__c> memberListAllLocation = null;
    public List<Member__c> memberListWithShiftAdmin = null;
    public List<Member__c> memberListSelected = null;
    public List<Shift__c> shiftdetails = null;
    public List<Shift__c> allShiftdetails = null;
    public List<Shift__c> allShiftInLocation = null;
    public List<Team__c> teamdetails = null; 
    public List<Team__c> teamdetailslist = null;
    public List<Shift_Assignments__c> shiftAssignList = null;
    public List<Shift_Assignments__c> shiftAssignList2 = null;
    public List<Shift_Assignments__c> shiftAssignList4 = null;
    public List<Shift_Assignments__c> teamAssignList = null;
    public List<Shift_Assignments__c> allTeamAssignList = null;
    public List<Shift_Assignments__c> allTeamAssignList2 = null;
    public List<Shift_Assignments__c> userAssignList = null;
    public List<Member__c> membersInfo = null;
    public List<Shift_Assignments__c> userShiftOrTeamAssignment = null;
    public List<Shift_Assignments__c> userShiftOrTeamAssignment2 = null;
    public List<Files__c> memberFileList = null;
    public Shift_Assignments__c assignedInfo = null;
    public List<Production_Order__c> pendingOrderList = null;
    public List<Shift_Assignments__c> assignedInfos = null;
    public List<Member__c> membersInLocation = null;
    
    //Return the List of Profile based User Login
    public List<Profile> getProfiles(){
        try{
             profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
             MyProflieName= profile[0].Name;
         }catch(Exception e){
              System.debug(e);  
         }
       return profile ;
    }
    
    //Return the Member Details to List 
    public Member__c getMember(){
    
        try{
            if(MyProflieName=='Production Administrator' || MyProflieName=='Shift Administrator' || MyProflieName=='IT Administrator' || MyProflieName=='Team Leader')
            member  = [select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where User_Id__c =:userinfo.getuserid()];
        }catch(Exception e){
          System.debug(e);  
        }
        return member;
    }
    
    //Return the Incentive list based on the location Provided
    public List<File_Categories__c> getIncentiveList(){
        try{
            
                incentiveList = [SELECT Name,Standard_Target_Per_Day__c,Standard_Time_per_File_Min__c, 
                Standard_Time_per_File_Max__c, Standard_OptionalCost_Parameter__c, Standard_OptionalCost_Per_Day__c, 
                Standard_OptionalCost_Per_file__c,  
                Standard_RegularCost_Per_Day__c, Standard_Regular_Cost_per_File__c from File_Categories__c  order by Name asc ];
           
        }catch(Exception e){
      System.debug(e);  
        }
        return incentiveList;
    }
        
    //Return the Standard operation Cost  location 
    public location__c getCostByLoc(Id locId){
      try{
          if(locId != null){
              locObj =  [Select Name,Location_Country__c, Standard_Regular_Cost__c  from location__c where id = :locId];
           }
      }catch(Exception e){
          System.debug(e);  
      }
        return locObj;
    }
    
    //Return the Location
    public List<Location__c> getLocations(){
     try{
        locationList = [select id,Name from Location__c where Location_Status__c = 'Active' ORDER BY Name ASC];
        }catch(Exception e){
          System.debug(e);  
      }
        return locationList;
    }
    
    
     public List<Member__c> getMemberListAssociatedLocation(){
        memberList = new List<Member__c>();
         system.debug('##@@##');
        try{
           system.debug('####'+userinfo.getuserid() );
            // Retrieve the logged member details 
            Member__c loggedMember = [select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where User_Id__c =: userinfo.getuserid() AND Status__c='Active' ORDER BY Name ASC];
            system.debug('##loggedMember ##'+loggedMember );
            // Retrieve the list of active members associated with logged member's location
            memberList = [SELECT Id, Name, Location_id__c, Location_id__r.Name, First_Name__c, Designation__c FROM Member__c WHERE Location_id__c =: loggedMember.Location_id__c AND Id !=: loggedMember.Id AND Status__c='Active' AND Designation__c != 'Production Administrator' ORDER BY Name ASC];
            system.debug('##memberList ##'+memberList );
         }catch(Exception e){
              System.debug(e);  
          }
        return memberList;
    }
    
    // Retrieve the available shift in logged user's location
    
    public List<Shift__c> getAvailableShiftInLocation(){
        
        try{
            // Retrieve the logged member details 
            Member__c loggedMember = getMember();
            
            // Retrieve the available shift in logged user's location
            shiftdetails=[select id,Name, Implements_From__c, Implements_To__c, Shift_Start_Time__c, Shift_End_Time__c from Shift__c WHERE Shift_Location__c=:loggedMember.Location_id__c AND Status__c='Active' AND (Implements_To__c >:System.now() OR Implements_To__c =null) ORDER BY Name ASC];
            
         }catch(Exception e){
          System.debug(e);  
        }
        return shiftdetails;
        
    }
    
    // Retrieve the available team in logged user's location
    
    public List<Team__c> getAvailableTeamInLocation(){
        
        try{
            // Retrieve the logged member details 
            Member__c loggedMember = getMember();
    
            teamdetails= [select id,Name from Team__c WHERE Location__c=:loggedMember.Location_id__c ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return teamdetails;
    }
    
    public List<Shift_Assignments__c> getAllShiftAssignmentInfo(Set<Id> members){
        
        try{
            shiftAssignList = [SELECT Id, Name, Member__c,  Shift_Code__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return shiftAssignList;
    }
    
    public List<Shift_Assignments__c> getTeamAssignmentInfo(Set<Id> members, Id CurrentTeams){
        
        try{
            teamAssignList = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c FROM Shift_Assignments__c WHERE Member__c IN : members AND Member__r.Team_Id__c =: CurrentTeams  AND Shift_Assigned__c = true]; // false
        }catch(Exception e){
            System.debug(e);  
        }
        return teamAssignList;
    }
    
    //Shift Un Assigned Section 
     public List<Shift_Assignments__c> retrieveShiftUnAssignmentDetails(Set<Id> members, String type, String fromDate, String toTime){
        shiftAssignList2 = new List<Shift_Assignments__c>();
        try{
            Date fromdt = null;
            Date todt = null;
            String fromdateTimeFormat;
            String todateTimeFormat;
           
            if(String.isNotEmpty(fromDate)){
                  fromdt = Date.parse(fromDate);
            }
            if(String.isNotEmpty(toTime)){
                todt = Date.parse(toTime);
            }

            if(type == 'Team'){

                if(String.isNotEmpty(fromDate) && String.isEmpty(toTime)){
                    shiftAssignList2 = [SELECT Id, Name, Member__c,  Shift_Code__c,Shift_Code__r.Name, ToTime__c, FromTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true AND (((FromTime__c <=: fromdt OR FromTime__c >=: fromdt) AND ToTime__c=NULL) OR ((FromTime__c >=: fromdt OR FromTime__c <=: fromdt) AND ToTime__c>=: fromdt)) ];
                } else if (String.isNotEmpty(fromDate) && String.isNotEmpty(toTime)){
                     shiftAssignList2 = [SELECT Id, Name, Member__c,  Shift_Code__c,Shift_Code__r.Name, ToTime__c, FromTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true AND ((FromTime__c <=: todt AND ToTime__c >=: fromdt) OR ToTime__c = null)]; 
                } else {
                    shiftAssignList2 = [SELECT Id, Name, Member__c,  Shift_Code__c,Shift_Code__r.Name, ToTime__c, FromTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true AND (ToTime__c >: System.Today()  OR ToTime__c = null) ];
                }
            
            } else if (type == 'Shift'){

                if(String.isNotEmpty(fromDate) && String.isEmpty(toTime)){
                    shiftAssignList2 = [SELECT Id, Name, Member__c,  Shift_Code__c, ToTime__c, FromTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true AND (((FromTime__c <=: fromdt OR FromTime__c >=: fromdt) AND ToTime__c=NULL) OR ((FromTime__c >=: fromdt OR FromTime__c <=: fromdt) AND ToTime__c>=: fromdt)) ];
                } else if (String.isNotEmpty(fromDate) && String.isNotEmpty(toTime)){
                    shiftAssignList2 = [SELECT Id, Name, Member__c,  Shift_Code__c, ToTime__c, FromTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true AND ((FromTime__c <=: todt AND ToTime__c >=: fromdt) OR ToTime__c = null)]; 
                } else {
                    shiftAssignList2 = [SELECT Id, Name, Member__c,  Shift_Code__c, ToTime__c, FromTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true AND (ToTime__c >: System.Today()  OR ToTime__c = null) ]; // AND (ToTime__c >: System.now() OR ToTime__c = null)--- OR ToTime__c <: Date.parse(dt)
                }
             }
        }catch(Exception e){
            System.debug(e);  
        }
        return shiftAssignList2;
    } 
    
  
    public List<Shift_Assignments__c> getAllTeamAssignmentInfo(Set<Id> members){
        
        try{
            allTeamAssignList = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Assigned__c = true]; // false
        }catch(Exception e){
            System.debug(e);  
        }
        return allTeamAssignList;
    }
    
    public List<Shift_Assignments__c> getUserAssignmentInfo(Id memberId, String type){
        
        try{
            if(type == 'Team'){
                userAssignList = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c FROM Shift_Assignments__c WHERE Member__c = : memberId  AND Shift_Assigned__c = true];
            } else if (type == 'Shift') {
                userAssignList = [SELECT Id, Name, Member__c,  Shift_Code__c FROM Shift_Assignments__c WHERE Member__c = : memberId  AND Shift_Assigned__c = true];
            }
        }catch(Exception e){
            System.debug(e);  
        }

        return userAssignList;
    }
    
    // Get the list of shift assignments of members in a location for specific shift or team
    
    public List<Shift_Assignments__c> getUserAssignmentForShiftOrTeam(Set<Id> members, Id teamOrShift, String type){
        
        try{
            if(type == 'Team'){
                userShiftOrTeamAssignment = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c FROM Shift_Assignments__c WHERE Member__c IN : members AND Member__r.Team_Id__c =: teamOrShift AND Shift_Assigned__c = true ]; 
                
            } else if (type == 'Shift'){
                userShiftOrTeamAssignment = [SELECT Id, Name, Member__c,  Shift_Code__c FROM Shift_Assignments__c WHERE Member__c IN : members AND Shift_Code__c =: teamOrShift AND Shift_Assigned__c = true ];
            }
        }catch(Exception e){
            System.debug(e);  
        }   
        return userShiftOrTeamAssignment;
    }
    
    public List<Shift_Assignments__c> retrieveShiftAssignmentDetails(Set<Id> members, Id teamOrShift, String type, String fromDate, String toTime){
        
       try{
            String dateTimeFormat = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\''); 

            Date fromdt = null;
            Date todt = null;
            List<String> SplitHolder;
            
            String CnvtFromDate;
            String CnvtToDate;
             
            if(String.isNotEmpty(fromDate)){
                  fromdt = Date.parse(fromDate);
              
            }
            if(String.isNotEmpty(toTime)){
                todt = Date.parse(toTime);
                
            }
            
            if(type == 'Team'){

                if(String.isNotEmpty(fromDate) && String.isEmpty(toTime)){
                    userShiftOrTeamAssignment2 = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c, Shift_Code__c, Shift_Code__r.Name FROM Shift_Assignments__c WHERE Member__c IN : members AND Member__r.Team_Id__c =: teamOrShift AND Shift_Assigned__c = true AND (((FromTime__c <=: fromdt OR FromTime__c >=: fromdt) AND ToTime__c=NULL) OR ((FromTime__c >=: fromdt OR FromTime__c <=: fromdt) AND ToTime__c>=: fromdt))]; 
                } else if (String.isNotEmpty(fromDate) && String.isNotEmpty(toTime)){
                    userShiftOrTeamAssignment2 = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c, Shift_Code__c, Shift_Code__r.Name FROM Shift_Assignments__c WHERE Member__c IN : members AND Member__r.Team_Id__c =: teamOrShift AND Shift_Assigned__c = true AND ((FromTime__c <=: todt AND ToTime__c >=: fromdt) OR ToTime__c = null)];
                } else {
                    userShiftOrTeamAssignment2 = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c, Shift_Code__c, Shift_Code__r.Name FROM Shift_Assignments__c WHERE Member__c IN : members AND Member__r.Team_Id__c =: teamOrShift AND Shift_Assigned__c = true] ;  // AND ToTime__c >=:system.now() AND ToTime__c = null
                   
                }
                
            } else if (type == 'Shift'){
                 if(String.isNotEmpty(fromDate) && String.isEmpty(toTime)){
                    userShiftOrTeamAssignment2 = Database.Query('SELECT Id, Name, Member__c,  Shift_Code__c FROM Shift_Assignments__c WHERE Member__c IN : members AND Shift_Code__c =: teamOrShift AND Shift_Assigned__c = true AND (((FromTime__c <=:fromdt OR FromTime__c >=: fromdt) AND ToTime__c=NULL) OR ((FromTime__c >=:fromdt OR FromTime__c <=: fromdt) AND ToTime__c>=:fromdt))  '); 
                } else if (String.isNotEmpty(fromDate) && String.isNotEmpty(toTime)){
                    userShiftOrTeamAssignment2 = [SELECT Id, Name, Member__c,  Shift_Code__c FROM Shift_Assignments__c WHERE Member__c IN : members AND Shift_Code__c =: teamOrShift  AND Shift_Assigned__c = true AND ((FromTime__c <=: todt AND ToTime__c >=: fromdt) OR ToTime__c = null) ];
                } else {
                    userShiftOrTeamAssignment2 = [SELECT Id, Name, Member__c,  Shift_Code__c FROM Shift_Assignments__c WHERE Member__c IN : members AND Shift_Code__c =: teamOrShift  AND Shift_Assigned__c = true ]; // AND ToTime__c >=:system.now() AND ToTime__c = null   
                }
            }
        }catch(Exception e){
            System.debug(e);  
        }   
        return userShiftOrTeamAssignment2;
    }

  
    // Get Member details of list of member member

    public List<Member__c> getMembersInfo(List<String> memberIds){
        try{
            membersInfo = [SELECT Id, Name, Designation__c, User_Id__c, First_Name__c, Last_Name__c FROM Member__c WHERE Id IN : memberIds AND Status__c='Active'];
        }catch(Exception e){
            System.debug(e);  
        }
        return membersInfo;
    }
    
    // Get the shift information for input shift code 

    public Shift__c getShiftInfo(Id shiftId){
        try{
            shiftInfo = [SELECT Id, Name, Implements_From__c, Implements_To__c, Shift_Start_Time__c, Shift_End_Time__c FROM Shift__c WHERE Id =: shiftId];
        }catch(Exception e){
            System.debug(e);  
        }
        return shiftInfo;
    }
    

    
    // Get the List of pending orders assingned to list of member
    public List<Production_Order__c> getAllPendingProductionOrders(Set<Id> memberIds){
        try{
            if(memberIds.isEmpty() == false){
                pendingOrderList= [SELECT Id, Name, QC_Incharge__c, TL_Incharge__c, Production_Order_Id__c, Production_Order_Status__c FROM Production_Order__c WHERE (QC_Incharge__c IN: memberIds OR TL_Incharge__c IN: memberIds) AND Production_Order_Status__c != 'Completed' AND Production_Order_Status__c != 'Cancelled' AND Production_Order_Status__c != 'Uploaded'];
            }
        }catch(Exception e){
            System.debug(e);  
        }
        return pendingOrderList;
    }
    
    // Get the List of files assingned to list of member
    public List<Files__c> getAllFilesListAssignedToMember(Set<Id> memberIds){
        try{
            if(memberIds.isEmpty()== false){
                memberFileList = [SELECT Id, Name, Member__c, Status__c FROM Files__c WHERE Member__c IN: memberIds AND Status__c != 'Completed' AND Status__c != 'Cancelled' AND Status__c != 'Deleted' ];
            }
        }catch(Exception e){
            System.debug(e);  
        }
        return memberFileList;
    }
    
    
    // Retrieve the assignment information of particular shift or team

    public List<Shift_Assignments__c> getUserAssignedInfos(Set<Id> members, Id teamOrShiftId, String type){
        try{
            if(type == 'Team'){
                assignedInfos = [SELECT Id, Shift_Assigned__c, Member__r.Team_Id__c FROM Shift_Assignments__c WHERE Member__c IN : members AND Member__r.Team_Id__c =: teamOrShiftId AND Shift_Assigned__c = true];

            } else if (type == 'Shift'){
                assignedInfos = [SELECT Id, Name, Shift_Assigned__c, Shift_Code__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Code__c =: teamOrShiftId AND Shift_Assigned__c = true];

            }
        }catch(Exception e){
            System.debug(e);  
        }
        return assignedInfos ;
    }
    
    // Retrieve all the available shift exists
    
    public List<Shift__c> getAllShiftList(){
    
        try{
            // Retrieve the available shift in logged user's location
            allShiftdetails=[select id,Name, Implements_From__c, Implements_To__c, Shift_Start_Time__c, Shift_End_Time__c from Shift__c WHERE Status__c='Active' ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return allShiftdetails;
    
    }
    
     // Retrieve the available team exists
    public List<Team__c> getAllTeamList(Id locationId){
        
        try{
            teamdetailslist= [select id,Name from Team__c where Location__c =: locationId ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return teamdetailslist;
    }
    
    // Retrieve the all members 
    public List<Member__c> getAllMemberInLocation(){
         try{
            memberListAllLocation = [SELECT Id, Name, Location_id__c, First_Name__c, Designation__c FROM Member__c WHERE Status__c='Active' ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return memberListAllLocation;
    }
    
    // Retrieve the all members except shift admin
    public List<Member__c> getAllExceptSAMemberInLocation(){
         try{
             
             // Retrieve the logged member details 
            Member__c loggedMember = getMember();
             
            // memberListWithShiftAdmin = [SELECT Id, Name, Location_id__c, First_Name__c, Designation__c FROM Member__c WHERE Status__c='Active' AND Designation__c != 'Shift Administrator' AND Designation__c != 'Production Administrator'];
            memberListWithShiftAdmin = [SELECT Id, Name, Location_id__c, First_Name__c, Designation__c FROM Member__c WHERE Location_id__c =: loggedMember.Location_id__c AND Id !=: loggedMember.Id AND Status__c='Active' AND Designation__c != 'Shift Administrator' AND Designation__c != 'Production Administrator'];
        }catch(Exception e){
            System.debug(e);  
        }
        return memberListWithShiftAdmin;
    }
    public List<Member__c> getSelectedMemberDetails(Set<Id> members, Id locationId){
         try{
            if(locationId != null){
                memberListSelected = [SELECT Id, Name, Location_id__c, First_Name__c, Designation__c FROM Member__c WHERE Status__c='Active' AND Id NOT IN : members AND Location_id__c =: locationId AND Designation__c != 'Production Administrator'];        
            } else{
                memberListSelected = [SELECT Id, Name, Location_id__c, First_Name__c, Designation__c FROM Member__c WHERE Status__c='Active' AND Id NOT IN : members AND Designation__c != 'Production Administrator'];
            }            
        }catch(Exception e){
            System.debug(e);  
        }
        return memberListSelected;
   
    }
    
      // Holiday RECORD LIST
     
    
    
    //LOCATION PICKLIST FOR  HOLIDAY
    public List<SelectOption> getlocation(){
        List <SelectOption> location = new List<SelectOption>();
        location.add(new SelectOption('','Select '));
        for(Location__c alllocation:[select Location_Country__c,Name,id from Location__c where Location_Status__c=:'Active' ORDER BY Name]){
            location.add(new SelectOption(alllocation.id,alllocation.Name));
        }
        return location;
    }
    
    
    //SHOW SHIFT PICKLIST  FOR  HOLIDAY
    public  List<SelectOption> getshift(String shiftid){
        getmember();
        getProfiles();
        List <SelectOption> shift = new List<SelectOption>();
        if(MyProflieName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME){
            if(shiftid!=null){
                shift.add(new SelectOption('','Select '));
                for(Shift__c allshift:[select Name,id from Shift__c where Shift_Location__c=:shiftid AND Status__c=:'Active' ORDER BY Name]){
                    If(allshift.Name!= null){
                        shift.add(new SelectOption(allshift.id,allshift.Name));
                    }
                }
              
                }else{
                
                shift.add(new SelectOption('','Select '));
                for(Shift__c allshift:[select Name,id from Shift__c where  Status__c=:'Active' ORDER BY Name]){
                    
                    If(allshift.name!= null){
                        //shift.add(new SelectOption(allshift.id,allshift.Name));
                    }
                }
            }
            }else if(MyProflieName == EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME){
            shift.add(new SelectOption('','Select '));
            for(Shift__c allshift:[select Name,id from Shift__c where Shift_Location__r.Name=:member.Location_id__r.Name AND Status__c=:'Active' ORDER BY Name]){
                
                If(allshift.Name!= null){
                    shift.add(new SelectOption(allshift.ID,allshift.Name));
                }
            }
        }
        return shift;
    }
    
    
    
     
    
    
     //Return the Location
    public List<Location__c> getAllLocations(){
     try{
        locationList = [select id,Name from Location__c where Location_Status__c = 'Active' ORDER BY Name ASC];
        }catch(Exception e){
          System.debug(e);  
      }
        return locationList;
    }
    
    public List<Member__c> getMembersInLocation(Id locationId){
        membersInLocation = new List<Member__c>();
        try{
           
            // Retrieve the list of active members associated with location selected by system administration.
            membersInLocation = [SELECT Id, Name, Location_id__c, Location_id__r.Name, First_Name__c, Designation__c FROM Member__c WHERE Location_id__c =: locationId AND Status__c='Active' AND Designation__c != 'Production Administrator'];
         }catch(Exception e){
              System.debug(e);  
          }
        return membersInLocation;
    }
    
   
    public List<Shift__c> getAllShiftListForSelectedLocation(Id locationId){
    
         try{
            // Retrieve the available shift in logged user's location
            allShiftInLocation =[select id,Name, Implements_From__c, Implements_To__c, Shift_Start_Time__c, Shift_End_Time__c from Shift__c WHERE Status__c='Active' AND Shift_Location__c=: locationId ORDER BY Name ASC];
            // (Implements_To__c >:System.now() OR Implements_To__c =null)
         }catch(Exception e){
          System.debug(e);  
         }
           return allShiftInLocation;
    }
    
    
     @TestVisible private Date setStringToDateFormat(String myDate) {
       String[] myDateOnly = myDate.split(' ');
       String[] strDate = myDateOnly[0].split('/');
       Integer myIntDate = integer.valueOf(strDate[1]);
       Integer myIntMonth = integer.valueOf(strDate[0]);
       Integer myIntYear = integer.valueOf(strDate[2]);
       Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
       return d;
    }

    //Shift Un Assigned Section 
     public List<Shift_Assignments__c> retrieveTeamUnAssignmentDetails(Set<Id> members, String type, String fromDate, String toTime){
        shiftAssignList4 = new List<Shift_Assignments__c>();
        try{
            Date fromdt = null;
            Date todt = null;
            String fromdateTimeFormat;
            String todateTimeFormat;
           
             if(String.isNotEmpty(fromDate)){
                  fromdt = Date.parse(fromDate);
              
            }
            if(String.isNotEmpty(toTime)){
                todt = Date.parse(toTime);
                
            }
            if(type == 'Team'){
            
                 if(String.isNotEmpty(fromDate) && String.isEmpty(toTime)){
                    shiftAssignList4 = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c, Shift_Code__c, FromTime__c, ToTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Code__c != null AND Shift_Assigned__c = true AND (((FromTime__c <=: fromdt OR FromTime__c >=: fromdt) AND ToTime__c=NULL) OR ((FromTime__c >=: fromdt OR FromTime__c <=: fromdt) AND ToTime__c>=: fromdt)) ]; 
                 } else if (String.isNotEmpty(fromDate) && String.isNotEmpty(toTime)){
                    shiftAssignList4 = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c, Shift_Code__c, FromTime__c, ToTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Code__c != null AND Shift_Assigned__c = true AND ((FromTime__c <=: todt AND ToTime__c >=: fromdt) OR ToTime__c = null)]; 
                } else {
                    shiftAssignList4 = [SELECT Id, Name, Member__c,  Member__r.Team_Id__c, Shift_Code__c, FromTime__c, ToTime__c FROM Shift_Assignments__c WHERE Member__c IN : members  AND Shift_Code__c != null AND  Shift_Assigned__c = true AND (ToTime__c >: System.Today()  OR ToTime__c = null)]; // false
                }
            
            } 
       }catch(Exception e){
              System.debug(e);  
          }
    
       return shiftAssignList4;

       }
       
    
    List<Files__c> fileList = new List<Files__c>();
    
   List<Files__c> orderInfoList  = new List<Files__c>();
   public List<Files__c> getOrderInfoDetails(Id orderId){
   
       orderInfoList = [select File_Job_Titles__c,Production_Order__r.Total_File_Count__c,Production_Order__r.Production_Order_TAT__c,Production_Order__r.TL_incharge__c,Production_Order__r.QC_incharge__c,Production_Order__r.name,Production_Order__r.Production_order_status__c, Production_Order__r.Production_Order_Instruction__c,Production_Order__r.id from Files__c where Production_Order__c = :orderId ];
       
       return orderInfoList;
   }
  
   
}