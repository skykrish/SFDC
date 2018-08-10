/**********************************************************************************
*   Class               :       clsTest_EPMS_FileOperator_Assignment              *
*   Created Date        :       31/08/2016                                        *
*   Description         :       Test Class for EPMS_Operator_Assignment_File      *
**********************************************************************************/

@isTest(seeAllData=true)
public class clsTest_EPMS_FileOperator_Assignment {

    static testMethod void operator_assignment_case_1(){
        
        PageReference pageRef = Page.EPMS_Operator_File_Assignment;
        Test.startTest();
        
         string basepath='Order';
            string type = 'assign';
            Test.setCurrentPage(pageRef);
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'MBOI Phase-1'];
        if(location != null){
            // Shift Information
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase 1' AND Status__c = 'Active'];
            // Team Information
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name = 'Team 01 - Phase 1'];
            // Shift Assignment Records
            List<Shift_Assignments__c> shiftAssignment = [SELECT Id, Name, Team_Assignment_Id__c, Member__c, Member__r.Designation__c FROM Shift_Assignments__c WHERE Shift_Code__c =: shift.Id AND Team_Assignment_Id__c =: team.Name ];
            List<Id> memberIds = new List<Id>();
            if(shiftAssignment != null){
                for(Shift_Assignments__c shiftass : shiftAssignment){
                    if(shiftass.Member__r.Designation__c == 'Photo Artists'){
                        memberIds.add(shiftass.Member__c);
                    }
                }
            }
            
            // Production Order Records
            
            List<Production_Order__c> orderList = [SELECT Id, Name FROM Production_Order__c WHERE Id IN (SELECT Production_Order__c FROM Files__c) AND Production_Order_Status__c = 'New'];
            List<Files__c> newFilesList = new List<Files__c>();
            Set<Id> orderNoIds = new Set<Id>();
            if(orderList != null && orderList.size() > 0){
                for(Production_Order__c newOrder : orderList){
                    orderNoIds.add(newOrder.Id);
                }
            }
            
