<#assign ancestor=coreNode.ancestors/>
<#if ancestor?size gte 2>
  <div class="product-category-navigation">
    <a href="${ancestor[ancestor?size-2].webUi.url}">${ancestor[ancestor?size-2].title}</a>
  </div>
</#if>
