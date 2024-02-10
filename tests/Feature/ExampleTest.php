<?php

test('make an HTTP request to this app', function () {
    /**
     * Builds a Slim request object.
     * @source https://github.com/slimphp/Slim-Psr7/blob/master/src/Factory/ServerRequestFactory.php
     * 
     * Once you have a request object, you can add a request body, headers, and more.
     * @see https://www.slimframework.com/docs/v4/objects/request.html#the-request-headers
     */
    $request = $this->request->createServerRequest('GET', '/hello/joe');
    /**
     * "Executes" the request and returns Slim's response object,
     * which you can then use to get the status code and response body.
     * @see https://www.slimframework.com/docs/v4/objects/response.html#the-response-status
     * @source https://github.com/slimphp/Slim/blob/4.x/Slim/App.php
     */
    $response = $this->app->handle($request);
    $body = $response->getBody() . ""; // This is a hacky way to execute $response->__toString();

    expect($response->getStatusCode())->toBe(200);
    expect($body)->toBe("Hello, joe");
});
