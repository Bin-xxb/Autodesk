<@liaMarkupCache ttl="86400000" anonymousOnly="false" />
<#assign todays_date_in_millisec = .now?long />
<#assign todays_date = ((.now)?date)?iso_utc />
<#assign month_back_date_in_millisec = todays_date_in_millisec-2592000000 />
<#assign month_back_date = ((todays_date_in_millisec-2592000000)?number_to_time)?string('YYYY-MM-dd') />

<#assign liql_autodesk_metrics_idea_topics = "select count(*) from messages where conversation.style='idea' and depth=0 and post_time > ${month_back_date_in_millisec} AND post_time < ${todays_date_in_millisec}"/>
<#assign topics_count = restadmin("2.0","/search?q=" + liql_autodesk_metrics_idea_topics?url).data.count!0 />

<#assign liql_autodesk_metrics_idea_posts = "select count(*) from messages where conversation.style='idea' and post_time > ${month_back_date_in_millisec} AND post_time < ${todays_date_in_millisec}"/>
<#assign posts_count = restadmin("2.0","/search?q=" + liql_autodesk_metrics_idea_posts?url).data.count!0 />

<#assign comments_count = posts_count - topics_count />
${comments_count}