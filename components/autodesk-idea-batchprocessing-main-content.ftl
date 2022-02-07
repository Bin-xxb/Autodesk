<#assign roleFlag = false/>
<#assign roles_response=restadmin('/users/id/${user.id}/roles')>
<#list roles_response.roles.role as role>
	<#if role.name=="Idea Exchange" || role.name=="Administrator" || role.name == "Idea Exchange Admin">
		<#assign roleFlag=true/>
	</#if>
</#list>
<#if roleFlag == false>
	<div class="exception-page-message UserDoesNotHavePermissionException lia-panel-feedback-banner-alert lia-component-content">
	<div class="lia-text error-description">
		${text.format('idea-batch-process-permission-msg')}
	</div>
	<div class="lia-text">
		<a class="lia-link-navigation previous-page-link lia-js-referer-link" id="link_0" href="/t5/custom/page/page-id/Discussions-Page">${text.format('idea-batch-process-return-label')}</a>
	</div>
</div>
<#else>

<#assign filter_query = http.request.parameters.name.get("filter_query","") />
<#assign board_id = http.request.parameters.name.get("id","") />
<#assign filter_id =  http.request.parameters.name.get("filter_id","") />
<#if board_id = "">
	<#assign board_id_value="2">
<#else>
	<#assign board_id_value=board_id>
</#if>
<#assign resp_board=restadmin('boards/id/${board_id_value}')>
<#assign board_title_value=resp_board.board.title  />

<div class="container" style="display:inline-block">
	<div class="lia-node-header-title1"><span> ${board_title_value} <span>  </div>
	<div class="info-messages">
	<@component id="custom.autodesk.Idea.InvalidId.filter" />
	</div>
	
