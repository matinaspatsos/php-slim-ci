<?php

namespace Tests;

use PHPUnit\Framework\TestCase as BaseTestCase;
use App\App;
use Slim\Psr7\Factory\ServerRequestFactory;
use Psr\Http\Message\ServerRequestFactoryInterface;

abstract class FeatureTestCase extends BaseTestCase
{
    public $app;
    public ServerRequestFactoryInterface $request;

    public function __construct(...$args)
    {
        parent::__construct(...$args);

        $this->app = new App;

        $this->request = new ServerRequestFactory;
    }
}
