/**********************************************************************************
*   Class               :       clsTest_EPMS_UpdateMemTeam            *
*   Created Date        :       30/03/2017                            *
*   Description         :       Test Class for EPMS_UpdateMemTeam     *
**********************************************************************************/
@istest
 Public class  clsTest_EPMS_UpdateMemTeam  {
     
     @testSetup  static void setupTestData() {
         
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex1';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase1x1';
            insert location;
            
            List<Team__c> teamlist= new List<Team__c>();
            Team__c  teamA = new Team__c();
            teamA.Name = 'Team 1';
            teamA.Location__c =location.id;
            teamlist.add(teamA);
            
            Team__c teamB = new Team__c();
            teamB.Name = 'Team 2';
            teamB.Location__c =location.id;
            teamlist.add(teamB);
            
            if(teamlist.size() > 0)
            {
                insert teamlist;
            }
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
    
            
            List<Member__c> memberlist = new List<Member__c>();
            Member__c member1= new Member__c();
            member1.Name=' Member A';
            member1.Last_Name__c =' Tester1';
            member1.Email__c='marchtest1@gmail.com';
            member1.Designation__c='Photo Artists';
            member1.Location_id__c=location.id;
            member1.Country__c='India';
            member1.Status__c='Active';
            member1.Team_Id__c=teamA.id;
            memberlist.add(member1);
            
            Member__c member2 = new Member__c();
            member2.Name='Member B';
            member2.Last_Name__c ='Tester2';
            member2.Email__c='marchtest2@gmail.com';
            member2.Designation__c='Photo Artists';
            member2.Location_id__c=location.id;
            member2.Country__c='India';
            member2.Status__c='Active';
            member2.Team_Id__c=teamB.id;
            memberlist.add(member2);
            
            Member__c member3 = new Member__c();
            member3.Name='Member C';
            member3.Last_Name__c ='Tester3';
            member3.Email__c='marchtest3@gmail.com';
            member3.Designation__c='Team Leader';
            member3.Location_id__c=location.id;
            member3.Country__c='India';
            member3.Status__c='Active';
            member3.Team_Id__c=teamB.id;
            memberlist.add(member3);
            
            Member__c member4 = new Member__c();
            member4.Name='Member D';
            member4.Last_Name__c ='Tester4';
            member4.Email__c='marchtest4@gmail.com';
            member4.Designation__c='Quality Control';
            member4.Location_id__c=location.id;
            member4.Country__c='India';
            member4.Status__c='Active';
            member4.Team_Id__c=teamA.id;
            memberlist.add(member4);
            
            Member__c member5 = new Member__c();
            member5.Name='Member E';
            member5.Last_Name__c ='Tester5';
            member5.Email__c='marchtest5@gmail.com';
            member5.Designation__c='Team Leader';
            member5.Location_id__c=location.id;
            member5.Country__c='India';
            member5.Status__c='Active';
            member5.Team_Id__c=teamA.id;
            memberlist.add(member5);
            
            Member__c member6 = new Member__c();
            member6.Name='Member F';
            member6.Last_Name__c ='Tester6';
            member6.Email__c='marchtest6@gmail.com';
            member6.Designation__c='Quality Control';
            member6.Location_id__c=location.id;
            member6.Country__c='India';
            member6.Status__c='Active';
            member6.Team_Id__c=teamB.id;
            memberlist.add(member6);
            
            Member__c member7 = new Member__c();
            member7.Name='Member G';
            member7.Last_Name__c ='Tester7';
            member7.Email__c='marchtest2@gmail.com';
            member7.Designation__c='Production Administrator';
            member7.Location_id__c=location.id;
            member7.Country__c='India';
            member7.Status__c='In Active';
            member7.Team_Id__c=teamB.id;
            memberlist.add(member7);
            
            if(memberlist.size()>0)
            {
                insert memberlist;
            }
            
            List<Shift__c> shiftlist =new List<Shift__c>();
            Shift__c shiftA = new Shift__c();
            shiftA.Name='SHIFT 1';
            shiftA.Shift_Location__c= location.id;
            shiftA.Implements_From__c = system.now().addDays(3);
            shiftA.Shift_Start_Time__c = system.now();
            shiftA.Shift_End_Time__c = shiftA.Shift_Start_Time__c.addHours(9);
            shiftA.Status__c ='Active';
            insert shiftA;
            
            Shift__c shiftB = new Shift__c();
            shiftB.Name='SHIFT 2';
            shiftB.Shift_Location__c= location.id;
            shiftB.Implements_From__c = system.now().addDays(3);
            shiftB.Shift_Start_Time__c = system.now().addHours(3);
            shiftB.Shift_End_Time__c = shiftA.Shift_Start_Time__c.addHours(9);
            shiftB.Status__c ='Active';
            insert shiftB;
            
            
            if(shiftlist.size()> 0){
                insert shiftlist;
            }
         
         List<Shift_Assignments__c> shiftasslist =new List<Shift_Assignments__c>();
         Shift_Assignments__c shiftass1 = new Shift_Assignments__c();
         shiftass1.Location__c=location.id;
         shiftass1.Shift_Code__c=shiftB.id;
         shiftass1.Member__c=member1.id;
         shiftass1.FromTime__c=system.today();
         shiftass1.Shift_Assigned__c=true;
         shiftasslist.add(shiftass1);
         
         
         Shift_Assignments__c shiftass2 = new Shift_Assignments__c();
         shiftass2.Location__c=location.id;
         shiftass2.Shift_Code__c=shiftA.id;
         shiftass2.Member__c=member2.id;
         shiftass2.FromTime__c=system.today();
         shiftass2.Shift_Assigned__c=true;
         shiftasslist.add(shiftass2);
         
         if(shiftasslist.size() >0){
             insert shiftasslist;
         }
         
         
         
     }
     static testmethod void  Updatememberdata(){
        Test.startTest();
        Member__c querymember=[select id,Name,Designation__c,Location_id__c,Team_Id__c from  Member__c where Last_Name__c ='Tester2' limit 1];
        Team__c   queryteam=[select Id, Name,Location__c from  Team__c where  Name = 'Team 1' limit 1];
        
         if(querymember !=null && queryteam !=null)
         {
             querymember.Team_Id__c = queryteam.id;
             update querymember;
         }  
        Test.stopTest();
     }
     
     static testmethod void  UpdatememberdesignationTL(){
        Test.startTest();
        Member__c querymember1=[select id,Name,Designation__c,Location_id__c,Team_Id__c from  Member__c where Last_Name__c ='Tester3' limit 1];
        Team__c   queryteam1=[select Id, Name,Location__c from  Team__c where  Name = 'Team 1' limit 1];
        try{
         if(querymember1 !=null && queryteam1 !=null)
         {    
             
             querymember1.Team_Id__c =  queryteam1.Id ;
             update querymember1;
         }  
         Test.stopTest();
        }
        Catch(DmlException de){
            System.debug('The Message is'+de);
        }  
     }
 
    static testmethod void  UpdatememberdesignationQC(){
        Test.startTest();
        Member__c querymember2=[select id,Name,Designation__c,Location_id__c,Team_Id__c from  Member__c where Last_Name__c ='Tester4' limit 1];
        Team__c   queryteam2=[select Id, Name,Location__c from  Team__c where  Name = 'Team 2' limit 1];
        try{
         if(querymember2 !=null && queryteam2 !=null)
         {    
             
             querymember2.Team_Id__c =  queryteam2.Id ;
             update querymember2;
         }  
        Test.stopTest();
     }
     Catch(DmlException de){
         
         System.debug('The Message is'+de);
     }
    }

    static testmethod void Checkerror(){
        Test.startTest();
         Member__c querymember3=[select id,Name,Designation__c,Location_id__c,Team_Id__c from  Member__c where Last_Name__c ='Tester7' limit 1];
         Team__c   queryteam3=[select Id, Name,Location__c from  Team__c where  Name = 'Team 2' limit 1];
        try{
            if(querymember3 !=null && queryteam3 !=null)
            {
                querymember3.Team_Id__c = queryteam3.Id;
                update querymember3;
            }
            Test.stopTest();
        }
         Catch(DmlException de){
              System.debug('The Message is'+de);
         }
    }
 }