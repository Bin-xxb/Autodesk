<#assign page_number = webuisupport.path.parameters.name.get( "page", 1) />
<#assign filter_count= http.request.parameters.name.get("filter_count","") />
<#assign filter_query = http.request.parameters.name.get("filter_query","") />
<#if filter_count != "" && filter_count?number == 1>
	<#assign page_number = 1/>
</#if>
<#assign page_size=1000/>
<#assign pagination_count = 0/>
<#assign ideas_ID_list=0>

<#assign link_count = 0/>
<#assign link_to_show_default=3/>
<#assign idea_list_length = 0 />
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
<#assign result_list_size =0 />
<#assign pageable_item = webuisupport.paging.pageableItem.setCurrentPageNumber(page_number).setItemsPerPage(page_size).setTotalItems(result_list_size?number).setPagingMode( "enumerated").build />

<div class="pagination"><@component id="common.widget.pager" pageableItem=pageable_item />
<#assign from =  0 />
<#assign to = 0 />
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
         
      </table>             
                        <div id="no-filter-result-msg">          
                                    ${text.format('idea-batch-process-message-No-filter-applied')}
                        </div>
   </div>
</div>


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