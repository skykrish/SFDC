trigger RemoveOrder on Files__c (after update) {

if(EPMS_CheckRecursiveRemoveOrder.runOnce()){

List<id> poids = new List<id>();
set<id> tlmemids = new set<id>();
set<id> qcmemids = new set<id>();
Map<id,member__c> tlidsMap;
Map<id,member__c> qcidsMap;
List<production_order__c> porders = new List<production_order__c>();
List<production_order__c> pordersqc = new List<production_order__c>();



for(files__c f:trigger.new){
   
    poids.add(f.production_order__c);
   

}
Map<id,set<id>> potlMap = new Map<id,set<id>>();
Map<id,set<id>> poqcMap = new Map<id,set<id>>();


Map<id,production_order__c> prodordersMap = new Map<id,production_order__c>([select id,TLuseridR1__c,TLuseridR2__c,QCidr1__c,QCidr2__c from production_order__c where id=:poids]);

List<files__c> files = [select production_order__c,name,TLInCharge__r.user_id__c,QCIncharge__r.user_id__c from files__c where production_order__c =:poids and status__c != 'Approved' and status__c != 'On-Hold'];
if(files.size()>0){


for(files__c f:files)
{
    if(potlMap.get(f.production_order__c) != null)
    {
        potlMap.get(f.production_order__c).add(f.TLInCharge__r.user_id__c);
    }else{
        potlMap.put(f.production_order__c,new set<id>{f.TLInCharge__r.user_id__c});
    }

     if(poqcMap.get(f.production_order__c) != null)
    {
        poqcMap.get(f.production_order__c).add(f.QCIncharge__r.user_id__c);
    }else{
        poqcMap.put(f.production_order__c,new set<id>{f.QCIncharge__r.user_id__c});
    }

}
System.debug('--------potlMap------'+potlMap);



/* System.debug('--------------potlMap.values()-----------'+potlMap.values());
List<id> ordertlid = new List<id>();
List<set<id>> ordersetlist = new List<set<id>>();

for(id ortlid:potlMap.values().split(',')){
    ordertlid.add(ortlid);
}
System.debug('------------ordersetlist--------'+ordersetlist);

tlidsMap= new Map<id,member__c>([select id,user_id__c from member__c where id =:potlMap.values()]); */
       
    Integer i = 0;
    Integer j = 0;
   
    System.debug('----------tlidsMap------------'+tlidsMap);
            for(id poid:prodordersMap.keyset())
            {
                prodordersMap.get(poid).TLuseridR1__c = '';
                prodordersMap.get(poid).TLuseridR2__c = '';
                  prodordersMap.get(poid).QCidr1__c = '';
                prodordersMap.get(poid).QCidr2__c = '';

                i = 0;
                j = 0;
                if(potlMap.get(poid) != null){

               
                for(id tlid: potlMap.get(poid)){
                    System.debug('-----------tlid-----------'+tlid);
                    if(i<=13){
                        if(prodordersMap.get(poid).TLuseridR1__c != ''){
                             prodordersMap.get(poid).TLuseridR1__c +=  ','+tlid;
                        }else{
                            prodordersMap.get(poid).TLuseridR1__c = tlid;
                        }

                    }else{

                         if(prodordersMap.get(poid).TLuseridR2__c != ''){
                             prodordersMap.get(poid).TLuseridR2__c += ','+tlid;
                        }else{
                            prodordersMap.get(poid).TLuseridR2__c = tlid;
                        }

                    }
                   i++;

                }
                } 
                if(poqcMap.get(poid) != null){

             
                for(id qcid: poqcMap.get(poid)){
                    System.debug('-----------tlid-----------'+qcid);
                    if(j<=13){
                        if(prodordersMap.get(poid).QCidr1__c != ''){
                             prodordersMap.get(poid).QCidr1__c +=  ','+qcid;
                        }else{
                            prodordersMap.get(poid).QCidr1__c = qcid;
                        }

                    }else{

                         if(prodordersMap.get(poid).QCidr2__c != ''){
                             prodordersMap.get(poid).QCidr2__c += ','+qcid;
                        }else{
                            prodordersMap.get(poid).QCidr2__c = qcid;
                        }

                    }
                   j++;

                }
                }
               porders.add(prodordersMap.get(poid));

            } 



}

else{
 for(id poid:prodordersMap.keyset()){
 
 prodordersMap.get(poid).QCidr1__c='';
 prodordersMap.get(poid).QCidr2__c='';
 prodordersMap.get(poid).TLuseridR1__c='';
 prodordersMap.get(poid).TLuseridR2__c='';
 
 porders.add(prodordersMap.get(poid));
 
 }
 
 }


System.debug('----------porders----------------'+porders);

    if(porders.size()>0){
       
        try{
             update porders;
        }catch(exception e){
            System.debug('--------------------'+e);
        }
       
    }


}

}