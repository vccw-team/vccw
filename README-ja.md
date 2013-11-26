# VCCW (vagrant-chef-centos-wordpress)

これは、WordPressのプラグインやテーマ、ウェブサイトなどの開発用のVagrantファイルです。

このVagrantファイルを使用すると、プラグインやテーマのテストに必要な多様な環境を数分で構築でき、チームでウェブサイトを構築する際にはVagrantfileを共有するだけで、サイトの環境そのものをチームメンバー全員で共有することができます。

* Vagrantfileを数行修正するだけでForce SSL Adminやマルチサイト、任意のサブディレクトリへのインストールなど、多様な環境に対応しています。
* 仮想マシンが起動したらWordPressのインストールは不要です。http://wordpress.local/ にアクセスしてください。(ユーザー名: `admin`、パスワード: `admin`)
* URLはカスタマイズ可能で、vagrant-hostsupdaterを使用すれば起動時に `/etc/hosts` にレコードを追加し、停止時に自動的に削除します。
* デフォルトでデバッグモードが有効化されています。
* デフォルトでSSLが設定されており、SSL環境での動作テストが可能です。
* 開発に便利な、theme-check, plugin-checkプラグインが有効化されています。
* テーマユニットテストのデータを自動的にインポートすることが可能です。
* [wp-cli](http://wp-cli.org/)がプリインストールされています。
* Vagrantファイル内の `www` ディレクトリと、仮想マシン内の `/var/www` が同期しています。
* ホストマシンのMacに[wp-cli](http://wp-cli.org)がインストールされていれば、ホストマシンからもwp-cliを使ったデータベースのエクスポート等が可能です。

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
6. Vagrantfileを準備。
 * `cp Vagrantfile.sample Vagrantfile`
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

* `WP_VERSION = 'latest'`
 * WordPressのバージョンを指定できます。(WordPress 3.4以降のみ)
 * 最新版を使用したい場合は、`latest` を指定してください。(デフォルト)
 * [ベータ版](http://wordpress.org/download/release-archive/)を指定することも可能です。(例: 3.7-beta2)
* `WP_LANG = "ja"`
 * wp-config.phpに指定するWordPressの言語(WP_LANGの値)を指定してください。
 * `WP_VERSION` の値との組み合わせによっては、その言語のバージョンが存在しないためにエラーになる可能性があります。その場合はこの値を `""` にしてください。
* `WP_HOSTNAME = "wordpress.local"`
 * WordPressサイトのホスト名を指定してください。(例: `exmaple.com` 、`digitalcube.jp` など)
 * この値はWordPressのURLにも使用されます。
* `WP_DIR = ''`
 * WordPressをサブディレクトリ以下にインストールしたい場合はサブディレクトリ名を指定してください。
 * WordPressのURLは、`WP_HOSTNAME` と `WP_DIR` を結合したものが使用されます。
 * たとえば、`http://wordpress.local/wp/` でWordPressを構築する場合は、`/wp` または `wp` と指定してください。
* `WP_TITLE = "Welcome to the Vagrant"`
 * デフォルトのWordPressのタイトルを指定してください。
* `WP_ADMIN_USER = "admin"`
 * デフォルトのWordPressのユーザー名を指定してください。
 * このVagrantfileでエクスポートしたデータを本番サイトに適用する際のために、ここはカスタマイズして使用することを推奨します。
* `WP_ADMIN_PASS = "admin"`
 * デフォルトのユーザーのパスワードを指定してください。
* `WP_DB_PREFIX = 'wp_'`
 * WordPressのデータベース内のテーブルに使用されるプレフィックスを指定してください。
* `WP_DEFAULT_PLUGINS = %w(theme-check plugin-check hotfix)`
 * デフォルトでインストール&有効化するプラグインを配列で指定してください。
 * プラグインは、公式ディレクトリ上のプラグインであればプラグイン名、もしくは `.zip` ファイルまでのURLでも指定できます。
* `WP_DEFAULT_THEME = ''`
 * デフォルトでインストール&有効化するテーマを指定してください。
 * テーマは、.zipまでのURLを指定するか、公式ディレクトリ上のテーマであれば `twentyfourteen` などのテーマ名でも指定可能です。
* `WP_IS_MULTISITE = false`
 * `true` に変更すると、マルチサイトが有効化されます。
 * マルチサイトは、デフォルトでサブディレクトリ型になります。サブドメイン型を使用するにはwp-config.phpを手作業で修正してください。
 * サブドメイン型のマルチサイトを構築するには別途DNSサーバー等を用意する必要があります。
* `WP_FORCE_SSL_ADMIN = false`
 * `true` に変更すると、ログイン時及び管理画面でSSLが強制されます。
 * SSLの証明書はダミーの自己証明書が適用されています。
* `WP_DEBUG = true`
 * `true` の場合、デバッグモードが有効化されます。(デフォルト)
 * 開発用を想定しているので、有効化しておくことをご推奨します。
* `WP_THEME_UNIT_TEST = false`
 * `true` にすると[テーマユニットテスト](http://codex.wordpress.org/Theme_Unit_Test)用のデータを自動的にインポートします。
* `WP_ALWAYS_RESET = true`
 * `true` の場合、`vagrant provision` のたびに、WordPressデータベースが再構築されます。(デフォルト)
 * データベースが再構築されると、投稿した記事等のデータは全て消えますのでご注意ください。
* `WP_IP = "192.168.33.10"`
 * 仮想マシンのプライベートIPアドレスを指定してください。

### プロビジョニング後のVagrantfileのカスタマイズについて

プロビジョニング後(`vagrant up`した後)にVagrantfileを修正しその結果を反映するには以下の手順を踏む必要があります。

1. `vagrant up` でマシンを起動
2. Vagrantfileを修正。このとき `WP_ALWAYS_RESET` の値が `true` であること。
3. `vagrant provision` コマンドを実行して変更内容を反映。
4. `vagrant reload` でマシンを再起動。

なお、`vagrant provision` の際にはWordPress本体は、Vagrantfileで指定されたものに上書きされますが、`wp-content/` 以下のプラグインやテーマ等のファイルは、プロビジョニング前のファイルがそのまま残ります。

### /etc/hosts について

* Vagrantのプラグイン vagrant-hostsupdater を使用することで、Vagrantfileで指定したホスト名が自動的に `/etc/hosts` に追加されます。
* `vagrant halt` もしくは `vagrant destroy` でマシンを停止すれば、`/etc/hosts` に追加されたホスト名は自動的に削除されます。

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

## サーバーの設定等

* ファイヤーウォールは、以下のポートを開放しています。
 * 22 - SSH用
 * 80 - HTTP用
 * 443 - HTTPS用
 * 3306 - MySQL用(ホストマシンからwp-cliを使用するために開放しています。)
* CentOS 6.4系を使用しています。
 * PHP 5.3.x
 * MySQL 5.1.x
 * Apache 2.2.x
* プロビジョニングに時間がかかるのでパッケージのアップデート等はしてません。

## WordPress i18n toolsによるテーマやプラグインの翻訳方法

仮想マシンにSSHで接続する。

    vagrant ssh

テーマ(またはプラグイン)ディレクトリ内のlanguagesディレクトリに移動

    cd /var/www/wordpress/wp-content/themes/xxxxx/languages

.pot ファイルを作成する

    makepot wp-theme ..  # テーマの場合
    makepot wp-plugin .. # プラグインの場合

あとは、.pot から .po を作って、翻訳作業を行なってください。

.po から .mo を作成するには、以下のような感じのコマンドを実行してください。

    msgfmt ja.po -o ja.mo

## ご注意

* `vagrant halt` でマメにマシンを停止しないと、仮想マシンが大量に立ち上がっちゃうので気をつけましょう。
* 用が終わったら `vagrant destroy` で、マシンを破棄するのもお忘れなく。

## おねがい

* pull requestは大歓迎です。
* メールやDM等での直接の質問はご遠慮願います。
* バグ報告やご要望は、[Issues](https://github.com/miya0001/vagrant-chef-centos-wordpress/issues) へどうぞ！

## Contibutors

* [@miya0001](http://twitter.com/miya0001) - http://wpist.me/
* [@naokomc](http://twitter.com/naokomc) - http://naoko.cc/
