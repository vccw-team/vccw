
<div id="total-hacks-post" class="total-hacks-tab">
<h3><?php _e('Posts &amp; Pages', 'wp-total-hacks'); ?></h3>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Remove meta boxes for Posts', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Choose the items you want to remove.', 'wp-total-hacks'); ?></p>
        <ul>
            <?php foreach ($this->post_metas as $wgt => $pos): ?>
            <li>
<?php if (get_option('wfb_postmetas') && is_array(get_option('wfb_postmetas')) && in_array($wgt, get_option('wfb_postmetas'))): ?>
                <input id="wfb_postmetas_<?php echo $wgt; ?>" type="checkbox" name="wfb_postmetas[]" value="<?php echo $wgt; ?>" checked="checked" />
<?php else: ?>
                <input id="wfb_postmetas_<?php echo $wgt; ?>" type="checkbox" name="wfb_postmetas[]" value="<?php echo $wgt; ?>" />
<?php endif; ?>
                <label for="wfb_postmetas_<?php echo $wgt; ?>"><?php echo __($pos['title']); ?></label>
            </li>
            <?php endforeach; ?>
        </ul>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Remove meta boxes for Pages', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Choose the items you want to remove.', 'wp-total-hacks'); ?></p>
        <ul>
            <?php foreach ($this->page_metas as $wgt => $pos): ?>
            <li>
<?php if (get_option('wfb_pagemetas') && is_array(get_option('wfb_pagemetas')) && in_array($wgt, get_option('wfb_pagemetas'))): ?>
                <input id="wfb_pagemetas_<?php echo $wgt; ?>" type="checkbox" name="wfb_pagemetas[]" value="<?php echo $wgt; ?>" checked="checked" />
<?php else: ?>
                <input id="wfb_pagemetas_<?php echo $wgt; ?>" type="checkbox" name="wfb_pagemetas[]" value="<?php echo $wgt; ?>" />
<?php endif; ?>
                <label for="wfb_pagemetas_<?php echo $wgt; ?>"><?php _e($pos['title']); ?></label>
            </li>
            <?php endforeach; ?>
        </ul>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Revision Control', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Limit the number of revisions allowed.', 'wp-total-hacks'); ?></p>
        <select name="wfb_revision" id="wfb_revision">
            <option value=""><?php _e('Store All', 'wp-total-hacks'); ?></option>
            <?php for($i=0; $i<21; $i++): ?>
            <?php
                if (strlen(get_option("wfb_revision")) && intval(get_option("wfb_revision")) === $i) {
                    $chk = 'selected="selected"';
                } else {
                    $chk = '';
                }
            ?>
            <option value="<?php echo $i; ?>" <?php echo $chk; ?>><?php echo $i; ?></option>
            <?php endfor; ?>
        </select>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Stop self-pingbacks', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Stop sending pingbacks from your own site to your own site when writing posts.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_selfping'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Add "Excerpt" support for Pages.', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('Allows you to add excerpt text to pages.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_pageexcerpt'); ?>
    </div>
</div>

<div class="block">
    <h4><img src="<?php echo $this->get_plugin_url(); ?>/img/check.png" height="24" width="24" /><?php _e('Allow you to create child page for "draft".', 'wp-total-hacks'); ?></h4>
    <div class="block_content">
        <p><?php _e('You can create child page for non-publish Page.', 'wp-total-hacks'); ?></p>
        <?php $this->sel('wfb_createpagefordraft'); ?>
    </div>
</div>

</div><!--end .tab-->

