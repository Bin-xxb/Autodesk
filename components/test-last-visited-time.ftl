<#assign query = "SELECT id, email, last_visit_time FROM users WHERE id = '${user.id}' LIMIT 1" />
<#assign user_items = restadmin("2.0", "/search?q=${query?url}").data.items![] />
<#assign item = user_items[0] />
${item.last_visit_time?long}