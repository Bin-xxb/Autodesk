<#-- modified function to get active ares but with only forum -->    
<#function getUserActiveAreasList userId >
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
        </#if>
    </#if>
    <#return boardsArray />      
</#function>

<#function getUnansweredPosts>  
    <#assign boardsArray=getUserActiveAreasList(user.id) />
    <#assign count=0/>
    <#if boardsArray?size gt 0>
        <#list boardsArray as boardID>
            <#assign queryString = [
                                    '/boards',
                                    '/id',
                                    '/${boardID}'
                                    '/search/messages/',
                                    '?',
                                    'solved=false',
                                    '&',
                                    'sort_by=-topicPostDate',
                                    '&',
                                    'page_size=30',
                                    '&', 'page=1','&','restapi.format_detail=full_list_element','&','restapi.response_style=view'
                                    ]?join("") />
            <#if count==0>
                <#assign messages = rest(queryString).messages.message />
            <#else>
                <#assign messages = messages + rest(queryString).messages.message />
            </#if>
            <#assign count=count+1 />
        </#list>
    </#if>
    <#return messages>
</#function> 
        
        

        
<#-- function to get unanswered posts based on the logged in user , that too only threads -->       
        

    <#assign unansweredMessages=getUnansweredPosts() />
    <#assign filteredThreads=[]/>
    <#list unansweredMessages as message>
        <#if message.@href==message.root.@href>        
                <#assign filteredThreads= filteredThreads+[message]/>
        </#if>
    </#list>
    
    <#assign repliesBasedSortMessages=[]/>
    <#list filteredThreads as msg>
        <#assign boardId=msg.board.@href?substring(msg.board.@href?last_index_of('/')+1,msg.board.@href?length) />
        <#assign linearMessages=rest('/boards/id/${boardId}/threads/id/${msg.board_id}').thread.messages.linear.message/>
        size : ${linearMessages?size}<br>
        <#assign linearMessages=linearMessages?sort_by("id")?reverse />
        
        
        <#assign repliesBasedSortMessages=repliesBasedSortMessages+[{"id":"${msg.board_id}","post_time":"${linearMessages[0].post_time}","board":"${boardId}"}] />
    </#list>
    <#assign repliesBasedSortMessages=repliesBasedSortMessages?sort_by('post_time') />
    fort posttime size ${repliesBasedSortMessages?size}
    <#assign filteredThreadsUponPostTime=[]/>
    <#list repliesBasedSortMessages as rbsm>
        <#assign message=rest('/boards/id/${rbsm.board}/threads/id/${rbsm.id}').thread.messages.topic />
        <#assign filteredThreadsUponPostTime = filteredThreadsUponPostTime + [message] />
    </#list>
    
    ${filteredThreadsUponPostTime?size}
   
  
  
  
  
      