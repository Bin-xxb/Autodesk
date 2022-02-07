<@liaMarkupCache ttl="86400000" anonymousOnly="false" />
<#assign todays_date_in_millisec = .now?long />
<#assign todays_date = ((.now)?date)?iso_utc />
<#assign month_back_date_in_millisec = todays_date_in_millisec-2592000000 />
<#assign month_back_date = ((todays_date_in_millisec-2592000000)?number_to_time)?string('YYYY-MM-dd') />

<#assign liql_autodesk_metrics_forum_solutions = "select count(*) from messages where conversation.style='forum' and conversation.solved=true and depth=0 and conversation.last_post_time >${month_back_date_in_millisec} AND conversation.last_post_time < ${todays_date_in_millisec}" />
<#assign solutions_count = restadmin("2.0","/search?q=" + liql_autodesk_metrics_forum_solutions?url).data.count!0 />
${solutions_count}