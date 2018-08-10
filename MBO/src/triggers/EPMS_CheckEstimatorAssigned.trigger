/************************************************************************************
*   Class               :       EPMS_CheckEstimatorAssigned                     	*
*   Created Date        :       18/01/2018                                          *           
*   Description         :       Validation Error when uncheck IsEstimator checkbox	*
************************************************************************************/
trigger EPMS_CheckEstimatorAssigned on Member__c (before update) {
    for(Member__c mem:Trigger.New)
    {
         if(Trigger.oldmap.get(mem.id). Is_Estimator__c != Trigger.newmap.get(mem.id).Is_Estimator__c && Trigger.newmap.get(mem.id).Is_Estimator__c == false)
         {
             integer  file_List= [select count() from Files__c where status__c= 'Estimator Assigned' and Estimator__c =:mem.id];
             if(file_List > 0){
                 mem.addError('Files are still assigned to the user please clear all the files ');
             }
         }
    }

}