</div>
<div class="AdvancedThreadSearchForm " id="advancedThreadSearchForm" style="background-color:#fff;">
    <div class="lia-panel custom-filter">
		<div class="lia-node-header-boxes"> ${text.format('idea-batch-process-filter-label')}  </div>
        <div class="lia-panel-content-wrapper" style="display:visible" id="advancedSearchPanel_content">
            <div class="lia-panel-content">
                <form enctype="multipart/form-data" class="lia-form lia-form-vertical lia-form-footer-outside-fieldset AdvancedThreadSearchForm"
                    action="https://forums-dev.autodesk.com/t5/forums/searchpage.messagesearch.advancedthreadsearchform.form.form.form"
                    method="post" id="form_1" name="form_1">
                    <div class="t-invisible"><input value="tab/message/q-p/YWR2YW5jZWRTZWFyY2g6dHJ1ZTo6ZmlsdGVyOmxhYmVscw.." name="t:ac" type="hidden">
                        <input value="search/contributions/messagesearchcontributionspage" name="t:cp" type="hidden">
                        <input
                            type="hidden"></div>
                    <div class="lia-inline-ajax-feedback">
                        <div class="AjaxFeedback" id="feedback_1"></div>
                    </div>
                    <div class="lia-inline-ajax-feedback">
                        <div class="AjaxFeedback" id="feedback_1"></div>
                    </div>
                    <input value="58y2MfpBlLMRBCllVTuuHpvxZvxWT8dmenlIJfKuBZ_uLhdWdHk4vL36ebvp-8kV" name="lia-action-token" type="hidden">
                    <input value="form_1" id="form_UID" name="form_UID" type="hidden">
                    <input value="" id="form_instance_key" name="form_instance_key" type="hidden">
					<div class="lia-input-edit-form-row-main">
						<div class="lia-quilt-row lia-quilt-row-standard lia-input-edit-form-row lia-quilt-row-first">
							<div class="lia-quilt-column lia-quilt-column-24 lia-quilt-column-single lia-input-edit-form-column">
								<div class="lia-quilt-column-alley lia-quilt-column-alley-single">
									<div class="lia-form-row lia-form-phrase-entry">
										<div class="lia-form-label-wrapper" style="padding-bottom:5px;">
											<label for="lia-phrase" class="lia-form-label">${text.format('idea-batch-process-keyword-search-label')}</label>
										</div>
										<div class="lia-quilt-row lia-quilt-row-standard">
											<div class="lia-quilt-column lia-quilt-column-16 lia-quilt-column-single">
												<div class="lia-quilt-column-alley lia-quilt-column-alley-single">
													<div class="lia-form-input-wrapper">
														<input class="custom-textinput" id="keyword-box" name="phrase" type="text">
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="lia-quilt-row lia-quilt-row-standard lia-input-edit-form-row lia-quilt-row-center">
							<div class="lia-quilt-column lia-quilt-column-12 lia-quilt-column-left lia-input-edit-form-column">
								<div class="lia-quilt-column-alley lia-quilt-column-alley-left">									
									<div class="lia-form-row lia-form-phrase-entry">
										<div class="lia-form-label-wrapper" style="padding-bottom:5px;">
											<label for="lia-phrase" class="lia-form-label">${text.format('idea-batch-process-id-label')}</label>${text.format('idea-batch-process-multiple-id-label')}
										</div>
										<div class="lia-quilt-row lia-quilt-row-standard">
											<div class="lia-quilt-column lia-quilt-column-16 lia-quilt-column-single">
												<div class="lia-quilt-column-alley lia-quilt-column-alley-single">
													<div class="lia-form-input-wrapper">
														<input class="custom-textinput" id="idea-box" name="phrase" type="text">
													</div>
												</div>
											</div>
										</div>
									</div>
									
									
									 <div class="lia-form-row lia-form-one-or-more-entry">
										<div class="lia-form-label-wrapper" style="padding-bottom:5px;" >
											<label for="lia-oneOrMore" class="lia-form-label">${text.format('idea-batch-process-filter-by-label')}</label>
										</div>
										<div class="lia-form-input-wrapper">
											<select class="lia-form-status-input" id="lia-status-filter-by" name="status">
												<option title="New Idea" value="-1" id="23">${text.format('idea-batch-process-select-status-label')}</option>	
												<#assign status_response=restadmin('/boards/id/${board_id_value}/message_statuses/available')>
												<#list status_response.message_statuses.message_status as message_status>
													<option title="New Idea" value="${message_status.key}" id="${message_status.id}">${message_status.name}</option>
												</#list>	
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="lia-quilt-column lia-quilt-column-12 lia-quilt-column-right lia-input-edit-form-column">
								<div class="lia-quilt-column-alley lia-quilt-column-alley-right">
									<div class="lia-form-row lia-form-search-type-entry" style="min-height:50px;">

										<div class="lia-quilt-row lia-quilt-row-standard lia-input-edit-form-row lia-quilt-row-first lia-quilt-row-last">
											<div class="lia-quilt-column lia-quilt-column-24 lia-quilt-column-single lia-input-edit-form-column">
												<div class="lia-quilt-column-alley lia-quilt-column-alley-single">
													<div class="lia-form-row lia-form-filter-date-range-entry date-range-editor">
														<div class="lia-form-label-wrapper" style="padding-bottom:5px;" >
															<label for="lia-searchType" class="lia-form-label">${text.format('idea-batch-process-date-created-label')}</label>
														</div>
														<div class="lia-datepicker">
															<@component id="custom.autodesk.Idea.DatePicker" />
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="lia-form-row lia-form-search-results-size-entry" style="display:flex;flex-direction: column;">
										<div class="lia-form-label-wrapper" style="padding-bottom:5px;" >
											<label for="lia-searchResultsSize" class="lia-form-label">${text.format('idea-batch-process-votes-label')}</label>
												<span class="votes-radio"><input type="radio" id="radio_gt_or_eq" name="vote_filter" value="gt_or_eq">${text.format('idea-batch-process-gteq-label')}</span> 
												<span class="votes-radio"><input type="radio" id="radio_eq" name="vote_filter" value="eq">${text.format('idea-batch-process-eq-label')}</span>
												<span class="votes-radio"><input type="radio" id="radio_lt_or_eq" name="vote_filter" value="lt_or_eq">${text.format('idea-batch-process-lteq-label')}</span>
											</div>
										<div style="display:inline-flex;">
											<div class="lia-form-input-wrapper" style="width: 284px;
	">
												<input class="custom-textinput" id="vote-box" name="phrase" type="text">
											</div>
										</div>
									</div>

								</div>
							</div>
						</div>
						<div class="lia-quilt-row lia-quilt-row-standard lia-input-edit-form-row lia-quilt-row-last custom-filter-buttons">
							<div class="lia-quilt-column lia-quilt-column-24 lia-quilt-column-single lia-input-edit-form-column">
								<div class="lia-quilt-column-alley lia-quilt-column-alley-single">
									<div class="lia-form-input-wrapper">
										<span class="lia-button-wrapper lia-button-wrapper-primary lia-button-wrapper-Submit-action"><input value="Submit" name="submitContextX" type="hidden"><input title="" class="lia-button lia-button-primary lia-button-Submit-action" value="${text.format('idea-batch-process-filter-button-label')}" id="filter-button" name="submitContext" type="button"></span>
									</div>
								</div>
							</div>
						</div>
					</div>
                </form>
				
            </div>
        </div>
    </div>
</div>

