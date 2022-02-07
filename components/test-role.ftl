<#assign userRole = ""/>
<#assign userRolesRequest = restadmin('users/id/${user.id?c}/roles') />
    <#if userRolesRequest.roles?? && userRolesRequest.roles?has_content >
        <#list userRolesRequest.roles.role as r >
            <#assign userRole = userRole+ r.name+":" />
        </#list>
        <#assign userRole = userRole?substring(0,userRole?length-1) />
    </#if>
${userRole}