/**********************************************************************************
*   Class               :       clsTest_EPMS_MultiselectController                *
*   Created Date        :       12/04/2016                                        *
*   Description         :       Test Class for EPMS_MultiselectController         *
**********************************************************************************/
@isTest
private class clsTest_EPMS_MultiselectController {
    static testMethod void testMultiselectController() {
        MultiselectController c = new MultiselectController();
        
        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();

        c.leftOptionsHidden = 'A&a&b&b&C&c';
        c.rightOptionsHidden = '';
        
        System.assertEquals(c.leftOptions.size(), 3);
        System.assertEquals(c.rightOptions.size(), 0);
    }
}