<#assign page_number = webuisupport.path.parameters.name.get( "page", 1) />
<#assign pgURL=http.request.url/>

<#assign filter_count= http.request.parameters.name.get("filter_count","") />
<#assign filter_query = http.request.parameters.name.get("filter_query","") />
<#if filter_count != "" && filter_count?number == 1>
	<#assign page_number = 1/>
</#if>
<#assign index1=pgURL?last_index_of('/')/>
<#assign index2=pgURL?index_of('?')/>
<#assign PageNo=pgURL?substring(index1+1,index2)/>
<#if PageNo!="custom-idea-batch-processing">
<#assign page_number=pgURL?substring(index1+1,index2)?number/>
</#if>
<#assign page_size=60/>
<#assign pagination_count = 0/>
<#assign ideas_ID_list=getMessageID()>

<#assign link_count = 0/>
<#assign link_to_show_default=3/>
<#assign idea_list_length = ideas_ID_list?size />
<#assign total_length=idea_list_length/10/>
<#assign floor = total_length?floor />
<#assign ceiling = total_length?ceiling />
<#assign evenFlag = false/>
<#if floor?number lt ceiling?number >
	<#assign link_count = floor?number +1 />
<#else>
	<#assign link_count = floor?number/>	
	<#assign evenFlag = false />
</#if>

<#-- Gets the total number of results -->
 <#--<#assign result_list_size =restadmin('boards/id/${board_id}/topics/count').value?number /> -->
<#assign result_list_size =pagination_count?number />
<#assign pageable_item = webuisupport.paging.pageableItem.setCurrentPageNumber(page_number).setItemsPerPage(page_size).setTotalItems(result_list_size?number).setPagingMode( "enumerated").build />

<div class="pagination"><@component id="common.widget.pager" pageableItem=pageable_item />
<#assign from = (page_size * (page_number-1)) + 1 />
<#assign to = (page_size * page_number) />
<#-- <label>${from?number} - ${to?number} of ${result_list_size} Ideas</label> -->
<label> ${result_list_size} Ideas</label>
</div>

