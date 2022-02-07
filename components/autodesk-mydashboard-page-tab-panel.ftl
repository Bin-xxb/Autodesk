<#assign
                currentURL = coreNode.webUi.url
/>
<#if config.getString("phase", "dev") == "dev">
  <#assign envURL = "https://knowledge-int.autodesk.com" />
  <#assign forumUrl = "https://forums-dev.autodesk.com" />
<#elseif config.getString("phase", "stage") == "stage">
  <#assign envURL = "https://knowledge-staging.autodesk.com" />
  <#assign forumUrl = "https://forums-stg.autodesk.com" />
<#elseif config.getString("phase", "prod") == "prod">
    <#assign envURL = "https://knowledge.autodesk.com" />
                <#assign forumUrl = "https://forums.autodesk.com" />
</#if>
<#assign lang='en' />
<#if user.anonymous==false>
        <#assign queryString="select language from users where id='${user.id}'" />
        <#assign lang=rest("2.0","/search?q="+queryString?url).data.items[0].language />
</#if>
<#assign
                panelTabs = [
                                                                {
                                                                                "id"           : "my-contribution",
                                                                                "title"    : "${text.format('autodesk-mydashboard-page-tab-panel-label.contribution')}",
                                                                                "pageLabel": "all-posts-page",
                                                                                "url": "/profile/contributions#/dashboard"
                                                                },
                                                                {
                                                                                "id"           : "my-private-screencast",
                                                                                "title"    : "${text.format('autodesk-mydashboard-page-tab-panel-label.myprivatescreencast')}",
                                                                                "pageLabel": "faq-posts-page",
                                                                                "url": "/profile/contributions#/dashboard/private"
                                                                },

                                                                {
                                                                                "id"           : "screencast-shared-withme",
                                                                                "title"    : "${text.format('autodesk-mydashboard-page-tab-panel-label.screencastsharedwithme')}",
                                                                                "pageLabel": "solved-posts-page",
                                                                                "url": "/profile/contributions#/dashboard/shared"
                                                                },
                                                                {
                                                                                "id"           : "forum-dashboard",
                                                                                "title"    : "${text.format('autodesk-mydashboard-page-tab-panel-label-forums-dashboard')}",
                                                                                "pageLabel": "unanswered-posts-page",
                                                                                "url": "/t5/custom/page/page-id/mydashboard"
                                                                }                                                              

                                                ]
/>
<div class="lia-tabs-standard-wrapper custom-component-mydashborad-page-tab-list lia-component-tabs" id="tabgroup">
   <ul class="lia-tabs-standard">
                <#list panelTabs as tab>
                                <#if tab.id == "forum-dashboard" >
                                                <li class="lia-tabs lia-tabs-active" data-tab="${tab.id}-tab-content" id="forum-dashboard-tab">
                                                                <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="0" href="${forumUrl}${tab.url}">${tab.title}</a></span>
                                                </li>
                                <#else>
                                                <li class="lia-tabs lia-tabs-inactive" data-tab="${tab.id}-tab-content" id="${tab.id}-tab"> 
            <#if lang!="en">
                <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="0" href="${envURL}/${lang}${tab.url}">${tab.title}</a></span>
            <#else>
                <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="0" href="${envURL}${tab.url}">${tab.title}</a></span>
            </#if>
                                                </li>
                                </#if>
                </#list>
    <li class="lia-tabs lia-tabs-inactive lia-tab-overflow lia-js-hidden" style="">
                                                <div class="lia-menu-navigation-wrapper" id="dropdownmenu">
                                                                <div class="lia-menu-navigation">
                                                                                <div class="dropdown-default-item"><a title="${text.format('component.DropDownMenu.link.title')?html}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" id="dropDownLink" href="#"><span class="lia-fa lia-tab-overflow-icon"></span></a>
                                                                                                <div class="dropdown-positioning">
                                                                                                                <div class="dropdown-positioning-static">
                                                                                                                                <ul id="dropdownmenuitems" class="lia-menu-dropdown-items"></ul>
                                             <iframe class="lia-iframe-shim" src="javascript:void(0);" tabindex="-1" style="position: absolute; border: 0px; opacity: 0; top: 41.1562px; left: -237.688px; height: 247px; width: 287px; z-index: 940; display: none;"></iframe>
                                                                                                                </div>
                                                                                                </div>
                                                                                </div>
                                                                </div>
                                                </div>
                                </li>
   </ul>
</div>

<@liaAddScript>
(function($) { 
//debugger;
jQuery('.lia-quilt-column-main-content .lia-quilt-column-alley.lia-quilt-column-alley-left').each(function(){
jQuery(this).html(jQuery(this).html().replace(/&nbsp;/gi,''));
});
})(LITHIUM.jQuery); 
</@liaAddScript>  
  
