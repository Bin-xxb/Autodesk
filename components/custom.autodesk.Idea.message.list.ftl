<#assign board_id = http.request.parameters.name.get("id","") />
<#assign page_number = webuisupport.path.parameters.name.get( "page", 1) />
<#assign page_size = 1000 />
<#if board_id = "">
	<#assign board_id="1">
</#if>
<#-- Gets the total number of results -->
<#assign result_list_size =restadmin('boards/id/${board_id}/topics/count').value?number />
<#assign pageable_item = webuisupport.paging.pageableItem.setCurrentPageNumber(page_number).setItemsPerPage(page_size).setTotalItems(result_list_size?number).setPagingMode( "enumerated").build />
<div class="pagination"><@component id="common.widget.pager" pageableItem=pageable_item /></div>
<#assign from = (page_size * (page_number-1)) + 1 />
<#assign to = (page_size * page_number) />
<#if to?number gte result_list_size?number>
	<#assign to = result_list_size?number/>
</#if>
<label class="showpagecount">${from?number} - ${to?number} of ${result_list_size} Ideas</label> 
<#-- <label> ${result_list_size} Ideas</label> -->
</div>
<div class="MessageList lia-component-forums-widget-message-list lia-component-message-list" id="messageList_ea541444ce260c">
   <a name="message-list"> </a>
   <div class="t-data-grid thread-list">
      <table class="lia-list-wide">
         <thead id="columns_ea541444ce260c">
            <tr>
               
               <th scope="col"  class="moderatorBatchProcessingColumn lia-data-cell-tertiary lia-data-cell-checkbox">
			    <input name="bm" type="checkbox" id="check-all"value="400%3A529" title="Select All" class="select">
			   </th>
			    <th scope="col" class="threadIdColumn lia-data-cell-primary lia-data-cell-text">
                  Ideas ID
               </th>
               <th scope="col" class="threadSubjectColumn lia-data-cell-primary lia-data-cell-text">
                  Subject
               </th>
			   <th scope="col" class="threadSubjectColumn lia-data-cell-primary lia-data-cell-text">
                  Post date
               </th>
			   <th scope="col" class="threadSubjectColumn lia-data-cell-primary lia-data-cell-text">
                  Status
               </th>
			   <th scope="col" class="threadSubjectColumn lia-data-cell-primary lia-data-cell-text">
                  Comment
               </th>
            </tr>
         </thead>
         <tbody id="topic-table">
		 <#if board_id = "">
			<#assign board_id="4">
		</#if>
		 <#assign no_of_post=restadmin('boards/id/${board_id}/topics/count').value>
		 <#assign ideasList= restadmin('boards/id/${board_id}/topics?page_size=${page_size}&page=${page_number}')/>
		 <#assign response_board=restadmin('boards/id/${board_id}')>
		 <#assign board_title=response_board.board.short_title  />
		 <#assign board_name=board_title?replace(" ","-") />
		 
		 
			<#list ideasList.node_message_context.message as message>
			<#assign href1=message.@href>
				<#assign href2=message.root.@href>
				<#assign message_id=href2?substring(href2?last_index_of('/')+1,href2?length)/>
				<#assign response=restadmin('/messages/id/${message_id}/message_status')>
				<#assign resp_subject=restadmin('/messages/id/${message_id}')>
				<#assign subj = resp_subject.message.subject />
				
				<#if href1==href2 >
				
				
				<div class="${message_id}">
					<tr class="lia-list-row lia-row-odd lia-list-row-thread-readonly lia-js-data-messageUid-${message_id} lia-js-data-messageRevision-1 lia-list-row-thread-unread t-first lia-list-row-locked">
					
					   <td class="ideaCheckboxColumn lia-data-cell-tertiary lia-data-cell-checkbox">
						  <input name="bm" type="checkbox" id="${message_id}" value="400%3A529" title="Select Select a product and board to get started." class="BatchProcessing" onchange="getIndividualStatus(event)">
					   </td>
					   
					   <td class="ideaIdColumn lia-data-cell-primary lia-data-cell-text column-id">
					   <div class="UserProfileSummary1 lia-user-item lia-js-data-userId-588801 lia-user-info-group">
							 <div class="lia-user-attributes">
								<div class="lia-user-name12">
								   <h2 class="message-subject">
									  <span class="lia-message-unread1">
									  <#assign subjectresp=resp_subject.message.subject>
									  <#assign subject_link_transform0=subjectresp?replace(" ","-")>
									  <#assign subject_link_transform1=subjectresp?replace("’","-")>
									  <a class="page-link lia-link-navigation lia-custom-event" id="link_2_ea541444ce260c"    href="/t5/${board_name}/${subject_link_transform1}/idi-p/${message_id}" target="_blank" >
									 ${message_id}
									  </a>		  
									  </span>
								   </h2>
								</div>
							 </div>
						  </div>
					   </td>
					   
					   <td class="ideaSubjectColumn lia-data-cell-primary lia-data-cell-text column-subject">
						  <div class="MessageSubjectCell">
							 <div class="MessageSubject">
								<div class="MessageSubjectIcons ">
								   <h2 class="message-subject">
									  <span class="lia-message-unread">
									  <#assign subjectresp=message.subject>
									  <#assign subject_link_transform0=subjectresp?replace(" ","-")>
									  <#assign subject_link_transform1=subjectresp?replace("’","-")>
									  <a class="page-link lia-link-navigation lia-custom-event" id="link_2_ea541444ce260c" href="/t5/${board_name}/${subject_link_transform1}/idi-p/${message_id}" target="_blank" >
									  
									  ${message.subject}
									  </a>
									  </span>
								   </h2>
								</div>
							 </div>
						  </div>
					   </td>
					   <td class="ideaPostDateColumn lia-data-cell-secondary lia-data-cell-text column-postdate">
						  <div class="UserProfileSummary lia-user-item lia-js-data-userId-588801 lia-user-info-group">
							 <div class="lia-user-attributes">
								<div class="lia-user-name">
								   <span class="UserName lia-user-name lia-user-rank-Autodesk-Support">
									  
									  ${get_date_for_days_ago('${message.post_time}')}
								   </span>
								</div>
							 </div>
						  </div>
					   </td>
					   <td class="ideaStatusColumn lia-data-cell-secondary lia-data-cell-text column-status">
						  <div class="UserProfileSummary lia-user-item lia-js-data-userId-588801 lia-user-info-group">
							 <div class="lia-user-attributes">
								<div class="lia-user-name1">
								   <span class="UserName1 lia-user-name1 lia-user-rank-Autodesk-Support">
									  <div class="username_area"><span class="status_id_${message_id} ${response.message_status.id}">${response.message_status.name}</span></div>
								   </span>
								</div>
							 </div>
						  </div>
					   </td>
					   <td class="ideaCommentColumn lia-data-cell-secondary lia-data-cell-text column-comment">
						  <div class="UserProfileSummary lia-user-item lia-js-data-userId-588801 lia-user-info-group">
							 <div class="lia-user-attributes">
								<div class="lia-user-name">
								   <span class="UserName lia-user-name lia-user-rank-Autodesk-Support">
								    
									 <@component id="quick_reply" msg_id=message_id />
								   </span>
								</div>
							 </div>
						  </div>
					   </td>
					
					</tr>
					</div>
				</#if>
			</#list>
         </tbody>
      </table>
   </div>
