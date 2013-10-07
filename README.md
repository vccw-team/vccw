vagrant-chef-centos-wordpress
=============================

これは、WordPress開発用のVagrantファイルです。  
このVagrantファイルを利用すると、`vagrant up` だけで以下のような特徴のWordPress環境が数分で構築できます。

* インストール不要です。http://wordpress.local/ にアクセスしてください。(ユーザー名: `admin`、パスワード: `admin`)
* URLはカスタマイズ可能で、vagrant-hostsupdaterを使用すれば起動時に `/etc/hosts` にレコードを追加し、停止時に自動的に削除します。
* デフォルトでデバッグモードが有効化されています。
* 開発に便利な、theme-check, plugin-checkプラグインが有効化されています。
* Vagrantファイル内の `www` ディレクトリと、仮想マシン内の `/var/www` が同期しています。


## インストール方法

1. VirtualBoxをインストールしてください。
  * https://www.virtualbox.org/
2. Vagrantをインストールしてください。
3. vagrant-hostsupdater をインストールしてください。
4. Vagrantファイルをcloneしてください。
5. 仮想マシンを起動
