<?php

use App\Example;

test('test() should return the string "test"', function () {
    expect(Example::test())->toBe('test');
});
