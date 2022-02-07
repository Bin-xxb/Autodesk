<#if env.context.message?? && env.context.message.uniqueId gt 0>

	<#if !env.context.message.parent??>
		<#assign queryString = "SELECT count(*) FROM messages WHERE ancestors.id = '${env.context.message.uniqueId?c}'" />
		<#assign repliesCount = restadmin("2.0", "/search?q=${queryString?url}").data.count!0 />

		<#assign queryString = "SELECT metrics.views FROM messages WHERE id = '${env.context.message.uniqueId?c}'" />
		<#assign viewsCount = 0 />
		<#assign viewsItems = restadmin("2.0", "/search?q=${queryString?url}").data.items![] />
		<#if viewsItems[0]?? && viewsItems[0].metrics?? && viewsItems[0].metrics.views??>
			<#assign viewsCount = viewsItems[0].metrics.views?number />
		</#if>

		<div class="autodesk-view-count">${viewsCount} ${text.format("messages.stat.topic-views-count.label", viewsCount)}, ${repliesCount} ${text.format("messages.stat.thread-replies-count.label", repliesCount)}</div>
		
	<#else>

		<div class="lia-message-author-with-avatar">
			<span class="UserName lia-user-name lia-user-rank-Employee lia-component-message-view-widget-author-username">
				<span class="autodesk-reply-author">${text.format("autodesk.reply_to.in_reply_to")}</span>
				<#if env.context.message.parent.author.id != -1>
					<a class="lia-link-navigation lia-page-link lia-user-name-link" target="_self" href="${env.context.message.parent.author.webUi.url}"><span class="">${env.context.message.parent.author.login}</span></a>
				<#else>
					<span class="lia-link-navigation lia-link-disabled lia-user-name-link"><span class="anon-user">${text.format("user.anonymous_label.title", env.context.message.parent.author.login)}</span></span>
				</#if>
			</span>
		</div>

	</#if>
</#if>