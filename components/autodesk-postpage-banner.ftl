<#assign interaction_style = "" />
<#if page.interactionStyle??>
	<#assign interaction_style = page.interactionStyle />
</#if>
<#if interaction_style == "none" >
	<#assign interaction_style = http.request.parameters.name.get("interaction_style", "forum")?string />
</#if>
<#if interaction_style != "forum" && interaction_style != "idea" && interaction_style != "qanda" >
	<#assign interaction_style = "forum" />
</#if>


<#assign forums_title = text.format('autodesk-forums-postpage-banner-title')>
<#assign ideas_title = text.format('autodesk-ideas-postpage-banner-title')>
<#assign qanda_title = text.format('autodesk-qanda-postpage-banner-title')>
<div class="lia-page-banner-wrapper">
	<div class="lia-page-banner">
		<#if interaction_style == "idea">
			<span class="lia-page-banner-title"><h2>${ideas_title}</h2></span>
			<span class="lia-page-banner-description">${text.format('autodesk-ideas-postpage-banner-description')}</span>
		<#elseif interaction_style == "forum" >
			<span class="lia-page-banner-title"><h2>${forums_title}</h2></span>
			<span class="lia-page-banner-description">${text.format('autodesk-forums-postpage-banner-description')}</span>
        <#else>
            <span class="lia-page-banner-title"><h2>${qanda_title}</h2></span>
			<span class="lia-page-banner-description">${text.format('autodesk-qanda-postpage-banner-description')}</span>
		</#if>
	</div>
</div>