<div class="bside">
<h3><?php _e('Translators', 'wp-total-hacks'); ?></h3>
<p><?php $this->get_translators(); ?></p>
</div>

<div class="bside">
<h3><?php _e('Contributors', 'wp-total-hacks'); ?></h3>
<p><?php $this->get_contributors(); ?></p>
</div>

<script type="text/javascript">
    window.scrollTo(0,0);
    var send = window.send_to_editor;
    var hacks = new totalhacks();
    jQuery('#tabid').val(location.hash.substring(1, location.hash.length));

    // setup tab menu
    jQuery('#total-hacks-tabs .total-hacks-tab').each(function(){
        var id = jQuery(this).attr("id");
        var txt = jQuery(jQuery('h3', this).get(0)).text();
        var li = jQuery('<li><a href="#'+id+'"><span>'+txt+'</span></a></li>');
        jQuery('#menu').append(li);
    });
    jQuery(function(){
        jQuery("#total-hacks-tabs").tabs({fx:{opacity:'toggle', duration:'fast'}});
        jQuery("#total-hacks-tabs h3").css('display', 'none');
    });
    jQuery("#menu a").click(function(){
        var href = jQuery(this).attr('href');
        href = href.substring(1, href.length);
        jQuery('#tabid').val(href);
    });
    jQuery('#total-hacks-tabs').css('display', 'block');

    // setup media uploader
    jQuery('a.media-upload').each(function(){
        var rel = jQuery(this).attr("rel");
        jQuery(this).click(function(){
            window.send_to_editor = function(html) {
                imgurl = jQuery('img', html).attr('src');
                jQuery('#'+rel).val(imgurl);
                tb_remove();
            }
            formfield = jQuery('#'+rel).attr('name');
            tb_show(null, 'media-upload.php?post_id=0&type=image&TB_iframe=true');
            return false;
        });
    });

    // setup visual editor
    jQuery('#total-hacks-tabs a.thickbox').each(function(){
        jQuery(this).click(function(){
            window.send_to_editor = send;
        });
    });

<?php if (isset($_GET['update']) && $_GET['update'] === 'true'): ?>
    jQuery('#wfb-notice').css('display', 'block');
    jQuery('#wfb-notice').delay(2000).animate({
        opacity: 0,
        display: "none"
    }, 500, null, function(){jQuery(this).css('display', 'none');});
<?php endif; ?>
</script>
