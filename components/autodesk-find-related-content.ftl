<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>

<!-- this will show related content from AKN -->

<#assign languageMap={
         "en":"ENU",
         "fr":"FRA",
         "de":"DEU",
         "tr":"TUR",
         "pt":"PTB",
         "ja":"JPN",
         "zh":"CHS",
         "ru":"RUS",
         "es":"ESP",
         "zh-CN":"CHS",
         "pt-br":"PTB"
         }/>
<#assign user_lang="en"/>
<#if user.anonymous ==false>
    <#assign user_lang_value=restadmin('/users/id/${user.id}/profiles/name/language').value/>
    <#assign user_lang=languageMap[user_lang_value] />
</#if>
<#assign cc9= coreNode.settings.name.get("customcontent.9_text")?string />
<#if cc9?trim != "">
<div class="lia-panel lia-panel-standard lia-component-custom-knowledge-network-widget hidden">
    <div class="lia-decoration-border">
        <div class="lia-decoration-border-top"></div>
        <div class="lia-decoration-border-content">
            <div>
                <div class="lia-panel-heading-bar-wrapper">
                    <div class="lia-panel-heading-bar">
                        <span class="lia-panel-heading-bar-title">${text.format("side-rail-related-content-title")}</span>
                    </div>
                </div>
                <div class="lia-panel-content-wrapper">
                    <div class="lia-panel-content">
                        <div class="StringDisplayTaplet">
                            <p>${text.format("side-rail-related-content-subtitle")}</p>
                        </div>
                        <div class="ActionLinksTaplet">
                            <ul class="lia-list-standard">
                            </ul>
                        </div>          
                    </div>
                </div>
            </div>
        </div>
        <div class="lia-decoration-border-bottom"> </div>
    </div>
</div>
<#assign boardid=page.context.thread.board.id />
<#assign boardtitle=page.context.thread.board.title />
<#assign boardtitle=boardtitle?lower_case />
<#assign boardtitle=boardtitle?replace(" ","-") />
<#assign boardtitle=boardtitle?replace("-forum","") />
<#assign lang='en'/>

<@liaAddScript>
;(function($){
    "use strict";
    
    //debugger;
    var webUrl=window.location.href;
    var index1=webUrl.lastIndexOf('/');
    var threadId=webUrl.substring(index1+1,webUrl.length);
    
    var AKN = {
                threadId    : "${page.context.thread.topicMessage.uniqueId}",
                productId   : "",
                $grid       : $(".lia-component-custom-knowledge-network-widget .lia-list-standard"),
                showAKN     : function(){
                                $("#lia-body .lia-content .lia-component-custom-knowledge-network-widget").removeClass("hidden");
                            },
                listTemplate: function(title,link,knowledge_source){
    return '<li><a href="' + link + '">' + title + '</a></li><span class="lia-related-content-source">'+knowledge_source+'</span>';
                                            
                            },
                getEnvPhaseBeehive : function(){
                                // Right now phase variable pointing to current stage envirnment 
                                var phase = "";
                                                            
                                <#if config.getString("phase","prod")?string == "dev">
                                    phase = "-dev";
                                <#elseif config.getString("phase","prod")?string == "stage">
                                    phase = "-stage";
                                </#if> 
                                    return phase;
                            },
                getEnvPhase : function(){
                                // Right now phase variable pointing to current stage envirnment 
                                var phase = "";
                                                            
                                <#if config.getString("phase","prod")?string == "dev">
                                    phase = "-dev";
                                <#elseif config.getString("phase","prod")?string == "stage">
                                    phase = "-stg";
                                </#if> 
                                    return phase;
                            },
                populateData: function(){
                //debugger
                                        var that = this;
                                        $.ajax({
                                            url: "https://forums"+that.getEnvPhase()+".autodesk.com/autodesk/plugins/custom/autodesk/autodesk/smp-rightrail-ep?boardid=${boardid}&boardTitle=${boardtitle}&language=${lang}",
                                            contentType: "application/json",
                                            success: function(result) {  
    //debugger;
                                                var temp=$.parseJSON(result); 
                                                if(temp.status=="success"){
    //debugger;
                                                    this.productId=temp.listid;
                                                    if(that.getEnvPhase()=="-stg"){
                                                        that.threadId="5920956";
                                                        that.productId="ACD";
                                                    }
                                                
                                                $.ajax({
                                                    url: "https://beehive"+that.getEnvPhaseBeehive()+".autodesk.com/community/service/rest/caas/resource/lithium",
                                                    data:{id:that.threadId,p:that.productId,l:'${user_lang}'},
                                                    contentType: "application/json",
                                                    success: function(result1) {  
                                                    //debugger;
                                                        if(typeof result1.mlts == "undefined"){
                                                        } else {
                                                            for (var i = 0 ;i < result1.mlts.mlt.length; i ++ ){
                                                                var $list = that.listTemplate(result1.mlts.mlt[i].title,result1.mlts.mlt[i].aknUrl,result1.mlts.mlt[i].knowledgeSource);
                                                                that.$grid.append($list);
                                                            }
                                                             that.showAKN();
                                                        }

                                                    },
                                                    error: function(res) {
                                                                                                       //debugger;
                                                    $('.lia-component-custom-knowledge-network-widget .lia-panel-content').append('<span>'+$(res)+'</span>');  
                                                            }
                                                });
    
                                                }
                                            },
                                            error: function(res) {
                                            $('.lia-component-custom-knowledge-network-widget .lia-panel-content').append('<span>'+$(res)+'</span>');  
                                                    }
                                        });
    }                                        
            };

    $(function(){
                                                                                             
        AKN.populateData();
    });
})(LITHIUM.jQuery);
</@liaAddScript>


</#if>

<#if debugEnabled>
    <#assign finish = .now?long />
    <#assign elapsed = finish - start />
    <script>console.log('autodesk-find-related-content: Time elapsed: ${elapsed}ms');</script>
</#if>