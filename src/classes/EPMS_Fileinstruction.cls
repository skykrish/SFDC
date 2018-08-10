/**********************************************************************************
*   Class               :       EPMS_Fileinstruction                              *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       To download file instruction attachments          *
**********************************************************************************/

public class EPMS_Fileinstruction
{
  
    public String orderID{get;set;}
    public String orderName{get;set;}  
    public Files__c SelectedFile {get;set;}
    public list<Files__c> instructionfile {get;set;}            
    public list<Production_Order__c> Podetails {get;set;}
    public string ids {get;set;}
    public string basepath {get;set;}
    public string myUrl{get;set;}
    public string InstructionFiles{get;set;}
    public list<string> InstructionFileNames{get;set;}
    public list<WrapperFiles> Filesinstructions{get;set;}
    public string Selectfilename{get;set;}
     public string PreviewIP {get;set;}
     public Production_order__c SelectedOrder{get;set;}
            
    public EPMS_Fileinstruction()
    {
        ids=ApexPages.currentPage().getParameters().get('id');
        basepath = ApexPages.currentPage().getParameters().get('type'); 
        Filesinstructions = new list<WrapperFiles>();
        list<GroupMember> AllSalesRegion = new list<GroupMember>();  
        list<Settings__c> settingsusers = new list<Settings__c>();
        SelectedFile = new Files__c();
        
        if(!string.isEmpty(ids)){
            SelectedFile = [select id,Name,InstructionNames__c,Production_Order__c,Production_Order__r.Name,File_Preview_URL__c,Parent_id__c from Files__c where id=:ids ];
        }
        
        orderID = null;
        orderName = null;
        Selectfilename= null;
        InstructionFiles = null;  
        if(SelectedFile!=null){
            orderID = SelectedFile.Production_Order__c;
            orderName = SelectedFile.Production_Order__r.Name; 
            InstructionFiles=SelectedFile.InstructionNames__c;
            Selectfilename = SelectedFile.Name;                  
        }
        SelectedOrder = new Production_order__c();
         if(!string.isEmpty(orderID)){
            SelectedOrder = [select id,Name,Mbo_Location__c,User__c from Production_order__c where id=:orderID ];
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
        
        InstructionFileNames = new list<string>();
        InstructionFileNames = InstructionFiles.split(',');
        system.debug('-----InstructionFileNames-----'+InstructionFileNames);
        Podetails = new list<Production_order__c>();
        if(orderID!=null){
        Podetails = [select id,Name from Production_order__c where id =:orderID Limit 1];
        }
        instructionfile = new list<Files__c>();
        if(InstructionFileNames.size()>0){
            instructionfile = [select id,Name,Production_Order__r.Name,File_Preview_URL__c,Parent_Id__c  from Files__c where Production_order__c =:orderID and File_type__c='File instruction' and id IN : InstructionFileNames ];
            system.debug(instructionfile.size()+'----------'+instructionfile);
           
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