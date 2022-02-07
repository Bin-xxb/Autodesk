<#attempt>
	<#--
	 Intelligent Content Syndication.
	 (ICS) 2019 iTalent By Ravindra
	for #This component displays syndication icon in the target/syndicated messages(Thread's and Reply's)#
	-->

	<#if  page.name == "ForumTopicPage" || page.name == "TkbArticlePage" || page.name == "BlogArticlePage" || page.name == "IdeaPage" || page.name == "TkbPage" || page.name == "TkbCommunityPage" ||  page.name == "TkbCategoryPage" || page.name == "ForumPage" || page.name == "BlogPage" || page.name == "IdeaExchangePage" || page.name == "SearchPage">

      <#-- moved the css into skin scss
      <link rel="stylesheet" type="text/css" href='${asset.get("/html/assets/ics.css")}' integrity="sha384-YteOMvjZpBphISfTOUQhFt6YfSJPFC1qGuMEhgIqWywRM3kMmYnj3bE3IwFFdsjm" crossorigin="anonymous">
      -->
		<#import "cross_community_macro.ftl" as macroDetails>

		<@liaAddScript>
			var mbasMessagesIconDetails = "";
	        function processSyndicatedData(res){
	            ;(function($) {
	                var quiltObj = getQuiltDetails();
	                var iconDetails = {};
	            	var iconDetailsArray =[];
	                if (quiltObj.isQuilt == true) {
	                    var uids = getmessageIds(quiltObj.get_ids_class);
	                    var resMsgArray = res.msg_custom_field_list;
	                 
	                    if(uids != ""){
	                    	uids.split(",").map(msgId => {
								var result = resMsgArray.filter(obj => {
								  return obj.id === msgId
								});
								if(result != "" && result != null && result != undefined ){
									iconDetailsArray.push(result[0]);
								}
							});
							iconDetails.msg_custom_field_list = iconDetailsArray;
							appendSyndicationIcons(iconDetails, quiltObj.add_custom_data_class,  quiltObj.reply_add_custom_data_class, quiltObj.quiltName);
	                	}   	
	                }
	            })(LITHIUM.jQuery);
	        }

			function showSyndicationIcon(){
	            <#if page.name == "ForumPage">
	                ;(function($) {
	                    try {
	                        if(mbasMessagesIconDetails == ""){ 
	                            $.ajax({
	                                type: 'GET',
	                                url: '${macroDetails.custom_field_url}',
	                                data: {
	                                    "uids": "",
	                                    "request_type":"syndcation_icon",
	                                    "boardID":"${coreNode.id}"
	                                },
	                                success: function(response) {
	                                    mbasMessagesIconDetails = response;
	                                    //setTimeout(processSyndicatedData, 1000, response);
	                                    processSyndicatedData(response);
	                                },
	                                error: function(response) {     
	                                }
	                            });
	                        } else {
	                            setTimeout(processSyndicatedData, 2000, mbasMessagesIconDetails);
	                        }
	                    }//End try block 
	                    catch(err) {
	                        console.log(err);
	                    }//End catch blockw
	                })(LITHIUM.jQuery);
	            </#if>
			}

			function getmessageIds(getMessageIdClassName){
				var uids = "";
				;(function($) {
				
				var get_id_length = $(getMessageIdClassName).length;
				//get all messages id's
				for (var j = 0; j < get_id_length; j++) {
				  <#if page.name == "TkbPage" || page.name == "TkbCommunityPage" ||  page.name == "TkbCategoryPage" || page.name == "ForumPage" || page.name == "BlogPage" || page.name == "IdeaExchangePage" >
					 var thref = $(getMessageIdClassName)[j].getAttribute('href');
					 
						if(thref.match(/.*\/td-p\/(\d+)/)){
							//forum page
							var result = thref.match(/.*\/td-p\/(\d+)/);
						}else if(thref.match(/.*\/m-p\/(\d+)/)){
							//forum page
							var result = thref.match(/.*\/m-p\/(\d+)/);
						}else if(thref.match(/.*\/ba-p\/(\d+)/)){
							//blog page
							var result = thref.match(/.*\/ba-p\/(\d+)/);
						}else if(thref.match(/.*\/idi-p\/(\d+)/)){
							//idea page
							var result = thref.match(/.*\/idi-p\/(\d+)/);
						}else{
							// TKB page
							var result = thref.match(/.*\/ta-p\/(\d+)/);
						}
						
						if(result != "" && result != null && result != undefined){
							var tid = result[1];
							if(tid != "undefined" && tid != undefined && tid != "null" && tid != null){
								if (uids == "") {
									uids += tid;
								}else{
									uids +=',' + tid ;
								}
							}
						}

				  <#elseif page.context.thread??>
						<#assign Thread_ID = page.context.thread.topicMessage.uniqueId />
						var tid = $(getMessageIdClassName)[j].dataset.liaMessageUid;
						if(tid != "undefined" && tid != undefined && tid != "null" && tid != null){
							if (uids == "") {
								uids += tid;
							} else {
								uids +=',' + tid;
							}
						}	

				  <#elseif page.name == "SearchPage">
						var tid = $(getMessageIdClassName)[j].dataset.liaMessageUid;
						if(tid != "undefined" && tid != undefined && tid != "null" && tid != null){
							if (uids == "") {
								uids += tid;
							} else {
								uids +=',' + tid;
							}
						}
							
				  </#if>
				}

				uids = [...new Set(uids.split(","))];
				})(LITHIUM.jQuery);
				return uids.join(",");
			}

			function getsyndicationIconDetails(MessageIds, boardID){

				var res="";
				;(function($) {
				if(MessageIds != "" || boardID != ""){
					$.ajax({
		            type: 'GET',
		            url: '${macroDetails.custom_field_url}',
		            "async": false,
		            data: {
		                "uids": MessageIds,
		                "request_type":"syndcation_icon",
		                "boardID":boardID
		            },

		            success: function(response) {
		            	//console.log(response);
		            	res = response;
		            },
		            error: function(response) {
		            	//console.log(response);
		            }
		    	});
				}
				})(LITHIUM.jQuery);
		    	return res;
			}

			function appendSyndicationIcons(jsonObj, classThreadLevel, classReplyLevel,quiltName){
				;(function($) {
				if(jsonObj != ""){
					$('.syndcation-message-icon').remove();
					for (var i = 0; i < jsonObj.msg_custom_field_list.length; i++) {
							            		
		        		var metadata_value = jsonObj.msg_custom_field_list[i].messages;
		        		var messages_id = jsonObj.msg_custom_field_list[i].id;
		        		var messageOriginType = jsonObj.msg_custom_field_list[i].messageOriginType;
		        		var sourceIconType = jsonObj.msg_custom_field_list[i].sourceIconType;
		        		
		        		// The message is target then will display the syndication icon
			          	if(messageOriginType == "target" || (messageOriginType == "source" && sourceIconType != "")){

			          		<#--Start: preparing syndication icon content -->
			          		<#-- var a_tag = document.createElement("a");
			          		a_tag.setAttribute("href","javascript:void(0)")
			          		a_tag.setAttribute("class" , "syndcation-message-icon-anchor");
			          		a_tag.setAttribute("tabindex","-1"); -->

			          		var icon = document.createElement("img");
							icon.setAttribute("class" , "syndcation-message-icon");
							
							if(messageOriginType == "target"){
								icon.setAttribute("alt","Syndicated - Inbound");
								icon.setAttribute("title","Syndicated - Inbound");
								icon.setAttribute("src","/html/assets/ics-data-transfer-img.png");
							}else if(messageOriginType == "source"){
								if(sourceIconType == "partialSyndication"){
									icon.setAttribute("alt","Partially syndicated - Outbound");
									icon.setAttribute("title","Partially syndicated - Outbound");
									icon.setAttribute("src","/html/assets/ics-partial-syndication-img.png");
								}else if(sourceIconType == "fullSyndication"){
									icon.setAttribute("alt","Syndicated - Outbound");
									icon.setAttribute("title","Syndicated - Outbound");
									icon.setAttribute("src","/html/assets/ics-fully-syndication-img.png");
								}
							}
				
							<#-- a_tag.append(icon); -->
							<#--End: preparing syndication icon content -->
          		
			          		<#if page.name == "TkbPage" || page.name == "TkbCommunityPage" ||  page.name == "TkbCategoryPage" || page.name == "ForumPage" || page.name == "IdeaExchangePage">
			          			if(quiltName == "forum-page" || quiltName == "tkb-page" || quiltName == "idea-exchange-page"){
			          				$(".lia-js-data-messageUid-"+messages_id+" "+classThreadLevel).prepend(icon);
			          			}else{
			          				$(classThreadLevel)[i].prepend(icon);
			          			}
			          		<#elseif  page.name == "BlogPage">
			          			var div_tag = document.createElement("span");
			          			div_tag .style.display = "inline-block";
			          			div_tag.append(icon);
			          			$(classThreadLevel)[i].before(div_tag);
			          		<#elseif page.name == "SearchPage">
			          			$(".lia-js-data-messageUid-"+messages_id+" "+classThreadLevel).prepend(icon);
			          		
			          		<#else>
			          			<#if page.context.thread??>
												<#assign Thread_ID = page.context.thread.topicMessage.uniqueId />
											<#else>
												<#assign Thread_ID = ""/>
											</#if>
					     				if("${Thread_ID}" != messages_id){
					     					$(".message-uid-"+messages_id+" "+classReplyLevel).prepend(icon);
					     				}else{
					     					$(classThreadLevel)[i].prepend(icon);
					     				}
					     			</#if>
			          	}
		        	}//for loop end
		        }
		        })(LITHIUM.jQuery);
			}

			function getQuiltDetails(){
				var details = {"isQuilt":false};
				;(function($) {
				
				var quiltObj = JSON.parse('${macroDetails.syndication_icon_quiltObj?string}');
				for (var i = 0; i < quiltObj.length; i++) {

					if ($(".lia-quilt-"+quiltObj[i].quilt_name).length > 0) {
						details.isQuilt = true;
						details.get_ids_class = quiltObj[i].get_ids_class;
						details.add_custom_data_class = quiltObj[i].add_class;
						details.reply_add_custom_data_class = quiltObj[i].reply_add_class;
						details.quiltName = quiltObj[i].quilt_name;
					}
				}
				})(LITHIUM.jQuery);
				return details;
			}

			;(function($) {
				try {
					$( window ).load(function() {
					  syndicationIcon();
					});

					<#if page.name == "SearchPage">
						$("body").on('DOMNodeInserted', function(event) {
							if($(event.target).hasClass("lia-message-search-container") && $(event.target).hasClass("lia-component-search-widget-message-search")){
								syndicationIcon();
							}
						});
					</#if>
					function syndicationIcon(){
						try {
							var quiltObj = getQuiltDetails();

							if (quiltObj.isQuilt == true) {
								var uids = getmessageIds(quiltObj.get_ids_class);
								
								var iconDetails = getsyndicationIconDetails(uids,"");

								appendSyndicationIcons(iconDetails, quiltObj.add_custom_data_class,  quiltObj.reply_add_custom_data_class, quiltObj.quiltName);	
							}
						
						}//End try block 
						catch(err) {
				          console.log(err);
				        }//End catch block
					}
				}//End try block 
				catch(err) {
		          console.log(err);
		        }//End catch block	
			})(LITHIUM.jQuery);
		</@liaAddScript>
	</#if>
<#recover>
	<h3 class="ics-element-donot-delete error-info" style="display: none">Error Message in icons: ${.error}</h3>
</#attempt>