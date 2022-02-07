<div class="custom-occasion-rsvp-feedback">
	<div class="lia-component-occasion-action-rsvp"></div>
</div>

<@liaAddScript>
;(function($) {
	var $occasionView = $('.lia-quilt-occasion-view');
	var $rsvp = $occasionView.find('.custom-occasion-rsvp-feedback .lia-component-occasion-action-rsvp');
	var $rsvpFeedback = $occasionView.find('.lia-component-occasion-action-rsvp .lia-occasion-rsvp-feedback');
	$rsvp.append($rsvpFeedback);

	var $primaryButton = $('.lia-component-occasion-action-rsvp .lia-button-wrapper .lia-button-primary');
	
	function rsvpFeedback() {
		var $rsvp = $('.custom-occasion-rsvp-feedback .lia-component-occasion-action-rsvp');
		$rsvp.find('.lia-occasion-rsvp-feedback').remove();
		var $rsvpFeedback = $('.lia-component-occasion-action-rsvp .lia-occasion-rsvp-feedback');
		$rsvp.append($rsvpFeedback);
	}

	$primaryButton.on('click', function(){
		$( document ).ajaxComplete(function( event, xhr, settings ) {
			var seturl = settings.url;
			if ( seturl.indexOf("occasionpage.occasionboardrsvp.respondyeslinkdata") >= 0 ) {
				rsvpFeedback();
			}
			if ( seturl.indexOf("occasionpage.occasionboardrsvp.respondnolinkdata") >= 0 ) {
				rsvpFeedback();
			}
			if ( seturl.indexOf("occasionpage.occasionboardrsvp.respondmaybelinkdata") >= 0 ) {
				rsvpFeedback();
			}
		}); 
		
	});
})(LITHIUM.jQuery);
</@liaAddScript>
