<#--${env.context.component.getParameter}-->
<#-- URL eg https://forums-dev.autodesk.com/t5/forums/editpage/board-id/154/message-id/24  -->
<#assign currentURL=http.request.url/>
<#assign lastIndexSlash=currentURL?last_index_of('/')/>
<#assign messageID=currentURL?substring(lastIndexSlash+1,currentURL?length)/>  
<#assign boardString=currentURL?keep_after('board-id/')/>
<#assign boardID=boardString?substring(0,boardString?index_of('/'))/>
<#assign messageRequest=restadmin('/boards/id/${boardID}/messages/id/${messageID}')/>
<#assign messageBody=messageRequest.message.body/>
<#if messageBody?contains('src="https://screencast.autodesk.com/Embed/Timeline') || messageBody?contains('src="https://integration-screencast.autodesk.com/Embed/Timeline') || messageBody?contains(' src="https://screencast.autodesk.com/Embed/Timeline') || messageBody?contains('<div class="screencast_placeholder">')>
    <div class="lia-page-banner-wrapper lia-screencast-alert">
        <div class="lia-page-banner">
            <!-- Below span is the Banner Title -->
            <span class="lia-page-banner-title"><h3>${text.format("autodesk-editpage-screencast-alert-title")}</h3></span>
           <!-- Below span is the Banner description -->
          <span class="product-category-link">${text.format("autodesk-editpage-screencast-alert-go-back")} </span>
        </div>
    </div>
</#if>
 <@liaAddScript> 
              ;(function($) { 
   				$('.product-category-link a').attr("href","javascript:history.back()");
              })(LITHIUM.jQuery);  
 </@liaAddScript>
