<#assign interaction_style=http.request.parameters.name.get("interaction_style","") />
<#if interaction_style != "forum" && interaction_style != "idea">
	<#assign interaction_style = "forum"/>
</#if>


<div class="lia-page-banner-wrapper">
	<div class="lia-page-banner">
		<#if interaction_style == "forum" || interaction_style == "">
			<span class="lia-page-banner-title">
				<h1>${text.format('autodesk-landing-page-forums-ideas-banner-label.forum-banner-desc-title')}</h1>
			</span>
			<span class="lia-page-banner-description">
				${text.format('autodesk-landing-page-forums-ideas-banner-label.forum-banner-desc-p')}
			</span>
		<#elseif interaction_style=="idea">
			<span class="lia-page-banner-title">
				<h1>${text.format('autodesk-landing-page-forums-ideas-banner-label.idea-banner-desc-title')}</h1>
			</span>
			<span class="lia-page-banner-description">
				${text.format('autodesk-landing-page-forums-ideas-banner-label.idea-banner-desc-p')}
			</span>
		</#if>
		

		<div class="banner-group">
			<@component id="common.widget.search-bar" />
			<div class="lia-page-banner-links">
				<li class="li-links <#if interaction_style=="forum">li-active</#if>"><a href="?interaction_style=forum" data-wat-link="true" data-wat-loc="tab" data-wat-val="forums">${text.format('autodesk-landing-page-forums-label')}</a></li>|<li class="li-links <#if interaction_style=="idea">li-active</#if>"><a href="?interaction_style=idea" data-wat-link="true" data-wat-loc="tab" data-wat-val="ideas">${text.format('autodesk-landing-page-ideas-label')}</a></li>
		    </div> 
		</div>
		
	</div>
</div>