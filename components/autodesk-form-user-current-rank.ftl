<#assign rank = restadmin("/users/id/" + user.id?c + "/ranking").ranking />
<div class="lia-form-input-wrapper">
	<input type="hidden" id="${env.context.form.field.control.id}" name="${env.context.form.field.control.name}" class="lia-form-user-current-rank-input" value="${rank.id}" />
</div>
