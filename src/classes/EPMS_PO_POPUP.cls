/**********************************************************************************
*   Class               :       EPMS_PO_POPUP                                     *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       To Display popup                                  *
**********************************************************************************/
public class EPMS_PO_POPUP
{
    public string ids{get;set;}
    
    public EPMS_PO_POPUP()
    {    
        ids=ApexPages.currentPage().getParameters().get('ids');
    }
}