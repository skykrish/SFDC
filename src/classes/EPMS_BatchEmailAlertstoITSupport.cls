/***********************************************************************/
/* Class Name          :  EPMS_BatchEmailAlertstoITSupport                 */
/*  Created Date       :  11/12/2017                                      */
/* Description         :  Email Alerts to IT Support for New Orders      */
/***********************************************************************/
global class EPMS_BatchEmailAlertstoITSupport implements Database.Batchable<SObject> {
    
    DateTime theDateTime = DateTime.valueOfGMT(String.valueOf(DateTime.now().addMinutes(-5)));  
    // Production_Order__c plist = [select id,Name,Mbo_Location__c,owner.Name,Production_Order_Instruction__c,Anken_Order__c,createddate,New_Files_Count__c,Total_Anken_Count__c from Production_Order__c where Production_Order_Status__c ='New' and createddate >=: theDateTime];
    //Decimal countfile = plist.New_Files_Count__c;
    
    global List<Member__c> ItAdmins=new List<Member__c>();
    global List<Production_Order__c>  polist=new List<Production_Order__c>();
    global String Location;
    global list<String> mailIds;
    
    global EPMS_BatchEmailAlertstoITSupport(String Loc){
     Location=loc;
     system.debug('-----loc----'+Location);
    
        List<Production_Order__c>  polist = [select id,Name,Mbo_Location__r.Name,File_Count_Delay__c,Mbo_Location__c,ReUpload__c,Production_Order_Instruction__c,owner.Name,Production_Order_TAT__c,Anken_Order__c,createddate,New_Files_Count__c,Total_Anken_Count__c,Production_Order_Status__c from Production_Order__c where Production_Order_Status__c IN ('New','Estimation Request')   and createddate <= :system.now().addMinutes(-20)  and ReUpload__c=false and Mbo_Location__r.Name=:Location and File_Count_Delay__c=false order by createddate asc];

    system.debug('----polist----'+polist);
    
    }
   
    String s = System.URL.getSalesforceBaseUrl().getHost();
    
    string startMail;
    string mailBody = '';
    string endMail = '<br><br>Thanking You <br> EPMS Administrator';
    
     
    
    global List<Production_Order__c> start(Database.BatchableContext ctx) {
        return polist;  
    }
    global void execute(Database.BatchableContext BC, List<Production_Order__c> polist) {
        
        List<User> mailUsers = [select id, Email from User where Profile.Name ='IT Administrator' ];
        system.debug('***********IT Administrator************'+mailUsers);
        
        //List<Production_Order__c> polist = [select id,Name,File_Count_Delay__c,Mbo_Location__c,Production_Order_Instruction__c,owner.Name,Production_Order_TAT__c,Anken_Order__c,createddate,New_Files_Count__c,Total_Anken_Count__c from Production_Order__c where Production_Order_Status__c ='New' and createddate >= :theDateTime];
        system.debug('PO list:'+polist.size());  
    }
    global void finish(Database.BatchableContext BC) {
        
        
        
        
        startMail = 'Files belonging to the ' +Location+ ' for the following Production orders have not been uploaded on epms <br><br>';
        polist=[select id,Name,Mbo_Location__r.Name,File_Count_Delay__c,Mbo_Location__c,ReUpload__c,Production_Order_Instruction__c,owner.Name,Production_Order_TAT__c,Anken_Order__c,createddate,New_Files_Count__c,Total_Anken_Count__c,Production_Order_Status__c from Production_Order__c where Production_Order_Status__c IN ('New','Estimation Request') and createddate <= :system.now().addMinutes(-20)  and ReUpload__c=false and Mbo_Location__r.Name=:Location and File_Count_Delay__c=false order by createddate asc];
        system.debug('------polist------'+polist);
        system.debug('------location------'+Location);
        
        
      //to get It Admin Mail Ids Based on their Location and designation  
        
      /*   List<Member__c> ItAdmins=[select id,User_Id__r.Email from Member__c where Designation__c='IT Administrator' and Location_id__r.Name=:Location];
         system.debug('-----ItAdmins----'+ItAdmins);  
    
     Set<String> ItAdminEmails=new Set<String>();
     List<String> ItAdminEmailIds=new List<String>();
    
     
     //to add the it admin mail ids to the List of string
     
        if(ItAdmins.size()>0){
        for(Member__c mem:ItAdmins){
        ItAdminEmails.add(mem.User_Id__r.Email);
        }
        }
        
        ItAdminEmailIds.addAll(ItAdminEmails);  
        
        
        system.debug('-------itadminemails------'+ItAdminEmails);  */
        String myDate;
        
        if(polist.size()>0) {
            List<Production_Order__c> listp = new List<Production_Order__c>();
            for(Production_Order__c p:polist) {
                if((p.Total_Anken_Count__c > p.New_Files_Count__c) || p.Total_Anken_Count__c==0) {
                p.File_Count_Delay__c=True;
                    listp.add(p);
                    Date TATDate;
                    Integer hours,minutes;
                    
                    DateTime poTAT = p.Production_Order_TAT__c;
                    
                    if(poTAT !=null){
                    myDate = poTAT.format('yyyy/MM/dd HH:mm', 'IST');
                    
                    system.debug('-----myDate---'+myDate);
                   }
                     
                     
                     if(poTAT !=null){
                    mailbody +='<a href=https://' + System.URL.getSalesforceBaseUrl().getHost() + '/'+p.Id+'>'+p.Name+'</a>'+'  '+'Total File Count(Anken):'+p.Total_Anken_Count__c+'  '+'TAT:'+myDate+'<br><br>';
                      }else{
                      
                       mailbody +='<a href=https://' + System.URL.getSalesforceBaseUrl().getHost() + '/'+p.Id+'>'+p.Name+'</a>'+'  '+'Total File Count(Anken):'+p.Total_Anken_Count__c+'  '+'TAT:'+p.Production_Order_TAT__c+'<br><br>';
                      }
                
                } 
            }
           
                if(listp.size()>0) {
                update listp;
                system.debug('*****************************'+listp);
                
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
               
               // mail.setTargetObjectId(UserInfo.getUserId());
              // mail.setReplyTo('noreply@Salesforce.com on behalf of MBOI Admin');
                 mail.setSenderDisplayName('serversupport@mboi.in');
              
              //  mail.setToAddresses(ItAdminEmailIds);
           //   mail.setToAddresses(mailIds);
           //   mail.setToAddresses(new String[] {'support@mboi.in'});
              
              //     mail.setToAddresses(new String[] {'aarthig@chn.srmtech.com'}); 
                    mail.setToAddresses(new String[] {'sreeudayareddy@gmail.com'});               
                mail.saveAsActivity = false;
                mail.setSubject(startMail);
                mail.setHtmlBody(startMail+mailbody+endMail);
                mails.add(mail);
                Messaging.sendEmail(mails);
            }
            }
        
    }
}