<#compress>
<#attempt>
<#assign parents = coreNode.ancestors />
<#if parents?size gt 0>   
	<#assign grouphubID = parents[0].id>
	<#assign nodeData = [] />
	<#assign query = "SELECT id, short_title, conversation_style, view_href FROM nodes WHERE parent.id = 'grouphub:${grouphubID}'" />
	<#assign children= restadmin("2.0", "/search?q=" + query?url).data.items![] />
	<#list children as child>
		<#assign topicQuery = "SELECT id FROM messages WHERE node.id = '${child.id}' AND depth = 0" />
		<#assign topicSize = restadmin("2.0", "/search?q=" + topicQuery?url).data.size?c />
		<#assign data = {
			"title": child.short_title,
			"type": child.conversation_style,
			"topics": topicSize,
			"link": child.view_href
		} />
		<#assign nodeData = nodeData + [data] />
	</#list>
	<#if nodeData?has_content>
		<li:nodes-nodes-summary class="lia-limuirs-comp lia-component-nodes-widget-nodes-summary"
		data-lia-limuirs-hydrated="true">
			<div class="lia-panel lia-panel-standard">
				<div class="lia-decoration-border">
					<div class="lia-decoration-border-content">
						<div>
							<div class="lia-panel-heading-bar-wrapper">
								<div class="lia-panel-heading-bar">
									<span role="heading" aria-level="4" class="lia-panel-heading-bar-title">
										${text.format('li.nodes.NodesSummary.contents')}
									</span>
								</div>
							</div>
							<div class="lia-panel-content-wrapper">
								<div class="lia-panel-content">
									<ul class="lia-list-standard">
										<#list nodeData as data>
										<li class="lia-summary-view-item">
											<a href="${data.link}" class="lia-link-navigation">
												<span class="lia-node-summary-title">
													${data.title}
												</span>
												<span class="lia-node-summary-count">
													<i class="lia-fa lia-fa-${data.type} lia-img-icon-${data.type}-board">
													</i>
													${data.topics}
												</span>
											</a>
										</li>
										</#list>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</li:nodes-nodes-summary>
	</#if>
</#if> 
<#recover>
</#attempt>
</#compress>
