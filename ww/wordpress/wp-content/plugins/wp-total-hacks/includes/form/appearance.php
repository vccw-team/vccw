
<div id="total-hacks-admin" class="total-hacks-tab">
<h3><?php _e('Appearance in admin', 'wp-total-hacks'); ?></h3>

<div class="block">
    <h4><img alt="" src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Change admin header logo', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php printf(__('Upload %s x %s pixel image for admin header logo.', 'wp-total-hacks'), 16, 16); ?></p>
        <p><img class="caption" alt="" src="<?php echo $this->get_plugin_url(); ?>/img/admin_header_logo.png"></p>
        <input type="text" id="wfb_custom_logo" name="wfb_custom_logo" class="media" value="<?php $this->op('wfb_custom_logo'); ?>" />
        <a class="media-upload" href="JavaScript:void(0);" rel="wfb_custom_logo"><?php _e('Select File', 'wp-total-hacks'); ?></a>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Change admin footer text', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('You can edit admin footer text. Line breaks will remove.', 'wp-total-hacks'); ?></p>
        <p><img class="caption" alt="" src="<?php echo $this->get_plugin_url(); ?>/img/admin_footer_text.png"></p>
        <div class="poststuff">
        <div class="postdivrich" class="postarea">
        <?php wp_editor($this->op('wfb_admin_footer_text', false), "wfb_admin_footer_text"); ?>
        </div><!--end #postdivrich-->
        </div><!--end #poststuff-->
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Change login logo', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('You can customize logo, URL and Title. The logo image size is recommended 310 x 70 pixel.', 'wp-total-hacks'); ?></p>
        <p><img class="caption" alt="" src="<?php echo $this->get_plugin_url(); ?>/img/login_logo.png"></p>
        <dl>
        <dt><?php _e('Logo', 'wp-total-hacks'); ?></dt>
        <dd><input type="text" id="wfb_login_logo" name="wfb_login_logo" class="media" value="<?php $this->op('wfb_login_logo'); ?>" />&nbsp;<a class="media-upload" href="JavaScript:void(0);" rel="wfb_login_logo"><?php _e('Select File', 'wp-total-hacks'); ?></a></dd>
        <dt><?php _e('URL', 'wp-total-hacks'); ?></dt>
        <dd><input class="text" type="text" name="wfb_login_url" value="<?php $this->op('wfb_login_url'); ?>" /></dd>
        <dt><?php _e('Title', 'wp-total-hacks'); ?></dt>
        <dd><input class="text" type="text" name="wfb_login_title" value="<?php $this->op('wfb_login_title'); ?>" /></dd>
        </dl>
    </div>
</div>

</div><!--end .tab-->

