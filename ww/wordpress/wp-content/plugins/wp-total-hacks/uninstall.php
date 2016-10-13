<?php

//if uninstall not called from WordPress exit
if (!defined('WP_UNINSTALL_PLUGIN')) {
    exit;
}


$total_hacks_options = array(
    'wfb_google_analytics',
    'wfb_favicon',
    'wfb_admin_favicon',
    'wfb_apple_icon',
    'wfb_apple_icon_precomposed',
    'wfb_hide_version',
    'wfb_google',
    'wfb_yahoo',
    'wfb_bing',
    'wfb_hide_custom_fields',
    'wfb_revision',
    'wfb_autosave',
    'wfb_selfping',
    'wfb_widget',
    'wfb_custom_logo',
    'wfb_admin_footer_text',
    'wfb_login_logo',
    'wfb_login_url',
    'wfb_login_title',
    'wfb_webmaster',
    'wfb_remove_xmlrpc',
    'wfb_exclude_loggedin',
    'wfb_adjacent_posts_rel_links',
    'wfb_remove_more',
    'wfb_pageexcerpt',
    'wfb_postmetas',
    'wfb_pagemetas',
    'wfb_emailaddress',
    'wfb_sendername',
    'wfb_contact_methods',
    'wfb_remove_excerpt',
    'wfb_update_notification',
    'wfb_attachmentlink',
    'wfb_createpagefordraft',
    'wfb_disallow_pingback',
);


foreach ($total_hacks_options as $op) {
    delete_option($op);
}

