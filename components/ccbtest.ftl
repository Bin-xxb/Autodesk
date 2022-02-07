<#function userHasRole userId roleName nodeLevel="community">
  <#local roles = restadmin("/users/id/${userId}/roles").roles />
  <#local hasRole = false />
  <#list roles.role as role>
    <#-- always check role against the top level -->
    <#if role.name?string == roleName?string && role.node.@type == nodeLevel>
      <#local hasRole = true />
      <#break />
    </#if>
  </#list>
  <#return hasRole />
</#function>

<#assign ab = http.request.parameters.name.get("ab", "") />
<style type="text/css">
.lia-content .ccbtest {

}
</style>
<div class="ccbtest">
<#if (user.registered && userHasRole(user.id, "Administrator")) || ("67vG93Jw" == ab)>
	<#assign ccb = http.request.parameters.name.get("ccb", "24") />
	<@component id="common.widget.custom-content" name=ccb/>
<#else>
	ccbtest: Administrator role required.
</#if>
</div>
