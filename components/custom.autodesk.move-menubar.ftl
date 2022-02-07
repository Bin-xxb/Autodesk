<@liaAddScript>
;(function($) {
	var $menubar = $( ".lia-forum-topic-page-gte-5-pager" ).clone();
	$( ".lia-forum-topic-page-gte-5-pager" ).remove();
	$menubar.appendTo( ".lia-component-reply-list" );
})(LITHIUM.jQuery);
</@liaAddScript>