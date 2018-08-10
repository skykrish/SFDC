global class Strings {
    private static final String cryptoPrivateKey = 'ROh\'FV}|F$QFq)ELrlQSiqt:6ZG$Xp?L';

    /**
      * 文字列を暗号化します。
      * @param cipherText 暗号化対象の文字列
      * @return 暗号化された文字列
      */
    global static String encryptString(String cipherText) {
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', Blob.valueOf(Strings.cryptoPrivateKey), Blob.valueOf(cipherText));
        return EncodingUtil.base64Encode(encryptedData);
    }

    /**
      * 文字列を複合化します。
      * @param cipherText 複合化対象の文字列
      * @return 複合化された文字列
      */
    global static String decryptString(String cipherText) {
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', Blob.valueOf(Strings.cryptoPrivateKey), EncodingUtil.base64Decode(cipherText));
        return decryptedData.toString();
    }

    /**
      * 文字列が null または、空文字かを判定します。
      * @param value 判定対象の文字列
      * @param permittedWhiteSpace 空白のみの場合も空文字と見なす場合は true。それ以外は false。
      * @return null または、空文字の場合は true。それ以外は false。
      */
    global static Boolean isNullOrEmpty(String value, Boolean permittedWhiteSpace) {
        if (permittedWhiteSpace && value != null) {
            return Strings.isNullOrEmpty(value.trim());
        } else {
            return Strings.isNullOrEmpty(value);
        }
    }

    /**
      * 文字列が null または、空文字かを判定します。
      * @param value 判定対象の文字列
      * @return null または、空文字の場合は true。それ以外は false。
      */
    global static Boolean isNullOrEmpty(String value) {
        return value == null || value.length() == 0;
    }

    /**
      * 文字列が郵便番号形式かを判定します。
      * @return 郵便番号形式の場合は true。それ以外は false。
      */
    global static Boolean isPostalCode(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '^\\d{3}(?:-?(?:\\d{2}|\\d{4}))?$';
        return Pattern.matches(p, value);
    }

    /**
      * 文字列が電話番号形式かを判定します。
      * @return 電話番号形式の場合は true。それ以外は false。
      */
    global static Boolean isPhoneNumber(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '(?!^(090|080|070|050))(?=^\\d{2,5}?-\\d{1,4}?-\\d{4}$)[\\d-]{12}|' +
                    '(?=^(090|080|070|050)-\\d{4}-\\d{4}$)[\\d-]{13}|' + 
                    '(?=^0120-\\d{2,3}-\\d{3,4})[\\d-]{12}|' +
                    '^0800-\\d{3}-\\d{4}';
        if (Pattern.matches(p, value)) {
            return true;
        } else {
            p = '(?!^(090|080|070|050))^[\\d]{10}|' +
                '(090|080|070|050)[\\d]{8}';
            return Pattern.matches(p, value);
        }
    }

    /**
      * 文字列が電子メール形式かを判定します。
      * @return 電子メール形式の場合は true。それ以外は false。
      */
    global static Boolean isEMail(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '[\\w\\.\\-]+@(?:[\\w\\-]+\\.)+[\\w\\-]+';
        return Pattern.matches(p, value);
    }

    /**
      * 文字列がURL形式かを判定します。
      * @return URL形式の場合は true。それ以外は false。
      */
    global static Boolean isUrl(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '^(https?|ftp):\\/\\/([^\\x00-\\x20()\"<>\\x7F-\\xFF])+';
        return Pattern.matches(p, value);
    }

    /**
      * 文字列が日付形式かを判定します。
      * @return 日付形式の場合は true。それ以外は false。
      */
    global static Boolean isDate(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '^(?:[0-9]{4}/(?:(?:0?[1-9]|1[0-2])/(?:0?[1-9]|1[0-9]|2[0-8])|' +
                    '(?:0?[13-9]|1[0-2])/(?:29|30)|(?:0?[13578]|1[02])/31)|' +
                    '(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:[02468][048]|[13579][26])00)/0?2/29)$';
        return Pattern.matches(p, value);
    }
    
    /**
      * 文字列が Integer として有効かを判定します。
      * @return 有効な場合は true。それ以外は false。
      */
    global static Boolean isInteger(String value) {
        try {
            Integer.valueOf(value);
            
            return true;
        } catch (Exception ex) {
            return false;
        }
    }
    
    /**
      * 文字列が Decimal として有効かを判定します。
      * @return 有効な場合は true。それ以外は false。
      */
    global static Boolean isDecimal(String value) {
        try {
            Decimal.valueOf(value);
            
            return true;
        } catch (Exception ex) {
            return false;
        }
    }
    
    /**
      * 文字列が全角カナのみかを判定します。
      * @return 全角カナの場合は true。それ以外は false。
      */
    global static Boolean isWideKana(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '^[ァ-ー]+$';
        return Pattern.matches(p, value);
    }

    /**
      * 文字列が全角英数カナのみかを判定します。
      * @return 全角英数カナの場合は true。それ以外は false。
      */
    global static Boolean isWideAlphaNumKana(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '^[０-９ａ-ｚＡ-Ｚァ-ー]+$';
        return Pattern.matches(p, value);
    }

    /**
      * nullの場合に空文字を返します。
      * @return nullの場合 空文字を返す。それ以外はそのまま。
      */
    global static String nullToBlank(String value) {
        if (value == null) {
            value = '';
        }
        return value;
    }

    /**
     * 年、月、日からSOQL用日付文字列「YYYY-MM-DD」を取得します。
     * 
     *  @param  year    年
     *  @param  month   月
     *  @param  day     日
     *  @return         「YYYY-MM-DD」の文字列
     */
    global static String createSOQLDate(Integer year, Integer month, Integer day){
        return Strings.createSOQLDate(Date.newInstance(year, month, day));
    }

    /**
     * 年、月、日からSOQL用日付文字列「YYYY-MM-DD」を取得します。
     * 
     *  @param  dt      日付
     *  @return         「YYYY-MM-DD」の文字列
     */
    global static String createSOQLDate(Date dt){
        return dt.format().replaceAll('/', '-');
    }

    /**
      * 文字列が半角英数のみかを判定します。
      * @return 半角英数の場合は true。それ以外は false。
      */
    global static Boolean isHalfAlphaNum(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '^[0-9a-zA-Z]+$';
        return Pattern.matches(p, value);
    }

    /**
      * 文字列がクレジットカード番号形式かを判定します。
      * VISA, MasterCard, American Express のフォーマットに対応。
      * @return クレジットカード番号形式の場合は true。それ以外は false。
      */
    global static Boolean isCreditCardNo(String value) {
        if (Strings.isNullOrEmpty(value)) return false;

        String p = '^((4\\d{3})|(5[1-5]\\d{2})|(6011))([- ])?\\d{4}([- ])?\\d{4}([- ])?\\d{4}|3[4,7]\\d{13}$';
        return Pattern.matches(p, value);
    }

    /**
      * 文字列がクレジットカード番号形式かを判定します。
      * 半角数値で成り立っているかどうか
      * @return クレジットカード番号形式の場合は true。それ以外は false。
      */
    global static Boolean isCreditCardNo(String value1, String value2, String value3, String value4) {
        if (Strings.isNullOrEmpty(value1) ||
            Strings.isNullOrEmpty(value2) ||
            Strings.isNullOrEmpty(value3) ||
            Strings.isNullOrEmpty(value4)
        ) {
           	 return false;
        }
        
        // カード番号
        String value = value1 + value2 + value3 + value4;
        
        // 13～16桁であること
        if (!(value.length() >= 13 && value.length() <= 16)) {
           	 return false;
        }
        
        // すべて半角数値かどうか
        String p = '^[0-9]+$';
        return Pattern.matches(p, value);
    }

    /**
     * 改行制御(帳票用)。
     *
     * @param targetString 改行を入れる文字列
     * @return String 加工した文字列
     */
    global static String convertBr2LineBreakString(String targetString) {
        String convertStr = null;
        if (targetString != null) {
            //サイニタイズ
            convertStr = targetString.escapeHtml4();
            //加工した文字列保持(WIN)
            convertStr = convertStr.replaceAll('\r\n', '<br/>');
            //加工した文字列保持(MAC)
            convertStr = convertStr.replaceAll('\r', '<br/>');
            //加工した文字列保持(UNIX)
            convertStr = convertStr.replaceAll('\n', '<br/>');
        }
        return convertStr; 
    }

    static testMethod void myUnitTest() {
        String encryptString = Strings.encryptString('password');
        String decryptString = Strings.decryptString(encryptString);
        System.assertEquals('password', decryptString);
        
        System.assertEquals(true, Strings.isNullOrEmpty(null));
        System.assertEquals(true, Strings.isNullOrEmpty(''));
        System.assertEquals(false, Strings.isNullOrEmpty('ABC'));
        System.assertEquals(true, Strings.isNullOrEmpty(null, true));
        System.assertEquals(true, Strings.isNullOrEmpty(null, false));
        System.assertEquals(true, Strings.isNullOrEmpty(' ', true));
        System.assertEquals(false, Strings.isNullOrEmpty(' ', false));
        System.assertEquals(false, Strings.isNullOrEmpty('ABC', true));
        System.assertEquals(false, Strings.isNullOrEmpty('ABC', false));
        
        System.assertEquals(false, Strings.isPostalCode(null));
        System.assertEquals(false, Strings.isPostalCode('ABC'));
        System.assertEquals(false, Strings.isPostalCode('100-'));
        System.assertEquals(true, Strings.isPostalCode('100'));
        System.assertEquals(true, Strings.isPostalCode('100-00'));
        System.assertEquals(true, Strings.isPostalCode('100-0001'));
        System.assertEquals(true, Strings.isPostalCode('10000'));
        System.assertEquals(true, Strings.isPostalCode('1000000'));

        System.assertEquals(false, Strings.isPhoneNumber(null));
        System.assertEquals(false, Strings.isPhoneNumber('090'));
        System.assertEquals(false, Strings.isPhoneNumber('090-0000'));
        System.assertEquals(true, Strings.isPhoneNumber('090-0000-0001'));
        System.assertEquals(true, Strings.isPhoneNumber('03-0001-0001'));
        System.assertEquals(true, Strings.isPhoneNumber('0120-000-001'));
        System.assertEquals(true, Strings.isPhoneNumber('050-0000-0001'));
        System.assertEquals(true, Strings.isPhoneNumber('09000000001'));
        System.assertEquals(true, Strings.isPhoneNumber('0300010001'));
        System.assertEquals(true, Strings.isPhoneNumber('0120000001'));
        System.assertEquals(true, Strings.isPhoneNumber('05000000001'));
        
        System.assertEquals(false, Strings.isEMail(null));
        System.assertEquals(false, Strings.isEMail('abc@abc'));
        System.assertEquals(true, Strings.isEMail('abc@abc.com'));
        System.assertEquals(true, Strings.isEMail('abcd.ab@abc.ne.jp'));
        
        System.assertEquals(false, Strings.isUrl(null));
        System.assertEquals(false, Strings.isUrl('http://'));
        System.assertEquals(true, Strings.isUrl('http://www.abc.com'));
        System.assertEquals(true, Strings.isUrl('http://www.abc.com/'));
        System.assertEquals(true, Strings.isUrl('https://www.abc.com/index.html'));
        System.assertEquals(true, Strings.isUrl('https://www.abc.com/index.html?email=aaa@abc.com'));

        System.assertEquals(false, Strings.isWideKana(null));
        System.assertEquals(false, Strings.isWideKana(''));
        System.assertEquals(false, Strings.isWideKana('あいうえお'));
        System.assertEquals(false, Strings.isWideKana('ｱｲｳｴｵｰ'));
        System.assertEquals(true, Strings.isWideKana('アイウエオー'));


        System.assertEquals(false, Strings.isWideAlphaNumKana(null));
        System.assertEquals(false, Strings.isWideAlphaNumKana(''));
        System.assertEquals(false, Strings.isWideAlphaNumKana('あいうえお'));
        System.assertEquals(false, Strings.isWideAlphaNumKana('ｱｲｳｴｵｰ'));
        System.assertEquals(true, Strings.isWideAlphaNumKana('アイウエオー'));
        System.assertEquals(true, Strings.isWideAlphaNumKana('ＡＢＣＤＥ'));
        System.assertEquals(true, Strings.isWideAlphaNumKana('０１２３４５'));

        System.assertEquals(false, Strings.isDate(null));
        System.assertEquals(false, Strings.isDate(''));
        System.assertEquals(false, Strings.isDate('2011/2/29'));
        System.assertEquals(false, Strings.isDate('2011/13/1'));
        System.assertEquals(true, Strings.isDate('2000/2/29'));
        System.assertEquals(true, Strings.isDate('2004/2/29'));
        System.assertEquals(true, Strings.isDate('2011/05/22'));

        System.assertEquals(false, Strings.isInteger(null));
        System.assertEquals(false, Strings.isInteger(''));
        System.assertEquals(true, Strings.isInteger('1'));
        System.assertEquals(false, Strings.isInteger('1.1'));
        System.assertEquals(false, Strings.isInteger('1,000'));

        System.assertEquals(false, Strings.isDecimal(null));
        System.assertEquals(false, Strings.isDecimal(''));
        System.assertEquals(true, Strings.isDecimal('1'));
        System.assertEquals(true, Strings.isDecimal('1.1'));
        System.assertEquals(true, Strings.isDecimal('1.'));
        System.assertEquals(false, Strings.isDecimal('1,000'));
        System.assertEquals(false, Strings.isDecimal('1,000.1'));

        System.assertEquals('2011-07-14', Strings.createSOQLDate(2011, 7, 14));

        System.assertEquals('', Strings.nullToBlank(null));
        System.assertEquals('TEST', Strings.nullToBlank('TEST'));

        System.assertEquals(false, Strings.isHalfAlphaNum(null));
        System.assertEquals(false, Strings.isHalfAlphaNum(''));
        System.assertEquals(true, Strings.isHalfAlphaNum('az'));
        System.assertEquals(true, Strings.isHalfAlphaNum('AZ'));
        System.assertEquals(true, Strings.isHalfAlphaNum('09'));
        System.assertEquals(true, Strings.isHalfAlphaNum('azAZ09'));
        System.assertEquals(false, Strings.isDecimal('azあ'));
        System.assertEquals(false, Strings.isDecimal('az!'));

        System.assertEquals(false, Strings.isCreditCardNo(null));
        System.assertEquals(false, Strings.isCreditCardNo(''));
        System.assertEquals(true, Strings.isCreditCardNo('375987654321001'));
        System.assertEquals(true, Strings.isCreditCardNo('4000123456789010'));
        System.assertEquals(true, Strings.isCreditCardNo('5419849999999999'));

        System.assertEquals(false, Strings.isCreditCardNo(null, null, null, null));
        System.assertEquals(false, Strings.isCreditCardNo('1234', '5678', '89', '12'));
        System.assertEquals(true, Strings.isCreditCardNo('1234', '5678', '8901', '1234'));

        System.assertEquals('&lt;br/&gt;', Strings.convertBr2LineBreakString('<br/>'));
        System.assertEquals('<br/>', Strings.convertBr2LineBreakString('\r\n'));
        System.assertEquals('<br/>', Strings.convertBr2LineBreakString('\n'));
        System.assertEquals('<br/>', Strings.convertBr2LineBreakString('\r'));
    }
}