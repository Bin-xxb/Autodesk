<#if page?? && page.context?? && page.context.message??>

<div class="lia-component-custom-share">
	<span class="share-title">${text.format('custom.blog-share.title')}</span>
	<ul class="social-icons">
		<li class="facebook"><a target="_blank" href="//www.facebook.com/sharer/sharer.php?u=${page.context.message.webUi.url?url}"></a></li>	
		<li class="twitter"><a target="_blank" href="//twitter.com/share?url=${page.context.message.webUi.url?url}&text=${page.context.message.subject?url}"></a></li>
		<li class="linkedin"><a target="_blank" href="//www.linkedin.com/shareArticle?mini=true&url=${page.context.message.webUi.url?url}&title=${page.context.message.subject?url}"></a></li>
	</ul>
</div>

<@liaAddScript>
;(function($){

	$('#lia-body .lia-content .lia-component-custom-share .social-icons').on('click', 'a',function(e) {
			e.preventDefault();
			var left = (screen.width/2)-(600/2);
			var top = (screen.height/2)-(400/2);
			window.open($(this).attr('href'), "share-pop-up", "toolbar=yes,location=yes,directories=yes,status=no,menubar=no,scrollbars=yes,resizable=yes,width=600,height=400,top=" + top + ",left=" + left);
		});
})(jQuery);
</@liaAddScript>
</#if>