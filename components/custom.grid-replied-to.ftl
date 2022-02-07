<#if !user.anonymous>
	<#assign start = .now?long />
	<#if (env.context.message.uniqueId)?has_content>
		<#assign topicId = env.context.message.uniqueId />
		<#assign currentUserId = user.id />
		<#assign qry = "select id from messages where topic.id='${topicId}' and author.id='${currentUserId}' and depth > 0 limit 1 offset 0" />
		<#assign replyCnt = ((rest("2.0", "/search?q=" + qry?url("UTF-8") + "&restapi.response_style=view").data.items)![])?size />
		<script>console.log('Reply count for ${topicId}: ${replyCnt}');</script>
		<#if replyCnt gt 0>
			<div class="custom-reply-message-icon"></div>
		</#if>
	</#if>
	<#assign finish = .now?long />
	<#assign elapsed = finish - start />
	<script>console.log('Time elapsed: ${elapsed}ms');</script>
</#if>