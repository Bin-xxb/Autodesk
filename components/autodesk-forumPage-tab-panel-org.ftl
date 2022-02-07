<#import "autodesk.common.lib.macros.ftl" as autodesk_macro>
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
 <#assign msg_preview_endpoint = "https://forums${phase}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/autodesk-message-preview?msg_id=" />

<#assign
	solvedPostPage = http.request.parameters.name.get('solved-posts-page', '1')?string?number
	unansweredPostPage = http.request.parameters.name.get('unanswered-posts-page', '1')?string?number
	faqPostPage = http.request.parameters.name.get('faq-posts-page', '1')?string?number
	currentURL = coreNode.webUi.url
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
					"count"    : "autodesk_macro.getFrequentlyAskedQuestionsCount({'location':'boards','locationId':'\"${coreNode.id}\"'})",
					"api"	   : "autodesk_macro.getFrequentlyAskedQuestions({
																'location'  :'boards',
																'locationId':'\"${coreNode.id}\"',
																'pageSize'  :'${messages_per_page_linear}',
																'page'      : ${faqPostPage}
															})"
				},

				{
					"id"	   : "solved-posts",
					"title"    : "${text.format('autodesk-forumPage-tab-panel-label.solutions')}",
					"pageLabel": "solved-posts-page",
					"pageNumber" : solvedPostPage,
					"count"    : "autodesk_macro.getLastestSolutionsCount({'location':'boards','locationId':'\"${coreNode.id}\"'})",
					"api"	   : "autodesk_macro.getLastestSolutionsPosts({
																'location'  :'boards',
																'locationId':'\"${coreNode.id}\"',
																'pageSize'  :'${messages_per_page_linear}',
																'page'      : ${solvedPostPage}
															})"
				},
				{
					"id"	   : "unanswered-posts",
					"title"    : "${text.format('autodesk-forumPage-tab-panel-label.unanswered')}",
					"pageLabel": "unanswered-posts-page",
					"pageNumber" : unansweredPostPage,
					"count"    : "autodesk_macro.getUnansweredPostsCount({'location':'boards','locationId':'\"${coreNode.id}\"'})",
					"api"	   : "autodesk_macro.getUnansweredPosts({
																'location'  :'boards',
																'locationId':'\"${coreNode.id}\"',
																'pageSize'  :'${messages_per_page_linear}',
																'page'      :${unansweredPostPage}
															})"
				}				

			]
/>
<div class="lia-tabs-standard-wrapper custom-component-threads-tab-list lia-component-tabs" id="tabgroup">
   <ul class="lia-tabs-standard">
   
   	<#list panelTabs as tab>
		<!-- LIT-1061: adding anchor tag -->
		<#if tab.id == "all-posts" >
			<li class="lia-tabs lia-tabs-active" data-tab="${tab.id}-tab-content" id="all-posts-tab">
				<span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="${currentURL}">${tab.title}</a></span>			
			</li>
		<#else>
			<li class="lia-tabs lia-tabs-inactive" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">			
				<span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="${currentURL}?${tab.id}-page=1">${tab.title}</a></span>
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
   
   <#list panelTabs as tab>
	<#if tab.id == "all-posts">
		<div class="custom-component-message-list-wrapper tab-content" id="${tab.id}-tab-content">
			<#if rest("/boards/id/${coreNode.id}/posts/count").value?number gt 0 >
				<@component id="menu-bar"/>
			</#if>
			
			<#-- <@component id="reply-filter"/> -->
			<@component id="message-list"/>
			<@component id="paging"/>			
		</div>
	<#else>
	<#-- faq-posts, solved-posts, unanswered-posts -->
		<div class="custom-component-message-list-wrapper tab-content lia-js-hidden" id="${tab.id}-tab-content">
		<#-- ${tab.id} -->
		<#assign postCount   = tab.count?eval />
		<#-- ${postCount} -->
		<#assign messages    = tab.api?eval />
		<#-- ${messages?size} -->
		<#assign pagingLabel = tab.pageLabel />
		<#assign pageNumber = tab.pageNumber />
		<#assign totalPage   = (postCount / messages_per_page_linear)?ceiling />
		<#-- NOTE : Hide pagination and show only 1st page data for faq-posts tab --> 
		<#if tab.id!='faq-posts'>
		
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
		</#if>
		
		<div class="MessageList lia-component-forums-widget-message-list lia-forum-message-list custom-message-list" id="messageList_${tab.id}">
		<#if (messages?size > 0)>
				<a shape="rect" name="message-list"></a>
				<div class="t-data-grid thread-list">
					<#-- <@autodesk_macro.lib_custom_wide_table_posts messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />	-->
					<@autodesk_macro.lib_custom_wide_table_posts_with_avatar messages=messages optionsHash={"pageSize"    :messages_per_page_linear} />
					
				</div>

		<#else>
			<div class="lia-panel-status-banner-note">
				<div class="lia-text">
					<p>${text.format('li.media.masonry-grid.empty')}</p>
				</div>
			</div>
		</#if>
		</div>		
		
		<#-- NOTE : Hide pagination and show only 1st page data for faq-posts tab --> 
		<#if tab.id!='faq-posts'>
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
		</#if>
		</div>
	</#if>
