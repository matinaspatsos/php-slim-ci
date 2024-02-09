<?php

namespace App;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

class App
{
  // TODO type definition
  public $app;

  public function __construct()
  {
    $this->app = AppFactory::create();
    $this->app->addRoutingMiddleware();

    $errorMiddleware = $this->app->addErrorMiddleware(true, true, true);

    // TODO separate router
    $this->app->get('/hello/{name}', function (Request $request, Response $response, $args) {
        $name = $args['name'];
        $response->getBody()->write("Hello, $name");
        return $response;
    });
  }

  public function __call(string $name, array $args)
  {
    $this->app->$name(...$args);
  }
}
