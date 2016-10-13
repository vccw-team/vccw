<?php
/*
Plugin Name: WP Total Hacks
Author: Takayuki Miyauchi
Plugin URI: https://github.com/miya0001/wp-total-hacks
Description: WP Total Hacks can customize your WordPress.
Version: 2.0.1
Author URI: http://wpist.me/
Domain Path: /languages
Text Domain: wp-total-hacks
*/


new TotalHacks();

class TotalHacks {

	private $option_params = array(
		'wfb_google_analytics' => 'text',
		'wfb_favicon' => 'url',
		'wfb_admin_favicon' => 'bool',
		'wfb_apple_icon' => 'url',
		'wfb_apple_icon_precomposed' => 'bool',
		'wfb_hide_version' => 'bool',
		'wfb_google' => 'text',
		'wfb_bing' => 'text',
		'wfb_hide_custom_fields' => 'bool',
		'wfb_revision' => 'int',
		'wfb_selfping' => 'bool',
		'wfb_widget' => 'array',
		'wfb_custom_logo' => 'url',
		'wfb_admin_footer_text' => 'html',
		'wfb_login_logo' => 'url',
		'wfb_login_url' => 'url',
		'wfb_login_title' => 'text',
		'wfb_webmaster' => 'bool',
		'wfb_remove_xmlrpc' => 'bool',
		'wfb_exclude_loggedin' => 'bool',
		'wfb_remove_more' => 'bool',
		'wfb_pageexcerpt' => 'bool',
		'wfb_postmetas' => 'array',
		'wfb_pagemetas' => 'array',
		'wfb_emailaddress' => 'email',
		'wfb_sendername' => 'text',
		'wfb_contact_methods' => 'array',
		'wfb_remove_excerpt' => 'bool',
		'wfb_update_notification' => 'bool',
		'wfb_createpagefordraft' => 'bool',
		'wfb_disallow_pingback' => 'bool',
		'wfb_shortcode' => 'bool',
		'wfb_oembed' => 'bool',
	 );

	public function __construct()
	{
		if ( is_admin() ) {
			require_once( dirname( __FILE__ ).'/includes/admin.php' );
			new TotalHacksAdmin(
				WP_PLUGIN_URL.'/'.dirname( plugin_basename( __FILE__ ) ),
				$this->option_params
			 );
		}
		if ( strlen( $this->op( 'wfb_revision' ) ) ) {
			if ( !defined( 'WP_POST_REVISIONS' ) ) {
				define( 'WP_POST_REVISIONS', $this->op( 'wfb_revision' ) );
			}
		}
		add_action( 'init',			  array( $this, 'init' ) );
		add_action( 'plugins_loaded',	array( $this, 'plugins_loaded' ) );
		add_action( 'get_header',		array( $this, 'get_header' ) );
		add_action( 'wp_head',		   array( $this, 'wp_head' ) );
		add_action( 'admin_head',		array( $this, 'admin_head' ) );
		add_filter( 'admin_footer_text', array( $this, 'admin_footer_text' ) );
		add_action( 'login_head',		array( $this, 'login_head' ) );
		add_action( 'admin_menu' ,	   array( $this, 'admin_menu' ) );
		add_filter( 'login_headerurl',   array( $this, 'login_headerurl' ) );
		add_filter( 'login_headertitle', array( $this, 'login_headertitle' ) );
		add_action( 'pre_ping',		  array( $this, 'pre_ping' ) );
		add_action( 'wp_dashboard_setup',array( $this, 'wp_dashboard_setup' ) );
		add_filter( 'the_content_more_link', array( $this, 'the_content_more_link' ) );
		add_filter( 'wp_mail_from',	  array( $this, 'wp_mail_from' ) );
		add_filter( 'wp_mail_from_name', array( $this, 'wp_mail_from_name' ) );
		add_filter( 'user_contactmethods', array( $this, 'user_contactmethods' ) );
		add_filter( 'excerpt_more',	  array( $this, 'excerpt_more' ) );
		add_filter( 'page_attributes_dropdown_pages_args', array( $this, 'page_attributes_dropdown_pages_args' ) );
		add_action( 'save_post', array( $this, 'save_post' ) );
	}

	public function save_post( $id )
	{
		if ( $this->op( 'wfb_createpagefordraft' ) ) {
			$p = get_post( $id );
			if ( $p->post_type === 'page' && $p->post_status !== 'trash' && isset( $p->post_parent ) ) {
				$parent_id = $p->post_parent;
				if ( $parent_id ) {
					$parent = get_post( $parent_id );
					$status = array( 'draft', 'pending', 'future' );
					if ( isset( $parent->post_status ) && in_array( $parent->post_status, $status ) ) {
						remove_action( 'save_post', array( $this, 'save_post' ) );
						$args = array(
							'ID' => $id,
							'post_status' => $parent->post_status,
						 );
						if ( $parent->post_status === 'future' ) {
							$args['post_date'] = $parent->post_date;
							$args['post_date_gmt'] = $parent->post_date_gmt;
						}
						wp_update_post( $args );
						add_action( 'save_post', array( $this, 'save_post' ) );
					}
				}
			}
		}
	}

