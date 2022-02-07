<@liaMarkupCache ttl="86400000" anonymousOnly="false" />
<#assign todays_date_in_millisec = .now?long />
<#assign todays_date = ((.now)?date)?iso_utc />
<#assign month_back_date_in_millisec = todays_date_in_millisec-2592000000 />
<#assign month_back_date = ((todays_date_in_millisec-2592000000)?number_to_time)?string('YYYY-MM-dd') />

<#assign liql_autodesk_metrics_forum_topics = "select count(*) from messages where conversation.style='forum' and depth=0 and post_time > ${month_back_date_in_millisec} AND post_time < ${todays_date_in_millisec}"/>
<#assign topics_count = restadmin("2.0","/search?q=" + liql_autodesk_metrics_forum_topics?url).data.count!0 />
${topics_count}
