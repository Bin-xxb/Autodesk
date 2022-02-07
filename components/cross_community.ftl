<#attempt>
  <#--
   Intelligent Content Syndication.
   (ICS) 2019 iTalent By Ravindra
  for #This component displays the target communities dropdown and post, status buttons#
  -->
  <#if  page.name == "ForumTopicPage" || page.name == "TkbArticlePage" || page.name == "BlogArticlePage" || page.name == "IdeaPage">
    <#if user.registered && !user.anonymous && page.context.thread??> <#-- Start: checking anonymous users and checking page.context.thread is empty or not-->
      <#-- moved the css into skin scss
      <link rel="stylesheet" type="text/css" href='${asset.get("/html/assets/ics.css")}' integrity="sha384-YteOMvjZpBphISfTOUQhFt6YfSJPFC1qGuMEhgIqWywRM3kMmYnj3bE3IwFFdsjm" crossorigin="anonymous">
      -->
      <#import "cross_community_macro.ftl" as macroDetails>
      <#assign ThreadId = page.context.thread.topicMessage.uniqueId />

      <#assign query = "select author.id,author.login,author.email from messages where id = '${ThreadId}'"/>
      <#assign thread_author_id = restadmin("2.0","/search?q=" + query?url) />
      <#assign msg_author_id = thread_author_id.data.items[0].author.id />
      <#assign msg_author_login = thread_author_id.data.items[0].author.login />
      <#assign msg_author_email = thread_author_id.data.items[0].author.email />

      <#--Start: User is an Admin or actual message author or super users we can display widget -->
      <#if (user.id == msg_author_id?number && macroDetails.isNominator) || macroDetails.isSyndicatorAdmin ||  macroDetails.isSyndicator > 

        <#-- getting login user sso id-->
        <#if user.sso_id??>
          <#assign user_sso_id = user.sso_id/>
        <#else>
          <#assign user_sso_id = ""/>
        </#if>

        <#assign interactionStyle = page.interactionStyle />
        <#assign isInteractionStyle = false />
        <#assign isCommunityActive = false />
        <#assign isDisabled = false />
        <#assign messageOriginType = "" />

        <#assign  origin_value = restadmin("/messages/id/${ThreadId}/metadata/key/${macroDetails.message_origin_key}").value />
        <#if origin_value != "" && origin_value?split("|")[0]??>
          <#assign messageOriginType = origin_value?split("|")[0] />
        </#if>

        <#assign accessToken = macroDetails.accessToken />
        <#assign isAuthorizedFacebook = macroDetails.isAuthorizedFacebook />
        <#assign  communityDetails = macroDetails.communityDetails(ThreadId,"")  />
        
        <#assign communityDetailsObject = communityDetails.communityObj/>
        <#assign categoryId = communityDetails.categoryId />

        <#if communityDetailsObject?has_content && communityDetailsObject?? >
          <#assign sourceCommunityDetails = communityDetailsObject?eval.community_details.source/>
          <#assign targetCommunityDetails = communityDetailsObject?eval.community_details.target/>
          
          <#-- Start:checking community is active or not and community is not target -->
          <#if sourceCommunityDetails?? && sourceCommunityDetails?has_content && sourceCommunityDetails.active != false && sourceCommunityDetails.communityFunction != "TARGET"> 
            <#assign isCommunityActive = true />

            <#list sourceCommunityDetails.interactionStyleMappings as dataStyle>
              <#if dataStyle.interactionStyle == interactionStyle && dataStyle.active >
                <#assign isInteractionStyle = true />
              </#if>
            </#list>
          </#if><#-- End:checking community is active or not and community is not target -->
        </#if>

        <#assign isCategory = false/>
        <#assign category_details = [] />
        <#assign target_community = "" />

        <#-- Start:checking this community is category_as_community or not -->
        <#if macroDetails.category_as_community_value?? && macroDetails.category_as_community_value != "" && macroDetails.category_as_community_value?has_content >
          <#list macroDetails.category_as_community_value?eval.categories_list as cat_details>
            <#assign category_details = category_details + [cat_details.categoryID] />
            
            <#if cat_details.categoryID?matches(categoryId, "i")>
              <#assign isCategory = true/>
            </#if>
          </#list>
        </#if><#-- End:checking this community is category_as_community or not -->

        <#assign shareMessagesValue = restadmin("/messages/id/${ThreadId}/metadata/key/${macroDetails.share_messages_key}").value/>

        <#if !shareMessagesValue?contains('unselected') && shareMessagesValue != "">
          <#assign isDisabled = true />
        </#if>

        <#if isCommunityActive && isInteractionStyle  ><#--Start: checking community is active or not, interactionStyle is active or not, checking this this message is target or not, if it is category is community then display in that categories only and if it is not category is community display the hole community-->

          <div class="main-div Xcommunity" id="cross-community" style="display: none;">
            <#-- This below code commenting on 27/09/2019. this is not pushing right now. it push may be next sprint -->
            <#-- <div class="lia-panel-heading-bar-wrapper">
              <div class="lia-panel-heading-bar">
                <span aria-level="4" role="heading" class="lia-panel-heading-bar-title">Syndicate Content</span>
              </div>
            </div> -->
            <div class="loader-div">
              <div class="loader" ></div>
            </div>
            <div class="commnity-panel-right" id="commnity-panel-right">
              <div class="commnity-panel">
                <button class="dropdown " aria-haspopup="true" aria-expanded="false" <#if messageOriginType == 'target'>disabled="disabled"</#if>>
                  <span class="selected-values">Select Community</span>
                  <div class="toggle-icon"></div>
                </button>
                <ul style="display: none;" class="dropdown-manu" role="listbox" tabindex="-1">
                  <li role="option">
                    <input type="checkbox" class="select-all" aria-label="select all" name="Select All">
                    <label class="select-all-label" for="select-all">Select All</label>
                  </li>
                  <#if targetCommunityDetails?? && targetCommunityDetails?has_content >
                  
                    <#list targetCommunityDetails  as data>
                      <#if data.active != false>
                      
                        <#if shareMessagesValue != "" && shareMessagesValue?split(";")[1]?? && shareMessagesValue?split(";")[1]?has_content >
                          <#assign targetCommunities = shareMessagesValue?split(";")[1] />
                          <#if targetCommunities?contains('${data.communityId}')>
                            <#list targetCommunities?split("||") as tc >
                              <#if "${data.communityId}" == "${tc?split(':')[0]}">
                                  <#if tc?split(":")[1] == "unselected">
                                    <li role="option">
                                      <input type="checkbox" name="${data.communityName}" aria-label="${data.communityName}" class="check-box" value="${data.communityId}" />
                                      <label class="check-box-label">${data.communityName}</label>
                                    </li>
                                  <#else>
                                    <li role="option">
                                      <input type="checkbox" name="${data.communityName}" aria-label="${data.communityName}" class="check-box" value="${data.communityId}" disabled="disabled" />
                                      <label class="check-box-label disabled-label">${data.communityName}</label>
                                    </li>
                                  </#if>
                              </#if>
                            </#list>
                          <#else>
                            <li role="option">
                              <input type="checkbox" name="${data.communityName}" aria-label="${data.communityName}" class="check-box" value="${data.communityId}" >
                              <label class="check-box-label">${data.communityName}</label>
                            </li> 
                          </#if>
                        <#else>
                          <li role="option">
                            <input type="checkbox" aria-label="${data.communityName}" name="${data.communityName}" class="check-box" value="${data.communityId}">
                            <label class="check-box-label">${data.communityName}</label>
                          </li>
                        </#if>
                      </#if>
                    </#list>
                  </#if>
                </ul>
              </div>

              <div class="commnity-panel">
                <button id="btn-post" class="btn-post lia-button lia-button-primary"  <#if messageOriginType == 'target'>disabled="disabled"</#if>>Syndicate</button> 
              </div>

              <div class="commnity-panel">
                <#-- <a href="JavaScript:Void(0);" id="btn-status" class="lia-link-navigation status-mbas-link"><span>Status</span></a> --> 
                <button id="btn-status" class="btn-status lia-button lia-button-primary">Status</button>
              </div>
            </div>

            <!-- The Status Modal -->
            <div id="statusModal" class="statusModal" role="dialog">
              <!-- Modal content -->
              <div class="status-modal-dialog" id="status-modal-dialog" role="document"> 
                <div class="statusModal-content">
                  <div class="modal-header">
                    <span class="search-bar">
                      <input type="text" id="search" placeholder="Search data here..."/>
                    </span>
                  </div>
                  <div id="tableDiv"></div>
                  <div class="modal-footer">
                    <button class="btn-ok btn-status-close lia-button lia-button-primary">OK</button>
                    <button type="button" class="status-close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">×</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- The Alert Modal -->
            <div id="alertModal" class="alertModal" role="dialog">
              <!-- Modal content -->
              <div class="modal-dialog" id="alert-modal-dialog" role="document"> 
                <div class="alertModal-content">
                  <div class="modal-header">
                  </div>
                  <div id="alert-popup"></div>
                  <div class="modal-footer">
                    <button class="btn-ok alert-popup-close lia-button lia-button-primary">OK</button>
                    <button type="button" class="close1" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">×</span>
                      <#-- <span aria-hidden="true">&#10005;</span> -->
                    </button>
                  </div>
                  
                </div>
              </div>
            </div>

            <!-- The unexists users Modal -->
            <div id="unexistsModal" class="unexistsModal" role="dialog">
              <!-- Modal content -->
              <div class="unexists-modal-dialog" id="unexists-modal-dialog" role="document"> 
                <div class="unexistsModal-content" >
                  <div class="modal-header">
                  </div>
                  <div id="unexists-popup"> </div>
                  <div class="modal-footer">
                    <button class="btn-register lia-button lia-button-primary" id="btn-register">Yes</button>
                    <button class="btn-publish lia-button lia-button-primary" id="btn-publish">No</button> 
                    <button type="button" class="unexists-close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">×</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- The confirmation Modal -->
            <div id="dialogboxModal" class="dialogboxModal" role="dialog">
              <!-- Modal content -->
              <div class="modal-dialog" id="modal-dialog" role="document"> 
                <div class="dialogboxModal-content">
                  <div class="modal-header">
                  </div>
                  <div id="dialogbox-popup"> </div>
                  <div class="modal-footer">
                    <button class="btn-proceed lia-button lia-button-primary" id="btn-proceed">Proceed</button>
                    <button class="btn-cancel lia-button lia-button-primary lia-button-Cancel-action" id="btn-cancel">Cancel</button>
                    <button type="button" class="dialogbox-close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">×</span>
                    </button> 
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <@liaAddScript>
            ;(function($) {
              try {

                <#--Start: ICS wight displaying in right alley column -->
                  <#-- This below code commenting on 27/09/2019. this is not pushing right now. it push may be next sprint -->
                  <#-- if($(document).find(".lia-quilt-column-side-content > .lia-quilt-column-alley-right .panel-main-title").length > 0){

                    $(".lia-quilt-column-side-content > .lia-quilt-column-alley-right > .panel-main-title").after($(".main-div.Xcommunity"));
                  }else if($(document).find(".lia-quilt-column-right-content .lia-quilt-column-alley-right").length > 0){
                    // TKBArticlePage
                    $(".lia-quilt-column-right-content > .lia-quilt-column-alley-right").prepend($(".main-div.Xcommunity"));
                  }else{

                    $(".lia-quilt-row-main > .lia-quilt-column-side-content > .lia-quilt-column-alley-right").prepend($(".main-div.Xcommunity"));
                  } -->
                <#--End: ICS wight displaying in right alley colunm -->

                $(".main-div.Xcommunity").css("display","inline-block");

                <#-- Start: disabled the syndicate button and select all checkBox -->
                  var checkBoxLength =$(".dropdown-manu li> .check-box").not(":disabled").length;
                  if(checkBoxLength == 0){
                    $(".select-all").attr("disabled", true); 
                    $(".select-all-label").addClass("disabled-label");
                    $("#btn-post").attr("disabled", true); $("#btn-post").addClass("bnt-post-disabled");
                  }
                  
                <#-- End: disabled the syndicate button and select all checkBox -->

                <#--Start: Modal popup accessible code -->
                  var dialogBox = document.getElementById('dialogboxModal'),
                      unexistsBox = document.getElementById('unexistsModal'),
                      alertBox = document.getElementById('alertModal'),
                      statusBox = document.getElementById('statusModal'),
                      p = document.getElementById('commnity-panel-right');

                  function swap () {
                    p.parentNode.insertBefore(dialogBox, p);
                    p.parentNode.insertBefore(unexistsBox, p);
                    p.parentNode.insertBefore(alertBox, p);
                    p.parentNode.insertBefore(statusBox, p);
                  }

                  swap();

                  // list out the vars
                  var dialogboxModal = getId('modal-dialog'),
                      alertboxModal = getId('alert-modal-dialog') ,
                      statusboxModal = getId('status-modal-dialog'),
                      allNodes = document.querySelectorAll("*"),
                      dialogboxModalOpen = false,
                      alertboxModalOpen = false,
                      statusboxModalOpen = false,
                      lastFocus;

                  // Let's cut down on what we need to type to get an ID
                  function getId ( id ) {
                    return document.getElementById(id);
                  }

                  // Restrict focus to the modal window when it's open.
                  // Tabbing will just loop through the whole modal.
                  // Shift + Tab will allow backup to the top of the modal,
                  // and then stop.
                  function focusRestrict ( event ) {
                    if ( dialogboxModalOpen && !dialogboxModal.contains( event.target ) ) {
                      event.stopPropagation();
                      dialogboxModal.focus();
                    }else if( alertboxModalOpen && !alertModal.contains( event.target )){
                      event.stopPropagation();
                      alertboxModal.focus();
                    }else if( statusboxModalOpen && !statusModal.contains( event.target )){
                      event.stopPropagation();
                      statusboxModal.focus();
                    }
                  }

                  // restrict tab focus on elements only inside modal window
                  for (i = 0; i < allNodes.length; i++) {
                    $(allNodes.item(i)).on('focus', focusRestrict);
                  }
                <#--End: Modal popup accessible code -->

                var isReload = false;
                var requested_user_details = {
                                                "userName":"${user.login}",
                                                "userEmail":"${user.email}",
                                                "userId":"${user.id}",
                                                "sso_id":"${user_sso_id}"
                                              };
                var register_list = "";
                var target_community_details =JSON.parse('${communityDetailsObject?string}');
                var target_communities_list = target_community_details.community_details.target;
                var selectedCommunities = [];
                var unselectedCommunity = [];

                <#-- Start: dropdown code -->
                  $('.dropdown').click(function(){
                    $(".toggle-icon").toggleClass("active");
                    $(".dropdown-manu").toggle();
                    if($('.dropdown').attr('aria-expanded') == "false"){
                      $('.dropdown').attr('aria-expanded',"true");
                    }else{
                      $('.dropdown').attr('aria-expanded',"false");
                    }
                  });

                  var li_length = $(".dropdown-manu li>input[type='checkbox']").not(":disabled").length;

                  <#--Start: check/uncheck "select all", if one of the listed checkbox item is check/uncheck -->
                  $(".check-box").change(function(){
                    var len_check = $(".check-box:checked").not(":disabled").length;
                    
                    if (li_length-1 == len_check) {
                      if (li_length-1 == 1) {
                        var placeholder_text = $(".check-box:checked").siblings()[0].textContent;
                      } else {
                        var placeholder_text = "All Selected";
                      }
                    } else {
                      if(len_check == 0){
                        var placeholder_text = "Select Community";
                      }else if(len_check == 1){
                        var placeholder_text = $(".check-box:checked").siblings()[0].textContent;
                        
                      }else if(len_check >= 2){
                        var placeholder_text = len_check +" Selected";
                      }
                    }
                    
                    $(".selected-values").text(placeholder_text);

                    //uncheck "select all", if one of the listed checkbox item is unchecked
                    if(false == $(this).prop("checked")){ //if this item is unchecked
                      $(".select-all").prop('checked', false); //change "select all" checked status to false
                    }

                    //check "select all" if all checkbox items are checked
                    if ($('.check-box:checked').not(":disabled").length == $('.check-box').not(":disabled").length ){
                      $(".select-all").prop('checked', true);
                    }
                  });<#--End: check/uncheck "select all", if one of the listed checkbox item is check/uncheck -->


                  <#--Start: select all checkboxes -->
                  $(".select-all").on("change click",function(){ 
                    $(".check-box").not(":disabled").prop('checked', $(this).prop("checked")); //change all ".checkbox" checked status
                    if ($(this).prop("checked") == true) {
                      if (li_length-1 == 1) {
                        var placeholder_text = $(".check-box:checked").siblings()[0].textContent;
                      } else {
                        var placeholder_text = "All Selected";
                      }
                    } else {
                      var placeholder_text = "Select Community";
                    }
                    $(".selected-values").text(placeholder_text);
                  });

                  $(".check-box").on('keydown', function(event){
                    
                    if(event.which == 13){
                      $(this).trigger("click");
                    }
                  });

                  $(".select-all").on('keydown', function(event){
                    if(event.which == 13){
                      $('.select-all').trigger("click");
                    }
                  });
                  <#--End: select all checkboxes -->

                  <#-- Start: user click the out side of the dropdown then dropdown will be hidding -->
                  $("html,body").click(function(event){
                    if($(event.target).hasClass("dropdown") === false && $(event.target).hasClass("selected-values") === false && $(event.target).hasClass("toggle-icon") === false && $(event.target).hasClass("select-all") === false && $(event.target).hasClass("check-box") === false && $(event.target.parentNode).hasClass("dropdown-manu") === false && $(event.target).hasClass("select-all-label") === false && $(event.target).hasClass("check-box-label") === false ){
                      $(".toggle-icon").removeClass("active");
                      $(".dropdown-manu").hide();
                      $('.dropdown').attr('aria-expanded',"false");
                    }
                  });

                  $('.dropdown-manu input:checkbox:not(:disabled):last').on('keydown', function(event){
                    
                    if(event.which == 9 && !event.shiftKey){
                      $(".toggle-icon").removeClass("active");
                      $(".dropdown-manu").hide();
                      $('.dropdown').attr('aria-expanded',"false");
                    }
                  });

                  $('.dropdown-manu input:checkbox:not(:disabled):first').on('keydown', function(event){
                    
                    if(event.which == 9 && event.shiftKey){
                      $(".toggle-icon").removeClass("active");
                      $(".dropdown-manu").hide();
                      $('.dropdown').attr('aria-expanded',"false");
                    }
                  });

                  $(".dropdown").on('keydown',function(event){

                    if((event.which == 9 && !event.shiftKey && li_length == 0)||(event.which == 9 && event.shiftKey)){
                      $(".toggle-icon").removeClass("active");
                      $(".dropdown-manu").hide();
                      $('.dropdown').attr('aria-expanded',"false");
                    }
                  });
                  <#-- END: user click the out side of the dropdown then dropdown will be hidding -->
                <#-- End: dropdown code -->

                <#-- Start: users selected syndication button then show the conformation dialog box --> 
                $('#btn-post').click(function() {
                  lastFocus = document.activeElement;

                  $("#btn-post").attr("disabled", true);
                  $("#btn-post").addClass("bnt-post-disabled");
                  $(".loader-div").css("display", "block");
                  $('html, body').css('overflowY', 'hidden');

                  var selected_option = $(".check-box:checked");
                  var chkArray = [];
                  var selected_communities = "";
                  var isTargetsHaveFacebook = false;
                  selected_option.each(function() {
                    var commId = $(this).val();

                    $.each(target_communities_list, function(index, obj){
                      if(obj.communityId == commId && obj.communityUrl.toLowerCase().indexOf("facebook") > -1){
                        isTargetsHaveFacebook = true;
                      }
                    }); 
                    chkArray.push(commId);
                    selected_communities += "<li>"+$(this.parentNode).children("label")[0].textContent+"</li>";
                  });
                  var selected = "";
                  selected = chkArray.join(',');

                  selected_communities = "<ol class='list-communities'>"+selected_communities+"</ol>";

                  var unselected_option = $(".check-box:not(:checked):not(:disabled)");
                  var unchkArray = [];
                  unselected_option.each(function() {
                    unchkArray.push($(this).val());
                  });
                  var unselected = "";
                  unselected = unchkArray.join(',');

                  if(selected.length > 0){
                    if("${accessToken}" == ""){ 

                      var message_text = "Please contact the community administrator for further authorization.";
                      alertPopUP(message_text);
                      $("#btn-post").attr("disabled", false);
                      $("#btn-post").removeClass("bnt-post-disabled");
                      
                    }else if("${isAuthorizedFacebook?c}" == "false" && isTargetsHaveFacebook){
                      var message_text = "Please contact the community administrator for facebook authorization.";
                      alertPopUP(message_text);
                      $("#btn-post").attr("disabled", false);
                      $("#btn-post").removeClass("bnt-post-disabled");

                    } else {
                      
                      var message = '<p>This message will be syndicated with following communities.</p>'+selected_communities+'<p>Do you want to proceed?</p>';

                      $('#dialogbox-popup').html(message);

                      $(".loader-div").css("display", "none");
                      
                      $("#dialogboxModal").css("display","block");
                      
                      
                      dialogboxModalOpen = true;
                      dialogboxModal.setAttribute('tabindex', '0');
                      dialogboxModal.focus();

                      //hidden scrol bar in main html
                      $('html, body').css('overflowY', 'hidden');
                    } 
                  }else {
                    var message_text = "Select at least one of the communities from the dropdown list.";
                    alertPopUP(message_text);
                    $("#btn-post").attr("disabled", false);
                    $("#btn-post").removeClass("bnt-post-disabled");
                  }   
                });<#-- End: users selected syndication button then show the conformation dialog box -->

                <#--Start: user selected cancel button in conformation dialog box then close the  conformation dialog box-->
                $(".btn-cancel,.dialogbox-close").click(function(){
                              
                  $("#dialogboxModal").css("display","none");
                  $('html, body').css('overflowY', 'visible');
                  $("#btn-post").attr("disabled", false);
                  $("#btn-post").removeClass("bnt-post-disabled");
                  dialogboxModal.setAttribute('tabindex', '-1');
                  dialogboxModalOpen = false;
                  lastFocus.focus();
                });<#--End: user selected cancel button in the confirmation dialog box then close the  confirmation dialog box-->

                <#--Start: user selected proceed button in conformation dialog box then pass the relevanted detail to middleware -->
                $(".btn-proceed").click(function(){

                  var selected_option = $(".check-box:checked");
                  var chkArray = [];

                  selected_option.each(function() {
                      chkArray.push($(this).val());
                  });
                  var selected = "";
                  selected = chkArray.join(',');

                  var unselected_option = $(".check-box:not(:checked):not(:disabled)");
                  var unchkArray = [];
                  unselected_option.each(function() {
                      unchkArray.push($(this).val());
                  });
                  var unselected = "";
                  unselected = unchkArray.join(',');

                  $("#dialogboxModal").css("display","none");
                  $('html, body').css('overflowY', 'visible');
                  $(".loader-div").css("display", "block");

                  dialogboxModal.setAttribute('tabindex', '-1');
                  dialogboxModalOpen = false;
                  lastFocus.focus();
                  <#-- userExisting(selected,unselected); -->
                  $('#btn-publish').trigger( "click" );
                });<#--End: user selected proceed button in the confirmation dialog box then pass the relevant detail to middleware -->
                
                <#--Start: display the pop ups  -->
                function alertPopUP(message){
                  
                  $('#alert-popup').html('<p>'+message+'</p>');
                        
                  $(".loader-div").css("display", "none");

                  $("#alertModal").css("display","block");
                  
                  alertboxModalOpen = true;
                  alertboxModal.setAttribute('tabindex', '0');
                  alertboxModal.focus();

                  //hidden scrol bar in main html
                  $('html, body').css('overflowY', 'hidden');

                  $(".alert-popup-close,.close1").click(function(){
                    
                    $("#alertModal").css("display","none");
                    
                    alertboxModal.setAttribute('tabindex', '-1');
                    alertboxModalOpen = false;
                    lastFocus.focus();
                    
                    $('html, body').css('overflowY', 'visible');
                    if (isReload == true) {
                      location.reload();
                    }
                  });
                }<#--End: display the pop ups  -->

                <#--Start: if admin then passing thread details to midelware,if normal user then passing to admin page and if super users then passing thread details to midelware-->
                $('#btn-publish').click(function() {
                  $(".loader-div").css("display", "block");
                    
                  var selected_option = $(".check-box:checked");
                  var chkArray = [];
                  selected_option.each(function() {
                      chkArray.push($(this).val());
                  });
                  var selected = "";
                  selected = chkArray.join(',');

                  var unselected_option = $(".check-box:not(:checked):not(:disabled)");
                  var unchkArray = [];
                  unselected_option.each(function() {
                      unchkArray.push($(this).val());
                  });
                  var unselected = "";
                  unselected = unchkArray.join(',');

                  if (selected.length > 0) {
                    var id = ${ThreadId};
                    var requestType = "${macroDetails.send_to_admin_requestType}";
                    var jsonObj = {
                        "details_list": [{
                            "tid": id,
                            "targetCommunity": selected
                        }]
                    };
                      
                    if ("${macroDetails.isSyndicatorAdmin?c}" == "true") {
                      
                      var requestType = "${macroDetails.post_to_target_requestType}";
                      var status = "publish";
                      
                      <#-- if(${user.id} != ${msg_author_id?number}){
                        sendPriviteMessage(${msg_author_id?number});
                      } -->
                      publishing(jsonObj, requestType, selected, unselected, status);
                    } else if(${user.id} == ${msg_author_id?number} && ${macroDetails.isNominator?c} ){
                      
                      var requestType = "${macroDetails.send_to_admin_requestType}";
                      var status = "initial";
                      sendAuditINFO(jsonObj, requestType, selected, unselected,status);
                    } else if("${macroDetails.isSyndicator?c}" == "true"){

                      var requestType = "${macroDetails.send_to_admin_requestType}";
                      var status = "initial";
                      sendAuditINFO(jsonObj, requestType, selected, unselected,status);
                      <#-- if(${user.id} != ${msg_author_id?number}){
                        sendPriviteMessage(${msg_author_id?number});
                      } -->
                    }
                  }
                });
                <#--End: if admin then passing thread details to midelware,if normal user then passing to admin page -->

                <#-- Start: Set the value in message level metadata -->
                function setMetadataValue(selected, unselected,status) {

                  $.ajax({
                      type: 'POST',
                      url: '${macroDetails.set_metadata}',
                      data: ({
                          "Thread_ID": "${ThreadId}",
                          "selected":selected,
                          "unselected": unselected,
                          "status":status
                      }),

                      success: function(response) {
                        if ("${macroDetails.isNominator?c}" == "true" || "${macroDetails.isSyndicator?c}" == "true") {
                          if(response.response.status == "success"){
                            
                            var message_text = "The message is successfully sent for moderation.";
                            alertPopUP(message_text);
                            isReload = true;
                          } else if(response.response.status == "error"){
                            
                            var message_text = response.response.message;
                            alertPopUP(message_text);
                          } 
                        }
                      },
                      error: function(response) {
                      }
                  });
                }<#-- End: Set the value in message level metadata -->

                <#-- Start: If admin posting the message then directly Passing thread details to midelware  -->
                function publishing(jsonObj, requestType, selectedCommunities, unselected, status) { 

                  $.ajax({
                    type : 'POST',
                    url : '${macroDetails.post_url}', 
                    data: ({    
                    "communityType":"${macroDetails.communityType}",
                    "sourceCommunityID":"${sourceCommunityDetails.communityId}",
                    "icsTenantId":"${sourceCommunityDetails.icsTenantId!}",
                    "requestType":requestType,
                    "selected_messages_object":JSON.stringify(jsonObj),
                    "requested_user_details":JSON.stringify(requested_user_details),
                    "approvedOrRejectedAuthorDetails":JSON.stringify(requested_user_details)
                    }),
                    success : function(response){
                      var json_obj = response;
                      if(json_obj != ""){
                        if(json_obj.response.status == "success"){

                          var message_text = json_obj.response.message;
                          setMetadataValue(selectedCommunities, unselected,status);
                          isReload = true;
                        }else if (json_obj.response.status == "error") {
                           var message_text = json_obj.response.message;
                        }else{
                          var message_text = "internal server error.Please try after some time.";
                        }
                        alertPopUP(message_text);
                      }
                    },
                    error : function(response){                           
                      var json_obj = response;
                      if(json_obj != ""){
                        if(json_obj.response.status == "success"){
                          var message_text = json_obj.success_details.message;
                          isReload = true;
                        }else if (json_obj.response.status == "error") {
                           var message_text = json_obj.response.message;
                        }else{
                         var message_text = "internal server error.Please try after some time.";
                        }
                        alertPopUP(message_text);                            
                      }
                    }
                  });
                }<#-- End: If admin posting the message then directly Passing thread details to midelware  -->

                <#--Start:Passing thread details to midelware for audit information-->
                function sendAuditINFO(jsonObj, requestType, selectedCommunities, unselected,status) {

                    $.ajax({
                        type: 'POST',
                        url: '${macroDetails.audit_url}',
                        data: ({
                            "communityType": "${macroDetails.communityType}",
                            "sourceCommunityID": "${sourceCommunityDetails.communityId}",
                            "icsTenantId":"${sourceCommunityDetails.icsTenantId!}",
                            "requestType": requestType,
                            "selected_messages_object": JSON.stringify(jsonObj),
                            "requested_user_details":JSON.stringify(requested_user_details)
                        }),
                        success: function(response) {
                          var json_obj = response;
                          if (json_obj != "") {
                            if (json_obj.response.status == "success") {
                                setMetadataValue(selectedCommunities, unselected,status);
                            } else if (json_obj.response.status == "error") {
                              var message_text = json_obj.response.message;
                              alertPopUP(message_text);  
                            }else {
                              var message_text = "internal server error.Please try after some time.";
                              alertPopUP(message_text);
                            }
                          }
                        },
                        error: function(response) {
                          var json_obj = response;
                          if (json_obj != "") {
                            if (json_obj.response.status == "success") {
                                var message_text = json_obj.response.message;
                            } else if (json_obj.response.status == "error") {
                                var message_text = json_obj.response.message;
                            } else {
                              var message_text = "internal server error.Please try after some time.";
                            }
                            alertPopUP(message_text);
                          }
                        }
                    });
                }<#--End:Passing thread details to midelware for audit information-->

                <#--Start: Getting message Status from midelware to display in ui-->
                $(document).on('click', '#btn-status', function() {
                  lastFocus = document.activeElement;
                  if("${accessToken}" != ""){
                    $(".loader-div").css("display","block");
                    $(".loader-div").css({"display":"inline-block"});

                    var json_obj = "";

                    $.ajax({
                        type: 'GET',
                        url: '${macroDetails.msg_status}',
                        "async": true,
                        data: {
                            "threadId": "${ThreadId}",
                            "communityId": "${sourceCommunityDetails.communityId}",
                            "icsTenantId":"${sourceCommunityDetails.icsTenantId!}",
                            "requestType":"${macroDetails.message_status_requestType}"
                        },
                        success: function(response) {
                          json_obj = response;

                          if (json_obj != "" && json_obj.hasOwnProperty('response')) {
                            if (json_obj.response.status == "success") {
                              var number_of_rows = json_obj.response.resultlist.length;
                              if (number_of_rows > 0) {

                                //Preparing table using json object 
                                var table_body = '<table border="1" id="tblHTML"><thead><tr><th>Target</th><th>Status</th><th>Source Message ID</th><th>Target Message ID</th><th>Post Time</th><th>Event Type</th></tr></thead><tbody>';

                                for (i = 0; i < json_obj.response.resultlist.length; i++) {
                                  table_body += '<tr>';
                                  table_body += '<td>';
                                  table_body += json_obj.response.resultlist[i].target_community_name ;
                                  table_body += '</td>';

                                  table_body += '<td>';
                                  if (json_obj.response.resultlist[i].error_description != "") {

                                    table_body += json_obj.response.resultlist[i].message_status + '(' + json_obj.response.resultlist[i].error_description + ')';
                                  } else {
                                      
                                    table_body += json_obj.response.resultlist[i].message_status;
                                  }
                                  table_body += '</td>';

                                  table_body += '<td>';
                                  table_body += '<a target="_blank" href="'+json_obj.response.resultlist[i].source_message_url+'">'+json_obj.response.resultlist[i].source_message_id + '</a>(' + json_obj.response.resultlist[i].message_type + ')';
                                  table_body += '</td>';

                                  table_body += '<td>';
                                  if(json_obj.response.resultlist[i].target_message_id != ""){
                                    table_body += '<a target="_blank" href="'+json_obj.response.resultlist[i].target_message_url+'">'+json_obj.response.resultlist[i].target_message_id + '</a>(' + json_obj.response.resultlist[i].message_type + ')';
                                  }
                                  table_body += '</td>';

                                  table_body += '<td>';
                                  if (json_obj.response.resultlist[i].create_or_edit_time != "") {
                                    var DTime = json_obj.response.resultlist[i].create_or_edit_time;
                                    var DZ = DTime.split(" ")[0] + "T" + DTime.split(" ")[1] + "Z";
                                    var localeDate = new Date(DZ);
                                    table_body += localeDate.toLocaleString();
                                  } else {
                                      
                                    table_body += json_obj.response.resultlist[i].create_or_edit_time;
                                  }
                                  table_body += '</td>';

                                  table_body += '<td>';
                                  table_body += json_obj.response.resultlist[i].event_type;
                                  table_body += '</td>';

                                  table_body += '</tr>';
                                }

                                table_body += '</tbody></table>';
                                $('#tableDiv').html(table_body);
                                $(".search-bar").css("display", "block");
                              } else {
                                $('#tableDiv').html('<p >No results found</p>');
                                $(".search-bar").css("display", "none");
                              }
                            } else if (json_obj.response.status == "error") {
                                $('#tableDiv').html('<p>' + json_obj.response.message + '</p>');
                                $(".search-bar").css("display", "none");
                            } 
                          }else{
                            $('#tableDiv').html('<p>internal server error.Please try after some time.</p>');
                            $(".search-bar").css("display", "none");
                          }

                          $(".loader-div").css("display", "none");
                          $("#statusModal").css("display","block");

                          statusboxModalOpen = true;
                          statusboxModal.setAttribute('tabindex', '0');
                          statusboxModal.focus();

                          //hidden scrol bar in main html
                          $('html, body').css('overflowY', 'hidden');

                          $(".btn-status-close, .status-close").click(function(){
                            $("#statusModal").css("display","none");
                            $('html, body').css('overflowY', 'visible');
                            statusboxModal.setAttribute('tabindex', '-1');
                            statusboxModalOpen = false;
                            lastFocus.focus();
                          });
                        },
                        error: function(response) {
                          var json_obj = response;
                          if (json_obj != "" && json_obj.hasOwnProperty('response')) {
                            if (json_obj.response.status == "success") {
                              var message_text = json_obj.success_details.message; 
                            } else if (json_obj.response.status == "error") {
                                
                              var message_text = json_obj.response.message;
                            } else {
                              var message_text = "internal server error.Please try after some time.";
                            }  
                          }else{
                            var message_text = "internal server error.Please try after some time.";
                          }
                          alertPopUP(message_text); 
                        }
                    }); /*END of ajax*/
                  }else{ 
                    var message_text = "Please contact the community administrator for further authorization.";
                    alertPopUP(message_text);

                    $("#btn-post").attr("disabled", false);
                    
                    $("#btn-post").removeClass("bnt-post-disabled");
                  }
                });<#--End: Getting message Status from midelware to display in ui-->

                <#--Start: filter in table-->
                $("#search").on("keyup", function() {
                  var value = $(this).val().toLowerCase();
                  $("table tr").filter(function(index) {
                      if (index > 0) {
                          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                      }
                  });
                });<#--End: filter in table-->

                <#--Start: onclick register button open model to show the reistion links-->
                $('#btn-register').click(function() {
                  
                  if("${macroDetails.isSyndicator?c}" == "true" && "${sourceCommunityDetails.is_sso?c}"== "true"){
                    createSuperUser();
                  }else{
                    var message_text = "<br>" + register_list + "<br>";
                    alertPopUP(message_text);
                  }
                });<#--End: onclick register button open model to show the reistion links-->

                <#--Start: If admin posting another author messages, if the author is not existed then send a private message to message author -->
                function sendPriviteMessage(user_id){
                  $.ajax({
                    type: "post",
                    url: "/restapi/vc/postoffice/notes/send",
                    data:({
                           "notes.recipient":"/users/id/"+user_id,
                           "notes.subject":"More Eyes Want to See Your Community Contribution",
                           "notes.note": "Hello ${msg_author_login},<br>The administrator is migrating this <a href='${http.request.url}'>message</a> to the following target communities.Please register to post the message author as you in target communities.<br>"+register_list

                         }),
                    success: function(result) { 
                    },
                    error : function(data){
                    }            
                  });
                }<#-- End: If admin posting another author messages, if the author is not existed then send a private message to message author -->
                    
                <#--Start: In this function user details pass to middleware for check user is existing/not in target communities then display the relevant popups -->
                function userExisting(selectedID, unselectedID){
                  var list_communities = "";
                  selectedCommunities = [];
                  unselectedCommunity = [];
                  selectedCommunities = selectedID;
                  unselectedCommunity = unselectedID;

                  /*Start:ajax call*/
                  $.ajax({
                      type: 'get',
                      url: '${macroDetails.user_status}',
                      data: ({
                          "Thread_ID": "${ThreadId}",
                          "targetCommunities": selectedID,
                          "requestType":"${macroDetails.user_status_requestType}"
                      }),

                      success: function(user_response) {
                        var json_obj = user_response;

                        if (json_obj != "" && json_obj.hasOwnProperty('response')) {
                          if (json_obj.response.status == "success") {
                            var number_of_rows = json_obj.response.resultlist.length;

                            if (number_of_rows != 0) {
                              for (var i = 0; i < number_of_rows; i++) {
                                if (json_obj.response.resultlist[i].userexists == false) {
                                  if (list_communities == "") {
                                    list_communities += "<li>" + json_obj.response.resultlist[i].communityName + "</li>";
                                    
                                    if(target_communities_list != ""){
                                      for(var j=0;j< target_communities_list.length; j++){
                                        if (json_obj.response.resultlist[i].communityName == target_communities_list[j].communityName){
                                          register_list += "<tr><td >"+(i+1)+".</td><td class='register-community-name'>" + target_communities_list[j].communityName + "</td><td><a class='register-button' target='_blank' href='"+target_communities_list[j].registrationUrl+"'>Register</a></td></tr>";
                                        }
                                      }
                                    } 
                                  } else {
                                    list_communities += "<li>" + json_obj.response.resultlist[i].communityName + "</li>";
                                    if(target_communities_list != ""){
                                       
                                      for(var j=0;j< target_communities_list.length; j++){
                                        if (json_obj.response.resultlist[i].communityName == target_communities_list[j].communityName){
                                          register_list += "<tr><td >"+(i+1)+".</td><td class='register-community-name'>" + target_communities_list[j].communityName + "</td><td><a class='register-button' target='_blank' href='"+target_communities_list[j].registrationUrl+"'>Register</a></td></tr>";
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                              register_list = "<table style='width: 50%;'><tbody>"+register_list+"</tbody></table>" ;
                            }
                            if (list_communities == "") {
                              var id = ${ThreadId};
                                
                              var jsonObj = {
                                  "details_list": [{
                                      "tid": id,
                                      "targetCommunity": selectedID
                                  }]
                              };
                                
                              if ("${macroDetails.isSyndicatorAdmin?c}" == "true") {
                                  
                                var requestType = "${macroDetails.post_to_target_requestType}";
                                var status = "publish";
                                <#-- if(${user.id} != ${msg_author_id?number}){
                                  sendPriviteMessage(${msg_author_id?number});
                                } -->
                                
                                publishing(jsonObj, requestType, selectedID, unselectedID, status);
                              } else if(${user.id} == ${msg_author_id?number} && ${macroDetails.isNominator?c} ){
                                var requestType = "${macroDetails.send_to_admin_requestType}";
                                var status = "initial";
                                sendAuditINFO(jsonObj, requestType, selectedID, unselectedID,status);
                              } else if("${macroDetails.isSyndicator?c}" == "true"){
                                
                                var requestType = "${macroDetails.send_to_admin_requestType}";
                                var status = "initial";
                               sendAuditINFO(jsonObj, requestType, selectedID, unselectedID,status);
                                <#-- if(${user.id} != ${msg_author_id?number}){
                                  sendPriviteMessage(${msg_author_id?number});
                                } -->
                              }
                            } else {

                              if("${macroDetails.isSyndicator?c}" == "true"){

                                $('#unexists-popup').html("<p>User name does not exists in following communities.</p><br><ol class='list-communities'>" + list_communities + "</ol><br><p>Do you want to register before Publishing</p>");
                              } else{
                                $('#unexists-popup').html("<p>User name does not exists in following communities.</p><br><ol class='list-communities'>" + list_communities + "</ol><br><p>Do you want to register before Publishing</p>");
                              }

                              $(".loader-div").css("display", "none");

                              //open the modal 
                              $("#unexistsModal").css("display","block");

                              //hidden scrol bar in main html
                              $('html, body').css('overflowY', 'hidden');

                              // When the user clicks on <span> (x) or Yes os no buttons, close the modal
                              $(".unexists-close, #btn-register, #btn-publish").click(function() {
                                $("#unexistsModal").css("display","none");

                                //display scrol bar in main html
                                $('html, body').css('overflowY', 'visible');
                              });
                            }  
                          } else if (json_obj.response.status == "error") {
                            
                            var message_text = json_obj.response.message;
                            alertPopUP(message_text);
                          } else {

                            var message_text = "internal server error.Please try after some time.";
                            alertPopUP(message_text);
                          }
                        }else {
                          var message_text = "internal server error.Please try after some time.";
                          alertPopUP(message_text); 
                        }
                      },
                      error: function(response) {
                        var json_obj = response;
                        if (json_obj != "" && json_obj.hasOwnProperty('response')) {
                          if (json_obj.response.status == "success") {

                            var message_text = json_obj.response.message;
                          } else if (json_obj.response.status == "error") {
                              
                            var message_text = json_obj.response.message;
                          } else{
                            var message_text = "internal server error.Please try after some time.";
                          }
                          alertPopUP(message_text);
                        }else {
                          var message_text = "internal server error.Please try after some time.";
                          alertPopUP(message_text);
                        }
                      }
                  }); /*END: ajax call*/
                }<#--End: In this function user details pass to middleware for check user is existing/not in target communities then display the relevant popups -->

                <#--Start: super user not existing target communities auto creating user in target communities in sso enable communities only  -->
                function createSuperUser(){
                  
                  var requestType = "${macroDetails.post_to_target_requestType}";
                  var status = "publish";
                  var id = ${ThreadId};

                  var postDetails = {
                      "details_list": [{
                          "tid": id,
                          "targetCommunity": selectedCommunities
                      }]
                  };

                  $.ajax({
                      type:"post",
                      url: '${macroDetails.user_status}',
                      data: ({
                          "Thread_ID": "${ThreadId}",
                          "targetCommunities": selectedCommunities,
                          "requestType":"${macroDetails.user_create_requestType}"
                      }),
                      success:function(data){
                        var json_obj = data;
                        if (json_obj != "" && json_obj.hasOwnProperty('response')) {

                          if(json_obj.response.status == "success"){

                            publishing(postDetails, requestType, selectedCommunities, unselectedCommunity, status);
                          } else if (json_obj.response.status == "error") {
                              var message_text = json_obj.response.message;
                              alertPopUP(message_text);
                          }
                        }
                      },
                      error: function(data){
                        var message_text = "User is Creation is field. Please try after some time.";
                        alertPopUP(message_text);
                      }
                  });
                }<#--End: super user not existing target communities auto creating user in target communities in sso enable communities only  -->
              }//End try block 
              catch(err) {
                console.log(err);
              }//End catch block
            })(LITHIUM.jQuery);
          </@liaAddScript>
        </#if><#--End: checking community is active or not, interaction style is active or not, checking this message is the target or not, if it is category is community then display in that categories only and if it is not the category is community display the hole community-->
      </#if><#--End: User is an Admin or actual message author or super users we can display widget -->
    </#if><#-- End: checking anonymous users and checking page.context.thread is empty or not-->
  </#if>
<#recover>
  <h3 class="ics-element-donot-delete error-info" style="display: none">Error Message: ${.error}</h3>   
</#attempt>