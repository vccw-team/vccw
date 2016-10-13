<div id="total-hacks-dashboard" class="total-hacks-tab">
<h3><?php _e('Other', 'wp-total-hacks'); ?></h3>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Deactivate Dashboard Widgets', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Choose the items you want to remove.', 'wp-total-hacks'); ?></p>
        <ul>
            <?php foreach ($this->widgets as $wgt => $pos): ?>
            <li>
<?php if (get_option('wfb_widget') && is_array(get_option('wfb_widget')) && in_array($wgt, get_option('wfb_widget'))): ?>
                <input id="wfb_widget_<?php echo $wgt; ?>" type="checkbox" name="wfb_widget[]" value="<?php echo $wgt; ?>" checked="checked" />
<?php else: ?>
                <input id="wfb_widget_<?php echo $wgt; ?>" type="checkbox" name="wfb_widget[]" value="<?php echo $wgt; ?>" />
<?php endif; ?>
                <label for="wfb_widget_<?php echo $wgt; ?>"><?php _e($pos['title']); ?></label>
            </li>
            <?php endforeach; ?>
        </ul>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Enable shortcode in the text widget', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('By default, the Text widget only support text and HTML. If you activate it, shortcode would be supported.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_shortcode'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Enable oEmbed in the text widget', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('By default, the Text widget only support text and HTML. If you activate it, oEmbed would be supported.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_oembed'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Add role "Webmaster"', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('This role has the capabilities of an "Editor", but can also edit theme options.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_webmaster'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Change default email address', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Change the email address and sender name used by automatic email notifications.', 'wp-total-hacks'); ?></p>
        <dl>
            <dt><?php _e('Name', 'wp-total-hacks'); ?></dt>
            <dd><input class="text" type="text" name="wfb_sendername" value="<?php $this->op('wfb_sendername')?>" /></dd>
            <dt><?php _e('Email', 'wp-total-hacks'); ?></dt>
            <dd><input class="text" type="text" name="wfb_emailaddress" value="<?php $this->op('wfb_emailaddress')?>" /></dd>
        </dl>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Delete default contact methods', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Delete default contact methods from user profile.', 'wp-total-hacks'); ?></p>
        <ul>
            <?php foreach ($this->contact_methods as $c => $n): ?>
            <li>
<?php if (get_option('wfb_contact_methods') && is_array(get_option('wfb_contact_methods')) && in_array($c, get_option('wfb_contact_methods'))): ?>
                <input id="wfb_contact_methods_<?php echo $c; ?>" type="checkbox" name="wfb_contact_methods[]" value="<?php echo $c; ?>" checked="checked" />
<?php else: ?>
                <input id="wfb_contact_methods_<?php echo $c; ?>" type="checkbox" name="wfb_contact_methods[]" value="<?php echo $c; ?>" />
<?php endif; ?>
                <label for="wfb_contact_methods_<?php echo $c; ?>"><?php _e($n); ?></label>
            </li>
            <?php endforeach; ?>
        </ul>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Remove Update Notification', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Remove Update Notification for all users except Admin User.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_update_notification'); ?>
    </div>
</div>

</div><!--end .tab-->


