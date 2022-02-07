<#if env.context.message.uniqueId gt 0>
<#assign msgId = env.context.message.uniqueId />
<#assign screencast_id = restadmin('/messages/id/${msgId?c}/metadata/key/custom.screencast_url').value />

<#if screencast_id?? && screencast_id != "">
<div class="iframe-container">
	<iframe width="640" height="590" src="${screencast_id}"  frameborder="0" scrolling="no" allowfullscreen="allowfullscreen" webkitallowfullscreen="webkitallowfullscreen"></iframe>
</div>

</#if>
</#if>