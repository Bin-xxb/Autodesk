<#assign active_areas = usercache.get("activeAreasKey", "") />

<#if active_areas?has_content>
    <!-- active_areas was NOT null, using cached value -->
<#else>
	<#assign items_max = 5 />

	<#assign active_areas = [] /> 

	<#assign query = "select board.id, board.title, board.view_href from messages where author.id = '${user.id}' order by post_time desc limit 100"  />
	<#assign msg_items = rest("2.0", "/search?q=${query?url}").data.items![] />

	<#if msg_items?size gt 0>
		<#assign boards = {} />
		<#list msg_items as msg_item>
			<#if boards[msg_item.board.id]??>
				<#assign boards = boards + {
					"${msg_item.board.id}": {
						"total": boards[msg_item.board.id].total + 1,
						"title": msg_item.board.title,
						"view_href": msg_item.board.view_href
					}
				} />
			<#else>
				<#assign boards = boards + {
					"${msg_item.board.id}": {
						"total": 1,
						"title": msg_item.board.title,
						"view_href": msg_item.board.view_href
					}
				} />
			</#if>
		</#list>

		<#assign sorted_boards = [] />
		<#list boards as id, board>
			<#assign sorted_boards = sorted_boards + [{
				"title": board.title,
				"view_href": board.view_href,
				"total": board.total
			}] />
		</#list>

		<#assign sorted_boards = sorted_boards?sort_by("total")?reverse />
		<#assign active_areas = sorted_boards?chunk(items_max)[0] /> 

	</#if>

	<#assign active_areas = usercache.put("activeAreasKey", active_areas) />
</#if>

<div class="lia-panel lia-panel-standard custom-component-autodesk-user-active-areas">
    <div class="lia-decoration-border">
        <div class="lia-decoration-border-top">
            <div> </div>
        </div>
        <div class="lia-decoration-border-content">
            <div>
                <div class="lia-panel-heading-bar-wrapper">
                    <div class="lia-panel-heading-bar"><span class="lia-panel-heading-bar-title">${text.format('taplet.forumsTaplets.topBoardsTaplet.title')}</span></div>
                </div>
                <div class="lia-panel-content-wrapper">
                    <div class="lia-panel-content">
                        <div id="userActiveBoardLinksTaplet" class="lia-nav-list">
                            <ul class="lia-list-standard">    
                            
                            	<#list active_areas as area>
                                
                                    <li><a class="lia-link-navigation " href="${area.view_href}" target="_blank">${area.title}</a></li>

                                </#list>
                            
                            </ul>
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
