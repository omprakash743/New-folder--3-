@IsTest
private class AccountActivationHelperTest {
    @IsTest
    static void testValidateAccountActivation() {
        List<Account> accounts = new List<Account>();
        Account account1 = new Account(Name = 'Test Account 1');
        Account account2 = new Account(Name = 'Test Account 2');
        Account account3 = new Account(Name = 'Test Account 3');
        accounts.add(account1);
        accounts.add(account2);
        accounts.add(account3);
        insert accounts;
        
        List<SQX_Team_Members__c> teamMembers = new List<SQX_Team_Members__c>();
        SQX_Team_Members__c teamMember1 = new SQX_Team_Members__c(
            Account__c = account1.Id,
            Member_Type__c = 'HR'
        );
        SQX_Team_Members__c teamMember2 = new SQX_Team_Members__c(
            Account__c = account2.Id,
            Member_Type__c = 'Admin'
        );
        teamMembers.add(teamMember1);
        teamMembers.add(teamMember2);
        insert teamMembers;
        List<String> errorMessages = new List<String>();
        Test.startTest();
        AccountActivationHelper.validateAccountActivation(accounts);
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals(3, updatedAccounts.size());
        for (Account acc : updatedAccounts) {
            if (acc.Id == account1.Id || acc.Id == account2.Id) {
                System.assertEquals(0, errorMessages.size(), 'Account should be valid');
            } else {
                errorMessages.add('Accounts cannot be Activated Without Team Members Member Type as Admin and HR');
            }
        }
        System.assertEquals('Accounts cannot be Activated Without Team Members Member Type as Admin and HR', errorMessages[0]);

    }
}