<#if coreNode.permissions.hasPermission("allow_switch_users")>
<div class="lia-panel lia-panel-standard ActionLinksTaplet lia-component-cusotm-switch-user"><div class="lia-decoration-border"><div class="lia-decoration-border-top"><div> </div></div><div class="lia-decoration-border-content"><div><div class="lia-panel-heading-bar-wrapper"><div class="lia-panel-heading-bar"><span aria-level="4" role="heading" class="lia-panel-heading-bar-title">${text.format("general.switch_user")}</span></div></div><div class="lia-panel-content-wrapper"><div class="lia-panel-content"><div class="ActionLinksTaplet lia-nav-list">
	<ul role="list" class="lia-list-standard">
		<li><@component id="admin.action.switch-user" /></li>
	</ul>
</div></div></div></div></div><div class="lia-decoration-border-bottom"><div></div></div></div></div>
</#if>