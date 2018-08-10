/**********************************************************************************
*   Class               :       EPMS_CheckRecursive                               *
*   Created Date        :       31/07/2016                                        *           
*   Description         :       Class for avoid recurive in trigger               *
**********************************************************************************/

public Class EPMS_CheckRecursive_stus
{
   
    private static integer hit = 0;
 
     public static boolean runTwice()
    {
    
    if(hit < 2 ){
    
    hit++;
    return true;
    }else{
    return false;
    }
        
        
    }
    
    
    
    
}