<#assign
	solvedPostPage = http.request.parameters.name.get('solved-posts-page', '')?string
	unansweredPostPage = http.request.parameters.name.get('unanswered-posts-page', '')?string
	faqPostPage = http.request.parameters.name.get('faq-posts-page', '')?string
	currentURL = "https://forums-stg.autodesk.com/t5/custom/page/page-id/TempPage"
/>
${solvedPostPage}
<#macro debug msg="">
<script>console.log("${msg}");</script>
</#macro>
<#global type_item=''/>



<#function lia_custom_mergeHashes hashes1 hashes2 >
<#assign
    hashes1Temp = hashes1
    hashes2Temp = hashes2
/>
<#list hashes2Temp?keys as key>
    <#assign hashes1Temp = hashes1Temp + {key:hashes2Temp[key]} />
</#list>
<#return hashes1Temp>

</#function>
    
    
<#assign
    optionsHash = {
        "location"  :"boards",
        "locationId":"706",
        "page":1,
        "pageSize"  :5
    }
/>
    
<#assign
    defaultOptions = {
        "location"  :"",
        "locationId":"",
        "page":1,
        "pageSize"  :5
    }
/>
<#if solvedPostPage!="" && faqPostPage=="" && unansweredPostPage=="" >
<#assign options = lia_custom_mergeHashes(defaultOptions,optionsHash) />
    <#if options.location == "" || options.locationId == "">
        <#assign queryString = [
                                '/search/messages/',
                                '?',
                                'solved=true',
                                '&',
                                'sort_by=-topicPostDate',
                                '&',
                                'page_size=${options.pageSize}',
                                '&', 'page=${options.page}','&','restapi.format_detail=full_list_element','&','restapi.response_style=view'
                                ]?join("") />
    <#else>
        <#assign queryString = [
                                '/${options.location}',
                                '/id',
                                '/${options.locationId}'
                                '/search/messages/',
                                '?',
                                'solved=true',
                                '&',
                                'sort_by=-topicPostDate',
                                '&',
                                'page_size=${options.pageSize}',
                                '&', 'page=${options.page}','&','restapi.format_detail=full_list_element','&','restapi.response_style=view'
                                ]?join("") />
    </#if>
    <#assign messages = rest(queryString).messages.message />
<#elseif solvedPostPage=="" && faqPostPage!="" && unansweredPostPage=="" >
    <#assign options = lia_custom_mergeHashes(defaultOptions,optionsHash) />
    <#if options.location == "" || options.locationId == "">
        <#assign queryString = [
                                '/search/messages/',
                                '?',
                                'solved=true',
                                '&',
                                'sort_by=-topicPostDate',
                                '&',
                                'page_size=${options.pageSize}',
                                '&', 'page=${options.page}','&','restapi.format_detail=full_list_element','&','restapi.response_style=view'
                                ]?join("") />
    <#else>
        <#assign queryString = [
                                '/${options.location}',
                                '/id',
                                '/${options.locationId}'
                                '/search/messages/',
                                '?',
                                'solved=true',
                                '&',
                                'sort_by=-topicPostDate',
                                '&',
                                'page_size=${options.pageSize}',
                                '&', 'page=${options.page}','&','restapi.format_detail=full_list_element','&','restapi.response_style=view'
                                ]?join("") />
    </#if>
    <#assign messages = rest(queryString).messages.message />
    <#assign messages=messages?sort_by(['views','count'])/>
<#elseif solvedPostPage=="" && faqPostPage=="" && unansweredPostPage!="">
    <#assign options = lia_custom_mergeHashes(defaultOptions,optionsHash) />
    <#if options.location == "" || options.locationId == "">
        <#assign queryString = [
                                '/search/messages/',
                                '?',
                                'solved=false',
                                '&',
                                'sort_by=-topicPostDate',
                                '&',
                                'page_size=${options.pageSize}',
                                '&', 'page=${options.page}','&','restapi.format_detail=full_list_element','&','restapi.response_style=view'
                                ]?join("") />
    <#else>
        <#assign queryString = [
                                '/${options.location}',
                                '/id',
                                '/${options.locationId}'
                                '/search/messages/',
                                '?',
                                'solved=false',
                                '&',
                                'sort_by=-topicPostDate',
                                '&',
                                'page_size=${options.pageSize}',
                                '&', 'page=${options.page}','&','restapi.format_detail=full_list_element','&','restapi.response_style=view'
                                ]?join("") />
    </#if>
    <#assign messages = rest(queryString).messages.message />
    
