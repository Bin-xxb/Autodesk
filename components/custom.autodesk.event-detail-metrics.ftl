<#assign threadId = page.context.thread.topicMessage.uniqueId />

<div class="event-detail-metrics">
    <i class="lia-fa-occasion"></i>
    <#assign occasion_date_start = "SELECT occasion_data.start_time FROM messages WHERE id = '${threadId}'"/>
    <#assign occasion_date = rest("2.0","/search?q=" + occasion_date_start?url).data.items!0 />
    <#if occasion_date?size gt 0 >
        <span class="occasion_date" >
            ${occasion_date[0].occasion_data.start_time?datetime?string["EEEE"]},
            ${occasion_date[0].occasion_data.start_time?date}
        </span>
    </#if>
    <#assign count_rsvp_yes = "SELECT count(*) FROM rsvps WHERE message.id = '${threadId}' AND rsvp_response = 'yes'"/>
    |<#assign rsvp_count = rest("2.0","/search?q=" + count_rsvp_yes?url).data.count!0 />
    <span class="occasion_attending">${rsvp_count} Attending</span>
</div>