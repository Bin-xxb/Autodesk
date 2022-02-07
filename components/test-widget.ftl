<!-- 
Display top Trending Topics based on #of replies
-->

<#assign todays_date_in_millisec = .now?long />
<#assign todays_date_locale = .now?iso_local />
<#assign month_back_date_in_millisec=todays_date_in_millisec-2629746000 />
<#assign month_back_date_locale=(todays_date_in_millisec?number_to_date)?iso_local />
<#assign board_id="706" />
<#attempt>
<#assign liql_trending_topics="select replies.count(*),subject,id,conversation.view_href,post_time from messages where post_time >"+ month_back_date_in_millisec +" AND post_time <"+ todays_date_in_millisec +" AND depth=0 AND board.id='"+board_id+"' ORDER BY replies.count(*) DESC LIMIT 1000"/>
<#assign response_liql_trending_topics=restadmin("2.0","/search?q=" + liql_trending_topics?url) />
<#assign objectCollection=[]/>
<#list response_liql_trending_topics.data.items as item>
    <#assign newObj={"replies":"${item.replies.count}","subject":"${item.subject}","view_href":'"${item.conversation.view_href}"'}/>
<#assign objectCollection=objectCollection+[newObj]/>
</#list>
    
<#assign objectCollection=objectCollection?sort_by('replies')?reverse/>


<#if objectCollection?size!=0 >
<div class="lia-trending-topics lia-panel lia-panel-standard">
	<h4>${text.format('autodesk-trending-topics-title')}</h4>
	<ul>
		<#list objectCollection as item>
			<li class="lia-trending-topics-link">
				<a href=${item.view_href} >${item.subject}</a>
			</li>
		</#list>
    </ul>
</div>
</#if>
<#recover>
</#attempt>