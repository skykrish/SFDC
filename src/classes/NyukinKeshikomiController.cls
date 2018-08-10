public with sharing class NyukinKeshikomiController {

    /** 顧客ID */
    private String kokyakuId;

    /** 顧客データ */
    public Account kokyaku {
        get;
        set;
    }

    /** 更新用請求ヘッダデータリスト */
    public List<SeikyuHeader__c> seikyuHeaderUpdateList;

    /** 更新用入金データリスト */
    public List<Nyukin__c> nyukinUpdateList;

    /** 表示用請求ヘッダデータリスト */
    public List<SeikyuHeaderDummy> seikyuHeaderList {
        get;
        set;
    }

    /** 表示用入金データリスト */
    public List<NyukinDummy> nyukinList {
        get;
        set;
    }

    /** チェック用請求ヘッダデータマップ */
    public Map<Id,SeikyuHeaderDummy> seikyuHeaderMap;

    /** チェック用入金データマップ */
    public Map<Id,NyukinDummy> nyukinMap;

    /** 選択された請求額合計 */
    public Decimal checkedSeikyugakuTotal {
        get;
        set;
    }

    /** 選択された入金額合計 */
    public Decimal checkedNyukingakuTotal {
        get;
        set;
    }

    // 定数
    private static String SEIKYU_STATUS_SEIKYUZUMI = '請求済み';
    private static String NYUKIN_STATUS_MINYUKIN = '未入金';
    private static String NYUKIN_STATUS_NYUKINZUMI = '入金済み';
    private static String STATUS_SHINKI = '新規';
    private static String STATUS_KESHIKOMIZUMI = '消し込み済み';

    /**
     * デフォルトコンストラクタ
     */
    public NyukinKeshikomiController() {

        this.kokyakuId = ApexPages.currentPage().getParameters().get('kokyakuId');
    }

    /**
     * 初期化処理
     */
    public PageReference init() {

        // 顧客データ取得
        this.kokyaku = this.getKokyakuData(this.kokyakuId);

        // 請求ヘッダデータ取得
        this.seikyuHeaderList = this.getSeikyuHeaderData(this.kokyakuId);

        // 入金データ取得
        this.nyukinList = this.getNyukinData(this.kokyakuId);

        return null;

    }

    /**
     * 消し込み処理
     */
    public PageReference keshikomi() {

System.debug('+++++++++++++++++++++++++++++S+' + this.checkedSeikyugakuTotal);
System.debug('+++++++++++++++++++++++++++++N+' + this.checkedNyukingakuTotal);

        // 消し込み対象の表示用請求ヘッダデータをマップに設定
        this.seikyuHeaderMap = new Map<Id,SeikyuHeaderDummy>();
        for(SeikyuHeaderDummy dummy : this.seikyuHeaderList){
            if(dummy.checked){
                seikyuHeaderMap.put(dummy.seikyuHeader.Id,dummy);
            }
        }

        // 消し込み対象の表示用入金データをマップに設定
        this.nyukinMap = new Map<Id,NyukinDummy>();
        for(NyukinDummy dummy : this.nyukinList){
            if(dummy.checked){
                nyukinMap.put(dummy.nyukin.Id,dummy);
            }
        }

        // 消し込み対象の請求ヘッダデータ取得
        this.seikyuHeaderUpdateList = [SELECT Id,
                                              NyukinStatus__c,
                                              Keshikomibi__c,
                                              SeikyuDateTime__c,
                                              Seikyugaku_Tax__c,
                                              SystemModstamp
                                         FROM SeikyuHeader__c
                                        WHERE Seikyusaki__c = :kokyakuId
                                          AND SeikyuStatus__c = :SEIKYU_STATUS_SEIKYUZUMI
                                          AND NyukinStatus__c = :NYUKIN_STATUS_MINYUKIN
                                          AND Del_Flg__c = FALSE
                                          AND Id IN :seikyuHeaderMap.keySet()
                                     ORDER BY SeikyuDateTime__c ASC,
                                              Seikyugaku_Tax__c ASC];

        // 消し込み対象の入金データ取得
        this.nyukinUpdateList = [SELECT Id,
                                        Status__c,
                                        Keshikomibi__c,
                                        NyukinDate__c,
                                        Nyukingaku__c,
                                        SystemModstamp
                                   FROM Nyukin__c
                                  WHERE Nyukinsaki__c = :kokyakuId
                                    AND Status__c = :STATUS_SHINKI
                                    AND Offset_Flg__c = false
                                    AND Id IN :nyukinMap.keySet()
                               ORDER BY NyukinDate__c ASC,
                                        Nyukingaku__c ASC];

        // 消し込み対象のデータの更新チェック
        if(!this.validation()){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '選択された消し込み対象のデータが他のユーザに更新された可能性があります。'));
        // 請求ヘッダーデータ選択チェック
        }else if(this.seikyuHeaderMap.size() == 0){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '請求データが選択されていません。'));
            return null;
        // 入金データ選択チェック
        }else if(this.nyukinMap.size() == 0){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '入金データが選択されていません。'));
            return  null;
        // 選択された入金金額と請求金額一致チェック
        }else if(this.checkedNyukingakuTotal != this.checkedSeikyugakuTotal){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '入金額の合計と請求額の合計が一致しません。'));
            return null;
        }else{
        	// 請求データの入金ステータス、消し込み日設定
        	for (SeikyuHeader__c item : this.seikyuHeaderUpdateList) {
                item.NyukinStatus__c = NYUKIN_STATUS_NYUKINZUMI;
                item.Keshikomibi__c = System.now();
        	}
        	// 入金データの入金ステータス、消し込み日、差額の設定
        	for (Nyukin__c item : this.nyukinUpdateList) {
                item.Status__c = STATUS_KESHIKOMIZUMI;
                item.Keshikomibi__c = System.now();
                item.Sagaku__c = nyukinMap.get(item.Id).nyukin.Sagaku__c;
        	}
            // 更新
            update this.seikyuHeaderUpdateList;
            update this.nyukinUpdateList;
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '選択された消し込み対象のデータの消し込みが完了しました。'));
        }

        // 請求書ヘッダデータ再取得
        this.seikyuHeaderList = this.getSeikyuHeaderData(this.kokyakuId);

        // 入金データ再取得
        this.nyukinList = this.getNyukinData(this.kokyakuId);

        return null;

    }
    /**
     * 顧客データを取得する。
     *
     * @param kokyakuId 顧客ID
     * @return 顧客データ
     */
    private Account getKokyakuData(String kokyakuId) {

        List<Account> kokyakuList = [SELECT Name
                                       FROM Account
                                      WHERE Id = :kokyakuId];

        return kokyakuList[0];
    }

    /**
     * 請求ヘッダデータを取得する。
     *
     * @param kokyakuId 顧客ID
     * @return 請求ヘッダデータリスト
     */
    private List<SeikyuHeaderDummy> getSeikyuHeaderData(String kokyakuId) {

        List<SeikyuHeader__c> seikyuHeaderTmpList = [SELECT Id,
                                                            SeikyuDateTime__c,
                                                            Seikyugaku_Tax__c,
                                                            SystemModstamp
                                                       FROM SeikyuHeader__c
                                                      WHERE Seikyusaki__c = :kokyakuId
                                                        AND SeikyuStatus__c = :SEIKYU_STATUS_SEIKYUZUMI
                                                        AND NyukinStatus__c = :NYUKIN_STATUS_MINYUKIN
                                                        AND Del_Flg__c = FALSE
                                                   ORDER BY SeikyuDateTime__c ASC,
                                                            Seikyugaku_Tax__c ASC];

        List<SeikyuHeaderDummy> seikyuHeaderDummyList = new List<SeikyuHeaderDummy>();
        for(Integer i = 0; i < seikyuHeaderTmpList.size(); i++){
            SeikyuHeaderDummy dummy = new SeikyuHeaderDummy();
            dummy.seikyuHeader = seikyuHeaderTmpList[i];
            seikyuHeaderDummyList.add(dummy);
        }

        return seikyuHeaderDummyList;

    }

    /**
     * 入金データを取得する。
     *
     * @param kokyakuId 顧客ID
     * @return 入金データリスト
     */
    private List<NyukinDummy> getNyukinData(String kokyakuId) {

        List<Nyukin__c> nyukinTmpList = [SELECT Id,
                                                NyukinDate__c,
                                                Nyukingaku__c,
                                                Sagaku__c,
                                                NyukingakuTotal__c,
                                                SystemModstamp
                                           FROM Nyukin__c
                                          WHERE Nyukinsaki__c = :kokyakuId
                                            AND Status__c = :STATUS_SHINKI
                                            AND Offset_Flg__c = false
                                       ORDER BY NyukinDate__c ASC,
                                                Nyukingaku__c ASC];

        List<NyukinDummy> nyukinDummyList = new List<NyukinDummy>();
        for(Integer i = 0; i < nyukinTmpList.size(); i++){
            NyukinDummy dummy = new NyukinDummy();
            dummy.nyukin = nyukinTmpList[i];
            dummy.nyukingakuSagaku = nyukinTmpList[i].NyukingakuTotal__c;
            nyukinDummyList.add(dummy);
        }

        return nyukinDummyList;

    }

    /**
     * 消し込み対象データの更新の有無をチェックする。
     *
     * @return true:OK, false:NG
     */
    private boolean validation() {

        // 消し込み対象データと表示用消し込み対象データの件数チェック
        if(this.seikyuHeaderUpdateList.size() != this.seikyuHeaderMap.size() || this.nyukinUpdateList.size() != this.nyukinMap.size()){
            return false;
        }

        // 請求ヘッダデータの消し込み対象データと表示用データの最終更新日チェック
        for(SeikyuHeader__c seikyuHeader : this.seikyuHeaderUpdateList){
            if(this.seikyuHeaderMap.containsKey(seikyuHeader.Id)){
                SeikyuHeaderDummy dummy = this.seikyuHeaderMap.get(seikyuHeader.Id);
                if(seikyuHeader.SystemModstamp.format() != dummy.seikyuHeader.SystemModstamp.format()){
                    return false;
                }
            }
        }

        // 入金データの消し込み対象データと表示用データの最終更新日チェック
        for(Nyukin__c nyukin : this.nyukinUpdateList){
            if(this.nyukinMap.containsKey(nyukin.Id)){
                NyukinDummy dummy = this.nyukinMap.get(nyukin.Id);
                if(nyukin.SystemModstamp.format() != dummy.nyukin.SystemModstamp.format()){
                    return false;
                }
            }
        }

        return true;
    }

    /**
     * 表示用請求ヘッダデータクラス
     */
    public class SeikyuHeaderDummy {

        /** 請求ヘッダデータ */
        public SeikyuHeader__c seikyuHeader {get; set;}

        /** 登録チェックボックス */
        public boolean checked {get; set;}

        /** デフォルトコンストラクタ */
        public SeikyuHeaderDummy() {
            this.checked = false;
        }
    }

    /**
     * 表示用入金データクラス
     */
    public class NyukinDummy {

        /** 入金データ */
        public Nyukin__c nyukin {get; set;}

        /** 入金額合計（表示用） */
        public Decimal nyukingakuSagaku {get; set;}

        /** 登録チェックボックス */
        public boolean checked {get; set;}

        /** デフォルトコンストラクタ */
        public NyukinDummy() {
            this.checked = false;
        }
    }

}