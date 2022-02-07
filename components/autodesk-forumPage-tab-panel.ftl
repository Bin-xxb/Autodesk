<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>


<#import "autodesk.message-list.macros.ftl" as autodesk />
   
<#assign boardId=coreNode.id/>

<#assign
    solvedPostPage = 1
    unansweredPostPage = 1
    faqPostPage = 1
    currentURL = http.request.url
/>

<#attempt>
<#assign
    solvedPostPage = http.request.parameters.name.get('solved-posts-page', '1')?string?number
    unansweredPostPage = http.request.parameters.name.get('unanswered-posts-page', '1')?string?number
    faqPostPage = http.request.parameters.name.get('faq-posts-page', '1')?string?number
/>
<#recover>
</#attempt>


<#assign messages_per_page_linear = settings.name.get("layout.messages_per_page_linear")?number />
<#assign
    panelTabs = [
        {
            "id"       : "all-posts",
            "title"    : "${text.format('autodesk-forumPage-tab-panel-label.allposts')}",
            "pageLabel": "all-posts-page"
        },
        {
            "id"       : "faq-posts",
            "title"    : "${text.format('autodesk-forumPage-tab-panel-label.faq')}",
            "pageLabel": "faq-posts-page",
            "pageNumber" : faqPostPage,
            "api"       : "autodesk.getSolvedPostsv2({
                                'location'  :'boards',
                                'locationId':'${boardId}',
                                'pageSize'  :'${messages_per_page_linear}',
                                'page'      : ${faqPostPage}
                            })",
            "count"     :"autodesk.getLastestSolutionsCountv2({'location':'boards','locationId':'${boardId}'})"
        },

        {
            "id"       : "solved-posts",
            "title"    : "${text.format('autodesk-forumPage-tab-panel-label.solutions')}",
            "pageLabel": "solved-posts-page",
            "pageNumber" : solvedPostPage,
            "api"       : "autodesk.getLastestSolutionsPostsv2({
                                'location'  :'boards',
                                'locationId':'${boardId}',
                                'pageSize'  :'${messages_per_page_linear}',
                                'page'      : ${solvedPostPage}
                            })",
            "count"     :"autodesk.getLastestSolutionsCountv2({'location':'boards','locationId':'${boardId}'})"
        },
        {
            "id"       : "unanswered-posts",
            "title"    : "${text.format('autodesk-forumPage-tab-panel-label.unanswered')}",
            "pageLabel": "unanswered-posts-page",
            "pageNumber" : unansweredPostPage,
            "api"       : "autodesk.getUnansweredPosts({
                                'location'  :'boards',
                                'locationId':'${boardId}',
                                'pageSize'  :'${messages_per_page_linear}',
                                'page'      : ${unansweredPostPage}
                            })",
            "count"     :"autodesk.getUnansweredPostsCount({'location':'boards','locationId':'${boardId}'})"
        }               
    ]
/>


<#assign tab_id = "all-posts" />
<#if !currentURL?contains('solved-posts-page') && !currentURL?contains('unanswered-posts-page') && currentURL?contains('faq-posts-page')>
    <#assign tab_id = "faq-posts" />
<#elseif currentURL?contains('solved-posts-page') && !currentURL?contains('unanswered-posts-page') && !currentURL?contains('faq-posts-page')>
    <#assign tab_id = "solved-posts" />
<#elseif !currentURL?contains('solved-posts-page') && currentURL?contains('unanswered-posts-page') && !currentURL?contains('faq-posts-page')>
    <#assign tab_id = "unanswered-posts" />
</#if>

