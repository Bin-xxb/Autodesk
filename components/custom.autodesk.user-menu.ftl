<#assign switch_user_mode = http.session.attributes.name.get("switch_user_mode", "")/>

<#if switch_user_mode?has_content>
	<@component id="users.widget.menu"/>
<#else>
	<@component id="custom.autodesk.me-menu"/>
</#if>
