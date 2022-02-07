<#assign is_product = coreNode.settings.name.get("autodesk.product_non_product")?matches("p", "i") />

<#assign query_param="" />
<#assign group_flag="false"/>
<#assign cat_title_initial="" />
<#assign cat_title_initial_low_case="" />
<#assign cat_href="" />
<#assign category_id=""/>
<#assign board_title_initial_low_case="" />

<#if page.name=="ForumPage" || page.name=="IdeaExchangePage">
	<#if coreNode.ancestors?size gte 3>
		<#assign category_id=coreNode.ancestors[1].id />
		<#assign cat_href=coreNode.ancestors[1].webUi.url />
		<#assign cat_title_initial=coreNode.ancestors[1].title />
		<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
		<#if cat_title_initial_low_case=="international forums">
			<#assign category_id=coreNode.ancestors[0].id />
			<#assign cat_href=coreNode.ancestors[0].webUi.url />
			<#assign cat_title_initial=coreNode.ancestors[0].title />
			<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
		</#if>
	<#else>
		<#assign category_id=coreNode.ancestors[0].id />
		<#assign cat_href=coreNode.ancestors[0].webUi.url />
		<#assign cat_title_initial=coreNode.ancestors[0].title />
		<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
	</#if>
		
	<#assign query_param="${(cat_title_initial_low_case?replace(' ','-'))}/ct-p/${category_id}" />
	<#if cat_title_initial_low_case=="autodesk community">
		<#assign cat_title_initial=coreNode.title />
		<#assign cat_href=coreNode.webUi.url />
		<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
		<#assign query_param="${(cat_title_initial_low_case?replace(' ','-'))}/bd-p/${coreNode.id}" />
	</#if>
<#elseif page.name=="CategoryPage">
	<#assign category_id=coreNode.id />
	<#assign cat_href=coreNode.webUi.url />
	<#assign cat_title_initial=coreNode.title />
	<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
	<#assign query_param="${(cat_title_initial_low_case?replace(' ','-'))}/ct-p/${category_id}" />
<#elseif page.name=="ForumTopicPage" || page.name=="IdeaPage">
	<#assign category_id=coreNode.ancestors[0].id />
	<#assign cat_href=coreNode.ancestors[0].webUi.url />
	<#assign cat_title_initial=coreNode.ancestors[0].title />
	<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
	<#assign query_param="${(cat_title_initial_low_case?replace(' ','-'))}/ct-p/${category_id}" />
	<#if cat_title_initial_low_case=="autodesk community">
		<#assign board_id=page.context.thread.board.id />
		<#assign board_title=page.context.thread.board.title />
		<#assign board_title_initial_low_case=board_title?lower_case />
		<#assign query_param="${(board_title_initial_low_case?replace(' ','-'))}/bd-p/${board_id}" />
	</#if>
<#elseif page.name=="GroupPage">
	<#assign group_flag="true"/>
	<#if coreNode.ancestors?size gte 3>
		<#assign category_id=coreNode.ancestors[1].id />
		<#assign cat_href=coreNode.ancestors[1].webUi.url />
		<#assign cat_title_initial=coreNode.ancestors[1].title />
		<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
	<#else>
		<#assign category_id=coreNode.ancestors[0].id />
		<#assign cat_href=coreNode.ancestors[0].webUi.url />
		<#assign cat_title_initial=coreNode.ancestors[0].title />
		<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
	</#if>  
		<#assign query_param="${(cat_title_initial_low_case?replace(' ','-'))}/ct-p/${category_id}" />
<#elseif page.name=="GroupMessagePage">
	<#assign group_flag="true"/>
	<#if coreNode.ancestors?size gte 3>
		<#assign category_id=coreNode.ancestors[1].id />
		<#assign cat_href=coreNode.ancestors[1].webUi.url />
		<#assign cat_title_initial=coreNode.ancestors[1].title />
		<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
	<#else>
		<#assign category_id=coreNode.ancestors[0].id />
		<#assign cat_href=coreNode.ancestors[0].webUi.url />
		<#assign cat_title_initial=coreNode.ancestors[0].title />
		<#assign cat_title_initial_low_case=cat_title_initial?lower_case />
	</#if>  
	<#assign query_param="${(cat_title_initial_low_case?replace(' ','-'))}/ct-p/${category_id}" />
	<#assign cat_title_initial=coreNode.title />
</#if>

