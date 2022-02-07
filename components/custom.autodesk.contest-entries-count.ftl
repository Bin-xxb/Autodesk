<#assign nodeId = coreNode.id />
<#assign query = "SELECT id, count(*), conversation.messages_count FROM messages WHERE board.id = '${nodeId}' AND depth = 0" />
<#assign entries = rest("2.0", "/search?q=" + query?url)/>
<div class="contest-count-winner-wrapper">
<div class="contest-entries-count">
  <span>
    ${text.format('custom.contest-entries-count.text', entries.data.count)}
  </span>
</div>
<div class="view-winner-text hide">
	<a href="#winner-content">${text.format("custom.view-winner.title")}</a>
</div>
</div>

<@liaAddScript>
; (function ($) {
  var $winnerTab = $('.winners-link.tab-link');
  if ($winnerTab.length > 0) {
  	$('.view-winner-text').removeClass('hide');
  }

  var url = window.location.href;
  var urlTop = url.split('tab/home');
  var winnerHref = urlTop[0] + 'tab/winner#winner-content';
  $('.contest-count-winner-wrapper .view-winner-text a').attr('href',winnerHref); 

  $('.contest-entries-count span').on('click', function() {
    $(window).scrollTop($('.lia-component-menu-bar-sort-pager').offset().top - $('.lia-component-quilt-header').height());
  })

})(jQuery);
</@liaAddScript>