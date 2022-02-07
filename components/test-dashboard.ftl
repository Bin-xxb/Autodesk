<#import "autodesk-dashboard-macro.ftl" as autodesk_macro>
<#assign phase="">
<#if config.getString( "phase", "prod")=="prod">
    <#assign phase="">
<#elseif config.getString( "phase", "prod")=="stage">
    <#assign phase="-stg">
<#elseif config.getString( "phase", "prod")=="dev">
    <#assign phase="-dev">
</#if>
 <#assign msg_preview_endpoint = "https://forums${phase}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/autodesk-message-preview?msg_id=" />

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
				"id"           : "unanswered-posts",
				"title"    : "${text.format('autodesk-dashboard-secondary-tabs-widget-label.unanswered')}",
				"pageLabel": "unanswered-posts-page",
				"pageNumber" : unansweredPostPage
			},
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
      <li class="lia-tabs <#if tab.id!='unanswered-posts'>lia-tabs-inactive<#else>lia-tabs-active</#if>" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">
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
					<div class="dropdown-default-item"><a title="Show option menu" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" id="dropDownLink" href="#"><span class="lia-fa lia-tab-overflow-icon"></span></a>
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
    <#if currentURL?contains('unanswered-posts-page') && !currentURL?contains('forum-posts-page') && !currentURL?contains('idea-posts-page')>
        <#-- if condition made for lazy loading for unanswered posts considering active areas wrt to that user -->
        
            <div class="tab-content" id="${panelTabs[0].id}-tab-content">
              <div class="" id="dashboard_${panelTabs[0].id}">
                 <#attempt>
                    <#assign pagingLabel = panelTabs[0].pageLabel />
                    <#assign pageNumber = panelTabs[0].pageNumber />
                    <#assign active_boards_list = autodesk_macro.getUserActiveAreasList(user.id) />
                     ${active_boards_list?size}
                    <#if active_boards_list?size gt 0>
                        <#assign postCount   = autodesk_macro.getUnansweredPostsCountWRTUser() />
                        <#assign messages    = autodesk_macro.getUnansweredPostsWRTUser() />
                    <#assign totalPage   = (postCount / messages_per_page_linear)?ceiling />	
                    <#else>
                        <#-- no active boards -->
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
                            <@autodesk_macro.lib_custom_wide_table_posts_with_avatar messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />				
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

    <#elseif !currentURL?contains('unanswered-posts-page') && currentURL?contains('forum-posts-page') && !currentURL?contains('idea-posts-page')>
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
                    <#else>
                        <#-- no active boards -->
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
                            
    <#elseif !currentURL?contains('unanswered-posts-page') && !currentURL?contains('forum-posts-page') && currentURL?contains('idea-posts-page')>
        <div class="tab-content" id="${panelTabs[2].id}-tab-content">
              <div class="" id="dashboard_${panelTabs[2].id}">
                 <#attempt>
                    <#assign pagingLabel = panelTabs[2].pageLabel />
                    <#assign pageNumber = panelTabs[2].pageNumber />
                    <#assign active_boards_list = autodesk_macro.getUserActiveAreasList(user.id) />
                    <#if active_boards_list?size gt 0>
                        <#assign postCount   =  panelTabs[2].count?eval/>
                        <#assign messages    = panelTabs[2].api?eval />
                    <#assign totalPage   = (postCount / messages_per_page_linear)?ceiling />	
                    <#else>
                        <#-- no active boards -->
                    </#if>
                        
                <div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${panelTabs[2].id}">
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

                    
<#assign msgCharLimit = 350 />
<div id="lia-panel-tooltip">
    <#list messages as message>
        <#assign msgText=message.body />
        <#assign msgTextWordFinder = msgText?index_of("<w:WordDocument>")>
        <#if msgTextWordFinder != -1>
            <#assign msgText = "Word Document Embedded" />	
        <#else>
            <#assign msgText = msgText?replace('<[^>]+>', '', 'r') />
        </#if>
        <#if msgText?length gt msgCharLimit>
            <#assign msgText = msgText?substring(0, msgCharLimit) + "&hellip;" />
        </#if>
        <div id="lia-custom-tooltip-${message.id}" class="lia-panel-tooltip-tr-bl" style="display: none;">
            <div class="litho_message_hoverbox"> 
                    <div class="litho_messageInfo_top"> 
                        <div>
                            <span class="litho_messageInfo_top_label">${msgText}</span>
                        </div>
                    </div>	
                <div class="tooltip-bg"></div>
            </div>
        </div>
    </#list>
