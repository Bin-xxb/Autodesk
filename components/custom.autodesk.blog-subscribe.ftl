
<#if !user.anonymous>
	<div class="blog-subscribe">
		<p>${text.format('custom.subscribe-blogs.text')}</p>
		<span class="lia-button-wrapper lia-button-wrapper-primary">
			<a class="lia-button lia-button-primary add-subscribe" href="#">
				<span></span>
			</a>
		</span>
	</div>
</#if>
<@liaAddScript>
; (function ($) {
	var $option = $('#dropdownmenuitems');
	var $addSubscribe = $option.find('#addBoardUserEmailSubscription');
	var addSubscribeUrl = $addSubscribe.attr('href');
	var $removeSubscribe = $option.find('#removeBoardUserEmailSubscription');
	var removeSubscribeUrl = $removeSubscribe.attr('href');
	var $sidebarAddSubscribe = $('.blog-subscribe .add-subscribe');
	if (typeof addSubscribeUrl != 'undefined') {
		$sidebarAddSubscribe.attr('href', addSubscribeUrl);
		$sidebarAddSubscribe.find('span').append("${text.format('custom.subscribe-blogs.title')}");
	}
	if (typeof removeSubscribeUrl != 'undefined') {
		$sidebarAddSubscribe.attr('href', removeSubscribeUrl);
		$sidebarAddSubscribe.find('span').append("${text.format('custom.unsubscribe-blogs.title')}");
	}
	if (typeof removeSubscribeUrl == 'undefined' && typeof addSubscribeUrl == 'undefined') {
		var $addSubscribe = $option.find('#addThreadUserEmailSubscription');
		var addSubscribeUrl = $addSubscribe.attr('href');
		var $removeSubscribe = $option.find('#removeThreadUserEmailSubscription');
		var removeSubscribeUrl = $removeSubscribe.attr('href');
		if (typeof addSubscribeUrl != 'undefined') {
			$sidebarAddSubscribe.attr('href', addSubscribeUrl);
			$sidebarAddSubscribe.find('span').append("${text.format('custom.subscribe-blogs.title')}");
		}
		if (typeof removeSubscribeUrl != 'undefined') {
			$sidebarAddSubscribe.attr('href', removeSubscribeUrl);
			$sidebarAddSubscribe.find('span').append("${text.format('custom.unsubscribe-blogs.title')}");
		}
	}
	if ($addSubscribe.length == 0 && $removeSubscribe.length == 0) {
		$('.blog-subscribe').hide();
	}

})(jQuery);
</@liaAddScript>