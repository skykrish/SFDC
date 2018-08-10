public with sharing class AnkenTriggerHandler {

    private boolean m_isExecuting = false;
    private integer batchSize = 0;
    
    /** 納品処理アサインフラグ */
    private Boolean asainFlg {get;set;}
    
    /** 納品ステータス */
    private String NOHINSHORI = '納品処理中';

    /**
     * コンストラクタ
     */
    public AnkenTriggerHandler(boolean isExecuting, integer size){
        this.m_isExecuting = isExecuting;
        this.batchSize = size;
        
        asainFlg = false;
    }

    public void onBeforeInsert(Anken__c[] updatedObjs){
        this.setNoukiGMT(updatedObjs);
        // 納品処理担当者更新
        this.setInsertInvoicePersonnel(updatedObjs);
    }

    public void onAfterInsert(Anken__c[] updatedObjs, Map<ID, Anken__c> ObjMap){
        // フィード投稿
        this.setInsertFeed(updatedObjs);
    }

    public void onBeforeUpdate(Anken__c[] oldObjs, Map<ID, Anken__c> oldObjMap, Anken__c[] updatedObjs, Map<ID, Anken__c> newObjMap){
        // 納期日時（GMT）更新
        this.setNoukiGMT(updatedObjs);
        // 納品処理担当者更新
        this.setUpdateInvoicePersonnel(oldObjs, updatedObjs, oldObjMap, newObjMap);
        // フィード投稿
        this.setUpdateFeed(oldObjs, updatedObjs, oldObjMap, newObjMap);
    }

    public void onAfterUpdate(Anken__c[] oldObjs, Anken__c[] updatedObjs, Map<ID, Anken__c> ObjMap){

        // 発注ステータス変更
        this.changeHachuStatus(oldObjs, updatedObjs);
    }


    /**
     * 納期日時（GMT）更新
     */
    private void setNoukiGMT(Anken__c[] updatedObjs) {

        // 納期日時（GMT）を更新
        for(Anken__c anken : updatedObjs) {

            if (anken.Nouki_Date__c != null && anken.Nouki_Time__c  != null) {
                String[] hhmm = anken.Nouki_Time__c.split('\\:');
                anken.Nouki_GMT__c = Datetime.newInstance(anken.Nouki_Date__c.year(), 
                                                            anken.Nouki_Date__c.month(), 
                                                            anken.Nouki_Date__c.day(), 
                                                            Integer.valueOf(hhmm[0]),
                                                            Integer.valueOf(hhmm[1]),
                                                            00
                                                            );
            } else {
                anken.Nouki_GMT__c = null;
            }
        }
    }

    /**
     * 発注ステータス変更
     */
    private void changeHachuStatus(Anken__c[] oldObjs, Anken__c[] updatedObjs) {

        // 処理対象案件リストを作成
        List<String> aidList = new List<String> ();
        for (Integer i = 0; i < oldObjs.size(); i ++) {
            // ステータスが受注作業完了に変更された場合のみ実行
            if (oldObjs[i].Status__c != updatedObjs[i].Status__c && updatedObjs[i].Status__c == '受注納品済み') {
                aidList.add(updatedObjs[i].Id);
            }
        }

        // 発注情報更新
        if (aidList.size() > 0) {
            // 発注情報取得
            List<HachuInfo__c> hachuInfoList = [SELECT Id, Name, HachuStatus__c FROM HachuInfo__c WHERE Anken__c = :aidList];
            // 発注ステータス更新
            for (HachuInfo__c item : hachuInfoList) {
                item.HachuStatus__c = '検収済み';
            }
            update hachuInfoList;
        }
    }
    
    /**
     * 納品処理担当者更新(insert)
     */
    private void setInsertInvoicePersonnel(Anken__c[] updatedObjs) {

        // 納品処理担当者を更新
        for(Anken__c anken : updatedObjs) {
            if(anken.InvoicePersonnelAsain__c != null){
                asainFlg = true;
            }
        }
        
        for(Anken__c anken : updatedObjs) {
            if(!asainFlg){
                if(anken.Status__c == NOHINSHORI
                    && anken.InvoicePersonnel__c == null){
                    anken.InvoicePersonnel__c = UserInfo.getUserId();
                }
            }else{
                anken.InvoicePersonnelAsain__c = null;
            }
        }
    }
    
    /**
     * 納品処理担当者更新(update)
     */
    private void setUpdateInvoicePersonnel(Anken__c[] oldObjs, Anken__c[] newObjs, Map<ID, Anken__c> oldObjMap, Map<ID, Anken__c> newObjMap) {
        
        List<Anken__c> ankenList = new List<Anken__c>();
        
        for(Anken__c anken : newObjs) {
            if(!anken.NohinshoriFlg__c){
                if(oldObjMap.get(anken.Id).Status__c != NOHINSHORI 
                    && newObjMap.get(anken.Id).Status__c == NOHINSHORI
                    && oldObjMap.get(anken.Id).InvoicePersonnel__c == newObjMap.get(anken.Id).InvoicePersonnel__c){
                    anken.InvoicePersonnel__c = UserInfo.getUserId();
                }
            }else{
                anken.NohinshoriFlg__c = false;
            }
        }
        
    }
    
    /**
     * 納品処理担当者フィード投稿(insert)
     */
    private void setInsertFeed(Anken__c[] insertObjs){
        
        for(Anken__c anken : insertObjs){
            
/** mod start 2017-08-01 */
//            if(anken.InvoicePersonnel__c != null){
            if(anken.InvoicePersonnel__c != null && anken.Status__c != '請求確定済み'){
/** mod end 2017-08-01 */
                
                setChatterFeed(anken);
            }
        }
    }
    
    /**
     * 納品処理担当者フィード投稿(update)
     */
    private void setUpdateFeed(Anken__c[] oldObjs, Anken__c[] newObjs, Map<ID, Anken__c> oldObjMap, Map<ID, Anken__c> newObjMap){
        
        List<Anken__c> ankenList = new List<Anken__c>();
        
        //フィード投稿レコード取得
        for(Anken__c anken : newObjs){
            if(oldObjMap.get(anken.Id).InvoicePersonnel__c != newObjMap.get(anken.Id).InvoicePersonnel__c && anken.InvoicePersonnel__c != null){
                ankenList.add(anken);
            }
        }
        
        if(ankenList.size() != 0){
            for(Anken__c anken : ankenList){
                
                setChatterFeed(anken);
            }
        }
    }
        
    /**
     * Chatter投稿
     */
    private void setChatterFeed(Anken__c anken){
        
        //詳細ページURL
        String ankenURL = '';
        ankenURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + anken.id;
        
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        mentionSegmentInput.id = anken.InvoicePersonnel__c;
        messageBodyInput.messageSegments.add(mentionSegmentInput);

        textSegmentInput.text = '\n' + System.Label.AnkenChatter + '\n\n' + ankenURL;
        messageBodyInput.messageSegments.add(textSegmentInput);

        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = anken.Id;
        
        If(!Test.isRunningTest()){
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        }
    }
}