<#attempt> 
	<#--
	 Intelligent Content Syndication.
	 (ICS) 2019 iTalent By Ravindra
	for #This component display source Community and source author in every message#
	-->

	<#if  page.name == "ForumTopicPage" || page.name == "TkbArticlePage" || page.name == "BlogArticlePage" || page.name == "IdeaPage">
		<#import "cross_community_macro.ftl" as macroDetails>
		<#if user.registered && !user.anonymous >
			<#if page.context.thread??>
				<#assign Thread_ID = page.context.thread.topicMessage.uniqueId>
				<@liaAddScript>
					;(function($) {
						try{

							Array.prototype.removeDuplicates = function () {
				                return this.filter(function (item, index, self) {
				                    return self.indexOf(item) == index;
				                });
				            };

							var uid_size = $('.lia-message-view-wrapper').size();
							var uids ="";
							for (var i = 0; i < uid_size; i++) {
								var tid = $('.lia-message-view-wrapper')[i].dataset.liaMessageUid;
								if(tid != "undefined" && tid != undefined && tid != "null" && tid != null){
									if (uids =="") {
										uids += tid
									} else {
										uids +=',' + tid;
									}
								}
							}

							uids = uids.split(",").removeDuplicates().join(",");
							
							if (uids != "") {
								$.ajax({
								            type: 'GET',
								            url: '${macroDetails.custom_field_url}',
								            "async": false,
								            data: {
								                "uids": uids,
								                "request_type":"source_identifier"
								            },

								            success: function(response) {
								            	//console.log(response);
								            	var json_obj = response;

									            
									            	for (var i = 0; i < json_obj.msg_custom_field_list.length; i++) {
									            	  if(json_obj.msg_custom_field_list[i].messages != ""){
									            	  	
										            		<#if page.name == "ForumTopicPage">
										            			
										            			$(".message-uid-"+json_obj.msg_custom_field_list[i].id+" .lia-message-body").before("<div class='source-identifier'>"+json_obj.msg_custom_field_list[i].messages+"</div>");
										            		
										            		<#elseif page.name == "BlogArticlePage">
										            			
										            			$(".message-uid-"+json_obj.msg_custom_field_list[i].id+" .lia-message-body").before("<div class='source-identifier'>"+json_obj.msg_custom_field_list[i].messages+"</div>");
										            		
										            		<#elseif page.name == "TkbArticlePage">
										            			if ("${Thread_ID}" != json_obj.msg_custom_field_list[i].id) {
										            				$(".lia-js-data-messageUid-"+json_obj.msg_custom_field_list[i].id+" .lia-message-body").before("<div class='source-identifier'>"+json_obj.msg_custom_field_list[i].messages+"</div>");
										            			} else {
										            				$(".lia-js-data-messageUid-"+json_obj.msg_custom_field_list[i].id+" .lia-message-body").before("<div class='source-identifier'>"+json_obj.msg_custom_field_list[i].messages+"</div>");
										            			}
										            			
										            		
										            		<#elseif page.name == "IdeaPage" >
										            			if ("${Thread_ID}" != json_obj.msg_custom_field_list[i].id) {
										            				$(".message-uid-"+json_obj.msg_custom_field_list[i].id+" .lia-message-body").before("<div class='source-identifier'>"+json_obj.msg_custom_field_list[i].messages+"</div>");
										            			} else {
										            				$(".message-uid-"+json_obj.msg_custom_field_list[i].id+" .lia-message-body").before("<div class='source-identifier'>"+json_obj.msg_custom_field_list[i].messages+"</div>");
										            			}
										            			
										            		</#if>
									            	  }	
									            	}
									            
								            },
								            error: function(response) {
								            	//console.log(response);
								            }
								        });

							}
						}//End try block 
						catch(err) {
				          console.log("error:"+ err);
				        }//End catch block
					})(LITHIUM.jQuery);
				</@liaAddScript>
			</#if>
		</#if>
	</#if>
<#recover>
	<h3 class="ics-element-donot-delete error-info" style="display: none">Error Message in source identifier: ${.error}</h3>
</#attempt>