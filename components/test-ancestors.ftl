<#assign ancestors = coreNode.ancestors />

<#list ancestors as node>
${node.id} <br>
</#list>