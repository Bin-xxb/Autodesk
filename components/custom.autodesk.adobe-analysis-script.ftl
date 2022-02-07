<#assign envURL=""/>
<#if config.getString("phase", "dev") == "dev">
  <#assign envURL = "-dev" />
<#elseif config.getString("phase", "stage") == "stage">
  <#assign envURL = "-stg" />
</#if>
<@liaAddScript>
    ;(function($){


        /* search bar submit */
        $('form.SearchForm').each(function() {
            var $search_form = $(this);

            var submitHandler = function() {
                $search_form.off('submit', submitHandler);

                var $text_input = $search_form.find('lia-form-type-text');
                var $search_granularity = $search_form.find('.lia-search-form-granularity');

                var val = $text_input.val();

                var title = "";

                if( $search_granularity.css('display') == 'none' ) {
                    title = 'non prefiltered';
                } else {
                    title = $search_granularity.find('option').filter(':selected').text();
                }
                
                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    eventContext: {
                        searchTerm: val
                    },
                    link: {
                        linkSection: 'forums search',
                        linkTitle: title ,
                        linkDestinationUrl: 'https://forums${envURL?js_string}.autodesk.com/t5/forums/searchpage/tab/message?advanced=false&allow_punctuation=false&q=' + val
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);
               // console.log(analyticsObj);
            };

            $search_form.on("submit", submitHandler);
        });

        /* type-ahead click */
        $( document ).ajaxComplete(function( event, xhr, settings ) {

            var seturl = settings.url;
            if ( seturl.indexOf("messagesearchfield.messagesearchfield:autocomplete") >= 0 ) {
            
                    $(".lia-autocomplete-content li").on("click", function (e) {
                        var $ele = $(this).find('> .lia-autocomplete-message-list-item-link');
                        var valink = $ele.text().trim();
                        var url = $ele.attr('href');
                        
                        if( $(this).find('> .lia-attachment-icon-container').length ) {
                            var title = 'tye-ahead link';
                        } else {
                            var title = 'type-ahead';
                        }
                        var val = $('.lia-autocomplete-input').val();
                        
                        var analyticsObj = {
                            event: {
                                eventType: 'link_click'
                            },
                            eventContext: {
                                searchTerm: val
                            },
                            link: {
                                linkSection: 'forums search',
                                linkTitle: title + ': ' + valink ,
                                linkDestinationUrl: 'https://forums${envURL?js_string}.autodesk.com' + url
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);

                        //console.log(analyticsObj);
                    }); 
                
            }
        }); 

        /* links tracking - community dashboard */
        $( "#communityAdminLinksTaplet a" ).each(function() {
            var $this = $(this);
            var text = $this.text().trim();
            if (text == '${text.format("menubar.community_admin")?js_string}') {
                text = 'community admin';
            } else if (text == '${text.format("menubar.category_admin")?js_string}') {
                text = 'category admin';
            } else if (text == '${text.format("menubar.moderation_manager")?js_string}') {
                text = 'moderation';
            } else if (text == '${text.format("spamManager.title")?js_string}') {
                text = 'spam quarantine';
            } else if (text == '${text.format("archivalPage.title")?js_string}') {
                text = 'archives';
            } else if (text == '${text.format("adminfaqpage.title")?js_string}') {
                text = 'admin help';
            } else if (text == '${text.format("page.LithiumStudio.title")?js_string}') {
                text = 'studio';
            } else if (text == '${text.format("page.Toolbox.title")?js_string}') {
                text = 'toolbox';
            } else if (text == '${text.format("custom.ics_admin")?js_string}') {
                text = 'ics admin';
            }
            $(this).attr({"data-wat-link":"true", "data-wat-loc":"category dashboard", "data-wat-val":text});
        });

        /* links tracking - forum links */
        $( ".lia-quick-community-links a" ).each(function() {
            var $this = $(this);
            var text = $this.text().trim();
            if (text == '${text.format("autodesk-forumlinks-widget-links-all-forums")?js_string}') {
                text = 'all forums';
            } else if (text == '${text.format("autodesk-forumlinks-widget-links-get-started")?js_string}') {
                text = 'getting started';
            } else if (text == '${text.format("autodesk-forumlinks-widget-links-support-link")?js_string}') {
                text = 'contact support and downloads';
            } else if (text == '${text.format("autodesk-forumlinks-widget-links-community-resource")?js_string}') {
                text = 'community resources';
            }
            $(this).attr({"data-wat-link":"true", "data-wat-loc":"forums links", "data-wat-val":text});
        });

        /* links tracking - expert elite */
        $( ".lia-component-users-widget-user-list .username_area a" ).each(function() {
            $(this).attr({"data-wat-link":"true", "data-wat-loc":"expert elite", "data-wat-val":$(this).text().toLowerCase()});
        });

        /* links tracking - top solution authors */
        $( ".lia-component-solutions-widget-accepted-solutions-leaderboard-taplet .lia-user-name-link" ).each(function() {
            $(this).attr({"data-wat-link":"true", "data-wat-loc":"top solution authors", "data-wat-val":$(this).text().toLowerCase()});
        });

        /* links tracking - trending topics */
        $( ".lia-trending-topics a" ).each(function() {
            $(this).attr({"data-wat-link":"true", "data-wat-loc":"trending topics", "data-wat-val":$(this).text().toLowerCase()});
        });

        /* links tracking - site nav */
        /*
        $( document ).ajaxComplete(function( event, xhr, settings ) {
            if (settings.url.indexOf('/ajax/adsk/main-menu') != -1) {
                $( ".off-canvas-menu-wrap ul a" ).each(function() {
                    $(this).attr({"data-wat-link":"true", "data-wat-loc":"site navigation", "data-wat-val":$(this).text().toLowerCase()});
                });
            }
        });
        */

        /* links tracking - site nav product picker */
        /*
        $( document ).ajaxComplete(function( event, xhr, settings ) {
            if (settings.url.indexOf('/ajax/adsk/products/quicktabs/forums') != -1) {
                $( ".product-picker-by-topics-container ul .product-name a" ).each(function() {
                    $(this).attr({"data-wat-link":"true", "data-wat-loc":"site nav product picker", "data-wat-val":$(this).text().toLowerCase()});
                });
            }
        });
        */

        /* links tracking - side banner */
        $( ".lia-component-common-widget-custom-content a" ).each(function() {
            var $this = $(this);
            var sideBanText = $this.text().trim();
            if( sideBanText.length ) {
                $this.attr({"data-wat-link":"true", "data-wat-loc":"side banner", "data-wat-val":sideBanText.toLowerCase()});
            } else {
                var $sideImg = $this.find('img').first();
                if( $sideImg.length ) {
                    var sideAlt = $sideImg.attr('alt');
                    if( sideAlt ) {
                        sideAlt = sideAlt.trim();
                    }
                    var sideTitle = $sideImg.attr('title');
                    if( sideTitle ) {
                        sideTitle = sideTitle.trim();
                    }
                    if( sideAlt && sideAlt.length ) {
                        $this.attr({"data-wat-link":"true", "data-wat-loc":"side banner", "data-wat-val":sideAlt.toLowerCase()});
                    } else if( sideTitle && sideTitle.length ) {
                        $this.attr({"data-wat-link":"true", "data-wat-loc":"side banner", "data-wat-val":sideTitle.toLowerCase()});
                    }
                }
            }

        });

        /* links tracking - side banner - twitter */
        if(typeof twttr !== 'undefined') {
            twttr.ready(function (twttr) {
                twttr.events.bind('click', function() {
                    $(".twitter-link").attr({"data-wat-link":"true", "data-wat-loc":"side banner", "data-wat-val":"twitter follow"});
                    $('.twitter-link').trigger( "click" );
                });
            });
        }

    })(LITHIUM.jQuery);
</@liaAddScript>



<#assign loginStatus = "no">
<#assign userRank = ""/>
<#assign userRole = ""/>
<#assign userOxygenId = "" />

<#assign pageTitle = ""/>
<#assign boardName = "" />
<#assign categoryName = "" />
<#assign dateOfFirstThread = "" />
<#assign acceptSolution = "" />
<#assign msgId = "" />
<#assign threadId = "" />


<#if !user.anonymous >
    <#assign userOxygenId = restadmin('/users/id/${user.id?c}/sso_id').value />
    <#assign loginStatus = "yes" >
    <#assign userRank = restadmin('users/id/${user.id?c}/ranking').ranking.name />
    <#assign userRolesRequest = restadmin('users/id/${user.id?c}/roles') />
    <#if userRolesRequest.roles?? && userRolesRequest.roles?has_content >
        <#list userRolesRequest.roles.role as r >
            <#assign userRole = userRole + r.name + " ; " />
        </#list>
        <#assign userRole = userRole?substring(0,userRole?length-1) />
    </#if>
</#if>

<#switch page.name>
    <#case "EditPage" >
        <#assign msgId = page.context.message.uniqueId />
        <#assign threadId = page.context.thread.topicMessage.uniqueId />
        <#assign dateOfFirstThread = page.context.thread.topicMessage.postDate?datetime?iso_utc />
        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign pageTitle = "Forums:${categoryName}:${boardName}:EditPage" />

        <@liaAddScript>
        ;(function($) {

            /* edit event */
            $(document).on('click', '.MessageEditorForm .lia-button-Submit-action', function() {

                var tagsInputValue = $('.lia-form-tags-input.lia-form-type-text.lia-form-input-vertical').val();
                var tags = 'no';
                var attachmentValue = $('.lia-drag-drop-attachments').height();
                var attachment = 'no';
                var screencastCheck = $('.lia-message-body-content .iframe-container iframe').length;
                var screencast = 'no';
                if(screencastCheck > 0)
                {
                    screencast = 'yes';
                }
                if(tagsInputValue != "")
                {
                    tags = 'yes';
                }
                if( attachmentValue > 0 )
                {
                    attachment = 'yes';
                }

                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'forums',
                        linkTitle: 'edit'
                    },
                    eventContext: {
                        dhxEventName: 'forums_content_edit_post',
                        dhxEventData: 'post',
                        threadId: '${msgId?js_string}',
                        parentId: '${threadId?js_string}',
                        dateOfFirstPost: '${dateOfFirstThread?js_string}',
                        screencast: screencast,
                        attachment: attachment,
                        tag: tags
                    }
                };

                if (!$('#lia_board_chosen .chosen-single').hasClass('chosen-default') && $('#lia-subject').val().length > 0) {
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                }
            });

            /* page loading */
            var AdoPageObj = {
                pageTitle: '${pageTitle?js_string?lower_case}',
                board: '${boardName?js_string?lower_case}',
                category: '${categoryName?js_string?lower_case}',
                dateOfFirstThread: '${dateOfFirstThread?js_string}',
                acceptSolution: '${acceptSolution?js_string}',
                threadId: '${msgId?js_string}',
                parentId: '${threadId?js_string}',
                contentTranslationType: 'n/a',
                contentLanguage: document.documentElement.lang
            };
            var AdoUserObj = {
                oxygenId: '${userOxygenId?js_string}',
                loginStatus: '${loginStatus?js_string}',
                userRole: '${userRole?js_string?lower_case}',
                userRank: '${userRank?js_string?lower_case}'
            };

            function clean(obj) {
              for (var key in obj) {
                if ( obj[key] === '' ) {
                  delete obj[key];
                }
              }
            }
            clean(AdoPageObj);
            clean(AdoUserObj);

            window.digitalData = window.digitalData || {};
            window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
            window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );


        })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "ReplyPage" >
        <#assign threadId = page.context.thread.topicMessage.uniqueId />
        <#assign dateOfFirstThread = page.context.thread.topicMessage.postDate?datetime?iso_utc />
        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign pageTitle = "Forums:${categoryName}:${boardName}:ReplyPage" />
        <@liaAddScript>
            ;(function($){

            /* page loading */
            var AdoPageObj = {
                pageTitle: '${pageTitle?js_string?lower_case}',
                board: '${boardName?js_string?lower_case}',
                category: '${categoryName?js_string?lower_case}',
                dateOfFirstThread: '${dateOfFirstThread?js_string}',
                acceptSolution: '${acceptSolution?js_string}',
                threadId: '${msgId?js_string}',
                parentId: '${threadId?js_string}',
                contentTranslationType: 'n/a',
                contentLanguage: document.documentElement.lang
            };
            var AdoUserObj = {
                oxygenId: '${userOxygenId?js_string}',
                loginStatus: '${loginStatus?js_string}',
                userRole: '${userRole?js_string?lower_case}',
                userRank: '${userRank?js_string?lower_case}'
            };

            function clean(obj) {
              for (var key in obj) {
                if ( obj[key] === '' ) {
                  delete obj[key];
                }
              }
            }
            clean(AdoPageObj);
            clean(AdoUserObj);

            window.digitalData = window.digitalData || {};
            window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
            window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );


            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "PostPage" >
        <#assign interaction_style = page.interactionStyle />
        <#if interaction_style != "forum" && interaction_style != "idea">
            <#assign interaction_style = "forum"/>
        </#if>
        <#assign boardName = "" />
        <#assign categoryName = "" />
        <#if coreNode.nodeType != "community" && coreNode.nodeType != "category">
            <#assign boardName = coreNode.title />
            <#if coreNode.ancestors?size == 1 >
                <#assign categoryName = coreNode.title />
            <#elseif coreNode.ancestors?size == 2 >
                <#assign categoryName = coreNode.ancestors[0].title />
            <#elseif coreNode.ancestors?size gt 2>
                <#list 0..coreNode.ancestors?size-1 as i>
                    <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
                </#list>
                <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
            </#if>
        </#if>
        <#assign postOrIdea = "" />
        <#if interaction_style == "forum">
            <#assign postOrIdea = "post" />
            <#if categoryName == "" >
                <#assign pageTitle = "Forums:${boardName}:PostForumForm" >
            <#else>
                <#assign pageTitle = "Forums:${categoryName}:${boardName}:PostForumForm" >
            </#if>
        <#elseif interaction_style == "idea">
            <#assign postOrIdea = "idea" />
            <#if categoryName == "">
                <#assign pageTitle="Ideas:${boardName}:PostIdeaForm" >
            <#else>
                <#assign pageTitle = "Ideas:${categoryName}:${boardName}:PostIdeaForm" >
            </#if>
        </#if>

        <@liaAddScript>
            ;(function($) {

                /* submission event */
                $(document).on('click', '.MessageEditorForm .lia-button-Submit-action', function() {
                    var current_date = new Date();
                    var date_utc = current_date.toISOString();

                    var tagsInputValue = $('.lia-form-tags-input.lia-form-type-text.lia-form-input-vertical').val();
                    var tags = 'no';
                    var attachmentValue = $('.lia-drag-drop-attachments').height();
                    var attachment = 'no';
                    var screencastCheck = $('.inserted-screencast').css('display');
                    var screencast = 'no';
                    if(screencastCheck == 'block')
                    {
                        screencast = 'yes';
                    }
                    if(tagsInputValue != "")
                    {
                        tags = 'yes';
                    }
                    if( attachmentValue > 0 )
                    {
                        attachment = 'yes';
                    }

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'forums',
                            linkTitle: '${postOrIdea?js_string} submit'
                        },
                        eventContext: {
                            dhxEventName: 'forums_content_${postOrIdea?js_string}_submission',
                            dhxEventData: '${postOrIdea?js_string}',
                            dateOfFirstPost: date_utc,
                            screencast: screencast,
                            attachment: attachment,
                            tag: tags
                        }
                    };
                    if (!$('#lia_board_chosen .chosen-single').hasClass('chosen-default') && $('#lia-subject').val().length > 0) {
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);

                    }
                });

            /* page loading */
            var AdoPageObj = {
                pageTitle: '${pageTitle?js_string?lower_case}',
                board: '${boardName?js_string?lower_case}',
                category: '${categoryName?js_string?lower_case}',
                dateOfFirstThread: '${dateOfFirstThread?js_string}',
                acceptSolution: '${acceptSolution?js_string}',
                threadId: '${msgId?js_string}',
                parentId: '${threadId?js_string}',
                contentTranslationType: 'n/a',
                contentLanguage: document.documentElement.lang
            };
            var AdoUserObj = {
                oxygenId: '${userOxygenId?js_string}',
                loginStatus: '${loginStatus?js_string}',
                userRole: '${userRole?js_string?lower_case}',
                userRank: '${userRank?js_string?lower_case}'
            };

            function clean(obj) {
              for (var key in obj) {
                if ( obj[key] === '' ) {
                  delete obj[key];
                }
              }
            }
            clean(AdoPageObj);
            clean(AdoUserObj);

            window.digitalData = window.digitalData || {};
            window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
            window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );


            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "IdeaPage" >
        <#assign msgId = page.context.thread.topicMessage.uniqueId />
        <#assign threadId = page.context.thread.topicMessage.uniqueId />
        <#assign dateOfFirstThread = page.context.message.postDate?datetime?datetime?iso_utc />
        <#assign pageURL = http.request.url />

        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign messageSubject = page.context.thread.topicMessage.subject />
        <#assign messageSubject = messageSubject?replace(":","") />
        <#assign pageTitle = "Ideas:${categoryName}:${boardName}:${messageSubject}" >

        <@liaAddScript>
            ;(function($) {

                /* leave a comment */
                $(document).on('click', '.CommentEditorForm .lia-button-Submit-action', function() {
                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'forums',
                            linkTitle: 'comment:first post'
                        },
                        eventContext: {
                            dhxEventName: 'forums_content_comment',
                            dhxEventData: 'idea',
                            parentId: '${threadId?js_string}',
                            threadId: '${msgId?js_string}',
                            screencast: 'no',
                            attachment: 'no',
                            tag: 'no'
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                });

                /* vote a post */
                $('.kudos-link').not('.kudos-revoke-link').not('.lia-link-disabled').on('click', function() {
                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'forums',
                            linkTitle: 'vote:first post'
                        },
                        eventContext: {
                            dhxEventName: 'forums_content_vote',
                            dhxEventData: 'idea',
                            parentId: '${threadId?js_string}',
                            threadId: '${msgId?js_string}'
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);


                });

                /* see who vote */
                $(document).on('click', '.kudos-count-link:not(.lia-link-disabled)', function() {

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'forums',
                            linkTitle: 'see who vote:first post'
                        },
                        eventContext: {
                            dhxEventName: 'forums_content_see_who_vote',
                            dhxEventData: 'idea',
                            parentId: '${msgId?js_string}',
                            threadId: '${msgId?js_string}'
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                });

                /* social share */
                $(document).on('click', '.social-share-link a', function() {
                    var val = $(this).attr('data-wat-social');

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'social share',
                            linkTitle: val,
                            linkDestinationUrl: '${pageURL?js_string}'
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                });


                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );


            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "ForumTopicPage" >
        <#assign pageURL = http.request.url />
        <#assign threadId = page.context.thread.topicMessage.uniqueId />
        <#assign boardName = coreNode.title />
        <#assign messageSubject = page.context.thread.topicMessage.subject />
        <#assign messageSubject = messageSubject?replace(":'","") />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
            <#assign pageTitle = "Forums:${boardName}:${messageSubject}" >
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
            <#assign pageTitle = "Forums:${categoryName}:${boardName}:${messageSubject}">
        <#elseif coreNode.ancestors?size gt 2>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
            <#assign pageTitle = "Forums:${categoryName}:${boardName}:${messageSubject}" >
        </#if>
        <#assign dateOfFirstThread = page.context.thread.topicMessage.postDate?datetime?iso_utc />
        <#assign queryStringSolution = "SELECT conversation.solved FROM messages WHERE id='${threadId}'" />
        <#assign items = restadmin("2.0","/search?q=" + queryStringSolution?url).data.items![] />
        <#assign acceptSolution = "no" />
        <#if items?size gt 0 >
            <#if items[0].conversation.solved >
                <#assign acceptSolution = "yes" />
            </#if>
        </#if>


        <@liaAddScript>
        ;(function($) {

            /* accept solution */
            $(document).on('click', '.lia-component-accepted-solutions-button .lia-button', function() {
                var dateCurrent = new Date();
                var isoTime = dateCurrent.toISOString();
                
                var msgId = $(this).closest('.lia-panel-message').attr('data-lia-message-uid');
                var postType = "non-first post";

                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'forums',
                        linkTitle: 'accept solution:'.concat(postType)
                    },
                    eventContext: {
                        dhxEventName: 'forums_accept_solutions_click',
                        dhxEventData: 'post',
                        parentId: '${threadId?js_string}',
                        threadId: msgId,
                        postType: 'postType',
                        dateOfAcceptance: isoTime
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);

            });

            /* translation widgets */
            $(document).on('change', '#select-lang', function() {
                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'translation widget',
                        linkTitle: $(this).val()
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);

            });

            /* like a post */
            $('.kudos-link').not('.kudos-revoke-link').not('.lia-link-disabled').on('click', function() {  
                var msgId = $(this).closest('.lia-panel-message').attr('data-lia-message-uid');
                var postType = "non-first post";
                if( msgId == "${threadId?js_string}" ) {
                    postType = "first post";
                }
                if($(this).closest('.lia-message-view-forum-message').hasClass('lia-accepted-solution')) {
                    postType = "accepted solution";
                }

                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'forums',
                        linkTitle: 'like:'.concat(postType)
                    },
                    eventContext: {
                        dhxEventName: 'forums_content_like',
                        dhxEventData: 'post',
                        parentId: '${threadId?js_string}',
                        threadId: msgId
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);

                
            });

            /* see who like  */
            $(document).on('click', '.kudos-count-link:not(.lia-link-disabled)', function() {
                var msgId = $(this).closest('.lia-panel-message').attr('data-lia-message-uid');
                var postType = "non-first post";
                if( msgId == "${threadId?js_string}" ) {
                    postType = "first post";
                }
                if($(this).closest('.lia-message-view-forum-message').hasClass('lia-accepted-solution')) {
                    postType = "accepted solution";
                }

                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'forums',
                        linkTitle: 'see who like:'.concat(postType)
                    },
                    eventContext: {
                        dhxEventName: 'forums_content_see_who_like',
                        dhxEventData: 'post',
                        parentId: '${threadId?js_string}',
                        threadId: msgId
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);

            });

            /* social share */
            $(document).on('click', '.social-share-link a', function() {
                var val = $(this).attr('data-wat-social');

                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'social share',
                        linkTitle: val,
                        linkDestinationUrl: '${pageURL?js_string}'
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);

            });

            /* scroll to accepted solution */
            var windowHeight = $(window).height();
            $(window).on('resize', function() {
                windowHeight = $(window).height();
            });
            var scrollToSolution = true;
            var $solution = $('.lia-accepted-solution').first();
            if ($solution.length) {
                $(window).on('scroll', function() {
                    if( scrollToSolution && ($(window).scrollTop() + windowHeight) > $solution.offset().top ) {
                        scrollToSolution = false;
                        var analyticsObj = {
                            event: {
                                eventType: 'dhx_scroll_to_bottom'
                            },
                            eventContext: {
                                dhxEventName: 'dhx_scroll_to_bottom',
                                dhxEventData: 'scroll accepted solution'
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);

                    }
                });
            }

            /* reply event */
            $(document).on('click', '.lia-action-reply', function() {
                var msgId = $(this).closest('.lia-panel-message').attr('data-lia-message-uid');
                var postType = "non-first post";
                if( msgId == "${threadId?js_string}" ) {
                    postType = "first post";
                }
                if($(this).closest('.lia-message-view-forum-message').hasClass('lia-accepted-solution')) {
                    postType = "accepted solution";
                }

                var screencastCheck = $(this).closest('.lia-message-view-forum-message').find('.lia-message-body-content .iframe-container iframe').length;
                var screencast = 'no';
                if(screencastCheck)
                {
                    screencast = 'yes';
                }

                var attachmentsCheck = $(this).closest('.lia-message-view-forum-message').find('.lia-message-attachments').length;
                var attachment = 'no';
                if(attachmentsCheck) {
                    attachment = 'yes';
                }

                var tagsCheck = $(this).closest('.lia-message-view-forum-message').find('.TagList').length;
                var tags = 'no';
                if(tagsCheck) {
                    tags = 'yes';
                }

                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'forums',
                        linkTitle: 'comment:'.concat(postType)
                    },
                    eventContext: {
                        dhxEventName: 'forums_content_reply',
                        dhxEventData: 'post',
                        parentId: '${threadId?js_string}',
                        threadId: msgId,
                        screencast: screencast,
                        attachment: attachment,
                        tag: tags
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);

            });

            /* page loading */
            var AdoPageObj = {
                pageTitle: '${pageTitle?js_string?lower_case}',
                board: '${boardName?js_string?lower_case}',
                category: '${categoryName?js_string?lower_case}',
                dateOfFirstThread: '${dateOfFirstThread?js_string}',
                acceptSolution: '${acceptSolution?js_string}',
                threadId: '${msgId?js_string}',
                parentId: '${threadId?js_string}',
                contentTranslationType: 'n/a',
                contentLanguage: document.documentElement.lang
            };
            var AdoUserObj = {
                oxygenId: '${userOxygenId?js_string}',
                loginStatus: '${loginStatus?js_string}',
                userRole: '${userRole?js_string?lower_case}',
                userRank: '${userRank?js_string?lower_case}'
            };

            function clean(obj) {
              for (var key in obj) {
                if ( obj[key] === '' ) {
                  delete obj[key];
                }
              }
            }
            clean(AdoPageObj);
            clean(AdoUserObj);

            window.digitalData = window.digitalData || {};
            window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
            window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

        })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "EscalationSubmissionPage" >
        <#assign msgId = env.context.message.uniqueId />
        <#assign threadId = env.context.message.uniqueId />
        <#assign dateOfFirstThread = env.context.message.postDate?datetime?iso_utc />
        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#assign categoryName = "" />
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign messageSubject = env.context.message.subject />
        <#assign messageSubject = messageSubject?replace(":","") />
        <#assign pageTitle = "Forums:${categoryName}:${boardName}:${messageSubject}:EscalationForm" >

        <@liaAddScript>
        ;(function($) {

            /* escalate post */
            $(document).on('click', '.EscalationSubmissionForm .lia-button-Submit-action', function() {

                var analyticsObj = {
                    event: {
                        eventType: 'link_click'
                    },
                    link: {
                        linkSection: 'forums',
                        linkTitle: 'escalate'
                    },
                    eventContext: {
                        dhxEventName: 'forums_content_escalate_post',
                        dhxEventData: 'post',
                        parentId: '${threadId?js_string}',
                        threadId: '${msgId?js_string}'
                    }
                };
                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                window.__analyticsChangeContext.push(analyticsObj);

            });

            /* page loading */
            var AdoPageObj = {
                pageTitle: '${pageTitle?js_string?lower_case}',
                board: '${boardName?js_string?lower_case}',
                category: '${categoryName?js_string?lower_case}',
                dateOfFirstThread: '${dateOfFirstThread?js_string}',
                acceptSolution: '${acceptSolution?js_string}',
                threadId: '${msgId?js_string}',
                parentId: '${threadId?js_string}',
                contentTranslationType: 'n/a',
                contentLanguage: document.documentElement.lang
            };
            var AdoUserObj = {
                oxygenId: '${userOxygenId?js_string}',
                loginStatus: '${loginStatus?js_string}',
                userRole: '${userRole?js_string?lower_case}',
                userRank: '${userRank?js_string?lower_case}'
            };

            function clean(obj) {
              for (var key in obj) {
                if ( obj[key] === '' ) {
                  delete obj[key];
                }
              }
            }
            clean(AdoPageObj);
            clean(AdoUserObj);

            window.digitalData = window.digitalData || {};
            window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
            window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

        })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "IdeaExchangePage" >
        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#assign categoryName = "" >
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName + coreNode.ancestors[i].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign pageURL = http.request.url />
        <#if pageURL?contains("most-kudoed") >
            <#assign boardType = "TopVoted" />
        <#elseif pageURL?contains("most-recent") >
            <#assign boardType = "LatestIdeas" />
        <#else>
            <#assign boardType = "HotIdeas" />
        </#if>
        <#assign pageTitle = "Ideas:${categoryName}:${boardName}:${boardType}" />

        <@liaAddScript>
            ;(function($) {
                /* vote a post */
                $('.kudos-link').not('.kudos-revoke-link').not('.lia-link-disabled').on('click', function() {
                    var msgId = $(this).closest('.lia-message-view-wrapper').attr('data-lia-message-uid');

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'forums',
                            linkTitle: 'vote:first post'
                        },
                        eventContext: {
                            dhxEventName: 'forums_content_vote',
                            dhxEventData: 'idea',
                            parentId: msgId,
                            threadId: msgId
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);
                    
                });

                /* see who vote */
                $(document).on('click', '.kudos-count-link:not(.lia-link-disabled)', function() {
                    var msgId = $(this).closest('.lia-message-view-wrapper').attr('data-lia-message-uid');

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'forums',
                            linkTitle: 'see who vote:first post'
                        },
                        eventContext: {
                            dhxEventName: 'forums_content_see_who_vote',
                            dhxEventData: 'idea',
                            parentId: msgId,
                            threadId: msgId
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);
                    
                });

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "SearchPage" >
        <#assign pageTitle = "SearchResult" >
        <#assign pageURL = http.request.url />
        
        <@liaAddScript>
            ;(function($) {

                /* sort by */
                $(document).on('click', '#dropdownmenuitems_1 li a', function() {
                    var val = $(this).attr('aria-label');
                    if(val == '${text.format("menubar.search_actions.sort_by_date")?js_string}') {
                        val = 'date';
                    } else if(val == '${text.format("menubar.search_actions.sort_by_views")?js_string}') {
                        val = 'views';
                    } else if(val == '${text.format("menubar.search_actions.sort_by_kudos_count")?js_string}') {
                        val = 'kudos';
                    } else if(val == '${text.format("menubar.search_actions.sort_by_replies")?js_string}') {
                        val = 'replies';
                    } else if(val == '${text.format("menubar.search_actions.sort_by_best_match")?js_string}') {
                        val = 'best match';
                    }

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'sort by',
                            linkTitle: val
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                });

                /* Search Result Link Click */

                $(document).on('click', '.MessageSubject .lia-custom-event', function() {
                    var url = $(this).attr('href');
                    var val = $(this).text().trim();
                    

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'search result',
                            linkTitle: val ,
                            linkDestinationUrl: 'https://forums${envURL?js_string}.autodesk.com' + url
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                });

                /* Click on search icon Press enter */
                $(".lia-button-SearchPageForm-action").on("click", function (e) {
                    var val = $('.lia-form-type-search').val();
        
                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        eventContext: {
                            searchTerm: val
                        },
                        link: {
                            linkSection: 'forums search',
                            linkTitle: 'non prefiltered' ,
                            linkDestinationUrl: 'https://forums${envURL?js_string}.autodesk.com/t5/forums/searchpage/tab/message?advanced=false&allow_punctuation=false&q=' + val
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);
                    //console.log(analyticsObj);
                }); 
               

                /* Search Result filter */

                /* metadata filter */
                $(document).on('click', '.lia-component-search-widget-bling-filter li', function() {
                    if ($(this).find('.search-toggle-element input').is(':checked') ) {
                        var val = $(this).find('label').text().trim();

                        var analyticsObj = {
                            event: {
                                eventType: 'link_click'
                            },
                            link: {
                                linkSection: 'search filter',
                                linkTitle: 'metadata: ' + val ,
                                linkDestinationUrl: ''
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);

                    }

                });

                /* type filter */
                $(document).on('click', '.lia-component-search-widget-type-filter .lia-list-standard li', function() {
                    if ($(this).find('.search-toggle-element input').is(':checked') ) {
                        var val = $(this).find('label').text().trim();

                        var analyticsObj = {
                            event: {
                                eventType: 'link_click'
                            },
                            link: {
                                linkSection: 'search filter',
                                linkTitle: 'type: ' + val ,
                                linkDestinationUrl: ''
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);
                        
                    }

                });

                /* date filter */
                $(document).on('click', '.lia-component-search-widget-post-date-filter .lia-list-standard li', function() {
                    if ($(this).find('.search-toggle-element input').is(':checked') ) {
                        var val = $(this).find('label').text().trim();

                        var analyticsObj = {
                            event: {
                                eventType: 'link_click'
                            },
                            link: {
                                linkSection: 'search filter',
                                linkTitle: 'date: ' + val ,
                                linkDestinationUrl: ''
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);
                        
                    }

                });

                /* contains filter */
                $(document).on('click', '.lia-component-search-widget-content-filter .lia-list-standard li', function() {
                    if ($(this).find('.search-toggle-element input').is(':checked') ) {
                        var val = $(this).find('label').text().trim();

                        var analyticsObj = {
                            event: {
                                eventType: 'link_click'
                            },
                            link: {
                                linkSection: 'search filter',
                                linkTitle: 'contains: ' + val ,
                                linkDestinationUrl: ''
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);
                        
                    }

                });

                /* authur filter */

                $( document ).ajaxComplete(function( event, xhr, settings ) {

                    var seturl = settings.url;
                    if ( seturl.indexOf("searchpage.searchauthorfilter.usersearchfield.usersearchfield") >= 0 ) {

                        $(".lia-component-search-widget-author-filter .lia-autocomplete-content-inline .lia-component-users-auto-complete-user-list-item").on("click", function () {
                       
                            var val = $(this).find(".lia-user-name-link span").text();

                            var analyticsObj = {
                                event: {
                                    eventType: 'link_click'
                                },
                                link: {
                                    linkSection: 'search filter',
                                    linkTitle: 'authur: ' + val ,
                                    linkDestinationUrl: ''
                                }
                            };
                            window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                            window.__analyticsChangeContext.push(analyticsObj);

                            //console.log(analyticsObj);
                        });
                    }  
                });

                /* community filter */
                $( document ).ajaxComplete(function( event, xhr, settings ) {

                    var seturl = settings.url;
                    if ( seturl.indexOf("searchpage.searchlocationfilter.filtercollapsiblepanel:collapsepanelrender") >= 0 ) {

                        $(".lia-component-search-widget-location-filter .lia-component-forums-widget-community-node-tree-item").on("click", function () {
                           
                            var val = $(this).text().trim();
                            var url = $(this).attr('href');

                            var analyticsObj = {
                                event: {
                                    eventType: 'link_click'
                                },
                                link: {
                                    linkSection: 'search filter',
                                    linkTitle: 'location: ' + val ,
                                    linkDestinationUrl: ''
                                }
                            };
                            window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                            window.__analyticsChangeContext.push(analyticsObj);

                            //console.log(analyticsObj);
                        });
                    }

                });

                /* view result by filter */
                $(".lia-form-search-type-input").change(function() {
                    var val = this.options[this.selectedIndex].title;
                    
                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'search filter',
                            linkTitle: 'view result by: ' + val ,
                            linkDestinationUrl: ''
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);
                });


                /* results per page filter */
                $(".lia-form-search-results-size-input").change(function() {
                    var val = this.options[this.selectedIndex].title;
                    
                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'search filter',
                            linkTitle: 'results per page: ' + val ,
                            linkDestinationUrl: ''
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);
                });

                $( document ).ajaxComplete(function( event, xhr, settings ) {

                    var seturl = settings.url;
                    if ( seturl.indexOf("searchpage.messagesearchv22:searchrerender") >= 0 ) {

                        $(".lia-form-search-type-input").change(function() {
                            var val = this.options[this.selectedIndex].title;
                            
                            var analyticsObj = {
                                event: {
                                    eventType: 'link_click'
                                },
                                link: {
                                    linkSection: 'search filter',
                                    linkTitle: 'view result by: ' + val ,
                                    linkDestinationUrl: ''
                                }
                            };
                            window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                            window.__analyticsChangeContext.push(analyticsObj);

                            //console.log(analyticsObj);
                        });
                        $(".lia-form-search-results-size-input").change(function() {
                            var val = this.options[this.selectedIndex].title;
                            
                            var analyticsObj = {
                                event: {
                                    eventType: 'link_click'
                                },
                                link: {
                                    linkSection: 'search filter',
                                    linkTitle: 'results per page: ' + val ,
                                    linkDestinationUrl: ''
                                }
                            };
                            window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                            window.__analyticsChangeContext.push(analyticsObj);

                            //console.log(analyticsObj);
                        });

                        
                    }
                });

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "CommunityPage">
        <#assign interactionStyle = http.request.parameters.name.get("interaction_style", "forum") />
        <#if interactionStyle != "forum" && interactionStyle != "idea">
            <#assign interactionStyle = "forum"/>
        </#if>
        <#if interactionStyle == "forum" >
            <#assign pageTitle = "HomePage:Forums" />
        <#elseif interactionStyle == "idea" >
            <#assign pageTitle = "HomePage:Ideas" />
        </#if>
        
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "CategoryPage">
        <#assign categoryName = coreNode.title />
        <#assign pageTitle = "Forums:${categoryName}:BoardListing" />
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "ForumPage" >
        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#assign pageURL = http.request.url />
        <#if pageURL?contains("?faq") >
            <#assign boardType = "FAQs" />
        <#elseif pageURL?contains("?solved") >
            <#assign boardType = "AcceptedSolutions" />
        <#elseif pageURL?contains("?unanswered") >
            <#assign boardType = "Unanswered" />
        <#else>
            <#assign boardType = "AllPosts" />
        </#if>
        <#assign pageTitle = "Forums:${categoryName}:${boardName}:${boardType}" />
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "KudosMessagePage" >
        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#if page.interactionStyle == "idea" >
            <#assign pageTitle = "Ideas:${categoryName}:${boardName}:SeeWhoLiked:AllUsers" />
        <#else>
            <#assign pageTitle = "Forums:${categoryName}:${boardName}:SeeWhoLiked:AllUsers" />
        </#if>
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "NotifyModeratorPage" >
        <#assign boardName = coreNode.title />
        <#if coreNode.ancestors?size == 1 >
            <#assign categoryName = coreNode.title />
        <#elseif coreNode.ancestors?size == 2 >
            <#assign categoryName = coreNode.ancestors[0].title />
        <#elseif coreNode.ancestors?size gt 2>
            <#list 0..coreNode.ancestors?size-1 as i>
                <#assign categoryName = categoryName+coreNode.ancestors[0].title+":" />
            </#list>
            <#assign categoryName = categoryName?substring(0,categoryName?length-1) />
        </#if>
        <#if page.interactionStyle == "idea" >
            <#assign pageTitle = "Ideas:${categoryName}:${boardName}:NotifyModerator" />
        <#else>
            <#assign pageTitle = "Forums:${categoryName}:${boardName}:NotifyModerator" />
        </#if>
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "ErrorPage" >
        <#assign interaction_style = "" />
        <#if page.interactionStyle == "forum" >
            <#assign interaction_style = "Forums" />
        <#elseif page.interactionStyle == "idea" >
            <#assign interaction_style = "Ideas" />
        </#if>
        <#assign pageTitle = "${interaction_style}:AccessDenied" />
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "mydashboard" >
        <#assign pageTitle = "Account:MyDashBoard" >
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "MyProfilePage" >
        <#assign pageTitle = "Account:MySitePreference" >
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "ViewProfilePage" >
        <#assign pageTitle = "Profile:${page.context.user.id?c}" >
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "FaqPage" >
        <#assign pageTitle = "HelpLinks" >
        <@liaAddScript>
            ;(function($){

                /* page loading */
                var AdoPageObj = {
                    pageTitle: '${pageTitle?js_string?lower_case}',
                    board: '${boardName?js_string?lower_case}',
                    category: '${categoryName?js_string?lower_case}',
                    dateOfFirstThread: '${dateOfFirstThread?js_string}',
                    acceptSolution: '${acceptSolution?js_string}',
                    threadId: '${msgId?js_string}',
                    parentId: '${threadId?js_string}',
                    contentTranslationType: 'n/a',
                    contentLanguage: document.documentElement.lang
                };
                var AdoUserObj = {
                    oxygenId: '${userOxygenId?js_string}',
                    loginStatus: '${loginStatus?js_string}',
                    userRole: '${userRole?js_string?lower_case}',
                    userRank: '${userRank?js_string?lower_case}'
                };

                function clean(obj) {
                  for (var key in obj) {
                    if ( obj[key] === '' ) {
                      delete obj[key];
                    }
                  }
                }
                clean(AdoPageObj);
                clean(AdoUserObj);

                window.digitalData = window.digitalData || {};
                window.digitalData.page = Object.assign( window.digitalData.page || {}, AdoPageObj );
                window.digitalData.user = Object.assign( window.digitalData.user || {}, AdoUserObj );

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "OccasionBoardPage" >
        <@liaAddScript>
            ;(function($){
            
                /* Community Conversation - Attend Link Click */
                $( ".lia-component-occasion-action-rsvp .lia-button-primary" ).on("click", function () {
                    var $this = $(this);
                    var url = $(this).attr('href');

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'community conversation',
                            linkTitle: 'i will attend' ,
                            linkDestinationUrl: url
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);
                });

                /* Community Conversation - Title Link Click */
                $( ".lia-quilt-occasions-list-item .lia-occasion-title a" ).on("click", function () {
                    var $this = $(this);
                    var val = $(this).text().trim();
                    var url = $(this).attr('href');

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'community conversation',
                            linkTitle: 'community event_' + val ,
                            linkDestinationUrl: 'https://forums${envURL?js_string}.autodesk.com' + url
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);

                });   

                /* Community Conversation - view selection */
                $( ".lia-occasions-list-view" ).on("click", function () {
                    
                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'tab',
                            linkTitle: 'list view',
                            linkDestinationUrl: ''
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);
                    
                });

                $( ".lia-occasions-calendar-view" ).on("click", function () {
                    
                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'tab',
                            linkTitle: 'calendar view',
                            linkDestinationUrl: ''
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);
                    
                });

                /* Community Conversation - checkbox */
                $( ".lia-component-occasions-widget-status-filter .lia-list-standard .filter-toggle" ).on("click", function () {
                    if ($(this).is(':checked') ) {
                        var val = $(this).val().trim().toLowerCase();

                        var analyticsObj = {
                            event: {
                                eventType: 'link_click'
                            },
                            link: {
                                linkSection: 'checkbox',
                                linkTitle: 'event status: ' + val
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);

                        //console.log(analyticsObj);
                    }  
                }); 

                $( document ).ajaxComplete(function( event, xhr, settings ) {

                    var seturl = settings.url;
                    if ( seturl.indexOf("occasionboardpage.occasionfilters") >= 0 ) {

                        $( ".lia-component-occasions-widget-status-filter .lia-list-standard .filter-toggle" ).on("click", function () {
                            if ($(this).is(':checked') ) {
                                var val = $(this).val().trim().toLowerCase();

                                var analyticsObj = {
                                    event: {
                                        eventType: 'link_click'
                                    },
                                    link: {
                                        linkSection: 'checkbox',
                                        linkTitle: 'event status: ' + val
                                    }
                                };
                                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                                window.__analyticsChangeContext.push(analyticsObj);

                                //console.log(analyticsObj);
                            }  
                        });  
                    }
                });

                $( document ).ajaxComplete(function( event, xhr, settings ) {

                    var seturl = settings.url;
                    if ( seturl.indexOf("occasionboardpage.occasionlabelsfilter") >= 0 ) {

                        $( ".lia-component-occasions-widget-labels-filter .lia-list-standard .filter-toggle" ).on("click", function () {
                        
                            if ($(this).is(':checked') ) {
                                var val = $(this).val().trim().toLowerCase();

                                var analyticsObj = {
                                    event: {
                                        eventType: 'link_click'
                                    },
                                    link: {
                                        linkSection: 'checkbox',
                                        linkTitle: 'labels: ' + val
                                    }
                                };
                                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                                window.__analyticsChangeContext.push(analyticsObj);

                                //console.log(analyticsObj);
                            }  
                        });   
                    }
                });

                /* calendar title tracking */
                $( document ).ajaxComplete(function( event, xhr, settings ) {

                    var seturl = settings.url;
                    if ( seturl.indexOf("occasionboardpage.occasionscalendar") >= 0 ) {

                        $(".fc-event-container").mouseover(function() {
                    
                            $(".lia-occasion-title a").on("click", function () {
                                var url = $(this).attr('href');
                                var val = $(this).text().trim().toLowerCase();

                                var analyticsObj = {
                                    event: {
                                        eventType: 'link_click'
                                    },
                                    link: {
                                        linkSection: 'community conversation',
                                        linkTitle: 'community event_' + val,
                                        linkDestinationUrl: 'https://forums${envURL?js_string}.autodesk.com' + url
                                    }
                                };
                                window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                                window.__analyticsChangeContext.push(analyticsObj);

                                //console.log(analyticsObj);
                            
                            });
                            
                        });  
                    }
                });
                

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

    <#case "OccasionPage" >
        <@liaAddScript>
            ;(function($){
                /* Community Conversation - Link Click */
                $( ".lia-component-occasion-action-rsvp .lia-button-primary" ).on("click", function () {
                    var $this = $(this);
                    var val = $(this).text().trim();
                    var url = $(this).attr('href');

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'community conversation',
                            linkTitle: val ,
                            linkDestinationUrl: url
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);

                });    

                $( document ).ajaxComplete(function( event, xhr, settings ) {

                    var seturl = settings.url;
                    if ( seturl.indexOf("occasions/occasionpage.occasionboardrsvp") >= 0 ) {

                        $( ".lia-component-occasion-action-rsvp .lia-button-primary" ).on("click", function () {
                            var $this = $(this);
                            var val = $(this).text().trim();
                            var url = $(this).attr('href');

                            var analyticsObj = {
                                event: {
                                    eventType: 'link_click'
                                },
                                link: {
                                    linkSection: 'community conversation',
                                    linkTitle: val ,
                                    linkDestinationUrl: url
                                }
                            };
                            window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                            window.__analyticsChangeContext.push(analyticsObj);

                            //console.log(analyticsObj);

                        });    
                    }
                });

                /* Community Conversation - Registration Link Click */
                $( ".lia-occasion-description a" ).on("click", function () {
                    var $this = $(this);
                    var url = $(this).attr('href');

                    if ( url.indexOf("autodesk.zoom.us/meeting/register") >= 0 ) {
                        var analyticsObj = {
                            event: {
                                eventType: 'link_click'
                            },
                            link: {
                                linkSection: 'community conversation',
                                linkTitle: 'community event meeting registration',
                                linkDestinationUrl: url
                            }
                        };
                        window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                        window.__analyticsChangeContext.push(analyticsObj);

                        //console.log(analyticsObj);
                    }
                });    

                /* profile icon */
                $( ".lia-component-occasion-action-rsvp .UserAvatar.lia-link-navigation" ).on("click", function () {
                    var url = $(this).attr('href');

                    var analyticsObj = {
                        event: {
                            eventType: 'link_click'
                        },
                        link: {
                            linkSection: 'community conversation',
                            linkTitle: 'profile icon',
                            linkDestinationUrl: 'https://forums${envURL?js_string}.autodesk.com' + url
                        }
                    };
                    window.__analyticsChangeContext = window.__analyticsChangeContext || [];
                    window.__analyticsChangeContext.push(analyticsObj);

                    //console.log(analyticsObj);
                
                });  

            })(LITHIUM.jQuery);
        </@liaAddScript>
    <#break>

</#switch>