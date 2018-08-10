/****************************************************************************
*   Class               :       EPMS_ShiftAttendance                         *
*   Created Date        :       12/09/2016                                   *           
*   Description         :       ShiftAttendance Report Class  for displaying 
                                member attendance status                     *
/*****************************************************************************/

Public class EPMS_ShiftAttendance
{
    public List<Date> DatesFrntEnd {get;set;}
    public List<Shift_Attendance__c> AttendanceList {get;set;}
    public List<profile> profileList = null;
    public String MyProflieName{get;set;}
    public Member__c member {get;set;}
    public List<Member__c> memberList {get;set;}
    public Date startDT {get; set;}
    public Date endDT {get; set;}
    public List<WrapperMember> MemberWrappper;
 
    private Integer OffsetSize = 0;
    private Integer QueryLimit = 20;
    private Integer CountTotalRecords = 0;
    
    public boolean tableFlag {get;set;}
    public Id selectvalue{get;set;}      
    
    public Shift_Attendance__c shiftAttedanceDetails{get; set;} 
    
    public List<WrapperMember> AttendanceMemberList {get;set;}
   
    EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
    EPMS_ShiftAttendance_Service attendanceService = new EPMS_ShiftAttendance_Service();
    
    
  //constructor
    public EPMS_ShiftAttendance() {
    
        AttendanceMemberList  = new List<WrapperMember>();
        shiftAttedanceDetails = new Shift_Attendance__c();
        startDT = shiftAttedanceDetails.Start_Date__c;
        endDT = shiftAttedanceDetails.End_Date__c;
        Date NewStartDate;
        DatesFrntEnd =new List<Date>();     
        Date firstDayOfMonth;
        Date lastDayOfMonth;
        Integer DaysoFcurrentMonth;
        Integer count=0;
        tableFlag = true;
        
        MemberWrappper = new list<WrapperMember>();             
        List<Date> monthCheck = new List<Date>();       
        
        if(startDT!=null && endDT!=null){
            firstDayOfMonth = startDT;
            lastDayOfMonth = endDT;
        }else{             
             firstDayOfMonth = System.today().addDays(-29);  
             lastDayOfMonth = System.today();
        }
        
        DaysoFcurrentMonth=firstDayOfMonth.daysBetween(lastDayOfMonth);
        NewStartDate = lastDayOfMonth;      
        for(integer i=0; i<=DaysoFcurrentMonth; i++){       
            DateTime ReqmtAssignDt=lastDayOfMonth;
            Date ReqmAssignDate=Date.NewInstance(ReqmtAssignDt.year(), ReqmtAssignDt.month(), ReqmtAssignDt.day());
            if(ReqmAssignDate == NewStartDate){
                count ++;
            }
            DatesFrntEnd.add(firstDayOfMonth.addDays(i));
        }
        
        AttendanceMemberList =getMemberWrappper();
     }
     
    //Search option based on Start Date and End Date
    public pagereference search(){
        CountTotalRecords = 0;
        OffsetSize = 0;
        Integer DaysoFcurrentMonth;    
        Date todayDate = System.today();
        Date startDT = shiftAttedanceDetails.Start_Date__c;
        Date endDT = shiftAttedanceDetails.End_Date__c;      
        
        if(startDT!=null && endDT==null)
        {
             tableFlag =false;           
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SELECT_END_DATE));
        }else if(startDT==null && endDT!=null)
        {
             tableFlag =false;           
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SELECT_START_DATE));           
        }else if(startDT!=null && endDT!=null){
                if(startDT <= todayDate && todayDate  >= endDT)
                {
                    if(startDT <= endDT)
                    {
                         DaysoFcurrentMonth=startDT.daysBetween(endDT);
                         if(DaysoFcurrentMonth<90)
                         {
                            tableFlag =true;                        
                            AttendanceList= attendanceService.getAttendanceDetails(startDT,endDT);
                            dateDetails();
                            AttendanceMemberList =getMemberWrappper();
                         }else
                         {
                            tableFlag =false;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_DATE_DIFF_90));        
                         }
                    }else{
                        tableFlag =false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SMALLER_END_DATE));           
                    }
                }else{
                    tableFlag =false;   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_FUTURE_DATE_NOT_ACCEPT));              
                }       
        }else{          
            startDT = System.today().toStartOfMonth();
            endDT = startDT.addDays(Date.daysInMonth(startDT.year(), startDT.month()) - 1); 
            tableFlag =true;
            AttendanceList= attendanceService.getAttendanceDetails(startDT,endDT);
            dateDetails(); 
            AttendanceMemberList =getMemberWrappper();
        }                       
        return null;
    }
    
    //List of Date Details
    public List<Date> dateDetails()
    {   
        DatesFrntEnd =new List<Date>();     
        Date firstDayOfMonth;
        Date lastDayOfMonth;
        Date NewStartDate;
        Integer DaysoFcurrentMonth;
        Integer count=0;
        
        if(shiftAttedanceDetails.Start_Date__c !=null &&  shiftAttedanceDetails.End_Date__c!=null)
        {
            firstDayOfMonth = shiftAttedanceDetails.Start_Date__c;
            lastDayOfMonth = shiftAttedanceDetails.End_Date__c;
        }else{      
            firstDayOfMonth = System.today().addDays(-29);  
            lastDayOfMonth = System.today();
        }
        
        DaysOfcurrentMonth=firstDayOfMonth.daysBetween(lastDayOfMonth);
        NewStartDate = lastDayOfMonth;       
        for(integer i=0; i<=DaysOfcurrentMonth; i++){
            DateTime ReqmtAssignDt=lastDayOfMonth;
            Date ReqmAssignDate=Date.NewInstance(ReqmtAssignDt.year(), ReqmtAssignDt.month(), ReqmtAssignDt.day());
            if(ReqmAssignDate == NewStartDate){
                count ++;
            }            
            DatesFrntEnd.add(firstDayOfMonth.addDays(i));
        }
        return DatesFrntEnd;
    }   
    
    //Wrapper Class for Member and Attendance Records
    public List<WrapperMember> getMemberWrappper(){

        Integer  TotalPresnt=0;
        Integer  TotalAbsent=0;
        Integer  TotalLeave=0;
        Integer TotalNoAttendance=0;
        Integer TotalDeputed=0;
        Integer TotalNoWork=0;
        
        
        Integer DaysoFcurrentMonth;        
        startDT = shiftAttedanceDetails.Start_Date__c;
        endDT = shiftAttedanceDetails.End_Date__c;
        
        List<Profile> PROFILE = queryObj.getProfiles();
         MyProflieName = PROFILE[0].Name; 
         if(MyProflieName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && MyProflieName != 'Country Administrator'){
             member = queryObj.getMember();
         }
         system.debug('Test the Member Details : ' + member);
        if(MyProflieName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME || MyProflieName == 'Country Administrator'){
            system.debug('CASE 1 Member List : ' + memberList);
             if(selectvalue==null)
             {
                system.debug('CASE 1.0 Member List : ' + memberList);
                CountTotalRecords = attendanceService.getMemberCount();
                memberList  = attendanceService.getMemberDetails(QueryLimit,OffsetSize);
             }
             else{
                system.debug('CASE 1.1 Member List : ' + memberList);
                CountTotalRecords = attendanceService.getMemberCount(selectvalue);
                memberList  = attendanceService.getMemberDetails(selectvalue,QueryLimit,OffsetSize);
             }
                     
        }else if(MyProflieName == EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME || MyProflieName == EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME || MyProflieName == EPMS_UTIL.EPMS_SHIFT_ADMIN_PROFILE_NAME){
            system.debug('CASE 2 Member List : ' + memberList);
            CountTotalRecords = attendanceService.getMemberCount(member.Location_id__c);
            memberList  = attendanceService.getMemberDetails(member.Location_id__c,QueryLimit,OffsetSize);            
        }
        system.debug(' Member List : ' + memberList);
        Date firstDayOfMonth;
        Date lastDayOfMonth;
        Date NewStartDate;
        if(startDT!=null && endDT!=null){
            firstDayOfMonth = startDT;
            lastDayOfMonth = endDT;         
            NewStartDate = firstDayOfMonth;
        }else{            
            firstDayOfMonth = System.today().addDays(-29);  
            lastDayOfMonth = System.today();             
            NewStartDate = lastDayOfMonth;          
        } 
        MemberWrappper = new list<WrapperMember>(); 
        
        List<Date> monthCheck = new List<Date>();
        DaysoFcurrentMonth=firstDayOfMonth.daysBetween(lastDayOfMonth);
        Date startDT=firstDayOfMonth;
        
        Integer count=0;
        for(integer i=0; i<=DaysoFcurrentMonth; i++){
        
            DateTime ReqmtAssignDt=lastDayOfMonth;
            Date ReqmAssignDate=Date.NewInstance(ReqmtAssignDt.year(), ReqmtAssignDt.month(), ReqmtAssignDt.day());
            if(ReqmAssignDate == NewStartDate){
                count ++;                
            }
            NewStartDate = firstDayOfMonth.addDays(i);
            monthCheck.add(firstDayOfMonth.addDays(i));
        }
        
        if(memberList != null && memberList.size() > 0){ 
            for(Member__c memberHolder:memberList){        
       
               Map<Integer, String> monthYearSet = new Map<Integer, String>();
               AttendanceList= attendanceService.getAttendanceDetails(memberHolder.Id,startDT,lastDayOfMonth);         
             
               Integer incr=0;
              
                for(Date checkdate:monthCheck){
                
                    if(AttendanceList.size() > 0 ){
                        
                        for(Shift_Attendance__c attendanceData : AttendanceList){
                        
                           if(checkdate==attendanceData.Attendance_Date__c && attendanceData.Attendance_Status__c==EPMS_UTIL.EPMS_LeaveStatus){
                                monthYearSet.put(incr,EPMS_UTIL.EPMS_LeaveStatus); 
                                TotalLeave=TotalLeave+1;
                                break;
                            }else if(checkdate==attendanceData.Attendance_Date__c && attendanceData.Attendance_Status__c==EPMS_UTIL.EPMS_AbsentStatus){
                                monthYearSet.put(incr,EPMS_UTIL.EPMS_AbsentStatus); 
                                TotalAbsent=TotalAbsent+1;
                                break;
                            }else if(checkdate==attendanceData.Attendance_Date__c && attendanceData.Attendance_Status__c==EPMS_UTIL.EPMS_DeputedStatus){
                                monthYearSet.put(incr,EPMS_UTIL.EPMS_DeputedStatus); 
                                TotalDeputed=TotalDeputed+1;
                                break;
                            }
                            else if(checkdate==attendanceData.Attendance_Date__c && attendanceData.Attendance_Status__c==EPMS_UTIL.EPMS_NWStatus){
                                monthYearSet.put(incr,EPMS_UTIL.EPMS_NWStatus); 
                                TotalNoWork=TotalNoWork+1;
                                break;
                            }else{                      
                                monthYearSet.put(incr,EPMS_UTIL.EPMS_PresentStatus); 
                                TotalPresnt=TotalPresnt+1;
                            }                       
                        }
                        incr++;
                        
                    }else{
                        for(Integer i=0;i<monthCheck.size();i++){
                            monthYearSet.put(i,EPMS_UTIL.EPMS_PresentStatus); 
                            TotalPresnt=TotalPresnt+1;
                        }
                    }
                }           
                
                MemberWrappper.add(new WrapperMember(memberHolder,monthYearSet,TotalPresnt,TotalAbsent,TotalLeave,TotalNoAttendance,TotalDeputed,TotalNoWork));  
               
                TotalPresnt=0;
                TotalAbsent=0;
                TotalLeave=0;
                TotalNoAttendance=0;
                TotalDeputed=0;
                TotalNoWork=0;
            }
        }
        return MemberWrappper;  
    }
    
    //Wrapper Class
    public with sharing class WrapperMember {
        public Member__c  memberHolder    { get;set; }
        public Map<Integer, String> userDays { get;set; }
        public Integer  TotalPresnt    { get;set; }
        public Integer  TotalAbsent    { get;set; }
        public Integer  TotalLeave    { get;set; }
        public Integer  TotalNoAttendance    { get;set; }
        public Integer  TotalDeputed    { get;set; }
        public Integer  TotalNoWork    { get;set; }
        
        
        
        public WrapperMember(Member__c memberHolder,Map<Integer, String> userDays ,Integer  TotalPresnt,Integer  TotalAbsent,Integer  TotalLeave,Integer  TotalNoAttendance,Integer TotalDeputed,Integer  TotalNoWork) {
            this.memberHolder=memberHolder;
            this.userDays=userDays ;
            this.TotalPresnt=TotalPresnt;
            this.TotalAbsent=TotalAbsent ;
            this.TotalLeave=TotalLeave ;
            this.TotalNoAttendance=TotalNoAttendance ;
            this.TotalDeputed=TotalDeputed ;
            this.TotalNoWork=TotalNoWork ;
            
        }
    }
    
    public Boolean getDisablePrevious(){
        if(OffsetSize>0){
            return false;
        }
        else return true;
    }
 
    public Boolean getDisableNext() {
        if (OffsetSize + QueryLimit < countTotalRecords){
            return false;
        }
        else return true;
    }
 
 //moving to next page
    public PageReference Next() {
        OffsetSize += QueryLimit;
        return null;
    }
 //mehtod moving previous page
    public PageReference Previous() {
        OffsetSize -= QueryLimit;
        return null;
    }
      
     // Selection option for location
     public List<SelectOption> getLocations(){     
          
         List <SelectOption> options  = new List<SelectOption>();
           options.add(new SelectOption('','--None--'));
         for(Location__c locations:queryObj.getLocations()){
            options.add(new SelectOption(locations.Id,locations.Name));
         }
        return options;
}
    }