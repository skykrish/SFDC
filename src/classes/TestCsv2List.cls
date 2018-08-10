/**
 * TestCsv2Listクラス用テストクラス
 */
@isTest
private class TestCsv2List {

    static testMethod void testGetList() {

        //
        List<List<String>> csvList1;
        List<List<String>> csvList2;
        List<List<String>> csvList3;
        List<List<String>> tsvList;

        // variable
        String csvText1 = '10,11,12,\"TEST\"\r\n20,21,22,\"TEST\"\r\n30,31,32,\"TEST\"\r\n';
        String csvText2 = '10,11,12,\"TEST\"\r20,21,22,\"TEST\"\r30,31,32,\"TEST\"\r';
        String csvText3 = '10,11,12,\"TEST\"\n20,21,22,\"TEST\"\n30,31,32,\"TEST\"\n';
        String tsvText = '10\t11\t12\t\"TEST\"\r\n20\t21\t22\t\"TEST\"\r\n30\t31\t32\t\"TEST\"\r\n';

        // test
        Test.startTest();
        csvList1 = Csv2List.getList(csvText1);
        csvList2 = Csv2List.getList(csvText2);
        csvList3 = Csv2List.getList(csvText3);
        tsvList = Csv2List.getList(tsvText, Csv2List.DELIMITER_TYPE_TAB);
        Test.stopTest();

        // check - csvText1
        System.assert(csvList1.size() == 3);
        System.assert(csvList1.get(0).get(0) == '10');
        System.assert(csvList1.get(0).get(1) == '11');
        System.assert(csvList1.get(0).get(2) == '12');
        System.assert(csvList1.get(0).get(3) == 'TEST');
        System.assert(csvList1.get(2).get(3) == 'TEST');
        // check - csvText2
        System.assert(csvList2.size() == 3);
        System.assert(csvList2.get(0).get(0) == '10');
        System.assert(csvList2.get(0).get(1) == '11');
        System.assert(csvList2.get(0).get(2) == '12');
        System.assert(csvList2.get(0).get(3) == 'TEST');
        System.assert(csvList2.get(2).get(3) == 'TEST');
        // check - csvText3
        System.assert(csvList3.size() == 3);
        System.assert(csvList3.get(0).get(0) == '10');
        System.assert(csvList3.get(0).get(1) == '11');
        System.assert(csvList3.get(0).get(2) == '12');
        System.assert(csvList3.get(0).get(3) == 'TEST');
        System.assert(csvList3.get(2).get(3) == 'TEST');
        // check - tsvText3
        System.assert(tsvList.size() == 3);
        System.assert(tsvList.get(0).get(0) == '10');
        System.assert(tsvList.get(0).get(1) == '11');
        System.assert(tsvList.get(0).get(2) == '12');
        System.assert(tsvList.get(0).get(3) == 'TEST');
        System.assert(tsvList.get(2).get(3) == 'TEST');
    }

	static testMethod void testGetListEasy() {

        //
        List<List<String>> csvList1;
        List<List<String>> csvList2;
        List<List<String>> csvList3;
        List<List<String>> csvList4;
        List<List<String>> csvList5;
        List<List<String>> csvList6;

        // variable
        String csvText1 = '10,11,12,\"TEST\"\r\n20,21,22,\"TEST\"\r\n30,31,32,\"TEST\"\r\n';
        String csvText2 = '10,11,12,\"TEST\"\r20,21,22,\"TEST\"\r30,31,32,\"TEST\"\r';
        String csvText3 = '10,11,12,\"TEST\"\n20,21,22,\"TEST\"\n30,31,32,\"TEST\"\n';
        String csvText4 = null;
        String csvText5 = '10,11,12';
        String csvText6 = '10\t11\t12\t\"TEST\"\r\n20\t21\t22\t\"TEST\"\r\n30\t31\t32\t\"TEST\"\r\n';

        // test
        Test.startTest();
        csvList1 = Csv2List.getListEasy(csvText1);
        csvList2 = Csv2List.getListEasy(csvText2);
        csvList3 = Csv2List.getListEasy(csvText3);
        csvList4 = Csv2List.getListEasy(csvText4);
        csvList5 = Csv2List.getListEasy(csvText5);
        csvList6 = Csv2List.getListEasy(csvText6, Csv2List.DELIMITER_TYPE_TAB);
        Test.stopTest();

        // check - csvText1
        System.assert(csvList1.size() == 3);
        System.assert(csvList1.get(0).get(0) == '10');
        System.assert(csvList1.get(0).get(1) == '11');
        System.assert(csvList1.get(0).get(2) == '12');
        System.assert(csvList1.get(0).get(3) == 'TEST');
        System.assert(csvList1.get(2).get(3) == 'TEST');
        // check - csvText2
        System.assert(csvList2.size() == 3);
        System.assert(csvList2.get(0).get(0) == '10');
        System.assert(csvList2.get(0).get(1) == '11');
        System.assert(csvList2.get(0).get(2) == '12');
        System.assert(csvList2.get(0).get(3) == 'TEST');
        System.assert(csvList2.get(2).get(3) == 'TEST');
        // check - csvText3
        System.assert(csvList3.size() == 3);
        System.assert(csvList3.get(0).get(0) == '10');
        System.assert(csvList3.get(0).get(1) == '11');
        System.assert(csvList3.get(0).get(2) == '12');
        System.assert(csvList3.get(0).get(3) == 'TEST');
        System.assert(csvList3.get(2).get(3) == 'TEST');
        // check - csvText4
        System.assert(csvList4.size() == 0);
        // check - csvText5
        System.assert(csvList5.size() == 1);
        System.assert(csvList5.get(0).get(0) == '10');
        System.assert(csvList5.get(0).get(1) == '11');
        System.assert(csvList5.get(0).get(2) == '12');
        // check - csvList6
        System.assert(csvList6.size() == 3);
        System.assert(csvList6.get(0).get(0) == '10');
        System.assert(csvList6.get(0).get(1) == '11');
        System.assert(csvList6.get(0).get(2) == '12');
        System.assert(csvList6.get(0).get(3) == 'TEST');
        System.assert(csvList6.get(2).get(3) == 'TEST');
    }
}