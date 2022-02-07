<#assign items = ['a', 'b'] />
<#assign newItems = items?map(item -> item) />
${newItems?size}