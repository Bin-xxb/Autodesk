<#-- 
	Expert Elite 
-->	

<#-- Expert Elite modal , the modal component is out of box -->	

<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>

<#-- # of users to display in the right rail -->
<#assign displayUserCount = 5 />

<#assign users_output_list = [] >
<#assign isModal = "">
<#attempt>
  <#assign isModal = env.context.component.getParameter("param")!"" />
<#recover>
  <#assign isModal = "" />
</#attempt>


<#-- checking if that category has expert elite role to any user -->
<#assign users_rank_position_list = [] />
<#assign role_exists = 0 /> 
<#assign corenodeID  = coreNode.id />
<#assign roles = restadmin("/categories/id/" + corenodeID +"/roles").roles.role />
<#list roles as role>
	<#assign roleName = "Expert Elite Highlight">
	<#if role.name == roleName>
		<#assign role_exists = 1 >
	</#if>
</#list>

<#if role_exists == 1>
	<#--  users fetched based on accepted solution but sorted based upon user name , ranks are decided by accepted sol so no need to sort based upon no of accepted solution -->
	<#assign qry = "SELECT id, login, rank.name, rank.position, rank.icon_left, rank.icon_right, avatar.profile, roles, solutions_authored.count(*) FROM users WHERE roles.id = 'c:${coreNode.id}:Expert Elite Highlight' LIMIT 1000" />	
	<#assign eliteUsers = (restadmin("2.0","/search?q=" + qry?url).data.items)![] />
	<#if (eliteUsers?size gt 0) >	
    <#assign componentParameters = modalsupport.component.parameters.add("autodesk-expert-elite", 10).build />
    <#assign modalOptions = modalsupport.options.setButtonType("secondary")
             .setTitle("Expert Elite").setSmall(false).setResizable(true)
             .setWidth(480).setMaxHeight(600).build />

    <@modal id="autodesk-expert-elite" label="autodesk.expert.elite" parameters=componentParameters options=modalOptions />
		<div class="lia-panel lia-panel-standard ExpertEliteTaplet Chrome lia-component-expert-elite-widget-taplet">
			<div class="lia-decoration-border"><div class="lia-decoration-border-top"><div> </div></div>
				<div class="lia-decoration-border-content">
					<div>
						<div class="lia-panel-heading-bar-wrapper">
							<div class="panel-heading-bar"><#if isModal == ""><h4>${text.format('autodesk-expert-elite-label')} </h4></#if></div>
						</div>
						<div class="lia-panel-content-wrapper">
							<div class="lia-panel-content">
								<div class="UserList lia-component-users-widget-user-list">
									<div class="t-data-grid">
										<table class="lia-list-slim">
											<tbody>
										<#-- sort by rank position -->
										<#list eliteUsers?sort_by(["rank", "position"]) as eliteUser>
											<#if eliteUser_index lt displayUserCount >
											  <tr class="lia-list-row lia-row-odd t-first lia-list-row-right-rail">
											<#else>  
												<tr class="lia-list-row lia-row-odd t-first lia-list-row-modal-popup">
											</#if>
													<td class="userColumn lia-data-cell-primary lia-data-cell-text">
														<div class="UserProfileSummary lia-user-item lia-js-data-userId-${eliteUser.id} lia-user-info-group">
															<div class="UserAvatar lia-user-avatar lia-component-common-widget-user-avatar">
				                        <#if eliteUser.login == "Anonymous">
				                          <img class="lia-user-avatar-message" title="adskadmin" alt="adskadmin" src="${eliteUser.avatar.profile}">
				                        <#else>
				                          <a class="UserAvatar lia-link-navigation" tabindex="-1" target="_self" href="${eliteUser.avatar.profile}"><img class="lia-user-avatar-message" title="adskadmin" alt="adskadmin" src="${eliteUser.avatar.profile}"></a>
				                        </#if>							
															</div>
															<div class="lia-user-attributes">
																<div class="lia-user-name">
																	<span class="UserName lia-user-name lia-user-rank-Advocate">
																		<#if (eliteUser.rank.icon_left)?has_content >
																			<img class="lia-user-rank-icon lia-user-rank-icon-left" title="Advocate" alt="Advocate" src="${eliteUser.rank.icon_left}">
																		</#if>
																		<span class="username_area"><a class="lia-link-navigation lia-page-link lia-user-name-link" style="" target="_self" href="/t5/user/viewprofilepage/user-id/${eliteUser.id}"><span class="">${eliteUser.login}</span></a></span>
																	</span>
																</div>
															</div>
														</div> 
													</td>
												</tr>
											</#list>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					<#if (eliteUsers?size gt displayUserCount) >	
						<div class="view-all-link">
							<h4><a class="lia-link-navigation" href="">${text.format('autodesk-expert-elite-view-all-label')}</a></h4>
						</div>
					</#if>
					<div class="lia-decoration-border-bottom"></div>
				</div>
			</div>	
		</div>
	</#if>
</#if>

<style>
	.ui-dialog-title {
		display:block;
	}
	.lia-component-common-widget-modal .lia-panel-dialog-trigger-event-click {
		display : none;
	}
	.lia-panel-dialog-content .ExpertEliteTaplet .view-all-link .lia-link-navigation {
		display:none;
	}
	.fa-question-circle:before {
		content: '\f059';
		font-family: fontawesome;
		height: 24px;
		width: 24px;
		display: inline-block;
	}
</style>

<@liaAddScript>
;(function($){
  $(function(){
		$('.lia-component-common-widget-modal .lia-panel-dialog-trigger-event-click').css('display','none');
		$('.ExpertEliteTaplet .view-all-link .lia-link-navigation').on('click',function(event) {
      $(".ui-dialog.ui-widget.ui-widget-content").css("top", "20px !important");
      $("html, body").animate({ scrollTop: 0 }, "slow");
		  event.preventDefault();
			$('.lia-component-common-widget-modal .lia-panel-dialog-trigger-event-click')[0].click();
		});
  });
})(LITHIUM.jQuery);
</@liaAddScript>

<#if debugEnabled>
	<#assign finish = .now?long />
	<#assign elapsed = finish - start />
	<script>console.log('autodesk-expert-elite: Time elapsed: ${elapsed}ms');</script>
</#if>