<?php // /web/html/test.php

// MySQL with PDO
$dns = 'mysql:dbname=' . DB_NAME . ';host=db;charset=utf8;';
$options = [
  // カラム型に合わない値がINSERTされようとしたときSQLエラーとする
  PDO::MYSQL_ATTR_INIT_COMMAND => "SET SESSION sql_mode='TRADITIONAL'",
  // SQLエラー発生時にPDOExceptionをスローさせる
  PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
];
try {
  $pdo = new PDO($dns, DB_USER, DB_PASSWORD, $options);
  var_dump($pdo);
} catch (PDOException $e) {
  echo $e->getMessage();
}

// Redis
$redis = new Redis();
// connect の第一引数は docker-compose.yml のイメージ名を指定する
$redis->connect('redis', 6379);
var_dump($redis->ping()); // => true

phpinfo();