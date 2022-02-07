<#assign role_flag=false />
<#assign escalation_flag=false/>
<#assign user_roles_list= restadmin("users/id/"+ user.id +"/roles")/>
<#list user_roles_list.roles.role as role>
  <#if role.name== "Administrator">
    <#assign role_flag=true />
    <#break>
  </#if>
</#list>
  
<#if role_flag==false>
  <#attempt>
  <#assign thread_id= page.context.thread.topicMessage.uniqueId>
  <#assign topic_author = restadmin("threads/id/"+ thread_id).thread.messages.topic.author.login/>
  <#if topic_author== user.login>
    <#assign escalation_count = restadmin("threads/id/"+ thread_id +"/escalations/count").value/>
    <#if escalation_count?number gte 1>
      <#assign escalation_flag=true/>
    </#if>
  </#if>
  <#recover>
    ${.error}
  </#attempt>
</#if>
   
<@liaAddScript>
;(function($) {
  $(".ForumTopicPage .lia-form-submit.lia-button-group .lia-button-wrapper-primary.lia-button-wrapper-Submit-action").css("display","block");
  if(${escalation_flag?c}){
     $(".lia-button-Submit-action").addClass("lia-link-disabled");
  }
  
})(LITHIUM.jQuery);
</@liaAddScript>