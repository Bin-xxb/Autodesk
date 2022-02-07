<#-- outdated component, do not use -->

<#assign user_lang = "en" />
<#if user.anonymous>
	<#assign param_lang = http.request.parameters.name.get("profile.language", "") />
	<#if param_lang == "" >
		<#assign anon_lang = http.request.cookies.name.get("lia.anon.profile.language") />
		<#if anon_lang?? && anon_lang.value??>
			<#assign user_lang = anon_lang.value />
		</#if>
	<#else>
		<#assign user_lang = param_lang />
	</#if>
	
<#else>
	<#assign user_lang = rest("/users/self/profiles/name/language").value />
</#if>

<#switch user_lang>
	<#case "de">
		<#break>
	<#case "fr">
		<#break>
	<#case "es">
		<#break>
	<#case "pt-br">
		<#break>
	<#case "ru">
		<#break>
	<#case "zh-CN">
		<#break>
	<#case "ja">
		<#break>
	<#case "tr">
		<#break>
	<#default>
		<#assign user_lang = "en" />
</#switch>

<#function getLangUrl url lang>
	<#local new_url = url?keep_before("?") />
	<#local query = url?keep_after("?") />
	<#local new_query = "" />
	<#list query?split("&") as kv>
		<#if kv != "" && kv != "profile.language" && kv?index_of("profile.language=") == -1>
			<#local new_query = new_query + "&" + kv />
		</#if>
	</#list>
	<#if new_query == "">
		<#local new_url = new_url + "?profile.language=" + lang />
	<#else>
		<#local new_query = new_query?remove_beginning("&") />
		<#local new_url = new_url + "?" + new_query + "&profile.language=" + lang />
	</#if>
	<#return new_url>
</#function>


<div class="custom-component-static-language-menu">

		<ul class="UserLanguage lia-list-standard-inline" title="${text.format('autodesk-static-language-dropdown-label.hover-tooltip')}">

				<li class="user-navigation-parent-dropdown">

						<span class="language-dropdown-logo language">
							<img src="https://knowledge.autodesk.com/sites/all/themes/autodesk_foundation5/images/standard/globe.png">
						</span>
						 
						<span class="language-dropdown-name pointable">	
							<span class="language-dropdown-first-name">${text.format("profile.language." + user_lang + ".title")}</span>
						</span>
						<div class="lia-menu-user-dropdown">
								<div class="user-navigation-language-drop-down">
										<div class="user-navigation-language-drop-down-inner">
												<div class="lia-list-standard lia-menu-user-nav">

														<div class="lia-quilt lia-quilt-user-slide-out-menu lia-quilt-layout-user-slide-out-menu">

																<div class="lia-quilt-column-alley lia-quilt-column-alley-single">
																	<div class="lia-list-standard menu-user-lang">
																		
																			<a href="${getLangUrl(http.request.url, 'de')}" class="lia-link-navigation">${text.format("profile.language.de.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'en')}" class="lia-link-navigation">${text.format("profile.language.en.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'es')}" class="lia-link-navigation">${text.format("profile.language.es.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'fr')}" class="lia-link-navigation">${text.format("profile.language.fr.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'ja')}" class="lia-link-navigation">${text.format("profile.language.ja.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'pt-br')}" class="lia-link-navigation">${text.format("profile.language.pt-br.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'tr')}" class="lia-link-navigation">${text.format("profile.language.tr.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'zh-CN')}" class="lia-link-navigation">${text.format("profile.language.zh-CN.title")}</a>
																			<a href="${getLangUrl(http.request.url, 'ru')}" class="lia-link-navigation">${text.format("profile.language.ru.title")}</a>
																				
																	</div>
																</div>

														</div>

												</div>
												<div class="user-navigation-arrow"></div>
										</div>
								</div>
						</div>
				</li>
		</ul>

</div>

<@liaAddScript>
;(function($) { 

	$(".custom-component-static-language-menu ul.UserLanguage").on("click", function(){
		$(".custom-component-static-language-menu .user-navigation-language-drop-down").toggle();
	});

})(LITHIUM.jQuery); 
</@liaAddScript>
