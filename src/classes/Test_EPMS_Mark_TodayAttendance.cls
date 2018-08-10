/**********************************************************************************
*   Class               :       Test_EPMS_Mark_TodayAttendance                      *
*   Created Date        :       05/04/2016                                          *
*   Description         :       Test Class for EPMS_Mark_TodayAttendance            *
**********************************************************************************/
@istest
public class Test_EPMS_Mark_TodayAttendance {
    
     public static testmethod void TestAttendance1() {
        
        Location__c location = new Location__c();
        location.Name = 'MBOI-Phase-2';
        location.Location_Country__c='India';
        location.Location_Status__c ='Active';
        location.Group_Name__c='MBOI-Phase-2';
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
        member.Today_Attendance__c = '';
        memberList.add(member);   
        insert memberList;
         
        List<shift_attendance__c> shiftAttList=new List<shift_attendance__c>(); 
        shift_attendance__c shiftAtt=new shift_attendance__c();
        shiftAtt.attendance_status__c='A';
        shiftAtt.Employee_name__c=member.Id;
         shiftAttList.add(shiftAtt);
         
         if(shiftAttList.size()>0){
             if(shiftAtt.attendance_status__c=='A') {
                 insert shiftAttList;
             }
         }
           
   
        Test.startTest();
        EPMS_Mark_TodayAttendance UpdateStatus=new EPMS_Mark_TodayAttendance();
        UpdateStatus.start(null);
        UpdateStatus.execute(null, memberList);
        UpdateStatus.finish(null);   
        
        Test.stopTest();
    }
}