<div class="MessageList lia-component-forums-widget-message-list lia-component-message-list" id="messageList_ea541444ce260c">
   <a name="message-list"> </a>
   <div class="t-data-grid thread-list">
      <table class="lia-list-wide">
         <thead id="columns_ea541444ce260c">
            <tr>
               
               <th scope="col"  class="moderatorBatchProcessingColumn lia-data-cell-tertiary lia-data-cell-checkbox">
			    <input name="bm" type="checkbox" id="check-all" value="400%3A529" title="Select all ideas on this page" class="select">
			   </th>
			   <th scope="col" class="threadIdColumn lia-data-cell-primary lia-data-cell-text">
                  Ideas ID
               </th>
               <th scope="col" class="threadSubjectColumn lia-data-cell-primary lia-data-cell-text">
                  Subject
               </th>
			   <th scope="col" class="threadPostDateColumn lia-data-cell-primary lia-data-cell-text">
                  Post date
               </th>
			   <th scope="col" class="threadStatusColumn lia-data-cell-primary lia-data-cell-text">
                  Status
               </th>
			   <th scope="col" class="threadCommentColumn lia-data-cell-primary lia-data-cell-text">
                  Comment
               </th>
            </tr>
         </thead>
         <tbody id="topic-table">
			<#if board_id = "">
				<#assign board_id="4">
			</#if>
			<#assign response_board=restadmin('boards/id/${board_id}')>
			<#assign board_title=response_board.board.short_title  />
			<#assign board_name=board_title?replace(" ","-") />
		    <#assign list_counter = 1/>
                <!-- list start -->
                <#if ideas_ID_list?size gt 0>
			<#list ideas_ID_list as message_id>
				<#if message_id != "">
				<#attempt>
				<#assign response=restadmin('/messages/id/${message_id}/message_status')>
				<#assign resp_subject=restadmin('/messages/id/${message_id}')>
				
				<div class="${message_id}">
					<#if list_counter gt page_size?number>
						<tr class="lia-list-row lia-row-odd lia-list-row-thread-readonly lia-js-data-messageUid-${message_id} message-counter-${list_counter} lia-js-data-messageRevision-1 lia-list-row-thread-unread t-first lia-list-row-locked test123">
					<#else>
						<tr class="lia-list-row lia-row-odd lia-list-row-thread-readonly lia-js-data-messageUid-${message_id} message-counter-${list_counter} lia-js-data-messageRevision-1 lia-list-row-thread-unread t-first lia-list-row-locked">
					</#if>
					
					   <td class="ideaCheckboxColumn lia-data-cell-tertiary lia-data-cell-checkbox">
						  <input name="bm" type="checkbox" id="${message_id}"value="400%3A529" title="Select Select a product and board to get started." class="BatchProcessing" onchange="getIndividualStatus(event)">
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
									  <#assign subjectresp=resp_subject.message.subject>
									  <#assign subject_link_transform0=subjectresp?replace(" ","-")>
									  <#assign subject_link_transform1=subjectresp?replace("’","-")>
									  <a class="page-link lia-link-navigation lia-custom-event" id="link_2_ea541444ce260c"    href="/t5/${board_name}/${subject_link_transform1}/idi-p/${message_id}" target="_blank" >
									 ${resp_subject.message.subject}
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
									   ${get_date_for_days_ago('${resp_subject.message.post_time}')}
								   </span>
								</div>
							 </div>
						  </div>
					   </td>
					   <td class="ideaStatusColumn lia-data-cell-secondary lia-data-cell-text column-status">
						  <div class="UserProfileSummary lia-user-item lia-js-data-userId-588801 lia-user-info-group">
							 <div class="lia-user-attributes">
								<div class="lia-user-name">
								   <span class="UserName lia-user-name lia-user-rank-Autodesk-Support">
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
					<#recover>
						
					</#attempt>
				</#if>
				 <#assign list_counter = list_counter + 1/>
			</#list>
			<!-- list end-->
          </#if>
         </tbody>
      </table>
                    <#if ideas_ID_list?size == 0>
                        <div id="no-filter-result-msg">
                                <#if filter_query=="Apply">
                                    ${text.format('filter-applied-no-result-idea-batch-process-message')}
                                <#else>
                                    ${text.format('no-filter-applied-idea-batch-process-message')}
                                </#if>
                        </div>
                    </#if>
   </div>
</div>


