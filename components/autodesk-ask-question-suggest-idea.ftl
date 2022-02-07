<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>

<#assign setting_list_roles_list = coreNode.settings.name.get("autodesk.roles_allowedpost_on_ro_nodes")!"" />
<#assign setting_list_roles_array = setting_list_roles_list?split(',')/>
<#assign roleFlag = isManagement(setting_list_roles_array) />

<#function isManagement setting_list_roles_array>
    <#if !user.anonymous>
        <#assign roles = restadmin("/users/id/" + user.id + "/roles").roles.role />
        <#list roles as role>
            <#list setting_list_roles_array as setting_list_role>
                 <#if role.name == setting_list_role>
                    <#return "true">
                    <#break>
                 </#if>
            </#list>
        </#list>
        <#return "false">
    <#else>
        <#return "false">
    </#if>
</#function>


<#if coreNode.nodeType=="category">
    <#assign category_id=coreNode.id/>
   <#if user.anonymous==false>
        <#-- check if cat is read-only or not and role of user-->
        <#assign cat_read_only = coreNode.settings.name.get("config.read_only")!"true" />
        
       <#assign canPostForForum=rest('/categories/id/${category_id}/boards/style/forum/policy/messages/post/allowed/count').value />
        <#assign canPostForIdea=rest('/categories/id/${category_id}/boards/style/idea/policy/messages/post/allowed/count').value />
        <#-- check read only on category and admin role-->

        <#if cat_read_only == "true" && roleFlag == "true">
            <div class="lia-ask-question-suggest-idea-container lia-panel lia-panel-standard">
                <#if canPostForForum?number gt 0>
                <span class="lia-button-wrapper lia-button-wrapper-primary">
                    <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="ask-a-question" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?catId=${category_id}">
                        ${text.format('autodesk-ask-question-suggest-idea-label-ask-a-question')}</a>
                    </span>
                </span>
                </#if>
                <#if canPostForIdea?number gt 0>
                    <span class="lia-button-wrapper lia-button-wrapper-primary">
                        <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="suggest-an-idea" href="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&catId=${category_id}">
                            ${text.format('autodesk-ask-question-suggest-idea-label-suggest-an-idea')}</a>
                        </span>
                    </span>
                </#if>
            </div>
        <#elseif cat_read_only == "false">
            <div class="lia-ask-question-suggest-idea-container lia-panel lia-panel-standard">
                <#if canPostForForum?number gt 0>
                <span class="lia-button-wrapper lia-button-wrapper-primary">
                    <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="ask-a-question" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?catId=${category_id}">
                        ${text.format('autodesk-ask-question-suggest-idea-label-ask-a-question')}</a>
                    </span>
                </span>
                </#if>
                <#if canPostForIdea?number gt 0>
                    <span class="lia-button-wrapper lia-button-wrapper-primary">
                        <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="suggest-an-idea" href="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&catId=${category_id}">
                            ${text.format('autodesk-ask-question-suggest-idea-label-suggest-an-idea')}</a>
                        </span>
                    </span>
                </#if>
            </div>   
        </#if>
    <#else>
        <#assign liql_conversastion_style="SELECT conversation_style from boards WHERE ancestor_categories.id='${category_id}'" />
        <#assign response_conversation_style=rest("2.0","/search?q=" + liql_conversastion_style?url) />
        <!-- setting a flag for interaction style if true then Suggest an idea button won't be displayed -->
        <#assign idea_flag=false />
        <#assign forums_flag=false />
        <#list response_conversation_style.data.items as boards >
            <#if boards.conversation_style=="idea">
                <#assign idea_flag=true />
            <#elseif boards.conversation_style=="forum">
                <#assign forums_flag=true />
            </#if>
        </#list>
        <div class="lia-ask-question-suggest-idea-container lia-panel lia-panel-standard">
            <#if forums_flag==true>
            <span class="lia-button-wrapper lia-button-wrapper-primary">
                <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="ask-a-question" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?catId=${category_id}">
                    ${text.format('autodesk-ask-question-suggest-idea-label-ask-a-question')}</a>
                </span>
            </span>
            </#if>
            <#if idea_flag==true>
                <span class="lia-button-wrapper lia-button-wrapper-primary">
                    <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="suggest-an-idea" href="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&catId=${category_id}">
                        ${text.format('autodesk-ask-question-suggest-idea-label-suggest-an-idea')}</a>
                    </span>
                </span>
            </#if>
        </div>
    </#if>
<#elseif coreNode.nodeType=="board">
    <#assign message_post_permission=coreNode.permissions.hasPermission("create_message") />
    <#assign board_read_only="false"/>
    <#assign board_id=coreNode.id/>
    <#-- check if board is read-only or not and role of user-->
    <#assign board_read_only = coreNode.settings.name.get("config.read_only")!"true" />
    

    <#assign queryString="select parent_category.id from boards where id='${coreNode.id}'">
    <#assign response_cat_id_response=rest("2.0","/search?q=" + queryString?url) />
    <#if response_cat_id_response.data.items[0].parent_category??==true>       
          <#assign response_cat_id=response_cat_id_response.data.items[0].parent_category.id />
          <#assign url="/t5/forums/postpage/board-id/${coreNode.id}/choose-node/true/interaction-style/${page.interactionStyle}?interaction_style=${page.interactionStyle}&catId=${response_cat_id}"/>
    <#else>
        <#assign url="/t5/forums/postpage/board-id/${coreNode.id}/interaction-style/${page.interactionStyle}?interaction_style=${page.interactionStyle}"/>
    </#if>
    <#if  board_read_only == "true" && roleFlag == "true">
        <#if message_post_permission==true>
            <div class="lia-ask-question-suggest-idea-container lia-panel lia-panel-standard">
                <span class="lia-button-wrapper lia-button-wrapper-primary">
                    <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="ask-a-question" href="${url}">
                        <#if page.interactionStyle=="forum">
                            ${text.format('autodesk-ask-question-suggest-idea-label-ask-a-question')}
                        <#elseif page.interactionStyle=="idea">
                            ${text.format('autodesk-ask-question-suggest-idea-label-suggest-an-idea')}
                        </#if>
                        </a>
                    </span>
                </span>  
            </div>
        </#if>
    <#elseif board_read_only == "false" >
        <#if message_post_permission==true>
            <div class="lia-ask-question-suggest-idea-container lia-panel lia-panel-standard">
                <span class="lia-button-wrapper lia-button-wrapper-primary">
                    <span class="primary-action message-post"><a class="lia-button lia-button-primary" id="ask-a-question" href="${url}">
                        <#if page.interactionStyle=="forum">
                            ${text.format('autodesk-ask-question-suggest-idea-label-ask-a-question')}
                        <#elseif page.interactionStyle=="idea">
                            ${text.format('autodesk-ask-question-suggest-idea-label-suggest-an-idea')}
                        </#if>
                        </a>
                    </span>
                </span>  
            </div>
        </#if>
    </#if>
   
</#if>

<#if debugEnabled>
    <#assign finish = .now?long />
    <#assign elapsed = finish - start />
    <script>console.log('autodesk-ask-question-suggest-idea: Time elapsed: ${elapsed}ms');</script>
</#if>