<#attempt>
<#assign user_id = page.context.user.id />
<#assign user_rank_resp=restadmin("/users/id/${user_id}/ranking")/>
<#assign imgURL = user_rank_resp.ranking.display.left_image.url/>
<#if imgURL?contains("/rank_icons/") >
<#assign imgURL=imgURL?replace(".png","_large.png")/>
</#if>

<#assign rank_name = user_rank_resp.ranking.name/>
<div class="user-rank-info">
	<img class="lia-user-rank-icon lia-user-rank-icon-left" title="Rank" alt="Rank"  src="${imgURL}">
	<div class="rank-info">
		<span class="UserRankName  lia-user-rank-label">${text.format("autodesk-userprofilepage-rank-label")}</span>
		<span class="UserRankName  lia-user-rank">${rank_name}</span>
	</div>
</div>
<#recover>
  <#-- ${.error} -->
    <span class="UserRankName  lia-user-rank-label"> No rank to display </span>
  </#attempt>