<#function getMessageID>
	<#assign pagination_count = 0/>
	<#assign filter_idstr= http.request.parameters.name.get("filter_idstr","") />
	<#assign filter_status= http.request.parameters.name.get("filter_status","") />
	<#assign filter_vote= http.request.parameters.name.get("filter_vote","") />
	<#assign date_from=http.request.parameters.name.get("dateFromMili","") />
	<#assign date_to=http.request.parameters.name.get("dateTomMili","") />
	<#assign keyword_filter=http.request.parameters.name.get("key_filter","") />
	<#assign board_id = http.request.parameters.name.get("id","") />
	<#assign vote_condition=http.request.parameters.name.get("vote_condition","") />

	<#if keyword_filter == "">
		<#assign subject_param="" />
	<#else>
		<#assign subject_param=" subject MATCHES '${keyword_filter}' and" />
	</#if>
	<#if filter_idstr == "">
		<#assign id_param="" />
	<#else>
		<#assign id_param=" id IN('${filter_idstr}') and" />
	</#if>

	<#if filter_vote=="" >
		<#assign vote_param="" />
	<#else> 
		<#if filter_vote!="" && vote_condition=='gt_or_eq'>
			<#assign vote_param=" kudos.sum(weight)>=${filter_vote} and" />
		<#elseif filter_vote!="" && vote_condition=='lt_or_eq'>
			<#assign vote_param=" kudos.sum(weight)<=${filter_vote} and" />
		<#elseif filter_vote!="" && vote_condition=='eq'>
			<#assign vote_param=" kudos.sum(weight)=${filter_vote} and" />
		</#if>	
	</#if>


	<#if date_from == "">
		<#assign date_param="" />
	<#else>
		<#assign date_param=" post_time > ${date_from} and post_time < ${date_to} and" />
	</#if>

	<#if filter_status == "">
		<#assign status_param="" />
	<#else>
		<#assign status_param=" status.key='${filter_status}' and" />
	</#if>

	<#assign offset_to = ((page_number-1) * page_size) />
	<#assign sort_param=" and board.id='${board_id}' and depth=0 limit ${page_size} offset ${offset_to?number}"/>
	<#assign actual_param=subject_param + id_param + date_param + vote_param + status_param/>
	<#assign and_str_index = actual_param?last_index_of('and')/>
	<#if and_str_index != -1>
	<#assign actual_param = actual_param?substring(0,and_str_index)+actual_param?substring(and_str_index+3,actual_param?length)/>
	</#if>

	<#if actual_param == "">
		<#assign sort_param=" board.id='${board_id}' and depth=0 limit ${page_size} offset ${offset_to?number}"/>
		<#assign liql_str="SELECT subject,id,post_time,status,kudos.sum(weight) from messages WHERE ${sort_param}"/>
	<#else>
		<#assign liql_str="SELECT subject,id,post_time,status,kudos.sum(weight) from messages WHERE ${actual_param}${sort_param}"/>
	</#if>

	${liql_str}
	<#assign response_posts=restadmin("2.0","/search?q=" + liql_str?url) />
	 <#assign keyword_search_id_collection = []/>
	<#if response_posts.data.size?number gt 0 >
	<#list response_posts.data.items as message >
		 <#assign keyword_search_id_collection=keyword_search_id_collection+['${message.id}']>
	</#list>
	</#if>

	<#assign liql_str_count="SELECT count(*) from messages WHERE ${actual_param}${sort_param}"/>
	<#assign response_all=restadmin("2.0","/search?q=" + liql_str_count?url) />
	<#assign pagination_count = response_all.data.count?number/>

	<#return keyword_search_id_collection>
</#function>


