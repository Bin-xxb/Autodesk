<#assign boardid=page.context.thread.board.id />
<#assign boardtitle=page.context.thread.board.title />
<#assign boardtitle=boardtitle?lower_case />
<#assign boardtitle=boardtitle?replace(" ","-") />
<#assign boardtitle=boardtitle?replace("-forum","") />
<#assign lang='en' />
<#assign environment="" />
<#if config.getString( "phase", "prod")=="dev">
    <#assign environment="-dev" />
<#elseif config.getString( "phase", "prod")=="stage">
    <#assign environment="-stg" />
</#if>
<#if user.anonymous==false>
        <#assign queryString="select language from users where id='${user.id}'" />
        <#assign lang=rest("2.0","/search?q="+queryString?url).data.items[0].language />
    </#if>
<#if page.interactionStyle=="forum">
    <div class="smp">
        
    </div>
</#if> 
<#assign service_provider_label=text.format('smp-service-providers-label-'+lang) />
<#assign service_provider_text_label=text.format('smp-service-providers-text-label-'+lang) />
<#assign SMPCallFlag="false" />
<#assign ancestorsLength=coreNode.ancestors?size />
<#if ancestorsLength==1>
    <#assign SMPCallFlag="true" />
<#else>
    <#assign parentCategoryID=coreNode.ancestors[ancestorsLength-2].id />
    <#assign parentCategoryProductCheckCall=restadmin('/categories/id/${parentCategoryID}/settings/name/autodesk.product_non_product')/>
    <#assign parentCategoryisProduct=parentCategoryProductCheckCall.value>
        <#if parentCategoryisProduct=="P" || parentCategoryisProduct=="p">
            <#assign SMPCallFlag="true" />
        </#if>
</#if>

<@liaAddScript>
;(function($){
    //debugger;
            if("${SMPCallFlag}"=="true"){
  var tt="https://forums${environment}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/smp-rightrail-ep?boardid=${boardid}&boardTitle=${boardtitle}&language=${lang}";
    //debugger;
            $.ajax({
                                            url: "https://forums${environment}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/smp-rightrail-ep?boardid=${boardid}&boardTitle=${boardtitle}&language=${lang}",
                                            contentType: "application/json",
                                            success: function(result) { 
                                                var temp=$.parseJSON(result); 
                                                //debugger;
                                                console.log("list-id:"+temp.listid);
												if(temp.status=="success" && temp.smp!=""){
                                                var DOMTemplate='<div class="lia-panel lia-panel-standard lia-component-community-widget-admin-links">'+
												'<div class="lia-decoration-border-content">'+
													'<span class="lia-panel-heading-bar-image">'+
														'<a class="lia-link-navigation smp-link" href="'+temp.smp+'">'+
																'<img src="/html/assets/ADK_SMP_Forum-Image.jpg" alt="SMP-right-rail-icon">'+
														'</a>'+
													'</span>'+
												'</div>';
                                                $('.smp').append(DOMTemplate);
                                                $('.smp .lia-link-navigation.smp-link').attr('href',temp.smp);
                                                }
                                            },
                                            error: function(res) {
                                                    }
                                        });
                    }
                                        
    
})(LITHIUM.jQuery);
</@liaAddScript>

    
        
