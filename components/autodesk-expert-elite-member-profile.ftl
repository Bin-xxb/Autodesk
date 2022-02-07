<#assign profile_lang = settings.name.get("profile.language", "") />
<#assign ee_lang = "" />
<#switch profile_lang>
	<#case "de">
		<#assign ee_lang = "/de" />
		<#break>
	<#case "es">
		<#assign ee_lang = "/es" />
		<#break>
	<#case "ja">
		<#assign ee_lang = "/ja" />
		<#break>
	<#default>
</#switch>

<#assign ee_phase = "" />

<#if config.getString( "phase", "prod") != "prod">
	<#assign ee_phase = "-stg" />
</#if>

<script>
	;function ee_iframe_resize(height) {
		var ee_iframe = document.getElementById('ee_iframe');
		ee_iframe.height = height + "px";
	}
</script>

<iframe id="ee_iframe" src="https://expertelite${ee_phase}.autodesk.com${ee_lang}/user" frameborder="0" width="100%" height="1000"></iframe>
