vagrant-chef-centos-wordpress
=============================

これは、WordPress開発用のVagrantファイルです。  
このVagrantファイルを利用すると、`vagrant up` だけで以下のような特徴のWordPress環境が数分で構築できます。

* インストール不要です。http://wordpress.local/ にアクセスしてください。(ユーザー名: `admin`、パスワード: `admin`)
* URLはカスタマイズ可能で、vagrant-hostsupdaterを使用すれば起動時に `/etc/hosts` にレコードを追加し、停止時に自動的に削除します。
* デフォルトでデバッグモードが有効化されています。
* 開発に便利な、theme-check, plugin-checkプラグインが有効化されています。
