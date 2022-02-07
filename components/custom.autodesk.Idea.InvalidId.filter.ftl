	<#assign filter_idstr= http.request.parameters.name.get("filter_idstr","") />
	<#assign board_id = http.request.parameters.name.get("id","") />
	<#assign board_id_value="2">
	<#if board_id = "">
		<#assign board_id_value="2">
	<#else>
		<#assign board_id_value=board_id>
	</#if>
	<#assign idarray=filter_idstr?split(',')>
	<#assign invalid_ID=""/>
	<#assign bflag = false />
	<#assign count = 0/>
	<#assign resp_board=restadmin('boards/id/${board_id_value}')>
	<#assign board_title_value=resp_board.board.title  />
	
	<#list idarray as message_id> 
		<#if message_id != "">
			<#attempt>
				<#assign response=restadmin('/messages/id/${message_id}/message_status')>
			<#recover>
				<#assign bflag = true/>
				<#assign count = count + 1/>
				<#if invalid_ID == "">
					<#assign invalid_ID =  message_id/>
				<#else>
					<#assign invalid_ID = invalid_ID + "," + message_id/>
				</#if>	
			</#attempt>
		</#if>	
	</#list>
	<#if bflag == true>
		<div class="custom-invalid-id">
				<#if count == 1>
					<span class="custom-invalid-meesage">The ID ${invalid_ID} doesn't belong to ${board_title_value}.</span>
				<#else>
					<span class="custom-invalid-meesage">The ID's ${invalid_ID} doesn't belong to ${board_title_value}. </span>
				</#if>
		</div>
	</#if>