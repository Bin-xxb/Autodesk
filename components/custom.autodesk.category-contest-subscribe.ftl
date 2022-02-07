<#if !user.anonymous>
  <div class="contest-subscribe">
    <p>${text.format('custom.subscribe-contest.text')}</p>
    <span class="lia-button-wrapper lia-button-wrapper-primary">
      <a class="lia-button lia-button-primary add-subscribe" href="javascript:void(0);">
        <span></span>
      </a>
    </span>
  </div>
</#if>
<@liaAddScript>
; (function ($) {
  var $option = $('.lia-menu-dropdown-items');
  var $addSubscribe = $option.find('.lia-category-subscription-link');
  var addSubscribeUrl = $addSubscribe.attr('href');

 //  if (typeof addSubscribeUrl != 'undefined') {
	// $sidebarAddSubscribe.attr('href', addSubscribeUrl);
	// $sidebarAddSubscribe.find('span').append("${text.format('custom.subscribe-contest.title')}");
 //  }

  $('.add-subscribe').on('click', function() {
  	console.log('1')
  	$addSubscribe.trigger('click');
  });

})(jQuery);
</@liaAddScript>