</#if>  
    
    
    
    
<@lib_custom_wide_table_posts_with_avatar messages=messages optionsHash={"pageSize"    :10} />
        
<#function getUserProfileAvatar user_id>
<#assign profileAvatar = "" />
<#if profileAvatar == "">
    <#attempt>
        <#assign profileAvatar = restadmin("/users/id/${user_id}/profiles/avatar/url").value />
    <#recover>
        <#assign profileAvatar = "" />
    </#attempt>
</#if>
<#return profileAvatar>
</#function>

    
    
    
<#macro lib_custom_wide_table_posts_with_avatar messages optionsHash>
<#assign
defaultOptions = {
    "subjectMaxLength" : 80
}
/>

    
<#assign options = lia_custom_mergeHashes(defaultOptions,optionsHash) />
<#assign messagesTemp = messages />

<#assign friendly_dates_enabled = settings.name.get("layout.friendly_dates_enabled") />
<#assign showRepliesColumn = coreNode.settings.name.get("layout.display_replies_column")?string />
<#assign showNewMsgColumn = coreNode.settings.name.get("layout.display_new_msgs_column")?string />
<#assign showViewsColumn = coreNode.settings.name.get("layout.display_views_column")?string />

<#assign floated_msg_list = [] >
<#assign floatedMsgResponse = rest("/boards/id/706/subscriptions/global/float/thread") />
<#assign floatedMsg=floatedMsgResponse.subscriptions.subscription.target.messages.topic/>    
<#list floatedMsg as topic >
    <#assign floated_msg_list = floated_msg_list + [topic.id]>
</#list>
<table class="lia-list-wide">
     <thead>
        <tr>
           <th scope="col" class="cMessageAuthorAvatarColumn lia-data-cell-secondary lia-data-cell-text t-first">
              <div class="lia-component-common-column-empty-cell"></div>
           </th>
           <th scope="col" class="cThreadInfoColumn lia-data-cell-secondary lia-data-cell-text">
              <div class="lia-component-common-column-empty-cell"></div>
           </th>
           <#if showRepliesColumn == "true">
               <th scope="col" class="cRepliesCountColumn lia-data-cell-secondary lia-data-cell-text">
                  <div class="lia-component-common-column-empty-cell"></div>
               </th>
           </#if>
           <#if showViewsColumn == "true">
               <th scope="col" class="cViewsCountColumn lia-data-cell-secondary lia-data-cell-text">
                  <div class="lia-component-common-column-empty-cell"></div>
               </th>
           </#if>
           <th scope="col" class="triangletop lia-data-cell-secondary lia-data-cell-text">
              <div class="lia-component-common-column-empty-cell"></div>
           </th>
        </tr>
     </thead>
     <tbody>
     <#list messagesTemp as message>
    <#attempt>
        <#assign restCallForParent=rest('/threads/id/${message.id}').id>
        <#assign isThread="true">
    <#recover>
        <#assign isThread="false">
    </#attempt>
        
    <#if isThread=="true">     
    <#assign thread_escalated = 0 />
    <#attempt>
    <#if coreNode.permissions.hasPermission("allow_view_escalations")>
        
        <#-- apply app cache to escalated thread rest call -->
        <#assign appcache_thread_escalated = "autodesk_escalated_" + message.thread.@view_href?replace("/","_") />
        <#assign thread_escalated = appcache.get(appcache_thread_escalated, "") />
        <#if !(thread_escalated?has_content) >
           <#assign thread_escalated = rest("/threads/id/${message.id}/escalations/count").value />
           <#assign thread_escalated_cache = appcache.put(appcache_thread_escalated, thread_escalated) />
           <@debug msg="fresh call for ${appcache_thread_escalated}" />
        <#else>
            <@debug msg="${appcache_thread_escalated} taken from appcache" />
        </#if>

    </#if>
    <#recover>
    ${.error}
    </#attempt>			 
        <#attempt>
            <#assign message_read=rest('/messages/id/${message.id}/read').value/>
            <#assign message_read_only = message.read_only />
        <#recover>
        ${.error}
        <#assign message_read="false"/>
        </#attempt>
