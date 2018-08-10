/**********************************************************************************
*   Class               :       EPMS_CheckRecursive_SOCF_SRCF                     *
*   Created Date        :       13/01/2018                                        *           
*   Description         :       Class for avoid recurive in trigger               *
**********************************************************************************/
public with sharing class EPMS_CheckRecursive_SOCF_SRCF {
    private static boolean run = true;
   
    public static boolean FileStatusTrigger;
    public static boolean fileBasedFolderTrigger;
    
    public static boolean runOnce()
    {
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    public static boolean isFutureUpdate;    
}