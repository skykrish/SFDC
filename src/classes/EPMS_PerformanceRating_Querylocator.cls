/**********************************************************************************
*   Class               :       EPMS_PerformanceRating_Querylocator               *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Query locator for performance rating service
                                and service class                                 *
**********************************************************************************/

public class EPMS_PerformanceRating_Querylocator {

    public list<Performance_Rating__c>  getGroupNamequery(string Gname)
    {
        list<Performance_Rating__c> GROUPNAMECHECk = new list<Performance_Rating__c>();
        GROUPNAMECHECk=[select Name From Performance_Rating__c where Name=:Gname Limit 1 ];
        return GROUPNAMECHECk;
    }

    public list<Performance_Rating__c> getquerycatlist()
    {
        List<Performance_Rating__c> CatListPer = [select Id,File_category__r.Name,File_category__c,Name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c from Performance_Rating__c ORDER BY File_category__r.Name ASC ];
        return CatListPer;
    }
    
    public list<File_Categories__c> getqueryAllCategory()
    {
        List<File_Categories__c> QCatList = [select id,Name  from File_Categories__c ORDER BY Name  ]; 
        return QCatList;
    }
    
    public list<Performance_Rating__c> getqueryAllPerformName()
    {
        List<Performance_Rating__c> QPCatList = [select Name from Performance_Rating__c];
        return QPCatList;
    }
    
    public list<Performance_Rating__c> getqueryPerform(set<string> Pname)
    {
        List<Performance_Rating__c> performlist = [select Id, Name, File_category__c, File_category__r.Name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c from Performance_Rating__c where Name =:Pname ORDER BY File_category__r.Name ASC ];
        return performlist;
    }


    public List<Performance_Rating__c> getCategoryDeleteList(String groupName, Set<String> tobeDeletedCatNames){
        List<Performance_Rating__c> deletePerformlist = null; 
        if(groupName != null && tobeDeletedCatNames != null && tobeDeletedCatNames.size() > 0){
            deletePerformlist = [select Id, Name from Performance_Rating__c WHERE name =: groupName AND File_category__r.Name IN : tobeDeletedCatNames];    
        }
    
        return deletePerformlist;
    }

    public Integer checkPerformanceExists(String groupName){
        List<Performance_Rating__c> tobeInsertPerformlist = new List<Performance_Rating__c>(); 
        if(groupName != null){
            tobeInsertPerformlist = [select Id, Name from Performance_Rating__c WHERE name=: groupName];    
        }
    
        return tobeInsertPerformlist.size();
    }
    
    public List<Performance_Rating__c> getAllPerformanceRatingList(String Groupname){
        List<Performance_Rating__c> allPerformlist = new List<Performance_Rating__c>();
        if(Groupname != null){
            allPerformlist = [select Id, File_category__r.Name,File_category__c,Name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c from Performance_Rating__c where name=:Groupname];    
        }
        return allPerformlist;    
    }  

    public list<File_Categories__c> getCategoryList()
    {
        list<File_Categories__c> allcat = new list<File_Categories__c>();
        allcat=[select Name from File_Categories__c ORDER BY Name ASC  ];
        return allcat;
    }

    public  list<Performance_Rating__c> checkgroupname(string enteredname)
    {
        list<Performance_Rating__c> groupname = new list<Performance_Rating__c>();
        groupname=[select Name From Performance_Rating__c where Name=:enteredname Limit 1 ];
        return groupname;
    }
  

}