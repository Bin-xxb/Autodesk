<#assign roleString = "" />
<#list restadmin("/users/id/" + user.id?c + "/roles").roles.role as role>
	<#assign roleString = roleString + role.name?trim />
	<#if role_has_next>
		<#assign roleString = roleString + " " />
	</#if>
</#list>


<div class="lia-form-input-wrapper">
	<input type="hidden" id="${env.context.form.field.control.id}" name="${env.context.form.field.control.name}" class="lia-form-user-current-roles-input" value="${roleString}" />
</div>