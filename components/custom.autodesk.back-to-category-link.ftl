<#assign ancestors = coreNode.ancestors />

<#if ancestors?size gt 0>
    <#if ancestors[0].nodeType == 'grouphub'>
        <div class="lia-custom-component-back-to-category lia-node-grouphub">
            <a class="lia-link-navigation" href="${ancestors[0].webUi.url}">${text.format("product-grouphub-navigation",'${ancestors[0].title}')?html}</a>
        </div>
    <#else>
        <div class="lia-custom-component-back-to-category">
            <a class="lia-link-navigation" href="${ancestors[0].webUi.url}">${text.format("product-category-navigation",'${ancestors[0].title}')?html}</a>
        </div>
    </#if>
</#if>