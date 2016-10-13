=== TinyMCE Templates ===
Contributors: miyauchi
Tags: tinymce, Visual Editor, template
Requires at least: 4.0
Tested up to: 4.4
Stable tag: 4.4.3

TinyMCE Template plugin will enable to use HTML template on WordPress Visual Editor.

== Description ==

TinyMCE Template plugin will enable to use HTML template on WordPress Visual Editor.

* [Website](http://miya0001.github.io/tinymce-templates/)
* [GitHub](https://github.com/miya0001/tinymce-templates)

= Some features: =

* Add "Insert Template" button to Visual Editor.
* You can edit template on WordPress admin.
* Copy to template from posts & pages.
* You can insert templates as shortcode.

= Translators: =

* Japanese(ja) - [Takayuki Miyauchi](http://wpist.me/)
* Italian(it_IT) - [Andrea Bersi](http://www.andreabersi.com)
* Swedish(sv_SE) - Tobias Bergius
* German(de_DE) - [nebojsa-simic](https://github.com/nebojsa-simic), [Martin Lettner](http://www.martinlettner.info/)
* Spanish(es_ES) - [David Bravo](http://www.dimensionmultimedia.com/)
* Dutch(nl_NL) - [Frank Groeneveld](http://ivaldi.nl/)
* French(fr_FR) - [HAROUY Jean-Michel](http://www.laposte.net/)
* Brazilian Portuguese(pt_BR) - [Rafael Funchal](http://www.rafaelfunchal.com.br/)
* Filipino(fil_PH) - [Morten Elm](http://www.storbyfan.dk/)
* Russian(ru_RU) - ihtimir
* Slovak(sk_SK) - [Branco](http://webhostinggeeks.com/user-reviews/)
* Hebrew(he_IL) - [Ahrale](http://atar4u.com/)
* Chinese(zh_CN) - [Riant](http://www.notidea.com/)

You can send your own language pack to me.

= Note =

How to display insert template button on wysiwyg editor of the ACF.

add_filter( 'tinymce_templates_enable_media_buttons', function(){
    return true; // Displays insert template button on all visual editors
} );

== Installation ==

* A plug-in installation screen is displayed on the WordPress admin panel.
* It installs it in `wp-content/plugins`.
* The plug-in is made effective.
* Open 'Template' menu.

== Screenshots ==

1. Template Admin.
2. Visual Editor.
3. Copy to new template from Edit Page.
4. Copy to new template from Admin Bar.

== Changelog ==

= 4.4.3 =

* Tested on WordPress 4.4.

= 4.4.0 =

* Bug fix when richedit is enabled.
* Add filter hook `tinymce_templates_enable_media_buttons`.

= 4.3.6 =

* Update German translation.

= 4.3.5 =

* Tested up to WordPress 4.2.

= 4.3.3 =

* Update Hebrew(he_IL) translation file.

= 4.3.2 =

* Fix closing modal window problem.
* Set same width with preview and content_width.
* Update js modal potision absolute to fixed.

= 4.3.1 =

* Bug fix on quick tags view.

= 4.0.0 =

* Remove sharing function.
* Add function inserting as shortcode.

= 3.4.0 =

* [Fix problem on the WordPress 3.9](https://github.com/miya0001/tinymce-templates/compare/3.3.0...3.4.0)

= 3.3.0 =
* [Fixed under the WordPtess 3.8.](https://github.com/miya0001/tinymce-templates/compare/3.2.0...3.3.0)

= 3.2.0 =
* Tested up to 3.7

= 3.0.0 =
* WordPress 3.5 fix

* [2.9.0](http://wpist.me/2012/06/14/tinymce-templates-2-9-0/)
* [2.8.0](http://wpist.me/2012/05/24/tinymce-templates-2-8-0/)
* [2.7.0](http://wpist.me/2012/05/19/tinymce-templates-2-7-0/)
* [2.6.0](http://wpist.me/2011/11/14/tinymce-templates-2-6-0/)
* [2.4.0](http://wpist.me/2011/11/14/tinymce-templates-2-4-0/)
* [2.3.0](http://wpist.me/2011/11/14/tinymce-templates-2-3-0/)
* [2.2.0](http://wpist.me/2011/11/13/tinymce-templates-2-2-0/)

== Credits ==

This plug-in is not guaranteed though the user of WordPress can freely use this plug-in free of charge regardless of the purpose.
The author must acknowledge the thing that the operation guarantee and the support in this plug-in use are not done at all beforehand.

== Contact ==

* http://wpist.me/
* twitter @wpist_me

== Special Thanks ==

* @kernfel on Twitter