	public function page_attributes_dropdown_pages_args( $args )
	{
		if ( $this->op( 'wfb_createpagefordraft' ) ) {
			$args['post_status'] = 'publish,private,draft,pending,future';
			return $args;
		}
		return $args;
	}

	public function plugins_loaded()
	{
		load_plugin_textdomain(
			"wp-total-hacks",
			false,
			dirname( plugin_basename( __FILE__ ) ).'/languages'
		 );

		if ( $this->op( 'wfb_disallow_pingback' ) ) {
			add_filter( 'xmlrpc_methods', array( $this, 'xmlrpc_methods' ) );
		}

		if ( $this->op( 'wfb_shortcode' ) ) {
			add_filter( 'widget_text', 'do_shortcode' );
		}

		if ( $this->op( 'wfb_oembed' ) ) {
			global $wp_embed;
			add_filter(  'widget_text', array(  $wp_embed, 'run_shortcode'  ), 8  );
			add_filter(  'widget_text', array(  $wp_embed, 'autoembed' ), 8  );
		}
	}

	public function xmlrpc_methods( $methods )
	{
		if ( $this->op( 'wfb_disallow_pingback' ) ) {
			unset( $methods['pingback.ping'] );
		}
		return $methods;
	}

	public function excerpt_more( $str )
	{
		if ( $this->op( 'wfb_remove_excerpt' ) ) {
			return null;
		}
		return $str;
	}

	public function user_contactmethods( $meth )
	{
		$del = $this->op( 'wfb_contact_methods' );
		if ( $del && is_array( $del ) ) {
			foreach ( $meth as $m => $s ) {
				if ( in_array( $m, $del ) ) {
					unset( $meth[$m] );
				}
			}
		}
		return $meth;
	}

	public function wp_mail_from( $str )
	{
		if ( $this->op( 'wfb_emailaddress' ) ) {
			if ( preg_match( "/^wordpress@/i", $str ) ) {
				return $this->op( 'wfb_emailaddress' );
			}
		}
		return $str;
	}

	public function wp_mail_from_name( $str )
	{
		if ( $this->op( 'wfb_sendername' ) ) {
			if ( preg_match( "/^wordpress/i", $str ) ) {
				return $this->op( 'wfb_sendername' );
			}
		}
		return $str;
	}

	public function init()
	{
		if ( $this->op( "wfb_pageexcerpt" ) ) {
			add_post_type_support( 'page', 'excerpt' );
		}
	}

	public function the_content_more_link( $str )
	{
		if ( $this->op( 'wfb_remove_more' ) ) {
			$str = preg_replace( '/#more-[0-9]+/i', '', $str );
		}
		return $str;
	}

	public function get_header()
	{
		if ( $this->op( 'wfb_remove_xmlrpc' ) ) {
			if ( !$this->op( "enable_app" ) && !$this->op( 'enable_xmlrpc' ) ) {
				remove_action( 'wp_head', 'wlwmanifest_link' );
				remove_action( 'wp_head', 'rsd_link' );
			}
		}
		if ( $this->op( 'wfb_hide_version' ) ) {
			remove_action( 'wp_head', 'wp_generator' );
		}
	}

	public function wp_dashboard_setup()
	{
		if ( $w = $this->op( 'wfb_widget' ) ) {
			global $wp_meta_boxes;
			foreach (  $wp_meta_boxes['dashboard'] as $position => $prio_boxes  ) {
				foreach (  $prio_boxes as $priority => $boxes  ) {
					foreach (  $boxes as $key => $array  ) {
						if ( in_array( $key, $w ) ) {
							unset( $wp_meta_boxes['dashboard'][$position][$priority][$key] );
						}
					}
				}
			}
		}
	}

	public function pre_ping( &$links )
	{
		if ( !$this->op( 'wfb_selfping' ) ) {
			return;
		}
		$home = $this->op(  'home'  );
		foreach ( $links as $l => $link ) {
		if ( 0 === strpos( $link, $home ) ) {
				unset( $links[$l] );
			}
		}
	}

	public function login_headerurl( $url )
	{
		if ( $op = $this->op( 'wfb_login_url' ) ) {
			return $op;
		} else {
			return $url;
		}
	}

	public function login_headertitle( $url )
	{
		if ( $op = $this->op( 'wfb_login_title' ) ) {
			return $op;
		} else {
			return $url;
		}
	}