<div class="Common-Comment-section custom-comment" id="common-comment" >
    <div class="lia-panel ">
		<div class="lia-node-header-boxes"> ${text.format('idea-batch-process-action-label')}</div>
        <div class="lia-panel-content-wrapper" style="display:visible" id="advancedSearchPanel_content">
            <div class="lia-panel-content">
                <form enctype="multipart/form-data" class="lia-form lia-form-vertical lia-form-footer-outside-fieldset AdvancedThreadSearchForm"
                    
                    id="form_1" name="form_1">
                    <div class="t-invisible"><input value="tab/message/q-p/YWR2YW5jZWRTZWFyY2g6dHJ1ZTo6ZmlsdGVyOmxhYmVscw.." name="t:ac" type="hidden">
                        <input value="search/contributions/messagesearchcontributionspage" name="t:cp" type="hidden">
                        <input
                            type="hidden"></div>
                    <div class="lia-inline-ajax-feedback">
                        <div class="AjaxFeedback" id="feedback_1"></div>
                    </div>
                    <div class="lia-inline-ajax-feedback">
                        <div class="AjaxFeedback" id="feedback_1"></div>
                    </div>
                    <input value="58y2MfpBlLMRBCllVTuuHpvxZvxWT8dmenlIJfKuBZ_uLhdWdHk4vL36ebvp-8kV" name="lia-action-token" type="hidden">
                    <input value="form_1" id="form_UID" name="form_UID" type="hidden">
                    <input value="" id="form_instance_key" name="form_instance_key" type="hidden">
                    <div class="lia-quilt-row lia-quilt-row-standard lia-input-edit-form-row lia-quilt-row-first lia-quilt-row-last">
                        <div class="lia-quilt-column lia-quilt-column-12 lia-quilt-column-left lia-input-edit-form-column">
                            <div class="lia-quilt-column-alley lia-quilt-column-alley-left">
                                <div class="lia-form-row lia-form-phrase-entry">
                                    <div class="lia-form-label-wrapper" style="padding-bottom:5px;" >
                                        <label for="lia-phrase" class="lia-form-label">${text.format('idea-batch-process-comment-label')}</label>${text.format('idea-batch-process-char-limit-label')}

                                    </div>
                                    <div class="lia-quilt-row lia-quilt-row-standard">
                                        <div class="lia-quilt-column lia-quilt-column-CommentText lia-quilt-column-single">
                                            <div class="lia-quilt-column-alley lia-quilt-column-alley-single">
                                                <div class="lia-form-input-wrapper custom-text-area">
                                                    
													<textarea placeholder="${text.format('idea-batch-process-comment-placeholder')}"  maxlength="1000" class="lia-form-body-input lia-form-type-text lia-form-input-vertical custom-textarea" id="batch-comment" name="body"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="lia-quilt-column lia-quilt-column-12 lia-quilt-column-right lia-input-edit-form-column">
                            <div class="lia-quilt-column-alley lia-quilt-column-alley-right">
                                <div class="lia-form-row lia-form-search-type-entry" style="min-height:0px;">
                                    <div class="lia-form-label-wrapper" style="padding-bottom:5px;" >
                                        <label for="lia-searchType" class="lia-form-label">${text.format('idea-batch-process-change-status-to-label')}</label>
                                    </div>
                                </div>
                                <div class="lia-form-input-wrapper" style="display:inline-flex;">
                                    <select class="lia-form-status-input-available" id="lia-status" name="status" style="width:284px;" onchange="getStatus(event)">
								<option title="New Idea" value="-1" id="23">${text.format('idea-batch-process-select-status-label')}</option>	
								<#assign status_response=restadmin('/boards/id/${board_id_value}/message_statuses/available')>
								<#list status_response.message_statuses.message_status as message_status>
								<option title="New Idea" value="${message_status.id}" id="${message_status.id}">${message_status.name}</option>
								</#list>	
							</select>
                            
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="custom-filter-buttons lia-button-wrapper">
						<input value="Submit" name="submitContextX" type="hidden"><input title="" class="lia-button lia-button-primary lia-button-Submit-action" value="${text.format('idea-batch-process-change-status-button-label')}" id="status-update" name="submitContext" type="button" >
					</div>
                </form>

            </div>
        </div>
    </div>
</div>

     
 <div style="padding-top:10px;"> </div>
<#if  filter_query == 'Apply'>
    <#if filter_query?length gt 0 >
	<@component id="autodesk-batchprocess-idea-filter" />
    </#if>
<#else>
    <@component id="autodesk-batchprocess-idea-filter-no-filter" />
</#if>

<@component id="custom.autodesk.Idea.loader.component" />     


<script>
function truncate( n, useWordBoundary ){
    if (this.length <= n) { return this; }
    var subString = this.substr(0, n-1);
    return (useWordBoundary 
       ? subString.substr(0, subString.lastIndexOf(' ')) 
       : subString) + "...";
}


function getParameter(theParameter) { 
  var params = window.location.search.substr(1).split('&');
 
  for (var i = 0; i < params.length; i++) {
    var p=params[i].split('=');
	if (p[0] == theParameter) {
	  return decodeURIComponent(p[1]);
	}
  }
  return false;
}
var param_vote_condition = getParameter('vote_condition');
if(!param_vote_condition){
	$("input:radio[value=gt_or_eq]").prop('checked',true);
}
else{
	$("input:radio").each(function(){if($(this).val()==param_vote_condition){$(this).prop('checked',true)}});
}

var selected_vote_filter=$("#advancedThreadSearchForm input[type=radio]:checked").val();
$("#advancedThreadSearchForm input[type=radio]").change(function(){selected_vote_filter = $(this).val();}); 


$(".info-messages").prepend("<span class='idea-status-valid-message'></span>"); 


function getConfirmation(request_str){
	var idArray=request_str.split(',');
	var status = $('#lia-status option:selected').text();
	var boardID = '${board_title_value}';
	var numberId = Number(idArray.length-1);
    if(numberId==1)
        {
	var answer = confirm("You can process as many as 60 ideas at a time. If your search filters a total number of posts greater than 60, select all posts, process them, click filter again, and repeat the process until you have processed all desired ideas.");
        }
    else{
    var answer = confirm("You can process as many as 60 ideas at a time. If your search filters a total number of posts greater than 60, select all posts, process them, click filter again, and repeat the process until you have processed all desired ideas.");
    }
	if (answer)
	{
	  updateSelectedStatus(request_str);
	}
}

