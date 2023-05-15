public class AccountActivationHelper {
    public static void validateAccountActivation(List<Account> updatedAccounts) {
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : updatedAccounts) {
            accountIds.add(acc.Id);
        }
        
        List<SQX_Team_Members__c> teamMembers = [
            SELECT Account__c, Member_Type__c
            FROM SQX_Team_Members__c
            WHERE Account__c IN :accountIds
                AND Member_Type__c IN ('HR', 'Admin')
        ];
        
        Map<Id, Set<String>> accountMemberTypes = new Map<Id, Set<String>>();
        for (SQX_Team_Members__c tm : teamMembers) {
            if (!accountMemberTypes.containsKey(tm.Account__c)) {
                accountMemberTypes.put(tm.Account__c, new Set<String>());
            }
            accountMemberTypes.get(tm.Account__c).add(tm.Member_Type__c);
        }
        
        for (Account acc : updatedAccounts) {
            if (!accountMemberTypes.containsKey(acc.Id) || 
                !accountMemberTypes.get(acc.Id).contains('HR') ||
                !accountMemberTypes.get(acc.Id).contains('Admin')) {
                acc.addError('Accounts cannot be Activated With Out Team Members Member Type as Admin and HR');
            }
        }
    }
}