<#if !user.anonymous>
  <div class="contest-subscribe">
    <p>${text.format('custom.subscribe-contest.text')}</p>
    <span class="lia-button-wrapper lia-button-wrapper-primary">
      <a class="lia-button lia-button-primary add-subscribe" href="#">
        <span></span>
      </a>
    </span>
  </div>
</#if>
<@liaAddScript>
; (function ($) {
  var $option = $('.lia-menu-dropdown-items');
  var $addSubscribe = $option.find('#addBoardUserEmailSubscription');
  var addSubscribeUrl = $addSubscribe.attr('href');
  var $removeSubscribe = $option.find('#removeBoardUserEmailSubscription');
  var removeSubscribeUrl = $removeSubscribe.attr('href');
  var $sidebarAddSubscribe = $('.contest-subscribe .add-subscribe');
  if (typeof addSubscribeUrl != 'undefined') {
    $sidebarAddSubscribe.attr('href', addSubscribeUrl);
    $sidebarAddSubscribe.find('span').append("${text.format('custom.subscribe-contest.title')}");
  }
  if (typeof removeSubscribeUrl != 'undefined') {
    $sidebarAddSubscribe.attr('href', removeSubscribeUrl);
    $sidebarAddSubscribe.find('span').append("${text.format('custom.unsubscribe-contest.title')}");
  }
  if (typeof removeSubscribeUrl == 'undefined' && typeof addSubscribeUrl == 'undefined') {
    var $addSubscribe = $option.find('#addThreadUserEmailSubscription');
    var addSubscribeUrl = $addSubscribe.attr('href');
    var $removeSubscribe = $option.find('#removeThreadUserEmailSubscription');
    var removeSubscribeUrl = $removeSubscribe.attr('href');
    if (typeof addSubscribeUrl != 'undefined') {
      $sidebarAddSubscribe.attr('href', addSubscribeUrl);
      $sidebarAddSubscribe.find('span').append("${text.format('custom.subscribe-contest.title')}");
    }
    if (typeof removeSubscribeUrl != 'undefined') {
      $sidebarAddSubscribe.attr('href', removeSubscribeUrl);
      $sidebarAddSubscribe.find('span').append("${text.format('custom.unsubscribe-contest.title')}");
    }
  }
  if ($addSubscribe.length == 0 && $removeSubscribe.length == 0) {
    $('.contest-subscribe').hide();
  }

})(jQuery);
</@liaAddScript>