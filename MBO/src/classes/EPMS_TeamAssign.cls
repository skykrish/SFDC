/**************************************************************************************
*   Class               :       EPMS_TeamAssign                                       *
*   Created Date        :       13/04/2016                                            *           
*   Description         :       class for team assignment                             *     
                                                                                       
****************************************************************************************/

public with sharing class EPMS_TeamAssign{
    private Integer OffsetSize = 0;
    private Integer QueryLimit = 7;
    private Integer CountTotalRecords = 0;
    public List<Member__c> memberList,QCmemberList= new List<Member__c>();
    public List<WrapperMember> MemberWrappper {public get; public set;}
    public  List<ID> teamHolder = new List<ID>();
    public List<Team__c>  teamList = new List<Team__c>();
    public EPMS_TeamAssign_detailService serviceObject=new EPMS_TeamAssign_detailService(); 
    public List<Team__c> teamList1 = new List<Team__c>();
    public List<Id>  teamIds = new List<Id>();
    public List<Id>  loggedInUserTeamIds = new List<Id>();
    public List<WrapperMember> finalMemberWrapperList {public get; public set;}
   
    List<Id> loggedInUserlocIds = new List<Id>();
    public String loggedInUser;
    public String loggedInUserProfile;
    
    List<User> userList = new List<User>();
    List<Id> profileIds = new List<Id>();
    List<Profile> profileList = new List<Profile>();
    public List<member__c> loggedInTLTeamIds = new List<Member__c>();
    public EPMS_TeamAssign(){
        MemberWrappper = new list<WrapperMember>(); 
        String teamid=ApexPages.currentPage().getParameters().get('id');
        loggedInUser  = ApexPages.currentPage().getParameters().get('id');        
        CountTotalRecords  = [select count() from Team__c ]; 
        teamList1 = [select id, name from team__c];
        for(Team__c tObj :  teamList1 ){
            teamIds.add(tObj.id);        
        }
    }  
    
    
    public List<WrapperMember> getMemberWrappers(){
        MemberWrappper = new List<WrapperMember>();      
        userList = [SELECT id, name ,ProfileId FROM User where id = : userinfo.getuserid()];
        
        for(User userObj : userList ){
            profileIds .add(userObj.ProfileId);
        }
       
        profileList = [SELECT Id, name FROM Profile where id = : profileIds];        
        loggedInUserProfile = profileList[0].Name;
      
       //  If SysAdmin logged in
       
       if(loggedInUserProfile == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME || loggedInUserProfile=='Country Administrator'){
        if(!teamIds.isEmpty()){
           teamList  = [select id, name from team__c where id = : teamIds LIMIT : QueryLimit OFFSET :OffsetSize ];
        }
       
      }
         // If TL/QC  logged in 
     
     loggedInTLTeamIds  = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name, Location_id__c,Designation__c  from Member__c where User_id__c = : loggedInUser];
     if((loggedInUserProfile == EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME) || (loggedInUserProfile ==  EPMS_UTIL.EPMS_QC_PROFILE_NAME) ){      
        
         if(!loggedInTLTeamIds.isEmpty()){
          for(Member__c memVar : loggedInTLTeamIds){
             loggedInUserTeamIds.add(memVar.Team_Id__c);
             loggedInUserlocIds.add(memVar.Location_id__c);
         }
         
         }
      
         if(!loggedInUserTeamIds.isEmpty() && !loggedInUserlocIds.isEmpty()){
          teamList  = [select id, name from team__c where id = : loggedInUserTeamIds and Location__c = :loggedInUserlocIds];
         }
           
      }
       // If Shift Admin/ production Admin logged in
      if((loggedInUserProfile == EPMS_UTIL.EPMS_SHIFT_ADMIN_PROFILE_NAME) || (loggedInUserProfile ==  EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME) ){
          
          for(Member__c memVar : loggedInTLTeamIds){
             loggedInUserlocIds.add(memVar.Location_id__c);           
         }
        if(!loggedInUserlocIds.isEmpty()){
            teamList  = [select id, name from team__c where  Location__c = :loggedInUserlocIds LIMIT : QueryLimit OFFSET :OffsetSize ];
        }        
      }
 
        if(!teamList.isEmpty()){
            for(Team__c teamObj : teamList){
                WrapperMember wrapObj = new WrapperMember();
                QCmemberList = serviceObject.getTeamQC_TLMembers(teamObj.id);  
                memberList = serviceObject.getTeamMembers(teamObj.id);
                finalMemberWrapperList = getTeamWrapperDetails(teamObj.Name, QCmemberList,memberList );            
            }
       } 
        return finalMemberWrapperList;
    }

   public List<WrapperMember> getTeamWrapperDetails(String teamName, List<member__c> tlqcList, List<member__c> memList){
       List<Member__c> msList = new List<Member__c>();
       String tlName;
       String qcName;
       if(!tlqcList.isEmpty() & tlqcList.size() == 2){          
           for(Integer i = 0; i < tlqcList.size(); i++){             
                for(Integer j = 0; j < memList.size(); j++)  {                  
                   if(tlqcList[i].team_id__c == memList[j].team_id__c){
                       msList.add(memList[j]);
                   }               
                }    // inner loop 
                if((tlqcList[i].Designation__c == EPMS_UTIL.EPMS_TEAM_DES) && (tlqcList[i + 1].Designation__c == EPMS_UTIL.EPMS_QC_DES)){
                     tlName =  tlqcList[i].Name; 
                     qcName = tlqcList[i + 1].Name;
                }
                
                WrapperMember wrapMemb = new WrapperMember();
                wrapMemb.teamName = teamName;
                wrapMemb.teamLeadName  = tlName; 
                wrapMemb.qcontrolName = qcName; 
                wrapMemb.membersList = msList;   
                MemberWrappper.add(wrapMemb);             
                break;
           } // 1st for loop
              
       }else If(!tlqcList.isEmpty() & tlqcList.size() == 1){
          for(Integer i = 0; i < tlqcList.size(); i++){
               
               for(Integer j = 0; j < memList.size(); j++)  { 
                   if(tlqcList[i].team_id__c == memList[j].team_id__c){
                       msList.add(memList[j]);
                   }
               }
              WrapperMember wrapMemb; 
               if(tlqcList[i].Designation__c == EPMS_UTIL.EPMS_TEAM_DES){
                    tlName =  tlqcList[i].Name;                     
                    wrapMemb = new WrapperMember();
                    wrapMemb.teamName = teamName;
                    wrapMemb.teamLeadName  = tlName; 
                    wrapMemb.qcontrolName = EPMS_UTIL.EPMS_TeamAssignStatus; 
                    wrapMemb.membersList = msList;  
                }
                if(tlqcList[i].Designation__c == EPMS_UTIL.EPMS_QC_DES){
                    qcName =  tlqcList[i].Name;
                    wrapMemb = new WrapperMember();
                    wrapMemb.teamName = teamName;
                    wrapMemb.teamLeadName  = EPMS_UTIL.EPMS_TeamAssignStatus; 
                    wrapMemb.qcontrolName = qcName; 
                    wrapMemb.membersList = msList;                     
                }
               
               MemberWrappper.add(wrapMemb);
           }
       
       
       }else if(tlqcList.isEmpty()){
            WrapperMember wrapMemb; 
            wrapMemb = new WrapperMember();
            wrapMemb.teamName = teamName;
            wrapMemb.teamLeadName  = EPMS_UTIL.EPMS_TeamAssignStatus; 
            wrapMemb.qcontrolName = EPMS_UTIL.EPMS_TeamAssignStatus; 
            wrapMemb.membersList = msList;            
            MemberWrappper.add(wrapMemb);
            
       }     
       
       return MemberWrappper;
      
   }
   
   
   public void beginning()
    {
        OffsetSize = 0;
    }
   
    public void previous()
    {
        OffsetSize = OffsetSize - QueryLimit;
    }
   
    public void next()
    {
        OffsetSize = OffsetSize + QueryLimit;
    }

    public void end()
    {
        OffsetSize = CountTotalRecords - math.mod(CountTotalRecords,QueryLimit);
    }       
   
    public boolean getprev()
    {
        if(OffsetSize == 0)
        return true;
        else
        return false;
    } 
   
    public boolean getnxt()
    {
        if((OffsetSize + QueryLimit) > CountTotalRecords)
        return true;
        else
        return false;
    }  
    
    
     public Integer getPageNumber() {
      return OffsetSize /QueryLimit + 1;
   }

   public Integer getTotalPages() {
      if (math.mod(CountTotalRecords  , QueryLimit ) > 0) {
         return CountTotalRecords  /QueryLimit  + 1;
      } else {
         return (CountTotalRecords  /QueryLimit );
      }
   }
 
     //Wrapper Class
    public with sharing class WrapperMember {
    
    public List<Member__c> membersList    { get;set; }
    
    public String teamName{get;set;}
    public String teamLeadName{get;set;}
    public String qcontrolName{get;set;}
    
        public WrapperMember(String tName,String tlName, String QCName, List<Member__c> membersList  ) {
            this.teamName =  tName;
            this.teamLeadName = tlName;
            this.qcontrolName =  QCName ;
            this.membersList = membersList;  
    
        }
        public WrapperMember(){        
        
        }
    }

}