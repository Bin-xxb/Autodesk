<#import "autodesk.common.lib.macros.ftl" as autodesk_macro>

<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>


<#assign interaction_style = http.request.parameters.name.get("interaction_style","forum") />
<#if interaction_style != "forum" && interaction_style != "idea">
	<#assign interaction_style = "forum"/>
</#if>

<#if interaction_style == "idea">
	<#assign queryString = "SELECT parent.id, id, title, view_href FROM nodes WHERE node_type ='board' AND conversation_style = 'idea' limit 10000" />
	<#assign items = rest( "2.0", "/search?q=" + queryString?url).data.items![] />
	<#assign nodes_allowed = [] />
	<#list items as item>
		<#assign nodes_allowed = nodes_allowed + [{
			"id": item.parent.id?keep_after(':'), 
			"view_href": item.view_href, 
			"title": item.title
		}] />
	</#list>
<#else>
	<#assign queryString = "SELECT id, title, view_href FROM nodes WHERE node_type ='category' limit 10000" />
	<#assign items=rest( "2.0", "/search?q=" + queryString?url).data.items![] />
	<#assign nodes_allowed = [] />
	<#list items as item>
		<#assign nodes_allowed = nodes_allowed + [{
			"id": item.id?keep_after(':'), 
			"view_href": item.view_href, 
			"title": item.title
		}] />
	</#list>
</#if>

<#if interaction_style=="forum" >
	<#assign tk_products = 'autodesk-landing-page-products-grouping-label.forums-products' />
	<#assign tk_additional = 'autodesk-landing-page-products-grouping-label.forums-additional' />
	<#assign tk_international = 'autodesk-landing-page-products-grouping-label.forums-international' />
<#else>
	<#assign tk_products = 'autodesk-landing-page-products-grouping-label.ideas-products' />
	<#assign tk_additional = 'autodesk-landing-page-products-grouping-label.ideas-additional' />
	<#assign tk_international = 'autodesk-landing-page-products-grouping-label.ideas-international' />
</#if>


<#assign
	panelTabs = [
	{
		"id"           : "products",
		"title"    : "${text.format(tk_products)}"
	},
	{
		"id"           : "additional",
		"title"    : "${text.format(tk_additional)}"
	},
	{
		"id"           : "international",
		"title"    : "${text.format(tk_international)}"
	}
	]
/>
<div class="lia-tabs-standard-wrapper custom-component-products-tab-list lia-component-tabs" id="tabgroup">
	<ul class="lia-tabs-standard">
		<#list panelTabs as tab>
		<li class="lia-tabs <#if tab.id!="products">lia-tabs-inactive<#else>lia-tabs-active</#if>" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">
			<span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab_index}" href="javascript:void(0)" data-wat-link="true" data-wat-loc="tab" data-wat-val="${tab.id}">${tab.title}</a></span>
		</li>
		</#list>
		<!-- Please add the below li as it in the Tabs just before closing the ul tag - this is for mobile view if not found would behave in mobile view -->
		<li class="lia-tabs lia-tabs-inactive lia-tab-overflow lia-js-hidden" style="">
			<div class="lia-menu-navigation-wrapper" id="dropdownmenu">
				<div class="lia-menu-navigation">
					<div class="dropdown-default-item"><a title="${text.format('component.DropDownMenu.link.title')?html}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" id="dropDownLink" href="#"><span class="lia-fa lia-tab-overflow-icon"></span><span class="lia-fa lia-tab-overflow-icon"></span></a>
						<div class="dropdown-positioning">
							<div class="dropdown-positioning-static">
								<ul id="dropdownmenuitems" class="lia-menu-dropdown-items"></ul><iframe class="lia-iframe-shim" src="javascript:void(0);" tabindex="-1" style="position: absolute; border: 0px; opacity: 0; top: 41.1562px; left: -111.141px; height: 178px; width: 160px; z-index: 940; display: none;"></iframe>
								<iframe class="lia-iframe-shim" src="javascript:void(0);" tabindex="-1" style="position: absolute; border: 0px; opacity: 0; top: 41.1562px; left: -237.688px; height: 247px; width: 287px; z-index: 940; display: none;"></iframe>
							</div>
						</div>
					</div>
				</div>
			</div>
		</li>
	</ul>

	<#list panelTabs as tab>
	<div class="tab-content <#if tab.id!="products">lia-js-hidden</#if>" id="${tab.id}-tab-content">
		<div class="" id="productList_${tab.id}">
		<#attempt>
		<#if interaction_style=="forum" >
			<#assign cat_list = autodesk_macro.getProductsListV3(tab.id, nodes_allowed) />
		<#else>
			<#assign cat_list = autodesk_macro.getProductsIdeasListV3(tab.id, nodes_allowed) />
		</#if>
		<#if tab.id=='international'>
		<div class="product-list">
			<div class="flyopen-section">
				<@autodesk_macro.generateMenu cat_list = cat_list tab_name=tab.id />
			</div>
		</div>
		<#elseif tab.id=='products'>
		<div class="product-list">
			<div class="flyopen-section">
				<@autodesk_macro.generateMenu cat_list = cat_list tab_name=tab.id />
			</div>
		</div>
		<#elseif tab.id=='additional'>
		<div class="product-list">
			<div class="flyopen-section">
				<@autodesk_macro.generateMenu cat_list = cat_list tab_name=tab.id />
			</div>
		</div>
		</#if>
		<#recover>
		${.error}
		</#attempt>
		</div>
	</div>
	</#list>
