<#assign interaction_style=http.request.parameters.name.get("interaction_style","") />

<#if interaction_style != "forum" && interaction_style != "idea">
	<#assign interaction_style = "forum"/>
</#if> 

<#if interaction_style=="forum">
	<@component id="autodesk-community-metrics-forum" />
<#elseif interaction_style=="idea">
	<@component id="autodesk-community-metrics-idea" />
</#if>