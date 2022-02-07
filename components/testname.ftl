<#assign first = restadmin("/users/id/13/profiles/name/name_first").value?string />
<#assign last = restadmin("/users/id/13/profiles/name/name_last").value?string />

first = ${first}  last = ${last}

<#assign env=http.request.serverName/>
${env}