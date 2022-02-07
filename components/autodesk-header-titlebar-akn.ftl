<#if config.getString("phase", "") == "prod">
    <#assign aknUrl = "https://knowledge.autodesk.com/" />
<#else>
    <#assign aknUrl = "https://knowledge-staging.autodesk.com/" />
</#if>

<div class="custom-component-titlebar-akn">
    <a href="${aknUrl?html}" class="lia-link-navigation">${text.format('autodesk-header-akn-label')}</a>
</div>  