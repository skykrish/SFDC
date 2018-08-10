/****************************************************************************
*   Class               :       ProdIncentive Settings Service              *
*   Created Date        :       11/09/2015                                  *           
*   Description         :       To Communicate with the  query locator      *
*                               and return the fetched result set           *
*                                                                           *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/

public class EPMS_ProductionIncentiveService{
    
    EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
    public List<profile> profileList = null;
    public List<File_Categories__c> incentiveList = null;
    public List<Location__c> locationList = null;
    public Member__c member = null;
    public Location__c locobj = null;
    public string selLoc{public set;public get;}
    
    //To Fetch List Of Profiles
    public List<profile> getProfiles(){
        profileList = queryObj.getProfiles();
        String MyProflieName = profileList[0].Name;
        return profileList;
    }
    
    //Get List of Members
    public Member__C getMember(){
        member = queryObj.getMember();
        return member;
    }
    
    //Get List Production Incentive Based on location
    public List<File_Categories__c> getIncentiveList(){
        incentiveList  = queryObj.getIncentiveList();
        return incentiveList;
    } 
     
    //Get List Production Incentive  Cost Based on location
    public location__c getCostByLoc(Id locId){
        locObj = queryObj.getCostByLoc(locId); 
        return locObj;
    }
    
    //To get all Location 
    public List<Location__c> getLocations(){
        locationList = queryObj.getLocations();
        return locationList;
    }    
}