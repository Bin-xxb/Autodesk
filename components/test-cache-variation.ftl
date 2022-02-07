<#assign pa = http.request.parameters.name.get("britta") />
${componentCacheSupport.setCacheVariation("bri", pa)}
${pa}
<@component id="test-timestamp"/>


