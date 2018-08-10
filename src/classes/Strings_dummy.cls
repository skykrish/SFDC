global class Strings_dummy {
	
	/** 暗号化キー */
	private static final String cryptoPrivateKey = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPp';

	/**
	  * 文字列を暗号化します。
	  * @param cipherText 暗号化対象の文字列
	  * @return 暗号化された文字列
	  */
	global static String encryptString(String cipherText) {
		Blob encryptedData = Crypto.encryptWithManagedIV('AES256', Blob.valueOf(Strings_dummy.cryptoPrivateKey), Blob.valueOf(cipherText));
		return EncodingUtil.base64Encode(encryptedData);
	}

	/**
	  * 文字列を複合化します。
	  * @param cipherText 複合化対象の文字列
	  * @return 複合化された文字列
	  */
	global static String decryptString(String cipherText) {
		Blob decryptedData = Crypto.decryptWithManagedIV('AES256', Blob.valueOf(Strings_dummy.cryptoPrivateKey), EncodingUtil.base64Decode(cipherText));
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
			return Strings_dummy.isNullOrEmpty(value.trim());
		} else {
			return Strings_dummy.isNullOrEmpty(value);
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
		if (Strings_dummy.isNullOrEmpty(value)) return false;

		String p = '^\\d{3}(?:-?(?:\\d{2}|\\d{4}))?$';
		return Pattern.matches(p, value);
	}

	/**
	  * 文字列が電話番号形式かを判定します。
	  * @return 電話番号形式の場合は true。それ以外は false。
	  */
	global static Boolean isPhoneNumber(String value) {
		if (Strings_dummy.isNullOrEmpty(value)) return false;

		String p = '(?!^(090|080|070))(?=^\\d{2,5}?-\\d{1,4}?-\\d{4}$)[\\d-]{12}|' +
					'(?=^(090|080|070)-\\d{4}-\\d{4}$)[\\d-]{13}|' + 
					'(?=^0120-\\d{2,3}-\\d{3,4})[\\d-]{12}|' +
					'^0800-\\d{3}-\\d{4}';
		if (Pattern.matches(p, value)) {
			return true;
		} else {
			p = '(?!^(090|080|070))^[\\d]{10}|' +
				'(090|080|070)[\\d]{8}';
			return Pattern.matches(p, value);
		}
	}

	/**
	  * 文字列が電子メール形式かを判定します。
	  * @return 電子メール形式の場合は true。それ以外は false。
	  */
	global static Boolean isEMail(String value) {
		if (Strings_dummy.isNullOrEmpty(value)) return false;

		String p = '[\\w\\.\\-]+@(?:[\\w\\-]+\\.)+[\\w\\-]+';
		return Pattern.matches(p, value);
	}

	/**
	  * 文字列がURL形式かを判定します。
	  * @return URL形式の場合は true。それ以外は false。
	  */
	global static Boolean isUrl(String value) {
		if (Strings_dummy.isNullOrEmpty(value)) return false;

		String p = '^(https?|ftp):\\/\\/([^\\x00-\\x20()\"<>\\x7F-\\xFF])+';
		return Pattern.matches(p, value);
	}

	/**
	  * 文字列が日付形式かを判定します。
	  * @return 日付形式の場合は true。それ以外は false。
	  */
	global static Boolean isDate(String value) {
		if (Strings_dummy.isNullOrEmpty(value)) return false;

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
	global static Boolean isZenkakuKana(String value) {
		if (Strings_dummy.isNullOrEmpty(value)) return false;

		String p = '^[ァ-ー]+$';
		return Pattern.matches(p, value);
	}

	/**
	  * nullの場合に空文字を返しますす。
	  * @return nullの場合 空文字を返す。それ以外はそのまま。
	  */
	global static String nullToBlank(String value) {
		if (value == null) {
			value = '';
		}
		return value;
	}

	static testMethod void myUnitTest() {
		String encryptString = Strings_dummy.encryptString('password');
		System.debug('******** 暗号化：' + encryptString);
		String decryptString = Strings_dummy.decryptString(encryptString);
		System.debug('******** 複合化：' + encryptString);
		System.assertEquals('password', decryptString);
		
		System.assertEquals(true, Strings_dummy.isNullOrEmpty(null));
		System.assertEquals(true, Strings_dummy.isNullOrEmpty(''));
		System.assertEquals(false, Strings_dummy.isNullOrEmpty('ABC'));
		System.assertEquals(true, Strings_dummy.isNullOrEmpty(null, true));
		System.assertEquals(true, Strings_dummy.isNullOrEmpty(null, false));
		System.assertEquals(true, Strings_dummy.isNullOrEmpty(' ', true));
		System.assertEquals(false, Strings_dummy.isNullOrEmpty(' ', false));
		System.assertEquals(false, Strings_dummy.isNullOrEmpty('ABC', true));
		System.assertEquals(false, Strings_dummy.isNullOrEmpty('ABC', false));
		
		System.assertEquals(false, Strings_dummy.isPostalCode(null));
		System.assertEquals(false, Strings_dummy.isPostalCode('ABC'));
		System.assertEquals(false, Strings_dummy.isPostalCode('100-'));
		System.assertEquals(true, Strings_dummy.isPostalCode('100'));
		System.assertEquals(true, Strings_dummy.isPostalCode('100-00'));
		System.assertEquals(true, Strings_dummy.isPostalCode('100-0001'));
		System.assertEquals(true, Strings_dummy.isPostalCode('10000'));
		System.assertEquals(true, Strings_dummy.isPostalCode('1000000'));

		System.assertEquals(false, Strings_dummy.isPhoneNumber(null));
		System.assertEquals(false, Strings_dummy.isPhoneNumber('090'));
		System.assertEquals(false, Strings_dummy.isPhoneNumber('090-0000'));
		System.assertEquals(true, Strings_dummy.isPhoneNumber('090-0000-0001'));
		System.assertEquals(true, Strings_dummy.isPhoneNumber('03-0001-0001'));
		System.assertEquals(true, Strings_dummy.isPhoneNumber('0120-000-001'));
		System.assertEquals(true, Strings_dummy.isPhoneNumber('09000000001'));
		System.assertEquals(true, Strings_dummy.isPhoneNumber('0300010001'));
		System.assertEquals(true, Strings_dummy.isPhoneNumber('0120000001'));
		
		System.assertEquals(false, Strings_dummy.isEMail(null));
		System.assertEquals(false, Strings_dummy.isEMail('abc@abc'));
		System.assertEquals(true, Strings_dummy.isEMail('abc@abc.com'));
		System.assertEquals(true, Strings_dummy.isEMail('abcd.ab@abc.ne.jp'));
		
		System.assertEquals(false, Strings_dummy.isUrl(null));
		System.assertEquals(false, Strings_dummy.isUrl('http://'));
		System.assertEquals(true, Strings_dummy.isUrl('http://www.abc.com'));
		System.assertEquals(true, Strings_dummy.isUrl('http://www.abc.com/'));
		System.assertEquals(true, Strings_dummy.isUrl('https://www.abc.com/index.html'));
		System.assertEquals(true, Strings_dummy.isUrl('https://www.abc.com/index.html?email=aaa@abc.com'));

		System.assertEquals(false, Strings_dummy.isZenkakuKana(null));
		System.assertEquals(false, Strings_dummy.isZenkakuKana(''));
		System.assertEquals(false, Strings_dummy.isZenkakuKana('あいうえお'));
		System.assertEquals(false, Strings_dummy.isZenkakuKana('ｱｲｳｴｵｰ'));
		System.assertEquals(true, Strings_dummy.isZenkakuKana('アイウエオー'));

		System.assertEquals(false, Strings_dummy.isDate(null));
		System.assertEquals(false, Strings_dummy.isDate(''));
		System.assertEquals(false, Strings_dummy.isDate('2011/2/29'));
		System.assertEquals(false, Strings_dummy.isDate('2011/13/1'));
		System.assertEquals(true, Strings_dummy.isDate('2000/2/29'));
		System.assertEquals(true, Strings_dummy.isDate('2004/2/29'));
		System.assertEquals(true, Strings_dummy.isDate('2011/05/22'));

		System.assertEquals(false, Strings_dummy.isInteger(null));
		System.assertEquals(false, Strings_dummy.isInteger(''));
		System.assertEquals(true, Strings_dummy.isInteger('1'));
		System.assertEquals(false, Strings_dummy.isInteger('1.1'));
		System.assertEquals(false, Strings_dummy.isInteger('1,000'));

		System.assertEquals(false, Strings_dummy.isDecimal(null));
		System.assertEquals(false, Strings_dummy.isDecimal(''));
		System.assertEquals(true, Strings_dummy.isDecimal('1'));
		System.assertEquals(true, Strings_dummy.isDecimal('1.1'));
		System.assertEquals(true, Strings_dummy.isDecimal('1.'));
		System.assertEquals(false, Strings_dummy.isDecimal('1,000'));
		System.assertEquals(false, Strings_dummy.isDecimal('1,000.1'));

		System.assertEquals('', Strings_dummy.nullToBlank(null));
		System.assertEquals('TEST', Strings_dummy.nullToBlank('TEST'));
	}
}