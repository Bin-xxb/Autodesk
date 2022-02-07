<#assign inGroupHub = false />
<#if coreNode.nodeType == "grouphub">
	<#assign inGroupHub = true />
<#else>
	<#list coreNode.ancestors as ancestor>
		<#if ancestor.nodeType == "grouphub">
			<#assign inGroupHub = true />
			<#break>
		</#if>
	</#list>
</#if>

<#-- required text keys --
common.widget.breadcrumb-label.home = Home
common.widget.breadcrumb-label.support_and_learning = Support & Learning
common.widget.breadcrumb-label.forums_home = Forums Home
common.widget.breadcrumb-label.unidentified_product = [Unidentified Product]
common.widget.breadcrumb-label.community = Community
-->
<#assign phase = config.getString("phase", "dev") />
<#if phase == "dev">
	<#assign envURL = "https://knowledge-int.autodesk.com" />
<#elseif phase == "stage">
	<#assign envURL = "https://knowledge-staging.autodesk.com" />
<#elseif phase == "prod">
	<#assign envURL = "https://knowledge.autodesk.com" />
</#if>


<#assign user_lang = settings.name.get("profile.language") />
<#if !user_lang?has_content>
	<#assign user_lang = "en" />
</#if>


<#assign lang_url = "" />
<#if user_lang != "en" && user_lang != "">
	<#assign lang_url = "/" + user_lang />
</#if>

			
<#if coreNode.settings.name.get("autodesk.product_non_product")?matches("p", "i") >
	<div class="${page.content.nav.breadcrumb.css}" id="custom-overridden-breadcrumb-component">
		<ul class="lia-list-standard-inline">
			<#if !inGroupHub>
			<li> <a href="${envURL}" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="knowledge_network" >${text.format('common.widget.breadcrumb-label.knowledge_network')}</a></li>
			<li class="lia-breadcrumb-seperator crumb-community lia-breadcrumb-community lia-breadcrumb-forum">
				<span class="crumb-community lia-breadcrumb-community lia-breadcrumb-forum">${page.content.nav.breadcrumb.seperator}</span>
			</li>
			<li> <a href="${envURL}/support" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="support and learning" >${text.format('common.widget.breadcrumb-label.support_and_learning')}</a></li>
			<li class="lia-breadcrumb-seperator crumb-community lia-breadcrumb-community lia-breadcrumb-forum">
				<span class="crumb-community lia-breadcrumb-community lia-breadcrumb-forum">${page.content.nav.breadcrumb.seperator}</span>
			</li>
			</#if>
			<#assign getParentProductID = coreNode.settings.name.get("autodesk.parent_product_node_id") >
			
			<#assign node = "" />

			<#assign node_cache_string = appcache.get("crumb_" + getParentProductID, "") />

			<#if node_cache_string?has_content>
				<#assign node_cache_string_arr = node_cache_string?split("|||") />
				<#assign node = { "title": node_cache_string_arr[0], "view_href": node_cache_string_arr[1]} />
			<#else>
				<#assign queryString ="SELECT title, view_href FROM nodes WHERE id='${getParentProductID}'" />

				<#assign node_result = rest("2.0","/search?q=" + queryString?url).data.items![] />
				<#if node_result?size gt 0>
					<#assign node = node_result[0] />

					<#assign node_cache_string = node.title + "|||" + node.view_href />

					<#assign cache_result = appcache.put("crumb_" + getParentProductID, node_cache_string) />
				</#if>
			</#if>

				
			<#if node?has_content>
				<li> <a href="${envURL}${lang_url}/adsk/products/forumid?id=${node.view_href?keep_after('t5/')?url}" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="${node.title?lower_case?html}" >${node.title}</a></li>
			<#else>
				<li>${text.format('common.widget.breadcrumb-label.unidentified_product')}</li>
			</#if>
			<li class="lia-breadcrumb-seperator crumb-community lia-breadcrumb-community lia-breadcrumb-forum">
				<span class="crumb-community lia-breadcrumb-community lia-breadcrumb-forum">${page.content.nav.breadcrumb.seperator}</span>
			</li>


		<#list page.content.nav.breadcrumb.crumbs as crumb>
			<#if crumb_index gt 0>
				<li class="${crumb.wrapperCss} <#if inGroupHub && crumb.isLink && crumb.url?contains("/ct-p/")>crumb-hidden</#if>">
				<#if crumb.isLink>
					<a href="${crumb.url}" class="${crumb.css!''}" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="${crumb.text?lower_case?html}">${crumb.text}</a>
				<#else>
					<span>${crumb.text}</span>
				</#if>
				</li>
				<#sep>
				<li class="${crumb.separatorCss}">
					<span>${page.content.nav.breadcrumb.seperator}</span>
				</li>
				</#sep>
			</#if>
		</#list>
		</ul>
	</div>

<#else>

	<div class="${page.content.nav.breadcrumb.css}" id="custom-overridden-breadcrumb-component">
		<ul class="lia-list-standard-inline">
			<#if !inGroupHub>
			<li> <a href="${envURL}" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="knowledge_network" >${text.format('common.widget.breadcrumb-label.knowledge_network')}</a></li>
			<li class="lia-breadcrumb-seperator crumb-community lia-breadcrumb-community lia-breadcrumb-forum">
			<span class="crumb-community lia-breadcrumb-community lia-breadcrumb-forum">${page.content.nav.breadcrumb.seperator}</span>
			</li>
			<li> <a href="${envURL}/community" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="community" >${text.format('common.widget.breadcrumb-label.community')}</a></li>
			<li class="lia-breadcrumb-seperator crumb-community lia-breadcrumb-community lia-breadcrumb-forum">
			<span class="crumb-community lia-breadcrumb-community lia-breadcrumb-forum">${page.content.nav.breadcrumb.seperator}</span>
			</li>
			</#if>
			<#list page.content.nav.breadcrumb.crumbs as crumb>
				<li class="${crumb.wrapperCss} <#if inGroupHub && crumb.isLink && crumb.url?contains("/ct-p/")>crumb-hidden</#if>">
				<#if crumb.isLink>
					<#if crumb_index==0 >
						<a href="${crumb.url}" class="${crumb.css!''}" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="forums home">${text.format('common.widget.breadcrumb-label.forums_home')}</a>
					<#else>
						<a href="${crumb.url}" data-wat-link="true" data-wat-loc="breadcrumbs" data-wat-val="${crumb.text?lower_case?html}">${crumb.text}</a>
					</#if>
				<#else>
					<span>${crumb.text}</span>
				</#if>
				</li>
				<#sep>
				<li class="${crumb.separatorCss}">
					<span>${page.content.nav.breadcrumb.seperator}</span>
				</li>
				</#sep>
			</#list>
		</ul>
	</div>
</#if>
			


<style>
#custom-overridden-breadcrumb-component .final-crumb,
#custom-overridden-breadcrumb-component .crumb-hidden,
#custom-overridden-breadcrumb-component .crumb-hidden + .lia-breadcrumb-seperator {
	display:none;
}
</style>