<#function getMessageID1>
	<#assign response_posts=restadmin('boards/id/${board_id}/topics?page_size=300')>
	<#assign filter_idstr= http.request.parameters.name.get("filter_idstr","") />
	<#assign filter_status= http.request.parameters.name.get("filter_status","") />
	<#assign filter_vote= http.request.parameters.name.get("filter_vote","") />
	<#assign date_from=http.request.parameters.name.get("date_from","") />
	<#assign date_to=http.request.parameters.name.get("date_to","") />
	<#assign keyword_filter=http.request.parameters.name.get("key_filter","") />
	
	<#assign combined_after_all_filters=[] />

			<#assign status_filter_id_seq=[]>
			<#if (filter_status?length gt 0)==true >
				<#list response_posts.node_message_context.message as message >	
						  <#assign href=message.@href>
						  <#assign resp=restadmin('${href}/message_status')>
						  <#if resp.message_status.id==filter_status>
							<#assign status_filter_id_seq=status_filter_id_seq+['${message.id}']>
						</#if>
				</#list>
			</#if>


			<#assign vote_filter_id_seq=[]>
			<#if (filter_vote?length gt 0)==true >
				<#list response_posts.node_message_context.message as message >		  
						<#if message.kudos.count?number gte filter_vote?number>
							<#assign vote_filter_id_seq=vote_filter_id_seq+['${message.id}']>
						</#if>
				</#list>
			</#if>


			<#assign date_filter_id_seq=[]>



			<#if ((date_from?length gt 0)   &&  (date_to?length gt 0) )==true >
			<#assign year_from =(date_from?split('-'))[0]>
			<#assign month_from =(date_from?split('-'))[1]>
			<#assign day_from =(date_from?split('-'))[2]>

			<#assign year_to =(date_to?split('-'))[0]>
			<#assign month_to =(date_to?split('-'))[1]>
			<#assign day_to =(date_to?split('-'))[2]>


				<#list response_posts.node_message_context.message as message >		  
						  <#assign post_date_resp=message.post_time>
						  
						  <#assign post_date=post_date_resp?split('T')>
						   
						  <#assign post_date_year=(post_date[0]?split('-'))[0]>
						  <#assign post_date_month=(post_date[0]?split('-'))[1]>
						  <#assign post_date_day=(post_date[0]?split('-'))[2]>
						
						  
						  <#if (post_date_year?number gte year_from?number) && (post_date_year?number lte year_to ?number) >
						  
								<#if (post_date_year?number == year_from?number) && (post_date_year?number == year_to ?number) >
								
									<#if (post_date_month?number gte month_from?number) && (post_date_month?number lte month_to ?number) >
										
										<#if (post_date_month?number == month_from?number) && (post_date_month?number == month_to ?number)  >
										
											 <#if (post_date_day?number gte day_from?number) && (post_date_day?number lte day_to ?number) >
											
												<#assign date_filter_id_seq=date_filter_id_seq+['${message.id}']>
											 </#if>
										<#else>
										
											<#assign date_filter_id_seq=date_filter_id_seq+['${message.id}']>
										
										</#if>
									</#if>
								<#else>
									<#assign date_filter_id_seq=date_filter_id_seq+['${message.id}']>
								</#if>
								
						  </#if>
						  
						  
				</#list>
			</#if>




			<#assign combined_seq=[] />
			<#if (((filter_status?length gt 0) && (filter_vote?length gt 0) &&  ( (date_from?length gt 0) && (date_to?length gt 0) )))==true >

				
				<#list status_filter_id_seq as stat_id>
				<#if vote_filter_id_seq?seq_contains(stat_id) >
				<#assign combined_seq=combined_seq+['${stat_id}'] >
				</#if>
				</#list>

				
					
				<#assign combined_after_all_filters=[]>
				<#list date_filter_id_seq as stat_id>
				<#if combined_seq?seq_contains(stat_id) >
				<#assign combined_after_all_filters=combined_after_all_filters+['${stat_id}'] >
				</#if>
				</#list>

			
			<#elseif ( (filter_status?length gt 0) && (filter_vote?length gt 0) )==true >
				   <#assign combined_after_all_filters=[] />
				   <#list status_filter_id_seq as stat_id>
					<#if vote_filter_id_seq?seq_contains(stat_id) >
					<#assign combined_after_all_filters=combined_after_all_filters+['${stat_id}'] >
					</#if>
				   </#list>
				   
			<#elseif ( (filter_status?length gt 0) && ( (date_from?length gt 0) && (date_to?length gt 0) ) )==true >
				<#assign combined_after_all_filters=[] />
				<#list status_filter_id_seq as stat_id>
					<#if date_filter_id_seq?seq_contains(stat_id) >
					<#assign combined_after_all_filters=combined_after_all_filters+['${stat_id}'] >
					</#if>
				   </#list>
				  
			<#elseif ( ( (date_from?length gt 0) && (date_to?length gt 0) ) && (filter_vote?length gt 0) )==true >
				<#assign combined_after_all_filters=[] />
				<#list vote_filter_id_seq as stat_id>
				<#if date_filter_id_seq?seq_contains(stat_id) >
				<#assign combined_after_all_filters=combined_after_all_filters+['${stat_id}'] >
				</#if>
				  </#list>
				  
			<#elseif (filter_status?length gt 0)==true>
				<#assign combined_after_all_filters=[] />
				<#assign combined_after_all_filters= status_filter_id_seq>
				
			<#elseif (filter_vote?length gt 0)==true>
				<#assign combined_after_all_filters=[] />
				<#assign combined_after_all_filters= vote_filter_id_seq>
				
			<#elseif ( (date_from?length gt 0) && (date_to?length gt 0) )==true>
				<#assign combined_after_all_filters=[] />
				<#assign combined_after_all_filters= date_filter_id_seq>
				
			</#if>
			 
			<#assign combined_after_all_filters_idfilter=[]> 
			
			<#if (combined_after_all_filters?size gte 0) && (filter_idstr?length  gte 0 )>
			  <#assign combined_after_all_filters_idfilter=[]> 
			  <#if combined_after_all_filters?size == 0 >
				<#if (filter_status?length == 0) || (filter_vote?length == 0) >
					<#assign combined_after_all_filters_idfilter=filter_idstr?split(',')>
				<#else>
					<#assign combined_after_all_filters_idfilter=[]/>
				</#if>	
			  <#else>
				  <#assign idarray=filter_idstr?split(',')>
				  <#if idarray?size ==1 &&  idarray[0]=="" >
				  <#assign combined_after_all_filters_idfilter=combined_after_all_filters>
				  <#else>
				   <#list idarray as id_index> 
						<#if combined_after_all_filters?seq_contains(id_index)  >
						<#assign combined_after_all_filters_idfilter=combined_after_all_filters_idfilter+['${id_index}'] >
						</#if>
					</#list>
				  </#if>
			  </#if>	
			</#if>
			
			<#assign keyword_search_id_collection1 = []/>
			<#if keyword_filter?length  gt 0>
				<#assign subject = keyword_filter/>
				<#assign subject = subject?replace(" ","%20") />
				<#assign subject = subject?replace("\"","%20") />
				<#assign keyword_search_id_collection1 = getTopicsIdForKeywordSearch(keyword_filter)/>
			</#if>
			
			<#assign final_result = []/>
			<#if keyword_filter?length  gt 0>
				<#list keyword_search_id_collection1 as id_index> 
					<#if combined_after_all_filters_idfilter?seq_contains(id_index)  >
						  <#assign final_result=final_result+['${id_index}'] > 
					</#if>
					<#if filter_vote?length == 0 &&  filter_status?length == 0 && filter_status?length == 0 >
						<#assign final_result=keyword_search_id_collection1 />
					</#if>
				</#list>
			<#else>
				<#assign final_result=combined_after_all_filters_idfilter />
			</#if>
				
			<#assign sizeoffilter = combined_after_all_filters_idfilter?size/>
			<#if (keyword_filter?length  gt 0 )>
				<#list keyword_search_id_collection1 as id_index> 
					<#if combined_after_all_filters?seq_contains(id_index) || combined_after_all_filters_idfilter?seq_contains(id_index) >
						<#assign combined_after_all_filters_idfilter=combined_after_all_filters_idfilter >
					<#else>
						<#assign combined_after_all_filters_idfilter=combined_after_all_filters_idfilter+['${id_index}'] >
					</#if>
				</#list>
			</#if>
			
 	<#return final_result>
