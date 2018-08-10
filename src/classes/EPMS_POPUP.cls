/**********************************************************************************
*   Class               :       EPMS_POPUP                                        *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       To Display popup                                  *
**********************************************************************************/
public class EPMS_POPUP
{
    public string ids{get;set;}
    
    public EPMS_POPUP()
    {    
        ids=ApexPages.currentPage().getParameters().get('ids');
    }
}