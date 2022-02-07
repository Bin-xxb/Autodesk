<#import "autodesk-forumpagetab-panel-macro.ftl" as autodesk>
<#-- OOTB components --
<component id="paging" wrapper="lia-paging-top lia-hidden-phone"/>
<component id="reply-filter"/>
<component id="message-list"/>
<component id="paging"/>	
<component id="solutions.widget.recently-solved-threads"/>
<component id="forums.widget.unanswered-topics-taplet"/>
-->
    
<#assign phase="">
<#if config.getString( "phase", "prod")=="prod">
    <#assign phase="">
<#elseif config.getString( "phase", "prod")=="stage">
    <#assign phase="-stg">
<#elseif config.getString( "phase", "prod")=="dev">
    <#assign phase="-dev">
</#if>
    
   
<#assign boardId="706"/>
<#assign
	solvedPostPage = http.request.parameters.name.get('solved-posts-page', '1')?string?number
	unansweredPostPage = http.request.parameters.name.get('unanswered-posts-page', '1')?string?number
	faqPostPage = http.request.parameters.name.get('faq-posts-page', '1')?string?number
	currentURL = http.request.url
/>

<#assign messages_per_page_linear = settings.name.get("layout.messages_per_page_linear")?number />
<#assign
	panelTabs = [
				{
					"id"	   : "all-posts",
					"title"    : "${text.format('autodesk-forumPage-tab-panel-label.allposts')}",
					"pageLabel": "all-posts-page"
				},
				{
					"id"	   : "faq-posts",
					"title"    : "${text.format('autodesk-forumPage-tab-panel-label.faq')}",
					"pageLabel": "faq-posts-page",
					"pageNumber" : faqPostPage,
                    "api"       : "autodesk.getFrequentlyAskedQuestions({
																'location'  :'boards',
																'locationId':'${boardId}',
																'pageSize'  :'${messages_per_page_linear}',
																'page'      : ${faqPostPage}
															})",
                    "count"     :"autodesk.getLastestSolutionsCount({'location':'boards','locationId':'${boardId}'})"
				},

				{
					"id"	   : "solved-posts",
					"title"    : "${text.format('autodesk-forumPage-tab-panel-label.solutions')}",
					"pageLabel": "solved-posts-page",
					"pageNumber" : solvedPostPage,
                    "api"       : "autodesk.getLastestSolutionsPosts({
																'location'  :'boards',
																'locationId':'${boardId}',
																'pageSize'  :'${messages_per_page_linear}',
																'page'      : ${solvedPostPage}
															})",
                    "count"     :"autodesk.getLastestSolutionsCount({'location':'boards','locationId':'${boardId}'})"
				},
				{
					"id"	   : "unanswered-posts",
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
<div class="lia-tabs-standard-wrapper custom-component-threads-tab-list lia-component-tabs" id="tabgroup">
   <ul class="lia-tabs-standard">
   
   	<#list panelTabs as tab>
		
		<#if tab.id == "all-posts" >
			<li class="lia-tabs lia-tabs-active" data-tab="${tab.id}-tab-content" id="all-posts-tab">
				<span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="${currentURL}">${tab.title}</a></span>			
			</li>
		<#else>
			<li class="lia-tabs lia-tabs-inactive" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">	
                <#assign pageURL=currentURL/>
                <#if currentURL?contains('?')>
                <#assign pageURL=currentURL?substring(0,currentURL?index_of('?')) />
                </#if>
				<span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="${pageURL}?${tab.id}-page=1">${tab.title}</a></span>
			</li>
		</#if>
	</#list>
    
      <li class="lia-tabs lia-tabs-inactive lia-tab-overflow lia-js-hidden" style="">
         <div class="lia-menu-navigation-wrapper" id="dropdownmenu">
            <div class="lia-menu-navigation">
               <div class="dropdown-default-item">
                  <a title="Show option menu" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" id="dropDownLink" href="#"><span class="lia-fa lia-tab-overflow-icon"></span></a>
                  <div class="dropdown-positioning">
                     <div class="dropdown-positioning-static">
                        <ul id="dropdownmenuitems" class="lia-menu-dropdown-items"></ul>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </li>
   </ul>
   
   

   
    <#if !currentURL?contains('solved-posts-page') && !currentURL?contains('unanswered-posts-page') && !currentURL?contains('faq-posts-page') >
       
     
        <div class="custom-component-message-list-wrapper tab-content" id="${panelTabs[0].id}-tab-content">
			<#if rest("/boards/id/${boardId}/posts/count").value?number gt 0 >
				<@component id="menu-bar"/>
			</#if>
			
			<#-- <@component id="reply-filter"/> -->
			<@component id="message-list"/>
			<@component id="paging"/>			
		</div>
    <#else>
        <#if currentURL?contains('solved-posts-page') && !currentURL?contains('unanswered-posts-page') && !currentURL?contains('faq-posts-page')>
             
             <div class="custom-component-message-list-wrapper tab-content lia-js-hidden" id="${panelTabs[2].id}-tab-content">
               
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
                            <#-- <@autodesk_macro.lib_custom_wide_table_posts messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />	-->
                            <@autodesk.lib_custom_wide_table_posts_with_avatar messages=messages optionsHash={"pageSize"    :5} />

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
        <#elseif !currentURL?contains('solved-posts-page') && currentURL?contains('unanswered-posts-page') && !currentURL?contains('faq-posts-page')>
             
             <div class="custom-component-message-list-wrapper tab-content lia-js-hidden" id="${panelTabs[3].id}-tab-content">
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
                            <#-- <@autodesk_macro.lib_custom_wide_table_posts messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />	-->
                            <@autodesk.lib_custom_wide_table_posts_with_avatar messages=messages optionsHash={"pageSize"    :5} />

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
        <#elseif !currentURL?contains('solved-posts-page') && !currentURL?contains('unanswered-posts-page') && currentURL?contains('faq-posts-page')>
            <div class="custom-component-message-list-wrapper tab-content lia-js-hidden" id="${panelTabs[1].id}-tab-content">
              
                <#assign pagingLabel = panelTabs[1].pageLabel />
                    <#assign pageNumber = panelTabs[1].pageNumber />
                    <#assign messages=panelTabs[1].api?eval/>
                    <#assign count=panelTabs[1].count?eval/>
               
                    <#-- NOTE : Hide pagination and show only 1st page data for faq-posts tab --> 
                    

                <div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${panelTabs[1].id}">

                <#if (messages?size > 0)>
                        <a shape="rect" name="message-list"></a>
                        <div class="t-data-grid thread-list">
                            <#-- <@autodesk_macro.lib_custom_wide_table_posts messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />	-->
                            <@autodesk.lib_custom_wide_table_posts_with_avatar messages=messages optionsHash={"pageSize"    :5} />

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
        </#if>
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
	var panelTabs = {
			$ulElement   : $("#lia-body .lia-content .custom-component-threads-tab-list .lia-tabs-standard"),
			$ulElement_responsive: $("#lia-body .custom-component-threads-tab-list li.lia-tab-overflow ul"),
			$tabPanel    : $("#lia-body .lia-content .custom-component-threads-tab-list"),
			onPageLoad	 : function(tab_id){
    //debugger;
								var that = this;
								that.$tabPanel.find(".tab-content").addClass("lia-js-hidden");								
								that.$tabPanel.find("#"+tab_id+"-tab-content").removeClass("lia-js-hidden");
								that.$ulElement.find(".lia-tabs").addClass("lia-tabs-inactive").removeClass("lia-tabs-active");
								that.$ulElement.find("#"+tab_id+"-tab").addClass("lia-tabs-active").removeClass("lia-tabs-inactive");
								panelTabs.renderMessageHover(tab_id+'-tab-content');
							},
			tabClick	 : function(){
								var that = this;
								console.log("in tabClick function -- ");

								that.$ulElement.on("click","li",function(){
									var tab_des=$(this).attr('data-tab');
									var tab_selctor=$(this).attr('id');
									console.log('tabClick event>>'+tab_selctor+' is active ::'+$(this).hasClass('lia-tabs-active'));
								});
										
							},
			move_horizontal_item_into_dd: function(){
				console.log('inside move_horozontal_item_into_dd');
				var that = this;
				var len = that.$ulElement.find("li.lia-tabs:not('.lia-tab-overflow'):not('.lia-js-hidden')").length;
				console.log(len);
				var toggle_this_ele = $(that.$ulElement.find("li.lia-tabs:not('.lia-tab-overflow'):not('.lia-js-hidden')")[len-1]);
				console.log(toggle_this_ele);
				var anchor_dom = $(toggle_this_ele.find("span a"));
				console.log(anchor_dom);
				that.$ulElement_responsive.append("<li>"+anchor_dom.outerHTML()+"</li>");
				$(toggle_this_ele).addClass('lia-js-hidden');
			},
			remove_item_from_dd : function(){
				var that = this;
				var tab_index = that.$ulElement.find("li.lia-tabs.lia-js-hidden.lia-tabs-active").find("a").attr('tabindex');
				that.$ulElement.find("li.lia-tabs.lia-js-hidden.lia-tabs-active").removeClass('lia-js-hidden');
				that.$ulElement_responsive.find("li a[tabindex="+tab_index+"]").remove();
			},
							
			initAllPosts : function(tab_des){							
						},
            renderMessageHover : function(tab_des){
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
panelTabs.tabClick();
var default_tab_id;
var tab_name;
	if( window.location.search && (window.location.search.indexOf('solved-posts-page=') > 0) ){
		tab_name  = window.location.search.substring(window.location.search.indexOf('solved-posts-page=')).split('=')[0];
		default_tab_id = tab_name.slice(0,-5);
		console.log(default_tab_id);
	}
	else if( window.location.search && (window.location.search.indexOf('faq-posts-page=') > 0) ){
		tab_name  = 	window.location.search.substring(window.location.search.indexOf('faq-posts-page=')).split('=')[0];
		default_tab_id = tab_name.slice(0,-5);
		console.log(default_tab_id);
	}
	else if( window.location.search && (window.location.search.indexOf('unanswered-posts-page=') > 0) ){
		tab_name  = 	window.location.search.substring(window.location.search.indexOf('unanswered-posts-page=')).split('=')[0];
		default_tab_id = tab_name.slice(0,-5);
		console.log(default_tab_id);
	}
	else{
		default_tab_id = 'all-posts';
	}

		panelTabs.onPageLoad(default_tab_id);	
		
/* only for smaller devices when menu from dd is selected and page is reloaded */		
var hidden_ele = panelTabs.$ulElement.find("li.lia-tabs.lia-js-hidden.lia-tabs-active:not('.lia-tab-overflow')").length;
if(hidden_ele > 0){
	panelTabs.move_horizontal_item_into_dd();
	panelTabs.remove_item_from_dd();
}


});

})(LITHIUM.jQuery); 
</@liaAddScript>
            
 