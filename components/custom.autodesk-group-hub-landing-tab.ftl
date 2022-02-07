<#assign queryString = "SELECT id, title, view_href, membership_type, avatar FROM grouphubs ORDER BY title ASC limit 10000" />
<#assign groups = rest( "2.0", "/search?q=" + queryString?url).data.items![] />

<div class="lia-group-hubs-list">
<#if groups?size gt 0>
    <ul>
        <#list groups as gp>
            <li>
                <div class="lia-group-hubs-panel-list-item">
                    <#if gp.membership_type == "open">
                        <div class="lia-membership-type lia-membership-type-open"></div>
                    <#elseif gp.membership_type == "closed">
                        <div class="lia-membership-type lia-membership-type-closed">${text.format('memberships.membership_type.closed.title')}</div>
                    <#elseif gp.membership_type == "closed_hidden">
                        <div class="lia-membership-type lia-membership-type-closed-hidden">${text.format('memberships.membership_type.closed_hidden.title')}</div>
                    </#if>
                    <a href="${gp.view_href}" class="lia-node-avatar-wrapper">
                        <#if gp.avatar.tiny_href?? && gp.avatar.tiny_href?size gt 0>
                            <img class="lia-node-avatar" src="${gp.avatar.tiny_href}" alt="${gp.title}">
                        <#else>
                            <span class="lia-node-avatar lia-node-avatar-default"></span>
                        </#if>
                    </a>
                    <h4 class="lia-node-title">
                        <a class="lia-link-navigation" href="${gp.view_href}">${gp.title}</a>
                    </h4>
                </div>
            </li>
        </#list>
    </ul>
</#if>
</div>