</#function>


<#function getTopicsIdForKeywordSearch keyword_filter>
	<#assign keyword_filter=http.request.parameters.name.get("key_filter","") />
	<#assign message_count=restadmin("/boards/id/${board_id}/search/messages/count").value/>
	<#-- <#assign message_count = 1000/> -->
	<#if message_count?number gt 12500 >
		<#assign message_count = 100/>
	</#if>
	<#assign liql_str="SELECT id FROM messages WHERE subject MATCHES '${keyword_filter}' and board.id='${board_id}' and depth=0 limit ${message_count}"/>
	<#-- <#assign liql_str="SELECT * FROM messages WHERE subject MATCHES '${keyword_filter}' and board.id='4' and depth=0"/> -->
	<#assign response_posts=restadmin("2.0","/search?q=" + liql_str?url) />
	<#assign keyword_search_id_collection = []/>
	<#list response_posts.data.items as message >	
		<#assign keyword_search_id_collection=keyword_search_id_collection+['${message.id}']>
	</#list>

	<#return keyword_search_id_collection />
</#function>

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

<#function getTopicsIdForKeywordSearch1 keyword_filter>
<#-- <#assign response_posts=restadmin('boards/id/${board_id}/search/messages?q=subject:testing&page_size=1000')> -->
<#assign response_posts=restadmin('boards/id/${board_id}/search/messages?q=subject:${keyword_filter}&page_size=1000')>
<#assign arr=[]>
<#list response_posts.messages.message as message >	
	<#assign len = arr?size >
		<#if len == 0>
			<#assign arr=arr+['${message.root.@href}']>
		<#else>
			<#assign bflag = false >
			<#list arr as id >	
				<#if '${message.root.@href}' == '${id}' >
					<#assign bflag = true >
					In true
				</#if>
			</#list>
			<#if bflag == false>
			<#assign href1=message.root.@href>
			<#assign href2=message.id>
			<#assign href1 = href1?substring(href1?last_index_of('/')+1,href1?length) />
			<#assign href2 = href2?substring(href2?last_index_of('/')+1,href2?length) />
			
			<#if href1 == href2>
				<#assign arr=arr+['${message.root.@href}']>
			</#if>
		</#if>	
		</#if>
	</#list>

	<#assign keyword_search_id_collection = []/>
	<#list arr as id >	
		<#assign response_message = restadmin('${id}') >
		<#assign message_id = id?substring(id?last_index_of('/')+1,id?length)/>
		 <#assign keyword_search_id_collection=keyword_search_id_collection+['${message_id}']>
	</#list>
	
	<#return keyword_search_id_collection />
