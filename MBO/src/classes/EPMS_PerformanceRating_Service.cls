/**********************************************************************************
*   Class               :       EPMS_PerformanceRating_Service                    *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       service class between performace rating and
                                performance ratingQuery locator classes           *
**********************************************************************************/

public class EPMS_PerformanceRating_Service {
    EPMS_PerformanceRating_Querylocator query = new EPMS_PerformanceRating_Querylocator();

    public list<Performance_Rating__c>  getGroupName(string Gname)
    {
        list<Performance_Rating__c> GROUPNAMECHECk = new list<Performance_Rating__c>();
        GROUPNAMECHECk=query.getGroupNamequery(Gname);
        return GROUPNAMECHECk;
    }
    
    public list<Performance_Rating__c> getCatList()
    {
        List<Performance_Rating__c> CatListPer = query.getquerycatlist();
        return CatListPer;
    }
    
    public list<File_Categories__c> getAllCategory()
    {
        List<File_Categories__c> CatList = query.getqueryAllCategory();
        return CatList;
    }
    public list<Performance_Rating__c> getAllPerformName()
    {
        List<Performance_Rating__c> PCatList = query.getqueryAllPerformName();
        return PCatList;
    }
    
    public list<Performance_Rating__c> getPerform(set<string> Pname)
    {
        List<Performance_Rating__c> performlist = query.getqueryPerform(Pname);
        return performlist;
    }
    
    public List<Performance_Rating__c> getCategoryDeleteList(String groupName, Set<String> tobeDeletedCatNames){
        List<Performance_Rating__c> performDellist = query.getCategoryDeleteList(groupName,tobeDeletedCatNames);
        return performDellist ;
    }
    
    public Integer checkPerformanceExists(String groupName){
        Integer groupRecordCount = query.checkPerformanceExists(groupName);
        return groupRecordCount;
    }
    
    public List<Performance_Rating__c> getAllPerformanceRatingList(String Groupname){
        List<Performance_Rating__c> allPerformlist = query.getAllPerformanceRatingList(Groupname);
        return allPerformlist;
    }
    
    public list<File_Categories__c> getCategoryList()
    {
        list<File_Categories__c> allcat = query.getCategoryList();
        return allcat;
    }
    
    public  list<Performance_Rating__c> checkgroupname(string enteredname)
    {
        list<Performance_Rating__c> groupname = query.checkgroupname(enteredname);
        return groupname;
    }
    


}