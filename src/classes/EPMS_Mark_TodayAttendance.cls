/************************************************************************************** 
*   Class               :   EPMS_Mark_TodayAttendance                                 *
*   Created Date        :   28/03/2018                                                *           
*   Description         :   Controller to update Member Attendance                    *
**************************************************************************************/
global class EPMS_Mark_TodayAttendance implements Database.Batchable<sObject> {
    
    String query = '';
    String status = 'Active';
    String todayAttendance = 'A';
    List<Member__c> updateMemberList = new List<Member__c>();
    
    global EPMS_Mark_TodayAttendance() {
        query = 'select id, name, Emp_ID__c, Today_Attendance__c from Member__c where Status__c =: status and Today_Attendance__c =: todayAttendance';   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {   
        return Database.getQueryLocator(query);        
    }   
    
    global void execute(Database.BatchableContext BC, List<Member__c> memberList) {
        
        system.debug('************ memberList : ' + memberList);    
        string updateStatus='';
        List<id> memberIDS=new List<id>();
        set<Id> memberIdSet = new Set<id>();
        List<shift_attendance__c> updateNoWorkAttendance = new List<shift_attendance__c>();
        for(Member__c mem:memberList) {
            memberIDS.add(mem.Id);    
        }        
        memberIdSet.addAll(memberIDS);        
        
        list<id> removeAbsentIds = new list<id>();
        for(Member__c memobj :memberList ) {
            removeAbsentIds.add(memobj.Id);  
        }
        List<shift_attendance__c>  shiftAttendStatusList = [select attendance_status__c,Employee_name__c  from shift_attendance__c where Employee_name__c In: memberlist];
        
        if(shiftAttendStatusList.size()>0) {
            for(shift_attendance__c shiftAttendance : shiftAttendStatusList){
                
                if(memberIdSet.contains(shiftAttendance.Employee_Name__c) && (shiftAttendance.Attendance_Status__c==EPMS_UTIL.EPMS_AbsentStatus)){
                    updateNoWorkAttendance.add(shiftAttendance);
                }
            }           
            if(memberList.size()>0 && memberList!=null) {
                List<Member__c> updateMemAttendance = new  List<Member__c>();           
                for(Member__c memAttendance : memberList){         
                    memAttendance.Today_Attendance__c='';
                    updateMemAttendance.add(memAttendance);
                }
                if(updateMemAttendance.size()>0) {
                    update updateMemAttendance;
                }
            }       
            
            try {
                if(updateNoWorkAttendance.size() > 0){
                    delete updateNoWorkAttendance;
                } else{
                    updateStatus = 'Error';
                }
            } catch(DMLException me) {
                updateStatus = 'Error';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
            } 
        }else{
            updateStatus = 'Error';
        }
        
        /*     Try{
            if(memberList.size()>0) {
                for(Member__c member : memberList) { 
                        member.Today_Attendance__c='';
                        updateMemberList.add(member);                    
                } 
            }
            
            if (updateMemberList != null && updateMemberList.size() > 0) {
                UPDATE updateMemberList;                
            }
        
            sendEmail(updateMemberList);
            
        } catch(Exception e) {
            system.debug('Exception in Updating Member Attendance : ' + e);
        }  */
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    // Temporarly added removed
   /* public void sendEmail(List<Member__c> updateMemberList) {
        String memStr = ''; 
        
        for (Member__c mem : updateMemberList) {
            memStr = memStr + mem.Emp_ID__c + ' - ' + mem.name + '<BR>';        
        }
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String eAddr = 'krishnasamys@chn.srmtech.com';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(eAddr);
        mail.setToAddresses(sendTo);

        mail.setSenderDisplayName('MBO Team');
    
        List<String> ccTo = new List<String>();
        ccTo.add('aarthig@chn.srmtech.com');
        mail.setCcAddresses(ccTo);

        mail.setSubject('Member Attendance Marked');
        String body = 'Member Attendance Batch ran at ' + system.now() + '<BR><BR>';
        body += 'Marked Attendance P for below Member(s) <BR><BR>';
        body += memStr;
        mail.setHtmlBody(body);
    
        mails.add(mail);
        
        Messaging.sendEmail(mails);
    } */
}