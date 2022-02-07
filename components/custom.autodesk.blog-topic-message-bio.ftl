<#assign envURL=""/>
<#if config.getString("phase", "dev") == "dev">
  <#assign envURL = "-dev" />
<#elseif config.getString("phase", "stage") == "stage">
  <#assign envURL = "-stg" />
</#if>

<#assign threadId = page.context.thread.topicMessage.uniqueId />
<#assign query = "SELECT author FROM messages WHERE id = '${threadId}'"/>
<#assign author = restadmin("2.0","/search?q=" + query?url).data.items!0 />
<#if author?size gt 0 >
    <#assign aid = '${author[0].author.id}' />
    <#assign query_user = "SELECT first_name, last_name, view_href, biography, avatar.profile FROM users WHERE id = '${aid}'"/>
    <#assign author_info = restadmin("2.0","/search?q=" + query_user?url).data.items!0 />
    <#if author_info?size gt 0 >
        <div class="blog-message-bio">
            <div class="bio-left">
                <a class="UserAvatar" href="https://forums${envURL}.autodesk.com${author_info[0].view_href}">
                    <img src="${author_info[0].avatar.profile}">
                </a>
            </div>
            <div class="bio-right">
                <div class="UserName">
                    <a href="https://forums${envURL}.autodesk.com${author_info[0].view_href}">
                        ${author_info[0].first_name} ${author_info[0].last_name}
                    </a>
                </div>  
                <#if author_info[0].biography ?? >
                    <div class="biography">${author_info[0].biography}</div>
                </#if>
            </div>
        </div>
        
    </#if>
</#if>