</#function>

<#function getKeywordSearchCollection keyword_filter>
	<#-- For keyword search filter assign to filter_idstr start -->
		<#assign filter_idstr= http.request.parameters.name.get("filter_idstr","") />
		<#assign keyword_filter=http.request.parameters.name.get("key_filter","") />
		<#assign keyword_search_id_collection1 = []/>
		<#if keyword_filter?length  gt 0>
			<#assign subject = "KV62"/>
			<#assign subject = subject?replace(" ","%20") />
			<#assign keyword_search_id_collection1 = getTopicsIdForKeywordSearch(subject)/>
			<#if keyword_search_id_collection1?size gt 0>
				<#if filter_idstr?length gt 0 >
					<#list keyword_search_id_collection1 as key_id >
						<#if filter_idstr?index_of(key_id) == -1>
							<#assign filter_idstr = filter_idstr + "," + key_id>
						</#if>
					</#list>
				<#else>
					<#list keyword_search_id_collection1 as key_id >
						<#if filter_idstr?length == 0>
							<#assign filter_idstr = key_id>
						<#else>
							<#assign filter_idstr = filter_idstr + "," + key_id>
						</#if>
					</#list>
					<#assign index=filter_idstr?last_index_of(',')>
					<#if index != -1>
						<#assign filter_idstr=filter_idstr?substring(0,index)>
					</#if>	
				</#if>
			</#if>
		</#if>
		<#-- For keyword search filter assign to filter_idstr End -->
		<#return filter_idstr>
</#function>


