/**********************************************************************************
*   Class               :       EPMS_AddPerformanceRating                         *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Used to create Performance from Performance
                                 rating Tab                                       *
**********************************************************************************/

public class EPMS_AddPerformanceRating{

public string valueName{set;get;}
public list<string> inputDetails {set;get;}
public list<File_Categories__c> categoryList{get;set;}
public List<Wrapperclass> performWrap  { set;get;} 
public EPMS_PerformanceRating_Service servClass = new EPMS_PerformanceRating_Service();//calling service Class

public EPMS_AddPerformanceRating(ApexPages.StandardController controller){
categoryList = new list<File_Categories__c>();
categoryList= servClass.getCategoryList();
performWrap = new list<Wrapperclass>(); 
    for(File_Categories__c FC : categoryList)
    {
       String VMin='';
       String Vmax='';
       performWrap.add(new Wrapperclass(FC,VMin,Vmax));   //adding all Categories to Wrapper Class 
    }     
       }
     //method to save Performance rating values
    public pagereference saveChanges() {
        Decimal min ;
        Decimal max ;
        Boolean ErrorFlag = true;
        list<Performance_Rating__c> performInsert = new list<Performance_Rating__c>();
        list<Performance_Rating__c> performInsertOnlyName = new list<Performance_Rating__c>();
        list<Performance_Rating__c> GROUPNAMECHECk = new list<Performance_Rating__c>();

        GROUPNAMECHECk= servClass.checkgroupname(valueName);
        
       //checking Min values and max values
        if(!String.isEmpty(valueName)){
            if(GROUPNAMECHECk.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ADD_PERFORMANCE_GROUP_ALREADY_EXISTS));
            }else{
                for(Wrapperclass perform: performWrap){  
                     string minS = perform.valuemin;
                     string maxS = perform.valuemax; 

                     if(String.isEmpty(minS) && !String.isEmpty(maxS)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ADD_PERFORMANCE_ENTER_CATEGORY_MIN_VALUE+perform.CategoryName.Name +''));
                            ErrorFlag = false;
                            return null; 
                     }
                     
                     if(!String.isEmpty(minS) && String.isEmpty(maxS)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ADD_PERFORMANCE_ENTER_CATEGORY_MAX_VALUE+perform.CategoryName.Name +''));
                            ErrorFlag = false;
                            return null; 
                     }
                     if(!String.isEmpty(minS)&&!String.IsEmpty(maxS)){
                        Decimal mincheck ;
                        Decimal maxcheck ;
                        try{
                            mincheck = Decimal.ValueOf(minS);
                            maxcheck = Decimal.ValueOf(perform.valuemax);
                         } catch (System.Exception e){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                            ErrorFlag = false;
                            return null;  
                         } 
                        min= Decimal.ValueOf(minS);
                        max  = Decimal.valueOf(perform.valuemax);
                       
                        if(min>max){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ADD_PERFORMANCE_MIN_VALUE_LESS_THAN_MAX_VALUE+perform.CategoryName.Name +''));
                            ErrorFlag = false;
                            return null;
                        }else if(min==max){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ADD_PERFORMANCE_MIN_VALUE_NOT_EQUAL_TO_MAX_VALUE+perform.CategoryName.Name +''));
                            ErrorFlag = false;
                            return null;
                        }
                        else if(min==null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ADD_PERFORMANCE_MIN_MAX_VALUE_SHOULD_NOT_EMPTY+perform.CategoryName.Name +''));
                            ErrorFlag = false;
                            return null;
                        }

                        else{

                            if(!String.isEmpty(minS)&&!String.IsEmpty(maxS)){
                                Performance_Rating__c Per = new Performance_Rating__c(); 
                                Per.Name=valueName;
                                per.File_Category__c=perform.CategoryName.id;
                                per.File_Performance_Stf_Min__c= min ;
                                per.File_Performance_Stf_Max__c= max ;
                                performInsert.add(Per);
                            }

                        }
                    }else{
                        Performance_Rating__c Per = new Performance_Rating__c(); 
                        Per.Name=valueName;
                        performInsertOnlyName.add(per); 

                    }
                }
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ADD_PERFORMANCE_PLEASE_ENTER_GROUP_NAME));
        }
        
        if(performInsertOnlyName.size()>0 && min == null && max == null)
        {
            insert performInsertOnlyName[0];
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_ADD_PERFORMANCE_RATING_CREATED_SUCCESS+ valueName +'')); 
        }


        if(performInsert.size()>0&&ErrorFlag==true)
        {
            try{
                insert performInsert;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_ADD_PERFORMANCE_RATING_CREATED_SUCCESS+ valueName +'')); 
                valueName=null;
                min = null;
                max = null; 
            } catch (DmlException e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, e.getMessage())); 
                return null;
            }
            
           
        
        }
        valueName=null;
         if(performWrap.size() > 0){
                for(Wrapperclass perform:performWrap){
                     perform.valuemin = null;
                     perform.valuemax= null;
                }
            }
        
        return null;
 
    }
    
//define wrapper class Structure    
public class Wrapperclass{
 public File_Categories__c CategoryName   { get; set; } 
 public String valuemin   { get; set; } 
 public String valuemax   { get; set; } 
 
  public Wrapperclass(File_Categories__c a,String VMin,String VMax) {
           CategoryName   = a;
           valuemin=VMin;
           valuemax=VMax;
        }
 
 
 }
 
 public pagereference Reset(){
    
    PageReference newpage = new PageReference('/apex/EPMS_AddPerformanceRating');    
    newpage.getParameters().clear();
    newpage.setRedirect(true);
    return newpage;
  }


}