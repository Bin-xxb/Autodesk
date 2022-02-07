<#assign eachMsgId=env.context.message.uniqueId/>	
<#assign messsageId=page.context.message.uniqueId/>
<#assign messageRatingsRequest=restadmin('/messages/id/${messsageId}/ratings/key/forum_topic_metoo/ratings/all')/>
<#assign messageRatingsCount=0/>
<#if messageRatingsRequest.ratings?size gt 0>
    <#assign messageRatingsCount=messageRatingsRequest.ratings.rating?size/>
</#if>
<#if eachMsgId==messsageId>
    <div class="custom_metoo lia-panel-feedback-banner-safe">
        <#if messageRatingsCount==0>
            <a href="#">I have the same question</a>
        <#else>
            <a href="#">I have the same question(${messageRatingsCount})</a>
        </#if>
    </div>
</#if>