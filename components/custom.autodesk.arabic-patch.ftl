<#assign role_flag = true />
<#assign time_diff = 1615255169000 - .now?long />

<#if !user.anonymous && time_diff gt 0>

	<#assign userRolesRequest = restadmin('users/id/${user.id?c}/roles') />
    <#if userRolesRequest.roles?? && userRolesRequest.roles?has_content >
        <#list userRolesRequest.roles.role as role >
            <#if role.name == "Administrator" >
			    <#assign role_flag = false />
			</#if>
			<#if role.name == "Expert Elite" >
			    <#assign role_flag = false />
			</#if>
			<#if role.name == "Community Manager" >
			    <#assign role_flag = false />
			</#if>
        </#list>
    </#if>

	
</#if>