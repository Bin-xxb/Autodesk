<!-- 
Display Links for -
1. All Forum boards
2. All Idea boards
3. Help
-->
<#assign ancestors = coreNode.ancestors />
<#assign coreId = coreNode.id />


<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>

<#assign base_url=coreNode.webUi.url?keep_before('/t5') />

<#if base_url?contains("dev")>
  <#assign get_started_url = "t5/community-announcements/welcome-to-the-community-start-here/m-p/44599?utm_source=forum-siderail&utm_medium=webpage&utm_campaign=getting-started" />
<#elseif base_url?contains("stg")>
  <#assign get_started_url = "t5/community-announcements/welcome-to-the-community-start-here/m-p/33972?utm_source=forum-siderail&utm_medium=webpage&utm_campaign=getting-started" />
<#else>
  <#assign get_started_url = "t5/forum-user-guides/welcome-to-the-community-start-here/td-p/9649716?utm_source=forum-siderail&utm_medium=webpage&utm_campaign=getting-started" />
</#if>


<#if coreId = "AutodeskUniversitySpeakers" >
    <div class="lia-quick-community-links lia-panel lia-panel-standard">
        <h4 class="title-bar" >${text.format('autodesk-speakerlinks-widget-title')?html}</h4>
        <ul>
            <li id="boards-link">
                <a  href="https://www.autodesk.com/autodesk-university/conference/speaker-materials">${text.format("autodesk-speakerlinks-widget-links-materials-page")?html}</a>
            </li>
            <li id="boards-link">
                <a  href="https://autodeskuniversity.smarteventscloud.com/content/">${text.format("autodesk-speakerlinks-widget-links-resource-center")?html}</a>
            </li>
            <li id="boards-link">
                <a  href="https://www.autodesk.com/autodesk-university/">${text.format("autodesk-speakerlinks-widget-links-university-website")?html}</a>
            </li>
            <li id="boards-link">
                <a  href="https://www.autodesk.com/autodesk-university/conference/overview">${text.format("autodesk-speakerlinks-widget-links-conference-site")?html}</a>
            </li> 
        </ul>
    </div>
<#else>
    <div class="lia-quick-community-links lia-panel lia-panel-standard">
        <h4 class="title-bar" >${text.format('autodesk-forumlinks-widget-title')?html}</h4>
        <ul>
            <li id="boards-link">
                <a  href="${text.format("autodesk-forumlinks-widget-links-all-forums-link")?html}">${text.format("autodesk-forumlinks-widget-links-all-forums")?html}</a>
            </li>
            <li id="boards-link">
                <a  href="${text.format("autodesk-forumlinks-widget-links-get-started-link")?html}">${text.format("autodesk-forumlinks-widget-links-get-started")?html}</a>
            </li>
            <li id="boards-link">
                <a  href="${text.format("autodesk-forumlinks-widget-links-support-link")?html}">${text.format("autodesk-forumlinks-widget-links-support")?html}</a>
            </li>
            <li id="boards-link">
                <a  href="${text.format("autodesk-forumlinks-widget-links-ava-link")?html}" target="_blank">${text.format("autodesk-forumlinks-widget-links-ava")?html}</a>
            </li>
            <#if ancestors?size gt 0>
                <li id="boards-link" class="boards-link-qna-only">
                <a  href="https://www.autodesk.com/products/autocad/overview" target=”_blank” >${text.format("product-qna-navigation",'${ancestors[0].title}')?html}</a>
            </li>
            </#if>
        </ul>
    </div>
</#if>

<#if debugEnabled>
  <#assign finish = .now?long />
  <#assign elapsed = finish - start />
  <script>console.log('autodesk-boards-ideas-help-quick-links: Time elapsed: ${elapsed}ms');</script>
</#if>