<script>
	var current_Page_data_showing_counter = 1;
	var default_page_link_to_show = 10;
	var total_links = ${link_count};
	var currentCount=${link_to_show_default};
	var hidden_link =${link_to_show_default}+1;
	var idea_list_length = ${idea_list_length};
	var arr = [{showLink:".lia-link-id-"+(currentCount+1),hideLink:".lia-link-id-"+1,currentCountValue:currentCount,hiddenCount:1}];
	function navigationTo(event){
		var currentSelectedId= event.currentTarget.id;
		if(currentSelectedId == "Next"){
			currentCount = arr[0].currentCountValue;
			hidden_link = arr[0].hiddenCount; 
			if(currentCount < total_links){
				var show_id = '.lia-link-id-'+(currentCount+1);
				$(show_id).css('display','block');
				var hidden_id = '.lia-link-id-'+ hidden_link; 
				$(hidden_id).css('display','none');
				$('#Previous').removeClass('lia-link-disabled');
				arr[0].showLink = show_id;
				arr[0].hideLink = hidden_id;
				arr[0].currentCountValue = arr[0].currentCountValue + 1;
				arr[0].hiddenCount = arr[0].hiddenCount + 1;
				if(arr[0].currentCountValue == total_links){
					$('#Previous').removeClass('lia-link-disabled');
					$('#Next').addClass('lia-link-disabled');
				}else{
					$('#Previous').removeClass('lia-link-disabled');
				}
				current_Page_data_showing_counter = current_Page_data_showing_counter + 1
				//showTableData(arr[0].hiddenCount,"Next");
				//showTableData(current_Page_data_showing_counter,"Next");
			}else{
				$('#Next').addClass('lia-link-disabled');
				$('#Previous').removeClass('lia-link-disabled');
			}
		}else if(currentSelectedId == "Previous"){
			currentCount = arr[0].currentCountValue;
			hidden_link = arr[0].hiddenCount; 
			if(hidden_link > 1){
				$('.lia-link-id-'+arr[0].currentCountValue).css('display','none');
				$('.lia-link-id-'+(arr[0].hiddenCount - 1)).css('display','block');
				
				arr[0].currentCountValue = arr[0].currentCountValue - 1;
				arr[0].hiddenCount = arr[0].hiddenCount - 1;
				if(arr[0].hiddenCount == 1){
					$('#Previous').addClass('lia-link-disabled');
					$('#Next').removeClass('lia-link-disabled');
				}else{
					$('#Next').removeClass('lia-link-disabled');
				}
				current_Page_data_showing_counter = current_Page_data_showing_counter -1; 
				//showTableData(arr[0].hiddenCount,"Previous");
				//showTableData(current_Page_data_showing_counter,"Previous");
			}else{
				$('#Next').removeClass('lia-link-disabled');
				$('#Previous').addClass('lia-link-disabled');
			}
		}
		showProgress("");
	}
	
	function showTableData(counter,action){
		for(var i=1;i<=idea_list_length;i++){
			$('.message-counter-'+i).hide();
		}
		var temp = (counter-1)*default_page_link_to_show+1;
		for(var i=temp;i<=counter*default_page_link_to_show;i++){
			$('.message-counter-'+i).show();
		}
		checkUncheck();
		searchCountResult(counter);
	}
	
	function searchCountResult(counter){
		var startFrom = (counter -1 )*default_page_link_to_show;
		if(counter == 1)
			startFrom = 0;
		var endTo = counter*default_page_link_to_show;
		if(endTo > idea_list_length)
			endTo = idea_list_length;
		$('#search-result-count').text(startFrom+1 +"-"+ endTo +" of about "+ ${ideas_ID_list?size} +" ideas");
	}
	
	function getIndividualPageResult(event){
		var currentSelectedPageId= event.currentTarget.id;
		if(current_Page_data_showing_counter == Number(currentSelectedPageId))
			return;
		current_Page_data_showing_counter = Number(currentSelectedPageId);
		
		showProgress("Individual");
	}
	
	function showIndividualPageResult(){
		for(var i=1;i<=idea_list_length;i++){
			$('.message-counter-'+i).hide();
		}
		var startCounter = (current_Page_data_showing_counter - 1)*default_page_link_to_show;
		var endCounter = startCounter + default_page_link_to_show;
		
		for(var i=startCounter + 1;i<=endCounter;i++){
			$('.message-counter-'+i).show();
		}
		checkUncheck();
		searchCountResult(current_Page_data_showing_counter);
	}
	
	function checkUncheck(){
		$('.BatchProcessing').prop('checked', false);
		$('#check-all').attr('checked', false); 
	}
	
	function showProgress(action){
		$('.overlay').show();
		$("#lia-status").prop('selectedIndex',0);
		setTimeout(function(){ 
			if(action != "Individual")
				showTableData(current_Page_data_showing_counter,"Next"); 
			else
				showIndividualPageResult();
			$('.overlay').hide();	
		}, 1500);
	}
	
	$('.Idea-Status-Page .lia-component-pagesnumbered .lia-paging-full-pages .lia-custom-event').click(function(event){
		var query=getQueryParamForPagination();
		var str = event.currentTarget.href;
		var arr1 = str.split('?');
		event.currentTarget.href = arr1[0]+"?"+query;
	});

</script>

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
	.test123{
		display:none;
	}

</style> 