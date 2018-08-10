/**********************************************************************************
    *   Class               :       EPMS_updateOrderStatus                            *
    *   Created Date        :       13/04/2016                                        *            
    *   Description         :       This trigger will update the order status
                                    based on files status change                     *
**********************************************************************************/ 

trigger EPMS_updateOrderStatus on Files__c (before update,After update){
    
    List<Production_Order__c> productionOrderList = null;
    List<Production_Order__c> productionOrderList1 = null;
    List<Files__c> filesList = Trigger.new;
    Set<String> fileOrderStatusList = new Set<String>();
    Set<String> fileOrderStatusList1 = new Set<String>();
    String orderStatus = null;
    String orderId = null;
    boolean doStatusCheck = false;
    boolean doJobTitleChange = false;
    boolean doImmediateFileUpdateOrder = false;
    Set<Id> productionOrderSet = new Set<Id>();
    string userId = String.valueOf(userinfo.getuserid());
    String loginMemberId = null;
    String TLIncharge = null;
    String Estimator = null;
    
    system.debug('***** $$$ userId = ' + userId);
    
    system.debug(' *** doStatusCheck : ' + doStatusCheck);
    
    List<String> memberAvailProfiles = new List<String>();
    memberAvailProfiles.add(Label.EPMS_MEMBER_DESIG_OPERATOR_PS);
    memberAvailProfiles.add('Team Leader');
    memberAvailProfiles.add('Quality Control');
    memberAvailProfiles.add('Shift Administrator');
    memberAvailProfiles.add('IT Administrator');
    memberAvailProfiles.add('Production Administrator');
    memberAvailProfiles.add('Assignor');
    system.debug('********** memberAvailProfiles : ' + memberAvailProfiles);
    
    /*code addition by subbarao*/
    
    List<files__c> poorders = new List<files__c>();
    List<production_order__c> PoList = new List<production_order__c>();
    

        if(trigger.isAfter){
        if(trigger.isUpdate){

            //if(EPMS_CheckRecursiveUpdateSt.runOnce()){
            
            poorders = [select id,production_order__c from files__c where id=:Trigger.new];
            List<id> pids = new List<id>();
            boolean isMember = false;
            for(files__c pods:poorders){
                pids.add(pods.production_order__c);
            }
            system.debug('-----------------------------------------------------------pids'+pids);
            PoList = [select id,Name,Production_Order_Status__c, Estimator__c, TL_Incharge__c from production_order__c where id=:pids AND Production_Order_Status__c !=: Label.EPMS_FileStatus_Pending];
            
            if(PoList != null && PoList.size() > 0){
                TLIncharge = PoList[0].TL_Incharge__c;
            }            

            system.debug('-----------------------------------------------------------PoList'+PoList);
            
            List<Profile> frofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            system.debug('Profile Name $$ ************* :: ' + frofile[0].Name);    
            
            for (String prof : memberAvailProfiles) {
                if (prof == frofile[0].Name) {
                    isMember = true;
                }
            }
                                
            // System Administrator & Country Administrator, Full Time Epmloyees(Japan) and Part Time Employees(Japan) are not part of Member so restricted for both 
            //if (frofile[0].Name != 'システム管理者' && frofile[0].Name != 'System Administrator' && frofile[0].Name != 'Part-time Employees (Japan)' && frofile[0].Name != 'Country Administrator' && frofile[0].Name != 'Full-time Employees (Japan)') {
            if (isMember) {
                Member__c mem = [SELECT Id,Name FROM Member__c WHERE User_Id__c=:userId and Status__c='Active' limit 1];
                if (mem != null) {
                    loginMemberId = mem.id;
                }
            }   
            
            
            List<files__c> requiredFileList = new List<files__c>();
            List<files__c> newfileset = new List<files__c>();
            List<files__c> completedFileSet = new List<files__c>();
            List<files__c> wipFileSet = new List<files__c>();
            List<files__c> qcFileSet = new List<files__c>();
            List<files__c> assignedFileSet = new List<files__c>();
            
            //EPMSSF-521 Changes - Start
            List<files__c> newfilesetAA = new List<files__c>();
            List<files__c> estimationRequestFileSet = new List<files__c>();
            List<files__c> estimatorAssignedFileSet = new List<files__c>();
            List<files__c> awaitingApprovalFileSet = new List<files__c>();
            List<production_order__c> newPOsetAA = new List<production_order__c>();
            List<production_order__c> estimationRequestPOSet = new List<production_order__c>();
            List<production_order__c> estimatorAssignedPOSet = new List<production_order__c>();
            List<production_order__c> awaitingApprovalPOSet = new List<production_order__c>();
                        
            //EPMSSF-521 Changes - End
            
            List<production_order__c> newPOSet = new List<production_order__c>();
            List<production_order__c> assignedPOSet = new List<production_order__c>();            
            List<production_order__c> newCompletedPOSet = new List<production_order__c>();
            List<production_order__c> workInProgressPOSet = new List<production_order__c>();
            List<files__c> poListFiles = new List<files__c>();
            Map<Id,List<files__c>> productionFilesMap = new Map<Id,List<files__c>>();
            
            
            requiredFileList = [SELECT Id, Name,FTP_Upload_Status__c,Production_Order__c,File_Type__c, Status__c,Tracker_handover__c, Estimator__c FROM Files__c WHERE Production_Order__c IN : pids AND File_Type__c = 'Image' AND Tracker_handover__c=FALSE ];
            
            if(requiredFileList != null && requiredFileList.size() > 0){
                
                for(files__c fly:requiredFileList){
                    //system.debug('$$$ Files List are : ' + fly);
                    Estimator = fly.Estimator__c;
                    if(productionFilesMap.containsKey(fly.Production_Order__c)){
                        productionFilesMap.get(fly.Production_Order__c).add(fly);
                        
                        }else{
                        productionFilesMap.put(fly.Production_Order__c,new List<files__c>{fly});
                        
                    }
                    
                }
                
            }
            system.debug('Production Map is :------------------------- ' + productionFilesMap);
            for(production_order__c PrOrder:PoList){
                if(productionFilesMap != null){
                    
                    //requiredFileList = [SELECT Id, Name,FTP_Upload_Status__c,File_Type__c, Status__c FROM Files__c WHERE Production_Order__c =: PrOrder.id AND File_Type__c = 'Image'];
                    system.debug('Before Required File List : ' + requiredFileList);
                    requiredFileList = productionFilesMap.get(PrOrder.id);
                    system.debug('After Required File List : ' + requiredFileList);                    
                    
                    system.debug('Current Order Name : [' + PrOrder.Name+'] Status : [' + PrOrder.Production_Order_Status__c +']'); 
                    system.debug('Approved File List Count : [' + newfileset.size() + '] Completed File List Count :[' + completedFileSet.size()+']');
                    //system.debug('Total File List Count: ' + requiredFileList.size());                    
                    if(requiredFileList != null && requiredFileList.size()>0){
                        system.debug('-------------------------inside completed PO List'+requiredFileList.size());
                        for(files__c f:requiredFileList){
                            if(((f.Status__c == 'Approved' && f.FTP_Upload_Status__c)|| f.Status__c == 'On-Hold')&&f.file_type__c =='Image') {
                                newfileset.add(f);
                            } 
                            if((f.Status__c == 'Approved'|| f.Status__c == 'On-Hold')&&f.file_type__c =='Image'){
                                completedFileSet.add(f);
                            }
                            // If any work in progress file make the order status as WIP
                            
                            if((f.Status__c =='Redo Re-Assigned' || f.Status__c == 'Redo'|| f.Status__c == 'WIP') && f.file_type__c =='Image'){ 
                                wipFileSet.add(f);
                            }
                            
                            //  If any QC in progress file make the order status as QCIP
                            if((f.Status__c =='QC' || f.Status__c == 'QCIP') && f.file_type__c =='Image'){ 
                                qcFileSet.add(f);
                            }
                            
                            //EPMSSF-521 Changes - Start
                            // File Ststus in Estimator Assigned
                            if(f.Status__c == label.EPMS_FileStatus_Estimation_Request && f.file_type__c =='Image'){ 
                                estimationRequestFileSet.add(f);
                            }

                            if(f.Status__c == label.EPMS_Status_Estimator_Assigned && f.file_type__c =='Image'){ 
                                estimatorAssignedFileSet.add(f);
                            }
                            
                            // File Ststus in Awaiting Approval
                            if(f.Status__c == label.EPMS_Status_Awaiting_Approval && f.file_type__c =='Image'){ 
                                awaitingApprovalFileSet.add(f);
                            }

                            // File Ststus in New
                            if(f.Status__c == label.EPMS_FileStatus_New && f.file_type__c =='Image' && TLIncharge == null){ 
                                newfilesetAA.add(f);
                            }
                            //EPMSSF-521 Changes - End
                            
                            // File Ststus in Assigned
                            if(f.Status__c == label.EPMS_FileStatus_Assigned && f.file_type__c =='Image'){ 
                                assignedFileSet.add(f);
                            }                            
                            
                        }
                        
                            system.debug('Assigned Files count : ' + assignedFileSet.size());
                            system.debug('WIP Files count : ' + wipFileSet.size());
                            system.debug('QC Files count : ' + qcFileSet.size());
                            system.debug('$$$ Estimator Assigned Files count : ' + estimatorAssignedFileSet.size());
                            system.debug('$$$ Awaiting Approval Files count : ' + awaitingApprovalFileSet.size());
                            system.debug('$$$ Completed Files count : ' + completedFileSet.size());
                            system.debug('$$$ Uploaded Files count : ' + newfileset.size());
                            system.debug('$$$ requiredFileList Files count : ' + requiredFileList.size());
                        
                        system.debug('----------------------------inside NewFile PO List'+newfileset.size());
                    }
                    if(requiredFileList != null && completedFileSet!=null && requiredFileList.size() == completedFileSet.size()){                       
                        
                        PrOrder.Production_Order_Status__c='Completed';
                        newCompletedPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status [Completed] :' + newCompletedPOSet);                         
                    }
                    
                    
                    if(requiredFileList != null && newfileset!=null && requiredFileList.size() == newfileset.size()){
                        PrOrder.FTP_Upload_Status__c = true;
                        PrOrder.FTP_Upload_Time__c = system.now();
                        PrOrder.Production_Order_Status__c='Uploaded';
                        newPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status [Uploaded] :' + newPOSet); 
                        
                    }
                    
                    // Update order status as WIP if files are in In-progress
                    system.debug('Total QC / QCIP Files List Count: ' + qcFileSet.size()); 
                    if(wipFileSet != null && wipFileSet.size() > 0){

                        PrOrder.Production_Order_Status__c='WIP';
                        workInProgressPOSet.add(PrOrder);
                        system.debug('Inside the PO Order status :' + workInProgressPOSet);
                    //EPMSSF-521 Changes - Start
                    } else if(requiredFileList != null && newfilesetAA!=null && requiredFileList.size() == newfilesetAA.size()){

                        PrOrder.Production_Order_Status__c=label.EPMS_FileStatus_New;
                        newPOsetAA.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status [New] :' + estimatorAssignedPOSet);
                    
                    } else if((requiredFileList != null && estimationRequestFileSet!=null && estimationRequestFileSet.size() > 0)){

                        PrOrder.Production_Order_Status__c=label.EPMS_FileStatus_Estimation_Request;
                        estimationRequestPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status [Estimation Request] :' + estimationRequestPOSet);
                    
                    } else if((requiredFileList != null && estimatorAssignedFileSet!=null && requiredFileList.size() == estimatorAssignedFileSet.size()) ||
                                (requiredFileList != null && estimatorAssignedFileSet!=null && awaitingApprovalFileSet!=null && requiredFileList.size() > 0 && estimatorAssignedFileSet.size() > 0 && awaitingApprovalFileSet.size() > 0)){

                        PrOrder.Production_Order_Status__c=label.EPMS_Status_Estimator_Assigned;
                        //PrOrder.Estimator__c = loginMemberId; // Update PO User as Login User
                        PrOrder.Estimator__c = Estimator;
                        estimatorAssignedPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status [Estimator Assigned] :' + estimatorAssignedPOSet);
                    
                    } else if(requiredFileList != null && awaitingApprovalFileSet!=null && requiredFileList.size() == awaitingApprovalFileSet.size()){

                        PrOrder.Production_Order_Status__c=label.EPMS_Status_Awaiting_Approval;
                        awaitingApprovalPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status [Awaiting Approval] :' + awaitingApprovalPOSet);
                    //EPMSSF-521 Changes - End                    
                    } else if(requiredFileList != null && qcFileSet!=null && requiredFileList.size() == qcFileSet.size()){

                        PrOrder.Production_Order_Status__c='QCIP';
                        workInProgressPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status 1 [QCIP] :' + workInProgressPOSet);
                    } else if(requiredFileList != null && qcFileSet!=null && completedFileSet!= null && qcFileSet.size()>0 && (requiredFileList.size() == (qcFileSet.size() + completedFileSet.size()))){

                        PrOrder.Production_Order_Status__c='QCIP';
                        workInProgressPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status 2 [QCIP] :' + workInProgressPOSet);
                    } else if(requiredFileList != null && qcFileSet!=null && qcFileSet.size() > 0 && qcFileSet.size() < requiredFileList.size()){
                    
                        PrOrder.Production_Order_Status__c='WIP';
                        workInProgressPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status 1 [WIP] :' + workInProgressPOSet);
                    
                    } else if(requiredFileList != null && completedFileSet!=null && completedFileSet.size() > 0 && completedFileSet.size() < requiredFileList.size()){
                    
                        PrOrder.Production_Order_Status__c='WIP';
                        workInProgressPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status 2 [WIP] completedFileSet :' + completedFileSet);
                    
                    } else if(requiredFileList != null && assignedFileSet != null && ((requiredFileList.size() == assignedFileSet.size()) || (assignedFileSet.size() > 0))){

                        PrOrder.Production_Order_Status__c='Assigned';
                        assignedPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status 1 Assigned :' + assignedPOSet);
                       
                    // When one file in assigned status then PO status also changed to Assigned status
                   }  else if(requiredFileList != null && assignedFileSet != null && assignedFileSet.size() > 0){

                        PrOrder.Production_Order_Status__c='Assigned';
                        assignedPOSet.add(PrOrder);
                        system.debug('~~~ Inside the PO Order status 2 Assigned :' + assignedPOSet);
                    
                    }

                }           
                
                newfileset.clear();
                completedFileSet.clear();
                wipFileSet.clear();
                assignedFileSet.clear();
                qcFileSet.clear();
                //EPMSSF-521 Changes - Start
                newfilesetAA.clear();
                estimationRequestFileSet.clear();
                estimatorAssignedFileSet.clear();
                awaitingApprovalFileSet.clear();
                //EPMSSF-521 Changes - End        
                            
            }
            
            if(newPOSet.size()>0 ){
                try{
                    system.debug('*** newPOSet : '+newPOSet);
                    update newPOSet; 
                    
                    }catch(exception e){
                    system.debug('exception------------'+e);
                }
            }
            if(newCompletedPOSet.size()>0 && newPOSet.isEmpty()){
                try{
                    system.debug('*** newCompletedPOSet : '+newCompletedPOSet);
                    update newCompletedPOSet; 
                    
                    }catch(exception e){
                    system.debug('exception------------'+e);
                }
            }
            
            if(workInProgressPOSet != null && workInProgressPOSet.size() > 0){
                try{
                    system.debug('*** workInProgressPOSet : '+workInProgressPOSet);
                    update workInProgressPOSet;
                } catch(DmlException de){
                    system.debug('Exception During Update WIP Status order :' + de.getMessage());
                }
            }
            
            //EPMSSF-521 Changes - Start
            
            
            if(estimationRequestPOSet != null && estimationRequestPOSet.size() > 0){
                try{
                    system.debug('*** estimationRequestPOSet : '+estimationRequestPOSet);
                    update estimationRequestPOSet;
                } catch(DmlException de){
                    system.debug('Exception During Update Estimation Request Status order :' + de.getMessage());
                }
            }
            
            
            
            if(estimatorAssignedPOSet != null && estimatorAssignedPOSet.size() > 0){
                try{
                    system.debug('*** estimatorAssignedPOSet : '+estimatorAssignedPOSet);
                    update estimatorAssignedPOSet;
                } catch(DmlException de){
                    system.debug('Exception During Update Estimator Assigned Status order :' + de.getMessage());
                }
            }

            if(awaitingApprovalPOSet != null && awaitingApprovalPOSet.size() > 0){
                try{
                    system.debug('*** awaitingApprovalPOSet : '+awaitingApprovalPOSet);
                    update awaitingApprovalPOSet;
                } catch(DmlException de){
                    system.debug('Exception During Update Awaiting Approval Status order :' + de.getMessage());
                }
            }
            
            if(newPOsetAA != null && newPOsetAA.size() > 0){
                try{
                    system.debug('*** newPOsetAA : '+newPOsetAA);
                    update newPOsetAA;
                } catch(DmlException de){
                    system.debug('Exception During Update New Status order :' + de.getMessage());
                }
            }            
            //EPMSSF-521 Changes - End
            // When one file in assigned status then PO status also changed to Assigned status 
            if(assignedPOSet != null && assignedPOSet.size() > 0){
                try{
                    system.debug('*** assignedPOSet : '+assignedPOSet);
                    update assignedPOSet;
                } catch(DmlException de){
                    system.debug('Exception During Update Assigned Status order :' + de.getMessage());
                }
            }            
            
            
        }
    //}
    
    }    
    
}