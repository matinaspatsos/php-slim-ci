<?php

namespace App;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\App as SlimApp;

class App
{
  protected SlimApp $app;

  public function __construct()
  {
    $this->app = AppFactory::create();
    $this->app->addRoutingMiddleware();

    // TODO update me
    $this->app->addErrorMiddleware(true, true, true);

    $this->app->get('/hello/{name}', function (Request $request, Response $response, $args) {
      $name = $args['name'];
      $response->getBody()->write(json_encode(['message' => 'Hello ' . $name]));
      return $response->withHeader('Content-Type', 'application/json');
    });

    $this->app->get('/', function (Request $request, Response $response) {
      $response->getBody()->write(json_encode(['ping' => 'pong!']));
      return $response->withHeader('Content-Type', 'application/json');
    });
  }

  public function __call(string $name, array $args)
  {
    return $this->app->$name(...$args);
  }
}