<div id="tabGroup-posts-tabs" class="lia-tabs-standard-wrapper lia-component-tabs custom-component-threads-tab-list">
    <ul role="tablist" class="lia-tabs-standard">
        <#list panelTabs as tab>
            <#if tab.id == "all-posts" >
                <li class="lia-tabs <#if tab_id == tab.id>lia-tabs-active<#else>lia-tabs-inactive</#if>" data-tab="${tab.id}-tab-content" id="all-posts-tab">
                    <#assign firstQuestionIndex=currentURL?index_of('?')/>
                    <#assign AllpostsURL=currentURL />
                    <#if firstQuestionIndex gt -1>
                        <#assign AllpostsURL=currentURL?substring(0,firstQuestionIndex) />
                    </#if>
                    <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="${AllpostsURL}" data-wat-link="true" data-wat-loc="tab" data-wat-val="${tab.id}">${tab.title}</a></span>           
                </li>
            <#else>
                <li class="lia-tabs <#if tab_id == tab.id>lia-tabs-active<#else>lia-tabs-inactive</#if>" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">   
                    <#assign pageURL=currentURL/>
                    <#if currentURL?contains('?')>
                        <#assign pageURL=currentURL?substring(0,currentURL?index_of('?')) />
                    </#if>
                    <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="${pageURL}?${tab.id}-page=1" data-wat-link="true" data-wat-loc="tab" data-wat-val="${tab.id}">${tab.title}</a></span>
                </li>
            </#if>
        </#list>
        <li role="presentation" class="lia-tabs lia-tabs-inactive lia-js-hidden lia-tab-overflow">
            <div class="lia-menu-navigation-wrapper lia-js-hidden" id="dropdownmenu-posts-tabs">
                <div class="lia-menu-navigation">
                    <div class="dropdown-default-item">
                        <a title="${text.format("component.DropDownMenu.link.title")}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" aria-expanded="false" role="button" aria-label="${text.format("DropDownMenu.default-link.aria-label")}" id="dropDownLink-posts-tabs" href="#"></a>
                        <div class="dropdown-positioning">
                            <div class="dropdown-positioning-static">
                                <ul role="listbox" id="dropdownmenuitems-posts-tabs" class="lia-menu-dropdown-items">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </li>
    </ul>
</div>

<#if tab_id == "all-posts" >
    <#-- Default tab, standard message list. -->
    <#assign messages=[]/>
    <div class="custom-component-message-list-wrapper tab-content" id="${panelTabs[0].id}-tab-content">
        <#if rest("/boards/id/${boardId}/posts/count").value?number gt 0 >
            <@component id="menu-bar"/>
        </#if>
        <@component id="message-list"/>
        <@component id="paging"/>           
    </div>
    <#if debugEnabled>
        <#assign finish = .now?long />
        <#assign elapsed = finish - start />
        <script>console.log('autodesk-forumPage-tab-panel: Tab #1 done. Time elapsed: ${elapsed}ms');</script>
    </#if>
<#elseif tab_id == "faq-posts">
    <#-- Faq Page tab. -->
    <div class="custom-component-message-list-wrapper tab-content" id="${panelTabs[1].id}-tab-content">
        <#assign pagingLabel = panelTabs[1].pageLabel />
        <#assign pageNumber = panelTabs[1].pageNumber />
        <#assign messages=panelTabs[1].api?eval/>
        <#assign count=panelTabs[1].count?eval/>
        <#assign totalPage   = (count / messages_per_page_linear)?ceiling />
        <#-- top pagination :: start -->
        <div class="lia-menu-bar lia-menu-bar-top top-block lia-component-post-list">
            <div class="lia-decoration-border-menu-bar">
                <div class="lia-decoration-border-menu-bar-top">
                    <div></div>
                </div>
                <div class="lia-decoration-border-menu-bar-content">
                    <div>               
                        <@autodesk.paging optionsHash={
                            "threadsTotal":count,
                            "pageSize"    :messages_per_page_linear,
                            "pageNumber"  :pageNumber,
                            "totalPage"   :totalPage,
                            "pagingLabel" :pagingLabel

                        } />
                    </div>
                </div>
                <div class="lia-decoration-border-menu-bar-bottom">
                    <div></div>
                </div>
            </div>
        </div>  
        <#-- top pagination :: end -->
        <div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${panelTabs[3].id}">
            <#if (messages?size > 0)>
                <a shape="rect" name="message-list"></a>
                <div class="t-data-grid thread-list">
                    <@autodesk.lib_custom_wide_table_posts_with_avatarv2 messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />
                </div>
            <#else>
                <div class="lia-panel-status-banner-note">
                    <div class="lia-text">
                        <p>${text.format('li.media.masonry-grid.empty')}</p>
                    </div>
                </div>
            </#if>
        </div>
    </div> 
    <#if debugEnabled>
        <#assign finish = .now?long />
        <#assign elapsed = finish - start />
        <script>console.log('autodesk-forumPage-tab-panel: Tab #4 done. Time elapsed: ${elapsed}ms');</script>
    </#if>
