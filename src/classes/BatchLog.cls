public with sharing class BatchLog {

    /** ログリスト */
    private List<String> logList;
    
    /** コンストラクタ */
    public BatchLog() {
        this.logList = new List<String>();
    }
    
    /** ログ追加 */
    public void write(String s) {
        this.loglist.add(Datetime.now() + ' ' + s + '\r\n');
    }

    /** ログリスト追加 */
    public void addLogList(List<String> logList) {
        this.loglist.addAll(logList);
    }

    /** ログリスト取得 */
    public List<String> getLogList() {
        return this.logList;
    }

    /** 全ログ取得 */
    public String toStr() {
        String s = '';
        for (String item : this.loglist) {
            s += item;
        }
        return s;
    }

    /** テストメソッド */
	public static testMethod void myUnitTest() {
		
        // テスト開始
        Test.startTest();

		BatchLog log = new BatchLog();
		log.write('TEST');

		BatchLog log2 = new BatchLog();
		log2.write('TEST1');
		
		log.addLogList(log2.getLogList());

		String s = log.toStr();

        // テスト終了
        Test.stopTest();
	}
}