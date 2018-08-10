/**********************************************************************************
*   Class               :       EPMS_ShowPerformance                              *
*   Created Date        :       04/05/2016                                        *
*   Description         :       Controller to acheive performance report(Members) *
**********************************************************************************/
public with sharing class EPMS_ShowPerformance {
    public Files__c fileInfo {get;set;}
    public String selectedLocId {set;get;}
    public String  selectedOrderIDId{set;get;}
    public string shiftCode{set;get;}
    public string selectedShiftName{set;get;}
    public string selectedTeamName{set;get;} 
    public string orderName{set;get;}
    public id teamId{set;get;}
    public List<Team__c> teamNames{set;get;}
    public List<Shift__c> shifts{set;get;}
    public List<Member__c> memberList{set;get;}
    public transient List<Bean> FileList{get;set;}
    public transient List<Bean2> FileList2{get;set;}
    public Integer shiftWiseTotalFile {set;get;}
    public dateTime fromDate{set;get;}
    public dateTime ToDate{set;get;}
    public List<SelectOption> LocOptionList;
    public List<String> filecategoryHeader {set;get;}
    public List<SelectOption> shiftOptionList;
    public integer totalShiftFileCount{get;set;}
    EPMS_ProductionOrderService POService = new EPMS_ProductionOrderService();
    public List<PieWedgeData> pieChartList {set;get;}
    
    public EPMS_ShowPerformance(){
        fileInfo = new Files__c();
        selectedShiftName=null;
        selectedTeamName=null;
        FileList = new List<Bean>();
        FileList2 = new List<Bean2>();
        pieChartList = new List<PieWedgeData>();
        filecategoryHeader = new List<String>();
        orderName ='';
    }
    
    
    public List<SelectOption> getListOfLocations(){
        List<Location__c> locations = POService.getLocation();
        LocOptionList = new List<SelectOption>();
        LocOptionList.add(new SelectOption('' ,'---Select---'));
        for(Location__c L : locations){
            LocOptionList.add(new SelectOption(L.Id , L.Name));
        }
       return LocOptionList;
    }
    
    public void getOrderDetails(){
    
       if(selectedLocId == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select the Location'));
            return;
        }
        system.debug('entered to getOrder Detail'+orderName);
        Production_Order__c Order = new Production_Order__c();
        orderName = orderName.trim();
        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
        Matcher orderMatch = isnumbers.matcher(orderName);
        
        if(orderName!='' && orderName.length()>0&&orderMatch.Matches()){
            try{
                Order = [select id,name from Production_Order__c where name =:orderName];
            }catch(exception e){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Production Order NotFound'));
                system.debug('#############################'+e);
            }
          
            system.debug('-----------------orderDetails----------'+Order);
        } else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'please enter a valid order number'));
        }
        
        if(Order !=null){
            selectedOrderIDId = Order.id;
            system.debug('---------------orderId----------'+selectedOrderIDId);
            locationListOfMembers();    
        }
    }
    
    public List<SelectOption> getListOfOrders(){
        //List<Production_Order__c> Orders = [select name from Production_Order__c where Mbo_Location__c =:selectedLocId And  (Production_Order_Status__c ='Completed' OR Production_Order_Status__c ='Uploaded')];
        List<Production_Order__c> Orders =[select name from Production_Order__c where Mbo_Location__c =:selectedLocId And  (Production_Order_Status__c ='Completed' OR Production_Order_Status__c ='Uploaded') order by createddate desc limit 900];
        List<SelectOption> pOrderList = new List<SelectOption>();
        pOrderList.add(new SelectOption('' ,'---Select---'));
        for(Production_Order__c  O : Orders){
            pOrderList.add(new SelectOption(O.Id , O.Name));
        }
       return pOrderList;
    }
    
    
    public void  ListOfShifts(){
       teamNames = null; 
       if(!String.isEmpty(orderName)){
        orderName = '';
        selectedOrderIDId=null;
       }
       
       selectedShiftName=null;
       selectedTeamName=null;
        FileList =  new List<Bean>();
        pieChartList = new List<PieWedgeData>();
        if(selectedLocId!=''){
            shifts = [select id,name from shift__c where Shift_Location__c=:selectedLocId];
        }else{
           shifts = null; 
        }
        locationListOfMembers();
        
    }
    
    
     
    public void  ListOfTeams(){
        
        List<AggregateResult> teams;
        List<string> teamList = new List<String>();
        pieChartList = new List<PieWedgeData>();
        teamNames = null;
        FileList =  new List<Bean>();
        selectedTeamName = null;
        Shift__c shiftInfo = null;
        if(shifts != null && !string.isBlank(shiftCode)){
            shiftInfo = [SELECT Name FROM Shift__c WHERE Id =: shiftCode LIMIT 1];
            if(shiftInfo != null){
                selectedShiftName = shiftInfo.Name;
            }
            
            teams = [SELECT Team_Assignment_Id__c team FROM Shift_Assignments__c WHERE Shift_Code__c =:shiftCode and Team_Assignment_Id__c != null and Shift_Assigned__c = true group by 
            Team_Assignment_Id__c];

            if(teams.size()>0){
                for(AggregateResult ar:teams){
                    teamList.add((string)(ar.get('team')));
                }
                teamNames = [select id,name from Team__c where name=:teamList];

            }

        }else{
           teamNames = null; 
        }
        shiftListOfMembers();
    }

    
    public void teamListOfMembers(){
        List<id> memberIds = new  List<id>();
        FileList = new List<Bean>();
        FileList2 = new List<Bean2>();
        Map<string,Map<string,integer>>memberfilecategory = new  Map<string,Map<string,integer>>();
        pieChartList = new List<PieWedgeData>();
        List<AggregateResult> files = new  List<AggregateResult>();
        List<AggregateResult> filesOptional = new  List<AggregateResult>();
        Team__c teamInfo = null;
        if(teamNames != null && !string.isBlank(teamId)){
            teamInfo = [SELECT Name FROM Team__c WHERE Id =: teamId LIMIT 1];
            if(teamInfo != null){
                selectedTeamName = teamInfo.Name;
            }
            memberList = [select id,name,Emp_ID__c from Member__c where Team_Id__c=:teamId  and status__C='Active'];     
        }else{
            memberList = null;
        }
        totalShiftFileCount = 0;
        Map<Id, String> memberInfoMap = new Map<Id, String>();
        if(memberList != null && memberList.size()>0){
            for(Member__c m:memberList){
                memberIds.add(m.id);
                memberInfoMap.put(m.id,m.Name);
            }
           
            system.debug('------------------Entered into files with out date');
            files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c = 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
            
            filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c != 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
           
            List<File_Categories__c> fileCategoryList = [SELECT Id, Name FROM File_Categories__c Order By Name];
            Integer sumOfMemberFiles = 0;
            for(Member__c m:memberList){
                String memberName = '';
                sumOfMemberFiles = 0;
                Map<String,List<Map<String,Integer>>> memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>();
                Map<String,List<Map<String,List<Integer>>>> memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>(); 
            
                if((files !=null && files.size() > 0) || (filesOptional !=null && filesOptional.size() > 0)){
                    Set<String> memberFileCatSet = new Set<String>();
                    Set<String> memberFileCatSetOptional = new Set<String>();
                    Map<String,Integer> memberCatMap = new Map<String,Integer>();
                    Map<String,Integer> memberCatOptionMap = new Map<String,Integer>();
                    List<Map<String,Integer>> memberCatMapList = new List<Map<String,Integer>>();  
                    List<Map<String,List<Integer>>> memberCatMapWithROList = new List<Map<String,List<Integer>>>();
                    for(AggregateResult ar:files){
                        if(m.Id == ar.get('memId')){
                            memberFileCatSet.add((String) ar.get('CategoryCode'));
                            memberName = (String) ar.get('MemberName');
                            String currentfileCat = (String) ar.get('CategoryCode');
                            memberCatMap.put(currentfileCat,Integer.valueOf(ar.get('NumberOfFiles')));
                            system.debug('Current Member Category Map {REGULAR}---' + memberCatMap);
                            sumOfMemberFiles += Integer.valueOf(ar.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar));
                        }
                    }
                    system.debug('Member Name --- : ' + m.Name + ' Employee Id --- : ' + m.Emp_ID__c);   
                    for(AggregateResult ar2:filesOptional){
                        if(m.Id == ar2.get('memId')){
                            memberFileCatSetOptional.add((String) ar2.get('CategoryCode'));
                            memberName = (String) ar2.get('MemberName');
                            String currentfileCat = (String) ar2.get('CategoryCode');
                            memberCatOptionMap.put(currentfileCat,Integer.valueOf(ar2.get('NumberOfFiles')));
                            system.debug('Current Member Category Map {OPTIONAL} ---' + memberCatOptionMap);
                            sumOfMemberFiles += Integer.valueOf(ar2.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar2));
                        }
                    }
                    Map<String,Integer> thismemberRegCatMap = new Map<String,Integer>();
                    for(String newCategory : memberFileCatSet)  {
                        if(fileCategoryList != null && fileCategoryList.size() > 0){
                            for(File_Categories__c fileCat : fileCategoryList){
                                filecategoryHeader.add(fileCat.Name);
                                
                                if(fileCat.Name == newCategory){
                                    
                                    thismemberRegCatMap.put(fileCat.Name,Integer.valueOf(memberCatMap.get(fileCat.Name)));
                                    system.debug('Current Member Category Map ---' + thismemberRegCatMap);
                                    //memberCatMapList.add(thismemberCatMap);
                                } 
                                /*else {
                                    thismemberCatMap.put(fileCat.Name,0);
                                    system.debug('Current (ELSE) Member Category Map ---' + thismemberCatMap);
                                    memberCatMapList.add(thismemberCatMap);
                                }*/
                            }
                        }
                    }
                    
                    Map<String,Integer> thismemberCatOptionalMap = new Map<String,Integer>();
                     for(String newCategory : memberFileCatSetOptional)  {
                        if(fileCategoryList != null && fileCategoryList.size() > 0){
                            for(File_Categories__c fileCat : fileCategoryList){
                                //filecategoryHeader.add(fileCat.Name);
                                
                                if(fileCat.Name == newCategory){
                                    
                                    thismemberCatOptionalMap.put(fileCat.Name,Integer.valueOf(memberCatOptionMap.get(fileCat.Name)));
                                    system.debug('Current Member Category Map ---' + thismemberCatOptionalMap);
                                    //memberCatMapList.add(thismemberCatMap);
                                } 
                                /*else {
                                    thismemberCatMap.put(fileCat.Name,0);
                                    system.debug('Current (ELSE) Member Category Map ---' + thismemberCatMap);
                                    memberCatMapList.add(thismemberCatMap);
                                }*/
                            }
                        }
                    }
                    for(File_Categories__c categoryName : fileCategoryList){
                        Map<String,List<Integer>> thismemberCatMap = new Map<String,List<Integer>>();
                        if(!memberFileCatSet.contains(categoryName.Name)){
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }
                            
                        }else {
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }   
                        }
                    }
                    
                    if(memberCatMapWithROList.size() > 0){
                        //memberCatFinalMapList.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapList);
                        memberCatFinalMapList2.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapWithROList);
                        system.debug('Final Member Category Map with Member Name ---' + memberCatMapWithROList);
                        FileList2.add(new Bean2(m.Name,m.Emp_ID__c, memberCatFinalMapList2,sumOfMemberFiles));
                    }
                }
                if(sumOfMemberFiles > 0){
                    FileList2.add(new Bean2(memberName,sumOfMemberFiles));
                  totalShiftFileCount +=sumOfMemberFiles;
                     pieChartList.add(new PieWedgeData(memberName,Decimal.valueOf(sumOfMemberFiles)));
                }
          
            }

            FileList2.add(new Bean2(totalShiftFileCount));

        }else{
            FileList2 = null;
        }
        system.debug('teamListOfMembers -- BEFORE FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
        fromDate = null;
        ToDate = null;
        system.debug('teamListOfMembers -- AFTER FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
    }
    
    
    
    public void locationListOfMembers(){
        system.debug('Entered into Location List of members');
        List<id> memberIds = new  List<id>();
        FileList = new List<Bean>();
        FileList2 = new List<Bean2>();
        Map<string,Map<string,integer>>memberfilecategory = new  Map<string,Map<string,integer>>();
        List<AggregateResult> filesOptional = new  List<AggregateResult>();
        pieChartList = new List<PieWedgeData>();
        List<AggregateResult> files = new  List<AggregateResult>();
        
        if(selectedLocId != '' && !string.isBlank(selectedLocId)){
            memberList = [select id,Name,Emp_ID__c from Member__c where Location_id__c=:selectedLocId and status__C='Active'];     
        }else{
            memberList = null;
        }
        totalShiftFileCount = 0;
        Map<Id, String> memberInfoMap = new Map<Id, String>();
        if(memberList != null && memberList.size()>0){
            for(Member__c m:memberList){
                memberIds.add(m.id);
                memberInfoMap.put(m.id,m.Name);
            }
          
          
            if(selectedOrderIDId != null){
                system.debug('------------------Entered into files with orderId' + selectedOrderIDId);
                files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c = 'Clipping' and Production_Order__c=:selectedOrderIDId AND (Status__c = 'On-Hold' OR Status__c = 'Approved')  group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name];
                filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c != 'Clipping' and Production_Order__c=:selectedOrderIDId AND (Status__c = 'On-Hold' OR Status__c = 'Approved')  group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name];
                       
                
            }else{
                system.debug('------------------Entered into files with out date');
                files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c = 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
            
                filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c != 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
           
            }
            Set<string> newMemberIds = new Set<string>();
            if(files != null && files.size() > 0){
                for(AggregateResult arMember : files){
                    newMemberIds.add(String.valueOf(arMember.get('memId')));
                }
            }
            
            if(filesOptional != null && filesOptional.size() > 0){
                for(AggregateResult arMember : filesOptional){
                    newMemberIds.add(String.valueOf(arMember.get('memId')));
                }
            }
            
            if(newMemberIds != null && newMemberIds.size() >0){
                memberList = [select id,Name,Emp_ID__c  from Member__c where Id IN:newMemberIds and status__C='Active'];
            }    

            List<File_Categories__c> fileCategoryList = [SELECT Id, Name FROM File_Categories__c Order By Name];

            Integer sumOfMemberFiles = 0;
            for(Member__c m:memberList){
                String memberName = '';
                sumOfMemberFiles = 0;  
                Map<String,List<Map<String,Integer>>> memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>();  
                Map<String,List<Map<String,List<Integer>>>> memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>(); 
                if((files !=null && files.size() > 0) || (filesOptional !=null && filesOptional.size() > 0)){
                    Set<String> memberFileCatSet = new Set<String>();
                    Set<String> memberFileCatSetOptional = new Set<String>();
                    Map<String,Integer> memberCatMap = new Map<String,Integer>();
                    Map<String,Integer> memberCatOptionMap = new Map<String,Integer>();
                    List<Map<String,Integer>> memberCatMapList = new List<Map<String,Integer>>();
                    List<Map<String,List<Integer>>> memberCatMapWithROList = new List<Map<String,List<Integer>>>();
                    for(AggregateResult ar:files){
                        if(m.Id == ar.get('memId')){
                            memberFileCatSet.add((String) ar.get('CategoryCode'));
                            memberName = (String) ar.get('MemberName');
                            String currentfileCat = (String) ar.get('CategoryCode');
                            
                            memberCatMap.put(currentfileCat,Integer.valueOf(ar.get('NumberOfFiles')));
                            system.debug('Current Member Category Map ---' + memberCatMap);
                            sumOfMemberFiles += Integer.valueOf(ar.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar));
                        }
                    }
                    system.debug('Member Name --- : ' + m.Name + ' Employee Id --- : ' + m.Emp_ID__c);   
                    
                    for(String newCategory : memberFileCatSet)  {
                        if(fileCategoryList != null && fileCategoryList.size() > 0){
                            for(File_Categories__c fileCat : fileCategoryList){
                                filecategoryHeader.add(fileCat.Name);
                                Map<String,Integer> thismemberCatMap = new Map<String,Integer>();
                                if(fileCat.Name == newCategory){
                                    thismemberCatMap.put(fileCat.Name,Integer.valueOf(memberCatMap.get(fileCat.Name)));
                                    system.debug('Current Member Category Map ---' + thismemberCatMap);
                                    //memberCatMapList.add(thismemberCatMap);
                                } 
                            }
                        }
                    }
                    
                    for(AggregateResult ar2:filesOptional){
                        if(m.Id == ar2.get('memId')){
                            memberFileCatSetOptional.add((String) ar2.get('CategoryCode'));
                            memberName = (String) ar2.get('MemberName');
                            String currentfileCat = (String) ar2.get('CategoryCode');
                            memberCatOptionMap.put(currentfileCat,Integer.valueOf(ar2.get('NumberOfFiles')));
                            system.debug('Current Member Category Map {OPTIONAL} ---' + memberCatOptionMap);
                            sumOfMemberFiles += Integer.valueOf(ar2.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar2));
                        }
                    }
                        
                   for(File_Categories__c categoryName : fileCategoryList){
                        Map<String,List<Integer>> thismemberCatMap = new Map<String,List<Integer>>();
                        if(!memberFileCatSet.contains(categoryName.Name)){
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }
                            
                        }else {
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }   
                        }
                    }
                    
                    if(memberCatMapWithROList.size() > 0){
                        //memberCatFinalMapList.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapList);
                        memberCatFinalMapList2.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapWithROList);
                        system.debug('Final Member Category Map with Member Name ---' + memberCatMapWithROList);
                        FileList2.add(new Bean2(m.Name,m.Emp_ID__c, memberCatFinalMapList2,sumOfMemberFiles));
                    }
                }
                    
                if(sumOfMemberFiles > 0){
                    FileList2.add(new Bean2(memberName,sumOfMemberFiles));
                    totalShiftFileCount +=sumOfMemberFiles;
                    pieChartList.add(new PieWedgeData(memberName,Decimal.valueOf(sumOfMemberFiles)));
                }

            }

            FileList2.add(new Bean2(totalShiftFileCount));

        }else{
            FileList2 = null;
        }

    }
    
    public void shiftListOfMembers(){
        
        List<id> memberIds = new  List<id>();
        FileList = new List<Bean>();
        FileList2 = new List<Bean2>();
        Map<string,Map<string,integer>> memberfilecategory = new  Map<string,Map<string,integer>>();
        
        pieChartList = new List<PieWedgeData>();
        List<AggregateResult> filesOptional = new  List<AggregateResult>();
        List<AggregateResult> files = new  List<AggregateResult>();
        
        if(shiftCode != '' && !string.isBlank(shiftCode)){
            Shift__c shift = [select id,name,Shift_Location__c from Shift__c where id=:shiftCode];
            memberList = [select id,Name,Emp_ID__c  from Member__c where Current_Shift__c=:shift.name and status__C='Active' and   Location_id__c=:shift.Shift_Location__c];     
        } else{
            memberList = null;
        }
        
        totalShiftFileCount = 0;
        Map<Id, String> memberInfoMap = new Map<Id, String>();
        if(memberList != null && memberList.size()>0){
            for(Member__c m:memberList){
                memberIds.add(m.id);
                memberInfoMap.put(m.id,m.Name);
            }

            system.debug('------------------Entered into files with out date');
            files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c = 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
            
            filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c != 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
        
            Set<string> newMemberIds = new Set<string>();
            if(files != null && files.size() > 0){
                for(AggregateResult arMember : files){
                    newMemberIds.add(String.valueOf(arMember.get('memId')));
                }
            }
            
            if(filesOptional != null && filesOptional.size() > 0){
                for(AggregateResult arMember : filesOptional){
                    newMemberIds.add(String.valueOf(arMember.get('memId')));
                }
            }
            
            if(newMemberIds != null && newMemberIds.size() >0){
                memberList = [select id,Name,Emp_ID__c  from Member__c where Id IN:newMemberIds and status__C='Active'];
            }
            
            List<File_Categories__c> fileCategoryList = [SELECT Id, Name FROM File_Categories__c Order By Name];
            Integer sumOfMemberFiles = 0;
            Map<String,List<Map<String,Integer>>> memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>();
            Map<String,List<Map<String,List<Integer>>>> memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>(); 
            
            for(Member__c m:memberList){
                
                String memberName = '';
                sumOfMemberFiles = 0;   
                memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>();
                memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>(); 
            
                if((files !=null && files.size() > 0) || (filesOptional !=null && filesOptional.size() > 0)){
                    Set<String> memberFileCatSet = new Set<String>();
                    Set<String> memberFileCatSetOptional = new Set<String>();
                    Map<String,Integer> memberCatMap = new Map<String,Integer>();
                    Map<String,Integer> memberCatOptionMap = new Map<String,Integer>();
                    List<Map<String,List<Integer>>> memberCatMapWithROList = new List<Map<String,List<Integer>>>();
                    List<Map<String,Integer>> memberCatMapList = new List<Map<String,Integer>>();
                    
                    for(AggregateResult ar:files){

                        if(m.Id == ar.get('memId')){
                            memberFileCatSet.add((String) ar.get('CategoryCode'));
                            memberName = (String) ar.get('MemberName');
                            String currentfileCat = (String) ar.get('CategoryCode');
                            
                            memberCatMap.put(currentfileCat,Integer.valueOf(ar.get('NumberOfFiles')));
                            system.debug('Current Member Category Map ---' + memberCatMap);
                            sumOfMemberFiles += Integer.valueOf(ar.get('NumberOfFiles'));
                            /*memberCatMapList.add(memberCatMap);
                            system.debug('Current Category Code :' + currentfileCat);
                            
                            
                            system.debug('Final Member Category Map ---' + memberCatMapList);
                            system.debug('Current Member Name :' + memberName);
                            system.debug('Category Member set :' +memberFileCatSet);*/
                            FileList2.add(new Bean2(ar));
                        }
                    }
                    
                    for(AggregateResult ar2:filesOptional){
                        if(m.Id == ar2.get('memId')){
                            memberFileCatSetOptional.add((String) ar2.get('CategoryCode'));
                            memberName = (String) ar2.get('MemberName');
                            String currentfileCat = (String) ar2.get('CategoryCode');
                            memberCatOptionMap.put(currentfileCat,Integer.valueOf(ar2.get('NumberOfFiles')));
                            system.debug('Current Member Category Map {OPTIONAL} ---' + memberCatOptionMap);
                            sumOfMemberFiles += Integer.valueOf(ar2.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar2));
                        }
                    }
                    
                    system.debug('Member Name --- : ' + m.Name + ' Employee Id --- : ' + m.Emp_ID__c);   
                    
                    for(String newCategory : memberFileCatSet)  {
                        if(fileCategoryList != null && fileCategoryList.size() > 0){
                            for(File_Categories__c fileCat : fileCategoryList){
                                filecategoryHeader.add(fileCat.Name);
                                Map<String,Integer> thismemberCatMap = new Map<String,Integer>();
                                if(fileCat.Name == newCategory){
                                    thismemberCatMap.put(fileCat.Name,Integer.valueOf(memberCatMap.get(fileCat.Name)));
                                    system.debug('Current Member Category Map ---' + thismemberCatMap);
                                    //memberCatMapList.add(thismemberCatMap);
                                } 
                                /*else {
                                    thismemberCatMap.put(fileCat.Name,0);
                                    system.debug('Current (ELSE) Member Category Map ---' + thismemberCatMap);
                                    memberCatMapList.add(thismemberCatMap);
                                }*/
                            }
                        }
                    }
                    
                    for(File_Categories__c categoryName : fileCategoryList){
                        Map<String,List<Integer>> thismemberCatMap = new Map<String,List<Integer>>();
                        if(!memberFileCatSet.contains(categoryName.Name)){
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }
                            
                        }else {
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }   
                        }
                    }
                    
                    if(memberCatMapWithROList.size() > 0){
                        //memberCatFinalMapList.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapList);
                        memberCatFinalMapList2.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapWithROList);
                        system.debug('Final Member Category Map with Member Name ---' + memberCatMapWithROList);
                        FileList2.add(new Bean2(m.Name,m.Emp_ID__c, memberCatFinalMapList2,sumOfMemberFiles));
                    }
                }
                
                if(sumOfMemberFiles > 0){
                    FileList2.add(new Bean2(memberName,sumOfMemberFiles));
                    totalShiftFileCount +=sumOfMemberFiles;
                    pieChartList.add(new PieWedgeData(memberName,Decimal.valueOf(sumOfMemberFiles)));
                }
            }
   
            FileList2.add(new Bean2(totalShiftFileCount));
        }else{
            FileList2 = null;
        }
        
        system.debug('shiftListOfMembers -- BEFORE FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
        fromDate = null;
        ToDate = null;
        system.debug('shiftListOfMembers -- AFTER FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
    }
    
    
    public PageReference CreateExcelSheet() {
        pagereference pr = new PageReference('/apex/EPMS_ShowPerformanceExcel');
        //pagereference pr = new PageReference('/apex/EPMS_ShowPerformanceExcel_v2');
        return pr;
    }
    
 
    
    
    
    public void search(){
        
        system.debug(' ### SELECTED LOCATION ####' + selectedLocId);
        system.debug(' ### SELECTED SHIFT ####' + shiftCode);
        system.debug(' ### SELECTED TEAM ####' + teamId);
        system.debug(' ### SELECTED SHIFT1 ####' + selectedShiftName);
        system.debug(' ### SELECTED TEAM1 ####' + selectedTeamName);
        system.debug(' $$$$$ FROM DATE $$$$$' + fromDate);
        system.debug(' $$$$$ TO DATE $$$$$' + ToDate);
        system.debug(' @@@@@ INPUT FROM DATE $$$$$' + fileInfo.Work_Start_Time__c);
        system.debug(' $$$$$ INPUT TO DATE $$$$$' + fileInfo.Work_End_Time__c);
        if(selectedLocId == null){
        
        }
        //fromDate =fileInfo.Work_Start_Time__c;
        //ToDate =fileInfo.Work_End_Time__c;
        if(fromDate != null){
            if(ToDate != null){
                if(ToDate < fromDate){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'From Date Should be less than To Date '));
                    return;                
                }
            } else {
                if(fromDate > system.now()){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'From Date Should be less than To Date / Current time '));
                    return;    
                }
            }
            
        }
        if(selectedLocId == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select the Location'));
            return;
        }
        if(fromDate == null && ToDate == null){
            if(selectedLocId != null && shiftCode== null && teamId == null)
            {
                system.debug(' ### SELECTED LOCATION ####' );
                locationListOfMembers();    
            }
            else if(selectedLocId != null && shiftCode!= null && teamId == null){
                system.debug(' ### SELECTED SHIFT ####');
                shiftListOfMembers();   
            }
            else if(selectedLocId != null && shiftCode!= null && teamId != null){
                system.debug(' ### CASE TEAM ####');
                teamListOfMembers();    
            }    
        }else if(fromDate != null){
            // Clear the Production Order No in text Box
            if(selectedOrderIDId != null){
                selectedOrderIDId = null;
                orderName = '';
            }
            if(ToDate == null){
                ToDate = system.now();
            }
             system.debug(' $$$$$ CURRENT TO DATE $$$$$' + ToDate);
            if(selectedLocId != null && shiftCode== null && teamId == null)
            {
                system.debug(' ### SELECTED LOCATION [WITH DATE] ####' );
                displayMemberBylocation(selectedLocId,fromDate,ToDate);    
            }
            else if(selectedLocId != null && shiftCode!= null && teamId == null){
                system.debug(' ### SELECTED SHIFT  [WITH DATE] ####');
                displayMemberByshift(shiftCode,fromDate,ToDate);   
            }
            else if(selectedLocId != null && shiftCode!= null && teamId != null){
                system.debug(' ### SELECTED TEAM [WITH DATE] ####');
                displayMemberByTeam(teamId,fromDate,ToDate);    
            }
            
        }
        
    }
    
    public void displayMemberBylocation(String selectedLocId, Datetime fromDate, Datetime ToDate){
        system.debug('Entered into Location List of members filter by DATE');
        system.debug(' ### displayMemberBylocation #### Location ID : ' + selectedLocId + ' FROM DATE '+ fromDate + ' TO DATE ' + ToDate);
        List<id> memberIds = new  List<id>();
        FileList = new List<Bean>();
        FileList2 = new List<Bean2>();
        Map<string,Map<string,integer>>memberfilecategory = new  Map<string,Map<string,integer>>();
        pieChartList = new List<PieWedgeData>();
        List<AggregateResult> filesOptional = new  List<AggregateResult>();
        List<AggregateResult> files = new  List<AggregateResult>();
        if(selectedLocId != '' && !string.isBlank(selectedLocId)){
            memberList = [select id,Name,Emp_ID__c from Member__c where Location_id__c=:selectedLocId and status__C='Active'];     
        }else{
            memberList = null;
        }
        totalShiftFileCount = 0;
        Map<Id, String> memberInfoMap = new Map<Id, String>();
        if(memberList != null && memberList.size()>0){
            for(Member__c m:memberList){
                memberIds.add(m.id);
                memberInfoMap.put(m.id,m.Name);
            }
          
          
            if(selectedOrderIDId != null){
                system.debug('--------displayMemberBylocation----------Entered into files with orderId');
                files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c = 'Clipping' and Production_Order__c=:selectedOrderIDId  group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name];
                filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c != 'Clipping' and Production_Order__c=:selectedOrderIDId  group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name];
                Set<string> newMemberIds = new Set<string>();
                if(files != null && files.size() > 0){
                    for(AggregateResult arMember : files){
                        newMemberIds.add(String.valueOf(arMember.get('memId')));
                    }
                }
                
                if(filesOptional != null && filesOptional.size() > 0){
                    for(AggregateResult arMember : filesOptional){
                        newMemberIds.add(String.valueOf(arMember.get('memId')));
                    }
                }
            
                if(newMemberIds != null && newMemberIds.size() >0){
                    memberList = [select id,Name,Emp_ID__c  from Member__c where Id IN:newMemberIds and status__C='Active'];
                }           
                
            }else{
                system.debug('------------------Entered into files with out date');
                //files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; //
                
                files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c = 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold') and (Work_Start_Time__c>=:fromDate AND     Work_End_Time__c <=:ToDate)   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
                
                filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and Job_List__c != 'Clipping' and (Status__c='Approved' OR Status__c='On-Hold') and (Work_Start_Time__c>=:fromDate AND     Work_End_Time__c <=:ToDate)   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
               
                Set<string> newMemberIds = new Set<string>();
                if(files != null && files.size() > 0){
                    for(AggregateResult arMember : files){
                        newMemberIds.add(String.valueOf(arMember.get('memId')));
                    }
                }
                
                if(filesOptional != null && filesOptional.size() > 0){
                    for(AggregateResult arMember : filesOptional){
                        newMemberIds.add(String.valueOf(arMember.get('memId')));
                    }
                }
            
                if(newMemberIds != null && newMemberIds.size() >0){
                    memberList = [select id,Name,Emp_ID__c  from Member__c where Id IN:newMemberIds and status__C='Active'];
                }
            }

            List<File_Categories__c> fileCategoryList = [SELECT Id, Name FROM File_Categories__c Order By Name];

            Integer sumOfMemberFiles = 0;
            for(Member__c m:memberList){
                String memberName = '';
                sumOfMemberFiles = 0;  
                Map<String,List<Map<String,Integer>>> memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>();   
                Map<String,List<Map<String,List<Integer>>>> memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>();             
                if((files !=null && files.size() > 0) || (filesOptional !=null && filesOptional.size() > 0)){
                    Set<String> memberFileCatSet = new Set<String>();
                    Set<String> memberFileCatSetOptional = new Set<String>();
                    Map<String,Integer> memberCatMap = new Map<String,Integer>();
                    Map<String,Integer> memberCatOptionMap = new Map<String,Integer>();
                    List<Map<String,Integer>> memberCatMapList = new List<Map<String,Integer>>();
                    List<Map<String,List<Integer>>> memberCatMapWithROList = new List<Map<String,List<Integer>>>();
                    for(AggregateResult ar:files){
                        if(m.Id == ar.get('memId')){
                            memberFileCatSet.add((String) ar.get('CategoryCode'));
                            memberName = (String) ar.get('MemberName');
                            String currentfileCat = (String) ar.get('CategoryCode');
                            
                            memberCatMap.put(currentfileCat,Integer.valueOf(ar.get('NumberOfFiles')));
                            system.debug('Current Member Category Map ---' + memberCatMap);
                            sumOfMemberFiles += Integer.valueOf(ar.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar));
                        }
                    }
                    system.debug('Member Name --- : ' + m.Name + ' Employee Id --- : ' + m.Emp_ID__c);   
                    
                    for(AggregateResult ar2:filesOptional){
                        if(m.Id == ar2.get('memId')){
                            memberFileCatSetOptional.add((String) ar2.get('CategoryCode'));
                            memberName = (String) ar2.get('MemberName');
                            String currentfileCat = (String) ar2.get('CategoryCode');
                            memberCatOptionMap.put(currentfileCat,Integer.valueOf(ar2.get('NumberOfFiles')));
                            system.debug('Current Member Category Map {OPTIONAL} ---' + memberCatOptionMap);
                            sumOfMemberFiles += Integer.valueOf(ar2.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar2));
                        }
                    }
                    
                    for(String newCategory : memberFileCatSet)  {
                        if(fileCategoryList != null && fileCategoryList.size() > 0){
                            for(File_Categories__c fileCat : fileCategoryList){
                                filecategoryHeader.add(fileCat.Name);
                                Map<String,Integer> thismemberCatMap = new Map<String,Integer>();
                                if(fileCat.Name == newCategory){
                                    thismemberCatMap.put(fileCat.Name,Integer.valueOf(memberCatMap.get(fileCat.Name)));
                                    system.debug('Current Member Category Map ---' + thismemberCatMap);
                                    //memberCatMapList.add(thismemberCatMap);
                                } 
                                /*else {
                                    thismemberCatMap.put(fileCat.Name,0);
                                    system.debug('Current (ELSE) Member Category Map ---' + thismemberCatMap);
                                    memberCatMapList.add(thismemberCatMap);
                                }*/
                            }
                        }
                    }
                        
                    for(File_Categories__c categoryName : fileCategoryList){
                        Map<String,List<Integer>> thismemberCatMap = new Map<String,List<Integer>>();
                        if(!memberFileCatSet.contains(categoryName.Name)){
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }
                            
                        }else {
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }   
                        }
                    }
                    
                    if(memberCatMapWithROList.size() > 0){
                        //memberCatFinalMapList.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapList);
                        memberCatFinalMapList2.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapWithROList);
                        system.debug('Final Member Category Map with Member Name ---' + memberCatMapWithROList);
                        FileList2.add(new Bean2(m.Name,m.Emp_ID__c, memberCatFinalMapList2,sumOfMemberFiles));
                    }
                }
                    
                if(sumOfMemberFiles > 0){
                    FileList2.add(new Bean2(memberName,sumOfMemberFiles));
                    totalShiftFileCount +=sumOfMemberFiles;
                    pieChartList.add(new PieWedgeData(memberName,Decimal.valueOf(sumOfMemberFiles)));
                }

            }

            FileList2.add(new Bean2(totalShiftFileCount));

        }else{
            FileList2 = null;
        }

    }
    
    public void displayMemberByshift(String shiftCode,Datetime fromDate, Datetime ToDate){
        
        List<id> memberIds = new  List<id>();
        FileList = new List<Bean>();
        FileList2 = new List<Bean2>();
        Map<string,Map<string,integer>> memberfilecategory = new  Map<string,Map<string,integer>>();
        pieChartList = new List<PieWedgeData>();
        List<AggregateResult> filesOptional = new  List<AggregateResult>();
        List<AggregateResult> files = new  List<AggregateResult>();
        
        if(shiftCode != '' && !string.isBlank(shiftCode)){
            Shift__c shift = [select id,name,Shift_Location__c from Shift__c where id=:shiftCode];
            memberList = [select id,Name,Emp_ID__c  from Member__c where Current_Shift__c=:shift.name and status__C='Active' and   Location_id__c=:shift.Shift_Location__c];     
        } else{
            memberList = null;
        }
        
        totalShiftFileCount = 0;
        Map<Id, String> memberInfoMap = new Map<Id, String>();
        if(memberList != null && memberList.size()>0){
            for(Member__c m:memberList){
                memberIds.add(m.id);
                memberInfoMap.put(m.id,m.Name);
            }

            system.debug('------------------Entered into files with out date');
            //files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
            
            files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and (Status__c='Approved' OR Status__c='On-Hold') and Job_List__c = 'Clipping' and (Work_Start_Time__c>=:fromDate AND     Work_End_Time__c <=:ToDate)   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
            filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and (Status__c='Approved' OR Status__c='On-Hold') and Job_List__c != 'Clipping' and (Work_Start_Time__c>=:fromDate AND     Work_End_Time__c <=:ToDate)   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
            
            Set<string> newMemberIds = new Set<string>();
            if(files != null && files.size() > 0){
                for(AggregateResult arMember : files){
                    newMemberIds.add(String.valueOf(arMember.get('memId')));
                }
            }
            
            if(filesOptional != null && filesOptional.size() > 0){
                for(AggregateResult arMember : filesOptional){
                    newMemberIds.add(String.valueOf(arMember.get('memId')));
                }
            }
            
            if(newMemberIds != null && newMemberIds.size() >0){
                memberList = [select id,Name,Emp_ID__c  from Member__c where Id IN:newMemberIds and status__C='Active'];
            }
            
            List<File_Categories__c> fileCategoryList = [SELECT Id, Name FROM File_Categories__c Order By Name];
            Integer sumOfMemberFiles = 0;
            Map<String,List<Map<String,Integer>>> memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>();
            Map<String,List<Map<String,List<Integer>>>> memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>(); 
            for(Member__c m:memberList){
                
                String memberName = '';
                sumOfMemberFiles = 0;   
                memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>();
                memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>();
                if((files !=null && files.size() > 0) || (filesOptional !=null && filesOptional.size() > 0)){
                    Set<String> memberFileCatSet = new Set<String>();
                    Set<String> memberFileCatSetOptional = new Set<String>();
                    Map<String,Integer> memberCatMap = new Map<String,Integer>();
                    List<Map<String,Integer>> memberCatMapList = new List<Map<String,Integer>>();
                    Map<String,Integer> memberCatOptionMap = new Map<String,Integer>();
                    List<Map<String,List<Integer>>> memberCatMapWithROList = new List<Map<String,List<Integer>>>();
                    for(AggregateResult ar:files){

                        if(m.Id == ar.get('memId')){
                            memberFileCatSet.add((String) ar.get('CategoryCode'));
                            memberName = (String) ar.get('MemberName');
                            String currentfileCat = (String) ar.get('CategoryCode');
                            
                            memberCatMap.put(currentfileCat,Integer.valueOf(ar.get('NumberOfFiles')));
                            system.debug('Current Member Category Map ---' + memberCatMap);
                            sumOfMemberFiles += Integer.valueOf(ar.get('NumberOfFiles'));
                            /*memberCatMapList.add(memberCatMap);
                            system.debug('Current Category Code :' + currentfileCat);
                            
                            
                            system.debug('Final Member Category Map ---' + memberCatMapList);
                            system.debug('Current Member Name :' + memberName);
                            system.debug('Category Member set :' +memberFileCatSet);*/
                            FileList2.add(new Bean2(ar));
                        }
                    }
                    system.debug('Member Name --- : ' + m.Name + ' Employee Id --- : ' + m.Emp_ID__c);   
                    
                    for(AggregateResult ar2:filesOptional){
                        if(m.Id == ar2.get('memId')){
                            memberFileCatSetOptional.add((String) ar2.get('CategoryCode'));
                            memberName = (String) ar2.get('MemberName');
                            String currentfileCat = (String) ar2.get('CategoryCode');
                            memberCatOptionMap.put(currentfileCat,Integer.valueOf(ar2.get('NumberOfFiles')));
                            system.debug('Current Member Category Map {OPTIONAL} ---' + memberCatOptionMap);
                            sumOfMemberFiles += Integer.valueOf(ar2.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar2));
                        }
                    }
                    
                    for(String newCategory : memberFileCatSet)  {
                        if(fileCategoryList != null && fileCategoryList.size() > 0){
                            for(File_Categories__c fileCat : fileCategoryList){
                                filecategoryHeader.add(fileCat.Name);
                                Map<String,Integer> thismemberCatMap = new Map<String,Integer>();
                                if(fileCat.Name == newCategory){
                                    thismemberCatMap.put(fileCat.Name,Integer.valueOf(memberCatMap.get(fileCat.Name)));
                                    system.debug('Current Member Category Map ---' + thismemberCatMap);
                                    //memberCatMapList.add(thismemberCatMap);
                                } 
                                /*else {
                                    thismemberCatMap.put(fileCat.Name,0);
                                    system.debug('Current (ELSE) Member Category Map ---' + thismemberCatMap);
                                    memberCatMapList.add(thismemberCatMap);
                                }*/
                            }
                        }
                    }
                    
                    for(File_Categories__c categoryName : fileCategoryList){
                        Map<String,List<Integer>> thismemberCatMap = new Map<String,List<Integer>>();
                        if(!memberFileCatSet.contains(categoryName.Name)){
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }
                            
                        }else {
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }   
                        }
                    }
                    
                    if(memberCatMapWithROList.size() > 0){
                        //memberCatFinalMapList.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapList);
                        memberCatFinalMapList2.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapWithROList);
                        system.debug('Final Member Category Map with Member Name ---' + memberCatMapWithROList);
                        FileList2.add(new Bean2(m.Name,m.Emp_ID__c, memberCatFinalMapList2,sumOfMemberFiles));
                    }
                    
                }
                
                if(sumOfMemberFiles > 0){
                    FileList2.add(new Bean2(memberName,sumOfMemberFiles));
                    totalShiftFileCount +=sumOfMemberFiles;
                    pieChartList.add(new PieWedgeData(memberName,Decimal.valueOf(sumOfMemberFiles)));
                }
            }
   
            FileList2.add(new Bean2(totalShiftFileCount));
        }else{
            FileList2 = null;
        }
        
        system.debug('shiftListOfMembers -- BEFORE FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
        fromDate = null;
        ToDate = null;
        system.debug('shiftListOfMembers -- AFTER FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
    }

    public void displayMemberByTeam(String teamId,Datetime fromDate, Datetime ToDate){
        List<id> memberIds = new  List<id>();
        FileList = new List<Bean>();
        FileList2 = new List<Bean2>();
        Map<string,Map<string,integer>> memberfilecategory = new  Map<string,Map<string,integer>>();
        pieChartList = new List<PieWedgeData>();
        List<AggregateResult> filesOptional = new  List<AggregateResult>();
        List<AggregateResult> files = new  List<AggregateResult>();
        Team__c teamInfo = null;
        if(teamNames != null && !string.isBlank(teamId)){
            teamInfo = [SELECT Name FROM Team__c WHERE Id =: teamId LIMIT 1];
            if(teamInfo != null){
                selectedTeamName = teamInfo.Name;
            }
            memberList = [select id,name,Emp_ID__c from Member__c where Team_Id__c=:teamId  and status__C='Active'];     
        }else{
            memberList = null;
        }
        totalShiftFileCount = 0;
        Map<Id, String> memberInfoMap = new Map<Id, String>();
        if(memberList != null && memberList.size()>0){
            for(Member__c m:memberList){
                memberIds.add(m.id);
                memberInfoMap.put(m.id,m.Name);
            }
           
            system.debug('------------------Entered into files with out date');
            //files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and (Status__c='Approved' OR Status__c='On-Hold')   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name]; 
            files = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and (Status__c='Approved' OR Status__c='On-Hold') and Job_List__c = 'Clipping' and (Work_Start_Time__c>=:fromDate AND     Work_End_Time__c <=:ToDate)   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name];
            filesOptional = [SELECT   Member__r.Emp_ID__c EmpId,Member__r.name MemberName,Member__c memId, File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Member__c =:memberIds and (Status__c='Approved' OR Status__c='On-Hold') and Job_List__c != 'Clipping' and (Work_Start_Time__c>=:fromDate AND     Work_End_Time__c <=:ToDate)   group by Member__r.name, Member__r.Emp_ID__c,Member__c,File_Category_Code__r.name];
           
            List<File_Categories__c> fileCategoryList = [SELECT Id, Name FROM File_Categories__c Order By Name];
            Integer sumOfMemberFiles = 0;
            for(Member__c m:memberList){
                String memberName = '';
                sumOfMemberFiles = 0;
                Map<String,List<Map<String,Integer>>> memberCatFinalMapList = new Map<String,List<Map<String,Integer>>>(); 
                Map<String,List<Map<String,List<Integer>>>> memberCatFinalMapList2 = new Map<String,List<Map<String,List<Integer>>>>();                 
                List<Map<String,List<Integer>>> memberCatMapWithROList = new List<Map<String,List<Integer>>>();
                if((files !=null && files.size() > 0) || (filesOptional !=null && filesOptional.size() > 0)){
                    Set<String> memberFileCatSet = new Set<String>();
                    Set<String> memberFileCatSetOptional = new Set<String>();
                    Map<String,Integer> memberCatMap = new Map<String,Integer>();
                    Map<String,Integer> memberCatOptionMap = new Map<String,Integer>();
                    List<Map<String,Integer>> memberCatMapList = new List<Map<String,Integer>>();                        
                    for(AggregateResult ar:files){
                        if(m.Id == ar.get('memId')){
                            memberFileCatSet.add((String) ar.get('CategoryCode'));
                            memberName = (String) ar.get('MemberName');
                            String currentfileCat = (String) ar.get('CategoryCode');
                            memberCatMap.put(currentfileCat,Integer.valueOf(ar.get('NumberOfFiles')));
                            system.debug('Current Member Category Map ---' + memberCatMap);
                            sumOfMemberFiles += Integer.valueOf(ar.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar));
                        }
                    }
                    system.debug('Member Name --- : ' + m.Name + ' Employee Id --- : ' + m.Emp_ID__c);   
                    
                    for(AggregateResult ar2:filesOptional){
                        if(m.Id == ar2.get('memId')){
                            memberFileCatSetOptional.add((String) ar2.get('CategoryCode'));
                            memberName = (String) ar2.get('MemberName');
                            String currentfileCat = (String) ar2.get('CategoryCode');
                            memberCatOptionMap.put(currentfileCat,Integer.valueOf(ar2.get('NumberOfFiles')));
                            system.debug('Current Member Category Map {OPTIONAL} ---' + memberCatOptionMap);
                            sumOfMemberFiles += Integer.valueOf(ar2.get('NumberOfFiles'));
                            FileList2.add(new Bean2(ar2));
                        }
                    }
                    
                    for(String newCategory : memberFileCatSet)  {
                        if(fileCategoryList != null && fileCategoryList.size() > 0){
                            for(File_Categories__c fileCat : fileCategoryList){
                                filecategoryHeader.add(fileCat.Name);
                                Map<String,Integer> thismemberCatMap = new Map<String,Integer>();
                                if(fileCat.Name == newCategory){
                                    thismemberCatMap.put(fileCat.Name,Integer.valueOf(memberCatMap.get(fileCat.Name)));
                                    system.debug('Current Member Category Map ---' + thismemberCatMap);
                                    //memberCatMapList.add(thismemberCatMap);
                                } 
                                /*else {
                                    thismemberCatMap.put(fileCat.Name,0);
                                    system.debug('Current (ELSE) Member Category Map ---' + thismemberCatMap);
                                    memberCatMapList.add(thismemberCatMap);
                                }*/
                            }
                        }
                    }
                    
                    for(File_Categories__c categoryName : fileCategoryList){
                        Map<String,List<Integer>> thismemberCatMap = new Map<String,List<Integer>>();
                        if(!memberFileCatSet.contains(categoryName.Name)){
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(0); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }
                            
                        }else {
                            if(!memberFileCatSetOptional.contains(categoryName.Name)){
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(0); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            } else {
                                List<Integer> newIntegerList = new List<Integer>();
                                newIntegerList.add(Integer.valueOf(memberCatMap.get(categoryName.Name))); // Regular Job File Count
                                newIntegerList.add(Integer.valueOf(memberCatOptionMap.get(categoryName.Name))); // Optional Job File Count
                                thismemberCatMap.put(categoryName.Name,newIntegerList);
                                memberCatMapWithROList.add(thismemberCatMap);
                            }   
                        }
                    }
                    
                    if(memberCatMapWithROList.size() > 0){
                        //memberCatFinalMapList.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapList);
                        memberCatFinalMapList2.put(memberInfoMap.get(m.Id)+' : ' +m.Emp_ID__c,memberCatMapWithROList);
                        system.debug('Final Member Category Map with Member Name ---' + memberCatMapWithROList);
                        FileList2.add(new Bean2(m.Name,m.Emp_ID__c, memberCatFinalMapList2,sumOfMemberFiles));
                    }
                }
                if(sumOfMemberFiles > 0){
                    FileList2.add(new Bean2(memberName,sumOfMemberFiles));
                  totalShiftFileCount +=sumOfMemberFiles;
                     pieChartList.add(new PieWedgeData(memberName,Decimal.valueOf(sumOfMemberFiles)));
                }
          
            }

            FileList2.add(new Bean2(totalShiftFileCount));

        }else{
            FileList2 = null;
        }
        system.debug('teamListOfMembers -- BEFORE FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
        fromDate = null;
        ToDate = null;
        system.debug('teamListOfMembers -- AFTER FROM DT $$ ' + fromDate + ' To Date $$$ ' + ToDate);
    }

    public class Bean{
        public string MemberName{get;private set;}
        public string FilecategoryCode{get;private set;}
        public  integer NumberOfFiles{get;private set;}
        public  integer TotalFiles{get;private set;}
        public  integer totalShiftFileCount{get;private set;}
        public string EmployeeId{get;private set;}
        public string aggrMemberName{get;private set;}
        public integer aggrNumberOfFiles{get;private set;}
        
        public string labelforToalFiles{get;private set;}
        public string empId {get;private set;}
        public Map<String,List<Map<String, Integer>>> memberCatListMap {get;private set;}
        
         Bean(String name, String emplId, Map<String, List<Map<String, Integer>>> memberFinalCategoryList, Integer totalcount){
           memberCatListMap = new Map<String,List<Map<String, Integer>>>();
            this.empId = (string) emplId;
            this.MemberName = (string) name;
            this.memberCatListMap = memberFinalCategoryList;
            this.NumberOfFiles = (integer) totalcount;
         
            
        }         

        Bean(AggregateResult ar){
           
            this.EmployeeId = (string) ar.get('EmpId');
            this.aggrMemberName = (string) ar.get('MemberName');
            this.FilecategoryCode = (string) ar.get('CategoryCode');
            this.aggrNumberOfFiles = (integer) ar.get('NumberOfFiles');
         
            
        }         
        
        Bean(String memberName, Integer totalNoOfFilesForMember){
            this.labelforToalFiles =  memberName;
            this.TotalFiles = (integer) totalNoOfFilesForMember;
        }
        Bean(Integer totalShiftFileCount){
            this.totalShiftFileCount = (integer) totalShiftFileCount;
        }
    }
    
    
    public class Bean2{
        public string MemberName{get;private set;}
        public string FilecategoryCode{get;private set;}
        public  integer NumberOfFiles{get;private set;}
        public  integer TotalFiles{get;private set;}
        public  integer totalShiftFileCount{get;private set;}
        public string EmployeeId{get;private set;}
        public string aggrMemberName{get;private set;}
        public integer aggrNumberOfFiles{get;private set;}
        
        public string labelforToalFiles{get;private set;}
        public string empId {get;private set;}
        public Map<String,List<Map<String,List<Integer>>>> memberCatListMap {get;private set;}
        
         Bean2(String name, String emplId, Map<String,List<Map<String,List<Integer>>>> memberFinalCategoryList, Integer totalcount){
           memberCatListMap = new Map<String,List<Map<String, List<Integer>>>>();
            this.empId = (string) emplId;
            this.MemberName = (string) name;
            this.memberCatListMap = memberFinalCategoryList;
            this.NumberOfFiles = (integer) totalcount;
         
            
        }         

        Bean2(AggregateResult ar){
           
            this.EmployeeId = (string) ar.get('EmpId');
            this.aggrMemberName = (string) ar.get('MemberName');
            this.FilecategoryCode = (string) ar.get('CategoryCode');
            this.aggrNumberOfFiles = (integer) ar.get('NumberOfFiles');
         
            
        }         
        
        Bean2(String memberName, Integer totalNoOfFilesForMember){
            this.labelforToalFiles =  memberName;
            this.TotalFiles = (integer) totalNoOfFilesForMember;
        }
        Bean2(Integer totalShiftFileCount){
            this.totalShiftFileCount = (integer) totalShiftFileCount;
        }
    }
    
    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        if(pieChartList != null && pieChartList.size() > 0){
            return pieChartList;
        } else {
            return data;
        }
        
    }
        
    // Wrapper class  
    public class PieWedgeData 
    {  
        public String name { get; set; }  
        public Decimal data { get; set; }  
        
        public PieWedgeData(String name, Decimal data) 
        {  
            this.name = name;  
            this.data = data;  
        }  
    }  


}