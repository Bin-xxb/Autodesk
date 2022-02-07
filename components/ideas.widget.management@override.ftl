<@delegate />
<#assign href_url="" />
<#assign category_id=""/>
<#if page.name=="IdeaExchangePage">
    <#assign category_id=coreNode.ancestors[0].id />
    <#if category_id== community.id>  
        <#assign href_url="/t5/forums/postpage/choose-node/true?interaction_style=idea&amp;catId=&amp;boardId=${coreNode.id}" />
    <#else>
        <#assign queryString="select parent_category.id from boards where id='${coreNode.id}'">
          <#assign response_cat_id_response=restadmin("2.0","/search?q=" + queryString?url) />
          <#if response_cat_id_response.data.items[0].parent_category??==true>
              <#assign response_cat_id=response_cat_id_response.data.items[0].parent_category.id />
              <#assign readonly = restadmin("/boards/id/${coreNode.id}/settings/name/config.read_only").value?string />
              <#assign href_url="/t5/forums/postpage/board-id/${coreNode.id}?interaction_style=${page.interactionStyle}&catId=${response_cat_id}&boardId=${coreNode.id}">
              <#if readonly == "true">
              <#assign href_url="/t5/forums/postpage/choose-node/true?interaction_style=${page.interactionStyle}&catId=&boardId=&preBoardId=">
            </#if>
        </#if>
    </#if>
<#elseif page.name=="IdeaPage">
    <#assign category_id=coreNode.ancestors[0].id />
    <#assign board_id=page.context.thread.board.id />
    <#if category_id== community.id>
      	 <#assign board_id=page.context.thread.board.id />
        <#assign href_url="/t5/forums/postpage/choose-node/true?interaction_style=idea&amp;catId=${category_id}&amp;boardId=${board_id}" />
    <#else>
        <#assign queryString="select parent_category.id from boards where id='${coreNode.id}'">
          <#assign response_cat_id_response=restadmin("2.0","/search?q=" + queryString?url) />
          <#if response_cat_id_response.data.items[0].parent_category??==true>
              <#assign response_cat_id=response_cat_id_response.data.items[0].parent_category.id />
              <#assign readonly = restadmin("/boards/id/${coreNode.id}/settings/name/config.read_only").value?string />
              <#assign href_url="/t5/forums/postpage/board-id/${coreNode.id}?interaction_style=${page.interactionStyle}&catId=${response_cat_id}&boardId=${coreNode.id}">
              <#if readonly == "true">
              <#assign href_url="/t5/forums/postpage/choose-node/true?interaction_style=${page.interactionStyle}&catId=&boardId=&preBoardId=">
              </#if>
          </#if>
    </#if>
</#if>
            
<#assign bflag = 'false'/>
<#assign roles_response=restadmin('/users/id/${user.id}/roles')>
<#list roles_response.roles.role as role>
	<#if role.name=="Idea Exchange" || role.name=="Administrator" || role.name == "Idea Exchange Admin">
		<#assign bflag='true'>
	</#if>
</#list>
<#assign filterid="" />
<#assign board_id=""  />  
<#if user.anonymous == false>
	<#assign board_name=coreNode.shortTitle />
	<#assign board_id=coreNode.id />
	<#assign resp=restadmin('/boards/id/${board_id}/message_statuses/available')>
	<#assign filterid="">
	<#list resp.message_statuses.message_status as msg_status>
		<#assign filterid=msg_status.id>
		 <#break>
	</#list>
</#if>
<@liaAddScript>
  
;(function($){
  insertLink();	
  $('#batchProcess').on('click',function(){
    //debugger;
  var arr = window.location.href.split("/");
    var filter_id="${filterid}";
  var hostName = arr[0] + "//" + arr[2]; 
  window.open(hostName+"/t5/custom/page/page-id/custom-idea-batch-processing?id=${board_id}&filter_id="+filter_id+"&filter_query=filter","_blank");
  });
  
  function insertLink(){
	var bflag = ${bflag};
	if(bflag == true){
		$('.IdeaExchangePage .BoardManagementTaplet .lia-list-standard').append('<li><a class="lia-link-navigation batch-process-link" id="batchProcess">Idea Batch Processing</a></li>');
	}
  }
  
    $(".BoardManagementTaplet.lia-nav-list .lia-list-standard a.article-post-link").attr("href","${href_url}");   
})(LITHIUM.jQuery);
</@liaAddScript>
    
 