function updateSelectedStatus(request_str){
	$('.overlay').show();
		var post_comment=$('#batch-comment').val();
		post_comment = encodeURIComponent( post_comment ).replace(/[!'()]/g, escape).replace(/\*/g, "%2A");
		request_str=request_str.substring(0, request_str.length-1);
		var arr = window.location.href.split("/");
		var hostName = arr[0] + "//" + arr[2]; 
		var url=hostName+"/autodesk/plugins/custom/autodesk/autodesk/ideastation_poc?request_str="+request_str+"&statusid="+status_id+"&post_comment="+post_comment;
		changeStatus(request_str,status_id,post_comment);
}
 
$('.lia-quick-reply').hide();

$('.Edit-link').click(function(event){
	//debugger;
	var tar=event.target;
	var x=$(tar).attr('id');
	var str="#quick-reply-"+x;
	var z=$(str);
	$(z).show();
	$('#lia-body_'+x).text($('#span-link-'+x).text());
	$('#community-post-edit-link-'+x).hide();
	$('#lia-body_'+x).show();
	$('.button-group-'+x).show();

});

$('.lia-button.lia-button-primary.lia-button-Cancel-action').click(function(event){
	//debugger;
	var tar=event.target;
	var n=$(tar).attr('name');
	$('#lia-body_'+n).hide();
	$('.button-group-'+n).hide();
	$('#community-post-edit-link-'+n).show();
});


	status_id=$('#lia-status').val();
    document.getElementById("status-update").addEventListener("click", function(){
	
        status_id=$('#lia-status').val();
		
		var request_str="";
		$("#topic-table tr").each(function() {
			var x=$(this).find('.BatchProcessing');
			var test = $(this).is(':visible');
			var y=$(x).is(":checked:not(:disabled)");
			if(y==true)
			{
				request_str=request_str+$(x).attr('id')+",";
			}
		});
		if(status_id == -1 && request_str==""){
			alert("No Ideas selected.\nNo Change Status To selected.");
			return;
		}
		if(status_id == -1){
			alert("No Change Status To selected.");
			return;
		}
		if(request_str==""){
			alert('No ideas selected.');
			return ;
		}
		getConfirmation(request_str);
});

var counter=0;
function bacthUpdateComment_1(request_str,post_comment){
//debugger;
var arr = window.location.href.split("/");
var hostName = arr[0] + "//" + arr[2];

	if(post_comment!="")
	{
		var idArray=request_str.split(',');
			for(var index=0;index<idArray.length;index++)
			{
			var URL=hostName+"/restapi/vc/messages/id/"+idArray[index]+"/reply?message.body="+post_comment;
			var saveData = $.ajax({
							  type: 'POST',
							  dataType: "xml",
							  async:"false",
							  url: URL,
							  error: function (jqXHR, exception) {
									//debugger;
									
							},
							 success: function(resultData) {
							 counter++;
							}
						});
			}
	}
}

function updateTheCommentAfterAjax(request_str,post_comment){
	var idArray=request_str.split(',');
	for (var i = 0;i<idArray.length ;i++){
		var id = idArray[i];
		if(post_comment != ""){
			post_comment = truncate.apply(post_comment, [40, true]);
			console.log('truncated comment *** '+post_comment);
			$('#span-link-'+id).text(post_comment);
		}		
		$($('#span-link-'+id).siblings()[0]).text('Edit');
		$('#community-post-edit-link-'+id).show();
		$('#lia-body_'+id).hide();
		$('.button-group-'+id).hide();
		$('.status_id_'+id).text($('#lia-status option:selected').text());
		$('#'+id).attr('checked', false);
	}
	$('#check-all').attr('checked', false); 

}
function bacthUpdateComment(message_id,post_comment){
	var arr = window.location.href.split("/");
	var hostName = arr[0] + "//" + arr[2];

	if(post_comment!="")
	{
			var URL=hostName+"/restapi/vc/messages/id/"+message_id+"/reply?message.body="+post_comment;
			var saveData = $.ajax({
						  type: 'POST',
						  dataType: "xml",
						  async:"false",
						  url: URL,
						  error: function (jqXHR, exception) {
								//debugger;
								 counter++;
								
						},
						 success: function(resultData) {
							counter++;
							//updateTheCommentAfterAjax(message_id,post_comment);
							var decode = decodeURI(post_comment);
							post_comment = unescape(decode);
							console.log('full comment *** '+post_comment);
							post_comment = truncate.apply(post_comment, [40, true]);
							console.log('truncated comment *** '+post_comment);
							$('#span-link-'+message_id).text(post_comment);
							$('.lia-js-data-messageUid-'+message_id).addClass('success');
							if(counter == idArray.length){
								$('.overlay').hide();
								uncheckAfterSuccess();
								updateSuccessStatus(idArray);

								$(".custom-textarea").val("");
								$("#lia-status").prop('selectedIndex',0);								
							}
						}
					});
	}
}

var idArray = [];
function changeStatus(request_str,status_id,post_comment){
    debugger;
	$('.custom-invalid-id').css('display','none');
	$('.idea-status-valid-message').css('display','none');
	var counter_status=0;
	counter = 0;
	idArray = [];
	idArray=request_str.split(',');
    var batch_process_hundreds_count=1;
	for (var i = 0;i<idArray.length ;i++){
        if(i==batch_process_hundreds_count*20){
            debugger;
            setInterval(1000);
            batch_process_hundreds_count++;
        }
	    var arr = window.location.href.split("/");
		var hostName = arr[0] + "//" + arr[2];
		//var url1 =hostName+"/restapi/vc/messages/id/"+idArray[i]+"/message_status/set?message.status=id/"+status_id;
		var url1=hostName+"/autodesk/plugins/custom/autodesk/autodesk/custom-ideastation-bulk-api?request_str="+idArray[i]+"&statusid="+status_id+"&post_comment="+post_comment;
		var saveData = $.ajax({
				  type: 'POST',
				  dataType: "json",
				  async:"false",
				  url: url1,
				  error: function (jqXHR, exception) {
					//debugger;
					counter_status++;
				},
				 success: function(resultData) {
				 //debugger;
					if(post_comment == "")
						$('.lia-js-data-messageUid-'+idArray[counter_status]).addClass('success');
					
					
					//updateTheCommentAfterAjax(idArray[counter_status],post_comment);
					$('.status_id_'+idArray[counter_status]).text($('#lia-status option:selected').text());
					$('.lia-js-data-messageUid-'+idArray[counter_status]+' .ideaStatusColumn').addClass('success');
					$('#'+idArray[counter_status]).attr('checked', false);
					//bacthUpdateComment(idArray[counter_status],post_comment);
					updateThePostComment(post_comment,idArray[counter_status]);
					counter_status++;
					if(counter_status ==idArray.length){
					
						//bacthUpdateComment(request_str,post_comment);
						//if(post_comment == ""){
							updateSuccessStatus(idArray);
							$('.overlay').hide();
							$(".custom-textarea").val("");
							$("#lia-status").prop('selectedIndex',0);	
							
						//}
						uncheckAfterSuccess();
					}
				}
			});
			//bacthUpdateComment(idArray[counter_status],post_comment);
	}
}
	
	function updateThePostComment(post_comment,message_id){
		if(post_comment!="")
		{
			var decode = decodeURI(post_comment);
			post_comment = unescape(decode);
			console.log('full comment *** '+post_comment);
			post_comment = truncate.apply(post_comment, [40, true]);
			console.log('truncated comment *** '+post_comment);
			$('#span-link-'+message_id).text(post_comment);
			$('.lia-js-data-messageUid-'+message_id).addClass('success');
		}
	}
	function uncheckAfterSuccess(){
		for (var i = 0;i<idArray.length ;i++){
			var id = idArray[i];
			$('#'+id).attr('checked', false);
		}
		$('#check-all').attr('checked', false); 
	}
	
	function updateSuccessStatus(idArray){
		if(idArray.length==1)
		{
			$(".idea-status-valid-message").show();
			$(".idea-status-valid-message").text("Status of "+idArray.length+" Idea changed to "+$(".lia-form-status-input-available option:selected").text());
		}
		else
		{
		  $(".idea-status-valid-message").show();
		  $(".idea-status-valid-message").text("Status of "+idArray.length+" Ideas changed to "+$(".lia-form-status-input-available option:selected").text());
		}
	}
	function timeoutforstatus(totalCount){
		var timeCounter = (totalCount/3)*1000;
		setTimeout(function(){ 
				$('.overlay').hide();	
		}, timeCounter);
	}

	var status_id="";
	function getStatus(event){
		var option = event.currentTarget.selectedOptions;
		status_id = option[0].id;
		for (var i = 0;i<idArray.length ;i++){
			//$('.lia-js-data-messageUid-'+idArray[i]).css('background','#ffffff');
			$('.lia-js-data-messageUid-'+idArray[i]).removeClass('success');
			
		}
		enableDisableIdeaRow();
	}
	
	$('#check-all').change(function(event){
		var target_obj=event.target;
		var status_selected = $("#lia-status option:selected").text();
		$("#topic-table tr").each(function() {
			var x=$(this).find('.BatchProcessing');
			var isVisible = $(this).is(':visible');
			var y=$(x).is(":checked");
			if(isVisible==true)
			{
				var status_value = $('.status_id_'+$(x).attr('id')).text();
				
				if($(target_obj).is(":checked")==true){
					if(status_value == status_selected){
						$(x).prop("disabled", true);
						//$(this).css('background','grey');
						$(this).addClass('disabled');
					}
					$(x).prop('checked', true);
				}
				else{
					if ($(this).hasClass('disabled')) {
						$(this).removeClass('disabled');
						$(this).find('.BatchProcessing').prop("disabled", false);
					}
					$(x).prop('checked', false);
				}
			}else{
				$(x).prop('checked', false);
			}
		});
	});

	function getIndividualStatus(event){
	//return;
		var id = event.currentTarget.id;
		var statusId = $('.status_id_'+id);
		var status_selected = $("#lia-status option:selected").text();
		$("#topic-table tr").each(function() {
			var x = $(this).find(statusId);
			var checkbox = $(this).find("#"+id);
		if(x.length > 0){
				var status_value = $('.status_id_'+id).text();
				if(status_value == status_selected){
					$(checkbox).prop("disabled", true);
					$(this).addClass('disabled');
				}
			}
		});
	}
	function enableDisableIdeaRow(){
		console.log('changed');
		var status_selected = $("#lia-status option:selected").text();
		$("#topic-table tr").each(function() {
			if ($(this).hasClass('disabled')) {
				console.log('class removed');
				$(this).removeClass('disabled');
				$(this).find('.BatchProcessing').prop("disabled", false);
			}

			var x = $(this).find('.BatchProcessing');
			var isVisible = $(this).is(':visible');
			var isChecked = $(x).is(":checked");
			if (isVisible && isChecked) {
				var status_text = $(this).find(".ideaStatusColumn .username_area span").text();
				if (status_text == status_selected) {
					$(x).prop("disabled", true);
					$(this).addClass('disabled');
					console.log('class added');
				}
			}
		});
	}
	var filter_count=-1;
	function getQueryParam()
	{
		//debugger;
		filter_count = 1;
		var ideas_id_str=$('#idea-box').val();
		var filter_status_id=$('#lia-status-filter-by').val();
		var key_filter=$('#keyword-box').val();
		key_filter = key_filter.replace(/"/g, '\\"');
		key_filter = encodeURIComponent( key_filter ).replace(/[!'()]/g, escape).replace(/\*/g, "%2A");
		

		if(filter_status_id==-1)
		filter_status_id="";
		var vote_count=$('#vote-box').val();
		var dateFromVal=$('#datepickerFrom').val();
		var dateToVal=$('#datepickerTo').val();
		var dateFrom="";
		var dateTo="";
		
		ideas_id_str = ideas_id_str.replace(/,\s*$/, "");
		var ideas_id_str = getUniqueIds([ideas_id_str.split(',')]);
		$('#idea-box').val(ideas_id_str);
		debugger;
		
		if(ideas_id_str == "" && filter_status_id == "" && vote_count == "" && dateFromVal == "" && dateToVal == "" && key_filter == ""){
			alert("Please select Keyword Search, Ideas Id, Change Status To, Date , Votes (Greater than 'or' equal to) to filter");
			return ""; 
		}
		/* if(ideas_id_str == "" || filter_status_id != "-1" || vote_count == ""){
			if((dateFromVal =="" && dateToVal =="") || (dateFromVal =="" && dateToVal !="") || dateFromVal !="" && dateToVal ==""){
				alert("Please select date to filter");
				return ""; 
			}
		} */
		var idValue = '${board_id_value}';
		var milisecondsFrom = (new Date($('#datepickerFrom').val())).getTime();
		var milisecondsTo = (new Date($('#datepickerTo').val())).getTime();
		var bflag = getTodayDate($('#datepickerTo').val());
		if(bflag)
		{
			var d = new Date();
		    var n = d.getTime();
			milisecondsTo = n;
		}
		if(milisecondsFrom == milisecondsTo){
			var d = new Date();
		    var n = d.getTime();
			milisecondsTo = n;		
		}
		if(dateFromVal!="" && dateToVal!=""){
			var dateFromValSplit=dateFromVal.split('/');
			var dateToValSplit=dateToVal.split('/');
			dateFrom=dateFromValSplit[2]+"-"+dateFromValSplit[0]+"-"+dateFromValSplit[1];
			dateTo=dateToValSplit[2]+"-"+dateToValSplit[0]+"-"+dateToValSplit[1];
			return "filter_query=Apply&filter_status="+filter_status_id+"&vote_condition="+selected_vote_filter+"&filter_vote="+vote_count+"&date_from="+dateFrom+"&date_to="+dateTo+"&filter_idstr="+ideas_id_str+"&key_filter="+key_filter+"&id="+idValue+"&dateFromMili="+milisecondsFrom+"&dateTomMili="+milisecondsTo+"&filter_count="+filter_count;
		}
		else
		{
			return "filter_query=Apply&filter_status="+filter_status_id+"&vote_condition="+selected_vote_filter+"&filter_vote="+vote_count+"&filter_idstr="+ideas_id_str+"&key_filter="+key_filter+"&id="+idValue+"&filter_count="+filter_count;
		}
	}

	jQuery('#idea-box').keyup(function () { 
		 this.value = this.value.replace(/[^0-9\.,{1}]/g,'');
		this.value=this.value.replace(/^[, ]+|[, ]+$|[, ]+/g, ",").trim();
	});

	jQuery('#vote-box').keyup(function () { 
		this.value = this.value.replace(/[^0-9\.]/g,'');
	});

	function getTodayDate(todayDate){
		var bflag = false;
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1; //January is 0!
		var yyyy = today.getFullYear();

		if(dd<10) {
			//dd = '0'+dd
		} 

		if(mm<10) {
			//mm = '0'+mm
		} 

		today = mm + '/' + dd + '/' + yyyy;
		if(today == todayDate)
			bflag = true;
		return bflag;
	}
	var getUrlParameter = function getUrlParameter(sParam) {
		var sPageURL; 
		if(sParam == 'key_filter'){
			sPageURL = (window.location.search.substring(1));
		}else{
			sPageURL = decodeURIComponent(window.location.search.substring(1));
		}
		var sURLVariables = sPageURL.split('&'),
			sParameterName,
			i;

		for (i = 0; i < sURLVariables.length; i++) {
			sParameterName = sURLVariables[i].split('=');

			if (sParameterName[0] === sParam) {
				return sParameterName[1] === undefined ? true : sParameterName[1];
			}
		}
	};
	
	updateFieldsAsPerFilter();
	function updateFieldsAsPerFilter(){
		resetAll();
		var filter_status = getUrlParameter('filter_status');
		var filter_vote = getUrlParameter('filter_vote');
		var date_from = getUrlParameter('date_from');
		var date_to = getUrlParameter('date_to');
		var filter_idstr = getUrlParameter('filter_idstr');
		var keyword_filter = getUrlParameter('key_filter');
		
		if(filter_status != undefined){
			$("#lia-status-filter-by > option").each(function(index) {
				if(this.value == filter_status){
					$("#lia-status-filter-by").prop('selectedIndex',index);
					$(".lia-form-status-input-available option[value="+filter_status+"]").remove();
				}
			});
		}

		if(filter_vote != undefined){
			$('#vote-box').val(filter_vote);
		}
		
		if(filter_idstr != undefined){
			$('#idea-box').val(filter_idstr);
		}
		
		if(keyword_filter != undefined){
			var decode = decodeURI(keyword_filter);
			var unesc_keyword = unescape(decode);
			unesc_keyword = unesc_keyword.replace(/\\/g, '');
			$('#keyword-box').val(unesc_keyword);
		}
		
		if(date_from != undefined){
			var date_picker_from=date_from;
			var from_str=date_picker_from.split('-');
			var from_str_rearranged=from_str[1]+"/"+from_str[2]+"/"+from_str[0];
			$('#datepickerFrom').val(from_str_rearranged);
		}
		if(date_to != undefined){
		var date_picker_to=date_to;
			var to_str=date_picker_to.split('-');
			var to_str_rearranged=to_str[1]+"/"+to_str[2]+"/"+to_str[0];
			$('#datepickerTo').val(to_str_rearranged);
		}
	}

	function resetAll(){
		$('#vote-box').val("");
		$('#idea-box').val("");
		$('#datepickerFrom').val("");
		$('#datepickerTo').val("");
		$("#lia-status-filter-by").prop('selectedIndex',0);
	}
	
	function getUniqueIds(arr) {
		var r = new Array();
		o:for(var i = 0, n = arr[0].length; i < n; i++)
		{
			for(var x = 0, y = r.length; x < y; x++)
			{
				if(r[x]==arr[0][i])
				{
					//alert('this is a DUPE!');
					continue o;
				}
			}
			if(r.length < 800)
				r[r.length] = arr[0][i];
		}
		return r;
	}
	
	$('#filter-button').click(function(event){
		var query=getQueryParam();
		if(query == "")
			return;
		$('.overlay').show();
		var url = window.location.href;    
		if (url.indexOf('?') > -1){
		   url=url.substr(0,url.indexOf('?'));
		   url += '?'+query;
		}else{
		   url += '?'+query;
		}
		window.location.href = url;
	});
	
	function getQueryParamForPagination()
	{
		//debugger;
		filter_count = -1;
		var ideas_id_str=$('#idea-box').val();
		var filter_status_id=$('#lia-status-filter-by').val();
		var key_filter=$('#keyword-box').val();
		key_filter = encodeURIComponent( key_filter ).replace(/[!'()]/g, escape).replace(/\*/g, "%2A");
		key_filter = key_filter.replace(/"/g, '\\"');
		
		if(filter_status_id==-1)
		filter_status_id="";
		var vote_count=$('#vote-box').val();
		var dateFromVal=$('#datepickerFrom').val();
		var dateToVal=$('#datepickerTo').val();
		var dateFrom="";
		var dateTo="";
		
		ideas_id_str = ideas_id_str.replace(/,\s*$/, "");
		var ideas_id_str = getUniqueIds([ideas_id_str.split(',')]);
		$('#idea-box').val(ideas_id_str);
		
		var idValue = '${board_id_value}';
		var milisecondsFrom = (new Date($('#datepickerFrom').val())).getTime();
		var milisecondsTo = (new Date($('#datepickerTo').val())).getTime();
		var bflag = getTodayDate($('#datepickerTo').val());
		if(bflag)
		{
			var d = new Date();
		    var n = d.getTime();
			milisecondsTo = n;
		}
		if(milisecondsFrom == milisecondsTo){
			var d = new Date();
		    var n = d.getTime();
			milisecondsTo = n;		
		}
		if(dateFromVal!="" && dateToVal!=""){
			var dateFromValSplit=dateFromVal.split('/');
			var dateToValSplit=dateToVal.split('/');
			dateFrom=dateFromValSplit[2]+"-"+dateFromValSplit[0]+"-"+dateFromValSplit[1];
			dateTo=dateToValSplit[2]+"-"+dateToValSplit[0]+"-"+dateToValSplit[1];
			return "filter_query=Apply&filter_status="+filter_status_id+"&filter_vote="+vote_count+"&date_from="+dateFrom+"&date_to="+dateTo+"&filter_idstr="+ideas_id_str+"&key_filter="+key_filter+"&id="+idValue+"&dateFromMili="+milisecondsFrom+"&dateTomMili="+milisecondsTo+"&filter_count="+filter_count+"&vote_condition="+selected_vote_filter;
		}
		else
		{
			return "filter_query=Apply&filter_status="+filter_status_id+"&filter_vote="+vote_count+"&filter_idstr="+ideas_id_str+"&key_filter="+key_filter+"&id="+idValue+"&filter_count="+filter_count+"&vote_condition="+selected_vote_filter;
		}
	}  
</script>
</#if>
<style>
#lia-body .lia-content .lia-form .lia-form-input-wrapper > select {
    margin: 0 0 10px;
    padding: 2px;
    /*height: 20px;*/
    border-radius: 0;
}
#lia-body .lia-content .lia-component-forums-widget-message-list .thread-list {
    background: url(/html/assets/node-h2-bg.gif?308FAF49781C5C31EA0D9647DCAE7131) repeat-x top left;
    background: none;
}
#lia-body .lia-content .lia-component-forums-widget-message-list table.lia-list-wide th {
    padding: 10px;
    font-weight: 700;
    border-bottom: 2px solid gainsboro;
}
.custom-filter {
    background-color: #fff;
    padding: 10px;
	border: 1px solid #ccc;
	margin-top:5px;
}
#common-comment{
     margin-top:5px;
	 background-color: #fff;
	 padding:10px;
	 padding-bottom:0px;
	 margin-bottom: 0px;
	border: 1px solid #ccc;
}
.lia-node-header-title1 {
    font-family: 'FrutigerNextW04-Regular';
    padding: 0px 0 10px 10px;
    margin-top: 15px;
    font-size: 14pt;
    line-height: 0px;
    letter-spacing: 0px !important;
    text-transform: uppercase;
    font-weight: bold;
}
.Idea-Status-Page-1 .lia-quilt-row.lia-quilt-row-feedback{
	display: none;
}
.Idea-Status-Page-1 .lia-node-header-title1 {
	display: inline-block;
}
.Idea-Status-Page-1 .custom-invalid-id{
	margin-left: 60px;
    margin-top: 5px;
    display: inline-block;
    padding: 5px 10px 5px 10px;
}
.Idea-Status-Page-1 .custom-invalid-meesage{
	color:red;
}

.lia-node-header-boxes {
	margin-top: 0px;
    margin-bottom: 16px;
    padding: 5px 0px 0px 0px;
    font-size: 10.2pt;
    line-height: 0px;
    text-transform: uppercase;
    font-weight: bold;
}

.Idea-Status-Page-1 tr.disabled {
    background-color: grey;
    opacity: 0.5;
}
.Idea-Status-Page-1 .custom-filter-buttons{
	margin-top: 10px;
}

#lia-body .lia-content .lia-form .lia-form-input-wrapper > textarea, #lia-body .lia-content .lia-form .lia-form-input-wrapper > .custom-textarea {
    margin: 0 0 0px;
}
.custom-textinput{
	width: 500px !important;
}
.Idea-Status-Page-1 tr.disabled {
    background-color: grey;
    opacity: 0.5;
}
.Idea-Status-Page-1 tr.success {
    background-color: #E6F1CC;
 }
 .Idea-Status-Page-1 tr.clearSuccess {
    background-color: #ffffff;
 }
.Idea-Status-Page-1 .lia-quilt-column-CommentText{
	width:86%;
}
.Idea-Status-Page-1 .idea-status-valid-message {
    margin-left: 200px;
    font-size:14px;
    color:green;
    text-transform:none;
    font-weight:normal;
}

.Idea-Status-Page-1 .info-messages{
	display: inline-block;
    vertical-align: top;
    margin-left: 300px;
}
.Idea-Status-Page-1 .custom-invalid-id {
    margin-left: 0px;
    margin-top: 5px;
    display: inline-block;
    padding: 0px;
}
.Idea-Status-Page-1 .idea-status-valid-message{
    display: block;
}
.Idea-Status-Page-1 .lia-node-header-title1 {
    display: inline-block;
    vertical-align: middle;
}
.Idea-Status-Page-1 .idea-status-valid-message {
    margin-left: 0px;
}
.Idea-Status-Page-1 .lia-input-edit-form-row-main input[type="radio"] {
    margin-right:5px!important;
}
#lia-body.Idea-Status-Page-1 label.showpagecount {
    position: relative;
    top: -20px;
	}
	//css for date
	.lia-datepicker .lia-date-picker span
	{
		
			line-height:40px !important;
		
	}


</style>