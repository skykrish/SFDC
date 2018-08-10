global class CreateAnkenAndPo implements Database.Batchable<sObject> {
    
    
    list<String> Ankenid=new list<string>();
        list<Anken__c> Anklist=new list<Anken__c>();
        list<Production_Order__c> polist=new list<Production_Order__c>();
        global String query;
        global CreateAnkenAndPo(){
         query='Select id,name from Anken__C limit 2'; 
        }
    global Database.QueryLocator start(Database.BatchableContext BC){
       
        
        return Database.getQueryLocator(query);     
    }  

    global void execute(Database.BatchableContext BC, List<Anken__C> AnkRecords){
        
for(integer i=0;i<15;i++){
    Anken__c ank=new Anken__C();
    ank.ItemCnt__c=30;
    ank.KokyakuName__c='0011000000Ws2iB';
    ank.JuchuDateTime__c = system.now();
    ank.KokyakuTantosya_Main__c ='003N000001DVgrD';
    Anklist.add(ank);   
}

insert Anklist;

for(Anken__c anken:Anklist){
    Ankenid.add(anken.id);
    
}

for(Anken__c anken:[select id,name,ItemCnt__c from Anken__c where id=:Ankenid]){
    Production_Order__c prod=new Production_Order__c();
    prod.Anken_Order__c=anken.Id;
    prod.Name=anken.Name;
    prod.Total_Files_Count__c=anken.ItemCnt__c;
    prod.Production_Order_Status__c='NEW';
    prod.Mbo_Location__c='a0q5F0000071jDD';
    prod.Sales_Region_Country__c='India';
	prod.Location_For_Sharing__c='MBOI Phase-2';
   polist.add(prod);
}
insert polist; 
        system.debug('-----executebatch-----');

   } 
    global void finish(Database.BatchableContext BC) {    
    }
}