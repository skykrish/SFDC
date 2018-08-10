public without sharing class CommonUtil {

   /**
    * 指定したオブジェクト内の指定した選択リスト項目の設定値をすべて取得する。
    *
    * @param objName オブジェクト名
    * @param fld 項目名
    * @return 選択リスト
    */
   public static list<Schema.PicklistEntry> getPicklistValues(String objName, String fld){
       List<Schema.PicklistEntry> pickList;
       Schema.SObjectType sobjtype = (Schema.SObjectType)Schema.getGlobalDescribe().get(objName);
       if(sobjtype != null){
           Map<String, Schema.SObjectField> fieldmap = sobjtype.getDescribe().fields.getMap();
           Schema.SObjectField f = (Schema.SObjectField)fieldmap.get(fld);
           if(f != null){
               Schema.DescribeFieldResult r = f.getDescribe();
               pickList = r.getPicklistValues();
           }
       }
       return pickList;
   }

   /**
    * 指定したオブジェクトの全項目を取得するクエリを生成する
    *
    * @param objName オブジェクト名
    * @return 全項目取得用クエリ
    */
   public static String getSelectAllQuery(String objName) {
       return getSelectAllQuery(objName, new List<String> ());
   }

   /**
    * 指定したオブジェクトの全項目＋追加項目を
    * 取得するクエリを生成する
    *
    * @param objName オブジェクト名
    * @param addColumns 追加項目
    * @return 全項目取得用クエリ
    */
    public static String getSelectAllQuery(String objName, List<String> addColumns) {

        String fieldsString = '';
        String commaString = '';

        // SObject Describe
        Schema.DescribeSObjectResult obj = Schema.getGlobalDescribe().get(objName).getDescribe();

        // Fieldマップ取得
        Map<String, Schema.SObjectField> fieldMap = obj.fields.getMap();
        for(Schema.SObjectField item : fieldMap.values()) {
            if (item.getDescribe().getName() == 'BillingAddress' 
                || item.getDescribe().getName() == 'ShippingAddress'
                || item.getDescribe().getName() == 'OtherAddress'
                || item.getDescribe().getName() == 'MailingAddress'
                ){
                continue;
            }
            fieldsString += commaString + item.getDescribe().getName();
            commaString = ',';
        }

        // 追加項目
        for (String item : addColumns) {
            fieldsString += commaString + item;
        }

        return 'SELECT ' + fieldsString + ' FROM ' + objName;
    }

    /**
     * sObjectを指定した項目でソートをかける
     *
     * @param items SObject
     * @param sortField 項目名
     * @param order ソート順
     */
    public static void sortList(List<Sobject> items, String sortField, String order){
        List<Sobject> resultList = new List<Sobject>();
        Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
        for(Sobject ob : items){
            if(objectMap.get(ob.get(sortField)) == null){
                objectMap.put(ob.get(sortField), new List<Sobject>());
            }
            objectMap.get(ob.get(sortField)).add(ob);
        }

        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();

        for(object key : keys){
            resultList.addAll(objectMap.get(key));
        }
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(Sobject ob : resultList){
                items.add(ob);
            }
        }
        else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);
            }
        }
    }
    
    /**
     * CSV取込み_Shift-jisファイルを受け入れる
     * http://vaindespair.blogspot.jp/2012/07/blog-post_26.html
     * @return Windows-31Jに変換した文字列
     */
    public static String convertedString(Blob inSource) {
        String hex = EncodingUtil.convertToHex(inSource);
        String result2 = '%';
        Integer hexSize = 300000;
        Integer qu = hex.length() / hexSize;
        Integer j = 0;
        while(true) {
            if(j >= qu) {
                if(j == qu) {
                    result2 += hex.substring(j*hexSize).replaceAll('[[0-9][a-fA-F]]{2}', '$0%');
                    result2 = result2.substring(0, result2.length()-1);
                }
                break ;
            } else {
                result2 += hex.substring(j*hexSize,
                (j+1)*hexSize).replaceAll('[[0-9][a-fA-F]]{2}', '$0%');
            }
            j++;
        }    
        return EncodingUtil.urlDecode(result2, 'Windows-31J');
    }

}