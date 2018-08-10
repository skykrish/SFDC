/**********************************************************************************
*   Class               :       clsTest_EPMS_ShiftcodeUpdate                      *
*   Created Date        :       05/04/2016                                        *
*   Description         :       Test Class for EPMS_ShiftcodeUpdate               *
**********************************************************************************/
@isTest
public class clsTest_EPMS_ShiftcodeUpdate{ 
  
    static testMethod void Test_EPMS_ShiftcodeUpdate_method1() {
    
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex4';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x4';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;
            
            List<Member__c> memberList = new List<Member__c>();
            Member__c member =new Member__c();
            member.Name='Tiger';     
            member.Location_id__c=location.id;
            member.Last_Name__c='Scott';
            member.Email__c='testtigerscoot@gmail.com';
            member.Country__c='India';
            member.Designation__c='Quality Control';
            member.Status__c='Active';
            memberList.add(member); 
            
            Member__c member2 =new Member__c();
            member2.Name='RoopKumar';     
            member2.Location_id__c=location.id;
            member2.Last_Name__c='Singh';
            member2.Email__c='roopkumar.s@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Team Leader';
            member2.Status__c='Active';
            memberList.add(member2); 
            
            Member__c member3 =new Member__c();
            member3.Name='Gurupradeep';     
            member3.Location_id__c=location.id;
            member3.Last_Name__c='Singh';
            member3.Email__c='testFirsttestlastQC@gmail.com';
            member3.Country__c='India';
            member3.Designation__c='Quality Control';
            //member3.Status__c='Active';
            member3.Status__c='Deputed';
            memberList.add(member3); 
            
            if(memberList.size() > 0){
                insert memberList;
            }
            String memberIdList = '';
            if(memberList != null && memberList.size() > 0){
                Integer count = 0;
                for(Member__c newmember : memberList){
                    if(count == 0){
                        memberIdList = newmember.Id;
                    } else {
                        memberIdList +=',' + newmember.Id;
                    }
                    count++;
                }
            }
            Shift__c shift=new Shift__c();
            shift.Name='First shift';
            Shift.Implements_From__c=System.Today(); 
            Shift.Shift_Start_Time__c=System.now();
            Shift.Shift_End_Time__c=System.now().addDays(7);
            Shift.Status__c='Active';
            Shift.Shift_Location__c=location.id;
            insert shift;
            
            List<Shift_Assignments__c> shiftAssignedRecords = new List<Shift_Assignments__c>();
            Shift_Assignments__c shiftAssign1=new Shift_Assignments__c();
            shiftAssign1.Member__c=member.Id;
            shiftAssign1.Shift_Assigned__c=true;
            shiftAssign1.FromTime__c=system.Today();
            shiftAssign1.Shift_Code__c=shift.Id;
            shiftAssign1.Location__c=location.id;
            shiftAssignedRecords.add(shiftAssign1);
            
            Shift_Assignments__c shiftAssign2=new Shift_Assignments__c();
            shiftAssign2.Member__c=member2.Id;
            shiftAssign2.Shift_Assigned__c=true;
            shiftAssign2.FromTime__c=system.Today();
            shiftAssign2.Shift_Code__c=shift.Id;
            shiftAssign2.Location__c=location.id;
            shiftAssignedRecords.add(shiftAssign2);
            
            Shift_Assignments__c shiftAssign3=new Shift_Assignments__c();
            shiftAssign3.Member__c=member3.Id;
            shiftAssign3.Shift_Assigned__c=true;
            shiftAssign3.FromTime__c=system.Today();
            shiftAssign3.Shift_Code__c=shift.Id;
            shiftAssign3.Location__c=location.id;
            shiftAssignedRecords.add(shiftAssign3);
            insert shiftAssignedRecords;
            
            List<Shift_Attendance__c> shiftAttendanceRecords = new List<Shift_Attendance__c>();
            Shift_Attendance__c sa=new Shift_Attendance__c();
            sa.Attendance_Date__c=System.Today();
            sa.Attendance_Status__c='P';
            sa.Employee_Name__c=member.id;
            sa.Start_Date__c=System.Today();
            sa.End_Date__c=System.Today();
            sa.Shift_Code__c=shift.id;
            shiftAttendanceRecords.add(sa);
            
            Shift_Attendance__c sa1=new Shift_Attendance__c();
            sa1.Attendance_Date__c=System.Today();
            sa1.Attendance_Status__c='P';
            sa1.Employee_Name__c=member.id;
            sa1.Start_Date__c=System.Today();
            sa1.End_Date__c=System.Today();
            sa1.Shift_Code__c=shift.id;
            shiftAttendanceRecords.add(sa1);
            
            Shift_Attendance__c sa2=new Shift_Attendance__c();
            sa2.Attendance_Date__c=System.Today();
            sa2.Attendance_Status__c='P';
            sa2.Employee_Name__c=member.id;
            sa2.Start_Date__c=System.Today();
            sa2.End_Date__c=System.Today();
            sa2.Shift_Code__c=shift.id;
            shiftAttendanceRecords.add(sa2);
            insert shiftAttendanceRecords;
            
            Test.StartTest();       
            
            //EPMS_ShiftcodeUpdate.updateShiftCode(memberIdList); 
            EPMS_ShiftcodeUpdate.updateNoWork(memberIdList);
            EPMS_ShiftcodeUpdate.updateAbsent(memberIdList);
            EPMS_ShiftcodeUpdate.removeAbsent(memberIdList);

            List<Member__c> memberList2 = new List<Member__c>();            
            Member__c member4 =new Member__c();
            member4.Name='Raajesh';     
            member4.Location_id__c=location.id;
            member4.Last_Name__c='Kumar';
            member4.Email__c='raajeshksree@gmail.com';
            member4.Country__c='India';
            member4.Designation__c='Quality Control';
            member4.Status__c='Active';
            memberList2.add(member4);
            
            Member__c member5 =new Member__c();
            member5.Name='Mandeep';     
            member5.Location_id__c=location.id;
            member5.Last_Name__c='Singh';
            member5.Email__c='singhmandeep@gmail.com';
            member5.Country__c='India';
            member5.Designation__c='Quality Control';
            member5.Status__c='Active';
            memberList2.add(member5);
            
            insert memberList2;
            
            Shift_Assignments__c shiftAssign56=new Shift_Assignments__c();
            shiftAssign56.Member__c=member5.Id;
            shiftAssign56.Shift_Assigned__c=true;
            shiftAssign56.FromTime__c=system.Today();
            shiftAssign56.Shift_Code__c=shift.Id;
            shiftAssign56.Location__c=location.id;
            insert shiftAssign56;
            
            Shift_Assignments__c shiftAssign55=new Shift_Assignments__c();
            shiftAssign55.Member__c=member4.Id;
            shiftAssign55.Shift_Assigned__c=true;
            shiftAssign55.FromTime__c=system.Today();
            shiftAssign55.Shift_Code__c=shift.Id;
            shiftAssign55.Location__c=location.id;
            insert shiftAssign55;
            
            String memberIdList2 = '';
            if(memberList != null && memberList.size() > 0){
                Integer count2 = 0;
                for(Member__c newmember2 : memberList){
                    if(count2 == 0){
                        memberIdList2 = newmember2.Id;
                    } else {
                        memberIdList2 +=',' + newmember2.Id;
                    }
                    count2++;
                }
            }
            
            //EPMS_ShiftcodeUpdate.updateShiftCode(memberIdList2);
            EPMS_ShiftcodeUpdate.updateNoWork(memberIdList2);
            EPMS_ShiftcodeUpdate.updateAbsent(memberIdList2);

            Test.stopTest();
    }
}