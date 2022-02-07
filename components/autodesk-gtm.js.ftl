<#assign pageTitle=""/>
<#assign userLanguage=""/>
<#assign loginStatus="No">
<#assign userRank=""/>
<#assign userRole=""/>
<#if !user.anonymous>
    <#assign userLanguage=restadmin("/users/id/${user.id?c}/profiles/name/language").value />
    <#assign loginStatus="Yes">
    <#assign userRank=restadmin('users/id/${user.id?c}/ranking').ranking.name />
    <#assign userRolesRequest=restadmin('users/id/${user.id?c}/roles') />
    <#if userRolesRequest.roles?? && userRolesRequest.roles?has_content>
        <#list userRolesRequest.roles.role as r>
            <#assign userRole=userRole+ r.name+":"/>
        </#list>
        <#assign userRole=userRole?substring(0,userRole?length-1)/>
    </#if>
</#if>
<#switch page.name>
    <#case "CommunityPage">
        <#assign interactionStyle=http.request.parameters.name.get("interaction_style", "forum") />
        <#if interactionStyle != "forum" && interactionStyle != "idea">
            <#assign interactionStyle = "forum"/>
        </#if>
        <#if interactionStyle=="forum">
            <#assign pageTitle="HomePage:Forums"/>
        <#elseif interactionStyle=="idea">
            <#assign pageTitle="HomePage:Ideas"/>
        </#if>
        <@liaAddScript>
            ;(function($){
            /* write js code*/
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
            $(window).on('load',function(){
            //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage': language,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            }); 
            })(LITHIUM.jQuery);
        </@liaAddScript>
     <#break>
    <#case "CategoryPage">
        <#assign categoryId=coreNode.id />
        <!-- interaction style is not a valid paramater on category so we will always pass forums -->
        <#assign categoryProductCheck=restadmin('/categories/id/${categoryId}/settings/name/autodesk.product_non_product').value/>
        <#assign categoryTitle=coreNode.title />
        <#if categoryProductCheck=="P" || categoryProductCheck=="p">
                <#assign pageTitle="Forums:Product:${categoryTitle}:BoardListing">
        <#elseif categoryProductCheck=="NP" || categoryProductCheck=="np">
                <#assign pageTitle="Forums:NonProduct:${categoryTitle}:BoardListing">
        </#if>
            
        <@liaAddScript>
            ;(function($){
            /* write js code*/
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
            $(window).on('load',function(){
            //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage': language,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': '',
                'category':'${categoryTitle?js_string}'
                });
            }); 
            })(LITHIUM.jQuery);
        </@liaAddScript>
        
     <#break>
    <#case "ForumPage">
        <#assign boardId=coreNode.id />
        <#assign boardProductCheck=restadmin('/boards/id/${boardId}/settings/name/autodesk.product_non_product').value/>
        <#assign boardTitle=coreNode.title />
        <#if coreNode.ancestors?size==1>
            <#assign productName=coreNode.title />
            <#assign categoryName=coreNode.title />
        <#elseif coreNode.ancestors?size==2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName=coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName=""/>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName=categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign interactionStyle=page.interactionStyle />
        <#assign faqTabSelected=http.request.parameters.name.get("faq-posts-page", "") />
        <#assign SolvedTabSelected=http.request.parameters.name.get("solved-posts-page", "") />
        <#assign unsolvedTabSelected=http.request.parameters.name.get("unanswered-posts-page", "") />

        <#if faqTabSelected != "">
            <#attempt>
                <#assign faqTabSelected = faqTabSelected?number?string />
            <#recover>
                <#assign faqTabSelected = "1" />
            </#attempt>
        </#if>
        <#if SolvedTabSelected != "">
            <#attempt>
                <#assign SolvedTabSelected = SolvedTabSelected?number?string />
            <#recover>
                <#assign SolvedTabSelected = "1" />
            </#attempt>
        </#if>
        <#if unsolvedTabSelected != "">
            <#attempt>
                <#assign unsolvedTabSelected = unsolvedTabSelected?number?string />
            <#recover>
                <#assign unsolvedTabSelected = "1" />
            </#attempt>
        </#if>



        <#assign pageNo = "1" />


            <#if boardProductCheck=="P" || boardProductCheck=="p">
                <#if faqTabSelected=="" && SolvedTabSelected=="" && unsolvedTabSelected=="">
                    <#assign pageNo = webuisupport.path.parameters.name.get("page", "1")?string />
                    <#if coreNode.ancestors?size==1 >
                        <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:All-Post">
                    <#else>
                        <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:All-Post">
                    </#if>
                    
                <#else>
                    <#if faqTabSelected!="">
                        <#assign pageNo=faqTabSelected />
                        <#if coreNode.ancestors?size==1 >
                            <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:FAQs">
                        <#else>
                            <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:FAQs">
                        </#if>  
                    <#elseif SolvedTabSelected!="">
                        <#assign pageNo=SolvedTabSelected />
                        <#if coreNode.ancestors?size==1 >
                            <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:AcceptedSolutions">
                        <#else>
                            <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:AcceptedSolutions">
                        </#if> 
                    <#elseif unsolvedTabSelected!="">
                        <#assign pageNo=unsolvedTabSelected />
                        <#if coreNode.ancestors?size==1 >
                            <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:Unresolved"/>
                        <#else>
                            <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:Unresolved"/>
                        </#if> 
                    </#if>
                </#if>
            <#elseif boardProductCheck=="NP" || boardProductCheck=="np">
                <#if faqTabSelected=="" && SolvedTabSelected=="" && unsolvedTabSelected=="">
                    <#assign pageNo = webuisupport.path.parameters.name.get("page", "1")?string />
                    <#if coreNode.ancestors?size==1 >
                        <#assign pageTitle="Forums:NonProduct:${boardTitle}:All-Post">
                    <#else>
                        <#assign pageTitle="Forums:NonProduct:${categoryName}:${boardTitle}:All-Post">
                    </#if>               
                <#else>
                    <#if faqTabSelected!="">
                        <#assign pageNo=faqTabSelected />
                        <#if coreNode.ancestors?size==1 >
                            <#assign pageTitle="Forums:NonProduct:${boardTitle}:FAQs">
                        <#else>
                            <#assign pageTitle="Forums:NonProduct:${categoryName}:${boardTitle}:FAQs">
                        </#if>                  
                    <#elseif SolvedTabSelected!="">
                        <#assign pageNo=SolvedTabSelected />
                        <#if coreNode.ancestors?size==1 >
                            <#assign pageTitle="Forums:NonProduct:${boardTitle}:AcceptedSolutions">
                        <#else>
                            <#assign pageTitle="Forums:NonProduct:${categoryName}:${boardTitle}:AcceptedSolutions">
                        </#if>                 
                    <#elseif unsolvedTabSelected!="">
                        <#assign pageNo=unsolvedTabSelected />
                        <#if coreNode.ancestors?size==1 >
                            <#assign pageTitle="Forums:NonProduct:${boardTitle}:Unresolved">
                        <#else>
                            <#assign pageTitle="Forums:NonProduct:${categoryName}:${boardTitle}:Unresolved">
                        </#if>      
                    </#if>
                </#if>
            </#if>

                        
            <@liaAddScript>
            ;(function($){
            /* write js code*/
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
            $(window).on('load',function(){
            //debugger;
                var xx='${pageNo?js_string}';
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage': language,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': '',
                'category':'${categoryName?js_string}',
                'board':'${boardTitle?js_string}',
                'pageNumber':'${pageNo?js_string}'
                });
            }); 
            })(LITHIUM.jQuery);
        </@liaAddScript>
     
     <#break>
    <#case "IdeaExchangePage">
        <#assign boardId=coreNode.id />
        <#assign boardProductCheck=restadmin('/boards/id/${boardId}/settings/name/autodesk.product_non_product').value/>
        <#assign boardTitle=coreNode.title />
        <#if coreNode.ancestors?size==1>
            <#assign productName=coreNode.title />
            <#assign categoryName=coreNode.title />
        <#elseif coreNode.ancestors?size==2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName=coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName="">
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName=categoryName+coreNode.ancestors[i].title+":" />
            </#list>
            <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign URL=http.request.url />
        <#assign tabString="/tab/" />
        <#assign indexOfTab=URL?index_of('/tab/') />
        <#assign indexStartTab=indexOfTab+tabString?length />
        <#assign pageString="/page/" />
        <#assign indexOfPage=URL?index_of('/page/') />
        <#assign pageNo="">
        <#assign selectedTab="HotIdeas">
        <#if indexOfPage!=-1 >
            <#if indexOfTab!=-1>
                <#assign selectedTab=URL?substring(indexStartTab,indexOfPage)/>
                <#assign startIndexPage=indexOfPage+pageString?length />
                <#assign pageNo=URL?substring(startIndexPage,URL?length) />
            <#else>
                <#assign selectedTab="popular"/>
                <#assign startIndexPage=indexOfPage+pageString?length />
                <#assign pageNo=URL?substring(startIndexPage,URL?length) />
            </#if>
        <#else>
             <#if indexOfTab!=-1>
                <#assign selectedTab=URL?substring(indexStartTab,URL?length)/>
                <#assign pageNo="1">
            <#else>
                <#assign selectedTab="popular"/>
                <#assign pageNo="1">
            </#if>
        </#if>
        <#if boardProductCheck=="P" || boardProductCheck=="p">
            <#if selectedTab=="most-kudoed">
                <#assign pageTitle="Ideas:Product:${productName}:${categoryName}:TopVoted">
            <#elseif selectedTab=="popular">
                <#assign pageTitle="Ideas:Product:${productName}:${categoryName}:HotIdeas">
            <#elseif selectedTab=="most-recent">
                <#assign pageTitle="Ideas:Product:${productName}:${categoryName}:LatestIdeas">
            </#if>
        <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck=="">    
            <#if selectedTab=="most-kudoed">
                <#assign pageTitle="Ideas:NonProduct:${categoryName}:TopVoted">
            <#elseif selectedTab=="popular">
                <#assign pageTitle="Ideas:NonProduct:${categoryName}:HotIdeas">
            <#elseif selectedTab=="most-recent">
                <#assign pageTitle="Ideas:NonProduct:${categoryName}:LatestIdeas">
            </#if>
        </#if>
                    
        <@liaAddScript>
            ;(function($){
            //debugger;
            /* write js code*/
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
            $(window).on('load',function(){
            //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage': language,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': '',
                'category':'${categoryName?js_string}',
                'board':'${boardTitle?js_string}',
                'pageNumber':'${pageNo?js_string}'
                });
            }); 
           
            $('.lia-link-navigation.kudos-link').on('click',function(e){
                //debugger;
                var tar=e.target;
                var msgDiv=$(tar).closest('.KudosButton.lia-button-image-kudos-wrapper');
                var threadID=$(msgDiv).attr('data-lia-kudos-id');
                var postType="First Post";
                
                var uniqueMsgDiv=$('.lia-js-data-messageUid-'+threadID);
                
                window.dataLayer.push({
                'event': 'likeOrVote',
                'postType': postType,
                'postOrIdea': 'Idea',
                'parentID': threadID
                });
            });
            
            $('.MessageKudosCount.lia-component-kudos-widget-message-kudos-count,.lia-button-image-kudos-label.lia-component-kudos-widget-kudos-count-label').on('click',function(e){
                //debugger;
                var tar=e.target;
                var msgDiv=$(tar).closest('.KudosButton.lia-button-image-kudos-wrapper');
                var threadID=$(msgDiv).attr('data-lia-kudos-id');
                var postType="First Post";
                
                var uniqueMsgDiv=$('.lia-js-data-messageUid-'+threadID);
                
                window.dataLayer.push({
                'event': 'seeWhoLiked',
                'postType': postType,
                'postOrIdea': 'Idea',
                'parentID': threadID
                });
            });
            })(LITHIUM.jQuery);
        </@liaAddScript>
     
     <#break>
    <#case "ForumTopicPage">
        
        <#assign postDateTime=page.context.message.postDate?datetime />
        <#assign postDateTimeUTC=postDateTime?iso_utc />
        <#assign pageURL=http.request.url />
        <#assign messageID = page.context.thread.topicMessage.uniqueId />
        <#assign queryStringSolution="SELECT conversation.solved FROM messages WHERE id='${messageID}'" />
        <#assign response=restadmin("2.0","/search?q=" + queryStringSolution?url) />
        <#assign isSolutionCheck=response.data.items[0].conversation.solved />
        <#if isSolutionCheck==true>
            <#assign isSolutionCheck="Yes" />
        <#else>
            <#assign isSolutionCheck="No" />
        </#if>
        <#assign boardId=coreNode.id />
        <#assign messageSubject=env.context.message.subject />
        <#assign indexOfColon=messageSubject?index_of(':') />
        <#assign messageSubject=messageSubject?substring(indexOfColon+1,messageSubject?length) />
        <#assign messageSubject=messageSubject?replace("'","&quote;") />
        <#assign boardProductCheck=restadmin('/boards/id/${boardId}/settings/name/autodesk.product_non_product').value/>
        <#assign boardTitle=coreNode.title />
        <#if coreNode.ancestors?size==1>
            <#assign productName=coreNode.title />
            <#assign categoryName=coreNode.title />
        <#elseif coreNode.ancestors?size==2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName=coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName="">
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName=categoryName+coreNode.ancestors[i].title+":" />
            </#list>
            <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
        </#if>
            
        <#assign URL=http.request.url />
        <#assign pageString="/page/" />
        <#assign indexOfPage=URL?index_of('/page/') />
        <#assign pageNo="">
        <#if indexOfPage!=-1>
            <#assign startIndexPage=indexOfPage+pageString?length />
            <#assign pageNo=URL?substring(startIndexPage,URL?length) />
        <#else>
            <#assign pageNo="1">
        </#if>
        <#if boardProductCheck=="P" || boardProductCheck=="p">
            <#if coreNode.ancestors?size==1>
                <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:${messageSubject}">
            <#else>
                <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:${messageSubject}">
            </#if>       
        <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck=="">
            <#if coreNode.ancestors?size==1>
                <#assign pageTitle="Forums:NonProduct:${boardTitle}:${messageSubject}">
            <#else>
                <#assign pageTitle="Forums:NonProduct:${categoryName}:${boardTitle}:${messageSubject}">
            </#if>       
        </#if> 
            
        <@liaAddScript>
            ;(function($){
            /* write js code*/
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
            $(window).on('load',function(){
            //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage': language,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'category':'${categoryName?js_string}',
                'board':'${boardTitle?js_string}',
                'dateOfFirstPost':'${postDateTimeUTC?js_string}',
                'acceptedSolution':'${isSolutionCheck?js_string}',
                'pageNumber':'${pageNo?js_string}',
                'parentID': '${messageID?js_string}',
                });
            });
            $('.lia-component-quick-reply .lia-button.lia-button-primary.lia-button-Submit-action').on('click',function(e){
            //debugger;
                var wrapDiv=$(this).closest('.lia-message-view-wrapper');
                var ReplyingToMsgId=wrapDiv.attr('data-lia-message-uid');
                var postType="Non First Post";
                if(ReplyingToMsgId=="${messageID?js_string}"){
                    postType="First Post";
                }
                var uniqueMsgDiv=$('.lia-js-data-messageUid-'+ReplyingToMsgId);
                var solutionDiv=$(uniqueMsgDiv).find('.lia-list-row-thread-solved.lia-accepted-solution');
                if(solutionDiv.length!=0){
                    postType="Accepted Solution";
                }
                window.dataLayer.push({
                        'event': 'reply',
                        'replyType': 'Quick Reply',
                        'postType': postType,
                        'parentID': '${messageID?js_string}',
                        'postOrIdea': 'Post',
                        'threadID':ReplyingToMsgId
                        });
            });
            $('.lia-component-accepted-solutions-button').on('click',function(e){
                //debugger;
                var dateCurrent=new Date();
                var isoTime=dateCurrent.toISOString();
                var immediateElement=$(this).find('.lia-button.lia-button-secondary');
                var hrefURL=immediateElement.attr('href');
                var msgString='/message-uid/';
                var indexEnd=hrefURL.indexOf('?');
                var indexStart=hrefURL.indexOf('/message-uid')+msgString.length;
                var msgID=hrefURL.substring(indexStart,indexEnd);
                window.dataLayer.push({
                    'event': 'accept',
                    'postType': 'Non First Post',
                    'parentID': '${messageID?js_string}',
                    'threadID': msgID,
                    'dateOfAcceptance': isoTime
                    });
                });
            $('.lia-button.lia-button-secondary.lia-rating-image.lia-rating-image-selected.lia-rating-image-active').on('click',function(e){
                    window.dataLayer.push({
                        'event': 'meToo',
                        'postOrIdea': 'Post',
                        'parentID': '${messageID?js_string}',
                        'threadID': '${messageID?js_string}',
                        });
            });
             $('.lia-link-navigation.kudos-link').on('click',function(e){
                //debugger;
                var tar=e.target;
                var yy=$(tar).hasClass('kudos-revoke-link');
                if($(tar).hasClass('kudos-revoke-link')==false){
                    var msgDiv=$(tar).closest('.KudosButton.lia-button-image-kudos-wrapper');
                    var threadID=$(msgDiv).attr('data-lia-kudos-id');
                    var postType="Non First Post";
                    if(threadID=="${messageID?js_string}"){
                        postType="First Post";
                    }
                    var uniqueMsgDiv=$('.lia-js-data-messageUid-'+threadID);
                    var solutionDiv=$(uniqueMsgDiv).find('.lia-list-row-thread-solved.lia-accepted-solution');
                    if(solutionDiv.length!=0){
                        postType="Accepted Solution";
                    }
                    window.dataLayer.push({
                    'event': 'likeOrVote',
                    'postType': postType,
                    'postOrIdea': 'Post',
                    'parentID': '${messageID?js_string}',
                    'threadID': threadID
                    });
                }
            });
            $('.lia-button-image-kudos-label.lia-component-kudos-widget-kudos-count-label').on('click',function(e){
                //debugger;
                var tar=e.target;
                var msgDiv=$(tar).closest('.KudosButton.lia-button-image-kudos-wrapper');
                var threadID=$(msgDiv).attr('data-lia-kudos-id');
                var postType="Non First Post";
                if(threadID=="${messageID?js_string}"){
                    postType="First Post";
                }
                var uniqueMsgDiv=$('.lia-js-data-messageUid-'+threadID);
                var solutionDiv=$(uniqueMsgDiv).find('.lia-list-row-thread-solved.lia-accepted-solution');
                if(solutionDiv.length!=0){
                    postType="Accepted Solution";
                }
                window.dataLayer.push({
                'event': 'seeWhoLiked',
                'postType': postType,
                'postOrIdea': 'Post',
                'parentID': '${messageID?js_string}',
                'threadID': threadID
                });
            });
            $('#btn-default-lang').on('click',function(e){
            //debugger;
                window.dataLayer.push({
                'event': 'translationWidget',
                'translationLanguage': 'eng-EN'
                });
            });
            
            $('.lang-translator-right #select-lang').on('change',function(e){
            //debugger;
                var selectedCountry = $(".lang-translator-right #select-lang"). val();
                window.dataLayer.push({
                'event': 'translationWidget',
                'translationLanguage': selectedCountry
                });
                });
            
            $('body').delegate( ".helpful-actions .helpful-radio", "click",function(e){
                //debugger;
                var spanAttr=$(this).attr('aria-labelledby');
                var lastIndexOfHyphen=spanAttr.lastIndexOf('-');
                var yesOrNo=spanAttr.substring(lastIndexOfHyphen+1,spanAttr.length);
                if(yesOrNo=="yes"){
                    $('.helpful-button').on('click',function(event){
                            window.dataLayer.push({
                            'event': 'helpfulness',
                            'helpful': yesOrNo,
                            'postOrIdea': 'Post',
                            'parentID': '${messageID?js_string}'
                            }); 
                        });   
                    }else{  
                        $('.helpful-button').on('click',function(){
                            var helpFulNoOptions="";
                            $('.helpful-feedback .helpful-radio').each(function(element){
                                //debugger;
                                if($(this).attr('aria-checked')=="true"){
                                    helpFulNoOptions=$(this).next().text();
                                    window.dataLayer.push({
                                    'event': 'helpfulnessOption',
                                    'helpful': yesOrNo,
                                    'postOrIdea': 'Post',
                                    'parentID': '${messageID?js_string}',
                                    'helpfulNoOptions':helpFulNoOptions
                                    }); 
                                }    
                                });
                            
                        }); 
                    }
                
            });
            
            jQuery('.EscalateNowForm .lia-button.lia-button-primary.lia-button-Submit-action').on('click',function(e){
            //debugger;
            var divAttrVal=jQuery(this).val();
            if(divAttrVal=="Need an Answer"){
            var closeWrapDiv=jQuery(this).closest('.lia-component-forums-widget-message-view-two');
            var threadID=jQuery(closeWrapDiv).attr('data-lia-message-uid');
                window.dataLayer.push({
                    'event': 'needAnAnswer',
                    'postOrIdea': 'Post',
                    'parentID': '${messageID?js_string}',
                    'threadID': threadID,
                    }); 
            }
            });
            })(LITHIUM.jQuery);
        </@liaAddScript>             
     <#break>
    <#case "IdeaPage">
        <#assign postDateTime=page.context.message.postDate?datetime />
        <#assign postDateTimeUTC=postDateTime?iso_utc />
        <#assign pageURL=http.request.url />
        <#assign indexOfSlash=pageURL?last_index_of('/')>
        <#assign messageID=pageURL?substring(indexOfSlash+1,pageURL?length) />
        <#assign messageSubject=page.context.thread.topicMessage.subject />
        <#assign indexOfColon=messageSubject?index_of(':') />
        <#assign messageSubject=messageSubject?substring(indexOfColon+1,messageSubject?length) />
         <#assign messageSubject=messageSubject?replace("'","&quote;") />
        <#assign boardId=coreNode.id />
        <#assign boardProductCheck=restadmin('/boards/id/${boardId}/settings/name/autodesk.product_non_product').value/>
        <#assign boardTitle=coreNode.title />
        <#if coreNode.ancestors?size==1>
            <#assign productName=coreNode.title />
            <#assign categoryName=coreNode.title />
        <#elseif coreNode.ancestors?size==2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName=coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName="">
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName=categoryName+coreNode.ancestors[i].title+":" />
            </#list>
            <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
        </#if>
            
        <#assign URL=http.request.url />
        <#assign pageString="/page/" />
        <#assign indexOfPage=URL?index_of('/page/') />
        <#assign pageNo="">
        <#if indexOfPage!=-1>
            <#assign startIndexPage=indexOfPage+pageString?length />
            <#assign pageNo=URL?substring(startIndexPage,URL?length) />
        <#else>
            <#assign pageNo="1">
        </#if>
        <#if boardProductCheck=="P" || boardProductCheck=="p">
            <#if coreNode.ancestors?size==1>
                <#assign pageTitle="Ideas:Product:${productName}:${boardTitle}:${messageSubject}">
            <#else>
                <#assign pageTitle="Ideas:Product:${productName}:${categoryName}:${boardTitle}:${messageSubject}">
            </#if>      
        <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck=="">
            <#if coreNode.ancestors?size==1>
                <#assign pageTitle="Ideas:NonProduct:${boardTitle}:${messageSubject}">
            <#else>
                <#assign pageTitle="Ideas:NonProduct:${categoryName}:${boardTitle}:${messageSubject}">
            </#if>    
        </#if>
            <@liaAddScript>
            ;(function($){
            /* write js code*/
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                $(window).on('load',function(){
                //debugger;
                    window.dataLayer.push({
                    'pageTitle': '${pageTitle?js_string}',
                    'userSetLanguage': language,
                    'rank': '${userRank?js_string}',
                    'role': '${userRole?js_string}',
                    'loginStatus': '${loginStatus?js_string}',
                    'analyticsID': '',
                    'category':'${categoryName?js_string}',
                    'board':'${boardTitle?js_string}',
                    'dateOfFirstPost':'${postDateTimeUTC?js_string}',
                    'pageNumber':'${pageNo?js_string}',
                    'parentID': '${messageID?js_string}',
                    });
                });

                $('.lia-link-navigation.kudos-link').on('click',function(e){
                    //debugger;
                    var tar=e.target;
                    var msgDiv=$(tar).closest('.KudosButton.lia-button-image-kudos-wrapper');
                    var threadID=$(msgDiv).attr('data-lia-kudos-id');
                    var postType="Non First Post";
                    if(threadID=="${messageID?js_string}"){
                        postType="First Post";
                    }

                    var uniqueMsgDiv=$('.lia-js-data-messageUid-'+threadID);

                    window.dataLayer.push({
                    'event': 'likeOrVote',
                    'postType': postType,
                    'postOrIdea': 'Idea',
                    'parentID': threadID
                    });
                });

                $('.MessageKudosCount.lia-component-kudos-widget-message-kudos-count,.lia-button-image-kudos-label.lia-component-kudos-widget-kudos-count-label').on('click',function(e){
                    //debugger;
                    var tar=e.target;
                    var msgDiv=$(tar).closest('.KudosButton.lia-button-image-kudos-wrapper');
                    var threadID=$(msgDiv).attr('data-lia-kudos-id');
                    var postType="Non First Post";
                    if(threadID=="${messageID}"){
                        postType="First Post";
                    }

                    var uniqueMsgDiv=$('.lia-js-data-messageUid-'+threadID);

                    window.dataLayer.push({
                    'event': 'seeWhoLiked',
                    'postType': postType,
                    'postOrIdea': 'Idea',
                    'parentID': threadID
                    });
                });
                
                $('#btn-default-lang').on('click',function(e){
                //debugger;
                    window.dataLayer.push({
                    'event': 'translationWidget',
                    'translationLanguage': 'eng-EN'
                    });
                });
            
                $('.lang-translator-right #select-lang').on('change',function(e){
                //debugger;
                    var selectedCountry = $(".lang-translator-right #select-lang"). val();
                    window.dataLayer.push({
                    'event': 'translationWidget',
                    'translationLanguage': selectedCountry
                    });
                });
                
                $('.lia-quilt-column.lia-quilt-column-16.lia-quilt-column-right .lia-form-submit.lia-button-group .lia-button.lia-button-primary.lia-button-Submit-action').on('click',function(e){
                window.dataLayer.push({
                    'event': 'reply',
                    'replyType': 'Comment',
                    'postType': 'Non First Post',
                    'parentID': '${messageID?js_string}',
                    'postOrIdea': 'Idea',
                    'threadID':'${messageID?js_string}'
                    });
                });
                $('body').delegate( ".helpful-actions .helpful-radio", "click",function(e){
                //debugger;
                var spanAttr=$(this).attr('aria-labelledby');
                var lastIndexOfHyphen=spanAttr.lastIndexOf('-');
                var yesOrNo=spanAttr.substring(lastIndexOfHyphen+1,spanAttr.length);
                if(yesOrNo=="yes"){
                    $('.helpful-button').on('click',function(event){
                            window.dataLayer.push({
                            'event': 'helpfulness',
                            'helpful': yesOrNo,
                            'postOrIdea': 'Post',
                            'parentID': '${messageID?js_string}'
                            }); 
                        });   
                    }else{  
                        $('.helpful-button').on('click',function(){
                            var helpFulNoOptions="";
                            $('.helpful-feedback .helpful-radio').each(function(element){
                                //debugger;
                                if($(this).attr('aria-checked')=="true"){
                                    helpFulNoOptions=$(this).next().text();
                                    window.dataLayer.push({
                                    'event': 'helpfulnessOption',
                                    'helpful': yesOrNo,
                                    'postOrIdea': 'Post',
                                    'parentID': '${messageID?js_string}',
                                    'helpfulNoOptions':helpFulNoOptions
                                    }); 
                                }    
                                });
                            
                        }); 
                    }
                
            });
            })(LITHIUM.jQuery);
        </@liaAddScript>
     
     <#break>
        <#case "PostPage">
            <#assign interaction_style=""/>
            <#assign postType="postOrIdeaSubmit" /> 
            
            <#assign categoryID=""/>
            <#assign boardID=""/>
            
            <#assign postOrIdea="" />
            <#assign categoryID=http.request.parameters.name.get("catId","")>
            <#assign boardID=webuisupport.path.rawParameters.name.get("board-id", "")>
            <#assign preBoardID=http.request.parameters.name.get("preBoardId","")>
            <#if (categoryID!="" && boardID!="") ||  preBoardID!="" >
                <#if coreNode.ancestors?size gt 1>
                    <#assign interaction_style=page.interactionStyle/>
                    <#assign categoryID=coreNode.ancestors[0].id />
                    <#assign boardID=coreNode.id />
                    <#assign boardTitle=coreNode.title />
                <#else>
                    <#assign interaction_style=http.request.parameters.name.get("interaction_style","forum") />
                    <#if interaction_style != "forum" && interaction_style != "idea">
                        <#assign interaction_style = "forum"/>
                    </#if>
                    <#if boardID="">
                        <#assign boardID=preBoardID />
                        <#assign categoryName=""/>
                        <#assign boardTitle=restadmin('/boards/id/${boardID}/title').value />
                    </#if>  
                </#if>    
                <#assign boardProductCheck=restadmin('/boards/id/${boardID}/settings/name/autodesk.product_non_product').value/>
                
                <#if coreNode.ancestors?size==0>
                    <#if preBoardID=="">
                        <#if categoryID!="">
                            <#assign categoryName=restadmin('/categories/id/${categoryID}/title').value />
                            <#assign productName=categoryName />
                            <#assign boardTitle=restadmin('/boards/id/${boardID}/title').value />
                        </#if>
                    </#if>
                <#elseif coreNode.ancestors?size==1>
                    <#assign productName=coreNode.title />
                    <#assign categoryName="" />
                <#elseif coreNode.ancestors?size==2>
                    <#assign productName=coreNode.ancestors[0].title />
                    <#assign categoryName=coreNode.ancestors[0].title />
                <#elseif coreNode.ancestors?size gt 2>
                    <#assign productName=coreNode.ancestors[0].title />
                    <#assign categoryName="">
                    <#list 0..coreNode.ancestors?size-1 as i>
                        <#assign categoryName=categoryName+coreNode.ancestors[i].title+":" />
                    </#list>
                    <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
                </#if>
            
                <#if boardProductCheck=="P" || boardProductCheck=="p">
                    <#if interaction_style=="forum">
                        <#assign postOrIdea="Post" />
                        <#if categoryName=="">
                            <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:PostForumForm">
                        <#else>
                            <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:PostForumForm">
                        </#if>
                        
                    <#elseif interaction_style=="idea">
                        <#assign postOrIdea="Idea" />
                        <#if categoryName=="">
                            <#assign pageTitle="Ideas:Product:${productName}:${boardTitle}:PostIdeaForm">
                        <#else>
                            <#assign pageTitle="Ideas:Product:${productName}:${categoryName}:${boardTitle}:PostIdeaForm">
                        </#if>
                        
                    </#if>
                <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck==""> 
                    <#if interaction_style=="forum">
                        <#assign postOrIdea="Post" />
                        <#if categoryName=="">
                            <#assign pageTitle="Forums:NonProduct:${boardTitle}:PostForumForm">
                        <#else>
                            <#assign pageTitle="Forums:NonProduct:${categoryName}:${boardTitle}:PostForumForm">
                        </#if>
                        
                    <#elseif interaction_style=="idea">
                        <#assign postOrIdea="Idea" />
                        <#if categoryName=="">
                            <#assign pageTitle="Ideas:NonProduct:${boardTitle}:PostIdeaForm">
                        <#else>
                            <#assign pageTitle="Ideas:NonProduct:${categoryName}:${boardTitle}:PostIdeaForm">
                        </#if>
                        
                    </#if>
                </#if>  

                    <@liaAddScript>
                    ;(function($){
                    /* write js code*/

                    var language="${userLanguage?js_string}";
                    if("${loginStatus?js_string}"=="Offline"){
                        language=document.documentElement.lang;
                        }

                    $(window).on('load',function(){
                        //debugger;
                        window.dataLayer.push({
                        'pageTitle': '${pageTitle?js_string}',
                        'userSetLanguage':language ,
                        'rank': '${userRank?js_string}',
                        'role': '${userRole?js_string}',
                        'loginStatus': '${loginStatus?js_string}',
                        'analyticsID': '',
                        'category':'${categoryName?js_string}',
                        'board':'${boardTitle?js_string}',
                        });
                    }); 
                    $('.lia-button.lia-button-primary.lia-button-Submit-action').on('click',function(){
                        //debugger;
                        var current_date = new Date();
                        var date_utc = current_date.toISOString();

                        var tagsInputValue=$('.lia-form-tags-input.lia-form-type-text.lia-form-input-vertical').val();
                        var tags='No';
                        var attachmentValue=$('.lia-form-type-file').val();
                        var attachment='No';
                        var screencastCheck=$('.iframe-container iframe').length;
                        var screencast='No';
                        if(screencastCheck>0)
                        {
                            screencast='Yes';
                        }
                        if(tagsInputValue!="")
                        {
                            tags='Yes';
                        }
                        if(attachmentValue!="")
                        {
                            attachment='Yes';
                        }

                        window.dataLayer.push({
                        'event': '${postType?js_string}',
                        'postOrIdea': '${postOrIdea?js_string}',
                        'dateOfFirstPost': date_utc,
                        'screencast': screencast,
                        'attachment': attachment,
                        'tag': tags
                        });
                        });
                    })(LITHIUM.jQuery);
                </@liaAddScript>  
            <#else>
                <#if categoryID!="">
                    <#assign categoryName=restadmin('/categories/id/${categoryID}/title').value />
                    <#assign interaction_style=http.request.parameters.name.get("interaction_style","forum") />
                    <#if interaction_style != "forum" && interaction_style != "idea">
                        <#assign interaction_style = "forum"/>
                    </#if>
                    <#assign categoryProductCheck=restadmin('/categories/id/${categoryID}/settings/name/autodesk.product_non_product').value/>
                        <#if categoryProductCheck=="P" || categoryProductCheck=="p">
                            <#if interaction_style=="forum">
                                <#assign postOrIdea="Post" />
                                <#assign pageTitle="Forums:Product:${categoryName}:${categoryName}:NotSelected:PostForumForm">
                            <#elseif interaction_style=="idea">
                                <#assign postOrIdea="Idea" />
                                <#assign pageTitle="Ideas:Product:${categoryName}:${categoryName}:NotSelected:PostIdeaForm">
                            </#if>
                        <#elseif categoryProductCheck=="NP" || categoryProductCheck=="np" || boardProductCheck==""> 
                            <#if interaction_style=="forum">
                                <#assign postOrIdea="Post" />
                                <#assign pageTitle="Forums:NonProduct:${categoryName}:NotSelected:PostForumForm">
                            <#elseif interaction_style=="idea">
                                <#assign postOrIdea="Idea" />
                                <#assign pageTitle="Ideas:NonProduct:${categoryName}:NotSelected:PostIdeaForm">
                            </#if>
                        </#if>  
                        <@liaAddScript>
                        ;(function($){
                        /* write js code*/

                        var language="${userLanguage?js_string}";
                        if("${loginStatus?js_string}"=="Offline"){
                            language=document.documentElement.lang;
                            }

                        $(window).on('load',function(){
                            //debugger;
                            window.dataLayer.push({
                            'pageTitle': '${pageTitle?js_string}',
                            'userSetLanguage':language ,
                            'rank': '${userRank?js_string}',
                            'role': '${userRole?js_string}',
                            'loginStatus': '${loginStatus?js_string}',
                            'analyticsID': '',
                            'category':'${categoryName?js_string}',
                            'board':'NotSelected',
                            });
                        }); 
                        $('.lia-button.lia-button-primary.lia-button-Submit-action').on('click',function(){
                            //debugger;
                            var current_date = new Date();
                            var date_utc = current_date.toISOString();

                            var tagsInputValue=$('.lia-form-tags-input.lia-form-type-text.lia-form-input-vertical').val();
                            var tags='No';
                            var attachmentValue=$('.lia-form-type-file').val();
                            var attachment='No';
                            var screencastCheck=$('.iframe-container iframe').length;
                            var screencast='No';
                            if(screencastCheck>0)
                            {
                                screencast='Yes';
                            }
                            if(tagsInputValue!="")
                            {
                                tags='Yes';
                            }
                            if(attachmentValue!="")
                            {
                                attachment='Yes';
                            }

                            window.dataLayer.push({
                            'event': '${postType?js_string}',
                            'postOrIdea': '${postOrIdea?js_string}',
                            'dateOfFirstPost': date_utc,
                            'screencast': screencast,
                            'attachment': attachment,
                            'tag': tags
                            });
                            });
                        })(LITHIUM.jQuery);
                    </@liaAddScript>  
                </#if>
            </#if>        
        <#break>
        <#case "ReplyPage">
            <#assign MsgID =page.context.message.uniqueId />
            <#assign parentMsgID="" />
            <#assign queryStringParent="select parent.id from messages where id='${MsgID}'" />
            <#assign responseParent=restadmin("2.0","/search?q=" + queryStringParent?url) />
            <#assign postType="Non First Post" />
            <#if responseParent.data.items[0].parent??>
                <#assign parentMsgID=responseParent.data.items[0].parent.id />
                <#assign queryString="select is_solution from messages where id='${MsgID}'" />
                <#assign response=restadmin("2.0","/search?q=" + queryString?url) />
                <#assign is_Solution=response.data.items[0].is_solution />
                <#if is_Solution==true>
                    <#assign postType="Accepted Solution" />
                </#if>
            <#else>
                 
                <#assign postType="First Post" /> 
            </#if>
            <#assign msgSubject =env.context.message.subject />
            <#assign indexOfColon=msgSubject?index_of(':') />
            <#assign msgSubject =msgSubject?substring(indexOfColon+1,msgSubject?length) />
            <#assign msgSubject=msgSubject?replace("'","&quote;") />
            <#assign interaction_style=""/>
            <#assign categoryID=""/>
            <#assign boardID=""/>
            
            <#assign postOrIdea="" />
            <#assign interaction_style=page.interactionStyle/>
            <#if coreNode.ancestors?size gt 1>
                <#assign categoryID=coreNode.ancestors[0].id />
                <#assign boardID=coreNode.id />
            <#else>
                <#assign boardID=coreNode.id />
            </#if>    
            <#assign boardProductCheck=restadmin('/boards/id/${boardID}/settings/name/autodesk.product_non_product').value/>
            <#assign boardTitle=coreNode.title />
            <#if coreNode.ancestors?size==1>
                <#assign productName=coreNode.title />
                <#assign categoryName="" />
            <#elseif coreNode.ancestors?size==2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName=coreNode.ancestors[0].title />
            <#elseif coreNode.ancestors?size gt 2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName="">
                <#list 0..coreNode.ancestors?size-1 as i>
                    <#assign categoryName=categoryName+coreNode.ancestors[i].title+":" />
                </#list>
                <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
            </#if>
            
            <#if boardProductCheck=="P" || boardProductCheck=="p">
                    <#if categoryID=="">
                        <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:${msgSubject}:ReplyForm" />
                    <#else>
                        <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:${msgSubject}:ReplyForm" />
                    </#if>
            <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck==""> 
                    <#if categoryID=="">
                        <#assign pageTitle="Forums:NonProduct:${productName}:${boardTitle}:${msgSubject}:ReplyForm" />
                    <#else>
                        <#assign pageTitle="Forums:NonProduct:${productName}:${categoryName}:${boardTitle}:${msgSubject}:ReplyForm" />
                    </#if>
            </#if>
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': '',
                'category':'${categoryName?js_string}',
                'board':'${boardTitle?js_string}',
                'parentID': '${parentMsgID?js_string}'
                });
            });
                
            $('#submitContext_1').on('click',function(){
                //debugger;
                    var tagsInputValue=$('.lia-form-tags-input.lia-form-type-text.lia-form-input-vertical').val();
                    var tags='No';
                    var attachmentValue=$('.lia-form-type-file').val();
                    var attachment='No';
                    var screencastCheck=$('.iframe-container iframe').length;
                    var screencast='No';
                    if(screencastCheck>0)
                    {
                        screencast='Yes';
                    }
                    if(tagsInputValue!="")
                    {
                        tags='Yes';
                    }
                    if(attachmentValue!="")
                    {
                        attachment='Yes';
                    }
                
                    window.dataLayer.push({
                    'event': 'reply',
                    'replyType': 'reply',
                    'postType': '${postType?js_string}',
                    'parentID': '${parentMsgID?js_string}',
                    'postOrIdea': 'Post',
                    'screencast': screencast,
                    'attachment': attachment,
                    'tag': tags,
                    'threadID':'${MsgID?js_string}'
                    });
                });
                
            })(LITHIUM.jQuery);
        </@liaAddScript>      
        <#break>
        <#case "MyProfilePage">
            <#assign pageURL=http.request.url />
            <#assign indexOfLastSlash=pageURL?last_index_of('/') />
            <#assign indexOfLastColon=pageURL?last_index_of(':') />
            <#if indexOfLastColon!=5>
                <#assign primaryTab=pageURL?substring(indexOfLastSlash+1,indexOfLastColon) />
                <#assign secondaryTab=pageURL?substring(indexOfLastColon+1,pageURL?length)/>
                <#assign pageTitle="Account:MySitePreference:${primaryTab}:${secondaryTab}" />
            <#else>
                <#assign primaryTab=pageURL?substring(indexOfLastSlash+1,pageURL?length) />
                <#if primaryTab=="personal-profile">
                    <#assign pageTitle="Account:MySitePreference:${primaryTab}:personal-info" />
                <#elseif primaryTab=="user-preferences">
                    <#assign pageTitle="Account:MySitePreference:${primaryTab}:personal" />
                <#elseif primaryTab=="user-tagging">
                    <#assign pageTitle="Account:MySitePreference:${primaryTab}:tagging-options" />
                <#elseif primaryTab=="macros">
                    <#assign pageTitle="Account:MySitePreference:${primaryTab}" />
                <#elseif primaryTab=="user-subscriptions">
                    <#assign pageTitle="Account:MySitePreference:${primaryTab}:email-subscriptions" />
                </#if>     
            </#if>
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });   
            })(LITHIUM.jQuery);
        </@liaAddScript>      
        <#break>
        <#case "ViewProfilePage">
            <#assign pageURL=http.request.url />
            <#assign indexStart= pageURL?last_index_of('/')>
            <#assign userID=pageURL?substring(indexStart+1,pageURL?length) />
            <#assign pageTitle="Profile:${userID}">
            
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });   
            })(LITHIUM.jQuery);
        </@liaAddScript>      
        <#break>
        <#case "mydashboard">
            <#assign pageTitle="Account:MyDashBoard">
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });   
            })(LITHIUM.jQuery);
        </@liaAddScript> 
        <#break>
        <#case "SearchPage">
            <#assign pageTitle="SearchResult">
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });   
            })(LITHIUM.jQuery);
        </@liaAddScript> 
        <#break>
        <#case "FaqPage">
            <#assign pageTitle="HelpLinks">
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });   
            })(LITHIUM.jQuery);
        </@liaAddScript> 
        <#break>
        <#case "AcceptedSolutionsLeaderboardPage">
            <#assign pageTitle="AcceptedSolutionsLeaderboard">
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });   
            })(LITHIUM.jQuery);
        </@liaAddScript> 
        <#break>
        <#case "KudosMessagePage">
            <#assign pageURL=http.request.url />
            <#assign indexOfSlash=pageURL?last_index_of('/')>
            <#assign selectedTab=""/>
            <#if indexOfSlash!=-1 >
                <#assign selectedTab=pageURL?substring(indexOfSlash+1,pageURL?length) />
                <#if selectedTab="expert-users">
                    <#assign selectedTab="Experts" />
                <#elseif selectedTab="all-users">
                    <#assign selectedTab="AllUsers" />
                </#if>
            </#if>
            <#assign pageTitle="AcceptedSolutionsLeaderboard">
            <#assign boardId=coreNode.id />
            <#assign boardProductCheck=restadmin('/boards/id/${boardId}/settings/name/autodesk.product_non_product').value/>
            <#assign boardTitle=coreNode.title />
            <#if coreNode.ancestors?size==1>
                <#assign productName=coreNode.title />
                <#assign categoryName="" />
            <#elseif coreNode.ancestors?size==2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName=coreNode.ancestors[0].title />
            <#elseif coreNode.ancestors?size gt 2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName=""/>
                <#list 0..coreNode.ancestors?size-1 as i>
                    <#assign categoryName=categoryName+coreNode.ancestors[0].title+":" />
                </#list>
                <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
            </#if>
                
            <#if boardProductCheck=="P" || boardProductCheck=="p">
                    <#if categoryName=="">
                        <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:SeeWhoLiked" />
                    <#else>
                        <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:SeeWhoLiked" />
                    </#if>
            <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck==""> 
                    <#if categoryName=="">
                        <#assign pageTitle="Forums:NonProduct:${productName}:${boardTitle}:SeeWhoLiked" />
                    <#else>
                        <#assign pageTitle="Forums:NonProduct:${productName}:${categoryName}:${boardTitle}:SeeWhoLiked" />
                    </#if>
            </#if>
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });   
            })(LITHIUM.jQuery);
        </@liaAddScript>
        <#break>
        <#case "EditPage">
            <#assign MsgID =env.context.message.id />
            <#assign msgSubject =env.context.message.subject />
            <#assign interaction_style=page.interactionStyle/>
            <#assign boardID=coreNode.id />
            <#assign boardProductCheck=restadmin('/boards/id/${boardID}/settings/name/autodesk.product_non_product').value/>
            <#assign boardTitle=coreNode.title />
            <#if coreNode.ancestors?size==1>
                <#assign productName=coreNode.title />
                <#assign categoryName="" />
            <#elseif coreNode.ancestors?size==2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName=coreNode.ancestors[0].title />
            <#elseif coreNode.ancestors?size gt 2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName="">
                <#list 0..coreNode.ancestors?size-1 as i>
                    <#assign categoryName=categoryName+coreNode.ancestors[i].title+":" />
                </#list>
                <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
            </#if>
            <#if boardProductCheck=="P" || boardProductCheck=="p">
                    <#if categoryName=="">
                        <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:EditForm" />
                    <#else>
                        <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:EditForm" />
                    </#if>
            <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck==""> 
                    <#if categoryName=="">
                        <#assign pageTitle="Forums:NonProduct:${productName}:${boardTitle}:EditForm" />
                    <#else>
                        <#assign pageTitle="Forums:NonProduct:${productName}:${categoryName}:${boardTitle}:EditForm" />
                    </#if>
            </#if>
            <@liaAddScript>
            ;(function($){
            /* write js code*/
                
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': '',
                'category':'${categoryName?js_string}',
                'board':'${boardTitle?js_string}',
                'parentID':'${MsgID?js_string}'
                });
            });
                
            $('#submitContext_1').on('click',function(){
                //debugger;
                    var tagsInputValue=$('.lia-form-tags-input.lia-form-type-text.lia-form-input-vertical').val();
                    var tags='No';
                    var attachmentValue=$('.lia-form-type-file').val();
                    var attachment='No';
                    var screencastCheck=$('.iframe-container iframe').length;
                    var screencast='No';
                    if(screencastCheck>0)
                    {
                        screencast='Yes';
                    }
                    if(tagsInputValue!="")
                    {
                        tags='Yes';
                    }
                    if(attachmentValue!="")
                    {
                        attachment='Yes';
                    }
                
                    window.dataLayer.push({
                    'event': 'edit',
                    'parentID': '${MsgID?js_string}',
                    'postOrIdea': 'Post',
                    'screencast': screencast,
                    'attachment': attachment,
                    'tag': tags
                    });
                });
                
            })(LITHIUM.jQuery);
        </@liaAddScript>      
        <#break>
        <#case "MessageHistoryPage">
            <#assign pageTitle="MessageHistory" />
            <@liaAddScript>
            ;(function($){
            /* write js code*/      
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });              
            })(LITHIUM.jQuery);
        </@liaAddScript>      
        <#break>
        <#case "MoveMessagesPage"> 
            <#assign pageTitle="MoveMessage" />
            <@liaAddScript>
            ;(function($){
            /* write js code*/      
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });              
            })(LITHIUM.jQuery);
        </@liaAddScript>   
        <#break>
        <#case "NotifyModeratorPage"> 
            <#assign interaction_style=page.interactionStyle/>
            <#assign boardID=coreNode.id />
            <#assign boardTitle=coreNode.title />
            <#assign boardProductCheck=restadmin('/boards/id/${boardID}/settings/name/autodesk.product_non_product').value/>
            <#assign boardTitle=coreNode.title />
            <#if coreNode.ancestors?size==1>
                <#assign productName=coreNode.title />
                <#assign categoryName="" />
            <#elseif coreNode.ancestors?size==2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName=coreNode.ancestors[0].title />
            <#elseif coreNode.ancestors?size gt 2>
                <#assign productName=coreNode.ancestors[0].title />
                <#assign categoryName="">
                <#list 0..coreNode.ancestors?size-1 as i>
                    <#assign categoryName=categoryName+coreNode.ancestors[i].title+":" />
                </#list>
                <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
            </#if>
            <#if boardProductCheck=="P" || boardProductCheck=="p">
                    <#if categoryName=="">
                        <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:NotifyModerator" />
                    <#else>
                        <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:NotifyModerator" />
                    </#if>
            <#elseif boardProductCheck=="NP" || boardProductCheck=="np" || boardProductCheck==""> 
                    <#if categoryName=="">
                        <#assign pageTitle="Forums:NonProduct:${productName}:${boardTitle}:NotifyModerator" />
                    <#else>
                        <#assign pageTitle="Forums:NonProduct:${productName}:${categoryName}:${boardTitle}:NotifyModerator" />
                    </#if>
            </#if>
            <@liaAddScript>
            ;(function($){
            /* write js code*/      
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': '',
                'board':'${boardTitle?js_string}',
                'category':'${categoryName?js_string}'
                });
            });              
            })(LITHIUM.jQuery);
        </@liaAddScript>   
        <#break>
        <#case "ConfirmationPage">
            <#assign pageTitle="Confirmation" />
            <@liaAddScript>
            ;(function($){
            /* write js code*/      
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });              
            })(LITHIUM.jQuery);
        </@liaAddScript>   
        <#break>
            <#case "EscalationSubmissionPage">
            <#assign pageURL=http.request.url />
            <#assign msgString="message-uid/"/>
            <#assign indexStart=pageURL?index_of(msgString)+msgString?length />
            <#assign msgId=pageURL?substring(indexStart,pageURL?length)/>
            <#assign queryString="select * from messages where id='${msgId}'"/>
            <#assign response=restadmin("2.0","/search?q=" + queryString?url) />
            <#assign parentID=""/>
            <#if response.data.items[0].parent??>
                <#assign parentID=response.data.items[0].parent.id />
            </#if>
            <#assign msgSubject="">
            <#if parentID!="">
                <#assign msgSubject=rest('/messages/id/${parentID}/subject').value />
            <#else>
                <#assign parentID=msgId/>
                <#assign msgSubject=rest('/messages/id/${parentID}/subject').value />
            </#if>
            <#assign msgSubject=msgSubject?replace("'","&quote;") />
            <#assign boardId=coreNode.id />
            <#assign boardProductCheck=restadmin('/boards/id/${boardId}/settings/name/autodesk.product_non_product').value/>
            <#assign boardTitle=coreNode.title />
            <#if coreNode.ancestors?size==1>
            <#assign productName=coreNode.title />
            <#assign categoryName=coreNode.title />
            <#elseif coreNode.ancestors?size==2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName=coreNode.ancestors[0].title />
            <#elseif coreNode.ancestors?size gt 2>
            <#assign productName=coreNode.ancestors[0].title />
            <#assign categoryName=""/>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName=categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName=categoryName?substring(0,categoryName?length-1) />
            </#if>
            <#assign interactionStyle=page.interactionStyle />
            <#if boardProductCheck=="P" || boardProductCheck=="p">
                <#if coreNode.ancestors?size==1 >
                    <#assign pageTitle="Forums:Product:${productName}:${boardTitle}:${msgSubject}:EscalationForm">
                <#else>
                    <#assign pageTitle="Forums:Product:${productName}:${categoryName}:${boardTitle}:${msgSubject}:EscalationForm">
                </#if>   
            <#elseif boardProductCheck=="NP" || boardProductCheck=="np">
               <#if coreNode.ancestors?size==1>
                        <#assign pageTitle="Forums:NonProduct:${boardTitle}:${messageSubject}:EscalationForm">
               <#else>
                        <#assign pageTitle="Forums:NonProduct:${categoryName}:${boardTitle}:${messageSubject}:EscalationForm">
               </#if>    
            </#if>
            <@liaAddScript>
            ;(function($){
            /* write js code*/      
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                }); 
            }); 
            var formFooterElem=$('.lia-form-footer')[0];
            var submitBtn=$(formFooterElem).find('.lia-button.lia-button-primary.lia-button-Submit-action');
                    if(formFooterElem!=undefined){
                    $(submitBtn).on('click',function(ev){
                            window.dataLayer.push({
                                'event': 'escalateNow',
                                'postOrIdea': 'Post',
                                'parentID': '${parentID?js_string}',
                                'threadID': '${msgId?js_string}',
                                }); 
                    });
                }
            })(LITHIUM.jQuery);
        </@liaAddScript>   
        <#break>
        <#case "ErrorPage">     
            <#assign interaction_style="" />
            <#if page.interactionStyle=="forum">
                <#assign interaction_style="Forums" />
            <#elseif page.interactionStyle=="idea">
                <#assign interaction_style="Ideas" />
            </#if>
            <#assign pageTitle="${interaction_style}:AccessDenied" />
            <@liaAddScript>
            ;(function($){
            /* write js code*/      
            var language="${userLanguage?js_string}";
            if("${loginStatus?js_string}"=="Offline"){
                language=document.documentElement.lang;
                }
                
            $(window).on('load',function(){
                //debugger;
                window.dataLayer.push({
                'pageTitle': '${pageTitle?js_string}',
                'userSetLanguage':language ,
                'rank': '${userRank?js_string}',
                'role': '${userRole?js_string}',
                'loginStatus': '${loginStatus?js_string}',
                'analyticsID': ''
                });
            });              
            })(LITHIUM.jQuery);
        </@liaAddScript>   
        <#break>
</#switch>
