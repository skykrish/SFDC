public class AutoAssign {
                
                /* initilizing properties begins */
                
                public List<String> selectedTeamId{get;set;} //To get the selected team 
                public String selectedShiftId{get;set;}
                public string selectAll{get;set;}
                public string chekboxselection{get;set;}     
                public production_order__c pOrder{get;set;}  //Track selected production order
                public String userCurrentShift {get;set;}    //To store the current shift of the user
                public String selShift{get;set;}              
                public List<Profile> profilelist {get;set;}  //To store the logged in user profile
                public List<string> reqids{get;set;}         //To store the individual ids from the current page url
                
                public set<id> teamids{get;set;}             //to store unique team ids queried through all the memberids 
                public String userCurrentTeam {get;set;}     
                public string userProfileName {get;set;}
                public List<Shift_Assignments__c> shiftassignment= null;   
                public set<id> memberids;                   //to store the memberids from the queried through current shift assignment
                public set<id> tlMemIds;
                public set<id> tlUserIds;
                public set<id> qcUserIds;
                public set<id> qcMemIds;
                public String fileMessage{get;set;}
                public List<SelectOption> shiftOptions{get;set;}
                public List<SelectOption> perPageLimitOptions{get;set;}
                public List<SelectOption> perMemPgLmt{get;set;}
                
                public Integer page_size{get;set;}
                public list<Shift__c> shiftsList=new list<Shift__c>();
                public String ShiftName{get;set;}
                public List<Member__c> MemberList{get;set;}
                PUBLIC set<id> Membersids{get;set;}
                public Boolean Ascending{get;set;}
                public Boolean Descending{get;set;}
                public production_order__c newPOFileCount{get;set;}
                public set<id> WipStatusIds=new set<id>();
                public list<dispMem>  dispList{get;set;}
                
                public set<id> AssignedStatusIds=new set<id>();
                public map<String,AggregateResult> WipIds{get;set;}
                public map<String,AggregateResult> AssignedIds{get;set;}
                public Integer WIPCount{get;set;}
                public Integer AssignedCount{get;set;}
                public Integer z=0;
                public Integer AssignedStatusCount{get;set;}
                //public Integer WipStatusCount{get;set;}
                public Integer j=0;
                
                /* Properties to keep track of pagination  */
                
                private integer pagenumber=1;   //to track the calling method during page traverse.                                                
                private integer counter =0;   //to keep track of offset
                public Integer selectedSize {get;set;}
                public Integer selectedMemSize{get;set;}
                
                public integer currentPageStart{get;set;}//
                public integer currentPageEnd{get;set;}
                    public List<dispMem> newMemList{get;set;}
                    public List<dispMem> MemList{get;set;}
                    public List<dispMem> pageMemList{get;set;}  
                    public string  selctedmems{get;set;}
                    public set<string> selectmemset;
                    
                
                public integer total_size{get;set;} //used to show user the total size of list of rows returned  
                
                public Integer allocatedFilesCount {get; set;}
                //public Integer unAllocatedFilesCount {get; set;}
                //public Integer totalMembers {get; set;}
                public Integer totalFiles {get; set;}
                //public string currentShift{get;set;}
                public Integer currentShiftFirstTime;
                public id loc{get;set;}
                public integer prevPageSize ;
                public Member__c mem{get; set;}
                public string poQc;
                public string poTl;
                
                //for TL and QC Inclusion and exclusion Process
                
                public boolean TLInclude{get;set;}
                public boolean QCInclude{get;set;}
                public boolean TLExclude{get;set;}
                public boolean QCExclude{get;set;}
                public Boolean TLInludeButton{get;set;}
                public Boolean QCInludeButton{get;set;}
                public Boolean TLExludeButton{get;set;}
                public Boolean QCExludeButton{get;set;}
                
                public list<AggregateResult> WipMemberList{get;set;}
                public list<AggregateResult> AssignedMemberList{get;set;}
                public boolean LoadCount{get;set;}
                
                
                /* instantiate services */
                    
                EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();  
                
                /* Instantiate query locator class */
                public EPMS_ProductionOrder_Query_Locator queryloc = new EPMS_ProductionOrder_Query_Locator();
                
                //Modified by udayasri
                
                public List<Member__c> membersList=new list<Member__c>();
                public Set<String> membersNames=new set<String>();
                public set<String> membersInAggregate=new set<String>();
                public set<String> membersInAggregateAssignedAndWIP=new set<String>();
                
                
                public Integer i=0;
                public list<Member__c> MemberswithIds=new List<Member__c>();
                public Member__c MemTL=new Member__c();
                public Member__c MemQC=new Member__c();
                public Integer TLAndQCAssignment;
                public List<String> TLQCExorInlusion{get;set;}
                public string ids{get;set;}
                public Boolean DescRating{get;set;}
                
                public List<Member__c> MembersLisMembersListWithTLAndQC=new List<Member__c>();
                public Map<Id,set<Id>> TeamWithMemberIds=new Map<Id,Set<Id>>();
                
                /* Constructor begins */
                
                public  AutoAssign(ApexPages.StandardController controller) {
                    selectedMemSize = 400;
                    
                    TLInclude=True;
                    QCInclude=False;
                    TLExludeButton=False;
                    QCExludeButton=True;
                    
                    LoadCount=true;
                    DescRating=false;
                    
                    currentShiftFirstTime=0;
                    WipIds=new map<String,AggregateResult>();
                    AssignedIds=new map<String,AggregateResult>();
                   
                    Ascending=True;
                    Descending=False;
                    
                
                        page_size=15;
                        selectedSize = 15;
                        prevPageSize = page_size;
                       
                
                    reqids = new List<string>();
                    Membersids=new set<id>();
                    teamids = new set<id>();
                    shiftassignment = new List<Shift_Assignments__c>();
                    
                    fileList = new List<cFile>();
                    try{
                        mem=[select id,Name,Location_id__c,Current_Shift__c from Member__c where User_Id__c=:UserInfo.getUserId()];
                        id loc=mem.Location_id__c;
                        shiftOptions = new List<SelectOption>();
                        if(loc!=null){
                        shiftsList=[select id,name from Shift__c where Shift_Location__c=:loc];
                        }
                    
                        for(Shift__c Shifts:shiftsList){
                            shiftOptions.add(new SelectOption(Shifts.id,Shifts.Name));
                        } 
                            

                    }catch(Exception e){
                        
                    }
                    
                    perPageLimitOptions=new List<SelectOption>();
                    perPageLimitOptions.add(new SelectOption('15','15'));
                    perPageLimitOptions.add(new SelectOption('30','30'));
                    perPageLimitOptions.add(new SelectOption('60','60'));
                    perPageLimitOptions.add(new SelectOption('120','120'));
                    perPageLimitOptions.add(new SelectOption('240','240')); 

                    perMemPgLmt = new List<SelectOption>();
                     perMemPgLmt.add(new SelectOption('400','ALL'));
                    perMemPgLmt.add(new SelectOption('5','5'));
                    perMemPgLmt.add(new SelectOption('10','10'));
                    perMemPgLmt.add(new SelectOption('20','20'));
                    perMemPgLmt.add(new SelectOption('40','40'));
                    perMemPgLmt.add(new SelectOption('80','80'));
                 


                    //update current  shift
                            Member__c mem=[select id,Name,Location_id__c,Current_Shift__c from Member__c where User_Id__c=:UserInfo.getUserId() limit 1];
                            if(mem != null){
                            loc=mem.Location_id__c;
                            shiftName=mem.Current_Shift__c;
                            
                            if(shiftName!=null){
                                
                                shift__c shiftId=[select id,name from shift__c where name=:shiftName];
                                selectedShiftId=shiftid.id;
                            }else{
                                ApexPages.AddMessage(new ApexPages.message(ApexPages.severity.ERROR,'Assignor should have a shift to proceed'));   
                                
                            }
                            }

                    //



                    
                    /* get the id from the url , seperate the id based on comma */
                    ids = ApexPages.currentPage().getParameters().get('ids');
                    if(ids != null){
                        for(String key:ids.split(',')){
                            reqids.add(key);
                        }
                    }
                    
                    /* get the logged in user profile */
                    try{
                        profilelist = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];

                    }catch(Exception e){
                        System.debug(e);  
                    }
                        
                    if(profilelist != null && profilelist.size() > 0){     
                        userProfileName = profilelist[0].Name;      
                    }       
                    system.debug('Logged User => Profile Name : ' + userProfileName);
                    Shift_Assignments__c shiftInfo = null;
                    
                    if(userProfileName != 'System Administrator' && userProfileName != 'Production Administrator' && userProfileName != 'Country Administrator'){
                        try{
                            Member__c userMemberInfo = fileService.getLoggedMemberInformation();        
                            if(userMemberInfo != null){     
                                shiftInfo = fileService.getLoggedMemberShiftAssignmentInformation(userMemberInfo.Id);      
                                if(shiftInfo != null){      
                                    userCurrentShift = shiftInfo.Shift_Code__c;
                                    system.debug('-----------------------'+userCurrentShift);  
                                    userCurrentTeam = userMemberInfo.Team_Id__c;  
                        
                            }
                            
                                    
                            }
                        } catch(Exception e){
                            system.debug('[ERROR] Exception throws during retrieve the User Shift Information : ' + e.getMessage());
                        }
                        
                    }  
                    if(userCurrentShift != null){       
                        selShift = userCurrentShift;        
                    } 
                    
                    if(selShift != null){
                        shiftassignment = queryloc.getShiftMemberlist(selShift);        
                    }
                    
                    memberids = new Set<Id>();     
                    if(shiftassignment != null && shiftassignment.size() > 0){                
                        for(Shift_Assignments__c memberObj : shiftassignment)
                        {       
                            memberids.add(memberObj.Member__C);        
                        }       
                    }
                    if(memberids != null)
                    {
                        getMembers();
                    }
                    currentPageStart =1;
                    
                  
                
                    
                    /* get the current production order and file count  details  */
                    
                    pOrder = [select id,name,Assignor__c,Production_Order_TAT__c,Production_Order_Instruction__c from production_order__c where id =:reqids limit 1];
                    
                

                    total_size = [select count() from files__C where production_order__c =:pOrder.id and File_Type__c='Image' and Status__c='New'];
                    
                    system.debug('*************************'+pOrder);

                      if(selectedSize < total_size){
                            currentPageEnd = currentPageStart + page_size-1;
                    }else{
                        currentPageEnd = total_size;
                    }
                    
                    if(pOrder != null) {            
                        getFiles();
                    }       
                }
                
                public void updatePOorder()
                {
                    try{
                    Member__c userMemberInfo = fileService.getLoggedMemberInformation();  

                    pOrder.Assignor__c = userMemberInfo.id;
                    update pOrder;
                    system.debug('-----------pOrder--------------'+pOrder);
                    }catch(exception e){

                    }

                }

                /* get the teams of all the members from memberids */
                public list<selectoption> getListOfTeams() { 
               
                    teamids.clear();
                    List<Team__c > teamList = new List<Team__c>();
                    
                    Member__c mem=[select id,Name,Location_id__c,Current_Shift__c from Member__c where User_Id__c=:UserInfo.getUserId() limit 1];
                        if(mem != null){
                            loc=mem.Location_id__c;
                            shiftName=mem.Current_Shift__c;
                            
                            if(shiftName!=null){
                                
                                shift__c shiftId=[select id,name from shift__c where name=:shiftName];
                                selectedShiftId=shiftid.id;
                            }else{
                                ApexPages.AddMessage(new ApexPages.message(ApexPages.severity.ERROR,'Assignor should have a shift to proceed'));   
                                
                            }
                            
                            //To get all TeamIds which ae related to the current shift and the Location
                            
                            MemberList=new list<Member__c>();
                            MemberList=[select id,name,Team_Id__c from Member__c where Current_Shift__c=:shiftName and Location_id__c=:loc and Status__c=:'Active'];
                            for(Member__c mem2:MemberList){
                                
                                teamids.add(mem2.Team_Id__c); 
                                
                            }
                        }else{
                            //TBD
                        }

                    
                    system.debug('*****************************'+teamids);
                
                    if(shiftName!=null) {
                        if(teamids != null) {
                            teamList = [select id,name from Team__c where id =: teamids];
                        }
                    }
                    List<SelectOption> options = new List<SelectOption>(); 
                    
                    options.add(new selectOption('All','All'));
                    for(Team__c j:teamList) {
                        options.add(new selectOption(j.id,j.name));
                    }
                    return options;
                }
                
                /* This method is used  to retrive the members based on selected teams */
                public void ListofMembers() {
                       Ascending=True;
                       Descending=False;
                    system.debug('---enterintolistofmembers----');
                    system.debug('********selectedTeamId*********************'+selectedTeamId);
                    getMembers();  
                }
                
                //modified bu udayasri
                
                public void RefreshingPageNumbers() {
                      total_size = [select count() from files__C where production_order__c =:pOrder.id and File_Type__c='Image' and Status__c='New'];
                     page_size=selectedSize;
                        prevPageSize = page_size;
                        pagenumber=1;
                        counter=0;
                        currentPageStart=1;
                         if(selectedSize < total_size){
                            currentPageEnd = currentPageStart + page_size-1;
                    }else{
                        currentPageEnd = total_size;
                    }

                  getFiles();
                    system.debug('--------counter------------'+counter);        
                }

            
                
                /* This method is used to retrive next set of files for the next page based on the offset counter */
                
                public void nextPage() {
                   
                  
                    pagenumber++;
                    counter += page_size;
                    currentPageStart = counter+1;

                if( currentPageStart+selectedSize < total_size){
                            currentPageEnd = currentPageStart + page_size-1;
                    }else{
                        currentPageEnd = total_size;
                    }
                
                    system.debug('--------counter------------'+counter);
                    getFiles();
                    
                }
                
                /* This method is used to retrive next set of files for the next page based on the offset counter */
                
                public void prevPage() {
                    pagenumber--;
                    counter -=  prevPageSize;
                    
                    currentPageStart = counter+1;
                    if(selectedSize < total_size){
                            currentPageEnd = currentPageStart + page_size-1;
                    }else{
                        currentPageEnd = total_size;
                    }
                
                    system.debug('--------counter------------'+counter);
                    getFiles();
                    
                }
                
                /* get the total pages to display */
                public Integer getTotalPages() {
                    
                    if (math.mod(total_size, page_size) > 0) {
                        return total_size/page_size + 1;  
                    } else {            
                        return (total_size/page_size);            
                    }
                }
                
                public Boolean getDisabledPrevious() {   /* This will disable the previous and beginning button */
                    
                    if(counter>0)        
                        return false;
                    else
                        return true;        
                }
                
                public Boolean getDisabledNext() {        /* This will disable the next and end buttons */
                    if (counter + page_size < total_size)
                        
                        return false;
                    else 
                        return true;
                }
                
                /* Collection of the class/wrapper objects cFile */
                public List<cFile> fileList {get; set;}
                
                /* This method uses a simple SOQL query to return a List of Files and feed them to a wrapper object/class. */
                public List<cFile> getFiles() {
                    system.debug('--------counter------------'+counter);
                    system.debug('------page_size------'+page_size);
                    total_size = [select count() from files__C where production_order__c =:pOrder.id and File_Type__c='Image' and Status__c='New'];
                    fileList.clear();
                    
                    for(Files__c f: [select Id, Name,Thumbnail_Display__c,File_Server_Host__c ,File_Thumbnail_URL__c,Instruction__c,Order_Instructions__c,Job_List__c from files__C  where production_order__c =:pOrder.id and File_Type__c='Image' and Status__c='New' Order By CreatedDate limit :page_size offset :counter]) {
                        // As each contact is processed we create a new cMember object and add it to the contactList
                        fileList.add(new cFile(f));
                        System.debug('-----------------Thumbnail_Display__c-------------'+f.File_Server_Host__c);
                        System.debug('-----------------Thumbnail_Display__c-------------'+f.File_Thumbnail_URL__c);
                    }
                    
                    return fileList;
                }

                public String[] convertStrToList(string str) {
                     String[] listToReturn = new List<String>();
                     if(String.isNotBlank(str)) {
                          for(String eachStr : str.split(',')) {
                          listToReturn.add(eachStr);
                      }
                     }
                    return listToReturn;
                }

                
                /// process the selected files with selected members
                public void processSelectedFiles() {
                    boolean errorFlag = false; 
                    TLAndQCAssignment=0;
                    string tlstring;
                    string qcstring;
                    Map<String,String> TLMap = new Map<String,String>();
                    Map<String,String> QCMap = new Map<String,String>();
                    List<Member__c> TLList = new List<Member__c>(); 
                    List<Member__c> QCList = new List<Member__c>();
                   
                    List<string> selectmemList;
                    List<id> memids = new List<id>();
                    selectmemset=new set<string>();


                    tlMemIds = new set<id>();
                    qcMemIds=new set<id>();
                    qcUserIds=new set<id>();
                    tlUserIds = new set<id>();
                    selectmemList = new List<String>();
                    
                    selectmemList = convertStrToList(selctedmems);
                    selectmemset.addall(selectmemList);

                     System.debug('-----------selctedmems----------------'+selectmemList);
                    
                    /* To hold selected files */
                    List<Files__c> selectedFiles = new List<Files__c>(); 
                    //List<dispMem> forselctmems = new List<dispMem>();
                    
                    /* To hold selected members  */
                    List<dispMem> selectedMembers = new List<dispMem>();
                    System.debug('-----------selectedMembers----------------'+selectedMembers);

                    List<member__c> selctmems = new List<member__c>();
                    selctmems = [select id,Name,team_id__c,Designation__c from member__c where id=:selectmemList];
                    System.debug('----------------selctmems--------------'+selctmems);

                    for(member__c memb:selctmems){
                        selectedMembers.add(new dispMem(memb.id,memb.name,memb.team_id__c,memb.Designation__c,'groupA',0,0,LoadCount));
                    }

                    System.debug('----------------forselctmems--------------'+selectedMembers);



                    
                    /* We will cycle through our list of cFile and will check to see if the selected property is set to true, if it is we add the file to the selectedfiles list */
                    for(cFile cfile: fileList) {
                        if(cfile.selected == true) {
                            selectedFiles.add(cfile.file);
                        }
                    } 

                    
                    
                    for(dispMem mem:selectedMembers){
                            memids.add(mem.memid);
                    }
                    System.debug('**********************************************'+JSON.serialize(dispList));
                    system.debug('***********selectedfiles**********************'+selectedFiles);
                    system.debug('***********Members**********************'+selectedMembers);
                    
                    
                    if(selectedMembers.size()>0){        
                        
                        //system.debug('-----selectedMembersid-----'+selectedMembers[0].memid);
                        
                
                        
                        if(memids!=null) {
                            
                                        
                            
                            try{
            
                                
                                
                                TLList = [select id,Name,Team_Id__c,Designation__c from Member__c where Designation__c=:'Team Leader'];
                                QCList = [select id,Name,Team_Id__c,Designation__c from Member__c where Designation__c=:'Quality Control']; 
                                
                                
                                for(Member__c tlMem : TLList) {
                                    TLMap.put(tlMem.Team_Id__c,tlMem.Id);
                                }
                                
                                for(Member__c qcMem : QCList) {
                                    QCMap.put(qcMem.Team_Id__c,qcMem.Id);
                                }
                                
                                
                            }catch(exception e){
                            } 
                        }
                        
                        if(selectedFiles.size()>0 && selectedMembers.size()>0 && selectedFiles.size()>=selectedMembers.size())
                        {
                            totalFiles = selectedFiles.size();
                            getEqualFileShare(selectedFiles.size(),selectedMembers.size());
                            system.debug('selectedFiles.size = ' + selectedFiles.size() + ', selectedMembers.size = ' + selectedMembers.size());
                            
                            integer assignedFileCount = 0;
                            for (Integer j=0; j<selectedMembers.size();j++) {
                            
                                for (Integer i =0; i < allocatedFilesCount; i++) {
                                    system.debug('**************** assignedFileCount : ' + assignedFileCount + ' , totalFiles : ' + totalFiles);
                                    if (assignedFileCount < totalFiles) {               
                                        selectedFiles.get(assignedFileCount).Member__c = selectedMembers[j].memid;

                                        system.debug('**************** assignedFileCount : ' + assignedFileCount);
                                    // system.debug('****************   Member Id : ' + member.mid + ' ; member name : ' + member.name + ' ; selectedFiles.get(assignedFileCount).Member__c : ' + selectedFiles.get(assignedFileCount).Member__c);
                                        selectedFiles.get(assignedFileCount).Status__c = Label.EPMS_FileStatus_Assigned;
                                        selectedFiles.get(assignedFileCount).File_Assignment_Time__c = system.now();

                                        system.debug('----------------------------selectedMembers.get(j).teamId------------------'+selectedMembers.get(j).teamId);

                                        selectedFiles.get(assignedFileCount).TLInCharge__c = TLMap.get(selectedMembers.get(j).teamId);
                                        selectedFiles.get(assignedFileCount).QCIncharge__c = QCMap.get(selectedMembers.get(j).teamId);
                                        poTl = TLMap.get(selectedMembers.get(j).teamId);
                                        poQc = QCMap.get(selectedMembers.get(j).teamId);
                                        tlMemIds.add(poTl);
                                        qcMemIds.add(poQc);


                                        assignedFileCount++;
                                    
                                    }
                                }
                            }
                            integer remainingfile = totalFiles - assignedFileCount;
                            system.debug('$$$$$$$$$$ + remainingfile : ' + remainingfile);
                            if (remainingfile > 0){
                            
                                //for (cMember member : selectedMembers) {
                                //for (Integer i =0; i < remainingfile; i++) {
                                for (Integer i =0; i < remainingfile; i++) {
                                    
                                    for (Integer j=0; j<selectedMembers.size();j++) { 
                                    
                                                        
                                        system.debug('**************** assignedFileCount : ' + assignedFileCount + '--- Total Files : ' + totalFiles);
                                        if ((assignedFileCount) < totalFiles) {
                                    

                                            selectedFiles.get(assignedFileCount).Member__c =  selectedMembers[j].memid;
                                            system.debug('**************** assignedFileCount : ' + assignedFileCount);
                                            //system.debug('****************   Member Id : ' + member.mid + ' ; member name : ' + member.name + ' ; selectedFiles.get(assignedFileCount).Member__c : ' + selectedFiles.get(assignedFileCount).Member__c);
                                            selectedFiles.get(assignedFileCount).Status__c = Label.EPMS_FileStatus_Assigned;
                                            selectedFiles.get(assignedFileCount).File_Assignment_Time__c = system.now();
                                            
                                    
                                            system.debug('----------------------------selectedMembers.get(j).teamId------------------'+selectedMembers.get(j).teamId);

                                        selectedFiles.get(assignedFileCount).TLInCharge__c = TLMap.get(selectedMembers.get(j).teamId);
                                        selectedFiles.get(assignedFileCount).QCIncharge__c = QCMap.get(selectedMembers.get(j).teamId);    

                                            system.debug('****** TLMap : ' + TLMap.get(selectedMembers.get(j).teamId));
                                            system.debug('****** QCMap : ' + QCMap.get(selectedMembers.get(j).teamId));
                                        poTl = TLMap.get(selectedMembers.get(j).teamId);
                                        poQc = QCMap.get(selectedMembers.get(j).teamId);
                                         tlMemIds.add(poTl);
                                         qcMemIds.add(poQc);
                                            assignedFileCount++;
                                        
                                        
                                            
                                        }
                                    }
                                }
                            }
                        

                              System.debug('tlmemids------------------------'+tlMemIds);           
                           
                        }
                       
                        if(selectedFiles.size()==0){
                            
                            fileMessage ='Please select the Files and Members to assign or NO files available';
                            
                        }
                        try {
                         
                           
                            UPDATE selectedFiles;
                             fileMessage = selectedFiles.size() +' files have been assigned to '+selectedMembers.size()+' members successfully';
                               system.debug('****** selectedFiles after Updates : ' + selectedFiles);
                            total_size = [select count() from files__C where production_order__c =:pOrder.id and File_Type__c='Image' and Status__c='New'];
                            newPOFileCount = [select id,TL_Incharge__c,QC_Incharge__c,TLQCusers__c,TLQCusers1__c,TLuseridR1__c,TLuseridR2__c,qcId__c,qcid1__c,QCidr1__c,QCidr2__c,New_Files_Count__c from production_order__c where id=:pOrder.id];
                             for(Member__c users: [select User_Id__c from member__c where id=:tlMemIds]){
                            tlUserIds.add(users.User_Id__c);
                             }
                             for(Member__c users: [select User_Id__c from member__c where id=:qcMemIds]){
                                 qcUserIds.add(users.User_Id__c);
                             }
                              system.debug('-----------tlUserIds---------------'+tlUserIds);

                        for(id  usrids:tlUserIds){
                            if(newPOFileCount.TLQCusers__c == null){
                                newPOFileCount.TLQCusers__c = usrids;
                                system.debug('-----------newPOFileCount.TLQCusers__c---------------'+newPOFileCount.TLQCusers__c);
                            }else{
                                     tlstring=newPOFileCount.TLQCusers__c;
                                     
                                     if(tlstring.length()<236){
                                     if(!(tlstring.contains(usrids))) {
                                     newPOFileCount.TLQCusers__c += ','+usrids;
                                     }
                                     }
                                     
                                     
                                      else if(newPOFileCount.TLQCusers1__c == null){
                                       if(!(tlstring.contains(usrids))) {
                                newPOFileCount.TLQCusers1__c = usrids;
                                }
                                     }else{
                                     tlstring +=','+newPOFileCount.TLQCusers1__c;
                                     if(tlstring.length()>236){
                                     if(!(tlstring.contains(usrids))) {
                                     newPOFileCount.TLQCusers1__c += ','+usrids;
                                     }
                                     
                                     
                            }
                            }
                         
                         }
                    }
                                
                     /*    for(id  qcusrid:qcUserIds){
                            if(qcstring == null){
                                qcstring = qcusrid;
                            }else{
                                     qcstring += ','+qcusrid;
                            }
                            
                        }  
                        
                        
                            if(newPOFileCount.qcId__c!=null){
                        newPOFileCount.qcId__c +=','+ tlstring;
                            }
                            else{
                                newPOFileCount.qcId__c +=tlstring;  
                            }
                            
                            if( newPOFileCount.qcId__c!=null){
                        newPOFileCount.qcId__c +=','+ qcstring;
                            }
                            else{
                                newPOFileCount.qcId__c +=qcstring;
                            }
                            
                            
                            
                            system.debug('------length of the field----'+QCfieldLength.length());

                       
                        update newPOFileCount; */
                        system.debug('-------------newPOFileCount------------------'+newPOFileCount);
                        if(newPOFileCount.New_Files_Count__c == 0){
                            


                                newPOFileCount.TL_Incharge__c = poTl;
                                newPOFileCount.QC_Incharge__c = poQc;
                                update newPOFileCount;
                                system.debug('-------------newPOFileCount------------------'+newPOFileCount);

                        }   
                        
                        
                        for(id  usrid:qcUserIds){
                            if(newPOFileCount.qcid__c == null){
                                newPOFileCount.qcid__c = usrid;
                            }else{
                                     tlstring=newPOFileCount.qcid__c;
                                     if(tlstring.length()<236){
                                     if(!(tlstring.contains(usrid))) {
                                     newPOFileCount.qcid__c += ','+usrid;
                                     }
                                     }
                                     
                                     
                                      else if(newPOFileCount.qcid1__c == null){
                                      if(!(tlstring.contains(usrid))) {
                                newPOFileCount.qcid1__c = usrid;
                                }
                                     }else{
                                     tlstring +=','+newPOFileCount.qcid1__c;
                                      if(!(tlstring.contains(usrid))) {
                                     if(tlstring.length()>236){
                                     newPOFileCount.qcid1__c += ','+usrid;
                                     }
                                     }
                                     }
                                     
                            
                            
                         }
                    }
                    
                    newPOFileCount.TLuseridR1__c=newPOFileCount.TLQCusers__c;
                    newPOFileCount.TLuseridR2__c=newPOFileCount.TLQCusers1__c;
                    newPOFileCount.QCidr1__c=newPOFileCount.qcid__c;
                    newPOFileCount.QCidr2__c=newPOFileCount.qcid1__c;
                    
                    
                    update newPOFileCount;
                   
                      

                  

                        }catch(DMLException me) {
                            System.debug('---------------me---------------'+me);
                            ApexPages.AddMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_Files_Assign_Error)); 
                             fileMessage ='Failed to update, Try Again';

                        }
                        
                    } else {
                        
                        fileMessage ='Please select the Files and Members to assign or NO files available';
                        
                    }
                      
                      
                      
                }
                
                public void ShiftAssign() {
                        Shift_Assignments__c shiftInfo = null;
                    
                    
                    try{
                        Member__c mem=[select id,Name,Location_id__c,Current_Shift__c from Member__c where User_Id__c=:UserInfo.getUserId()];
                        id loc=mem.Location_id__c;
                        
                        
                        system.debug('------selectedShiftId-----'+selectedShiftId);
                        
                        Shift__c Shift=[select id,name from Shift__c where id=:selectedShiftId];
                        
                        ShiftName=Shift.name;
                        mem.Current_Shift__c=ShiftName;
                        update mem;
                        system.debug('----shiftname----'+ShiftName);

                
            
                    if(selShift != null){
                        shiftassignment = queryloc.getShiftMemberlist(ShiftName);        
                    }

                    
                    memberids = new Set<Id>();     
                    if(shiftassignment != null && shiftassignment.size() > 0){                
                        for(Shift_Assignments__c memberObj : shiftassignment)
                        {       
                            memberids.add(memberObj.Member__C);        
                        }       
                    }
                getListOfTeams();
 
                    system.debug('get list of teams');
                        
                    }catch(exception e){
                        
                    }
                }
                
             
                /*   Collection of the  class/wrapper objects cMember  */
            
                public list<dispMem> reversedsort{get;set;}
                //MemberList = null;
                List<id> memids = new List<id>();
                           
                
                /*  This method uses a simple SOQL query to return a List of Members */
                public List<dispMem> getMembers() {
                
                TLQCExorInlusion=new List<String>();
                TLQCExorInlusion.clear();
                if(TLInclude==True && QCInclude==True){
                       TLQCExorInlusion.add('Team Leader');
                        TLQCExorInlusion.add('Quality Control');
                        TLQCExorInlusion.add(Label.EPMS_MEMBER_DESIG_OPERATOR_PS);
                        }
                        
                       if(TLInclude==False && QCInclude==False){
                        TLQCExorInlusion.add(Label.EPMS_MEMBER_DESIG_OPERATOR_PS);
                        }
                        
                       if(TLInclude==True && QCInclude==False){
                          TLQCExorInlusion.add('Team Leader');
                        TLQCExorInlusion.add(Label.EPMS_MEMBER_DESIG_OPERATOR_PS);
                        }
                         
                       if(TLInclude==False && QCInclude==True){
                        TLQCExorInlusion.add('Quality Control');
                        TLQCExorInlusion.add(Label.EPMS_MEMBER_DESIG_OPERATOR_PS);
                        }
                         
                        
                
                    newMemList = new List<dispMem>();
                
                    reversedsort=new list<dispMem>();
                    dispList = new list<dispMem>();

                
                    reversedsort.clear();
                    newMemList.clear();
                    dispList.clear();

                    system.debug('-----selectedTeamId------'+selectedTeamId);

                //  Member Selection for the particular Team
                    MemberList = null;
                    MemberList = new List<member__c>();
                    String shiftName=null;
                    
                    Member__c mems=[select id,Name,Location_id__c,Team_Id__c,Current_Shift__c from Member__c where User_Id__c=:UserInfo.getUserId() limit 1];
                            if(mems != null){
                                loc=mems.Location_id__c;
                                shiftName=mems.Current_Shift__c;
                            }




                    if(selectedTeamId == null || selectedTeamId.isEmpty() || selectedTeamId[0] == 'All' ){

                
                        
                        MemberList=[select id,name,Team_Id__c,Performance_Rating__r.Name,Designation__c from Member__c where Current_Shift__c=:shiftName and Designation__c =:TLQCExorInlusion and Status__c=:'Active' and Todays_Attendance__c='P'];
                        
  
                        
                        system.debug('------------selectedshiftName---------------'+shiftName);
                    
                        system.debug('------------MemberList---------------'+MemberList);
                        for(member__C mem : MemberList){
                            string memname =mem.name;
                            string designation =mem.Designation__c;
                            string temid = mem.Team_Id__c;
                            string rating=mem.Performance_Rating__r.Name;

                            dispList.add(new dispMem(mem.id,memname,temid,designation,rating,0,0,LoadCount));
                            system.debug('------------mem.name,mem.Designation---------------'+mem.name+'------'+mem.Designation__c);

                        }

                        system.debug('------------dispList---------------'+dispList);

                    }else{
      
                       
                        MemberList=[select id,name,Team_Id__c,Performance_Rating__r.Name,Designation__c from Member__c where Team_Id__c=:selectedTeamId and Status__c=:'Active' and Designation__c =:TLQCExorInlusion and Todays_Attendance__c='P'];
                        
                        
                        for(member__C mem : MemberList){
                            string memname =mem.name;
                            string designation =mem.Designation__c;
                            string temid = mem.Team_Id__c;
                            string rating=mem.Performance_Rating__r.Name;

                            dispList.add(new dispMem(mem.id,memname,temid,designation,rating,0,0,LoadCount));
                            system.debug('------------mem.name,mem.Designation---------------'+mem.name+'------'+mem.Designation__c);

                        }

                }
                List<id> membids = new List<id>();
                for(integer i=0; i < MemberList.size(); i++){
                        membids.add(MemberList[i].id);
                }

                /////////////////////
                
                
                     WipMemberList=[select  Member__c mId,Member__r.name mName ,Member__r.Team_Id__c mTeam,Member__r.Designation__c mDsgn,count(id) total from Files__c where member__C=: membids and Member__r.Designation__c =:TLQCExorInlusion and  status__c = 'WIP' and File_Type__c='Image' and Member__r.Todays_Attendance__c='P'  group by Member__c, Member__r.name ,Member__r.Team_Id__c,Member__r.Designation__c];
                                                      




                        for(AggregateResult WipStatus:WipMemberList){   
                    for(dispMem dip:dispList){
                        if(dip.memid == (string) WipStatus.get('mId')){
                            dip.WIPStatusCount = (Integer)WipStatus.get('total');
                            
                        }

                    }
                        
            
                        
                    }
                    system.debug('-----wipsize---'+WipStatusIds.size());
                    
                   
                    AssignedMemberList=[select  Member__c mId,Member__r.name mName ,Member__r.Team_Id__c mTeam, Member__r.Designation__c mDsgn,count(id) total from Files__c where member__C=: membids  and Member__r.Designation__c =:TLQCExorInlusion and status__c = 'Assigned' and File_Type__c='Image'  and Member__r.Todays_Attendance__c='P'  group by Member__c, Member__r.name ,Member__r.Team_Id__c,Member__r.Designation__c];
                     
                     

                       for(AggregateResult AssignedStatus:AssignedMemberList){
                     
                        for(dispMem dip:dispList){
                            if(dip.memid == (string) AssignedStatus.get('mId')){
                                system.debug(dip.WIPStatusCount);
                            dip.AssignedStatusCount = (Integer)AssignedStatus.get('total');
                            dip.WIPStatusCount =  dip.WIPStatusCount;
                            
                        }

                    }
                        
                    } 

                    dispList.sort();



                    
            
                ////////////////

                /* for(member__c mem:MemberList){
                    memids.add(mem.id);

                } */

    system.debug('------------------selectedMemSize----------'+selectedMemSize);

                    newMemList.clear();
                
                    if(selectedMemSize==null || selectedMemSize ==400){
                    
                    newMemList.addAll(dispList);
                    
                    }
                    else{
                    
                    if(selectedMemSize < dispList.size()){
                        for(Integer i=0; i<selectedMemSize;i++){
                        
                        newMemList.add(dispList[i]);
                        System.debug(newMemList);
                    }

                    }else{
                        for(Integer i=0; i<dispList.size();i++){
                        
                        newMemList.add(dispList[i]);
                        System.debug(newMemList);
                        }

                    }
                    }

    
                
                    for(Integer i = newMemList.size() - 1; i >= 0; i--){
                        reversedsort.add(newMemList[i]);
                        
                    }
                    newMemList.sort();
                    system.debug('------------------newMemList----------'+newMemList.size());
                    
                    if(Descending == true || DescRating == true){
                    
                        return reversedsort;
                        
                    }
                    
                    else{
                        
                        return newMemList;
                    }
                                

                }
                
                
                public void AscendingRating(){
                    LoadCount=False;
                    DescRating=false;
                    Descending=false;

                }
                
                public void DescendingRating(){
                    LoadCount=False;
                    DescRating=true;
                    Descending=false;

                }
                
                
                
                public void Ascending(){
                    LoadCount=true;
                    Ascending=True;
                    Descending=False;
                    DescRating=false;

                }
                
                public void Descending(){
                    LoadCount=true;
                    Ascending=False;
                    DescRating=false;
                    Descending=True;
                }
                
                public void TLInclude(){  
                    if(TLInclude == True){
                            TLInclude=false;
                    }else{
                          TLInclude=True;
                    }     
                getmembers(); 
                }
                
                public void QCInclude(){ 
                system.debug('-----QCExlude------');
                    if(QCInclude == True){
                            QCInclude=false;
                    }else{
                          QCInclude=True;
                    }    
                getmembers();
                }
                
                
                /* Wrapper calss for to structure files */
                public class cFile {
                    public Files__c file {get; set;}
                    public Boolean selected {get; set;}
                    public string thumbNailUri{get;set;}
                     
                    
                    //This is the contructor method. When we create a new cFile object we pass a Contact that is set to the con property. We also set the selected value to false
                    public cFile(Files__c  f) {
                        file = f;      
                        thumbNailUri =(String)f.get('Thumbnail_Display__c');

                        selected = false;
                    }
                }



                
                public void getEqualFileShare(Integer totalFiles, Integer totalMembers){
                    
                    allocatedFilesCount = totalFiles / totalMembers;
                    //balanceFile = totalFiles % totalArtist
                    //unAllocatedFilesCount = math.mod(totalFiles, totalMembers);   
                } 


                    public class dispMem implements Comparable{
                        public id memid{get;set;}
                        public string teamId{get;set;}
                        public string name {get;set;}
                        public string Designation {get;set;}
                        public Boolean selected {get; set;}
                        public String rating{get;set;}
                        public Boolean LoadCount{get;set;}
                        
                            public integer AssignedStatusCount {get;set;}
                            public integer  WIPStatusCount{get;set;}

                            public  dispMem( id memlistid,string Name ,string teamid ,string designation,string rating,Integer WIPCount,Integer AssignedCount,Boolean LoadCount){
                                this.memid = memlistid;
                                    this.name = Name;
                                    this.teamId = teamid;
                                    this.Designation = designation;
                                    this.WIPStatusCount = WIPCount;
                                    this.AssignedStatusCount = AssignedCount;
                                    this.rating=rating;
                                    this.selected =false;
                                    this.LoadCount=LoadCount;

                            }

                        public Integer compareTo(Object compareTo) {
                        dispMem compareToEventTask = (dispMem)compareTo;
                        if(LoadCount){
                        if (AssignedStatusCount == compareToEventTask.AssignedStatusCount ) {
                            return 0;
                        }          
                        if (AssignedStatusCount > compareToEventTask.AssignedStatusCount ) {
                            return 1;
                        }          
                        return -1;   
                          } 

                     else{
                        if (rating == compareToEventTask.rating ) {
                            return 0;
                        }          
                        if (rating > compareToEventTask.rating ) {
                            return 1;
                        }          
                        return -1;   
                          }                           
                    }  

                        
                    
                            
                    }   
                
            }