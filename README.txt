vagrant-chef-centos-wordpress
=============================

これは、WordPress開発用のVagrantファイルです。
このVagrantファイルを利用すると、`vagrant up` だけで以下のような特徴のWordPress環境が数分で構築できます。

* Vagrantfileを数行修正するだけでForce SSL AdminやMultisite、任意のサブディレクトリへのインストールなど、多様な環境に対応しています。
* 仮想マシンが起動したらWordPressのインストールは不要です。http://wordpress.local/ にアクセスしてください。(ユーザー名: `admin`、パスワード: `admin`)
* URLはカスタマイズ可能で、vagrant-hostsupdaterを使用すれば起動時に `/etc/hosts` にレコードを追加し、停止時に自動的に削除します。
* デフォルトでデバッグモードが有効化されています。
* デフォルトでSSLが設定されており、SSL環境での動作テストが可能です。
* 開発に便利な、theme-check, plugin-checkプラグインが有効化されています。
* [wp-cli](http://wp-cli.org/)がプリインストールされています。
* Vagrantファイル内の `www` ディレクトリと、仮想マシン内の `/var/www` が同期しています。


## インストール方法

1. VirtualBoxをインストールしてください。
 * https://www.virtualbox.org/
2. Vagrantをインストールしてください。
 * http://www.vagrantup.com/
3. vagrant-hostsupdater をインストールしてください。
 * `vagrant plugin install vagrant-hostsupdater`
4. Vagrantファイルをcloneしてください。
 * `git clone https://github.com/miya0001/vagrant-chef-centos-wordpress.git vagrant-wp`
5. Vagrantディレクトリへ移動。
 * `cd vagrant-wp`
6. 仮想マシンを起動。
 * `vagrant up`

## WordPressについて

* デフォルトのURLは、http://wordpress.local/ です。
* デフォルトのユーザー名は、 `admin` パスワードも `admin` です。
* デフォルトでデバッグモードが有効になっています。
* プリインストールのプラグインは以下のとおりです。
 * hotfix
 * theme-check
 * plugin-check
 * wp-multibyte-patch (jaのみ)

## カスタマイズ

Vagrantfileの定数を修正するだけであらゆる環境のWordPressを構築することができます。

* WP_VERSION         = 'latest' # Wordpress version latest or 3.4 or later
* WP_LANG            = "ja" # WordPress locale
* WP_HOSTNAME        = "wordpress.local" # e.g example.com
* WP_DIR             = '' # e.g. /wp or wp or other
* WP_TITLE           = "Welcome to the Vagrant" # title
* WP_ADMIN_USER      = "admin" # default user
* WP_ADMIN_PASS      = "admin" # default user's password
* WP_DB_PREFIX       = 'wp_' # Database prefix
* WP_DEFAULT_PLUGINS = %w(theme-check plugin-check hotfix) # default plugins
* WP_DEFAULT_THEME   = '' # e.g. twentythirteen
* WP_IS_MULTISITE    = false # enable multisite when true
* WP_FORCE_SSL_ADMIN = false # enable force ssl admin when true
* WP_ALWAYS_RESET    = true # always reset database
* WP_IP              = "192.168.33.10" # host ip address

## その他

* Vagrantfileの8行目を任意のホスト名に書き換えると、`vagrant up` 後に `/etc/hosts` に自動的にレコードを追加します。
* `vagrant halt` で仮想マシンを停止、もしくは `vagrant destroy` で仮想マシンを破棄すると、`/etc/hosts`のレコードは自動的に削除されます。

## おねがい

* VagrantもChefもRubyも初めてなので何かあったらやさしくフィードバックをお願いします。笑
* あと、pull request等は大歓迎です。