	public function wp_head()
	{
		if ( $this->op( "wfb_google_analytics" ) ) {
			if ( $this->op( "wfb_exclude_loggedin" ) && is_user_logged_in() ) {
			} else {
				echo apply_filters(  "wp_total_hacks_google_analytics", stripslashes(  $this->op(  "wfb_google_analytics"  )  )  );
			}
		}
        if ( ! function_exists( 'has_site_icon' ) || ( function_exists( 'has_site_icon' ) && ! has_site_icon() ) ) {
    		if ( $this->op( 'wfb_favicon' ) ) {
    			$link = '<link rel="Shortcut Icon" type="image/x-icon" href="%s" />'."\n";
    			printf( $link, $this->remove_scheme( esc_url( $this->op( "wfb_favicon" ) ) ) );
    		}
    		if ( $this->op( 'wfb_apple_icon' ) ) {
    			if ( $this->op( 'wfb_apple_icon_precomposed' ) ) {
    				$link = '<link rel="apple-touch-icon-precomposed" href="%s" />'."\n";
    			} else {
    				$link = '<link rel="apple-touch-icon" href="%s" />'."\n";
    			}
    			printf( $link, $this->remove_scheme( esc_url( $this->op( "wfb_apple_icon" ) ) ) );
    		}
        }
		echo $this->get_meta( 'google-site-verification', $this->op( 'wfb_google' ) );
		echo $this->get_meta( 'msvalidate.01', $this->op( 'wfb_bing' ) );

		if ( is_user_logged_in() && $this->op( "wfb_custom_logo" ) ) {
			$style = '<style type="text/css">';
			$style .= '#wp-admin-bar-wp-logo > .ab-item .ab-icon{background-position: 0 0;}';
		$style .= '#wpadminbar #wp-admin-bar-wp-logo > .ab-item .ab-icon:before {position: absolute; left: -1000%%;}';
		$style .= '#wpadminbar > #wp-toolbar.quicklinks > #wp-admin-bar-root-default.ab-top-menu > #wp-admin-bar-wp-logo.menupop > .ab-item > .ab-icon {background-image: url( %s ) !important; width: 16px; height: 16px; background-repeat: no-repeat; background-position: center center; background-size: auto; margin-top: 6px; left: 2px;}';
			$style .= '</style>';
			printf( $style, $this->remove_scheme( esc_url( $this->op( "wfb_custom_logo" ) ) ) );
		}
	}

	public function admin_head()
	{
		if ( $this->op( 'wfb_favicon' ) && $this->op( 'wfb_admin_favicon' ) ) {
			$link = '<link rel="Shortcut Icon" type="image/x-icon" href="%s" />'."\n";
			printf( $link, esc_url( $this->op( "wfb_favicon" ) ) );
		}
		if ( !$this->op( "wfb_custom_logo" ) ) {
			return;
		}
		$style = '<style type="text/css">';
		$style .= '#wp-admin-bar-wp-logo > .ab-item .ab-icon{background-position: 0 0;}';
		$style .= '#wpadminbar #wp-admin-bar-wp-logo > .ab-item .ab-icon:before {position: absolute; left: -1000%%;}';
		$style .= '#wpadminbar > #wp-toolbar.quicklinks > #wp-admin-bar-root-default.ab-top-menu > #wp-admin-bar-wp-logo.menupop > .ab-item > .ab-icon {background-image: url( %s ) !important; width: 16px; height: 16px; background-repeat: no-repeat; background-position: center center; background-size: auto; margin-top: 6px; left: 2px;}';
		$style .= '</style>';
		printf( $style, $this->remove_scheme( esc_url( $this->op( "wfb_custom_logo" ) ) ) );
	}

	private function get_meta( $name, $content )
	{
		if ( $name && $content ) {
			return sprintf(
				'<meta name="%s" content="%s" />'."\n",
				$name,
				esc_attr( $content )
			 );
		}
	}

	public function admin_footer_text( $text )
	{
		if ( $str = $this->op( 'wfb_admin_footer_text' ) ) {
			return $str;
		} else {
			return $text;
		}
	}

	public function login_head()
	{
		if ( $this->op( "wfb_login_logo" ) ) {
			printf(
				'<style type="text/css">h1 a {background-image: url( %s ) !important;}#login h1 a { width: auto !important; background-size: auto !important; }</style>',
				$this->remove_scheme( esc_url( $this->op( 'wfb_login_logo' ) ) )
			 );
		}
	}

	public function admin_menu()
	{
		$metas = $this->op( 'wfb_postmetas' );
		if ( $metas && is_array( $metas ) ) {
			foreach ( $metas as $meta ) {
				remove_meta_box( $meta, 'post', 'normal' );
			}
		}
		$metas = $this->op( 'wfb_pagemetas' );
		if ( $metas && is_array( $metas ) ) {
			foreach ( $metas as $meta ) {
				remove_meta_box( $meta, 'page', 'normal' );
			}
		}
		if ( $this->op( 'wfb_update_notification' ) ) {
			global $user_login;
			get_currentuserinfo();
			if ( !current_user_can( 'update_plugins' ) ) {
				remove_action( 'admin_notices', 'update_nag', 3 );
			}
		}
	}

	private function op( $key, $default = false )
	{
		$op = get_option( $key, $default );
		if ( is_array( $op ) ) {
			return $op;
		} else {
			return trim( stripslashes( $op ) );
		}
	}

	private function remove_scheme( $url )
	{
		return preg_replace( "/^http:/", "", $url );
	}

}

?>
