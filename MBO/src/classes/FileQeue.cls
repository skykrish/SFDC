public class FileQeue implements Queueable {
 
private List<id> estProdOrder = new List<id>();
private List<Files__C> updateEstFiles = new List<Files__C>();

        public FileQeue(List<id> pos){
         
        this.estProdOrder = pos;
        
        }
        
        public void execute(QueueableContext queCont){
                
            system.debug('---------------'+estProdOrder);
            
            for(files__c estfile:[select id , status__c from files__c where production_order__c=:estProdOrder])
                {
                    system.debug('-------------estfile-------');
                    estFile.status__c =  Label.EPMS_FileStatus_Estimation_Request;
                    
                    updateEstFiles.add(estFile);

                }
                 system.debug('---------------'+updateEstFiles);
                 if(updateEstFiles.size()>0){
                     update updateEstFiles;
                 }
        }



}