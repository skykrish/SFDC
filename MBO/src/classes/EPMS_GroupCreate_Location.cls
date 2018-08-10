/**********************************************************************************
*   Class               :       EPMS_GroupCreate_Location                         *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to create/update Public group          *
**********************************************************************************/
public class EPMS_GroupCreate_Location{

    public static void createGroup(list<Location__c> triggernew)
    {
        List<Group> groupList = new List<Group>();
        for(Location__c loc: triggernew){
            Group newGroup = new Group();
            if(loc.Location_Status__c !=EPMS_UTIL.EPMS_INACTIVE_STATUS){
                if(String.valueOf(loc.Name).length()>40)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.EPMS_MBO_GROUP_CREATION_CHAR_MESSAGE));
                else
                    newGroup.Name = String.valueOf(loc.Name);
                    groupList.add(newGroup);
            }
        }
        try{
            if(groupList!=null && groupList.size()>0 )
                upsert groupList;
            }Catch(Exception e){
                System.debug(e);
        }
    }
}