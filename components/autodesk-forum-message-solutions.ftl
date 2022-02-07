<#-- 
** page layout context : forum message **
** conditions : Show component only if current message is topic/root-message  **
** OOB text keys used : accepted-solution.message-status.go-to.solution  **
** custom text keys used : autodesk-forum-message-solutions-label.solved-by=S olved by {0}  **
-->
<#-- BR-561 : thread condition required to handle error when user is posting new message -->
<#if page.context.thread?? >
    <#if env.context.message.uniqueId==page.context.thread.topicMessage.uniqueId>
        <#assign queryString="SELECT id, view_href, author FROM messages where topic.id='${env.context.message.uniqueId}' and is_solution=true" />
        <#assign response_solutions=rest( "2.0", "/search?q=" + queryString?url) />
        <#if response_solutions.data.size?number gt 0>
			<div class="custom-component-autodesk-forum-message-solutions">					
				<#list response_solutions.data.items as sol>
					<div class="lia-panel-feedback-banner-safe">	
						<p>
							${text.format('autodesk-forum-message-solutions-label.solved-by',"<a href='${sol.author.view_href}'>${sol.author.login}</a>")}.							
							<a class="lia-link-navigation accepted-solution-link" href="${sol.view_href}">${text.format('accepted-solution.message-status.go-to.solution')}</a>
						</p>
					</div>
				</#list>				
			</div>			
        </#if>
    </#if>
</#if>
