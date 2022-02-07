<#assign msg_id=env.context.component.getParameter('msg_id') />

<#assign comments_count_response= restadmin('/messages/id/${msg_id}/comments/count')>
<#assign comments_count=comments_count_response.value>
<#assign recent_comment_body="" />
<#if comments_count?number==0>
<div class="lia-panel-content-wrapper-edit">
    <div class="lia-panel-content">
      <div id="community-post-edit-link-${msg_id}" "class="ActionLinksTaplet lia-nav-list">
         <span id="span-link-${msg_id}"></span>	
  	</div>
	</div>
</div>
<#else>
<#assign response= restadmin('/messages/id/${msg_id}/comments/messages?page_size=${comments_count}')>

<#list comments_count?number-1..0 as count>
<#assign recent_comment=response.messages.message[count]/>
<#assign recent_message_id=recent_comment.id />

<#assign response_recent_comment=restadmin('/messages/id/${recent_message_id}')>
<#if response_recent_comment.message.body?length gt 0 >
<#assign recent_comment_body=response_recent_comment.message.body>
  <#break>
</#if>
</#list>

<#if recent_comment_body?length==0 >
</#if>

<#assign ellipses = '...' />
<#assign str_limit = 40 />

<div class="lia-panel-content-wrapper-edit">
    <div class="lia-panel-content">
      <div id="community-post-edit-link-${msg_id}" "class="ActionLinksTaplet lia-nav-list">
	  <#assign str=recent_comment_body>
	    <#if str?lower_case?contains('<p>')==true>
			<#assign index1=str?lower_case?index_of('<p>')>
			<#assign index2=str?lower_case?index_of('</p>')>
			 <span id="span-link-${msg_id}">			 
				 <#assign truncated_str = str?substring(index1,index2) />
				 <#assign len = truncated_str?length />
				<#if len lt str_limit>
					${truncated_str?substring(0, len )?keep_before_last(" ")}
				<#else>
					${truncated_str?substring(0, str_limit)?keep_before_last(" ")}${ellipses}
				</#if>
			 </span>
		<#elseif str?contains('<BR />')==true>
				<span id="span-link-${msg_id}">${''}</span>
		<#elseif str?contains('<TABLE')>
				<span id="span-link-${msg_id}">${''}</span>
		<#else>
			<span id="span-link-${msg_id}">
				<#assign truncated_str = str />
				 <#assign len = truncated_str?length />
				<#if len lt str_limit>
					${truncated_str?substring(0, len )?keep_before_last(" ")}
				<#else>
					${truncated_str?substring(0, str_limit)?keep_before_last(" ")}${ellipses}
				</#if>
			</span>
		</#if> 
  	</div>
	</div>
</div>
</#if>

<!-- 
<div id="quick-reply-${msg_id}" class="lia-quick-reply">
	<div id="quick-reply-component" 
	<div class="lia-form-input-wrapper-edit">
	   <textarea placeholder="Enter Comment" maxlength="50" class="lia-form-body-input lia-form-type-text lia-form-input-vertical" id="lia-body_${msg_id}" style="height:47px;width:257px;name="body"></textarea>
	</div>
	<div class="lia-form-submit lia-button-group">
	   <div class="button-group-${msg_id}">
	   <span class="lia-button-wrapper lia-button-wrapper-primary lia-button-wrapper-Submit-action"><input value="Submit" name="submitContextX" type="hidden"><input title="" class="lia-button lia-button-primary lia-button-Submit-action" value="Post" id="submitContext_${msg_id}" name="${msg_id}"" type="submit" onclick="post_comment(event)"></span>
	   <span class="lia-button-wrapper lia-button-wrapper-primary lia-button-wrapper-Cancel-action"><input value="Cancel" name="submitContext_0X" type="hidden"><input title="" class="lia-button lia-button-primary lia-button-Cancel-action" value="Cancel" formnovalidate="formnovalidate" id="submitContext_1" name="${msg_id}"" type="submit"></span>
	   </div>
	</div>
</div>
-->
</div>

<script>

function post_comment(event){
	var target_element=event.target;
	var id=$(target_element).attr('name');

	var post_message=$('#lia-body_'+id).val();
	if( post_message.length==0)
	{
		alert('Blank comment not allowed');
	}
	else
	{
		var saveData = $.ajax({
					  type: 'POST',
					  dataType: "xml",
					  url: "https://forums-dev.autodesk.com/restapi/vc/messages/id/"+id+"/reply?message.body="+post_message,
					  error: function (jqXHR, exception) {
							//debugger;	
					},
					 success: function(resultData) {
						//debugger;
						$('#span-link-'+id).text(post_message);
						$($('#span-link-'+id).siblings()[0]).text('Edit');
						$('#community-post-edit-link-'+id).show();
						$('#lia-body_'+id).hide();
						$('.button-group-'+id).hide();
					}
				});
	}
}

</script>