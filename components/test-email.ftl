<#assign user_email = "peter.lu@hinterlands.com.au" />
<#assign q = "(email:${user_email?url})" />
q=${q}&f=email&sort_by=-reg_date<br>
<#assign query ="q=${q}&f=email&sort_by=-reg_date" />
<#assign users = restadmin("/search/users?" + query).users.user />
<#list users as usr>
${user.id} <br>
</#list>