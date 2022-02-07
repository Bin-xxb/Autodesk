<#assign new_url = http.request.url?keep_before("?") />
	<#assign query = http.request.url?keep_after("?") />
	<#assign new_query = "" />
	<#list query?split("&") as kv>
		<#if kv != "profile.language" && kv?index_of("profile.language=") == -1>
			<#assign new_query = new_query + "&" + kv />
		</#if>
	</#list>
	<#if new_query != "">
		<#assign new_query = new_query?remove_beginning("&") />
		<#assign new_url = new_url + "?" + new_query />
	</#if>

${new_url}
<br>
<#assign cookie = http.request.cookies.name.get("LithiumUserInfo").value />
<#assign lang = http.request.cookies.name.get("lia.anon.profile.language") />
${cookie}<br>
<#if lang?? && lang.value??>
${lang.value}
<#else>
empty lang
</#if>