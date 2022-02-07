<#attempt>

<#if !user.anonymous>
	<#assign escalation_flag=false/>

	<#assign thread_id= page.context.thread.topicMessage.uniqueId>
	<#assign topic_author= page.context.thread.topicMessage.author.login />
	<#if topic_author == user.login>
		<#assign escalation_count = restadmin("threads/id/"+ thread_id +"/escalations/count").value/>
		<#if escalation_count?number gte 1>
			<#assign escalation_flag=true/>
		</#if>
	</#if>

		
	<@liaAddScript>
	;(function($) {
		$(".ForumTopicPage .lia-form-submit.lia-button-group .lia-button-wrapper-primary.lia-button-wrapper-Submit-action").css("display","block");
		if(${escalation_flag?c}){
			$(".lia-button-Submit-action").addClass("lia-link-disabled");
		}
		
	})(LITHIUM.jQuery);
	</@liaAddScript>

</#if>

<#recover>
</#attempt>