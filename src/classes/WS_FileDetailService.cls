/*************************************************************************************
*   Class               :       WS_FileDetailService                                 *
*   Created Date        :       13/04/2016                                           *           
*   Description         :       Webservice to get file details,performance,categories*
**********************************************************************************/ 
public class WS_FileDetailService {
    private List<Member__c> mem= new List<Member__c>();
    List<Files__c> files = new List<Files__c>();
    List<File_Categories__c> fc = new List<File_Categories__c>();
    List<File_Categories__c> Categories = new List<File_Categories__c>();
    List<Mistakes__c> mistakes = new List<Mistakes__c>();
    List<Job_Titles__c> jobTitles = new List<Job_Titles__c>();
    String EstimatorAssignedStatus = Label.EPMS_Status_Estimator_Assigned; // Estimated
    
    //Query to get getting QC Files
    public List<Files__c> getQCFile(string userId){

        mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId and status__c='Active' limit 1];

        if(mem[0] != null && mem[0].Designation__c == 'Quality Control'){
            files = [Select Name,File_Auto_Number__c, QC_Comments__c,  File_Job_Titles__c,Production_Order_Name__c,Parent_Id__c,No_of_the_file__c,Delivery_Extension__c,File_Location__c,File_Category_Code__c,File_Type__c,Status__c,File_old_Status__c,File_Proccessing_Status__c,TLInCharge__c,
            File_Thumbnail_URL__c,File_Preview_URL__c,File_URL__c,Files_To_open__c,Tracker_Crashed__c,Instruction__c,File_category_id__c,File_HandOver_Instructions__c,Is_File_Redo__c,Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c,File_Copy_number__c,Original_File_Id__c,Member__c,Member__r.Name,Member_Assigned__c,Current_Extension__c,File_PS_Version__c, QCIncharge__c
            from Files__c where   QCIncharge__c=:mem[0].id AND Status__c ='QC' AND Files_To_open__c=1 and file_type__c='image' ];
        }
        return files;
    }
    //Get files for current user
    public List<Files__c> getFile(string userId){

        mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId and Status__c='Active' limit 1];
        //EPMSSF-521 Changes - Included Order_Instructions__c and Image_Definition__c in select query
        if(mem[0] != null){
            files =  [Select Name,File_Job_Titles__c,QC_Comments__c,Production_Order_Name__c,Parent_Id__c,No_of_the_file__c,Delivery_Extension__c,File_Location__c,File_Category_Code__c,File_Type__c,Status__c,File_old_Status__c,File_Proccessing_Status__c,File_Auto_Number__c,TLInCharge__c, Order_Instructions__c, Image_Definition__c, 
            File_Thumbnail_URL__c,Files_To_open__c,File_Preview_URL__c,File_URL__c,Tracker_Crashed__c,Instruction__c,File_HandOver_Instructions__c,File_category_id__c,Is_File_Redo__c,Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c,File_Copy_number__c,Original_File_Id__c,Member__c,Member__r.Name,Member_Assigned__c,Current_Extension__c,File_PS_Version__c, QCIncharge__c
            from Files__c where Member__c=:mem[0].id AND (Status__c ='Redo Re-Assigned' OR Status__c ='Assigned') AND Files_To_open__c=1 and file_type__c='image' ];
        }else{
            files = null;
        }
        return files;
    }
    
    //Get Estimation Files

    public List<Files__c> getFilesforEstimation(string userId){
        system.debug('$$$$$$$ userId : ' + userId); 
        mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId and Status__c='Active' limit 1];
        
        if(mem[0] != null){
            files =  [Select Name,File_Job_Titles__c,QC_Comments__c,Production_Order_Name__c,Parent_Id__c,No_of_the_file__c,Delivery_Extension__c,File_Location__c,File_Category_Code__c,File_Type__c,Status__c,File_old_Status__c,File_Proccessing_Status__c,File_Auto_Number__c,TLInCharge__c, Order_Instructions__c, Image_Definition__c, 
            File_Thumbnail_URL__c,Files_To_open__c,File_Preview_URL__c,File_URL__c,Tracker_Crashed__c,Instruction__c,File_HandOver_Instructions__c,File_category_id__c,Is_File_Redo__c,Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c,File_Copy_number__c,Original_File_Id__c,Member__c,Member__r.Name,Member_Assigned__c,Current_Extension__c,File_PS_Version__c, QCIncharge__c, Estimator__c
            from Files__c where Estimator__c=:mem[0].id AND Status__c =:EstimatorAssignedStatus AND Files_To_open__c=1 and file_type__c='image' ];
        }else{
            files = null;
        }
        return files;
    }

    //Get Job Title
    public List<Job_Titles__c> getJobTitles(){
        
        //jobTitles = [SELECT Id, Name, Job_Type__c from Job_Titles__c order by Name asc];
        jobTitles = [SELECT Id, Name, Job_Type__c from Job_Titles__c where Disabled__c = false ORDER BY Name ASC];

        if(jobTitles != null){
            return jobTitles;
        }else{
            return null;
        }
    }

    public List<Mistakes__c> getMistakes(string UserId)
    {
        mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId and Status__c='Active' limit 1];
        if(mem[0] != null)
        {
            mistakes = [select id, Name , Mistake__c,Mistake_Category__c,Mistake_Description__c,Penalty_for_Artist__c,Penalty_for_QC__c,Skip_Penalty_Flag__c,Location__c,Mistake_Location__c from Mistakes__c where   Location__c =: mem[0].Location_id__c order by Mistake__c ASC ];
        }else{
            mistakes = null;
        }
        return mistakes;


    }

    public  List<File_Categories__c> getCategories(){

        system.debug('USER Name ****** :: ' + userinfo.getuserid());
        Member__c member =[select id,Name,User_Id__c,Performance_Rating__c,Performance_Rating__r.Name from Member__c where User_Id__c =:userinfo.getuserid() limit 1];
        
        if(member !=null){
            Categories=[select Id, Name,Standard_Time_per_File_Max__c,Standard_Time_per_File_Min__c FROM File_Categories__c];
        }else{
             Categories = null;
        }
        return Categories;
    }

/*  
    public  List<File_Categories__c> getCategories(){
        string Performance;
        set<id>ids = new set<id>();
        List<Performance_Rating__c> PerformanceRating = new List<Performance_Rating__c>();

        //get current login member Performance Rating

        Member__c member =[select id,Name,User_Id__c,Performance_Rating__c,Performance_Rating__r.Name from Member__c where User_Id__c =:userinfo.getuserid()];
        if(member !=null && member.Performance_Rating__c !=null){
            Performance=member.Performance_Rating__r.Name;
        }else{
             Categories = null;
        }

        if(Performance!=null){
            PerformanceRating=[select id,Name,File_Category__c,File_Performance_Stf_Max__c,File_Performance_Stf_Min__c from Performance_Rating__c where Name =: Performance];

            for(Performance_Rating__c Rating:PerformanceRating){
                ids.add(Rating.File_Category__c);
            }
            if(ids.size()>0){
                Categories=[select Name,Standard_OptionalCost_Parameter__c,Standard_OptionalCost_Per_Day__c,Standard_OptionalCost_Per_file__c,Standard_RegularCost_Per_Day__c,Standard_Regular_Cost_per_File__c,Standard_Target_Per_Day__c,Standard_Time_per_File_Max__c,Standard_Time_per_File_Min__c FROM File_Categories__c where id IN:ids];
            }else{
                Categories = null;
            }
        }
        return Categories;
    }
*/    
}