<div class="custom-category-board-header">
	<div class="component-autodesk-product-nonproduct-page-title">
		<div class="inner-wrapper">
			<div id="product-banner">
				<#if is_product>
				<div id="product-icon-div">
					<a id="product-icon">
					</a>
				</div>
				</#if>
				<div id="product-name-div">
					<a id="product-name"><#if !is_product>${cat_title_initial}</#if></a>	
				</div>
			</div>
			<div id="product-community">
				${text.format("general.Community")}
			</div>
		</div>
	</div>

	<#if is_product>
	<div id="tabGroup-product-tabs" class="lia-tabs-standard-wrapper lia-component-tabs custom-component-submenu-products-tabs">
		<ul role="tablist" class="lia-tabs-standard">
			<li role="presentation" class="lia-tabs lia-tabs-active">
				<span class="lia-tabs-link-container"><a class="lia-link-navigation tab-link lia-custom-event" role="tab" aria-selected="true" tabindex="0" href="${cat_href}" data-wat-link="true" data-wat-loc="tab" data-wat-val="forums">${text.format('autodesk.akn-tabs.forums.label')}</a></span>
			</li>
			<li role="presentation" class="lia-tabs lia-tabs-inactive lia-js-hidden lia-tab-overflow">
				<div class="lia-menu-navigation-wrapper lia-js-hidden" id="dropdownmenu-product-tabs">
					<div class="lia-menu-navigation">
						<div class="dropdown-default-item">
							<a title="${text.format("component.DropDownMenu.link.title")}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" aria-expanded="false" role="button" aria-label="${text.format("DropDownMenu.default-link.aria-label")}" id="dropDownLink-product-tabs" href="#"></a>
							<div class="dropdown-positioning">
								<div class="dropdown-positioning-static">
									<ul role="listbox" id="dropdownmenuitems-product-tabs" class="lia-menu-dropdown-items">
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</li>
		</ul>
	</div>
	</#if>

</div>

<#if is_product>
<@component id="custom.autodesk.lia-tabs-js-lib"/>

<@liaAddScript>
;(function($){
	var language = LITHIUM.CommunityJsonObject.User.settings['profile.language'];
	var endpoint_url = '${webuisupport.urls.endpoints.name.get("sub-menu-ep").build()?js_string}' + '?query_param=${query_param?url?js_string}&lang=' + language;
	
	$.ajax({
		url: endpoint_url,
		contentType: "application/json",
		success: function(data) {
			/* product logo and name - start */
			if (data.productlanding) {
				$('#product-banner a').attr('href',data.productlanding);
			}
			if("${group_flag}"=="true"){
				$('#product-banner #product-name').text("${cat_title_initial}");
			} else if (data.productName) {
				if(data.productName=="AutoCAD for Mac"){
					$('#product-banner #product-name').text("AutoCAD ");
					var txt1 = document.createElement("span");
					$("#product-banner #product-name").append(txt1);			
					$('#product-banner #product-name span').text("for Mac");
				}
				else{
					$('#product-banner #product-name').text(data.productName);  
				}
			} else{
				$('#product-banner #product-name').text("${cat_title_initial}");
			}

			if(data.logo) {
				$('#product-icon').append('<img id="product-image" src="' + data.logo + '" alt="' + data.productName + '"/>');
			} else {
				$('#product-icon-div').remove();
			}

			/* for product name with no image */
			if($("#product-image").length != 0 && (!$("#product-image").attr('src') || $("#product-image").attr('src').indexOf('Blank_Forums_Logo.png') !== -1)) {
				$('#product-icon-div').remove();
			}
			/* product logo and name - end */


			/* product tabs - start */
			if (data.tabs) {
				var tabs_dom = '';
				Object.keys(data.tabs).forEach(function(key) {
					var value = data.tabs[key];
		
					var watVal = 'knowledge';
					if(value.indexOf('/learn') != -1) {
						watVal = 'learn';
					} else if(value.indexOf('/downloads') != -1) {
						watVal = 'downloads';
					} else if(value.indexOf('/troubleshooting') != -1) {
						watVal = 'troubleshooting';
					}
					tabs_dom +='<li role="presentation" class="lia-tabs lia-tabs-inactive"><span class="lia-tabs-link-container"><a class="lia-link-navigation tab-link lia-custom-event" role="tab" aria-selected="false" tabindex="0" href="' + value + '" data-wat-link="true" data-wat-loc="tab" data-wat-val="' + watVal + '">'+key+'</a></span></li>';
					
				});
				$('#tabGroup-product-tabs .lia-tabs-standard').prepend(tabs_dom);
				LITHIUM.ResponsiveTabsInit();
			}
			/* product tabs - end */
		}
	});

})(LITHIUM.jQuery);

</@liaAddScript>
</#if>
