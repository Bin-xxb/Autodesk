<#assign interaction_style = "" />
<#if page.interactionStyle??>
	<#assign interaction_style = page.interactionStyle />
</#if>
<#if interaction_style == "none" >
	<#assign interaction_style = http.request.parameters.name.get("interaction_style", "forum")?string />
</#if>
<#if interaction_style != "forum" && interaction_style != "idea">
	<#assign interaction_style = "forum" />
</#if>

<#assign CatId= http.request.parameters.name.get("catId","") />
<#assign post_flag=false>
<#assign user_post_count= restadmin("users/id/"+ user.id +"/topics/count").value?number/>

<#if user_post_count lte 5>
	<#assign catBoardMapping={
			 "59":60,
			 "5054":273,
			 "5056":328,
			 "511":514,
			 "157":2059,
			 "2062":139,
			 "531":514,
			 "156":296
			 }/>
	<#assign boardId= http.request.parameters.name.get("boardId","") />
	<#assign allCategoriesArrayInternational=coreNode.settings.name.get("autodesk.international_forums")?string/>
	<#assign allCategoriesArrayInternational=allCategoriesArrayInternational?split(',')/>
	<#assign flag=allCategoriesArrayInternational?seq_contains(CatId)/>
	<#assign forums_guidelines = text.format('autodesk-forums-submission-guidelines-heading')>
	<#assign ideas_guidelines = text.format('autodesk-ideas-submission-guidelines-heading')>
	<div class="lia-panel lia-panel-standard lia-submission-guidelines">
		<div class="lia-decoration-border">
		<div class="lia-decoration-border-top"></div>
			<div class="lia-decoration-border-content">
				<div>
					<div class="lia-panel-heading-bar-wrapper"><h3>
					<#if interaction_style == "idea">
						${ideas_guidelines}
					<#else>	
						${forums_guidelines}
					</#if>
					</h3></div>
					<div class="lia-panel-content-wrapper"><div class="lia-panel-content">	
							<#if interaction_style == "idea">
								${text.format('autodesk-ideas-submission-guidelines')}
							<#else>
								<#if allCategoriesArrayInternational?seq_contains(CatId)>
									<#if boardId=="60" || boardId=="273" || boardId=="393" || boardId=="514" || boardId=="2059" || boardId=="328" || boardId=="532" || boardId=="139">
										${text.format('autodesk-forums-submission-guidelines-installtion_licensing')}
									<#else>
										${text.format('autodesk-forums-submission-guidelines')}
									</#if>
								<#else>
									${text.format('autodesk-forums-submission-guidelines-not-under-international-category')}
								</#if>
							</#if>
					</div></div>
					
				</div>
			</div>
		<div class="lia-decoration-border-bottom"><div> </div></div>
		</div>
	</div>
	<#if flag?c=="true">
		<#assign url="/t5/forums/postpage/board-id/${catBoardMapping['${CatId}']}/choose-node/true/interaction-style/forum?catId=${CatId}"/>
	<@liaAddScript>
	;(function($) {
		
	   //debugger;
		var Elem=$('.link-installation-licensing a')[0];
		$(Elem).attr('href','${url}');
		})(LITHIUM.jQuery); 
	</@liaAddScript>
	</#if>
</#if>