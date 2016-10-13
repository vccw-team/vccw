/* global ajaxurl, tinymce, wpLinkL10n, setUserSetting, wpActiveEditor */
var tinymceTemplates;

( function( $ ) {
	var editor,

	tinymceTemplates = {

		init: function()
		{
			$('#button-tinymce-templates').bind('click', function(e){
				e.preventDefault();
				tinymceTemplates.get_template_list();
				tinymceTemplates.open();
			});

			$(window).resize(function(){
				tinymceTemplates.positionTop();
			});

			$('.close').click(function(e){
				e.preventDefault();
				tinymceTemplates.close();
			});

			$('#tinymce-templates-backdrop').click(function(e){
				e.preventDefault();
				tinymceTemplates.close();
			});

			$('#tinymce-templates-insert').click(function(e){
				e.preventDefault();
				if ($(this).attr('disabled')) {
					return false;
				}
				tinymceTemplates.insert();
				tinymceTemplates.close();
			});

			$('#tinymce-templates-list').bind('change', function(){
				tinymceTemplates.set_content();
			});

			$(window).keyup(function(e){
				if(e.keyCode == 27){
					e.preventDefault();
					tinymceTemplates.close();
				}
			});
		},

		insert: function()
		{
			if (tinymceTemplates.is_shortcode) {
				var tags = tinymceTemplates.content.match(/{\$([a-zA-Z0-9_]+?)}/g);

				var args = [];
				var is_content = '';

				if (tags) {
					var tags = tags.filter(function (x, i, self) {
						return self.indexOf(x) === i;
					});

					for (var i=0; i<tags.length; i++) {
						var tag = tags[i].match(/[a-zA-Z0-9_]+/);
						if ('content' === tag[0]) {
							is_content = '[/template]';
							continue;
						}
						args.push(tag[0] + '=""');
					}
				}

				if (0 < args.length) {
					html = '[template id="' + tinymceTemplates.template_id + '" ' + args.join(' ')+']' + is_contentz;
				} else {
					html = '[template id="' + tinymceTemplates.template_id + '"]' + is_content;
				}

				wp.media.editor.insert(html);
			} else {
				wp.media.editor.insert(tinymceTemplates.content);
			}
		},

		get_template_list: function()
		{
			var args = $.extend({}, tinymce_templates_list_args);

			$.ajax({
				url: tinymce_templates_list_uri,
				async: true,
				type: 'GET',
				dataType: 'json',
				data: args
			}).done(function(data){
				$.each(data, function(key, tpl){
					var option = $('<option />');
					$(option).attr('value', key);
					$(option).text(tpl.title);
					$('#tinymce-templates-list').append(option);
				});

				tinymceTemplates.set_content();
			});
		},

		set_content: function()
		{
			$('#tinymce-templates-insert').attr('disabled', true);

			if (!$('#tinymce-templates-list').val()) {
				return;
			}

			tinymceTemplates.template_id = $('#tinymce-templates-list').val();

			// I don't like reference here!!
			var args = $.extend({}, tinymce_templates_list_args);
			args['template_id'] = tinymceTemplates.template_id;

			$.ajax({
				url: tinymce_templates_list_uri,
				async: true,
				type: 'GET',
				dataType: 'json',
				data: args
			}).done(function(data){
				var styles = tinymce_templates_editor_stylesheets;

				var html = '<!DOCTYPE html><html><head>';
				html += '<style>body{ padding: 0 !important; margin: 20px !important; }</style>';
				for (var i=0; i<styles.length; i++) {
					var link = $('<link rel="stylesheet" type="text/css" media="all" />');
					link.attr('href', styles[i]);
					html += $('<div />').html(link).html(); // getting innerHTML
				}
				html += '</head><body class="mceContentBody">';
				html += data.preview;
				html += '</body></html>';

				var iframe = document.getElementById('tinymce-templates-preview');
				var doc = iframe.contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();

				if (data.is_shortcode) {
					$('#tinymce-templates-message').show();
				} else {
					$('#tinymce-templates-message').hide();
				}

				tinymceTemplates.is_shortcode = data.is_shortcode;
				tinymceTemplates.content = data.content;

				$('#tinymce-templates-insert').attr('disabled', false);
			});
		},

		open: function( editorId )
		{
			$('#tinymce-templates-list').html('');
			var iframe = document.getElementById('tinymce-templates-preview');
			var doc = iframe.contentWindow.document;
			doc.open();
			doc.write('');
			doc.close();

			tinymceTemplates.positionTop();

			$( document.body ).addClass( 'modal-open' );
			$('#tinymce-templates-wrap').show();
			$( '#tinymce-templates-backdrop' ).show();
		},

		close: function()
		{
			$(document.body ).removeClass('modal-open');
			$('#tinymce-templates-wrap').hide();
			$('#tinymce-templates-backdrop').hide();
			$('#tinymce-templates-insert').attr('disabled', true);
		},

		positionTop: function()
		{
			var windowHeight = $(document.body).height();

			$('#tinymce-templates-preview').css('height', windowHeight * 0.5);

			var height = $('#tinymce-templates-wrap').height();
			var top = (windowHeight / 2) - (height / 2) - ($('#wpadminbar').height() / 2);

			if (top < 16) {
				top = 16;
			} else if (top > 100) {
				top = 100;
			}

			$('#tinymce-templates-wrap').css('top', top);
		},
	};

	$( document ).ready( tinymceTemplates.init );

})( jQuery );