<#elseif tab_id == "solved-posts">
    <#-- Accepted Solutions Tab. -->
    <div class="custom-component-message-list-wrapper tab-content" id="${panelTabs[2].id}-tab-content">
        <#assign pagingLabel = panelTabs[2].pageLabel />
        <#assign pageNumber = panelTabs[2].pageNumber />
        <#assign messages=panelTabs[2].api?eval/>
        <#assign count=panelTabs[2].count?eval/>
        <#assign totalPage   = (count / messages_per_page_linear)?ceiling />
       
        <#-- top pagination :: start -->
        <div class="lia-menu-bar lia-menu-bar-top top-block lia-component-post-list">
            <div class="lia-decoration-border-menu-bar">
                <div class="lia-decoration-border-menu-bar-top">
                    <div></div>
                </div>
                <div class="lia-decoration-border-menu-bar-content">
                    <div>               
                        <@autodesk.paging optionsHash={
                                "threadsTotal":count,
                                "pageSize"    :messages_per_page_linear,
                                "pageNumber"  :pageNumber,
                                "totalPage"   :totalPage,
                                "pagingLabel" :pagingLabel

                            } />
                    </div>
                </div>
                <div class="lia-decoration-border-menu-bar-bottom">
                    <div></div>
                </div>
            </div>
        </div>  
        <#-- top pagination :: end -->
        <div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${panelTabs[2].id}">
        <#if (messages?size > 0)>
            <a shape="rect" name="message-list"></a>
            <div class="t-data-grid thread-list">
                <@autodesk.lib_custom_wide_table_posts_with_avatarv2 messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />
            </div>
        <#else>
            <div class="lia-panel-status-banner-note">
                <div class="lia-text">
                    <p>${text.format('li.media.masonry-grid.empty')}</p>
                </div>
            </div>
        </#if>
      </div>
    </div>         
    <#if debugEnabled>
        <#assign finish = .now?long />
        <#assign elapsed = finish - start />
        <script>console.log('autodesk-forumPage-tab-panel: Tab #2 done. Time elapsed: ${elapsed}ms');</script>
    </#if>
<#elseif tab_id == "unanswered-posts">
    <#-- unanswered messages tab. -->
    <div class="custom-component-message-list-wrapper tab-content" id="${panelTabs[3].id}-tab-content">
        <#assign pagingLabel = panelTabs[3].pageLabel />
        <#assign pageNumber = panelTabs[3].pageNumber />
        <#assign messages=panelTabs[3].api?eval/>
        <#assign count=panelTabs[3].count?eval/>
        <#assign totalPage   = (count / messages_per_page_linear)?ceiling />
        
        <#-- top pagination :: start -->
        <div class="lia-menu-bar lia-menu-bar-top top-block lia-component-post-list">
            <div class="lia-decoration-border-menu-bar">
                <div class="lia-decoration-border-menu-bar-top">
                    <div></div>
                </div>
                <div class="lia-decoration-border-menu-bar-content">
                    <div>               
                        <@autodesk.paging optionsHash={
                            "threadsTotal":count,
                            "pageSize"    :messages_per_page_linear,
                            "pageNumber"  :pageNumber,
                            "totalPage"   :totalPage,
                            "pagingLabel" :pagingLabel

                        } />
                    </div>
                </div>
                <div class="lia-decoration-border-menu-bar-bottom">
                    <div></div>
                </div>
            </div>
        </div>  
        <#-- top pagination :: end -->
        <div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${panelTabs[3].id}">
            <#if (messages?size > 0)>
                <a shape="rect" name="message-list"></a>
                <div class="t-data-grid thread-list">
                    <@autodesk.lib_custom_wide_table_posts_with_avatarv2 messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />
                </div>
            <#else>
                <div class="lia-panel-status-banner-note">
                    <div class="lia-text">
                        <p>${text.format('li.media.masonry-grid.empty')}</p>
                    </div>
                </div>
            </#if>
        </div>
    </div>    
    <#if debugEnabled>
        <#assign finish = .now?long />
        <#assign elapsed = finish - start />
        <script>console.log('autodesk-forumPage-tab-panel: Tab #3 done. Time elapsed: ${elapsed}ms');</script>
    </#if>
</#if>

<@component id="custom.autodesk.lia-tabs-js-lib"/>


        
<#if debugEnabled>
    <#assign finish = .now?long />
    <#assign elapsed = finish - start />
    <script>console.log('autodesk-forumPage-tab-panel: Component done. Time elapsed: ${elapsed}ms');</script>
</#if>
