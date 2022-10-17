public inherited sharing class TriggerHandlerConfigurationUtils {
    private static Map<String, TriggerHandlerConfiguration__mdt> configurationRecords;
    private static Map<String, String> contextXFieldMap = new Map<String, String>{
        'BEFORE_INSERT' => 'ShouldRunBeforeInsert__c',
        'BEFORE_UPDATE' => 'ShouldRunBeforeUpdate__c',
        'BEFORE_DELETE' => 'ShouldRunBeforeDelete__c',
        'AFTER_INSERT' => 'ShouldRunAfterInsert__c',
        'AFTER_UPDATE' => 'ShouldRunAfterUpdate__c',
        'AFTER_DELETE' => 'ShouldRunAfterDelete__c',
        'AFTER_UNDELETE' => 'ShouldRunAfterUndelete__c'
    };
    public static Map<String, TriggerHandlerConfiguration__mdt> getConfigurationRecords(){
        if(configurationRecords != null){
            return configurationRecords;
        }
        List<TriggerHandlerConfiguration__mdt> records = [
            Select
                Id,
                TriggerObject__r.QualifiedApiName,
                ShouldRun__c,
                ShouldRunAfterDelete__c,
                ShouldRunAfterInsert__c,
                ShouldRunAfterUndelete__c,
                ShouldRunAfterUpdate__c,
                ShouldRunBeforeDelete__c,
                ShouldRunBeforeInsert__c,
                ShouldRunBeforeUpdate__c
            From TriggerHandlerConfiguration__mdt
        ];
        configurationRecords = new Map<String, TriggerHandlerConfiguration__mdt>();
        for(TriggerHandlerConfiguration__mdt thc : records){
            configurationRecords.put(thc.TriggerObject__r.QualifiedApiName, thc);
        }
        return getConfigurationRecords();
    }

    public static TriggerHandlerConfiguration__mdt getConfigurationBySObjectName(String sObjectName){
        Map<String, TriggerHandlerConfiguration__mdt> recordsMap = getConfigurationRecords();
        TriggerHandlerConfiguration__mdt thc = recordsMap.get(sObjectName);
        if(thc == null){
            String message = 'SObject name not found in the configuration: ' + sObjectName;
            throw new TriggerHandlerConfigurationException(message);
        }
        return thc;
    }
    public static String getFieldForContext(String context){
        String fieldName = contextXFieldMap.get(context);
        if(String.isBlank(fieldName)){
            String message = 'Field not found for this specific context: ' + context;
            throw new TriggerHandlerConfigurationException(message);
        }
        return fieldName;
    }
    public static Boolean canRun(String sObjectName, String context){
        TriggerHandlerConfiguration__mdt thc = getConfigurationBySObjectName(sObjectName);
        String fieldName = getFieldForContext(context);
        Boolean shouldRun = thc.ShouldRun__c;
        Boolean shouldRunContext = (Boolean)thc.get(fieldName);
        Boolean toReturn = shouldRun && shouldRunContext;
        return toReturn;
    }
    public class TriggerHandlerConfigurationException extends Exception{}
}
