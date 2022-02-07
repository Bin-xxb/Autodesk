<@delegate /> 
<#assign phase = config.getString("phase", "dev") />
<#if phase == "dev">
  <#assign akn_accounts_url = "https://accounts-staging.autodesk.com" />
<#elseif phase == "stage">
  <#assign akn_accounts_url = "https://accounts-staging.autodesk.com" />
<#elseif phase == "prod">
    <#assign akn_accounts_url = "https://accounts.autodesk.com" />
</#if>
<#assign security_setting_url =akn_accounts_url+"/Profile/Security%20?theme=light"/>

<@liaAddScript>
;(function($) { 
$(".lia-menu-user-dropdown .user-navigation-settings-drop-down-inner #userMySubscriptions, .user-navigation-settings-drop-down-inner #faqPage").hide(); 
$(".lia-menu-user-dropdown .user-navigation-settings-drop-down-inner .lia-component-users-action-view-user-profile-modern").after('<a class="lia-link-navigation view-dashboard-link lia-component-users-action-view-user-profile-modern" href="/t5/custom/page/page-id/mydashboard?forum-posts-page=1"> \
				${text.format('user.widget.menu-label.dashboard')} \
				</a>');
	
$(".lia-menu-user-dropdown .lia-quilt-row-profile-links .lia-quilt-column-profile-links>div").append('<div class="profile-links-group akn-actions-group"> \
	<span class="profile-links-group-title lia-link-navigation">${text.format('user.widget.menu-label.autodesk-account')}</span> \
	<a class="lia-link-navigation" href="https://manage.autodesk.com">${text.format('user.widget.menu-label.manage-products-and-downloads')}</a> \
	<a class="lia-link-navigation" href="${security_setting_url}" target="_blank">${text.format('autodesk.edit-account.title')}</a> \
	</div>');
$(".lia-menu-user-dropdown .lia-quilt-row-profile-links .lia-quilt-column-profile-links>div").append($(".lia-menu-user-dropdown .lia-quilt-row-profile-links .lia-component-users-action-logout").detach());				
$(".lia-menu-user-dropdown .lia-component-admin-action-switch-user, .lia-menu-user-dropdown .lia-component-admin-widget-new-admin-short, .lia-menu-user-dropdown .lia-component-admin-action-studio-admin").wrapAll("<div class='profile-links-group admin-actions-group'></div>");
$(".lia-menu-user-dropdown .profile-links-group.admin-actions-group").prepend("<span class='profile-links-group-title lia-link-navigation'>${text.format('user.widget.menu-label.forums-admin')}</span>");
$(".lia-menu-user-dropdown .lia-component-users-action-view-user-profile-modern, .lia-menu-user-dropdown .lia-component-users-action-my-profile-settings").wrapAll("<div class='profile-links-group user-actions-group'></div>");
$(".lia-menu-user-dropdown .profile-links-group.user-actions-group").prepend("<span class='profile-links-group-title lia-link-navigation'>${text.format('user.widget.menu-label.autodesk-knowledge-network')}</span>");


var skin_id= "${skin.id}";
if(skin_id=="autodesk_br_area"){
$(".lia-menu-user-dropdown .lia-quilt-row-profile-links .lia-quilt-column-profile-links>div").prepend('<div class="profile-links-group area-actions-group"> \
	<span class="area-links-group-title lia-link-navigation">${text.format('user.widget.menu-label.area-section')}</span> \
	<a class="lia-link-navigation" href="${text.format('user.widget.menu-label.area-tutorials.link')}">${text.format('user.widget.menu-label.area-tutorials')}</a> \
	<a class="lia-link-navigation" href="${text.format('user.widget.menu-label.area-tutorial-series.link')}">${text.format('user.widget.menu-label.area-tutorial-series')}</a> \
	<a class="lia-link-navigation" href="${text.format('user.widget.menu-label.area-resume.link')}">${text.format('user.widget.menu-label.area-resume')}</a> \
	<a class="lia-link-navigation" href="${text.format('user.widget.menu-label.area-account.link')}">${text.format('user.widget.menu-label.area-account')}</a> \
	</div>');	
}

})(LITHIUM.jQuery); 


</@liaAddScript>