</#list>
</div>

<@liaAddScript>
;(function($) { 
	"use strict";
	
$(document).ready(function($) {
	var panelTabs = {
			$ulElement   : $("#lia-body .lia-content .custom-component-threads-tab-list .lia-tabs-standard"),
			$ulElement_responsive: $("#lia-body .custom-component-threads-tab-list li.lia-tab-overflow ul"),
			$tabPanel    : $("#lia-body .lia-content .custom-component-threads-tab-list"),
			onPageLoad	 : function(tab_id){
								var that = this;
								that.$tabPanel.find(".tab-content").addClass("lia-js-hidden");								
								that.$tabPanel.find("#"+tab_id+"-tab-content").removeClass("lia-js-hidden");
								that.$ulElement.find(".lia-tabs").addClass("lia-tabs-inactive").removeClass("lia-tabs-active");
								that.$ulElement.find("#"+tab_id+"-tab").addClass("lia-tabs-active").removeClass("lia-tabs-inactive");
								panelTabs.renderMessageHover();
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
			renderMessagePreview : function(tab_des){
						},
                        renderMessageHover:function(){
//debugger;
    var ur_loc=window.location.href;
    var tab_des="all-posts-tab-content";
    if (ur_loc.indexOf('faq-posts')!=-1)
    {
        tab_des='faq-posts-tab-content';
    }
    else if(ur_loc.indexOf('solved-posts')!=-1){
        tab_des='solved-posts-tab-content';
    }
    else if(ur_loc.indexOf('unanswered-posts')!=-1){
        tab_des='unanswered-posts-tab-content';
    }
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
														 if(href.indexOf(" ", UidIndex)!= -1){
															var msgId = href.slice(UidIndex, href.indexOf(" ", UidIndex));
														 }
														 else{
															var msgId = href.slice(UidIndex);
														 }
														 
													 }
													 else
													 {
														var msgId = "None";
													 }
													 var tipWidth = 320; // -- unused  var
													 var position = '';

													 
													 if (msgId!="null"){
														var elementId = "lia-custom-tooltip-"+ msgId;
														if($('#lia-panel-tooltip #'+elementId).length == 0){
															console.log('//optimization : add tooltip element in DOM only if it is not present');
															$("#lia-panel-tooltip").append("<div id='" + elementId + "'></div>");
															var msg_preview_url="${msg_preview_endpoint}" + msgId;							
															$.ajax({
																url: msg_preview_url,
																	success: function(data) {
												//debugger;
																		$("#" + elementId).append(data);										
																	}
															
															});
														}
														else{
															console.log('tooltip element already added');
														}
														
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