<#assign phase=""/>
<#assign aknphase=""/>
<#if config.getString( "phase", "prod")=="prod">
    <#assign phase=""/>
<#elseif config.getString( "phase", "prod")=="stage">
    <#assign phase="-stg"/>
    <#assign aknphase="-staging"/>
<#elseif config.getString( "phase", "prod")=="dev">
    <#assign phase="-dev"/>
    <#assign aknphase="-int"/>
</#if>  
<#assign lang='en' />
<#if user.anonymous==false>
        <#assign queryString="select language from users where id='${user.id}'" />
        <#assign lang=rest("2.0","/search?q="+queryString?url).data.items[0].language />
</#if>

<#if lang=="zh-CN">
<#assign lang="zh-hans"/>
</#if>
    
<#assign messages_per_page_linear = settings.name.get("layout.messages_per_page_linear")?number />
<#assign
	panelTabs = [
				{
					"id"	   : "akn-screencast-emails",
					"title"    : "${text.format('autodesk-MyProfilePage-tab-panel-label.screencast-emails')}",
					"pageLabel": "AKN-myprofile-page"
				},
				{
					"id"	   : "forums-search",
					"title"    : "${text.format('autodesk-tab-panel-label.forums')}",
					"pageLabel": "forums-search-page"
				}
			]
/>
<div class="lia-tabs-standard-wrapper custom-component-threads-tab-list lia-component-tabs" id="tabgroup">
   <ul class="lia-tabs-standard">
   
   	<#list panelTabs as tab>
		
		<#if tab.id == "forums-search" >
			<li class="lia-tabs lia-tabs-active" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">
				<span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="0" >${tab.title}</a></span>			
			</li>
		<#else>
			<li class="lia-tabs lia-tabs-inactive" data-tab="${tab.id}-tab-content" id="${tab.id}-tab">	
            <#if lang!="en">
                <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="0" href="https://knowledge${aknphase}.autodesk.com/${lang}/profile/preferences">${tab.title}</a></span>
            <#else>
                <span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="0" href="https://knowledge${aknphase}.autodesk.com/profile/preferences">${tab.title}</a></span>
            </#if>
				
			</li>
		</#if>
	</#list>
    
      <li class="lia-tabs lia-tabs-inactive lia-tab-overflow lia-js-hidden" style="">
         <div class="lia-menu-navigation-wrapper" id="dropdownmenu">
            <div class="lia-menu-navigation">
               <div class="dropdown-default-item">
                  <a title="${text.format('component.DropDownMenu.link.title')?html}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" id="dropDownLink" href="#"><span class="lia-fa lia-tab-overflow-icon"></span></a>
                  <div class="dropdown-positioning">
                     <div class="dropdown-positioning-static">
                        <ul id="dropdownmenuitems" class="lia-menu-dropdown-items"></ul>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </li>
   </ul>
</div>

  