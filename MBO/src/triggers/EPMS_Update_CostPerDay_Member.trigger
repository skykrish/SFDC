trigger EPMS_Update_CostPerDay_Member on Member__c (after insert) {
    list<Member__c> updateMemberList=new list<Member__c>();
    Decimal percentageCost = 0;
    
    try{
    
        List<Member__c> memberList=[select id,name, Designation__c, Location_id__r.Group_Name__c, Location_id__r.Standard_Regular_Cost__c, Location_id__r.Photo_Artist_Standard_Regular_Cost__c, Location_id__r.TL_Standard_Regular_Cost__c, Location_id__r.QA_Standard_Regular_Cost__c from Member__c  where id=:trigger.new and Status__c = 'Active'];
    
        for(Member__c member : memberList){
            
            if (member.Designation__c == Label.EPMS_MEMBER_DESIG_OPERATOR_PS) {
                percentageCost = member.Location_id__r.Photo_Artist_Standard_Regular_Cost__c;
            } else if (member.Designation__c == 'Team Leader') {
                percentageCost = member.Location_id__r.TL_Standard_Regular_Cost__c;                                
            } else if (member.Designation__c == 'Quality Control') {
                percentageCost = member.Location_id__r.QA_Standard_Regular_Cost__c;                                
            }
            
            system.debug('$***** percentageCost : ' + percentageCost);
            
            if (percentageCost != null) {        
                //double cost = member.Location_id__r.Standard_Regular_Cost__c;
                //member.Cost_Per_Day__c = (cost/26)*percentageCost;
                member.Cost_Per_Day__c = percentageCost/26;
                system.debug('member.Cost_Per_Day__c **** : ' + member.Cost_Per_Day__c);
                updateMemberList.add(member);
            }
        }
        if (updateMemberList != null & updateMemberList.size() > 0) {
            system.debug('updateMemberList ::: ' + updateMemberList);
            update updateMemberList;
        }
    } catch (Exception ex) {
        system.debug('Exception in Updating Cost Per Day : ' + ex);
    }
}