/****************************************************************************************************
*   Class           :   Filecategory_Old_file_updation                                          *
*   Created Date    :   13/04/2016                                                              *           
*   Description     :   This trigger will update the order status                               *
                        based on files status change                                            *
*   Modifications   :   Category Modified checkbox is true whenever File Category is modified   *                                     
****************************************************************************************************/    

trigger Filecategory_Old_file_updation on Files__c (before update) {
    
    List<String> orderlist=new List<String>();
    List<Files__c> DBlist = new List<Files__c>(); 
    
    list<string> fileIdlist = new list<string>();
    Map<string,string> changedFilecategory = new Map<string,string>();
    Map<string,string> EstimatedFilecategory = new Map<string,string>();
    
    if(Trigger.isUpdate && Trigger.isBefore ){
        
        //if(EPMS_CheckRecursiveOldFileUpdation.runOnce()){
        system.debug('*******Trigger.new Size = ' + Trigger.new.size());
        
        for(Files__c f:Trigger.new){
            
            fileIdlist.add(f.Id);
            changedFilecategory.put(f.Id, f.File_Category_Code__c);  
            EstimatedFilecategory.put(f.Id, f.Estimated_File_Category__c);
        }  

            
        System.debug('The File Ids are:@@@'+fileIdlist);
        System.debug('The File Ids Size are:@@@'+fileIdlist.size());
        System.debug('The File Id With Category are:@@@'+changedFilecategory); 
        System.debug('The File Id With Estimated Category are:@@@'+EstimatedFilecategory);  
        
        Map<string,string> initFilecategory = new Map<string,string>(); 
        Map<string,string> initEstimatedFilecategory = new Map<string,string>();        
        
        if(fileIdlist != null && fileIdlist.size() > 0) { 
            DBlist = [select Id, Name, File_Category_Code__c,Estimated_File_Category__c From Files__c where Id IN:fileIdlist];
        }
        System.debug('The Old File names:####'+DBlist);
        
        for(Files__c f1:DBlist){
            if (f1.File_Category_Code__c != null) {
                initFilecategory.put(f1.Id,f1.File_Category_Code__c );
            }
        }
        
        for(Files__c f7:DBlist){
            if (f7.Estimated_File_Category__c != null) {
                initEstimatedFilecategory.put(f7.Id,f7.Estimated_File_Category__c );
            }
        }
        
        for(Files__c f2:trigger.new){
            if(initFilecategory.containsKey(f2.Id)){
                if (f2.File_Category_Code__c != initFilecategory.get(f2.Id)) {
                    f2.Category_Modified__c = true;
                }
            }
        } 
        
        for(Files__c f8:trigger.new){
            if(initEstimatedFilecategory.containsKey(f8.Id)){
                if (f8.Estimated_File_Category__c != initEstimatedFilecategory.get(f8.Id)) {
                    f8.Estimation_Updated__c = True;
                }
            }
        } 
        for(Files__c f6:trigger.new) {  
            if(f6.Old_Estimated_File_Category__c == null){
                if(f6.Estimated_File_Category__c != trigger.oldMap.get(f6.Id).Estimated_File_Category__c) {
                    f6.Old_Estimated_File_Category__c =trigger.oldMap.get(f6.id).Old_Estimated__c; 
                }    
            }
        }
        
        //}           
        /*if((f.Status__c=='QC' || f.Status__c=='On-Hold') && (f.Redo_Checked_Same_Member__c==false || f.Redo_Checked_Same_Member__c==true) && (f.Tracker_handover__c==false || f.Tracker_handover__c==true) && f.Is_Handover_File__c !=1 ){
keylist.add(f.Name);
parentidlst.add(f.Parent_Id__c);
orderlist.add(f.Production_Order_Name__c);

}

}
System.debug('The File Names are:@@@'+keylist);
System.debug('The Parent Names are:@@@'+parentidlst);
System.debug('The Production order Names are:@@@'+orderlist);

Map<string,string>Filecategory=new Map<string,string>();

list<Files__c>DBlist=[select Name,File_Category_Code__c,Parent_Id__c,Status__c From Files__c where Name IN:keylist AND (Status__c ='Redo Re-Assigned' OR Status__c ='On-Hold'  OR Status__c ='Assigned'  ) AND  (Redo_Checked_Same_Member__c=false or Redo_Checked_Same_Member__c=true OR Tracker_handover__c=true OR Tracker_handover__c=false) AND File_Proccessing_Status__c='Redo' AND Parent_Id__c IN: parentidlst AND Production_Order_Name__c IN:orderlist ];
System.debug('The Old File names:####'+DBlist);
for(Files__c f1:DBlist){
Filecategory.put(f1.name,f1.File_Category_Code__c );
}

for(Files__c f2:trigger.new){
if(Filecategory.containsKey(f2.Name)){
f2.File_Category_Code__c  = Filecategory.get(f2.Name);
}

}*/
        System.debug('!!!!trigger.new::::'+trigger.new);
    }
}