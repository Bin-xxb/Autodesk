<!-- 
Display top Trending Topics based on # of replies
-->
<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>
<#assign todays_date_in_millisec = .now?long />
<#assign todays_date_locale = .now?iso_local />
<#assign month_back_date_in_millisec = todays_date_in_millisec-2629746000 />
<#assign month_back_date_locale = (todays_date_in_millisec?number_to_date)?iso_local />
<#assign board_id = coreNode.id />

<#assign qry = "SELECT id, subject, conversation.view_href, replies.count(*), post_time FROM messages WHERE post_time > ${month_back_date_in_millisec} AND post_time < ${todays_date_in_millisec} AND depth=0 AND board.id='${board_id}' ORDER BY replies.count(*) DESC LIMIT 5"/>
<#assign topics = liql(qry).data.items![] />
<#if debugEnabled>
	<#assign finish = .now?long />
	<#assign elapsed = finish - start />
	<script>console.log('autodesk-trending-topics: API call made. Time elapsed: ${elapsed}ms');</script>
</#if>
    
<#if topics?size gt 0>
	<div class="lia-trending-topics lia-panel lia-panel-standard">
		<h4>${text.format('autodesk-trending-topics-title')}</h4>
		<ul>
			<#list topics as topic>
				<li class="lia-trending-topics-link" msgId="${topic.id}">
					<a href="${topic.conversation.view_href}">${topic.subject}</a>
				</li>
			</#list>
	  </ul>
	</div>
</#if>
<#if debugEnabled>
	<#assign finish = .now?long />
	<#assign elapsed = finish - start />
	<script>console.log('autodesk-trending-topics: Component done. Time elapsed: ${elapsed}ms');</script>
</#if>
