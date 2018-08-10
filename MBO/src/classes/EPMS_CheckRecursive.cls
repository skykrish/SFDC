/**********************************************************************************
*   Class               :       EPMS_CheckRecursive                               *
*   Created Date        :       31/07/2016                                        *           
*   Description         :       Class for avoid recurive in trigger               *
**********************************************************************************/

public Class EPMS_CheckRecursive
{
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