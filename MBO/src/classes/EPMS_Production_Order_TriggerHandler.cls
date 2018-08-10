public with sharing class EPMS_Production_Order_TriggerHandler{
  
   public EPMS_Production_Order_TriggerHandler(){
    
         
       

   }

    public static void onBeforeInsert(List<Production_Order__c> prodOrderList){ 
        boolean errorFlag = true;
       
             
        List<Member__c> memberList = [select id,Name,Designation__c,Location_id__c from Member__c where Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS and id!=null];
        
        List<Production_Order__c> tlLocList = new List<Production_Order__c>();
        List<Production_Order__c> qcLocList = new List<Production_Order__c>();
        for(Production_Order__c newPO : prodOrderList){                        
            if(errorFlag){
                for(Member__c oldMember : memberList ){
                    if(oldMember.id == newPO.TL_Incharge__c && oldMember.Location_id__c == newPO.Mbo_Location__c ){
                        tlLocList.add(newPO);
                    }
                    if(oldMember.id == newPO.QC_Incharge__c && oldMember.Location_id__c == newPO.Mbo_Location__c ){
                        qcLocList.add(newPO);
                    }
                }
                
                if(newPO.TL_Incharge__c!=null){
                    if(tlLocList.isEmpty()){
                        newPO.addError(Label.EPMS_MBO_TL_incharge_does_not_belongs_to_Mbo_Location); 
                        errorFlag=false;
                    }else{
                        newPO.Production_Order_TL_Assignment_Time__c=System.Now();
                    }                   
                }else{
                    newPO.Production_Order_TL_Assignment_Time__c=null;
                } 
                
                if(newPO.QC_Incharge__c!=null){
                    if(qcLocList.isEmpty()){
                        newPO.addError(Label.EPMS_MBO_QC_incharge_does_not_belongs_to_Mbo_Location); 
                        errorFlag=false;
                    }else{
                        newPO.Production_Order_Qc_Assignment_Time__c=System.Now();
                    }
                }else{
                    newPO.Production_Order_Qc_Assignment_Time__c=null;
                } 
            }
            
        }       
    }
    
    
    
    
    
    
    public static void onBeforeUpdate(List<Production_Order__c> prodOrderList){
        
       List<String> status_list = new List<string>();
       status_list.add('QCIP');
         status_list.add('Completed');
          status_list.add('Pending');
           status_list.add('Redo');
            status_list.add('Handover');
             status_list.add('Customer-Approved');
        
        
        
        
          
          
          
          
          
          
          
        boolean errorFlag = true;
        Set<Id> prodIds = new Set<Id>();
        if(prodOrderList != null && prodOrderList.size() > 0){
            for(Production_Order__c order :prodOrderList){
                prodIds.add(order.Id);
            }
            
        }
        
        system.debug(' $$$ [Order File Ids] : {'+ prodIds +'}');
        List<Member__c> memberList = [select id,Name,Designation__c,Location_id__c from Member__c where Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS and id!=null];
        //List<Production_Order__c> oldPOList =[select id,TL_Incharge__c,QC_Incharge__c,Production_Order_TL_Assignment_Time__c,Production_Order_Qc_Assignment_Time__c,Mbo_Location__r.Name from Production_Order__c where id!=null];
        List<Production_Order__c> oldPOList =[select id,TL_Incharge__c,QC_Incharge__c,Production_Order_TL_Assignment_Time__c,Production_Order_Qc_Assignment_Time__c,Mbo_Location__r.Name from Production_Order__c where id IN : prodIds];
        
        List<Production_Order__c> tlLocList = new List<Production_Order__c>();
        List<Production_Order__c> qcLocList = new List<Production_Order__c>();        

        List<Production_Order__c > oldProdOrderList = [select id, Name,Mbo_Location__r.Name,Production_Order_Status__c from Production_Order__c where  Production_Order_Status__c  =: status_list and createdDate > LAST_MONTH];
        //List<Production_Order__c > oldProdOrderList = [select id, Name,Mbo_Location__r.Name,Production_Order_Status__c from Production_Order__c where id!=null];
   
        //List<Files__c> oldFileList =[select id,Name,File_Category_Code__c,File_Category_Code__r.Name,Status__c,Production_Order__c from Files__c where id!=null AND Status__c='Approved'];
        List<Files__c> oldFileList =[select id,Name,File_Category_Code__c,File_Category_Code__r.Name,Status__c,Production_Order__c from Files__c where Production_Order__c IN : prodIds AND Status__c='Approved'];
        List<File_Categories__c> oldFileCategoryList =[select id,Name from File_Categories__c where id!=null];
        
        List<Production_Order__c> updatePOList = new List<Production_Order__c>();
        List<Files__c> updateFileList = new List<Files__c>();
        
        List<File_Classification__c> fileClassficationList = new List<File_Classification__c>();
        List<Files__c> fcFileList = new List<Files__c>();
        
        List<String> fileNameList = new List<String>();
        Set<Id> fileCategoryList = new Set<Id>();
        
        Integer i =1;
        
        String[] stringList = new String[0];
        String[] categotyList = new String[0];
        
        for(Production_Order__c newPO : prodOrderList){                        
            if(errorFlag){
                // Change Order Status validation
               // if(newPO.TL_Incharge__c == null && newPO.QC_Incharge__c == null && newPO.Production_Order_Status__c == 'Assigned'){
                //   newPO.addError(Label.EPMS_MBO_Team_Leader_cannot_be_changed_when_order_status_is_Assigned);                
               // }
               
                for(Member__c oldMember : memberList ){
                    if(oldMember.id == newPO.TL_Incharge__c && oldMember.Location_id__c == newPO.Mbo_Location__c ){
                        tlLocList.add(newPO);
                    }
                    if(oldMember.id == newPO.QC_Incharge__c && oldMember.Location_id__c == newPO.Mbo_Location__c ){
                        qcLocList.add(newPO);
                    }
                }
                
                
                
                for(Production_Order__c oldPO : oldPOList){
                system.debug('-----qcLocList-----'+qcLocList);
                    system.debug(' [INSIDE TL & QC UPDATE] : Production Order ' + oldPO);
                    if(oldPO.Id == newPO.Id){
                        if(newPO.TL_Incharge__c!=null){
                            if(tlLocList.isEmpty()){
                                newPO.addError(Label.EPMS_MBO_TL_incharge_does_not_belongs_to_Mbo_Location); 
                                errorFlag=false;
                            }
                            if(oldPO.TL_Incharge__c != newPO.TL_Incharge__c){
                                newPO.Production_Order_TL_Assignment_Time__c=System.Now();
                            }
                        }else{
                            newPO.Production_Order_TL_Assignment_Time__c=null;
                        }
                        
                        if(newPO.QC_Incharge__c!=null){
                            if(qcLocList.isEmpty()){
                                newPO.addError(Label.EPMS_MBO_QC_incharge_does_not_belongs_to_Mbo_Location); 
                                errorFlag=false;
                            }
                            if(oldPO.QC_Incharge__c != newPO.QC_Incharge__c){
                                newPO.Production_Order_Qc_Assignment_Time__c=System.Now();  
                            }
                        }else{
                            newPO.Production_Order_Qc_Assignment_Time__c=null;
                        }                                                   
                    }
                }               
            }           
        }
        
        system.debug(' [OUTSIDE TL & QC UPDATE] : Production Order [NEW] : ' + prodOrderList);
        system.debug(' [OUTSIDE TL & QC UPDATE] : Production Order [OLD] : ' + oldProdOrderList);
        
        for(Production_Order__c newPO : prodOrderList){
            system.debug('### New Order Name : { ' + newPO.Name + ' } : Status = [' + newPO.Production_Order_Status__c + ']');
            for(Production_Order__c oldPO : oldProdOrderList){
                system.debug('*** Old Order Name : { ' + oldPO.Name + ' } : Status = [' + oldPO.Production_Order_Status__c + ']');
                if(oldPO.Id == newPO.Id && (newPO.Production_Order_Status__c ==label.EPMS_CompletedStatus_Order || newPO.Production_Order_Status__c == 'Uploaded')){
                    updatePOList.add(newPO);                
                    system.debug(' FOR UPDATE - Classification : ' + updatePOList);
                }
            }
        }

        system.debug(' $$$$$ [Order Update List ] : {'+ updatePOList +'}');

        for(Production_Order__c proOrder : updatePOList){
            for(Files__c file:oldFileList){
                if(file.Production_Order__c == proOrder.id){
                    updateFileList.add(file);
                }
            }
        } 
        system.debug('&&&&& [Order File List ] : {'+ updateFileList +'}');
        for(File_Categories__c fileCategory :oldFileCategoryList){
            for(Files__c file:updateFileList){
                system.debug(' File Category are : ' + file.File_Category_Code__c); 
                if(file.File_Category_Code__c == fileCategory.id){                   
                    fcFileList.add(file);
                    fileCategoryList.add(file.File_Category_Code__c);
                    system.debug('Added File Category are : ' + file.File_Category_Code__c);
                }
            }
        }
        
       system.debug('Added File Category List are : ' + fileCategoryList);
       system.debug('Added File Category File List are : ' + fcFileList);
       Map<String, string> fcMap = new Map<String, string>(); 
            for(File_Classification__c fcs: [Select Production_Order__c,Id,Name,File_Ids__c From File_Classification__c where Production_Order__c IN:updatePOList]){
            system.debug('----categoryMap----'+fcs.File_Ids__c);
                fcMap.put(fcs.Production_Order__c,fcs.File_Ids__c);                                         
            }                                    
                                                
        List<String> fileIds= new List<String>();
        integer cat=0;     
        system.debug('Added File Classification Map : ' + fcMap);
        for(Production_Order__c proOrder: updatePOList){
            string proorderId=proOrder.Id;
            system.debug('*** [Production Order are ] : '+proorderId);
            for(Id CategoryCode : fileCategoryList){                
                    for(Files__c file:fcFileList){
                        if(file.File_Category_Code__c == CategoryCode)
                            fileIds.add(file.Name);
                        else    
                            system.debug('[Un Categorized Files are ] : '+file.Name);
                    }           
               
                
                if(fcMap.containsKey(proOrder.Id)){
                system.debug('No need to add file classifcation');
                }
                else{
                cat++;               
                File_Classification__c fc= new File_Classification__c();
                if(cat < 10){
                    fc.Name=proOrder.Name +'-' + '00' + String.valueOf(cat);
                } else if(cat < 100){
                    fc.Name=proOrder.Name + '-' + '0'+ String.valueOf(cat);
                } else {
                    fc.Name=proOrder.Name + '-' + String.valueOf(cat);
                }
                
                
                fc.File_Ids__c = String.join(fileIds, ', ');
                fc.Production_Order__c= proOrder.Id;            
                fc.File_Category__c=CategoryCode;
                fc.Location_For_Sharing__c=proOrder.Location_For_Sharing__c;
                fc.File_Category_Count__c=fileIds.size();
                fileClassficationList.add(fc);
                fileIds.clear();
                i++;
                }
            }           
        }
        system.debug('[Classification Files are ] : '+fileClassficationList);
        set<File_Classification__c> fc=new set<File_Classification__c >();
        List<File_Classification__c> newFileClassficationList=new List<File_Classification__c >();
        if(fileClassficationList.size()>0){
            fc.addAll(fileClassficationList);
            newFileClassficationList.addAll(fc);
        }
            
        system.debug('[New Classification Files are ] : '+newFileClassficationList);
        if(newFileClassficationList.size()>0)
            upsert newFileClassficationList;        
        }
    
    
}