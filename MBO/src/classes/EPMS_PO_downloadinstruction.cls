/**********************************************************************************
*   Class               :       EPMS_PO_downloadinstruction                       *
*   Created Date        :       18/04/2016                                        *
*   Description         :       Class for Download Production order instruction   *
**********************************************************************************/

public class EPMS_PO_downloadinstruction
{

    public String orderID{get;set;}
    public String orderName{get;set;}
    public Production_order__c SelectedOrder {get;set;}
    public list<Files__c> instructionfile {get;set;} 
    public string ids {get;set;}
    public string basepath {get;set;}
    public string myUrl{get;set;}
    public string Selectfilename {get;set;}
    public string ThumbnailIP{get;set;}
    public string PreviewIP {get;set;}
    public list<WrapperFiles> Filesinstructions{get;set;}    
              
    public EPMS_PO_downloadinstruction()
    {
        ids=ApexPages.currentPage().getParameters().get('id');
        basepath = ApexPages.currentPage().getParameters().get('type'); 
        Filesinstructions = new list<WrapperFiles>();
        list<GroupMember> AllSalesRegion = new list<GroupMember>();  
        list<Settings__c> settingsusers = new list<Settings__c>();
        SelectedOrder = new Production_order__c();
        if(!string.isEmpty(ids)){
            SelectedOrder = [select id,Name,Mbo_Location__c,User__c from Production_order__c where id=:ids ];
        }
        orderID = null;
        orderName = null;
        Selectfilename= null;

        if(SelectedOrder!=null){
            orderID = SelectedOrder.id;
            orderName = SelectedOrder.Name; 
            Selectfilename= SelectedOrder.Name;            
        }
           
               
              if(SelectedOrder!=null){
                  AllSalesRegion= [Select Id, UserOrGroupId,Group.Name From GroupMember Where UserOrGroupId =:SelectedOrder.User__c];
                  }
                
                       if(SelectedOrder!=null&&AllSalesRegion.size()>0){
                      settingsusers = [select id,Name,file_server_nodejs_port_ins_file_access__c,file_server_nodejs_port_thumbnail_access__c,file_server_host__c from Settings__c where Location__c=:SelectedOrder.Mbo_Location__c AND Group_Name__c=:AllSalesRegion[0].Group.Name ];
                    }
                    
                    if(settingsUsers.size()>0)
                    {
                    PreviewIP=settingsusers[0].file_server_host__c+':'+settingsusers[0].file_server_nodejs_port_ins_file_access__c;
                    }

        instructionfile = new list<Files__c>();
        if(orderID!=null){
            instructionfile = [select id,Name,Production_Order__r.Name,File_Preview_URL__c,Parent_Id__c  from Files__c where Production_order__c =:orderID and File_type__c='Order instruction' ];                 
           
           // obj.Name='Order Instructions';
            for(Files__c FT :instructionfile ){
             WrapperFiles obj = new WrapperFiles();
            obj.ImagesFiles= FT.Name;
            obj.instructionFiles='http://'+PreviewIP+'/'+FT.File_Preview_URL__c;
            Filesinstructions.add(obj); 
            }
                            
        }
          
    
    }
    
    public PageReference gotoURL(){
    
        myUrl = ApexPages.CurrentPage().getParameters().get('myUrl');
        pageReference pr = new pageReference(myUrl);
        pr.setRedirect(true);
        return pr;        
    }
    
    public class WrapperFiles  {    
      //  public String Name{get;set;}
         public String ImagesFiles{get;set;}
         public  String instructionFiles {get;set;}
         
            public WrapperFiles(String FilesNames,String INSFiles) {
               // this.Name =  instructionname;
                this.ImagesFiles=FilesNames;
                this.instructionFiles = INSFiles;               
            }           
            public WrapperFiles(){}        
    }
}