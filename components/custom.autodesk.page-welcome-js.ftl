<@liaAddScript>
; (function ($) {
	$welcome = $('.lia-component-common-widget-welcome');
	if($welcome.length >0 && $welcome.text() == '') {
		$welcome.removeClass('active');
	}else {
		$welcome.addClass('active');
	}
})(LITHIUM.jQuery);
</@liaAddScript>