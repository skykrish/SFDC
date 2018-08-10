/**********************************************************************************
*   Class               :       EPMS_FilePOPUP                                    *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller class for display file popup       *
**********************************************************************************/
public class EPMS_FilePOPUP
{
    public string ids{get;set;}
    
    public EPMS_FilePOPUP()
    {    
        ids=ApexPages.currentPage().getParameters().get('ids');
    }
}