<#assign messageSolved=rest('messages/id/${message.id}/solutions/solution').value/>        
<tr class="lia-list-row ${["lia-row-odd", "lia-row-even"][message_index % 2]} <#if floated_msg_list?seq_contains(message.id)> lia-list-row-float<#else><#if messageSolved=="true"> lia-list-row-thread-solved</#if><#if thread_escalated?number gt 0 > lia-list-row-thread-escalated</#if></#if><#if message_read == "false"> lia-list-row-thread-unread</#if><#if (message_index + 1) == 1> t-first<#elseif (message_index + 1) == options.pageSize> t-last</#if> <#if message_read == "false"> lia-list-row-thread-unread</#if> <#if message_read_only == "true"> lia-list-row-thread-readonly</#if> lia-js-data-messageUid-${message.id}">
    <#assign msgBody=rest('/messages/id/${message.id}/body').value/>
           <td class="cMessageAuthorAvatarColumn lia-data-cell-secondary lia-data-cell-icon">
            <#assign author_href=message.author.@href/>
            <#assign authorId=author_href?substring(author_href?last_index_of('/'),author_href?length)/>
            <#assign profileAvatar = getUserProfileAvatar(authorId) />
              <div class="UserAvatar lia-user-avatar lia-component-messages-column-message-author-avatar">
                 <a class="UserAvatar lia-link-navigation" target="_self" href="${profileAvatar}"><img class="lia-user-avatar-message" title="${message.author.login}" alt="${message.author.login}" id="display_5" src="${profileAvatar}">
                 </a>
              </div>
           </td>
           <td class="cThreadInfoColumn lia-data-cell-primary lia-data-cell-text">
              <div class="lia-component-messages-column-message-info">
                 <div class="MessageSubjectCell">
                    <div class="MessageSubject">
                       <div class="MessageSubjectIcons ">
                        <#if messageSolved=="true">
                          <a class="lia-link-navigation verified-icon" href="${message.thread.@view_href}"><span class="lia-img-message-type-solved lia-fa-message lia-fa-type lia-fa-solved lia-fa" title="${text.format("config.message-type-solved.label")?html}" alt="${text.format("config.message-type-solved.label")?html}" aria-label="${text.format("config.message-type-solved.label")?html}"></span></a>
                          </#if>
                          <#if (thread_escalated?number gt 0) >
                          <span class="lia-img-message-escalated lia-fa-message lia-fa-escalated lia-fa" title="${text.format("images.message_escalated.tooltip")?html}" aria-label="${text.format("images.message_escalated.tooltip")?html}"></span>
                          </#if>							  
                          <h2 class="message-subject">
                             <span class="lia-message-unread">
                             <a class="page-link lia-link-navigation lia-custom-event" href="${message.thread.@view_href}">
                             ${message.subject}
                             </a>
                             </span>
                          </h2>
                        
                              <#if msgBody?matches(".*<((A)|(a)) .*((HREF)|(href)).*")>
                              <span class="lia-img-message-has-url lia-fa-message lia-fa-has lia-fa-url lia-fa" title="${text.format("images.message_has_url.tooltip")?html}" alt="${text.format("images.message_has_url.alt")?html}" aria-label="${text.format("images.message_has_url.tooltip")?html}">
                              </span>
                              </#if>
                          
                          
                              <#if msgBody?contains('<img') || msgBody?contains('<IMG')>
                                <span class="lia-img-message-has-image lia-fa-message lia-fa-has lia-fa-image lia-fa" title="${text.format("images.message_has_image.tooltip")?html}" alt="${text.format("images.message_has_image.alt")?html}" aria-label="${text.format("images.message_has_image.tooltip")?html}">
                                </span>			
                              </#if>
                          
                          
                              <#if msgBody?contains('<iframe') || msgBody?contains('<IFRAME')>
                                <span class="lia-img-message-has-video lia-fa-message lia-fa-has lia-fa-video lia-fa" title="${text.format("images.message_has_video.tooltip")?html}" alt="${text.format("images.message_has_video.alt")?html}" aria-label="${text.format("images.message_has_video.tooltip")?html}"></span>									
                              </#if>
                          
                          <#attempt>
                          <#assign queryString = "SELECT id FROM attachments WHERE message.id='"+message.id+"' limit 1" />
                          <#assign response_attachments = rest("2.0","/search?q=" + queryString?url) />
                              <#if response_attachments.data.size?number gt 0 >
                                <span class="lia-img-message-has-attachment lia-fa-message lia-fa-has lia-fa-attachment lia-fa" title="${text.format("images.message_has_attachment.tooltip")?html}" alt="${text.format("images.message_has_attachment.alt")?html}" aria-label="${text.format("images.message_has_attachment.tooltip")?html}"">
                                </span>								
                              </#if>
                          <#recover>
                          ${.error}
                          </#attempt>
                          
                       </div>
                      <#-- inline pagination start --
                            reference : Linear Format: Posts per page when viewing a topic
                            -->
                            <#assign messages_per_thread_page_linear = settings.name.get("layout.messages_per_thread_page_linear")?number />
                                                                                                                                 
                            <#assign total_messages_in_current_thread =  rest('messages/id/${message.id}/replies/count').value?number + 1/>								
                            <#assign totalPage_inline   = (total_messages_in_current_thread / messages_per_thread_page_linear)?ceiling />
                            <#if totalPage_inline gt 1>
                            <ul class="lia-list-standard-inline">
                                <li>[</li>
                            <#list 1..totalPage_inline as i>
                            <#assign page_num = (i_index+1)?number />
                                <li><a class="lia-link-navigation" href="${message.thread.@view_href}<#if page_num gt 1>/page/${page_num}</#if>">${page_num}</a></li>
                            </#list>
                            <li>]</li>
                            </ul>
                            </#if>						
                             <#-- inline pagination end -->		
                    </div>
                 </div>
                 <div class="lia-info-area">
                  <#attempt>
                  <#if authorId != '-1'>
                  <#-- apply app cache to Forum Page starts -->
                  <#assign appcache_ranking = "autodesk" + ("_users_id_" + authorId) + "_ranking" />
                  <#assign ranking = appcache.get(appcache_ranking, "") />
                  <#if !(ranking?has_content) >
                  <#assign ranking = restadmin("/users/id/" + authorId + "/ranking").ranking />
                  <#assign ranking_cache = appcache.put(appcache_ranking, ranking) />
                  <@debug msg="fresh call for ranking for ${appcache_ranking}" />
                  <#else>
                  <@debug msg="ranking taken from appcache for ${appcache_ranking}"/>
                  </#if>
                  <#-- apply app cache to Forum Page ends -->					
                    <span class="lia-info-area-item">
                    ${text.format("general.by")} <span class="UserName lia-user-name lia-user-rank-Participant lia-component-common-widget-user-name">
                    <#if ranking.display.left_image?has_content && ranking.display.left_image.url?has_content >
                    <img class="lia-user-rank-icon lia-user-rank-icon-left" title="${ranking.name?html}" alt="${ranking.name?html}" src="${ranking.display.left_image.url}">
                    </#if>
                    <#assign userHref=message.author.@href/>
                    <#assign userId=userHref?substring(userHref?last_index_of('/')+1,userHref?length)/>
                    <a class="lia-link-navigation lia-page-link lia-user-name-link" style="" target="_self" href="/t5/user/viewprofilepage/user-id/${userId}"><span class="">${message.author.login}</span></a>
                    </span>
                    <#attempt>  
                     <#assign queryString = "select id, view_href, author,  post_time, post_time_friendly  from messages where topic.id='"+message.id+"' order by post_time DESC limit 1" />
                     <#assign response_latest_post = rest("2.0","/search?q=" + queryString?url) />
                    <span class="DateTime lia-component-common-widget-date">
                    <#if response_latest_post.data.items[0].post_time_friendly??>
                        <span title="" class="local-friendly-date">${response_latest_post.data.items[0].post_time_friendly}</span>
                    <#else>
                       <span class="local-date">${response_latest_post.data.items[0].post_time?date?string.iso}</span>
                       <span class="local-time">${response_latest_post.data.items[0].post_time?time?string.short}</span>
                   </#if>
                    </span>
                    </span>
                    <span class="lia-dot-separator"></span>
                    
                    <#if message.board?? >
                        <#assign boardResponse=rest('${message.board.@href}')/>
                        <#assign boardTitleActual=boardResponse.board.title/>
                        <#assign boardTitle=boardTitleActual?lower_case>
                        <#assign boardTitle=boardTitle?replace(' ','-')/>
                        <#assign boardHref="/${boardTitle}/bd-p/${boardResponse.board.id}"/>
                        <span class="lia-info-area-item">
                            <span class="">
                                <a class="lia-link-navigation" target="_self" href="${boardHref}"><span class="">${boardTitleActual}</span></a>
                            </span>
                        </span>
                        <span class="lia-dot-separator"></span>
                    </#if>
                    

                    <span cssclass="lia-info-area-item" class="lia-info-area-item">
                    Latest post <span class="DateTime lia-component-common-widget-date">
                   <#if response_latest_post.data.items[0].post_time_friendly??>
                        <span title="" class="local-friendly-date">${response_latest_post.data.items[0].post_time_friendly}</span>
                    <#else>
                       <span class="local-date">${response_latest_post.data.items[0].post_time?date?string.iso}</span>
                       <span class="local-time">${response_latest_post.data.items[0].post_time?time?string.short}</span>
                   </#if>
                    </span> ${text.format("general.by")} <span class="UserName lia-user-name lia-user-rank-Participant lia-component-common-widget-user-name">
                    <#if ranking.display.left_image?has_content && ranking.display.left_image.url?has_content >
                    <img class="lia-user-rank-icon lia-user-rank-icon-left" title="${ranking.name?html}" alt="${ranking.name?html}" src="${ranking.display.left_image.url}">
                    </#if>
                    <a class="lia-link-navigation lia-page-link lia-user-name-link" style="" target="_self" href="${response_latest_post.data.items[0].author.view_href}"><span class="">${response_latest_post.data.items[0].author.login}</span></a>
                    </span>
                     <#recover>
                    ${.error}
                    </#attempt>
                    </span>
                     <#else>
                     ${text.format("general.anonymous")}
                     </#if>
                     <#recover>
                     ${.error}
                     </#attempt>
                 </div>
                 <div class="lia-stats-area">
                 <#if showRepliesColumn == "true">
                    <span class="lia-stats-area-item">
                    <span class="lia-message-stats-count">
                    <#attempt>
                     ${total_messages_in_current_thread-1}
                     <#recover>
                     ${.error}
                     </#attempt>
                     </span>
                    <span class="lia-message-stats-label">
                    ${text.format("page.list.linear.header.replies")}
                    </span>
                    </span>
                    <span class="lia-dot-separator"></span>
                </#if>
                <#if showViewsColumn == "true">
                    
                    <span class="lia-stats-area-item">
                    <span class="lia-message-stats-count">${message.views.count}</span>
                    <span class="lia-message-stats-label">
                    ${text.format("page.list.linear.header.views")}
                    </span>
                    </span>
                </#if>
                 </div>
              </div>
           </td>
           <#if showRepliesColumn == "true">
           <td class="cRepliesCountColumn lia-data-cell-secondary lia-data-cell-integer">
              <div class="lia-component-messages-column-message-replies-count">
                 <a class="lia-link-navigation lia-replies-count-link" href="${message.thread.@view_href}">
                 <span class="lia-message-stats-count">
                 <#attempt>
                 ${total_messages_in_current_thread?number-1}
                 <#recover>
                 ${.error}
                 </#attempt>
                 </span>
                 ${text.format("page.list.linear.header.replies")}
                 </a>
              </div>
           </td>
           </#if>
           <#if showViewsColumn == "true">
           <td class="cViewsCountColumn lia-data-cell-secondary lia-data-cell-integer">
              <div class="lia-component-messages-column-message-views-count">
                 <span class="lia-message-stats-count">${message.views.count}</span>
                 ${text.format("page.list.linear.header.views")}
              </div>
           </td>
           </#if>
           <td class="triangletop lia-data-cell-secondary lia-data-cell-icon">
              <div class="lia-component-common-column-empty-cell"></div>
           </td>
        </tr>
       </#if>                 
    </#list>
     </tbody>
  </table>
</#macro>