<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>

<#assign interaction_style= http.request.parameters.name.get("interaction_style","forum") />
<#if interaction_style != "forum" && interaction_style != "idea">
	<#assign interaction_style = "forum"/>
</#if>
<#assign var=""/>
<#assign uri=""/>
<#assign desc="" />
<#assign has_forum=false />
<#assign has_idea=false />
<#if page.name=="PostPage">
    <#assign cat_id= http.request.parameters.name.get("catId","") />
    <#if cat_id!="">
        <#assign liql_conversastion_style="SELECT conversation_style from boards WHERE ancestor_categories.id='${cat_id}'" />
        <#assign response_conversation_style=restadmin("2.0","/search?q=" + liql_conversastion_style?url) />
        <#list response_conversation_style.data.items as boards >
            <#if boards.conversation_style=="idea">
                <#assign has_idea=true />
            <#elseif boards.conversation_style=="forum">
                <#assign has_forum=true />
            </#if>
        </#list>    
    </#if>
    <#if interaction_style=="">
        <#if page.interactionStyle=="forum" || page.interactionStyle=="group">
            <#assign var='autodesk-post-to-ideas-label-post' />
            <#assign uri="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&amp;catId=${cat_id}&amp;boardId="/>
          <#assign desc="autodesk-post-to-ideas-label-can't-find-text">
        <#elseif page.interactionStyle=="idea">
            <#assign var='autodesk-post-to-forums-label-post' />
            <#assign uri="/t5/forums/postpage/choose-node/true/interaction-style/forum?interaction_style=forum&amp;catId=${cat_id}&amp;boardId="/>
          <#assign desc="autodesk-post-to-forums-label-can't-find-text">
        </#if>
    <#elseif interaction_style=="forum" || page.interactionStyle=="group">
        <#assign var='autodesk-post-to-ideas-label-post' />
        <#assign uri="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&amp;catId=${cat_id}&amp;boardId="/>
      <#assign desc="autodesk-post-to-ideas-label-can't-find-text">
    <#elseif interaction_style=="idea">
        <#assign var='autodesk-post-to-forums-label-post' />
        <#assign uri="/t5/forums/postpage/choose-node/true/interaction-style/forum?interaction_style=forum&amp;catId=${cat_id}&amp;boardId="/>
      <#assign desc="autodesk-post-to-forums-label-can't-find-text">
    </#if>
    
<#else>
    <#if page.interactionStyle=="forum" || page.interactionStyle=="group">
        <#assign var='autodesk-post-to-forums-label-post' /> 
      <#assign desc="autodesk-post-to-forums-label-can't-find-text">
    <#elseif page.interactionStyle=="idea">
        <#assign var='autodesk-post-to-ideas-label-post' />
      <#assign desc="autodesk-post-to-ideas-label-can't-find-text">
    </#if>
</#if>


<#if (page.name=="PostPage" && interaction_style=="forum" && has_idea==false) || (page.name=="PostPage" &&interaction_style=="idea" && has_forum==false) >
    <#assign flag_new=true/>
    <#if interaction_style=="forum">
        <#if has_idea==false>
            
        <#elseif has_idea==true>
                <div class="lia-panel-post-to-forums">
                <div class="lia-panel-content-post-to-forums">
                    <div class="lia-panel-content-post-to-forums description">
                    <p>${text.format("${desc}")}</p>
                    </div>
                    <h4>
                        <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&catId=${cat_id}&boardId=">
                    ${text.format('${var}')}
                    &nbsp</a>
                    </h4>
                </div>
                </div>
        </#if>
    <#elseif interaction_style=="idea"> 
          <#if has_forum==false>
              
          <#elseif has_forum==true>
                    <div class="lia-panel-post-to-forums">
                    <div class="lia-panel-content-post-to-forums">
                    <div class="lia-panel-content-post-to-forums description">
                    <p>${text.format("${desc}")}</p>
                    </div>
                    <h4>
                    <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?interaction_style=forum&catId=${cat_id}&boardId=">
                    ${text.format('${var}')}
                    &nbsp</a>
                    </h4>
                    </div>
                    </div>
          </#if>
    </#if>
            
</#if>
          
<#if (page.name=="PostPage" && interaction_style=="forum" && has_idea==true) || (page.name=="PostPage" &&interaction_style=="idea" && has_forum==true) >
    <div class="lia-panel-post-to-forums">
        <div class="lia-panel-content-post-to-forums">
            <div class="lia-panel-content-post-to-forums description">
            <p>${text.format("${desc}")}</p>
            </div>
            <h4>
            <#if uri=="">
                <a class="lia-go-to-forums" href="/t5/forums/postpage/board-id/${coreNode.id}">
            ${text.format('${var}')}
            &nbsp</a>
            <#else>
            <a class="lia-go-to-forums" href="${uri}">
            ${text.format('${var}')}
            &nbsp</a>
            </#if>
            </h4>
        </div>
    </div>
<#elseif page.name=="ForumTopicPage">
    <div class="lia-panel-post-to-forums">
        <div class="lia-panel-content-post-to-forums">
            <div class="lia-panel-content-post-to-forums description">
            <p>${text.format("${desc}")}</p>
            </div>
            <h4>
                <#if coreNode.ancestors[0].id== community.id>
                     <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?interaction_style=forum&amp;catId=&amp;boardId=&preBoardId=${coreNode.id}">
            ${text.format('${var}')} &nbsp</a>     
                <#else>
                  <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?interaction_style=forum&amp;catId=${coreNode.ancestors[0].id}&amp;boardId=${coreNode.id}">
            ${text.format('${var}')} &nbsp</a>     
                </#if>
                
            </h4>
        </div>
    </div>
<#elseif page.name=="GroupMessagePage">
    <div class="lia-panel-post-to-forums">
        <div class="lia-panel-content-post-to-forums">
            <div class="lia-panel-content-post-to-forums description">
            <p>${text.format("${desc}")}</p>
            </div>
            <h4>
                <#if coreNode.ancestors[0].id== community.id>
                     <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?interaction_style=group&amp;catId=&amp;boardId=&preBoardId=${coreNode.id}">
            ${text.format('${var}')} &nbsp</a>     
                <#else>
                  <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/forum?interaction_style=group&amp;catId=${coreNode.ancestors[0].id}&amp;boardId=${coreNode.id}">
            ${text.format('${var}')} &nbsp</a>     
                </#if>  
            </h4>
        </div>
    </div>
<#elseif page.name=="IdeaPage">
    <div class="lia-panel-post-to-forums">
        <div class="lia-panel-content-post-to-forums">
            <div class="lia-panel-content-post-to-forums description">
            <p>${text.format("${desc}")}</p>
            </div>
            <h4>
                <#if coreNode.ancestors[0].id== community.id>
                     <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&amp;catId=&amp;boardId=&preBoardId=${coreNode.id}">
            ${text.format('${var}')} &nbsp</a>     
                <#else>
                  <a class="lia-go-to-forums" href="/t5/forums/postpage/choose-node/true/interaction-style/idea?interaction_style=idea&amp;catId=${coreNode.ancestors[0].id}&amp;boardId=${coreNode.id}">
            ${text.format('${var}')} &nbsp</a>     
                </#if>
                
            </h4>
        </div>
    </div>
</#if>
<style>
  a.lia-go-to-forums::after{
    content: '\f105';
    font-family: fontawesome;
    height: 24px;
    width: 24px;
    display: inline-block;
}
</style>

<#if debugEnabled>
    <#assign finish = .now?long />
    <#assign elapsed = finish - start />
    <script>console.log('autodesk-post-to-forums: Time elapsed: ${elapsed}ms');</script>
</#if>