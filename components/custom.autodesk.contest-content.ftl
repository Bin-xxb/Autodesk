<#assign example = restadmin("/boards/id/${coreNode.id}/settings/name/contest.example")>
<#assign rules = restadmin("/boards/id/${coreNode.id}/settings/name/contest.rules")>

<span class="lia-content-status-message-example lia-contest-status-message lia-component-contest-example">
	${example.value}
</span>

<@component id="custom.autodesk.contest-start-end-date"/>
<@component id="custom.autodesk.contest-description"/>

<!-- <span class="lia-content-status-message-rules lia-contest-status-message lia-component-contest-rules">
	${rules.value}
</span>
-->