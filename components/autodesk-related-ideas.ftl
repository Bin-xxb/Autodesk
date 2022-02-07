<#import "autodesk.common.lib.macros.ftl" as autodesk_macro>

<#--
autodesk-related-ideas-label.related-ideas = Related ${general.message@place:idea}
-->
<#assign nodeId = coreNode.id />
<#assign 
    topic_id = page.context.thread.topicMessage.uniqueId?number 
    topic_subject = page.context.thread.topicMessage.subject?string
/>
<#-- replace apostrophe with enoced value -->
 <#assign topic_subject = topic_subject?replace("'","%27")/>
  <#assign topic_subject = topic_subject?replace('"',"%22")/>

<#assign 
    messages = autodesk_macro.getRelatedTopics({
        "topicSubject":"${topic_subject}",
        "topicId"   :"${topic_id}",
        "location"   :"board",
        "locationId" :"'${nodeId}'",
        "pageSize"  :5
    }) 
	
/>
<#if (messages?size > 0) >
<#-- Right Rail component template/DOM integrated -->	
	<div class="lia-panel lia-panel-standard custom-component-related-ideas">
		<div class="lia-decoration-border">
			<div class="lia-decoration-border-top">
				<div> </div>
			</div>
			<div class="lia-decoration-border-content">
				<div>
					<div class="lia-panel-heading-bar-wrapper">
						<div class="lia-panel-heading-bar">
							<span class="lia-panel-heading-bar-title">${text.format('autodesk-related-ideas-label.related-ideas')}</span>
						</div>
					</div>
					<div class="lia-panel-content-wrapper">
						<div class="lia-panel-content">
							<!-- Below replace Id with your component id with sufix of Taplet -->
							<div id="relatedIdeasLinks" class="lia-nav-list">
								<@autodesk_macro.slim_messages_list messages=messages optionsHash={"subjectMaxLength":80} />
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="lia-decoration-border-bottom">
				<div> </div>
			</div>
		</div>
	</div>
	
</#if>