</div>
<@liaAddScript>
;
(function($) {
$(document).ready(function($) {
	var panelTabs = {
		$ulElement: $("#lia-body .lia-content .custom-component-products-tab-list ul.lia-tabs-standard"),
		$ulElement_responsive: $("#lia-body .lia-content .custom-component-products-tab-list li.lia-tab-overflow ul"),
		$tabPanel: $("#lia-body .lia-content .custom-component-products-tab-list"),
		init: function() {
			var that = this;
			$("#lia-body .lia-content .custom-component-products-tab-list li.lia-tab-overflow").on("click", function(e) {
				console.log('li.lia-tab-overflow click');
				e.preventDefault();
				$(this).find("ul.lia-menu-dropdown-items").toggle();
				});	
			that.$ulElement.on("click", "li.lia-tabs:not('.lia-tab-overflow')", function() {
				var tab_des = $(this).attr('data-tab');
				var tab_selector = $(this).attr('id');
				console.log('tabClick event>>' + tab_selector + ' is active ::' + $(this).hasClass('lia-tabs-active'));
				that.tabClick(tab_selector);
			});
			that.$ulElement_responsive.on("click", "li", function() {
				console.log('ulElement_responsive on click');
				var tab_index = $(this).find("a").attr('tabindex');
				console.log(tab_index);
				
				that.move_horozontal_item_into_dd();
				console.log("// remove from tabs dropdown");
				console.log(this);
				$(this).remove();
				
				// show selected dropdown item in horizontal tabs
				$(that.$ulElement.find("li")[tab_index]).removeClass('lia-js-hidden');				
				$(that.$ulElement.find("li")[tab_index]).trigger('click');				
				});
			
		},
		tabClick: function(tab_id) {
			console.log("in tabClick function -- ");
			console.log('tabClick event>>' + tab_id + ' is active ::' + $(this).hasClass('lia-tabs-active'));
			$("#lia-body .lia-content .tab-content").addClass("lia-js-hidden");
			$("#lia-body .lia-content #" + tab_id + "-content").removeClass("lia-js-hidden");
			$("#lia-body .lia-content .lia-tabs").addClass("lia-tabs-inactive").removeClass("lia-tabs-active");
			$("#lia-body .lia-content #" + tab_id).addClass("lia-tabs-active").removeClass("lia-tabs-inactive");;
		},
		move_horozontal_item_into_dd: function(){
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
		}
	};
/* below code should be at the bottom of the script */
		panelTabs.init();

});
})(LITHIUM.jQuery); 
</@liaAddScript>



<#if debugEnabled>
	<#assign finish = .now?long />
	<#assign elapsed = finish - start />
	<script>console.log('autodesk-landing-page-products-grouping: Time elapsed: ${elapsed}ms');</script>
</#if>