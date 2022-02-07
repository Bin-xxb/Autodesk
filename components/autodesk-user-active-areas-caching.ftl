<@liaMarkupCache ttl="300000" variation="user_id" anonymousOnly="false"/>

<#if !user.anonymous>
    <#assign userRecentPostCount=rest('/users/id/${user.id}/posts/recent/count').value/>
    <#if userRecentPostCount?number gt 0>
        <#assign boardsHashMap={}/>
        <#assign userPostsResponse=rest('/users/id/${user.id}/posts/recent?page_size=1000')>
        <#list userPostsResponse.messages.message as message>
            <#assign boardHref=message.board.@href>
            <#assign boardId=boardHref?substring(boardHref?last_index_of('/')+1,boardHref?length)/>
            <#if boardsHashMap?keys?seq_contains('${boardId}')>   
                <#assign prevValue=boardsHashMap["${boardId}"]/>
                <#assign prevValue=prevValue+1 />
                <#assign BoardObjStr='{"'+boardId+'":'+prevValue+'}'/>
                <#assign modifiedBoardValue=BoardObjStr?eval/>
                <#assign boardsHashMap =boardsHashMap+modifiedBoardValue/>
            <#else>

                <#assign BoardObjStr='{"'+boardId+'":'+1+'}'/>

                <#assign modifiedBoardValue=BoardObjStr?eval/>
                <#assign boardsHashMap =boardsHashMap+modifiedBoardValue/>
            </#if>
        </#list>
        <#assign BoardPostValuesCountSorted=boardsHashMap?values?sort?reverse/>
        <#assign BoadrPostValuesSortedArrayOfChunks=BoardPostValuesCountSorted?chunk(7)/>
        <#assign firstFiveBoardPostValues=BoadrPostValuesSortedArrayOfChunks[0]/>
           
        <#assign boardsArray=[]/>
        <#assign boardsArrayCount=firstFiveBoardPostValues?size/>
        <#assign counter=0/>

        <#list firstFiveBoardPostValues as boardPostValues>   
        <#list boardsHashMap?keys as key>
          <#if counter lt boardsArrayCount>
            <#if boardsHashMap[key]==boardPostValues>
             <#if !boardsArray?seq_contains(key)>
               <#assign boardsArray=boardsArray+[key]/>
               <#assign counter=counter+1 />
             </#if>
            </#if>
          </#if>
        </#list>
        </#list>
        <div class="lia-panel lia-panel-standard custom-component-autodesk-user-active-areas">
        <div class="lia-decoration-border">
            <div class="lia-decoration-border-top">
                <div> </div>
            </div>
            <div class="lia-decoration-border-content">
                <div>
                    <div class="lia-panel-heading-bar-wrapper">
                        <div class="lia-panel-heading-bar"><span class="lia-panel-heading-bar-title">${text.format('taplet.forumsTaplets.topBoardsTaplet.title')}</span></div>
                    </div>
                    <div class="lia-panel-content-wrapper">
                        <div class="lia-panel-content">
                            <div id="userActiveBoardLinksTaplet" class="lia-nav-list">
                                <ul class="lia-list-standard">    
                                <#list boardsArray as board>
                                    <#assign boardDetails=rest('/boards/id/${board}?restapi.format_detail=full_list_element&restapi.response_style=view').board/>
                                        <li><a class="lia-link-navigation " href="${boardDetails.@view_href}" target="_blank">${boardDetails.title}</a></li>
                                </#list>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="lia-decoration-border-bottom">
                <div> </div>
            </div>
        </div>
    </div> 
    </#if>   
</#if>