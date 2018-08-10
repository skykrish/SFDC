public with sharing class NyukinTriggerHandler {

	private boolean m_isExecuting = false;
	private integer batchSize = 0;


	/** 請求ヘッダマップ */
	private Map<String, List<SeikyuHeader__c>> sHeadMap;

	/** 更新用請求ヘッダリスト */
	private List<SeikyuHeader__c> updateSHeadList;

	/** 登録方法：MANUAL */
	private static String INSERT_METHOD_MANUAL = 'MANUAL';

	/** ステータス：新規 */
	private static String STATUS_SHINKI = '新規';

	/** ステータス：消し込み済み */
	private static String STATUS_KESHIKOMIZUMI = '消し込み済み';

	/** 請求ステータス：請求済み */
	private static String SEIKYU_STATUS_SEIKYUZUMI = '請求済み';

	/** 入金ステータス：未入金 */
	private static String NYUKIN_STATUS_MINYUKIN = '未入金';

	/** 入金ステータス：入金済み */
	private static String NYUKIN_STATUS_NYUKINZUMI = '入金済み';

	/**
	 * コンストラクタ
	 */
	public NyukinTriggerHandler(boolean isExecuting, integer size){
		this.m_isExecuting = isExecuting;
		this.batchSize = size;
	}

	/**
	 * BeforeInsert
	 */
	public void OnBeforeInsert(Nyukin__c[] newObjs){

		// 請求ヘッダマップの作成
		this.createSHeadMap();

		// 更新用請求ヘッダリストの初期化
		this.updateSHeadList = new List<SeikyuHeader__c>();

		for(Nyukin__c nyukin : newObjs){
			// 入金データが消し込み対象か判定（登録方法がMANUALかつステータスが新規かつ次回相殺分ではないか判定）
			if(nyukin.InsertMethod__c == INSERT_METHOD_MANUAL && nyukin.Status__c == STATUS_SHINKI && !nyukin.Offset_Flg__c){
				// 消し込み処理の実行
				this.keshikomi(nyukin);
			}
		}

	}

    /**
     * 請求ヘッダマップ作成
     */
	private void createSHeadMap(){

		// 請求ヘッダを取得
		List<SeikyuHeader__c> seikyuHeaders = [SELECT id,
													Seikyusaki__c,
													Seikyugaku_Tax__c,
													NyukinStatus__c,
													Keshikomibi__c
												FROM SeikyuHeader__c
												WHERE SeikyuStatus__c = :SEIKYU_STATUS_SEIKYUZUMI
													AND NyukinStatus__c = :NYUKIN_STATUS_MINYUKIN
													AND Del_Flg__c = FALSE
												ORDER BY SeikyuDateTime__c ASC];

		// 請求ヘッダマップの初期化
		this.sHeadMap = new Map<String, List<SeikyuHeader__c>>();
		for(Integer i = 0; i < seikyuHeaders.size(); i++){
			SeikyuHeader__c seikyuHeader = seikyuHeaders[i];
			String key = seikyuHeader.Seikyusaki__c + String.valueOf(seikyuHeader.Seikyugaku_Tax__c);
			// 請求先と請求額（税込み）をキーに請求ヘッダリストを登録
			if(!this.sHeadMap.containsKey(key)){
				List<SeikyuHeader__c> shTmpList = new List<SeikyuHeader__c>();
				shTmpList.add(seikyuHeader);
				this.sHeadMap.put(key ,shTmpList);
			}else{
				this.sHeadMap.get(key).add(seikyuHeader);
			}
		}

	}

    /**
     * 消し込み処理
     *
     * @param nyukin 消し込み対象入金データ
     */
	private void keshikomi(Nyukin__c nyukin){

        // 入金先＋（入金額＋差額）でキーを作成する
        Integer nyukingaku = Integer.vaLueOf(nyukin.Nyukingaku__c);
        Integer sagaku = (nyukin.Sagaku__c != null) ? Integer.vaLueOf(nyukin.Sagaku__c) : 0;
		String key = nyukin.Nyukinsaki__c + String.valueOf(nyukingaku + sagaku);

		// 消し込み対象となる請求ヘッダが存在するか判定
		if(this.sHeadMap.containsKey(key)){
			List<SeikyuHeader__c> shTmpList = this.sHeadMap.get(key);
			for(SeikyuHeader__c sHead : shTmpList){
				// 請求ヘッダの消し込み
				if(sHead.NyukinStatus__c.equals(NYUKIN_STATUS_MINYUKIN)){
					sHead.NyukinStatus__c = NYUKIN_STATUS_NYUKINZUMI;
					sHead.Keshikomibi__c = System.now();
					this.updateSHeadList.add(sHead);

					// 入金のステータスと消し込み日を設定
					nyukin.Status__c = STATUS_KESHIKOMIZUMI;
					nyukin.Keshikomibi__c = System.now();

					break;
				}
			}
		}

		// 請求ヘッダの更新
		if(this.updateSHeadList.size() != 0){
			update this.updateSHeadList;
		}

	}
}