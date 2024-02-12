<?php

namespace App;

class Example
{
  public function testCiCd(): string
  {
    return "Wat???";
  }
  public static function test(): string
  {
    return "test";
  }
  public function sastFinding()
  {
    $password = "1234";
    $offset = $_GET['offset']; // beware, no input validation!
    $query  = "SELECT id, name FROM products ORDER BY name LIMIT 20 OFFSET $offset;";
    $result = pg_query($conn, $query);
  }
}
