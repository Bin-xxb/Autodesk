<#-- outdated component, do not use -->

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
<#assign lang='' />
<#if user.anonymous==false>
        <#assign queryString="select language from users where id='${user.id}'" />
        <#assign lang=rest("2.0","/search?q="+queryString?url).data.items[0].language />
<#else>
        <#assign lang = http.request.parameters.name.get('profile.language', '') >
	    <#if lang == "">
            <#assign lang = http.request.cookies.name.get("lia.anon.profile.language").value!"" />
	    </#if>	
</#if>

<#if lang=="tr" || lang=="en">
    <#assign lang=''/>
</#if>

<#if lang=="zh-CN">
    <#assign lang="zh-hans"/>
</#if>

<#assign title="">
<#assign id="">
<#assign nodeType=""/>  
<#assign parentCategoryId=""/> 
<#assign parentCategoryTitle=""/> 
<#assign parentcategoryProductCode=""/> 
<#assign parentProductCategoryNodeType=""/> 
<#assign searchLocation = http.request.parameters.name.get('location', '') />
<#assign searchString = http.request.parameters.name.get('q', '') />
<#assign searchString = searchString?url />
<#assign productCode="">
<#if searchLocation!="">
    <#assign indexColon=searchLocation?index_of(':')/>
    <#assign locationID=searchLocation?substring(indexColon+1,searchLocation?length) />
    <#assign nodeType=searchLocation?substring(0,indexColon)/>
    <#if nodeType=="forum-board">
        <#assign productCode=restadmin('/boards/id/${locationID}/settings/name/autodesk.product_non_product').value />
        <#assign queryStringBoard="select title from boards where id='${locationID}'" />
        <#assign title=rest("2.0","/search?q="+queryStringBoard?url).data.items[0].title />
        <#assign title=title?lower_case />
        <#assign title=title?replace(" ","-") />
        <#assign id=locationID>
        <#assign title=title?replace("-forum","") />
        
            <!-- code only written as a backup , if the call for board fails then go for category--> 
            <#assign parentCategoryQuery="select root_category.id,root_category.title from boards where id='${locationID}'" />
            <#assign parentCategoryObject=rest("2.0","/search?q="+parentCategoryQuery?url).data.items />
             <#if parentCategoryObject[0].root_category?? >
                <#assign parentCategoryId=parentCategoryObject[0].root_category.id />
                <#assign parentCategoryTitle=parentCategoryObject[0].root_category.title />
                <#assign parentCategoryTitle=parentCategoryTitle?lower_case />
                <#assign parentCategoryTitle=parentCategoryTitle?replace(" ","-") />
                <#assign parentcategoryProductCode=restadmin('/categories/id/${parentCategoryId}/settings/name/autodesk.product_non_product').value /> 
                <#assign parentProductCategoryNodeType="category">  
            </#if>
    <#elseif nodeType=="category">
        <#assign productCode=restadmin('/categories/id/${locationID}/settings/name/autodesk.product_non_product').value />
        <#assign queryStringcategory="select title from categories where id='${locationID}'" />
        <#assign title=rest("2.0","/search?q="+queryStringcategory?url).data.items[0].title />
        <#assign title=title?lower_case />
        <#assign title=title?replace(" ","-") />
        <#assign id=locationID>
            
    </#if>
