/**********************************************************************************
*   Class               :       EPMS_batchToUpdateCostPerDayInMember              *
*   Created Date        :       16/01/2018                                        *           
*   Description         :       This Batch Used to update cost per day field      *
*                                in Member Object based on Standard Regular cost  *
*                                in Location Object when there are more records.  *
*                                                                                 *
**********************************************************************************/

global class EPMS_batchToUpdateCostPerDayInMember implements Database.Batchable<sObject> {

    global String query;
    global id ids;
    global Location__c location=new Location__c();

    //To write Query on Member object based on location Record Id
    
    global EPMS_batchToUpdateCostPerDayInMember(id getid){
        ids=getid;
        system.debug('----ids----'+ids);
        query='select id,Designation__c,Cost_Per_Day__c,Location_id__c from Member__c where Location_id__c=:ids';
        
    }
    //To Return Query result to the Execute Method
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('-----startbatch----');
        
        return Database.getQueryLocator(Query);     
    }  

    global void execute(Database.BatchableContext info, List<Member__c> scope){
        
        system.debug('-----executebatch-----');
        system.debug('-----member----'+scope);
        
        List<Member__c> updateMemberField=new List<Member__c>();

        try {
        
        location = [select id, Standard_Regular_Cost__c, Photo_Artist_Standard_Regular_Cost__c, TL_Standard_Regular_Cost__c, QA_Standard_Regular_Cost__c from Location__c where id=:scope[0].Location_id__c];
        
        
            integer i=0;
            for(Member__c member :scope) { 
                
                system.debug('----location----'+location);
                
                //Calculation for Cost per day in Member Object based on standard Regular cost in Location field and designation 
                
                Decimal percentageCost = 0;
                if (member.Designation__c == Label.EPMS_MEMBER_DESIG_OPERATOR_PS) {
                    percentageCost = location.Photo_Artist_Standard_Regular_Cost__c;                             
                } else if (member.Designation__c == 'Team Leader') {
                    percentageCost = location.TL_Standard_Regular_Cost__c;                              
                } else if (member.Designation__c == 'Quality Control') {
                    percentageCost = location.QA_Standard_Regular_Cost__c;                              
                }
                
                system.debug('percentageCost ***** : ' + percentageCost);  
                
                if (percentageCost != null) {
                    Decimal stdRegCost = location.Standard_Regular_Cost__c;
                    member.Cost_Per_Day__c = percentageCost/26;
                    
                    system.debug('member.Cost_Per_Day__c ***** : ' + member.Cost_Per_Day__c);
                    updateMemberField.add(member);
                }
            }
            
            //Update the child record which are relation to the particular location
            
            if (updateMemberField != null && updateMemberField.size() > 0) {
                system.debug('updateMemberField ***** : ' + updateMemberField);
                UPDATE updateMemberField;
            }
        }
        catch (Exception ex) {
            system.debug('Exception in Updating Cost Per Day in Member : ' + ex);
        } 
    } 
    global void finish(Database.BatchableContext info) {    
    }
}