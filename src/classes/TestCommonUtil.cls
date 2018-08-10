/**
 * CommonUtilテストクラス
 */
@isTest
private class TestCommonUtil {

    /**
     * 正常系 全メソッド呼び出し
     */
    static testMethod void myUnitTest() {
        // テスト開始
        test.startTest();
        CommonUtil.getPicklistValues('Account', '業種');
        CommonUtil.getPicklistValues('Account', 'Name');
        CommonUtil.getSelectAllQuery('Account');
        CommonUtil.getSelectAllQuery('Contact');
        CommonUtil.getSelectAllQuery('Contact', new List<String>{'test'});
        CommonUtil.sortList(new List<Account>{new Account(Name = 'test')}, 'Name', 'asc');
        CommonUtil.sortList(new List<Account>{new Account(Name = 'test')}, 'Name', 'desc');
        test.stopTest();
    }
}