<#--  <#import "autodesk-dashboard-macro.ftl" as autodesk_macro>  -->
<#import "autodesk.message-list.macros.ftl" as autodesk_macro />

<#assign
	myForumPostPage = http.request.parameters.name.get('forum-posts-page', '1')?string?number
	unansweredPostPage = http.request.parameters.name.get('unanswered-posts-page', '1')?string?number
	myIdeaPostPage = http.request.parameters.name.get('idea-posts-page', '1')?string?number
	currentURL = http.request.url
/>
<#assign messages_per_page_linear = settings.name.get("layout.messages_per_page_linear")?number />

<#assign
panelTabs = [
    {
        "id"           : "forum-posts",
        "title"    : "${text.format('autodesk-dashboard-secondary-tabs-widget-label.my-forums')}",
        "pageLabel": "forum-posts-page",
        "pageNumber" : myForumPostPage,
        "count" : "autodesk_macro.getUserPostsCount({'user_id'  :'${user.id}','conversation_style' : 'forum'})",
        "api" : "autodesk_macro.getUserPosts({
            'pageSize'  :'${messages_per_page_linear}',
            'page'      :myForumPostPage,
            'user_id'  :'${user.id}',
            'conversation_style' : 'forum'
        })"
    },
    {
        "id"           : "idea-posts",
        "title"    : "${text.format('autodesk-dashboard-secondary-tabs-widget-label.my-ideas')}",
        "pageLabel": "idea-posts-page",
        "pageNumber" : myIdeaPostPage,
        "count" : "autodesk_macro.getUserPostsCount({'user_id'  :'${user.id}','conversation_style' : 'idea'})",
        "api" : "autodesk_macro.getUserPosts({
            'pageSize'  :'${messages_per_page_linear}',
            'page'      :myIdeaPostPage,
            'user_id'  :'${user.id}',
            'conversation_style' : 'idea'
        })"				
    }
]
/>
<div class="lia-tabs-standard-wrapper custom-component-dashboard-tab-list lia-component-tabs" id="dashboard-secondary-tabgroup">
    <ul class="lia-tabs-secondary">
        <#list panelTabs as tab>
        <li class="lia-tabs <#if tab.id!='forum-posts'>lia-tabs-inactive<#else>lia-tabs-active</#if>" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">
            <#assign indexQuestion=currentURL?index_of('?')/>
            <#if indexQuestion gt 0>
                <#assign url=currentURL?substring(0,indexQuestion)+"?${tab.id}-page=1"/>
            <#else>
                <#assign url=currentURL+"?${tab.id}-page=1"/>
            </#if>
            <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="${url}">${tab.title}</a></span>
        </li>
        </#list>
		<li class="lia-tabs lia-tabs-inactive lia-tab-overflow lia-js-hidden" style="">
			<div class="lia-menu-navigation-wrapper" id="dropdownmenu">
				<div class="lia-menu-navigation">
					<div class="dropdown-default-item"><a title="${text.format('component.DropDownMenu.link.title')?html}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" id="dropDownLink" href="#"><span class="lia-fa lia-tab-overflow-icon"></span></a>
						<div class="dropdown-positioning">
							<div class="dropdown-positioning-static">
								<ul id="dropdownmenuitems" class="lia-menu-dropdown-items"></ul>
                              	<iframe class="lia-iframe-shim" src="javascript:void(0);" tabindex="-1" style="position: absolute; border: 0px; opacity: 0; top: 41.1562px; left: -237.688px; height: 247px; width: 287px; z-index: 940; display: none;"></iframe>
							</div>
						</div>
					</div>
				</div>
			</div>
		</li>	  
    </ul>
    <#assign messages = [] />
    <#if  currentURL?contains('forum-posts-page') && !currentURL?contains('idea-posts-page')>
        <div class="tab-content" id="${panelTabs[0].id}-tab-content">
            <div class="" id="dashboard_${panelTabs[0].id}">
                <#attempt>
                <#assign pagingLabel = panelTabs[0].pageLabel />
                <#assign pageNumber = panelTabs[0].pageNumber />
                <#assign active_boards_list = autodesk_macro.getUserActiveAreasList(user.id) />
                <#if active_boards_list?size gt 0>
                    <#assign postCount   =  panelTabs[0].count?eval/>
                    <#assign messages    = panelTabs[0].api?eval />
                    <#assign totalPage   = (postCount / messages_per_page_linear)?ceiling />	
                </#if>
                <div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${panelTabs[0].id}">
		           <#if (messages?size gt 0)>
                        <#-- top pagination :: start -->
                        <div class="lia-menu-bar lia-menu-bar-top top-block lia-component-post-list">
                            <div class="lia-decoration-border-menu-bar">
                                <div class="lia-decoration-border-menu-bar-top">
                                    <div></div>
                                </div>
                                <div class="lia-decoration-border-menu-bar-content">
                                    <div>				
                                        <@autodesk_macro.paging optionsHash={
                                                "threadsTotal":postCount,
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
                        <a shape="rect" name="message-list"></a>
                        <div class="t-data-grid thread-list">
                            <@autodesk_macro.lib_custom_wide_table_posts_with_avatarv2 messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />				
                        </div>
                        <#-- bottom pagination :: start -->
                        <div class="lia-menu-bar lia-menu-bar-top top-block lia-component-post-list">
                            <div class="lia-decoration-border-menu-bar">
                                <div class="lia-decoration-border-menu-bar-top">
                                    <div></div>
                                </div>
                                <div class="lia-decoration-border-menu-bar-content">
                                    <div>				
                                        <@autodesk_macro.paging optionsHash={
                                            "threadsTotal":postCount,
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
                        <#-- bottom pagination :: end -->				
                    <#else>
                        <div class="lia-panel-status-banner-note">
                            <div class="lia-text">
                                <p>${text.format('li.media.masonry-grid.empty')}</p>
                            </div>
                        </div>
                    </#if>
		          </div>		
                <#recover>
                    ${.error}
                </#attempt>
            </div>
        </div>                      
    <#elseif  !currentURL?contains('forum-posts-page') && currentURL?contains('idea-posts-page')>
        <div class="tab-content" id="${panelTabs[1].id}-tab-content">
            <div class="" id="dashboard_${panelTabs[1].id}">
                <#attempt>
                <#assign pagingLabel = panelTabs[1].pageLabel />
                <#assign pageNumber = panelTabs[1].pageNumber />
                <#assign active_boards_list = autodesk_macro.getUserActiveAreasList(user.id) />
                <#if active_boards_list?size gt 0>
                    <#assign postCount   =  panelTabs[1].count?eval/>
                    <#assign messages    = panelTabs[1].api?eval />
                    <#assign totalPage   = (postCount / messages_per_page_linear)?ceiling />	
                </#if>
                <div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${panelTabs[1].id}">
		           <#if (messages?size gt 0)>
                    <#-- top pagination :: start -->
                    <div class="lia-menu-bar lia-menu-bar-top top-block lia-component-post-list">
                        <div class="lia-decoration-border-menu-bar">
                            <div class="lia-decoration-border-menu-bar-top">
                                <div></div>
                            </div>
                            <div class="lia-decoration-border-menu-bar-content">
                                <div>				
                                    <@autodesk_macro.paging optionsHash={
                                            "threadsTotal":postCount,
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
                    <a shape="rect" name="message-list"></a>
                    <div class="t-data-grid thread-list">
                        <@autodesk_macro.lib_custom_wide_table_posts_with_avatarv2 messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />				
                    </div>
                    <#-- bottom pagination :: start -->
                    <div class="lia-menu-bar lia-menu-bar-top top-block lia-component-post-list">
                        <div class="lia-decoration-border-menu-bar">
                            <div class="lia-decoration-border-menu-bar-top">
                                <div></div>
                            </div>
                            <div class="lia-decoration-border-menu-bar-content">
                                <div>				
                                    <@autodesk_macro.paging optionsHash={
                                            "threadsTotal":postCount,
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
                    <#-- bottom pagination :: end -->				
                    <#else>
                        <div class="lia-panel-status-banner-note">
                            <div class="lia-text">
                                <p>${text.format('li.media.masonry-grid.empty')}</p>
                            </div>
                        </div>
                    </#if>
		        </div>		
            <#recover>
                ${.error}
            </#attempt>
            </div>
        </div>             
    </#if>
</div>

<@liaAddScript>
;(function($) {
$(document).ready(function($) {
    function getPos(el) {
        var rect = el.getBoundingClientRect();
        scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;
        scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        return { top: rect.top + scrollTop, left: rect.left + scrollLeft }
    }
    var tab_des = "";
    var panelTabs = {
        $ulElement: $("#lia-body .lia-content .custom-component-dashboard-tab-list ul.lia-tabs-secondary"),
        $ulElement_responsive : $("#lia-body .lia-content select.lia-tabselect1"),
        $tabPanel: $("#lia-body .lia-content .custom-component-dashboard-tab-list"),			
        init: function() {		
            var that = this;
            var handler = function() {
                tab_des = $(this).attr('data-tab');
                var tab_selector = $(this).attr('id');
                that.tabClick(tab_selector);
            };
            var responsive_handler = function() {					
                var tab_index = that.$ulElement_responsive.find("option:selected").index();
                $(that.$ulElement.find("li")[tab_index]).trigger('click');					
            };
            $("#lia-body .lia-content .custom-component-mydashborad-page-tab-list li.lia-tab-overflow").on("click", function(e) {
                e.preventDefault();
                $(this).find("ul.lia-menu-dropdown-items").toggle();
            });	
            $("#lia-body .lia-content .custom-component-mydashborad-page-tab-list li.lia-tab-overflow li").on("click", function(e) {
                e.stopPropagation();
            });
            that.$ulElement.on("click", "li.lia-tabs:not(.lia-tab-overflow)", handler);
            that.$ulElement_responsive.on("change", responsive_handler);
        },
        tabClick: function(tab_id) {     
            if(tab_id == "forum-posts-tab"){
                current_index = 1;
            }
            else if(tab_id == "idea-posts-tab"){
                current_index = 2;
            }
            else{
                current_index = 0;
            }
            var selectedTab = $('.lia-tabselect.lia-tabselect1').find("option")[current_index];
            $(selectedTab).attr("selected","selected");
            var that = this;			
            that.$ulElement.find(".lia-tabs").addClass("lia-tabs-inactive").removeClass("lia-tabs-active");
            that.$ulElement.find("#" + tab_id).addClass("lia-tabs-active").removeClass("lia-tabs-inactive");
        },
        initAllPosts : function(tab_des) {	
            <#--in case if we need any processing on messages before load-->
        }
    };
    /* below code should be at the bottom of the script */
    panelTabs.init();
    var default_tab_id = 'unanswered-posts';
    var tab_name;
    if( window.location.search && (window.location.search.indexOf('forum-posts-page=') > 0) ){
        tab_name  = window.location.search.substring(window.location.search.indexOf('forum-posts-page=')).split('=')[0];
        default_tab_id = tab_name.slice(0,-5);
    }
    else if( window.location.search && (window.location.search.indexOf('idea-posts-page=') > 0) ){
        tab_name  = 	window.location.search.substring(window.location.search.indexOf('idea-posts-page=')).split('=')[0];
        default_tab_id = tab_name.slice(0,-5);
    }
    else if( window.location.search && (window.location.search.indexOf('unanswered-posts-page=') > 0) ){
        tab_name  = 	window.location.search.substring(window.location.search.indexOf('unanswered-posts-page=')).split('=')[0];
        default_tab_id = tab_name.slice(0,-5);
    }
    panelTabs.tabClick(default_tab_id+'-tab');
});		
})(LITHIUM.jQuery); 
</@liaAddScript>