</div>

<#function get_date_for_days_ago date>
		<#assign current_date =.now />
		<#assign current_date = current_date?iso_utc />   
		<#assign current_date= current_date />
		<#assign created_date= date />
		<#assign created_date= created_date?datetime("yyyy-MM-dd'T'HH:mm:ss")?long />
		<#assign current_date= current_date?datetime("yyyy-MM-dd'T'HH:mm:ss")?long />
		<#assign date_diff= current_date - created_date />
		<#assign time_diff= date_diff/(1000*60*60*24)?long />
		<#assign res = "" />
		<#if time_diff gt 0 && time_diff lt 30 && time_diff?round gt 1 >
			<#assign res >
			${time_diff?round} <#if time_diff?round gt 1>days<#else> day</#if> ago
			</#assign>
			<#elseif time_diff == 30>
			<#assign res >
			1 month ago 
			</#assign>
			<#elseif time_diff gt 30 && time_diff lt 365 >
			<#assign months = time_diff / 30 >
			<#assign res >
			${months?round} months ago 
			</#assign>
			<#elseif time_diff gt 365 >
			<#assign yearsago = time_diff / 365 >
			<#assign res >
			${yearsago?round}<#if yearsago == 1> year<#else>years</#if> ago 
			</#assign>
			<#else>
			<#assign minutes = time_diff * 24 *60 >
			<#if minutes lt 60 && minutes gt 0 >
			<#assign res >
			${minutes?round}<#if minutes?round gt 1> minutes<#else> minute</#if> ago
			</#assign>
			<#elseif minutes gt 60 >
			<#assign hours = minutes/60 >
			<#assign res>
			${hours?round}<#if hours?round gt 1> hours<#else> hour</#if> ago
			</#assign>
			<#else>
			<#assign res>just now</#assign>    
			</#if>
		</#if>
	<#return res>
</#function>

<style>
	.ideaIdColumn.lia-data-cell-primary.lia-data-cell-text.column-id
	{
	width:8% !important;
	}
	.ideaSubjectColumn.lia-data-cell-primary.lia-data-cell-text.column-subject{
		width:42% !important;
	}
	.ideaPostDateColumn.lia-data-cell-secondary.lia-data-cell-text.column-postdate
	{
		width:10% !important;
	}

	.ideaStatusColumn.lia-data-cell-secondary.lia-data-cell-text.column-status{
		width:15% !important;
	}
	.ideaCommentColumn.lia-data-cell-secondary.lia-data-cell-text.column-comment{
		width:15% !important;
	}

</style>


