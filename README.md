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

* WP_VERSION         = 'latest'
 * WordPressのバージョンを指定できます。(WordPress 3.4以降のみ)
 * 最新版を使用したい場合は、latestを指定してください。(デフォルト)
* WP_LANG            = "ja"
 * wp-config.phpに指定するWordPressの言語(WP_LANGの値)を指定してください。
* WP_HOSTNAME        = "wordpress.local"
 * WordPressサイトのホスト名を指定してください。(例: exmaple.com、digitalcube.jp など)
* WP_DIR             = ''
 * WordPressをサブディレクトリ以下にインストールしたい場合はサブディレクトリ名を指定してください。
 * たとえば、http://wordpress.local/wp/でWordPressを構築する場合は、`/wp` または `wp` と指定してください。
* WP_TITLE           = "Welcome to the Vagrant"
 * デフォルトのWordPressのタイトルを指定してください。
* WP_ADMIN_USER      = "admin"
 * デフォルトのWordPressのユーザー名を指定してください。
 * このVagrantfileでエクスポートしたデータを本番サイトに適用する際のために、ここはカスタマイズして使用することを推奨します。
* WP_ADMIN_PASS      = "admin"
 * デフォルトのユーザーのパスワードを指定してください。
* WP_DB_PREFIX       = 'wp_'
 * WordPressのデータベース内のテーブルに使用されるプレフィックスを指定してください。
* WP_DEFAULT_PLUGINS = %w(theme-check plugin-check hotfix)
 * デフォルトでインストール&有効化するプラグインを配列で指定してください。
 * プラグインは、公式ディレクトリ上のプラグインであればプラグイン名、もしくは `.zip` ファイルまでのURLでも指定できます。
* WP_DEFAULT_THEME   = ''
 * デフォルトでインストール&有効化するテーマを指定してください。
 * テーマは、.zipまでのURLを指定するか、公式ディレクトリ上のテーマであれば `twentyfourteen` などのテーマ名でも指定可能です。
* WP_IS_MULTISITE    = false
 * `true` に変更すると、マルチサイトが有効化されます。 
* WP_FORCE_SSL_ADMIN = false
 * `true` に変更すると、ログイン時及び管理画面でSSLが強制されます。
 * SSLの証明書はダミーの自己証明書が適用されています。
* WP_ALWAYS_RESET    = true
 * `true` の場合、`vagrant provision` のたびに、WordPressデータベースが再構築されます。(デフォルト)
 * データベースが再構築されると、投稿した記事等のデータは全て消えますのでご注意ください。
* WP_IP              = "192.168.33.10"
 * 仮想マシンのプライベートIPアドレスを指定してください。

## サイトのアドレスについて

* WP_HOSTNAMEを任意のホスト名に書き換えると、`vagrant up` 後に `/etc/hosts` に自動的にレコードを追加します。
* `vagrant halt` で仮想マシンを停止、もしくは `vagrant destroy` で仮想マシンを破棄すると、`/etc/hosts`のレコードは自動的に削除されます。
* この機能を使用すれば、投稿した記事データをそのまま本番環境で使用することができます。

## wp-cliについて

* このVagrantfileで構築される仮想マシンには、[wp-cli](http://wp-cli.org/) がインストールされています。
* ホストマシンののMacにwp-cliがインストールされていれば、ホストマシンからも仮想マシン上のWordPressに対してwp-cliを使ったオペレーションを行うことができます。

### wp-cliを使った操作の例

    cd vagrant-local
    
    # データベースをデスクトップにエクスポート
    wp db export ~/Desktop/export.sql
    
    # 記事やメディアなどをWordPressのエクスポート機能でエクスポート
    mkdir /Users/foo/Desktop/export
    wp export --dir=/Users/foo/Desktop/export
    
    # contcat-form-7を有効化
    wp plugin install contact-form-7 --activate
    
    # WordPressをアップデート
    wp core update

その他、wp-cliはいろんなことができますのでおすすめです。

## おねがい

* VagrantもChefもRubyも初めてなので何かあったらやさしくフィードバックをお願いします。笑
* あと、pull request等は大歓迎です。
