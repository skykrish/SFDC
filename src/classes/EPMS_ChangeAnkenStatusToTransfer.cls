/**********************************************************************************
*   Class               :       EPMS_ChangeAnkenStatusToTransfer*
*   Created Date        :       05/06/2018                                        *           
*   Description         :       Used to change Anken status to Transfer           *
**********************************************************************************/

public class EPMS_ChangeAnkenStatusToTransfer{
public List<Anken__c> AnkenList=new List<Anken__c>();
public List<String> AnkenIds=new List<String>();
public List<Anken__c> UpdatedAnkenList=new List<Anken__c>();

public EPMS_ChangeAnkenStatusToTransfer(){
 string ids = ApexPages.currentPage().getParameters().get('ids');
 for(String key:ids.split(',')){
            AnkenIds.add(key);
        } 

if(AnkenIds.size()>0){
for(Anken__c Ank:[select id,Name,Status__c from Anken__c where id=:AnkenIds]){
Ank.Status__c ='Transferring';
UpdatedAnkenList.add(Ank);

}
}
update UpdatedAnkenList;

}





}