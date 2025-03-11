@IsTest
public class PostSandboxRefreshScriptsTest {
	@testsetup private static void loadData() {}
    @isTest private static void postScriptCheck() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockGenerator());
        /*
        Add the following to your Mock Class
        if(requestName == 'updateMetadata') {
            MetadataService.updateMetadataResponse_element respElement = new MetadataService.updateMetadataResponse_element();
            MetadataService.SaveResult[] result = new List<MetadataService.SaveResult>();
            result.add(new MetadataService.SaveResult());
            respElement.result = result;
            response.put('response_x', respElement);                                               
        }
		*/
        PostSandboxRefreshScripts.run();
        Test.stopTest();
    }
}