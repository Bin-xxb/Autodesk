<#assign userId='26'/>
<#assign boardsArray=[]/>
    <#assign boardsArray = usercache.get("TesttKeyForTabs", "") />
    	     
    <#if boardsArray=="">
        <#assign boardsArray=[]/>
    </#if>
    <#if !(boardsArray?has_content)> 
        <#if !user.anonymous>
            <#assign userRecentPostCount=rest('/users/id/${userId}/posts/recent/count').value/>
            <#if userRecentPostCount?number gt 0>
                <#assign boardsHashMap={}/>
                <#assign userPostsResponse=rest('/users/id/${userId}/posts/recent?page_size=1000&restapi.response_style=view')>
                <#list userPostsResponse.messages.message as message>
                    <#if message.board.@view_href?contains('bd-p')>
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
                    </#if>
                </#list>
                <#assign BoardPostValuesCountSorted=boardsHashMap?values?sort?reverse/>
                <#assign BoadrPostValuesSortedArrayOfChunks=BoardPostValuesCountSorted?chunk(10)/>
                <#assign firstFiveBoardPostValues=BoadrPostValuesSortedArrayOfChunks[0]/>

                
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
            </#if>
        </#if>
         <#assign boardsArrayTxt = usercache.put("TesttKeyForTabs", boardsArray) />
      
      
     ${boardsArray?size}
      
      
      
    </#if>