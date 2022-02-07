<#assign ancestors = coreNode.ancestors/>
<#assign path_id = "" />
<#assign espanel_id = 157 />
<#assign deutsch_id = 59 />
<#assign portugues_id = 156 />
<#assign turkey_id = 2062 />
<#assign japaneses_id = 511 />
<#assign chinese_id = 531 />
<#assign french_id = 5054 />
<#assign russian_id = 5056 />


<#if ancestors?size gt 0>
	<#list ancestors as ac>
		<#assign path_id += "${ac.id}/" />
	</#list>
	<#assign path_arr = path_id?split("/") />
	
	<#attempt>
		<#if path_arr?seq_index_of("${espanel_id}") gt -1 || coreNode.id?number == espanel_id >
			<meta http-equiv="content-language" content="es">
			<script>
				document.documentElement.setAttribute('lang', "es");
			</script>
		<#elseif path_arr?seq_index_of("${deutsch_id}") gt -1 || coreNode.id?number == deutsch_id >
			<meta http-equiv="content-language" content="de">
			<script>
				document.documentElement.setAttribute('lang', "de");
			</script>
		<#elseif path_arr?seq_index_of("${portugues_id}") gt -1 || coreNode.id?number == portugues_id >
			<meta http-equiv="content-language" content="pt">
			<script>
				document.documentElement.setAttribute('lang', "pt");
			</script>
		<#elseif path_arr?seq_index_of("${turkey_id}") gt -1 || coreNode.id?number == turkey_id >
			<meta http-equiv="content-language" content="tr">
			<script>
				document.documentElement.setAttribute('lang', "tr");
			</script>
		<#elseif path_arr?seq_index_of("${japaneses_id}") gt -1 || coreNode.id?number == japaneses_id >
			<meta http-equiv="content-language" content="ja">
			<script>
				document.documentElement.setAttribute('lang', "ja");
			</script>
		<#elseif path_arr?seq_index_of("${chinese_id}") gt -1 || coreNode.id?number == chinese_id >
			<meta http-equiv="content-language" content="zh">
			<script>
				document.documentElement.setAttribute('lang', "zh");
			</script>
		<#elseif path_arr?seq_index_of("${french_id}") gt -1 || coreNode.id?number == french_id >
			<meta http-equiv="content-language" content="fr">
			<script>
				document.documentElement.setAttribute('lang', "fr");
			</script>
		<#elseif path_arr?seq_index_of("${russian_id}") gt -1 || coreNode.id?number == russian_id >
			<meta http-equiv="content-language" content="ru">
			<script>
				document.documentElement.setAttribute('lang', "ru");
			</script>
		</#if>
	<#recover>
	</#attempt>
	
</#if>


