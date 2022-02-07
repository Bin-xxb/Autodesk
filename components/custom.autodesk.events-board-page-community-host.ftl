<#assign hostIds= settings.name.get("autodesk.event.hosts.user_ids") />
<#assign hostIdsArr=hostIds?split(",") >
<div class="events-board-community-hosts">
    <h4>${text.format('custom.autodesk-events-board-community-hosts.title')}</h4>
    ${coreNode.settings.name.get("customcontent.21_text")}
    <ul class="community-hosts-list">
        <#list hostIdsArr as item>
            <#assign queryString="SELECT login, view_href, avatar, rank.name, rank.icon_left FROM users WHERE id = '${item?trim}'" />
            <#assign hosts=restadmin( "2.0" , "/search?q=" + queryString?url).data.items![] />
            <#list hosts as host>
                <#if host?size gt 0>
                    <li>
                        <div class="lia-user-avatar">
                            <img class="community-hosts-avatar" src="${host.avatar.profile}" alt="${host.login}" />
                        </div>
                        
                        <div class="lia-user-attributes">
                            <div class="lia-user-name">
                                <span class="UserName lia-user-name lia-user-rank-attributes">
                                    <img class="lia-user-rank-icon lia-user-rank-icon-left" alt="${host.rank.name}" src="${host.rank.icon_left}">
                                    <a class="lia-link-navigation lia-page-link lia-user-name-link" target="_self" href="${host.view_href}">
                                        <span>${host.login}</span>
                                    </a>
                                    <div class="lia-user-rank">${host.rank.name}</div>
                                </span>
                            </div>
                        </div>
                    </li>
                </#if>
            </#list>
        </#list>
    </ul>
</div>