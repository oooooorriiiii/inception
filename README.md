# README

## 機能説明

volume用の`data`ディレクトリが`${HOME}`に作成されます．

```bash
${HOME}/data/db_data
${HOME}/data/radis_data
${HOME}/data/web_data
```

## Review

## 準備

`/etc/hosts` に 以下を追記してください．

```bash
127.0.0.1 ymori.42.jp
```

レビュー項目にあるためです．これで `ymori.42.jp` で localhost にアクセスできるようになります．

レビュー後に削除してください．


## Make

`make run`で build から up までが完了するようになっています．

## nginx

- `http://localhost` ではアクセスできないようになっています．これは課題の要件です
- `https://localhost` SSL を通してアクセスできます．
- 自身により発行した証明書のため（本来は信頼できるCAが発行する）「このサイトは安全ではありません」という警告が出ますが，無視してアクセスしてください

## volume

web_data ディレクトリになにかファイルを作成すると，`autoindex` のページにファイルが追加されていることが確認できます．

## php-fpm
`for-review/php-fpm-test.php` ファイルを `${HOME}/data/web_data/` にコピーしてください．このファイルにアクセスすることで php による fast-cgi の簡単なテストが実行され，パラメータが取得できます．

## Redis

redis のコンテナの中に入って `redis-cli monitor` を実行してください．
workpress のページにアクセスすると，redis の動きを確認することができます．

## Adminer

1. `http://localhost:8080` にアクセスする（SSL には対応していません．`https` ではアクセスできません）
2. 以下の情報を入力する

|  | .envとの対応 | default (.env) |
| :-- | :--  | :--  |
| データベース種類   |           |  MySQL |
| サーバ            |            | mariadb |
| ユーザ名          | WP_DB_USER | db_user |
| パスワード         | WP_DB_PASSWORD | 42inception |
| データベース       | WP_DB_NAME | wordpress |

## その他

`wp` コマンドでのダウンロードがたまにコケます．これはダウンロード先のサイトのアクセス過多の問題らしいので，何回かやると正常に動きます．
