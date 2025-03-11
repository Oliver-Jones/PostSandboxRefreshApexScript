public class PostSandboxRefreshScripts implements Metadata.DeployCallback {
    public static void run() {
    	PostSandboxRefreshScripts.updateMetadata();
        PostSandboxRefreshScripts.runAsync();
        PostSandboxRefreshScripts.insertCustomObjectRecords();
        PostSandboxRefreshScripts.insertStandardObjectRecords();
    }
    
    @future(callout=true)
    public static void runAsync() {
        PostSandboxRefreshScripts.updateCustomLabels('');
    }
    
	public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
    }
    public static void createUpdateMetadata(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;
        for(String key : fieldWithValuesMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldWithValuesMap.get(key); 
            customMetadata.values.add(customField);
        }
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        PostSandboxRefreshScripts callback = new PostSandboxRefreshScripts();
        if(!Test.isRunningTest()) Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
    private static void updateMetadata() {
        PostSandboxRefreshScripts.createUpdateMetadata('My_Metadata.Demo1', 'Demo1', new Map<String, Object>{'Value__c' => 'John'});
        PostSandboxRefreshScripts.createUpdateMetadata('My_Metadata.Demo2', 'Demo2', new Map<String, Object>{'Value__c' => 'Doe'});
    }
    
    private static void updateCustomLabels(String sandboxName) {
        Organization org = [select issandbox, organizationtype, InstanceName, name from organization][0];
        System.debug(''+PostSandboxRefreshScripts.updateCustomLabel('My_Custom_Label_1', 'My Custom Label 1', 'en_US', 'Mary', false));
        System.debug(''+PostSandboxRefreshScripts.updateCustomLabel('My_Custom_Label_2', 'My Custom Label 2', 'en_US', 'Jane', false));
    }
    public static boolean updateCustomLabel(string csname,string description,string language,string value, boolean isProtected){
        List<MetadataService.Metadata> allMetadataList = new List<MetadataService.Metadata>();
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomLabel csLabel = new MetadataService.CustomLabel();
        csLabel.fullName = csname;
        csLabel.language = language;
        csLabel.protected_x  = isProtected;
        csLabel.shortDescription  = description;
        csLabel.value = value;
        allMetadataList.add(csLabel);
        List<MetadataService.SaveResult> results = service.updateMetadata(allMetadataList);
        for(MetadataService.SaveResult result: results) {
            system.debug('update custom label results success='+result.success);
        }
        return results[0].success;
    }   
    public static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
    
    @future
    private static void insertCustomObjectRecords() {
        insert new Custom_Object_1__c(Name = 'Test 1', Value__c = 'Tester 1');
        insert new Custom_Object_2__c(Name = 'Test 2', Value__c = 'Tester 2');
    }
    
    @future
    private static void insertStandardObjectRecords() {
        insert new Account(Name = 'Test 1');
        insert new Account(Name = 'Test 2');
    }
}