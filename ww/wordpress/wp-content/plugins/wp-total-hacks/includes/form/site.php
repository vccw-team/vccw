<div id="total-hacks-site" class="total-hacks-tab">
<h3><?php _e('Site Settings', 'wp-total-hacks'); ?></h3>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Add a favicon', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Please upload .ico image.', 'wp-total-hacks'); ?><br />
        <input type="text" id="wfb_favicon" name="wfb_favicon" class="media" value="<?php $this->op('wfb_favicon'); ?>" />
        <a class="media-upload" href="JavaScript:void(0);" rel="wfb_favicon"><?php _e('Select File', 'wp-total-hacks'); ?></a></p>
        <p><?php $this->sel('wfb_admin_favicon'); ?> <?php _e('Use this favicon with administration screens.', 'wp-total-hacks'); ?></p>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Add a apple-touch-icon', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Please upload .png image.', 'wp-total-hacks'); ?></p>
        <input type="text" id="wfb_apple_icon" name="wfb_apple_icon" class="media" value="<?php $this->op('wfb_apple_icon'); ?>" />
        <a class="media-upload" href="JavaScript:void(0);" rel="wfb_apple_icon"><?php _e('Select File', 'wp-total-hacks'); ?></a>
        <p>
<?php if (get_option('wfb_apple_icon_precomposed')): ?>
            <input type="checkbox" name="wfb_apple_icon_precomposed" value="1" checked="checked"  />
<?php else: ?>
            <input type="checkbox" name="wfb_apple_icon_precomposed" value="1" />
<?php endif; ?>
        apple-touch-icon as precomposed.</p>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Remove "wlwmanifest" and "xmlrpc" from meta.', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php printf(__('If you don\'t use "<a href="%s">Remote Publishing</a>", remove unnecessary tags from head.', 'wp-total-hacks'), admin_url('options-writing.php')); ?></p>
        <?php $this->sel('wfb_remove_xmlrpc'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Remove version number from head', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Remove generator tag from head. <span class="ex">e.g. &lt;meta name="generator" content="WordPress x.x.x" /&gt;</span>', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_hide_version'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Remove #more anchor', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Remove #more-xxx anchor from more links.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_remove_more'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Remove "[...]" from excerpt', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Remove "[...]" from output of the_excerpt().', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_remove_excerpt'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Block all pingbacks', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Block all pingbacks.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_disallow_pingback'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Install Google Analytics', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Add Google analytics code.', 'wp-total-hacks'); ?></p>
        <textarea name="wfb_google_analytics" id="wfb_google_analytics" cols="50" rows="7"><?php $this->op('wfb_google_analytics'); ?></textarea><br />
        <?php if (get_option('wfb_exclude_loggedin')): ?>
        <input id="wfb_exclude_loggedin" type="checkbox" name="wfb_exclude_loggedin" value="1" checked="checked" />
        <?php else: ?>
        <input id="wfb_exclude_loggedin" type="checkbox" name="wfb_exclude_loggedin" value="1" />
        <?php endif; ?>
        <label for="wfb_exclude_loggedin"><?php _e('Exclude user logged in.', 'wp-total-hacks'); ?></label>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Webmaster Tools Verification', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Enter your meta key "content" value to verify your blog with <a href="https://www.google.com/webmasters/tools/">Google Webmaster Tools</a> and <a href="http://www.bing.com/webmaster">Bing Webmaster Center</a>.', 'wp-total-hacks'); ?></p>
        <dl>
            <dt>Google</dt>
            <dd><input class="text" type="text" name="wfb_google" value="<?php $this->op('wfb_google')?>" /></dd>
            <dt>Bing</dt>
            <dd><input class="text" type="text" name="wfb_bing" value="<?php $this->op('wfb_bing')?>" /></dd>
        </dl>
    </div>
</div>

</div><!--end .tab-->
