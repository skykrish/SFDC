@isTest(SeeAllData=true)
public class Epms_MyDirectory_Query_Locator_Test {


        static testMethod void test1(){
            set<id> teamids = new set<id>();
            List<id> filesids = new List<id>();
            set<id> fileset = new set<id>();
            
            Team__c t = [select id,name from Team__c where name='Team 06 - Phase 2'];
            teamids.add(t.id);
            Location__C l = [select id  from location__c where name='MBOI Phase-2'];
         
            for(files__c file: [select id from files__c limit 10]){
                filesids.add(file.id);
                fileset.add(file.id);
            }



            Member__c mem = [select id,name,User_Id__c from member__c where name='Aravinda R' and Status__c='Active'];
            user u = [select id,profileid from user where id=:mem.User_Id__c];
            

            


              
            Production_Order__c po3=new Production_Order__c();
            po3.Name ='Order_3';
            po3.Production_Order_Status__c ='New';
            insert po3;

             File_Categories__c fcTest= new File_Categories__c();
            fcTest.Name ='testEB';
            fcTest.Standard_Time_per_File_Min__c =11;
            fcTest.Standard_Time_per_File_Max__c =20;
            fcTest.Standard_Regular_Cost_per_File__c =1000;
            fcTest.Standard_OptionalCost_Per_file__c =6;
            insert fcTest;


              // Files for Order_1
            Files__c parentfileTest= new Files__c();
            parentfileTest.Name ='Order_1_File_Directory';
            parentfileTest.Production_Order__c =po3.id;
            parentfileTest.File_Category_Code__c =fcTest.id;
            parentfileTest.Status__c ='QCIP';
            parentfileTest.File_Location__c=l.id;
            parentfileTest.Current_Extension__c ='.jpg';
            parentfileTest.File_Type__c = 'Directory';
            //parentfileTest.TLInCharge__c = tlMemberTest.Id;
            //parentfileTest.QCIncharge__c = qcMemberTest.Id;
            insert parentfileTest;
         

            List<Files__c> fileListTest = new List<Files__c>();
            for(Integer i=1;i<=10;i++){
                Files__c file= new Files__c();
                file.Name ='OrderTest_File_'+i;
                file.Production_Order__c =po3.id;
                file.File_Category_Code__c =fcTest.id;
                if(i==1){
                    file.Name ='Test.db';
                    file.Status__c ='Assigned';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                } else if(i==2){
                    file.Status__c ='QC';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                } else if(i==3){
                    file.Status__c ='WIP';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                }else if(i==4){
                    file.Status__c ='QCIP';
                    file.QCIncharge__c = mem.Id;
                    file.Tracker_Handover__c = false;
                }
                 else {
                    file.Status__c ='New';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                    
                }
                file.File_Location__c=l.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
               
                file.instruction__c = 'Test File Instructions ::';
                file.parent_Id__c = parentfileTest.Id;
                fileListTest.add(file);
            }
            insert fileListTest; 
           

           
            EPMS_MyDirectory_Query_Locator QL = new EPMS_MyDirectory_Query_Locator();

       

         
            QL.getLoggedUserInformation();
            QL.getLoggedUserProfileInformation();
            QL.getAllShiftList();
            QL.getMemberTeamInformation(teamids);
            QL.getOrderLocationOfSelectedOrder(po3.id);
            QL.getMemberListExistInLocation(l.id);
            QL.getFileDetailInformation(filesids);
            QL.getFileExtensionInformation(fileset);
            QL.getFileInstructionDetails(fileset);
            QL.getMemberDesignation(u.id);
           QL.getUserProfileInfo(u.profileid);
           QL.getProductionOrderCount();
           QL.getProductionOrderListOrderByName(10,5);
           QL.getProductionOrderCountByQC_Or_TL(mem.id);
           QL.getActiveMemberInfo(u.id);
           QL.getProductionOrderForSaleRegion(u.id,10,5);
           QL.getProductionOrderAssigedTO_QC_OR_TL(mem.id,10,5);
           QL.getRelatedFileListForProductionOrders(po3.id);
           QL.getFileCategoryList();
           QL.getQCFilesRelatedToProductionOrder(po3.id);
           QL.getQCFileDetailsForUpdate(fileset);
           QL.getQCChildFileDetailsForUpdate(fileset);
           QL.getAssignedFileListWithoutProductionOrders(10,5);
           QL.getAssignedFileListWithProductionOrdersFor_QC_Or_TL(po3.id);
           QL.getOrderCountFromFilesList(mem.id);
                System.runAs(u){
           QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Status','ASC',false);
           QL.getQCFilesCountRelatedToProductionOrder(po3.id);
           }


        }

