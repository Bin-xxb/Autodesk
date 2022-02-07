<#assign floated_msg_list = [] >
<#assign coreNodeid= 706 >
<#-- appcache for floated_msg_list-->
									<#assign queryString ="select message.id from floated_messages where message.board.id='${coreNodeid}' AND scope='global'" />
									<#assign response_floatedMsg = rest("2.0","/search?q=" + queryString?url) />
                                   <#list response_floatedMsg.data.items as msg >
										<#assign floated_msg_list = floated_msg_list + [msg.message.id]>
                                     ${msg.message.id}
									</#list>
                                  
                               
                               

  ${"size"+floated_msg_list?join(",")}
  
<@liaAddScript>
;(function($) {
  

})(LITHIUM.jQuery);
</@liaAddScript>