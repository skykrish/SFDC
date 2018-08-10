/**********************************************************************************
*   Class               :       EPMS_CheckRecursiveRemoveOrder                    *
*   Created Date        :       26/03/2018                                        *           
*   Description         :       Class for avoid recurive in trigger               *
**********************************************************************************/

public Class EPMS_CheckRecursiveRemoveOrder
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