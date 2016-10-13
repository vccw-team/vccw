<?php
/**
 * Plugin Name: Dynamic Hostname
 * Plugin URI:  https://vccw.cc/
 * Description: Set hostname dynamically for the development.
 * Version:	 0.4.2
 * Author:	  Takayuki Miyauchi
 * Author URI:  https://wpist.me/
 * License:	 GPLv2
 */


$dynamic_hostname = new Dynamic_Hostname();
$dynamic_hostname->register();

class Dynamic_Hostname {

	private $home_url;

	function register()
	{
		// nothing to do when wp-cli enabled
		if (defined('WP_CLI') && WP_CLI) {
			return;
		}

		$this->home_url = home_url();
		add_action('after_setup_theme', array($this, 'after_setup_theme'));
	}

	public function after_setup_theme()
	{
		$hooks = array(
			"home_url",
			"site_url",
			"stylesheet_directory_uri",
			"template_directory_uri",
			"plugins_url",
			"wp_get_attachment_url",
			"theme_mod_header_image",
			"theme_mod_background_image",
			"the_content",
			"upload_dir",
			"widget_text",
			"style_loader_src",
			"script_loader_src",
		);

		$hooks = apply_filters("dynamic_hostname_filters", $hooks);

		foreach ($hooks as $hook) {
			add_filter($hook, array($this, 'replace_host_name'));
		}

		add_action('save_post', array($this, 'save_post'), 10, 10);

		if (!defined("WP_HOME")) {
			add_action('admin_notices', array($this, 'admin_notices'));
		}
	}

	public function admin_notices()
	{
		echo '<div class="error"><p>[Dynamic Hostname] Please define the constant WP_HOME in your wp-config.php.</p></div>';
	}

	public function save_post($id, $post)
	{
		if ($this->get_default_hostname() !== $_SERVER['HTTP_HOST']) {
			remove_action('save_post', array($this, 'save_post'));
			$post->post_content = str_replace($_SERVER['HTTP_HOST'], $this->get_default_hostname(), $post->post_content);
			wp_update_post($post);
			add_action('save_post', array($this, 'save_post'), 10, 10);
		}
	}

	public function replace_host_name($uri)
	{
		if ($this->get_default_hostname() !== $_SERVER['HTTP_HOST']) {
			return str_replace($this->get_default_hostname(), $_SERVER['HTTP_HOST'], $uri);
		} else {
			return $uri;
		}
	}

	private function get_default_hostname()
	{
		if (defined('WP_HOME')) {
			$uri = parse_url(WP_HOME);
		} else {
			$uri = parse_url($this->home_url);
		}

		return $uri['host'];
	}

}

// EOF
