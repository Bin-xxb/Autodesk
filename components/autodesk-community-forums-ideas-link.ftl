<#assign interaction_style = http.request.parameters.name.get("interaction_style","") />
<#if interaction_style != "forum" && interaction_style != "idea">
	<#assign interaction_style = "forum"/>
</#if> 

<div class="link-container">
	<li class="li-links <#if interaction_style=="forum">li-active</#if>"><a href="?interaction_style=forum">${text.format('autodesk-landing-page-forums-label')}</a></li>|<li class="li-links <#if interaction_style=="idea">li-active</#if>"><a href="?interaction_style=idea">${text.format('autodesk-landing-page-ideas-label')}</a></li>
</div>
<div class="banner-container">
	<div class="banner-image <#if interaction_style=="forum">active-link</#if>"><img src="${asset.get('/html/assets/Forums-Icon.png')}"  alt="Banner of Forum "></div>
	<div class="banner-image <#if interaction_style=="idea">active-link</#if>"><img src="${asset.get('/html/assets/Ideas-Icon.png')}"  alt="Banner of Ideas"></div>
</div>