            if(orderNoIds.size() > 0){
                newFilesList = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__c IN :orderNoIds AND Status__c = 'New' AND File_Type__c = 'Image' ];
            }
            pageRef.getParameters().put('ids',newFilesList[0].id);
            pageRef.getParameters().put('type',type);
            EPMS_Operator_Assignment_Controller assignment = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue=location.Id;
            assignment.selectvalue=selectvalue;
            assignment.selectedShift = shift.Id;
            assignment.CurrentTeams = team.Id;       
            assignment.setUnAssignMember = false;   
            assignment.selectedTeamlead = memberIds[0];
            assignment.assign_save(); 
            Test.stopTest();
            
        }
    }

    
    static testMethod void operator_assignment_case_2(){
        
        PageReference pageRef = Page.EPMS_Operator_File_Assignment;
        Test.startTest();
        
        string basepath='Order';
        string type = 'assign';
        Test.setCurrentPage(pageRef);
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'MBOI Phase-1'];
        if(location != null){
        // Shift Information
        Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase 1' AND Status__c = 'Active'];
        // Team Information
        Team__c team = [SELECT Id, Name FROM Team__c WHERE Name = 'Team 01 - Phase 1'];
        // Shift Assignment Records
        List<Shift_Assignments__c> shiftAssignment = [SELECT Id, Name, Team_Assignment_Id__c, Member__c, Member__r.Designation__c FROM Shift_Assignments__c WHERE Shift_Code__c =: shift.Id AND Team_Assignment_Id__c =: team.Name ];
        List<Id> memberIds = new List<Id>();
        if(shiftAssignment != null){
            for(Shift_Assignments__c shiftass : shiftAssignment){
                if(shiftass.Member__r.Designation__c == 'Team Leader'){
                    memberIds.add(shiftass.Member__c);
                }
            }
        }
            // Production Order Records
            
            List<Production_Order__c> orderList = [SELECT Id, Name FROM Production_Order__c WHERE Id IN (SELECT Production_Order__c FROM Files__c WHERE Status__c = 'Assigned') AND Production_Order_Status__c != 'New'];
            List<Files__c> newFilesList = new List<Files__c>();
            Set<Id> orderNoIds = new Set<Id>();
            if(orderList != null && orderList.size() > 0){
                for(Production_Order__c newOrder : orderList){
                    orderNoIds.add(newOrder.Id);
                }
            }
            if(orderNoIds.size() > 0){
                newFilesList = [SELECT Id, Name, Status__c, Member__c, Member__r.Name, Member__r.Designation__c FROM Files__c WHERE Production_Order__c IN :orderNoIds AND Status__c = 'Assigned' AND Member__c  != null AND File_Type__c = 'Image' ];
            }
            pageRef.getParameters().put('ids',newFilesList[0].id);
            pageRef.getParameters().put('type',type);
            EPMS_Operator_Assignment_Controller assignment = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue=location.Id;
            assignment.selectvalue=selectvalue;
            assignment.selectedShift = shift.Id;
            assignment.CurrentTeams = team.Id;       
            assignment.setUnAssignMember = false;   
            assignment.selectedTeamlead = memberIds[0];
            assignment.assign_save(); 
            
            pageRef.getParameters().put('ids',newFilesList[0].id);
            pageRef.getParameters().put('type',type);
            EPMS_Operator_Assignment_Controller assignmentW = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            //string selectvalue=location.Id;
            assignmentW.selectvalue=selectvalue;
            assignmentW.selectedShift = shift.Id;
            assignmentW.CurrentTeams = team.Id;       
            assignmentW.setUnAssignMember = false;   
            assignmentW.selectedTeamlead = memberIds[0];
            assignmentW.assign_save(); 
            
            // Re-Assign Scenario
            type = 'unassign';
            pageRef.getParameters().put('ids',newFilesList[0].id);
            pageRef.getParameters().put('type',type);
            EPMS_Operator_Assignment_Controller rreassignment = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            //string selectvalue=location.Id;
            rreassignment.selectvalue=selectvalue;
            rreassignment.selectedShift = shift.Id;
            rreassignment.CurrentTeams = team.Id;       
            rreassignment.setUnAssignMember = false;   
            rreassignment.selectedTeamlead = memberIds[0];
            rreassignment.assign_save();
            
            pageRef.getParameters().put('ids',newFilesList[0].id);
            pageRef.getParameters().put('type',type);
            EPMS_Operator_Assignment_Controller unassignment = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            unassignment.selectvalue=selectvalue;
            unassignment.selectedShift = shift.Id;
            unassignment.CurrentTeams = team.Id;       
            unassignment.setUnAssignMember = true;   
            unassignment.assign_save();
            Test.stopTest();
            
        }
    }
    
    // Assign the Directory
    static testMethod void operator_assignment_case_3(){
        
        PageReference pageRef = Page.EPMS_Operator_File_Assignment;
        Test.startTest();
        
        string basepath='Order';
        string type = 'assign';
        Test.setCurrentPage(pageRef);
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'MBOI Phase-1'];
        if(location != null){
            // Shift Information
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase 1' AND Status__c = 'Active'];
            // Team Information
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name = 'Team 01 - Phase 1'];
            // Shift Assignment Records
            List<Shift_Assignments__c> shiftAssignment = [SELECT Id, Name, Team_Assignment_Id__c, Member__c, Member__r.Designation__c FROM Shift_Assignments__c WHERE Shift_Code__c =: shift.Id AND Team_Assignment_Id__c =: team.Name ];
            List<Id> memberIds = new List<Id>();
            if(shiftAssignment != null){
                for(Shift_Assignments__c shiftass : shiftAssignment){
                    if(shiftass.Member__r.Designation__c == 'Photo Artists'){
                        memberIds.add(shiftass.Member__c);
                    }
                }
            }
            // Production Order Records
            
            List<Production_Order__c> orderList = [SELECT Id, Name FROM Production_Order__c WHERE Id IN (SELECT Production_Order__c FROM Files__c) AND Production_Order_Status__c = 'New'];
            List<Files__c> newFilesList = new List<Files__c>();
            Set<Id> orderNoIds = new Set<Id>();
            if(orderList != null && orderList.size() > 0){
                for(Production_Order__c newOrder : orderList){
                    orderNoIds.add(newOrder.Id);
                }
            }
            if(orderNoIds.size() > 0){
                newFilesList = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__c IN :orderNoIds AND Status__c = 'New' AND File_Type__c = 'Directory' ];
            }
            pageRef.getParameters().put('ids',newFilesList[0].id);
            pageRef.getParameters().put('type',type);
            EPMS_Operator_Assignment_Controller assignment = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue=location.Id;
            assignment.selectvalue=selectvalue;
            assignment.selectedShift = shift.Id;
            assignment.CurrentTeams = team.Id;       
            assignment.setUnAssignMember = false;   
            assignment.selectedTeamlead = memberIds[0];
            assignment.assign_save(); 
            Test.stopTest();
            
        }
    }
    
    
    // Redo Scenario other shift and team method coverage
    static testMethod void operator_assignment_case_4(){
        
        PageReference pageRef = Page.EPMS_Operator_File_Assignment;
        Test.startTest();
        
        string basepath='Order';
        string type = 'reassign';
        Test.setCurrentPage(pageRef);
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'MBOI Phase-1'];
        if(location != null){
            // Shift Information
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase 1' AND Status__c = 'Active'];
            // Team Information
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name = 'Team 01 - Phase 1'];
            // Shift Assignment Records
            List<Shift_Assignments__c> shiftAssignment = [SELECT Id, Name, Team_Assignment_Id__c, Member__c, Member__r.Designation__c FROM Shift_Assignments__c WHERE Shift_Code__c =: shift.Id AND Team_Assignment_Id__c =: team.Name ];
            List<Id> memberIds = new List<Id>();
            if(shiftAssignment != null){
                for(Shift_Assignments__c shiftass : shiftAssignment){
                    if(shiftass.Member__r.Designation__c == 'Photo Artists'){
                        memberIds.add(shiftass.Member__c);
                    }
                }
            }
            // Production Order Records
            
            List<Production_Order__c> orderList = [SELECT Id, Name FROM Production_Order__c WHERE Id IN (SELECT Production_Order__c FROM Files__c WHERE Status__c = 'Redo') AND Production_Order_Status__c != 'New'];
            List<Files__c> newFilesList = new List<Files__c>();
            Set<Id> orderNoIds = new Set<Id>();
            if(orderList != null && orderList.size() > 0){
                for(Production_Order__c newOrder : orderList){
                    orderNoIds.add(newOrder.Id);
                }
            }
            if(orderNoIds.size() > 0){
                newFilesList = [SELECT Id, Name, Status__c, File_Location__c, File_Location__r.Name FROM Files__c WHERE Production_Order__c IN :orderNoIds AND Status__c = 'Redo' AND File_Type__c = 'Image' AND Member__c != null];
            }
            pageRef.getParameters().put('ids',newFilesList[0].id);
            pageRef.getParameters().put('type',type);
            pageRef.getParameters().put('source',basepath);
            EPMS_Operator_Assignment_Controller assignment = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue=location.Id;
            assignment.selectvalue=selectvalue;
            assignment.selectedShift = shift.Id;
            assignment.CurrentTeams = team.Id;       
            assignment.setUnAssignMember = false;   
            assignment.selectedTeamlead = memberIds[0];
            assignment.assign_save(); 
            
            Member__c memberNoPerfGrp = [SELECT Id, Name FROM Member__c WHERE Performance_Rating__c = null AND Status__c = 'Active' AND Location_id__c =: location.Id LIMIT 1]; 
            Member__c memberTL = [SELECT Id, Name,User_Id__c FROM Member__c WHERE id=:memberIds[0]]; 
            User u=[select id,Name from User where ID=:memberTL.User_Id__c];
            EPMS_Operator_Assignment_Controller assignmentE = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            assignmentE.selectvalue=selectvalue;
            assignmentE.selectedShift = shift.Id;
            assignmentE.CurrentTeams = team.Id;       
            assignmentE.setUnAssignMember = false;   
            assignmentE.selectedTeamlead = memberNoPerfGrp.Id;
            assignmentE.assign_save(); 
            
            system.runas(u){
            EPMS_Operator_Assignment_Controller assignment2 = new EPMS_Operator_Assignment_Controller();
            assignment2.getFilesInfoForDisplay();
            assignment2.selectvalue=selectvalue;
            assignment2.getShifts();
            assignment2.selectedShift = shift.Id;
            assignment2.getSelectedShift();
            assignment2.setSelectedShift(shift.Id);          
            assignment2.getTeams();
            assignment2.CurrentTeams = team.Id;
            assignment2.getAssignmentDetails();
            assignment2.getAvailableTeamLeaders();
            assignment2.assign_save(); 
            assignment2.Cancel();
            assignment2.ShowPanel();
            }
            Test.stopTest();
            
        }
    }  
    
    
}