        static testMethod void test2(){
                 set<id> teamids = new set<id>();
            List<id> filesids = new List<id>();
            set<id> fileset = new set<id>();
            
            Team__c t = [select id,name from Team__c where name='Team 06 - Phase 2'];
            teamids.add(t.id);
            Location__C l = [select id  from location__c where name='MBOI Phase-2'];
         
            for(files__c file: [select id from files__c limit 10]){
                filesids.add(file.id);
                fileset.add(file.id);
            }



            Member__c mem = [select id,name,User_Id__c from member__c where name='Aravinda R' and Status__c='Active'];
            user u = [select id,profileid from user where id=:mem.User_Id__c];
            

            


              
            Production_Order__c po3=new Production_Order__c();
            po3.Name ='Order_3';
            po3.Production_Order_Status__c ='New';
            insert po3;

             File_Categories__c fcTest= new File_Categories__c();
            fcTest.Name ='testEB';
            fcTest.Standard_Time_per_File_Min__c =11;
            fcTest.Standard_Time_per_File_Max__c =20;
            fcTest.Standard_Regular_Cost_per_File__c =1000;
            fcTest.Standard_OptionalCost_Per_file__c =6;
            insert fcTest;


              // Files for Order_1
            Files__c parentfileTest= new Files__c();
            parentfileTest.Name ='Order_1_File_Directory';
            parentfileTest.Production_Order__c =po3.id;
            parentfileTest.File_Category_Code__c =fcTest.id;
            parentfileTest.Status__c ='QCIP';
            parentfileTest.File_Location__c=l.id;
            parentfileTest.Current_Extension__c ='.jpg';
            parentfileTest.File_Type__c = 'Directory';
            //parentfileTest.TLInCharge__c = tlMemberTest.Id;
            //parentfileTest.QCIncharge__c = qcMemberTest.Id;
            insert parentfileTest;
         

            List<Files__c> fileListTest = new List<Files__c>();
            for(Integer i=1;i<=10;i++){
                Files__c file= new Files__c();
                file.Name ='OrderTest_File_'+i;
                file.Production_Order__c =po3.id;
                file.File_Category_Code__c =fcTest.id;
                if(i==1){
                    file.Name ='Test.db';
                    file.Status__c ='Assigned';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                } else if(i==2){
                    file.Status__c ='QC';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                } else if(i==3){
                    file.Status__c ='WIP';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                }else if(i==4){
                    file.Status__c ='QCIP';
                    file.QCIncharge__c = mem.Id;
                    file.Tracker_Handover__c = false;
                }
                 else {
                    file.Status__c ='New';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    file.QCIncharge__c = mem.Id;
                    
                }
                file.File_Location__c=l.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
               
                file.instruction__c = 'Test File Instructions ::';
                file.parent_Id__c = parentfileTest.Id;
                fileListTest.add(file);
            }
            insert fileListTest; 
           

           
            EPMS_MyDirectory_Query_Locator QL = new EPMS_MyDirectory_Query_Locator();

            System.runAs(u){

                for(Integer i=0; i<9;i++){
                    if(i==0){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Status','DESC',false);
                        QL.getQCFilesCountRelatedToProductionOrder(po3.id);

                    }else if(i==1){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Operator','ASC',false);
                    }else if(i==2){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Operator','DESC',false);
                    }else if(i==3){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Extension','ASC',false);
                    }else if(i==4){
                          QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Extension','DESC',false);
                    }else if(i==5){
                         QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Category','ASC',false);
                    }else if(i==6){
                         QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Category','DESC',false);
                    }else if(i==7){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Name','ASC',false);
                    }else if(i==8){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Name','DESC',false);
                    }
                }

                       for(Integer i=0; i<10;i++){
                    if(i==0){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Status','DESC',true);
                        QL.getQCFilesCountRelatedToProductionOrder(po3.id);

                    }else if(i==1){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Operator','ASC',true);
                    }else if(i==2){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Operator','DESC',true);
                    }else if(i==3){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Extension','ASC',true);
                    }else if(i==4){
                          QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Extension','DESC',true);
                    }else if(i==5){
                         QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Category','ASC',true);
                    }else if(i==6){
                         QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Category','DESC',true);
                    }else if(i==7){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Name','ASC',true);
                    }else if(i==8){
                        QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Name','DESC',true);
                    }else if(i==9){
                         QL.getQCFilesRelatedToProductionOrder(po3.id,10,5,'Status','ASC',true);
                    }
                }
           
           }




        }
        

}