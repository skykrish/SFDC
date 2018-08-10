/*****************************************************************************
   Class               :   EPMS_Create_User  
   Created Date        :   13/04/2016                                                             
   Description         :   Upon Member creation, this trigger will generate EmpID
                           for members and create User records using the member
                           details
  
 ******************************************************************************/
trigger EPMS_Create_User  on Member__c (before insert,after insert,before update,after update) {


    public set<id> MemberID = new set<id>();
    public static id usrID;
    Set<String> MemberEmails = new Set<String>();
     EPMS_MemberQueryLocator  queryobj = new EPMS_MemberQueryLocator ();
     
     list<string> memgroup = new list<string>();
    
    for(Member__c m:Trigger.new){
        MemberID.add(m.id);
    }
    
        if(Trigger.isBefore && Trigger.isInsert && !system.isBatch()){
            
            String designation = trigger.new[0].Designation__c;
            if(designation == EPMS_UTIL.EPMS_HOUSEKEEPER_DES && trigger.new[0].Enable_Login__c==true){
                 Trigger.new[0].addError(label.EPMS_HouseKeeperDesg_Validation);    
            }
            
            if(trigger.new[0].User_Id__c==null) {

                EPMS_MemberQueryLocator query = new EPMS_MemberQueryLocator();  
                List<Location__c> LocationCountry = query.getLocationCountryName(Trigger.new);
                set<string>memebercountry = new set<string>();
                
                
                
                for(Member__c MemCountry : Trigger.new){                
                    memebercountry.add(MemCountry.Country__c);                      
                }
                
                
                    if(LocationCountry.size()>0)
                    {
                        for(Location__c LocationCountryDetails : LocationCountry)
                        {
                            if(memebercountry.contains(LocationCountryDetails.Location_Country__c)&& memebercountry.size()>0)
                            {

                            }
                            else{                        
                                Trigger.new[0].addError(Label.EPMS_MBO_COUNTRY);
                            }
                        }
                    }else{
                        Trigger.new[0].addError(Label.EPMS_MBO_NOCOUNTRY);
                    }
                            
                            
                    //For Adding Employee ID Based on Country Choosed
                    Employee_Country_Code__c ConutryCode= Employee_Country_Code__c.getInstance(trigger.new[0].country__c);
                    List<Member__c> memberDetails= query.getAutoincrementNumber(Trigger.new);                    
                  
                    String Auto='';
                    if(memberDetails.size() > 0){
                        Auto=memberDetails[0].Emp_ID__c;    
                    }else{
                        Auto=ConutryCode.Country_Initial_Letter__c+'000000';
                    }
                        
                    String InitailString=Auto.substring(1,Auto.length());
                    String MemberIDHolder='';
                    Integer Totalvalue=0;
                    Integer converted=Integer.valueof(InitailString);
                    String Holder=String.valueof(converted);
                    
                    if(Holder.length() > = 6){
                        Totalvalue=Integer.valueof(InitailString);

                        Totalvalue=Totalvalue+1;
                        MemberIDHolder=String.valueof(Totalvalue);
                        
                    }else{
                        Totalvalue=Integer.valueof(InitailString);
                        Totalvalue=Totalvalue+1; 
                        String runnableString=String.valueof(Totalvalue);
                        for(Integer inc=1; inc<=6-runnableString.length();inc++){
                            MemberIDHolder=MemberIDHolder+String.valueof(0);
                        }
                        MemberIDHolder=MemberIDHolder+Totalvalue;
                       
                    }
                    trigger.new[0].Emp_ID__c = ConutryCode.Country_Initial_Letter__c+MemberIDHolder;
                                         
                    if(trigger.new[0].Enable_Login__c){

                        if(designation == EPMS_UTIL.EPMS_PRO_ADMIN_DES|| designation == EPMS_UTIL.EPMS_TEAM_DES || designation == EPMS_UTIL.EPMS_QC_DES || designation == EPMS_UTIL.EPMS_ARTIST_DES
                                 || designation == EPMS_UTIL.EPMS_SHIFT_ADMIN_DES || designation == EPMS_UTIL.EPMS_FM_DES || designation == EPMS_UTIL.EPMS_ITADMIN_DES || designation =='Assignor' || designation =='Estimator' || designation =='Operator PS' || designation ==Label.EPMS_Delivery_Designation){
                                usrID = EPMS_UserService.Createu(Trigger.new);  
                        }
                          
                    }
                    
                    trigger.new[0].User_Id__c = usrID;
                
                
                  
            }
        }
    
        
       if(Trigger.isBefore && Trigger.isUpdate &&!system.isBatch()){
       
            String designation = trigger.new[0].Designation__c;
            // validation for house keeper designation while creating members 
            if(designation == EPMS_UTIL.EPMS_HOUSEKEEPER_DES && trigger.new[0].Enable_Login__c==true){
                 Trigger.new[0].addError(label.EPMS_HouseKeeperDesg_Validation);    
            }
            Member__c existMember = Trigger.oldMap.get(Trigger.new[0].Id);
            
            EPMS_MemberQueryLocator query = new EPMS_MemberQueryLocator();  
                
            List<Location__c> LocationCountry = query.getLocationCountryName(Trigger.new);
            set<string>memebercountry = new set<string>();
            
            Set<String> userNameSet = new Set<String>();
            List<user> existUserList = query.getExistUserList();
            

            for(User u:existUserList){
                userNameSet.add(u.UserName);
            }
            
            
            
            for(Member__c MemCountry : Trigger.new){                
                memebercountry.add(MemCountry.Country__c);                      
            }
            

            if(LocationCountry.size()>0)
            {
                for(Location__c LocationCountryDetails : LocationCountry)
                {
                    if(memebercountry.contains(LocationCountryDetails.Location_Country__c)&& memebercountry.size()>0)
                    {

                    }
                    else{                        
                        Trigger.new[0].addError(Label.EPMS_MBO_COUNTRY);
                    }
                }
            }else{
                Trigger.new[0].addError(Label.EPMS_MBO_NOCOUNTRY);
            }
            
                            
            //For Adding Employee ID Based on Country Choosed
            Employee_Country_Code__c ConutryCode= Employee_Country_Code__c.getInstance(trigger.new[0].country__c);
            List<Member__c> memberDetails= query.getAutoincrementNumber(Trigger.new);
              
            
            String Auto='';
            if(memberDetails.size() > 0){
                Auto=memberDetails[0].Emp_ID__c;    
            }else{
                Auto=ConutryCode.Country_Initial_Letter__c+'000000';
            }
            
            String InitailString=Auto.substring(1,Auto.length());
            String MemberIDHolder='';
            Integer Totalvalue=0;
            Integer converted=Integer.valueof(InitailString);
            String Holder=String.valueof(converted);
            if(Holder.length() > = 6){
                Totalvalue=Integer.valueof(InitailString);

                Totalvalue=Totalvalue+1;
                MemberIDHolder=String.valueof(Totalvalue);
                
            }else{
                Totalvalue=Integer.valueof(InitailString);
                Totalvalue=Totalvalue+1; 
                String runnableString=String.valueof(Totalvalue);
                for(Integer inc=1; inc<=6-runnableString.length();inc++){
                    MemberIDHolder=MemberIDHolder+String.valueof(0);
                }
                MemberIDHolder=MemberIDHolder+Totalvalue;
               
            }

            
            if(designation == EPMS_UTIL.EPMS_PRO_ADMIN_DES|| designation == EPMS_UTIL.EPMS_TEAM_DES || designation == EPMS_UTIL.EPMS_QC_DES || designation == EPMS_UTIL.EPMS_ARTIST_DES
                 || designation == EPMS_UTIL.EPMS_SHIFT_ADMIN_DES || designation == EPMS_UTIL.EPMS_FM_DES || designation == EPMS_UTIL.EPMS_ITADMIN_DES || designation =='Assignor' || designation =='Estimator' || designation ==Label.EPMS_Delivery_Designation){
                
                
                if((trigger.new[0].Enable_Login__c == true ) && (existMember.Enable_Login__c == false)){                

                    if(existMember.user_id__c == null ){
                    
                        usrID = EPMS_UserService.Createu(Trigger.new);
                        trigger.new[0].User_Id__c = usrID; 
                    }
                    
                }
                if(existMember.Enable_Login__c == true){
                    
                    if(existMember.Email__c!=Trigger.new[0].Email__c) {                        
                        if(userNameSet.contains(Trigger.new[0].Email__c)){
                            Trigger.new[0].addError(label.EPMS_MemberEmail_Validation);
                        }else{
                            EPMS_UserService.UpdateUserDetails(Trigger.new[0].user_id__c,Trigger.new[0].id);                            
                        }
                    }else{

                    }                    
                }                  
            }            
        }  
        
        
        if(trigger.new[0].Status__c == 'Inactive' ){
            if(trigger.new[0].Enable_Login__c==true){
                if(trigger.new[0].Designation__c==EPMS_UTIL.EPMS_HOUSEKEEPER_DES){
                  trigger.new[0].Enable_Login__c = false;
                }
            }
            
            if(trigger.old[0].Enable_Login__c==true){
                //trigger.old[0].Enable_Login__c = false;
            }
        }
             
        if(trigger.new[0].Status__c == 'Active' && trigger.new[0].Enable_Login__c==true){
        
        }
        if(trigger.new[0].Status__c == 'Active' && trigger.new[0].Enable_Login__c==false){
        
        }
   
    if(Trigger.isAfter ){
        if(Trigger.isInsert && !system.isBatch()){
            if(Trigger.new[0].user_id__c!=null){               
                EPMS_UserService.insertRoleAfter(Trigger.new[0].user_id__c,Trigger.new[0].id); 
            }
                  
        } 
        if(Trigger.isUpdate && !system.isBatch()){
            if(Trigger.new[0].user_id__c!=null){                
                EPMS_UserService.insertRoleAfter(Trigger.new[0].user_id__c,Trigger.new[0].id); 
                EPMS_UserService.UpdateUserDetails(Trigger.new[0].user_id__c,Trigger.new[0].id);       
               
            }   
        
         
    
    /*    for(member__c member : Trigger.New) {   
            MemberEmails.add(member.Email__c);                 
        }        

        //query for the  users and put them in a map,//where the key is the email and the value is the user
        Map<String, User> emailUserMap = new Map<String, User> ();
        list<User> useremail = queryobj.getUserEmailList(MemberEmails);
        for(User aUser :useremail ){
            emailUserMap.put(aUser.UserName, aUser);//mapping user through there email address.
        }            
        List<Id> userIdList = new List<Id>();//           
        for(Member__c member_obj : Trigger.new) {       
            if(member_obj.location_id__c != Null){
                try{            
                    userIdList.add(emailUserMap.get(member_obj.Email__c).id);                   
                }
                catch(System.NullPointerException e){
                    system.debug('exception'+e);
                }
            } 
        
        }    
        
        
        
        
        list<member__c> memLocoldval = new list<member__c >();
    
        for(member__c member : Trigger.old) {    
            memLocoldval .add(member);    
        }
        for(member__c member : Trigger.New){            
           
            if(member.location_id__c!=trigger.old[0].location_id__c )
            { 
                if(locationid[0].id!=null && (member.location_id__c == locationid[0].id)){
                      
                    if(Limits.getFutureCalls() >= Limits.getLimitFutureCalls()){
                        system.debug('future calls=============>exceeded'); 
                   }else{
                   
                   EPMS_UserService.UpdateGroupDetails(memgroup[0],userIdList);                 
                   } 
              
                }
           }
           else if(member.location_id__c==trigger.old[0].location_id__c && trigger.old[0].User_Id__c==null) {
                     EPMS_UserService.UpdateGroupDetails(memgroup[0],userIdList);              
            }
        
    }  */

            
        } 
        
        
    
    
     }
    
    
}