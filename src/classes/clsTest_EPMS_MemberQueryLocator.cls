/**********************************************************************************
*   Class               :       clsTest_EPMS_MemberQueryLocator                   *
*   Created Date        :       02/04/2016                                        *
*   Description         :       Test Class for EPMS_MemberQueryLocator            *
**********************************************************************************/
@isTest
private class clsTest_EPMS_MemberQueryLocator{

    @testSetup static void setupTestData(){
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='E';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testmbomql@mbo.in';
            insert usermail;
            
            Profile profile = [SELECT Id FROM Profile WHERE Name = 'Quality Control'];

            User user = new User();
            user.FirstName ='Peter';
            user.LastName ='James';
            user.Alias ='Jammy'; 
            user.Username ='testusermql@mbo.in';
            user.Email='test3mql@mbo.in';
            user.ProfileId  = profile.id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.LocaleSidKey='en_US';
            user.EmailEncodingKey='UTF-8';
            user.LanguageLocaleKey='en_US';
            insert user;

            
            List<Member__c> memberList= new List<Member__c>();
            
            Member__c tlMemberTest =new Member__c();
            tlMemberTest.Name='Alexandar';     
            tlMemberTest.Location_id__c=location.Id;
            tlMemberTest.Last_Name__c='Fleming';
            tlMemberTest.Email__c='alexflemtl@mbo.in';
            tlMemberTest.Country__c='India';
            tlMemberTest.Designation__c='Team Leader';
            tlMemberTest.Status__c='Active';
            tlMemberTest.Today_Attendance__c = 'NW';
            memberList.add(tlMemberTest);
            
            Member__c qcMemberTest =new Member__c();
            qcMemberTest.Name='Ramkumar S';     
            qcMemberTest.Location_id__c=location.Id;
            qcMemberTest.Last_Name__c='Sundaresan';
            qcMemberTest.Email__c='ramkumarmql@mbo.in';
            qcMemberTest.Country__c='India';
            qcMemberTest.Designation__c='Quality Control';
            qcMemberTest.Status__c='Active';
            qcMemberTest.Today_Attendance__c = 'A';
            memberList.add(qcMemberTest);
            
            Member__c tl2MemberTest =new Member__c();
            tl2MemberTest.Name='Babu';     
            tl2MemberTest.Location_id__c=location.Id;
            tl2MemberTest.Last_Name__c='Chandran';
            tl2MemberTest.Email__c='aptrs16mql@mbo.in';
            tl2MemberTest.Country__c='India';
            tl2MemberTest.Designation__c='Team Leader';
            tl2MemberTest.Status__c='Active';
            tl2MemberTest.Today_Attendance__c = 'P';
            memberList.add(tl2MemberTest);
            
            if(memberList.size() > 0){
                insert memberList;
            }
    
    
    }

    static testMethod void testMemberQueryLocatorTestClass() {
            
            List<String> MemberEmailList = new List<String>();
            Set<String> MemberEmailSet = new Set<String>();
            Set<Id> LocIDs = new Set<Id>();
            Set<Id> SelectedIDs = new Set<Id>();
            list<String> memids = new List<String>();
            list<id> SelectedID = new list<id>();
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            List<Member__c> memberList = [SELECT Id, Name, Email__c, Country__c, Location__c, Location_id__c FROM Member__c WHERE Location_id__c =: location.Id]; 
            if(memberList != null && memberList.size() > 0){
                for(Member__c member : memberList){
                    MemberEmailSet.add(String.valueOf(member.Email__c));
                    MemberEmailList.add(String.valueOf(member.Email__c));
                    LocIDs.add(member.Location_id__c);
                    SelectedIDs.add(member.Id);
                    memids.add(String.valueOf(member.Id));
                }
            }
            SelectedID.addAll(SelectedIDs);
            Test.StartTest();
            EPMS_Member_service memberService = new EPMS_Member_service();
            memberService.getMemberlist(memids);
            memberService.getMemberinsertlist(SelectedID);
            memberService.getMemberUpdatelist(SelectedID);
            memberService.getLocationCountry(location.Id);
            memberService.getShiftmAssignments(SelectedID);
            memberService.getMemberOriginalLoc(MemberEmailList,LocIDs);
            memberService.getMemberOriginalLoc1(MemberEmailList,LocIDs);
            Test.StopTest();
    }       
    
    static testMethod void testMemberQueryLocatorTestClass2() {
            
            List<String> MemberEmailList = new List<String>();
            Set<String> MemberEmailSet = new Set<String>();
            Set<Id> LocIDs = new Set<Id>();
            Set<Id> SelectedIDs = new Set<Id>();
            list<String> memids = new List<String>();
            list<id> SelectedID = new list<id>();
            Id memid = null;
            User user = [SELECT Id, Name FROM User WHERE FirstName ='Peter'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            List<Member__c> memberList = [SELECT Id, Name, Email__c, Country__c, Location__c, Location_id__c FROM Member__c WHERE Location_id__c =: location.Id]; 
            if(memberList != null && memberList.size() > 0){
                for(Member__c member : memberList){
                    MemberEmailSet.add(member.Email__c);
                    MemberEmailList.add(member.Email__c);
                    LocIDs.add(member.Location_id__c);
                    SelectedIDs.add(member.Id);
                    memids.add(member.Id);
                    memid = member.Id;
                }
            }
            String Designation = 'Team Leader';
            SelectedID.addAll(SelectedIDs);
            Test.StartTest();
            EPMS_MemberQueryLocator queryObj = new EPMS_MemberQueryLocator();
            queryObj.getMemberlistinfo(memids);
            queryObj.getMemberlist(memid);
            queryObj.getMemberUpdateUser(SelectedIDs);
            queryObj.getMemberlistinsert(SelectedID);
            queryObj.getMemberlistUpdate(SelectedID);
            queryObj.getExistMemberList();
            queryObj.getLocation(String.valueOf(location.Id));
            //queryObj.getGroup(String.valueOf(location.Id));
            queryObj.getTeamAssign(SelectedID);
            queryObj.getShiftAssign(SelectedID);
            queryObj.getMemberUpdateOldLoctiondetails(SelectedID);
            queryObj.getUserlist(MemberEmailSet);
            queryObj.getUserEmailList(MemberEmailSet);
            queryObj.getUserProfileHolder();      
            queryObj.getUserProfile(Designation);
            queryObj.getUserRole();
            Designation = 'Team Leader';
            queryObj.getUserRoleUpdate(Designation);
            queryObj.getuserdetails(user.Id);
            queryObj.getExistUserList();
            queryObj.getLocationCountry(location.Id);
            queryObj.getAutoincrementNumber(memberList);
            queryObj.getAutoincrementNumber(memberList[0]);
            queryObj.getMemberOriginalLoc(MemberEmailList,LocIDs);
            queryObj.getMemberOriginalLoc1(MemberEmailList,LocIDs);
            queryObj.getLocationCountryName(memberList);
            queryObj.getmemberids(SelectedID);
            queryObj.getAssign();
            queryObj.getShiftCode(memberList);
            queryObj.getattendance(memberList);
            queryObj.getShiftAttendance(memberList);
            queryObj.getDeputedMEm(SelectedID);
            queryObj.getDeputedMEmAct(SelectedID);
            queryObj.getAllShiftAttendance(memberList);
            EPMS_CheckRecursive.isFutureUpdate = false;
            EPMS_CheckRecursive.runOnce();
            Test.StopTest();
    }       

}