</#if>


    
<#assign messages_per_page_linear = settings.name.get("layout.messages_per_page_linear")?number />
<#assign
	panelTabs = [
				{
					"id"	   : "akn-search",
					"title"    : "${text.format('autodesk-searchPage-tab-panel-label.knowledge')}",
					"pageLabel": "AKN-search-page"
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
				<span><a class="lia-link-navigation tab-link lia-custom-event" tabindex="0" href="">${tab.title}</a></span>
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

<@liaAddScript>
;(function($) { 
	"use strict";
	
$(window).load(function(){
		console.log("in window.load");
    
		});
		

	var panelTabs = {
			$ulElement   : $("#lia-body .lia-content .custom-component-threads-tab-list .lia-tabs-standard"),
			onPageLoad	 : function(tab_id){
    //debugger;
    
								var that = this;
								//that.$tabPanel.find(".tab-content").addClass("lia-js-hidden");								
								//that.$tabPanel.find("#"+tab_id+"-tab-content").removeClass("lia-js-hidden");
								that.$ulElement.find(".lia-tabs").addClass("lia-tabs-inactive").removeClass("lia-tabs-active");
								that.$ulElement.find("#"+tab_id+"-tab").addClass("lia-tabs-active").removeClass("lia-tabs-inactive");
    var temp="https://forums${phase}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/autodesk-searchpage-akn-tabs-ep?id=${id}&title=${title}&language=${lang}&nodetype=${nodeType}";
                                if("${productCode}"!="" && "${productCode}"!="NP" ){
                                         $.ajax({
                                            url: "https://forums${phase}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/autodesk-searchpage-akn-tabs-ep?id=${id}&title=${title}&language=${lang}&nodetype=${nodeType}",
                                            contentType: "application/json",
                                            success: function(result) { 
                                                    //debugger;
                                                var temp=$.parseJSON(result); 
                                            if(temp.status=="not_found"){
                                                if("${parentcategoryProductCode}"!="" && "${parentcategoryProductCode}"!="NP"){
                                                $.ajax({
                                                                                            url: "https://forums${phase}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/autodesk-searchpage-akn-tabs-ep?id=${parentCategoryId}&title=${parentCategoryTitle}&language=${lang}&nodetype=${parentProductCategoryNodeType}",
                                                                                            contentType: "application/json",
                                                                                            success: function(result) { 
                                                                                                //debugger;
                                                                                            var temp1=$.parseJSON(result); 
                                                                                            if(temp1.status!="not_found"){
                                                                                                        console.log(temp1.listid);
                                                                                                        $('#akn-search-tab span a').attr('href',"https://knowledge${aknphase}.autodesk.com/${lang}/search?search=${searchString}&p="+temp1.listid+"&sort=score");
                                                                                                }else{
                                                                                                    $('#akn-search-tab span a').attr('href',"https://knowledge${aknphase}.autodesk.com/${lang}/search?search=${searchString}&sort=score");
                                                                                                }

                                                                                            },
                                                                                            error: function(res) {
                                                                                                    //debugger;
                                                                                                    }
                                                                                                    });
                                                        }
                                                    else{
                                                        $('#akn-search-tab span a').attr('href',"https://knowledge${aknphase}.autodesk.com/${lang}/search?search=${searchString}&sort=score");
                                                    }
                                                            
    
                                                }
                                            else{
                                                //debugger;
                                                console.log(temp.listid);
                                                if(temp.listid!="undefined"){
                                                    $('#akn-search-tab span a').attr('href',"https://knowledge${aknphase}.autodesk.com/${lang}/search?search=${searchString}&p="+temp.listid+"&sort=score");
                                                    }else{
                                                         $('#akn-search-tab span a').attr('href',"https://knowledge.autodesk${aknphase}.com/search?search=${searchString}&sort=score");
                                                    }
                                               
                                                }
                                            },
                                            error: function(res) {
    //debugger;
                                                }
                                        });
                                }else{
                                    $('#akn-search-tab span a').attr('href',"https://knowledge${aknphase}.autodesk.com/${lang}/search?search=${searchString}&sort=score");
                                }
    
							},
			tabClick	 : function(){
    //debugger;
    //debugger;
								var that = this;
								console.log("in tabClick function -- ");

						that.$ulElement.on("click","li",function(){
								var tab_des=$(this).attr('data-tab');
								var tab_selector=$(this).attr('id');
								console.log('tabClick event>>'+tab_selector+' is active ::'+$(this).hasClass('lia-tabs-active'));
								});
								
							},
			
	};
		
$(function(){
    //debugger;
panelTabs.tabClick();
var default_tab_id;
var tab_name;
	if( window.location.search && (window.location.search.indexOf('akn-search') > 0) ){
		tab_name  = window.location.search.substring(window.location.search.indexOf('akn-search=')).split('=')[0];
		default_tab_id = tab_name.slice(0,-5);
		console.log(default_tab_id);
	}
	else{
		default_tab_id = 'forums-search';
	}

		panelTabs.onPageLoad(default_tab_id);						
});

	

})(LITHIUM.jQuery); 
</@liaAddScript>