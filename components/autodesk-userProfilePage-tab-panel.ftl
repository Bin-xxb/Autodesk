<#if config.getString( "phase", "prod")=="prod">
    <#assign phase = ""/>
<#else>
    <#assign phase = "-staging"/>
</#if>
    
<#assign
    panelTabs = [
                {
                    "id"       : "akn-contribution",
                    "title"    : "${text.format('autodesk-userProfilePage-tab-panel-label.contribution')}",
                    "href"     : "https://knowledge${phase}.autodesk.com/profile"
                },
                {
                    "id"       : "forums-search",
                    "title"    : "${text.format('autodesk-tab-panel-label.forums')}",
                    "href"     : "/t5/user/viewprofilepage/user-id/${page.context.user.id?c}"
                },
                {
                    "id"       : "badges",
                    "title"    : "${text.format('general.Badges')}",
                    "href"     : "/t5/badges/userbadgespage/user-id/${page.context.user.id?c}"
                }
            ]
/>
<div class="lia-tabs-standard-wrapper custom-component-threads-tab-list lia-component-tabs" id="tabgroup">
    <ul class="lia-tabs-standard">
   
        <#list panelTabs as tab>
            <li class="lia-tabs lia-tabs-<#if (tab?index == 1 && page.name == "ViewProfilePage") || (tab?index == 2 && page.name == "UserBadgesPage")>active<#else>inactive</#if>" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">
                <span><a id="${tab.id}" class="lia-link-navigation tab-link lia-custom-event" tabindex="${tab?index}" href="${tab.href}">${tab.title}</a></span>
            </li>
        </#list>

        <!-- Please add the below li as it in the Tabs just before closing the ul tag - this is for mobile view -->
        <li class="lia-tabs lia-tabs-inactive lia-tab-overflow lia-js-hidden" style="">
            <div class="lia-menu-navigation-wrapper" id="dropdownmenu">
                <div class="lia-menu-navigation">
                    <div class="dropdown-default-item"><a title="${text.format('component.DropDownMenu.link.title')?html}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" id="dropDownLink" href="#"><span class="lia-fa lia-tab-overflow-icon"></span><span class="lia-fa lia-tab-overflow-icon"></span></a>
                        <div class="dropdown-positioning">
                            <div class="dropdown-positioning-static">
                                <ul id="dropdownmenuitems" class="lia-menu-dropdown-items"></ul><iframe class="lia-iframe-shim" src="javascript:void(0);" tabindex="-1" style="position: absolute; border: 0px; opacity: 0; top: 41.1562px; left: -111.141px; height: 178px; width: 160px; z-index: 940; display: none;"></iframe>
                                <iframe class="lia-iframe-shim" src="javascript:void(0);" tabindex="-1" style="position: absolute; border: 0px; opacity: 0; top: 41.1562px; left: -237.688px; height: 247px; width: 287px; z-index: 940; display: none;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </li>
    
    </ul>
</div>

<#assign user_sso_id = ""/>
<#assign user_id = page.context.user.id />

<#attempt>
    <#assign user_sso_id = restadmin("/users/id/${user_id}/sso_id").value />
<#recover>
</#attempt>


<#if user_sso_id != "">
<@liaAddScript>
;(function($) { 
    "use strict";
   
    $.ajax({
        url: "https://akn.unifiedprofile${phase}.autodesk.com/unifiedprofileservice/user/profile/v1/profiledata?userId=${user_sso_id}&source=Knowledge",
        contentType: "application/json",
        success: function(result) 
        { 
          var temp1=result; 
          if(temp1.userprofile[0].profileData.profileLink!="")
          {
              var profilelink=temp1.userprofile[0].profileData.profileLink;
              $('#akn-contribution').attr('href',profilelink);
          }
        },
        error: function(res) {
        }
    });

})(LITHIUM.jQuery); 
</@liaAddScript>
</#if>