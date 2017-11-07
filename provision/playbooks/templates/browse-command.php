<?php

if ( ! class_exists( 'WP_CLI' ) ) {
	return;
}

/**
 * Open the website in your browser.
 *
 * ## Options
 *
 * [--wp-admin]
 * : Open the dashboard.
 *
 * @when before_wp_load
 */
$browse_command = function( $_, $assoc_args ) {
	$exec = 'xdg-open';
	if ( 'DAR' === strtoupper( substr( PHP_OS, 0, 3 ) ) ) {
		$exec = 'open';
	}

	$wp_admin = \WP_CLI\Utils\get_flag_value( $assoc_args, 'wp-admin' );

	if ( true === $wp_admin ) {
		$url = 'http://{{ vccw.hostname }}/wp-admin/';
	} else {
		$url = 'http://{{ vccw.hostname }}/';
	}

	passthru( $exec . ' ' . escapeshellarg( $url ) );
};

WP_CLI::add_command( 'browse', $browse_command );
