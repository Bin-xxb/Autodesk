<#assign member_list = restadmin("/groups/id/"+ coreNode.id +"/members?page_size=1000")/>
<#assign flag=false/>
<#list member_list.users.user as member_list_id>
  <#if user.id?string == member_list_id.id>
    <#assign flag=true/>
    <#break>
  </#if>
</#list>
  
<@liaAddScript>
;(function($) {
  
  //debugger;
  var is_anonymous = ${user.anonymous?c};
  if(is_anonymous){
     $('.lia-menu-bar-buttons').css("display","none");
  }
  
  if(!is_anonymous){
     if(${flag?c}){
      $('.message-post').css("display","block");
    }
    else{
   	 $('.join-group-link').css("display","block");
     $('.lia-group-action-menu').css("display","none");
   }
  }
})(LITHIUM.jQuery);
</@liaAddScript>