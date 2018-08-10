public with sharing class Csv2List {

    // 定数
    public static String DELIMITER_TYPE_COMMA = ',';
    public static String DELIMITER_TYPE_TAB = '\t';
    public static String LINE_SEPARATOR_CR = '\r';
    public static String LINE_SEPARATOR_LF = '\n';
    public static String DOUBLE_QUATE = '\"';
    public static String HALF_BLANK = ' ';

    // CSVからList<String>に変換（デリミタ：カンマ）
    //　引数１のテキストに対して、カンマで区切られた各値のリストを作成し、
    //　それを含む行単位のリストを取得する
    //
    //　戻り値：各値のリストを含む、行単位のリスト
    // 引数１：CSVテキスト
    public static List<List<String>> getList (String csvText) {
        return getList(csvText, DELIMITER_TYPE_COMMA);
    }

    // CSVからList<String>に変換（デリミタ指定）
    //　引数１のテキストに対して、指定したデリミタで区切られた各値のリストを作成し、
    //　それを含む行単位のリストを取得する
    //
    //　戻り値：各値のリストを含む、行単位のリスト
    //　引数１：CSVテキスト
    //　引数２：デリミタ
    //　　　　　カンマを使用する場合、DELIMITER_TYPE_COMMAを指定
    //　　　　　タブを使用する場合、DELIMITER_TYPE_TABを指定
    public static List<List<String>> getList (String csvText, String delimiter) {

        // 結果用リスト
        List<List<String>> items = new List<List<String>>();

        // ワーク変数
        List<String> item;
        String value = '';
        Boolean isAdd = true;           // 値として追加するかどうか
        Boolean isNewLine = true;       // 新しい行の開始かどうか
        Boolean startDQ = false;        // 文字列が開始しているかどうか
        Boolean endDQ = false;          // 文字列が終了しているかどうか

        // trim
        csvText = csvText.trim();

        // １文字ずつ検査
        for (Integer i = 0; i < csvText.length(); i++) {

            // １行分のデータを保持するためのリスト生成
            if (isNewLine) {
                item = new List<String>();
                isNewLine = false;
            }

            // １文字取得
            String now = csvText.substring(i, i+1);
            isAdd = true;

            // 半角スペースかどうか
            if (now == HALF_BLANK) {
                // 文字列中のデリミタでないかどうか
                if ((startDQ && endDQ) || (!startDQ && !endDQ)) {
                    // 文字列中でない値の先頭半角スペースは不要文字と判断
                    if (value.length() == 0) {
                        isAdd = false;
                    }
                }
            }

            // デリミタかどうか
            if (now == delimiter) {
                // 文字列中のデリミタでないかどうか
                if ((startDQ && endDQ) || (!startDQ && !endDQ)) {
                    // 文字列でない値のみTrim
                    if (!startDQ && !endDQ) {
                        value = value.trim();
                    }
                    // デリミタを処理
                    item.add(value);
                    // ワーク変数初期化
                    value = '';
                    startDQ = false;
                    endDQ = false;
                    isAdd = false;
                }
            }

            // 改行かどうか
            if (now == LINE_SEPARATOR_CR || now == LINE_SEPARATOR_LF) {
                // 文字列中の改行でないかどうか
                if ((startDQ && endDQ) || (!startDQ && !endDQ)) {
                    // 文字列でない値のみTrim
                    if (!startDQ && !endDQ) {
                        value = value.trim();
                    }
                    // 改行を処理
                    item.add(value);
                    items.add(item);
                    // ワーク変数初期化
                    value = '';
                    startDQ = false;
                    endDQ = false;
                    isAdd = false;
                    isNewLine = true;

                    // 改行コードがCRLFならば、LF部分を読み飛ばす
                    String next = csvText.substring(i+1, i+2);
                    if (now == LINE_SEPARATOR_CR && next == LINE_SEPARATOR_LF) {
                        i ++;
                    }
                }
            }

            // ダブルクォートかどうか
            if (now == DOUBLE_QUATE) {
                // 開始かどうか
                if (!startDQ) {
                    // ダブルクォートが未だ出ていない場合、
                    // 文字列の開始と判断する
                    startDQ = true;
                    isAdd = false;
                } else {
                    // ダブルクォートが既に出ている場合
                    // 次の１文字を先読み
                    if (i+1 != csvText.length()) {
                        // 次の文字があり、デリミタまたは改行コードの場合、
                        // 文字列の終了と判断する
                        String next = csvText.substring(i+1, i+2);
                        if (next == delimiter || next == LINE_SEPARATOR_CR || next == LINE_SEPARATOR_LF) {
                            endDQ = true;
                            isAdd = false;
                        }
                    } else {
                        // 次の文字がなく、最終文字がダブルクォート
                        isAdd = false;
                    }
                }
            }

            // １文字追加
            if (isAdd) {
                value += now;
            }

            // 最終文字かどうか
            if (i+1 == csvText.length()) {
                // 文字列でない値のみTrim
                if (!startDQ && !endDQ) {
                    value = value.trim();
                }
                item.add(value);
                items.add(item);
            }
        }

        return items;
    }

	// CSVからList<String>に変換（デリミタ：カンマ）
	//　引数１のテキストに対して、カンマで区切られた各値のリストを作成し、
	//　それを含む行単位のリストを取得する
	//
	//　戻り値：各値のリストを含む、行単位のリスト
	// 引数１：CSVテキスト
	public static List<List<String>> getListEasy(String csvText) {
		return getListEasy(csvText, DELIMITER_TYPE_COMMA);
	}

	// CSVからList<String>に変換（デリミタ指定）
	//　引数１のテキストに対して、指定したデリミタで区切られた各値のリストを作成し、
	//　それを含む行単位のリストを取得する
	//
	//　戻り値：各値のリストを含む、行単位のリスト
	//　引数１：CSVテキスト
	//　引数２：デリミタ
	//　　　　　カンマを使用する場合、DELIMITER_TYPE_COMMAを指定
	//　　　　　タブを使用する場合、DELIMITER_TYPE_TABを指定
	public static List<List<String>> getListEasy(String csvText, String delimiter) {

		// 結果用リスト
		List<List<String>> items = new List<List<String>>();

		//
		if(csvText == null){
			return items;
		}

		// trim
		csvText = csvText.trim();

		List<String> tmpItem = null;
		// 改行コードでsplit
		if(csvText.contains(LINE_SEPARATOR_CR + LINE_SEPARATOR_LF)){
			tmpItem = csvText.split(LINE_SEPARATOR_CR + LINE_SEPARATOR_LF);
		}else if(csvText.contains(LINE_SEPARATOR_CR)){
			tmpItem = csvText.split(LINE_SEPARATOR_CR);
		}else if(csvText.contains(LINE_SEPARATOR_LF)){
			tmpItem = csvText.split(LINE_SEPARATOR_LF);
		}else{
			tmpItem = new List<String>();
			tmpItem.add(csvText);
		}

		// 1行ごとのデータをデリミタでsplit
		for(Integer i = 0; i < tmpItem.size(); i++){
			List<String> item = null;

			// デリミタでsplit
			item = tmpItem[i].split(delimiter);

			// 各要素の最初と最後がダブルクォートかどうか
			for(Integer j = 0; j < item.size(); j++){
				String factor = item[j];
				if(!Strings.isNullOrEmpty(factor)
					&& factor.substring(0, 1).equals(DOUBLE_QUATE)
					&& factor.substring(factor.length() - 1, factor.length()).equals(DOUBLE_QUATE)){
					item[j] = factor.substring(1, factor.length() - 1);
				}
			}

			items.add(item);
		}

		return items;
	}
}