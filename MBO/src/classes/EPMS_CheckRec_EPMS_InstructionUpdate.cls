public Class EPMS_CheckRec_EPMS_InstructionUpdate
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