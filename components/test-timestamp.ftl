<#assign occasion_date_start = "SELECT occasion_data.start_time FROM messages WHERE id = '44943'"/>
<#assign occasion_date = rest("2.0","/search?q=" + occasion_date_start?url).data!0 />
${occasion_date.items[0].occasion_data.start_time?datetime?string["EEEE"]}
${occasion_date.items[0].occasion_data.start_time?date}

<#assign count_rsvp_yes = "SELECT count(*) FROM rsvps WHERE message.id = '44943' AND rsvp_response = 'yes'"/>
<#assign rsvp_count = rest("2.0","/search?q=" + count_rsvp_yes?url).data.count!0 />
${rsvp_count}