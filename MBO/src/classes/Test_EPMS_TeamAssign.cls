/**********************************************************************************
*   Class               :       Test_EPMS_TeamAssign                              *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_TeamAssign class              *
**********************************************************************************/


@isTest
    Public Class Test_EPMS_TeamAssign {
    
    static testMethod void testDoPostPostive() {
    
        PageReference pageRef = Page.EPMS_TeamAssign;
    
        Profile profile = [select id from Profile where Name = 'System Administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@shinsei.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        system.runas(user){
        
        Location__c locObj = new Location__c();
        locObj.Name = 'TestLocationOne';
        locObj.Location_Country__c = 'India';
        locObj.Group_Name__c = 'TestGroupOne';
        insert locObj;
        
        Location__c locObj1 = new Location__c();
        locObj1.Name = 'TestLocationTwo';
        locObj1.Location_Country__c = 'India';
        locObj1.Group_Name__c = 'TestGroupTwo';
        insert locObj1;
    
        List<Team__c> teamInsertList = new List<Team__c>();
        Team__c teamObj = new  Team__c();
        teamObj.Name = 'teamOne';
        teamObj.Location__c = locObj.Id;
        teamInsertList.add(teamObj);
        
        Team__c teamObj2 = new  Team__c();
        teamObj2.Name = 'team Two';
        teamObj2.Location__c = locObj.Id;
        teamInsertList.add(teamObj2);
        
        Team__c teamObj3 = new  Team__c();
        teamObj3.Name = 'team Three';
        teamObj3.Location__c = locObj.Id;
        teamInsertList.add(teamObj3);
        
        if(teamInsertList.size() > 0){
            insert teamInsertList;
        }
        
        List<Team__c> teamOne = new List<Team__c>();
        teamOne = [select id, name from team__c];
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist@mbo.in';
        insert usermail;       
    
        List<Member__c> memberInsertList = new List<Member__c>();
        Member__c memObj = new Member__c();
        memObj.Name = 'TestMemOne';
        memObj.Last_Name__c = 'MemOneLastNa';
        memObj.First_Name__c = 'MemOneFN';
        memObj.Email__c = 'adf1@dfg.com';
        memObj.Designation__c = 'Team Leader';
        memObj.Location_id__c = locObj.Id;
        memObj.Country__c = 'India';
        memObj.Team_Id__c = teamObj.id;
        memberInsertList.add(memObj);
        
        Member__c memArtists = new Member__c();
        memArtists.Name = 'TestMemOne';
        memArtists.Last_Name__c = 'MemOneLastNa';
        memArtists.First_Name__c = 'MemOneFN';
        memArtists.Email__c = 'adf2@dfg.com';
        memArtists.Designation__c = 'Photo Artists';
        memArtists.Location_id__c = locObj.Id;
        memArtists.Country__c = 'India';
        memArtists.Team_Id__c = teamObj.id;
        memberInsertList.add(memArtists);
     
        Member__c memObj1 = new Member__c();
        memObj1.Name = 'TestMemOne';
        memObj1.Last_Name__c = 'MemOneLastNa';
        memObj1.First_Name__c = 'MemOneFN';
        memObj1.Email__c = 'adf3@dfg.com';
        memObj1.Designation__c = 'Quality Control';
        memObj1.Location_id__c = locObj.Id;
        memObj1.Country__c = 'India';
        memObj1.Team_Id__c = teamObj2.id;
        memberInsertList.add(memObj1);
        
        Member__c memObj2 = new Member__c();
        memObj2.Name = 'TestMemOne';
        memObj2.Last_Name__c = 'MemOneLastNa';
        memObj2.First_Name__c = 'MemOneFN';
        memObj2.Email__c = 'adf4@dfg.com';
        memObj2.Designation__c = 'Team Leader';
        memObj2.Location_id__c = locObj.Id;
        memObj2.Country__c = 'India';
        memObj2.Team_Id__c = teamObj3.id;
        memberInsertList.add(memObj2); 
     
        Member__c memObj3 = new Member__c();
        memObj3.Name = 'TestMemOne';
        memObj3.Last_Name__c = 'MemOneLastNa';
        memObj3.First_Name__c = 'MemOneFN';
        memObj3.Email__c = 'adf5@dfg.com';
        memObj3.Designation__c = 'Quality Control';
        memObj3.Location_id__c = locObj.Id;
        memObj3.Country__c = 'India';
        memObj3.Team_Id__c = teamObj.id;
        memberInsertList.add(memObj3);
        
        if(memberInsertList.size() > 0){
            insert memberInsertList;
        }
        
        pageRef.getParameters().put('id',user.id);
        
        EPMS_TeamAssign  teamAssignObj = new EPMS_TeamAssign();
        teamAssignObj.beginning();
        teamAssignObj.previous();
        teamAssignObj.next();
        teamAssignObj.end();
        teamAssignObj.getprev();
        teamAssignObj.getnxt();
        teamAssignObj.getPageNumber();
        teamAssignObj.getTotalPages(); 
        
        teamAssignObj.teamList1 = teamOne;
        
        
        List<Member__c> MemberList = new List<Member__c>();
        List<Member__c> MemberList1 = new List<Member__c>();
    
        MemberList = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c = : teamObj.id AND Designation__c !=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME AND Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME  order by Team_Id__c,Designation__c ];
        MemberList1 = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c = : teamObj.id AND (Designation__c=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME OR Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME)  order by Team_Id__c,Designation__c ];
        
        teamAssignObj.QCmemberList = MemberList;
        teamAssignObj.memberList = MemberList1;
        teamAssignObj.getMemberWrappers();
        
        EPMS_TeamAssign  teamAssignObj2 = new EPMS_TeamAssign();
        
    
        teamAssignObj2.beginning();
        teamAssignObj2.previous();
        teamAssignObj2.next();
        teamAssignObj2.end();
        teamAssignObj2.getprev();
        teamAssignObj2.getnxt();
        teamAssignObj2.getPageNumber();
        teamAssignObj2.getTotalPages(); 
        
        List<Member__c> memberTeamList = new List<Member__c>();
        List<Member__c> MemberTL_QC_List = new List<Member__c>();
        
        memberTeamList = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c = : teamObj2.id AND Designation__c !=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME AND Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME  order by Team_Id__c,Designation__c ];
        MemberTL_QC_List = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c = : teamObj2.id AND (Designation__c=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME OR Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME)  order by Team_Id__c,Designation__c ];
        
        
        teamAssignObj.QCmemberList = memberTeamList;
        teamAssignObj.memberList = MemberTL_QC_List;
        teamAssignObj2.teamList1 = teamOne;
        teamAssignObj2.getMemberWrappers();
    
        EPMS_TeamAssign  teamAssignObj3 = new EPMS_TeamAssign();
   
        teamAssignObj3.beginning();
        teamAssignObj3.previous();
        teamAssignObj3.next();
        teamAssignObj3.end();
        teamAssignObj3.getprev();
        teamAssignObj3.getnxt();
        teamAssignObj3.getPageNumber();
        teamAssignObj3.getTotalPages(); 
        
        List<Member__c> memberTeamList1 = new List<Member__c>();
        List<Member__c> MemberTL_QC_List1 = new List<Member__c>();
        
        memberTeamList1 = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c = : teamObj3.id AND Designation__c !=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME AND Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME  order by Team_Id__c,Designation__c ];
        MemberTL_QC_List1 = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c = : teamObj3.id AND (Designation__c=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME OR Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME)  order by Team_Id__c,Designation__c ];
        
        
        teamAssignObj3.QCmemberList = memberTeamList1;
        teamAssignObj3.memberList = MemberTL_QC_List1;
        teamAssignObj3.teamList1 = teamOne;
        teamAssignObj3.getMemberWrappers();
        
        
    }
  }
}