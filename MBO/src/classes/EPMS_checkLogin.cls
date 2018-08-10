/****************************************************************************
*   Class               :       EPMS_checkLogin                             *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       Controller for checking the current user
                                having member or not. If the user have no 
                                member it will not allow to login           *
/***************************************************************************/
public class EPMS_checkLogin{

    public List<Member__c> MemberList {get;set;}   
    public String MyProflieName  {get;set;}
    public  Integer CheckSize {get;set;}
    //constructor
    public EPMS_checkLogin(){
        CheckSize=0;        
        MemberList=[Select Id  From Member__c where User_Id__c=:UserInfo.getUserId() and Status__c='Active'];
        CheckSize = MemberList.size(); 
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        MyProflieName = PROFILE[0].Name;
        // check logged in user profiles other than system admin and sales region
        if(CheckSize==0 && (MyProflieName=='System Administrator' || MyProflieName=='Sales Region')){
            CheckSize=1;
        }
        
        
    }
    
}