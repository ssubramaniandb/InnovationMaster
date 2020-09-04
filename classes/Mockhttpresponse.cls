@isTest
global class Mockhttpresponse Implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req)
    {
        HTTPResponse res= new HTTPResponse();
        res.setHeader('content-Type', 'applications/json');
        res.setBody('{"branches":"test2"}');
        res.setStatusCode(200);
        system.assertEquals(res.getStatusCode(), 200);
        return res;
        
    }
}