</div>

<@liaAddScript>
;(function($) {
$(document).ready(function($) {
    //debugger;
var tab_des = "";
        var panelTabs = {
			$ulElement: $("#lia-body .lia-content .custom-component-dashboard-tab-list ul.lia-tabs-secondary"),
			$ulElement_responsive : $("#lia-body .lia-content select.lia-tabselect1"),
			$tabPanel: $("#lia-body .lia-content .custom-component-dashboard-tab-list"),			
            init: function() {		
				//console.log("*** inside panelTabs init ***");
                var that = this;
				var handler = function() {
					//console.log(this);
					//console.log('ulElement on click');
                    tab_des = $(this).attr('data-tab');
					//console.log('tab_des>>'+tab_des);
                    var tab_selector = $(this).attr('id');
                    //console.log('tabClick event>> tab_selector>>' + tab_selector + ' is active ::' + $(this).hasClass('lia-tabs-active'));
                    that.tabClick(tab_selector);
					that.renderMessagePreview(tab_selector+'-content');
                };
				var responsive_handler = function() {					
					//console.log('ulElement_responsive on click');
					var tab_index = that.$ulElement_responsive.find("option:selected").index();
					//console.log(tab_index);					
					$(that.$ulElement.find("li")[tab_index]).trigger('click');					
				};
				$("#lia-body .lia-content .custom-component-mydashborad-page-tab-list li.lia-tab-overflow").on("click", function(e) {
					//console.log('li.lia-tab-overflow click');
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
    //debugger;
                console.log('in tab click'+tab_id)
				var that = this;			
                that.$ulElement.find(".lia-tabs").addClass("lia-tabs-inactive").removeClass("lia-tabs-active");
                that.$ulElement.find("#" + tab_id).addClass("lia-tabs-active").removeClass("lia-tabs-inactive");
            },
			initAllPosts : function(tab_des){	//in case if we need any processing on messages before load						
			},
			renderMessagePreview : function(tab_des){
    //debugger;
				//console.log('in renderMessagePreview > '+tab_des);				
				//debugger;
				$('body').append('<div id="lia-panel-tooltip"></div>');
				$("#lia-panel-tooltip").append("<div id='tt' ></div>");
				
				var counter=0;
				var renderedCssClass = "lia-panel-tooltip-tr-bl";
				$("#"+tab_des+" .lia-component-forums-widget-message-list .message-subject").each(function () {
					 var item = $(this);
					 var msgItem = item.parents('tr.lia-list-row');
					 var href = msgItem.attr('class');
					 
					 var UidIndex = href.indexOf("lia-js-data-messageUid-");
					 if(UidIndex != -1)
					 {
						 UidIndex = UidIndex + 23;
						 var msgId = href.slice(UidIndex);
					 }
					 else
					 {
						var msgId = "None";
					 }
					 var tipWidth = 320; // -- unused  var
					 var position = '';
					 
					 if (msgId!="null"){
						var elementId = "lia-custom-tooltip-"+ msgId;
						
						$("#" + elementId).hide();						
						
						if (!$("#" + elementId).hasClass(renderedCssClass)) {
								$("#" + elementId).addClass(renderedCssClass);	
						}
						var tooltipObj = item.tooltip({
							tip: "#" + elementId,
							position: position,
							onBeforeShow: function() {
							 $("#" + elementId).show();
							},
							onShow:function(){
							 //debugger;
							 var h = $("#" + elementId + " > div").outerHeight();
							  var w = $("#" + elementId + " > div").outerWidth();
							 var topValue = parseInt($("#" + elementId ).css("top").split("px")[0]);
							 //var newValue = topValue - h - 28;
							 var newValue = topValue + 33;
							 $("#" + elementId ).css("top", newValue.toString() + "px");
							  var leftValue = parseInt($("#" + elementId ).css("left").split("px")[0]);
							   var newLeftValue = leftValue - w/2;
							 $("#" + elementId ).css("left", newLeftValue.toString() + "px");
							}
						});
					 
					}
					counter++;
				});		
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
    console.log(default_tab_id);
		panelTabs.tabClick(default_tab_id+'-tab');
		panelTabs.renderMessagePreview(default_tab_id+'-tab-content');	
});		
})(LITHIUM.jQuery); 
</@liaAddScript>
