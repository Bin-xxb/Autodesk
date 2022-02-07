<#--<#assign v = community.settings.name.get("autodesk.qualtrics-api-token", "") />-->

<#assign token = rest("/users/self/settings/name/profile.access_token").value />
${token}