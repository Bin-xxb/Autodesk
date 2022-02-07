<#attempt>
  <#--
   Intelligent Content Syndication.
   (ICS) 2019 iTalent By Ravindra
  for #This component displays 

          1. moderation messages with pagination in Active Messages Tab 
          2. syndicated messages status with pagination in Status Tab
          3. reprocess the field threads with pagination in Reprocess Tab
          4. force sync option and Reset community syndication option in Support & Maintenance

          #
  -->
  <#-- <#include "cross_community_macro.ftl"> -->
  <#import "cross_community_macro.ftl" as macroDetails>
  <#assign state = (http.request.parameters.name.get("state",""))?html />
  <#assign fbError = (http.request.parameters.name.get("error",""))?html />
  <#-- moved the css into skin scss
  <link rel="stylesheet" type="text/css" href='${asset.get("/html/assets/ics.css")}' integrity="sha384-2SyW0Nv1G1k2eTXBYS3yzfMTnGH461STc6Ss9WpXpDTMG2TCDibjua3/9FjuEx7Y" crossorigin="anonymous">
  -->
  <script src='${asset.get("/html/assets/ics-angular.min.js")}' integrity="sha384-a/GTefoLxeOy99bEqfp1WWz9/01LtNmYytYXzvWtzPIw2qgWTSZf+73PdZCrdQxC" crossorigin="anonymous"></script>
    
  <#-- we are getting the okta_codeAPI, ClientID, redirect_URI, Scope values from "cross_community_macro"   -->
  <#assign loginURL = "${macroDetails.okta_codeAPI}?client_id=${macroDetails.ClientID}&response_type=code&scope=${macroDetails.Scope}&redirect_uri=${macroDetails.redirect_URI}&state=state-xyz"/>

  <#assign facebookURL = "https://www.facebook.com/v9.0/dialog/oauth?client_id=${macroDetails.facebookClientId}&redirect_uri=${macroDetails.redirect_page_url}&state=ICSFacebookAuthorization&scope=pages_read_user_content,pages_manage_posts,pages_show_list,pages_manage_engagement,pages_read_engagement,groups_access_member_info" />

  <#-- we are getting the category_as_community_value values and communityDetails macro calling  from "cross_community_macro"   -->
  <#assign categoryAsCommunityValue = macroDetails.category_as_community_value />

  <#if categoryAsCommunityValue?has_content == false><#-- here we are checking the category_as_community_value is empty not not if it is empty the -->
    <#assign  communityDetails = macroDetails.communityDetails("","")  />
        
    <#assign communityDetailsObject = communityDetails.communityObj/>
    <#assign categoryId = communityDetails.categoryId />

    <#assign sourceCommunityDetails = communityDetailsObject?eval.community_details.source/>
    <#assign targetCommunityDetails = communityDetailsObject?eval.community_details.target/>
    <#assign communityId = sourceCommunityDetails.communityId/>
    <#assign icsTenantId = sourceCommunityDetails.icsTenantId!""/>
    <#assign isAccessToFBAuthorization  = false/>
    <#list targetCommunityDetails as targetCommunity> 
      <#assign communityUrl = targetCommunity.communityUrl />
      <#if communityUrl?contains("facebook") || communityUrl?contains("FACEBOOK") || communityUrl?contains("Facebook")|| communityUrl?contains("FaceBook") >
        <#assign isAccessToFBAuthorization  = true/>
        <#break>
      </#if>
    </#list>
  <#else>
    <#assign catAsCommunity = "[" />
    <#list categoryAsCommunityValue?eval.categories_list as categoryAsCommunity>
      <#assign categoryId = categoryAsCommunity.categoryID !"" />
        <#assign  communityDetails = macroDetails.communityDetails("",categoryId)  />
        <#assign communityDetailsObject = communityDetails.communityObj/>
        <#assign sourceCommunityDetails = communityDetailsObject?eval.community_details.source/>
        <#assign icsTenantId = sourceCommunityDetails.icsTenantId!""/>
        <#assign targetCommunityDetails = communityDetailsObject?eval.community_details.target/>
        <#assign isAccessToFBAuthorization  = false/>
        <#list targetCommunityDetails as targetCommunity> 
          <#assign communityUrl = targetCommunity.communityUrl />
          <#if communityUrl?contains("facebook") || communityUrl?contains("FACEBOOK") || communityUrl?contains("Facebook")|| communityUrl?contains("FaceBook") >
            <#assign isAccessToFBAuthorization  = true/>
            <#break>
          </#if>
        </#list>
        
        <#if catAsCommunity !="[">
          <#assign catAsCommunity = catAsCommunity+"," />
        </#if>
        <#assign catAsCommunity = catAsCommunity+'{"communityName":"${categoryAsCommunity.communityName}","communityID":${categoryAsCommunity.communityID},"targetCategoryId":"${categoryAsCommunity.targetCategoryId}","categoryID":"${categoryAsCommunity.categoryID}","icsTenantId":"${icsTenantId}","isAccessToFBAuthorization":${isAccessToFBAuthorization?c}}' />
    </#list>
    <#assign catAsCommunity = catAsCommunity+"]" />
     <#assign categoryAsCommunityValue = '{"categories_list":${catAsCommunity}}'/>
    <#assign communityId = ""/>
    <#assign icsTenantId = ""/>
    <#assign isAccessToFBAuthorization  = false/>
  </#if>

  <#if user.sso_id??>
  <#assign user_sso_id = user.sso_id/>
  <#else>
  <#assign user_sso_id = ""/>
  </#if>

  <#if user.registered && !user.anonymous && macroDetails.isLithiumAdmin>


    <div  ng-app="myApp" ng-controller="myCtrl as myCtrl" bn-document-click="myCtrl.handleClick( $event )" name="myForm" data-ng-init="myCtrl.init()" class="moderation-section">
      <div ng-hide="myCtrl.accessToken === ''">
        <div class="category-data" ng-if="myCtrl.categoryAsCommnity == true" ng-cloak>
          <select class="category-list" ng-model="myCtrl.selectedCategory" ng-options="item.communityName for item in myCtrl.categoryDetailsList" ng-init="myCtrl.selectedCategory = myCtrl.categoryDetailsList[0]" ng-change="myCtrl.categoryChanges()" >

          </select>
        </div>
        <div class="reports">
          <button class="lia-button lia-button-primary" onclick="window.open('${macroDetails.powerBIReportsIframeUrl}', '_blank')">Syndication Reports</button>
        </div>
        <div class="custom-tab-container">
          <div class="tabs">

            <ul class="lia-tabs-standard">

              <li class="lia-tabs custom-tab" ng-click="myCtrl.activeMessages();myCtrl.activePage = 1" ng-class="{'lia-tabs-active':(myCtrl.messagesStatusListState == false && myCtrl.forceSyncRequstState == false && myCtrl.reprocessMessagesListState == false && myCtrl.supportStatus == false && myCtrl.isReportsTab == false)}"  >
                <span class="Messages-link"><a class="lia-link-navigation posts-link tab-link lia-custom-event">Active Messages</a></span>
              </li>
              <li class="lia-tabs custom-tab" ng-class="{'lia-tabs-active':(myCtrl.messagesStatusListState == true && myCtrl.forceSyncRequstState == false && myCtrl.reprocessMessagesListState == false && myCtrl.supportStatus == false && myCtrl.isReportsTab == false)}" ng-click="myCtrl.selectedItem = myCtrl.statusFilter[0];myCtrl.messagesStatusList();myCtrl.activePage = 1;myCtrl.selectedItem = myCtrl.statusFilter[0];" >
                <span><a class="lia-link-navigation posts-link tab-link lia-custom-event">Status</a></span>
              </li>
              <#-- <li class="lia-tabs custom-tab" ng-class="{'lia-tabs-active':(myCtrl.messagesStatusListState == false && myCtrl.forceSyncRequstState == true && myCtrl.reprocessMessagesListState == false && myCtrl.supportStatus == false)}" ng-click="myCtrl.forceSyncRequst()">
                <span><a class="lia-link-navigation posts-link tab-link lia-custom-event">Force Sync</a></span>
              </li> -->
              <li class="lia-tabs custom-tab" ng-class="{'lia-tabs-active':(myCtrl.messagesStatusListState == false && myCtrl.forceSyncRequstState == false && myCtrl.reprocessMessagesListState == true && myCtrl.supportStatus == false && myCtrl.isReportsTab == false)}" ng-click="myCtrl.handlingReprocessingMessages()" >
                <span><a class="lia-link-navigation posts-link tab-link lia-custom-event">Reprocess</a></span>
              </li>

              <li id="support-maintenance-tab" class="lia-tabs custom-tab" ng-class="{'lia-tabs-active':(myCtrl.messagesStatusListState == false && myCtrl.forceSyncRequstState == false && myCtrl.reprocessMessagesListState == false && myCtrl.supportStatus == true && myCtrl.isReportsTab == false)}" ng-click="myCtrl.supportTab()">
                <span><a class="lia-link-navigation posts-link tab-link lia-custom-event">Support & Maintenance</a></span>
              </li>

              <#-- <li class="lia-tabs custom-tab" ng-class="{'lia-tabs-active':(myCtrl.messagesStatusListState == false && myCtrl.forceSyncRequstState == false && myCtrl.reprocessMessagesListState == false && myCtrl.supportStatus == false && myCtrl.isReportsTab == true)}" ng-click="myCtrl.showReports()">
                <span><a class="lia-link-navigation posts-link tab-link lia-custom-event">Syndication Reports</a></span>
              </li> -->

            </ul>
          </div>
        </div>
        <div class="overlay"></div>
        <div class="data-container">
          
          <#-- Active Messages response -->
          <div class="tab-container-section" ng-if="myCtrl.messagesStatusListState == false && myCtrl.forceSyncRequstState == false && myCtrl.reprocessMessagesListState == false && myCtrl.supportStatus == false && myCtrl.isReportsTab == false"  ng-cloak>
            <div class="post-all-option bg-section" ng-if="myCtrl.count > 0">
              <#-- <div class="select-checkbox">
                <span>
                  <input type="checkbox" name="select All" id="select-all" class="select-all" ng-click="myCtrl.selectAll()" ng-model="myCtrl.isAllSelected"/>
                </span>
              </div>
              <div id="message-content">
                <button id="post-all-button" class="post-all-button lia-button lia-button-primary" ng-click="myCtrl.postAll()">Syndicate All</button> 
              </div> -->
              <span class="search_bar">
                <input type="search" id="search" ng-model="myCtrl.searchText" placeholder="Search here..."/>
              </span>
              <div class="clear"></div>
            </div>

            <div class="messagesData" ng-repeat="messagesData in myCtrl.messagesResults | filter :myCtrl.searchText track by $index">
              <div class="msg-obj">
                <div id="msg-content" class="msg-content">
                  <div class="Message-subject-cell">
                    <div class="select-checkbox">
                      <input type="checkbox" name="checkbox" id="msg-check" class="msg-check" ng-change="myCtrl.selectOptions()" ng-model="messagesData.isSelected" value="{{messagesData.msg_id}}"/>
                    </div>
                    <div class="msg-subject">
                      <a href="{{messagesData.msg_href}}">{{messagesData.msg_subject}}</a>
                    </div>
                  </div>
                  <div class="lia-info-area">
                    <span class="msg-user-name">By <a href="{{messagesData.msg_author_href}}">{{messagesData.msg_author}}</a></span>
                    <span class="msg-date-time"> {{messagesData.msg_date}} {{messagesData.msg_time}}</span>
                  </div>
                </div>
                <div class="target-communities-options">
                  <ul>                    
                    <li id="commnuty-option" class="commnuty-option" ng-repeat="communityDetails in messagesData.target_community_details ">
                      <div class="community-checkbox"> 
                        <span class="checkbox">
                          <input type="checkbox" name="communityName" class="community-id" id="community-id" value='{{communityDetails.communityId}}' ng-checked="communityDetails.communityStatus === 'selected'" ng-disabled="communityDetails.communityStatus === 'publish' || communityDetails.communityStatus === 'reject' || communityDetails.communityStatus === 'completed'" ng-model="communityDetails.isSelected"/>
                        </span>
                        <span ng-class="{'disabled-label':(communityDetails.communityStatus === 'publish' || communityDetails.communityStatus === 'reject' || communityDetails.communityStatus === 'completed')}">{{communityDetails.communityName}}</span>
                      </div>
                    </li>
                  </ul>
                  <div class="community-inputs">    
                    <button id="post-button" class="btn-cs lia-button lia-button-primary" ng-click="myCtrl.postMessages($index)">Syndicate</button>    
                    <button id="reject-button" ng-click="myCtrl.rejectMessages($index)" class="btn-cs lia-button lia-button-primary">Reject</button>   
                  </div>  
                </div>
              </div>
              <div class="clear"></div>
            </div>
            <div class="clear"></div>
          </div>

          <#-- Status results -->
          <div class="tab-container-section">
            <div class="tab-container-main" ng-if="myCtrl.messagesStatusListState == true" id="table-div" ng-cloak>
              <table id="response-table">
                <thead>
                  <tr class="table-th-bg">
                    <th>Target</th>
                    <th class="status-types-th">Status
                      <select class="status-types" ng-model="myCtrl.selectedItem" ng-options="item.name for item in myCtrl.statusFilter" ng-init="myCtrl.selectedItem = myCtrl.statusFilter[0]" ng-change="myCtrl.activePage = 1 ; myCtrl.messagesStatusList()"></select>
                    </th>
                    <th>Source Message Subject</th>
                    <th>Target Message ID</th>
                    <th>Post Time</th>
                    <#-- <th>Target Author Name</th> -->
                    <th>Event Type</th>
                  </tr>
                </thead>
                <tbody ng-if="myCtrl.count > 0">
                  <tr ng-repeat="statusData in myCtrl.statusResults">
                    <td>{{statusData.target_community_name}}</td>
                    <td>{{statusData.message_status}}<span ng-if="statusData.message_status == 'FAILED' && !statuData.error_description == ''">  ({{statuData.error_description}})</span></td>
                    <td><a target="_blank" href="{{statusData.source_message_url}}">{{statusData.message_subject}}</a></td>
                    <td><a target="_blank" href="{{statusData.target_message_url}}">{{statusData.target_message_id}}</a>
                      <span ng-if="!statusData.target_message_id == '' ">  ({{statusData.message_type}})</span></td>
                    <td>{{statusData.create_or_edit_date}}</td>
                    <#-- <td>{{statusData.target_message_author}}</td> -->
                    <td>{{statusData.event_type}}</td>
                  </tr>
                </tbody>
              </table>
              <div class="clear"></div>
            </div>
          </div>
          
          <#-- Reprocess Responce -->
          <div class="tab-container-section" ng-if="myCtrl.reprocessMessagesListState == true" id="table-div" ng-cloak>
            <div class="tab-container-main">
              <#-- <table id="response-table">
                <thead>
                  <tr >
                    <th>Target</th>
                    <th>Status</th>
                    <th>Source Message Subject</th>
                    <th>Reprocess Activity </th>
                  </tr>
                </thead>
                <tbody>
                  <tr ng-repeat="reprocessData in myCtrl.reprocessResults track by $index">
                    <td>{{reprocessData.target_community_name}}</td>
                    <td>{{reprocessData.message_status}}</td>
                    <td><a target="_blank" href="{{reprocessData.source_message_url}}">{{reprocessData.message_subject}}</a></td>
                    <td><button class="reprocess-button lia-button lia-button-primary" ng-click="myCtrl.reprocessMessages($index)">Reprocess</button></td>
                  </tr>
                </tbody>
              </table> -->
               <div class="reprocess-sync-div" ng-cloak>
                <label class="reprocess-sync-label">Reprocess<strong> *</strong></label>
                <form name="reprocessForm">
                  <div class="reprocess-sec">
                    <input type="text" name="input" ng-model="myCtrl.messageIds" placeholder="Enter Messages id with comma separated" id="reprocess-input" required ng-pattern="/^[0-9,]+$/">
                    <span class="error" ng-show="reprocessForm.input.$error.required">Required!</span>
                    <span class="error" ng-show="reprocessForm.input.$error.pattern">Allowed only numbers and comma(,)</span>
                  </div>
                  <button class="reprocess-button lia-button lia-button-primary" ng-click="myCtrl.reprocessingMessages()">Reprocess</button>
                </form>
              </div>
            </div>
          </div>

          <#-- support &  Maintenance-->
          <div class="tab-container-section" ng-if="myCtrl.supportStatus == true" ng-cloak>
            <div class="tab-container-main">
              <#-- <div class="force-sync-div " ng-cloak>
                <label class="force-sync-label">Thread ID<strong> *</strong></label>
                <form name="myForm">
                  <div class="forcesyncthread-sec">
                  <input type="text" name="input" ng-model="myCtrl.forceSyncThreadId" placeholder="Enter Thread ID"  ng-pattern="/^[0-9]*$/" class="forcefully-input" id="forcefully-input" ng-maxlength="20" required maxlength="20">

                  <span class="error" ng-show="myForm.input.$error.required">Required!</span>

                  <span class="error" ng-show="myForm.input.$error.pattern">Not a number!</span>

                  <span class="error" ng-show="myForm.input.$error.maxlength">Max 20 characters only!</span>
                </div>

                  <button class="forcefully-posting btn-left-mg lia-button lia-button-primary" id="forcefully-posting" ng-click="myCtrl.forceSyncMessages()" ng-disabled="myCtrl.forceSyncThreadId === ''|| myCtrl.forceSyncThreadId === undefined" ng-class="{'force-button':myCtrl.forceSyncThreadId === '','force-button-disable':myCtrl.forceSyncThreadId === undefined}">Force Sync</button>
                </form>
              </div> -->
              <div class="support-maintenance-div">
                <span>
                  <strong>*</strong>Reset community syndication.
                </span>
                <button class="access-token-button lia-button lia-button-primary" onclick=" window.open('${loginURL}','_self')">Community Syndication</button>
              </div>
              <div class="support-maintenance-div facebook-authorization-details" ng-if="myCtrl.isAccessToFBAuthorization ==true">
                <span>
                  <strong>*</strong>Facebook Authorization:
                </span>
                <button class="facebook-authorization lia-button lia-button-primary" onclick=" window.open('${facebookURL}','_self')"></i>Authorization</button>
              </div>
              <span ng-init="myCtrl.checkFacebookAuthorization()"></span>
            </div>
          </div>

          <#-- Reports tab -->
          <#-- <div class="tab-container-section" ng-if="myCtrl.isReportsTab == true" ng-cloak>
            <div>
              <iframe src="${macroDetails.powerBIReportsIframeUrl}" width="100%" height="500" allowfullscreen="allowfullscreen" webkitallowfullscreen="webkitallowfullscreen" mozallowfullscreen="mozallowfullscreen"></iframe>
            </div>
          </div> -->

          <div class="tab-container-main" ng-if="myCtrl.count === 0 && myCtrl.forceSyncRequstState === false && myCtrl.supportStatus == false && myCtrl.isReportsTab == false && myCtrl.reprocessMessagesListState == false" ng-cloak>
            <div class="no-result-found">
              <span>No results found.</span>
            </div>
          </div>

          <div id="custom-pagnation" class="lia-paging-full-wrapper lia-paging-pager lia-component-search-results-pager" id="pager" ng-hide="myCtrl.maxPage === 0 || myCtrl.maxPage ===1 " ng-cloak>
            <ul class="pagination pagination-sm inline pull-right">
              <li class="lia-paging-page-firstpage lia-component-firstpage">
                <a class="lia-link-navigation lia-custom-event" ng-class="{'previousDisable': myCtrl.activePage === 1 }" ng-click="myCtrl.goFristPage()"> 
                  <span class="lia-paging-page-arrow" title="Frist Page">&laquo;</span>
                </a>
              </li>
              <li class="lia-paging-page-previous lia-component-previous">
                <a class="lia-link-navigation lia-custom-event" ng-class="{'previousDisable': myCtrl.activePage === 1 }" ng-click="myCtrl.previousPage()"> 
                  <span class="lia-paging-page-arrow" title="Previous Page">&#8249;</span>
                </a>
              </li>

              <li class="lia-paging-page-ellipsis" ng-show="(myCtrl.activePage) > 2">
                <span class="lia-link-navigation lia-link-disabled" ng-cloak>...</span>
              </li>

              <li class="lia-paging-page-first" ng-class="{'firstPageDisable':myCtrl.firstPage == 0}">
                <a class="lia-link-navigation lia-custom-event"  rel="noreferrer noopener" ng-click=myCtrl.pagnation(myCtrl.firstPage) ng-class="{'lia-link-disabled':myCtrl.firstPage == 0,'anchorDisable':myCtrl.firstPage == 0}" ng-cloak> {{myCtrl.firstPage}} </a>
              </li>

              <li class="lia-paging-page-active" ng-class="{'activePageDisable':myCtrl.activePage == 0}">
                <span class="lia-link-navigation lia-link-disabled" ng-cloak> {{myCtrl.activePage}} </span>
              </li>

              <li class="lia-paging-page-last" ng-class="{'lastPage':myCtrl.lastPage == 0, 'clearDisable':myCtrl.lastPage == 0}" ng-show="myCtrl.activePage < myCtrl.maxPage">
                <a class="lia-link-navigation lia-custom-event"  rel="noreferrer noopener" ng-click=myCtrl.pagnation(myCtrl.lastPage)> {{myCtrl.lastPage}} </a>
              </li>

              <li class="lia-paging-page-ellipsis" ng-show="(myCtrl.activePage + 1) < myCtrl.maxPage ">
                <span class="lia-link-navigation lia-link-disabled" ng-cloak>...</span>
              </li>

              <li class="lia-paging-page-next lia-component-next">
                <a class="lia-link-navigation lia-custom-event" ng-class="{'nextDisable':myCtrl.activePage == myCtrl.maxPage,'lastPageDisable':myCtrl.maxPage == 0}" ng-click="myCtrl.nextPage()">
                  <span class="lia-paging-page-arrow" title="Next Page">&#8250;</span>
                </a>
              </li>
              <li class="lia-paging-page-lastpage lia-component-lastpage">
                <a class="lia-link-navigation lia-custom-event" ng-class="{'nextDisable':myCtrl.activePage == myCtrl.maxPage,'lastPageDisable':myCtrl.maxPage == 0}" ng-click="myCtrl.goLastPage()">
                  <span class="lia-paging-page-arrow" title="Last Page">&raquo;</span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
      <#-- The Alert Model -->
      <div id="model-popup" class="model-popup" ng-if="myCtrl.isModelOpen" ng-cloak>
        <#-- Model content -->
        <div class="model-popup-dialog"> 
          <div class="model-popup-content">
            <div class="model-popup-header">
              <button type="button" class="close" data-dismiss="model" ng-click="myCtrl.modelClose()" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>

            </div>
            <div id="model-popup-message" class="model-popup-body">
              {{myCtrl.modelMessage}}      
            </div>
            <div class="model-popup-footer">
              <button class="model-popup-close lia-button lia-button-primary" id="model-close" ng-click="myCtrl.modelClose()">Ok</button>
            </div>
          </div>
        </div>
      </div>

      <#-- Authorized the community -->
      <div class="authorization" ng-show="myCtrl.accessToken === ''" ng-cloak>
        <div class="div-access-token">
          <span class="access-token-info">Please establish the connection with middleware for syndicating content.</span>
          <#-- <img src="${asset.get("/html/assets/Community-Syndication.png")}" /> -->
          <button class="access-token-button lia-button lia-button-primary" onclick=" window.open('${loginURL}','_self')">Community Syndication</button>
        </div>
      </div>

      <#-- Capture Rejection reason in a free-form dialog when Admin/moderator clicks Reject in ICS Admin screen -->
      <div id="reason-capture-popup" class="reason-capture-popup" ng-if="myCtrl.isReasonModelOpen" ng-cloak>
        <#-- Model content -->
        <div class="reason-capture-popup-dialog"> 
          <div class="reason-capture-popup-content">
            <div class="reason-capture-popup-header">
              <#-- <span>
                <h1>
                  Admin Comments
                </h1>
              </span> -->
              <button type="button" class="close" data-dismiss="model" ng-click="myCtrl.closeReasonModel()" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>

            </div>
            <div id="reason-capture-popup-message" class="reason-capture-popup-body">
                <div>
                  <form name="reasonCaptureForm">
                    <div class="reason-capture-sec">
                    <label class="reason-capture-label" ng-show="myCtrl.requestType === '${macroDetails.reject_requestType}'">Rejected Comment<strong> *</strong> <span class="charaters-limit-span">(max 100 characters only)</span>
                    </label>
                    <input type="text" name="rejectReason" ng-model="myCtrl.reason" placeholder="Enter reason"   class="reason-input" id="reason-input1" rows="10" cols="30" required ng-show="myCtrl.requestType === '${macroDetails.reject_requestType}'" ng-maxlength="100" maxlength="100"/>
                    <span class="error" ng-show="reasonCaptureForm.rejectReason.$error.required" ng-if="myCtrl.requestType === '${macroDetails.reject_requestType}'">Required!</span>
                    <span ng-show="reasonCaptureForm.rejectReason.$touched && reasonCaptureForm.rejectReason.$error.maxlength">Max 100 characters only.</span>

                    <label class="reason-capture-label" ng-show="myCtrl.requestType === '${macroDetails.post_to_target_requestType}'">Admin Comments <span class="charaters-limit-span">(max 100 characters only)</span>
                    </label>
                    <input type="text" name="postedReason" ng-model="myCtrl.reason" placeholder="Enter reason"   class="reason-input" id="reason-input" rows="10" cols="30" required ng-show="myCtrl.requestType === '${macroDetails.post_to_target_requestType}'"ng-maxlength="100" maxlength="100"/>

                    <span ng-show="reasonCaptureForm.postedReason.$touched && reasonCaptureForm.postedReason.$error.maxlength">Max 100 characters only.</span>
                    </div>

                    <button class="capture-reason-message-proceed lia-button lia-button-primary" id="capture-reason-message-proceed" ng-disabled="(myCtrl.reason === ''|| myCtrl.reason === undefined) && myCtrl.requestType === '${macroDetails.reject_requestType}' " ng-click="myCtrl.captureReasonMessage()">Proceed</button>

                    <button class="capture-reason-message-cancel lia-button lia-button-primary lia-button-Cancel-action" id="capture-reason-message-cancel" ng-click="myCtrl.closeReasonModel()">Cancel</button>

                  </form>
                </div>   
            </div>
          </div>
        </div>
      </div>
    </div>
       

    <script>
      function loading(state){
        var ajax_loader_feedback = document.getElementsByClassName("lia-ajax-loader-feedback");
        var overlay = document.getElementsByClassName("overlay");
        if (state) {
          // $(".lia-ajax-loader-feedback+div").html("${text.format('ajax.general.loader.feedback.title')}");
          // $(".lia-ajax-loader-feedback").css("display", "block");
          // $(".overlay").css("display","block");
          // ajax_loader_feedback.style.display = "block";
          overlay[0].style.display = "block";
        }else{
          // $(".lia-ajax-loader-feedback").css("display", "none");
          // $(".overlay").css("display","none");
          // ajax_loader_feedback.style.display = "none";
          overlay[0].style.display = "none";
        }
      }
      
      angular.module('myApp', [])
      .config(function($locationProvider){
        $locationProvider.html5Mode({ enabled: true, requireBase: false, rewriteLinks: false });
      })
      .directive("bnDocumentClick",function( $document, $parse ){
          // I connect the Angular context to the DOM events.
          var linkFunction = function( $scope, $element, $attributes ){
              // Get the expression we want to evaluate on the
              // scope when the document is clicked.
              var scopeExpression = $attributes.bnDocumentClick;
              // Compile the scope expression so that we can
              // explicitly invoke it with a map of local
              // variables. We need this to pass-through the
              // click event.
              //
              // NOTE: I ** think ** this is similar to
              // JavaScript's apply() method, except using a
              // set of named variables instead of an array.
              var invoker = $parse( scopeExpression );
              // Bind to the document click event.
              $document.on(
                "click",
                function( event ){
                      // When the click event is fired, we need
                      // to invoke the AngularJS context again.
                      // As such, let's use the $apply() to make
                      // sure the $digest() method is called
                      // behind the scenes.
                      $scope.$apply(
                        function(){
                              // Invoke the handler on the scope,
                              // mapping the jQuery event to the
                              // $event object.
                              invoker(
                                $scope,
                                {
                                  $event: event
                                }
                                );
                            }
                            );
                    }
                    );
              // TODO: Listen for "$destroy" event to remove
              // the event binding when the parent controller
              // is removed from the rendered document.
            };
          // Return the linking function.
          return( linkFunction );
        })
      .controller('myCtrl', function($scope, $http, $log, $sce, $location, $window) {

        var myCtrl = this;
        myCtrl.statusFilter = [
        {
          id: 'all',
          name: 'ALL'
        }, 
        {
          id: 'COMPLETED',
          name: 'COMPLETED'
        }, 
        {
          id: 'FAILED',
          name: 'FAILED'
        }, 
        {
          id: 'REJECTED',
          name: 'REJECTED'
        }, 
        {
          id: 'INPROGRESS',
          name: 'INPROGRESS'
        },
        {
          id:'INMODERATION',
          name:'INMODERATION'
        }];
        myCtrl.messagesResults = [];
        myCtrl.statusResults = [];
        myCtrl.forceSyncResults = [];
        myCtrl.reprocessResults = [];
        myCtrl.selectedItem = myCtrl.statusFilter[0];
        myCtrl.messagesStatusListState = false;
        myCtrl.forceSyncRequstState = false;
        myCtrl.reprocessMessagesListState = false;
        myCtrl.isReportsTab = false;
        myCtrl.previousButton = true;
        myCtrl.nextButton = false;
        myCtrl.maxPage = 0;
        myCtrl.count = 0;
        myCtrl.firstPage = 0;
        myCtrl.activePage = 1;
        myCtrl.lastPage = 2;
        myCtrl.perPage = parseInt("${macroDetails.perPage}");
        myCtrl.forceSyncThreadId = '';
        myCtrl.isAllSelected = false;
        myCtrl.isModelOpen = false;
        myCtrl.modelMessage = '';
        myCtrl.accessToken = '${macroDetails.accessToken}';
        myCtrl.searchText;
        myCtrl.supportStatus = false;
        myCtrl.responseMessage = "";



        myCtrl.categoryAsCommnity = JSON.parse("${categoryAsCommunityValue?has_content?c}");
        myCtrl.categoryDetails = (myCtrl.categoryAsCommnity == true) ? JSON.parse('${categoryAsCommunityValue}') : {};
        myCtrl.categoryDetailsList =  (myCtrl.categoryAsCommnity == true) ? myCtrl.categoryDetails.categories_list : [];
        myCtrl.selectedCategory = myCtrl.categoryDetailsList[0];
        myCtrl.communityID = (myCtrl.categoryAsCommnity == false) ? parseInt("${communityId}") : myCtrl.selectedCategory.communityID;
        myCtrl.icsTenantId = (myCtrl.categoryAsCommnity == false) ? "${icsTenantId}" : myCtrl.selectedCategory.icsTenantId;
        myCtrl.isAccessToFBAuthorization = (myCtrl.categoryAsCommnity == false) ? JSON.parse("${isAccessToFBAuthorization?c}") : myCtrl.selectedCategory.isAccessToFBAuthorization;
        myCtrl.categoryID = (myCtrl.categoryAsCommnity == false) ? "" : myCtrl.selectedCategory.categoryID;
        

        myCtrl.requested_user_details = {
          "userName":"${user.login}",
          "userEmail":"${user.email}",
          "userId":"${user.id}",
          "sso_id":"${user_sso_id}"
        };
        myCtrl.isReasonModelOpen = false;
        myCtrl.reason = '';

        myCtrl.selectedArray = [];
        myCtrl.unSelectedArray = [];
        myCtrl.messageID;
        myCtrl.requestType = '';
        myCtrl.postingType = '';
        myCtrl.messagePosition = 0;
        myCtrl.statusResponse = [];
        myCtrl.messageIds = "";
        myCtrl.bulkDataMessages = [];
        myCtrl.facebookState = "${state}";
        myCtrl.facebookErrorRes ="${fbError}"

              
        myCtrl.init = function() {
          $window.loading(true);
          if (myCtrl.facebookState == "ICSFacebookAuthorization"){
            myCtrl.supportTab();
          }else{
            myCtrl.activeMessages();
          }
          $window.loading(false);
        }

        myCtrl.checkFacebookAuthorization  = function(){
          if (myCtrl.facebookState =="ICSFacebookAuthorization") {
            if( myCtrl.facebookErrorRes == "" ){
              myCtrl.modelMessage = "Successfully completed Facebook Authorization.";
              myCtrl.setAccessTokenDetails();
            }else if(myCtrl.facebookErrorRes == "access_denied"){
              myCtrl.modelMessage = "Unable to complete Facebook Authorization.";
            }
            
            myCtrl.isModelOpen = true;
            myCtrl.facebookState = '';
            window.history.pushState(null, null, '?state=');
          }
        };

        // Get all modration messages 
        myCtrl.activeMessages = function() {
          $window.loading(true);
          myCtrl.isAllSelected = false;
          myCtrl.messagesStatusListState = false;
          myCtrl.forceSyncRequstState = false;
          myCtrl.reprocessMessagesListState = false;
          myCtrl.isReportsTab = false;
          myCtrl.supportStatus = false;
          myCtrl.statusResults = [];
          myCtrl.forceSyncResults = [];
          myCtrl.reprocessResults = [];

          $http({
            method:'GET',
            url:LITHIUM.CommunityJsonObject.Community.viewHref +'${macroDetails.message_list_url}?pageNumber='+myCtrl.activePage+'&perPage='+myCtrl.perPage+'&categoryId='+myCtrl.categoryID
          }).then(function successCallback(response) {
            if (response.data.response.status != "error") {


              myCtrl.count = response.data.response.resultObj.messages_count;
              myCtrl.maxPage = Math.ceil(myCtrl.count/myCtrl.perPage);
              myCtrl.messagesResults = response.data.response.resultObj.messages_list;
              myCtrl.messagesResults.map(obj => {
                obj.msg_subject = decodeURIComponent(obj.msg_subject);
                obj.isSelected = false;
                obj.target_community_details.map(obj1 => {
                  if (obj1.communityStatus === 'selected') {
                    obj1.isSelected = true;
                  } else {
                    obj1.isSelected = false;
                  }
                  
                });
              });
              myCtrl.pageNumbers();
            } else {
              
              myCtrl.count = 0;
              myCtrl.maxPage = 0;
            }
            
            $window.loading(false);
          },function errorCallback(response) {
            myCtrl.count = 0;
            myCtrl.maxPage = 0;
            $window.loading(false);
          });
        }

        // Get all messages status from middle ware 
        myCtrl.messagesStatusList = function() {
          $window.loading(true);
          /*myCtrl.activeMessagesState = false;*/
          myCtrl.messagesStatusListState = true;
          myCtrl.forceSyncRequstState = false;
          myCtrl.reprocessMessagesListState = false;
          myCtrl.supportStatus = false;
          myCtrl.isReportsTab = false;
          myCtrl.messagesResults = [];
          myCtrl.forceSyncResults = [];
          myCtrl.reprocessResults = [];
          
          $http({
            method: 'GET',
            url: LITHIUM.CommunityJsonObject.Community.viewHref + '${macroDetails.msg_status}?pageNumber='+myCtrl.activePage+'&icsTenantId='+myCtrl.icsTenantId+'&communityId='+myCtrl.communityID+'&perPage='+myCtrl.perPage+'&messageType=all&statusValue='+myCtrl.selectedItem.id+'&requestType=${macroDetails.admin_messages_status_requestType}'
          }).then(function successCallback(response) {
            if (response.data.response.status != "error") {
              /*console.log(response);*/
              myCtrl.count = response.data.response.resultobj.messages_count;
              myCtrl.maxPage = Math.ceil(myCtrl.count/myCtrl.perPage);
              myCtrl.statusResponse = response.data.response.resultobj.messagestatuslist;
              
              if (myCtrl.count > 0) {
                myCtrl.statusResponse.map(obj => {

                  // converting UTC time to browser local time
                  if (obj.create_or_edit_date === "" || obj.create_or_edit_date === null || obj.create_or_edit_date === undefined) {
                    obj.create_or_edit_date = "";
                  } else {
                    var dateTime = obj.create_or_edit_date;
                    var timeZone = dateTime.split(" ")[0] + "T" + dateTime.split(" ")[1] + "Z";
                    var localeDate = new Date(timeZone);

                    obj.create_or_edit_date = localeDate.toLocaleString();
                  }
                  if (obj.event_type === "" || obj.event_type === null || obj.event_type === undefined) {
                    obj.event_type = "";
                  }
                });
              }
              
              myCtrl.statusResults = myCtrl.statusResponse;
              myCtrl.pageNumbers();
            }else{
              /*console.log(response);*/
              myCtrl.count = 0;
              myCtrl.maxPage = 0;
            }
            $window.loading(false);
          }, function errorCallback(response) {
            myCtrl.count = 0;
            myCtrl.maxPage = 0;
            $window.loading(false);
            /*console.log(response);*/
          });
        };

        myCtrl.forceSyncRequst = function() {
          $window.loading(true);
          /*myCtrl.activeMessagesState = false;*/
          myCtrl.messagesStatusListState = false;
          myCtrl.forceSyncRequstState = true;
          myCtrl.reprocessMessagesListState = false;
          myCtrl.supportStatus = false;
          myCtrl.isReportsTab = false;
          myCtrl.messagesResults = [];
          myCtrl.statusResults = [];
          myCtrl.reprocessResults = [];
          myCtrl.count = 0;
          myCtrl.maxPage = 0;
          $window.loading(false);
        };

        // Get all FAILED messages  from middle ware for reprocess the messages 
        myCtrl.reprocessMessagesList = function() {
          $window.loading(true);
          /*myCtrl.activeMessagesState = false;*/
          myCtrl.messagesStatusListState = false;
          myCtrl.forceSyncRequstState = false;
          myCtrl.reprocessMessagesListState = true;
          myCtrl.supportStatus = false;
          myCtrl.isReportsTab = false;
          myCtrl.messagesResults = [];
          myCtrl.statusResults = [];
          myCtrl.forceSyncResults = [];
          
          $http({
            method: 'GET',
            url: LITHIUM.CommunityJsonObject.Community.viewHref + '${macroDetails.msg_status}?pageNumber='+myCtrl.activePage+'&icsTenantId='+myCtrl.icsTenantId+'&communityId='+myCtrl.communityID+'&perPage='+myCtrl.perPage+'&messageType=THREAD&statusValue=FAILED&requestType=${macroDetails.admin_messages_status_requestType}'
          }).then(function successCallback(response) {
            if (response.data.response.status != "error") {
              /*console.log(response);*/
              myCtrl.count = response.data.response.resultobj.messages_count;
              myCtrl.maxPage = Math.ceil(myCtrl.count/myCtrl.perPage);
              myCtrl.reprocessResults = response.data.response.resultobj.messagestatuslist;
              myCtrl.pageNumbers();
            }else{
              /*console.log(response);*/
              myCtrl.count = 0;
              myCtrl.maxPage = 0;
            }
            $window.loading(false);
          }, function errorCallback(response) {
            myCtrl.count = 0;
            myCtrl.maxPage = 0;
            $window.loading(false);
            /*console.log(response);*/
          });
        };

        // pagnation 
        myCtrl.pagnation =function(pageNumber) {
          myCtrl.activePage = pageNumber;
          myCtrl.firstPage = myCtrl.activePage - 1;
          myCtrl.lastPage = myCtrl.activePage + 1;
          if (myCtrl.activePage == 1) {
            myCtrl.previousButton = true;
            
          } else {
            myCtrl.previousButton = false;
          }
          

          if (myCtrl.messagesStatusListState == true) {
            myCtrl.messagesStatusList();
          } else if (myCtrl.reprocessMessagesListState == true) {
            myCtrl.reprocessMessagesList();
          } else {
            myCtrl.activeMessages();
          }
        };

        // click the next ">" button in pagnation then go to the next page
        myCtrl.nextPage = function () {
          $window.loading(true);
          var pageNumber = myCtrl.activePage +1 ;

          myCtrl.firstPage = pageNumber - 1;
          myCtrl.activePage = pageNumber;
          myCtrl.lastPage = pageNumber + 1;

          if (myCtrl.messagesStatusListState == true) {
            myCtrl.messagesStatusList();
          } else if (myCtrl.reprocessMessagesListState == true) {
            myCtrl.reprocessMessagesList();
          } else {
            myCtrl.activeMessages();
          }
          $window.loading(false);
        };

        // click the previous "<" button in pagnation then go to the previous page
        myCtrl.previousPage = function () {
          $window.loading(true);
          var pageNumber = myCtrl.activePage - 1 ;

          myCtrl.firstPage = pageNumber - 1;
          myCtrl.activePage = pageNumber;
          myCtrl.lastPage = pageNumber + 1;
          
          if (myCtrl.messagesStatusListState == true) {
            myCtrl.messagesStatusList();
          } else if (myCtrl.reprocessMessagesListState == true) {
            myCtrl.reprocessMessagesList();
          } else {
            myCtrl.activeMessages();
          }
          $window.loading(false);
        };

        // click the frist "<<"  button in pagnation then go to the frist page
        myCtrl.goFristPage = function () {
          $window.loading(true);
          var pageNumber = 1 ;

          myCtrl.firstPage = pageNumber - 1;
          myCtrl.activePage = pageNumber;
          myCtrl.lastPage = pageNumber + 1;
          
          if (myCtrl.messagesStatusListState == true) {
            myCtrl.messagesStatusList();
          } else if (myCtrl.reprocessMessagesListState == true) {
            myCtrl.reprocessMessagesList();
          } else {
            myCtrl.activeMessages();
          }
          $window.loading(false);
        };

        // click the last "<<"  button in pagnation then go to the last page
        myCtrl.goLastPage = function () {
          $window.loading(true);
          var pageNumber =  myCtrl.maxPage;

          myCtrl.firstPage = pageNumber - 1;
          myCtrl.activePage = pageNumber;
          myCtrl.lastPage = pageNumber + 1;
          
          if (myCtrl.messagesStatusListState == true) {
            myCtrl.messagesStatusList();
          } else if (myCtrl.reprocessMessagesListState == true) {
            myCtrl.reprocessMessagesList();
          } else {
            myCtrl.activeMessages();
          }
          $window.loading(false);
        };

        // page numbers for pagnation 
        myCtrl.pageNumbers = function () {
          myCtrl.firstPage = myCtrl.activePage - 1;
          myCtrl.activePage = myCtrl.activePage;
          myCtrl.lastPage = myCtrl.activePage + 1;
        };

        // click the syndication button for the single meassage, pass the details to publishingToLive function  
        myCtrl.postMessages = function(index){
          $window.loading(true);
          myCtrl.reason = "";
          var status = "publish";
          myCtrl.requestType = "${macroDetails.post_to_target_requestType}";
          myCtrl.selectedArray = [];
          myCtrl.unSelectedArray = [];
          myCtrl.messageID = myCtrl.messagesResults[index].msg_id;
          myCtrl.postingType = 'single';
          myCtrl.messagePosition = index;
          angular.forEach(myCtrl.messagesResults[index].target_community_details, function(communityDetails){

            if (communityDetails.isSelected){
              myCtrl.selectedArray.push(communityDetails.communityId);
            }else{
              if (communityDetails.communityStatus === 'selected' || communityDetails.communityStatus === 'unselected') {
                myCtrl.unSelectedArray.push(communityDetails.communityId);
              }
            }
          });
          var selected = myCtrl.selectedArray.join(',');
          var unSelected = myCtrl.unSelectedArray.join(',');
          if (myCtrl.selectedArray.length > 0) {
            $window.loading(false);
            myCtrl.isReasonModelOpen = true;

          } else {
            $window.loading(false);
            myCtrl.modelMessage = "Select at least one target community to post the message.";
            myCtrl.isModelOpen = true;
          }
        };

        // Set the metadata value 
        myCtrl.setMetadata = function (id,selected,unselected,status) {
          $http({
            method:'POST',
            url:LITHIUM.CommunityJsonObject.Community.viewHref +'${macroDetails.set_metadata}?Thread_ID='+id+'&selected='+selected+'&unselected='+unselected+'&status='+status
          }).then(function successCallback(response) {
            //console.log(response);
          },function errorCallback(response) {
            // console.log(response);
          });
        };

        // pass the relavanted data to middle ware
        myCtrl.publishingToLive = function (jsonObj,requestType,reasonMessage,messageID,selected,unselected,status) {
          $window.loading(true);
          $http({
            method:'POST',
            url:LITHIUM.CommunityJsonObject.Community.viewHref +'${macroDetails.post_url}?communityType=${macroDetails.communityType}&sourceCommunityID='+myCtrl.communityID+'&icsTenantId='+myCtrl.icsTenantId+'&requestType='+requestType+'&selected_messages_object='+JSON.stringify(jsonObj)+'&approvedOrRejectedAuthorDetails='+JSON.stringify(myCtrl.requested_user_details)+'&reasonMessage='+reasonMessage
          }).then(function successCallback(response) {
            // console.log(response);
            myCtrl.modelMessage = response.data.response.message;
            $window.loading(false);
            myCtrl.isModelOpen = true;
            if (response.data.response.status != "error" && requestType == "${macroDetails.post_to_target_requestType}" && messageID != "" && messageID != null) {
              myCtrl.setMetadata(myCtrl.messageID,selected,unselected,status);
            }
          },function errorCallback(response) {
            $window.loading(false);
            // console.log(response);
          });
        };

        // click the reject button for the single meassage, pass the details to sendAuditINFO function 
        myCtrl.rejectMessages = function(index){
          $window.loading(true);
          //console.log(index);
          myCtrl.reason = "";
          var status = "reject";
          myCtrl.requestType = "${macroDetails.reject_requestType}";
          myCtrl.selectedArray = [];
          myCtrl.unSelectedArray = [];
          myCtrl.messageID = myCtrl.messagesResults[index].msg_id;
          myCtrl.messagePosition = index;
          /*console.log("msg_id"+myCtrl.messageID);*/
          angular.forEach(myCtrl.messagesResults[index].target_community_details, function(communityDetails){

            if (communityDetails.isSelected){
              myCtrl.selectedArray.push(communityDetails.communityId);
            }else{
              if (communityDetails.communityStatus === 'selected' || communityDetails.communityStatus === 'unselected') {
                myCtrl.unSelectedArray.push(communityDetails.communityId);
              }
            }
          });
          var selected = myCtrl.selectedArray.join(',');
          var unselected = myCtrl.unSelectedArray.join(',');

          if (myCtrl.selectedArray.length > 0) {
            $window.loading(false);
            myCtrl.isReasonModelOpen = true;

          } else {

            myCtrl.modelMessage = "Select at least one target community to post the message.";
            $window.loading(false);
            myCtrl.isModelOpen = true;
          }
        };

        // send the detail to middle ware for auditing
        myCtrl.sendAuditINFO = function (jsonObj,requestType,id,selected,unselected,status, reasonMessage) {
          $window.loading(true);
          $http({
            method:'POST',
            url:LITHIUM.CommunityJsonObject.Community.viewHref +'${macroDetails.audit_url}?communityType=${macroDetails.communityType}&sourceCommunityID='+myCtrl.communityID+'&icsTenantId='+myCtrl.icsTenantId+'&requestType='+requestType+'&selected_messages_object='+JSON.stringify(jsonObj)+'&approvedOrRejectedAuthorDetails='+JSON.stringify(myCtrl.requested_user_details)+'&reasonMessage='+reasonMessage
          }).then(function successCallback(response) {
            // console.log(response);
            myCtrl.modelMessage = response.data.response.message;
            $window.loading(false);
            myCtrl.isModelOpen = true;
            if (response.data.response.status != "error") {
              myCtrl.setMetadata(id,selected,unselected,status);
            } else {

            }
          },function errorCallback(response) {
            $window.loading(false);
            // console.log(response);
          });
        };

        // click the reprocess button then republishing the messages 
        myCtrl.reprocessMessages = function (index) {
          $window.loading(true);
          // console.log(myCtrl.reprocessResults[index]);
          var msg_id = myCtrl.reprocessResults[index].source_thread_id;
          var target_community = myCtrl.reprocessResults[index].target_community_id.toString();
          var msg_typs = myCtrl.reprocessResults[index].message_type;
          var jsonObj={
            "details_list":[{"tid":msg_id,
            "targetCommunity":target_community}]
          };
          var requestType = "${macroDetails.reprocess_requestType}";
          $http({
            method:'POST',
            url:LITHIUM.CommunityJsonObject.Community.viewHref +'${macroDetails.reprocess_url}?communityType=${macroDetails.communityType}&sourceCommunityID='+myCtrl.communityID+'&icsTenantId='+myCtrl.icsTenantId+'&requestType='+requestType+'&message_type='+msg_typs+'&selected_messages_object='+JSON.stringify(jsonObj)+'&requested_user_details='+JSON.stringify(myCtrl.requested_user_details)
          }).then(function successCallback(response) {
            
            myCtrl.modelMessage = response.data.response.message;
            $window.loading(false);
            myCtrl.isModelOpen = true;
          },function errorCallback(response) {
            $window.loading(false);
          });
        };

        // click the forceSync button then  forcefully sync content in all target communities
        myCtrl.forceSyncMessages = function () {
          $window.loading(true);
          var targetCommunity = "";
          var requestType = "${macroDetails.force_sync_requestType}";  
          var jsonObj = {
            "details_list": [{
              "tid": myCtrl.forceSyncThreadId,
              "targetCommunity": targetCommunity
            }]
          };
          myCtrl.publishingToLive(jsonObj,requestType, "", "",[],[],"");
          $window.loading(false);
        };

        // click the select all button in active Messages tab 
        myCtrl.selectAll = function () {
          var toggleStatus = !myCtrl.isAllSelected;

          angular.forEach(myCtrl.messagesResults, function(obj){ obj.isSelected = toggleStatus; });
        };

        // check/uncheck the messages then  check/uncheck the "select all"
        myCtrl.selectOptions =function () {
          myCtrl.isAllSelected = myCtrl.messagesResults.every(function(obj){ 
            return obj.isSelected; 
          });
        };

        // click the syndicate all button then get all selected message details , pass the details to publishingToLive function  
        myCtrl.postAll = function () {
          $window.loading(true);
          myCtrl.reason = "";
          var count = 0;
          myCtrl.selectedArray = [];
          myCtrl.postingType = 'all';

          var status = "publish";
          myCtrl.requestType = "${macroDetails.post_to_target_requestType}";
          var keepGoing = true;

          angular.forEach(myCtrl.messagesResults,function (obj) {
            if (obj.isSelected) {
              count++;
            }
          });
          if (count > 0) {
            for (var i = 0; i < myCtrl.messagesResults.length; i++) {
              if (myCtrl.messagesResults[i].isSelected) {
                myCtrl.selectedCommunityArray = [];
                myCtrl.unselectedCommunityArray = [];
                var community_list =myCtrl.messagesResults[i].target_community_details;
                for (var j = 0; j < community_list.length; j++) {
                  if (community_list[j].isSelected) {

                    myCtrl.selectedCommunityArray.push(community_list[j].communityId);

                  }else {
                    if (community_list[j].communityStatus === 'selected' || community_list[j].communityStatus === 'unselected') {
                      myCtrl.unselectedCommunityArray.push(community_list[j].communityId);
                    }
                  }
                }
                var selected = myCtrl.selectedCommunityArray.join(',');
                var unselected = myCtrl.unselectedCommunityArray.join(',');

                if (myCtrl.selectedCommunityArray.length > 0) {
                  
                  myCtrl.selectedArray.push({"tid":myCtrl.messagesResults[i].msg_id,
                    "targetCommunity":selected});
                  // myCtrl.setMetadata(myCtrl.messagesResults[i].msg_id,selected,unselected,status);
                  
                  // var adminAction = "approved";
                  // var index = i;
                  // myCtrl.sendPriviteMessage(index, selected, adminAction);

                } else {

                  myCtrl.modelMessage = "Select at lest one target community the message.";
                  $window.loading(false);
                  myCtrl.isModelOpen = true;
                  keepGoing = false;
                  break;

                }
              } 
            }

            if (keepGoing) {
              $window.loading(false);
              myCtrl.isReasonModelOpen = true;

            }
          } else {
            myCtrl.modelMessage = "Select at least one of the messages.";
            $window.loading(false);
            myCtrl.isModelOpen = true;
          }
        };

        // close the model 
        myCtrl.modelClose = function () {
          myCtrl.isModelOpen = false;
          if (myCtrl.messagesStatusListState === true) {
            myCtrl.messagesStatusList();
          } else if (myCtrl.reprocessMessagesListState === true) {
           myCtrl.handlingReprocessingMessages();
          } else if (myCtrl.forceSyncRequstState === true) {
            myCtrl.forceSyncThreadId ='';
            myCtrl.forceSyncRequst();
          }else if (myCtrl.supportStatus === true){
            myCtrl.forceSyncThreadId ='';
            myCtrl.supportTab();
          }else{
            myCtrl.activeMessages();
          }
        };

        // display the support & Maintenance tab
        myCtrl.supportTab =function () {
          $window.loading(true);
          myCtrl.supportStatus = true;
          myCtrl.messagesStatusListState = false;
          myCtrl.forceSyncRequstState = false;
          myCtrl.reprocessMessagesListState = false;
          myCtrl.isReportsTab = false;
          myCtrl.count = 0;
          myCtrl.maxPage = 0;
          $window.loading(false);
        }

        // For displaying reports
        myCtrl.showReports = function() {
          $window.loading(true);
          myCtrl.messagesStatusListState = false;
          myCtrl.forceSyncRequstState = false;
          myCtrl.reprocessMessagesListState = false;
          myCtrl.supportStatus = false;
          myCtrl.isReportsTab = true;
          $window.loading(false);
        }

        
        // category as community then changet the communities
        myCtrl.categoryChanges = function()  {
          $window.loading(true);
          myCtrl.communityID = myCtrl.selectedCategory.communityID;
          myCtrl.categoryID = myCtrl.selectedCategory.categoryID;
          myCtrl.icsTenantId = myCtrl.selectedCategory.icsTenantId;
          myCtrl.isAccessToFBAuthorization = myCtrl.selectedCategory.isAccessToFBAuthorization;
          myCtrl.activeMessages();
          // $window.loading(false);
        }

        // admin approved/rejected the message then  send the privite message to messages author 
        myCtrl.sendPriviteMessage = function(index, selected, adminAction,reasonMessage){
            var message_id = myCtrl.messagesResults[index].msg_id;
            var user_name = myCtrl.messagesResults[index].msg_author;
            var user_id = myCtrl.messagesResults[index].msg_author_id;
            var target_community_details = myCtrl.messagesResults[index].target_community_details;
            var select_communities = "";
            for (var i = 0; i < selected.split(",").length; i++) {
              
              for (var j = 0; j < target_community_details.length; j++) {
                
                if (target_community_details[j].communityId == selected.split(",")[i]) {
                    select_communities += "<li>"+target_community_details[j].communityName + "</li>";
                }
                
              }
            }
              select_communities = "<ol>"+select_communities+"</ol>";

              if(reasonMessage != ""){
                var reason = "Admin Comments: "+reasonMessage ;
              }else{
                var reason = "";
              }
              
              
              if (adminAction == "approved") {
                
                var message_subject = "Content syndication request approved.";
                var message_body = "Hello "+user_name+" ,<br><br>Your request for syndicating this <a href='/t5/xx/xx/td-p/"+message_id+"'>message</a> to the following target communities has been approved.<br><br>"+select_communities+"<br><br>"+reason+"<br><br><br>Thanks!";

              } else if(adminAction == "rejected"){
                
                var message_subject = "Content syndication request rejected.";
                var message_body = "Hello "+user_name+", <br><br>Your request for syndicating this <a href='/t5/xx/xx/td-p/"+message_id+"'>message</a> to the following target communities has been rejected.<br><br>"+select_communities+"<br><br>"+reason+"<br><br><br>Thanks!";
              }

              // The login user and message author is not same then will send the Private message to the message author
              if (user_id != "${user.id}") {
                $http({
                    method:'POST',
                    url:LITHIUM.CommunityJsonObject.Community.viewHref +'/restapi/vc/postoffice/notes/send?notes.recipient=/users/id/'+user_id+'&notes.subject='+message_subject+'&notes.note='+message_body

                  }).then(function successCallback(response) {
                    
                  },function errorCallback(response) {
                    
                  });
              }
           
          
        }

        // Capture reason from admin/modration for approved/rejected messages
        myCtrl.captureReasonMessage = function () {
          myCtrl.isReasonModelOpen = false;
          // console.log(myCtrl.reason);

          var selected = myCtrl.selectedArray.join(',');
          var unselected = myCtrl.unSelectedArray.join(',');

          if (myCtrl.requestType === "${macroDetails.reject_requestType}") {
            var status = "reject";
            var jsonObj={
              "details_list":[{"tid":myCtrl.messageID,
              "targetCommunity":selected}]
            };

            myCtrl.sendAuditINFO(jsonObj,myCtrl.requestType,myCtrl.messageID,selected,unselected,status,myCtrl.reason);
            var adminAction = "rejected";
            myCtrl.sendPriviteMessage(myCtrl.messagePosition, selected, adminAction, myCtrl.reason);

          } else if( myCtrl.requestType === "${macroDetails.post_to_target_requestType}") {
            
            if ( myCtrl.postingType === "single") {

              var status = "publish";
              var jsonObj={
                "details_list":[{"tid":myCtrl.messageID,
                "targetCommunity":selected}]
              };

              // myCtrl.setMetadata(myCtrl.messageID,selected,unselected,status);

              myCtrl.publishingToLive(jsonObj, myCtrl.requestType, myCtrl.reason, myCtrl.messageID,selected,unselected,status);
              var adminAction = "approved"
              myCtrl.sendPriviteMessage(myCtrl.messagePosition, selected, adminAction, myCtrl.reason);

            } else if(myCtrl.postingType === "all") {
              myCtrl.selectedArray = [];
              var status = "publish";
                for (var i = 0; i < myCtrl.messagesResults.length; i++) {
                  if (myCtrl.messagesResults[i].isSelected) {
                    myCtrl.selectedCommunityArray = [];
                    myCtrl.unselectedCommunityArray = [];
                    var community_list =myCtrl.messagesResults[i].target_community_details;
                    for (var j = 0; j < community_list.length; j++) {
                      if (community_list[j].isSelected) {

                        myCtrl.selectedCommunityArray.push(community_list[j].communityId);

                      }else {
                        if (community_list[j].communityStatus === 'selected' || community_list[j].communityStatus === 'unselected') {
                          myCtrl.unselectedCommunityArray.push(community_list[j].communityId);
                        }
                      }
                    }
                    var selected = myCtrl.selectedCommunityArray.join(',');
                    var unselected = myCtrl.unselectedCommunityArray.join(',');

                    if (myCtrl.selectedCommunityArray.length > 0) {
                      
                      myCtrl.selectedArray.push({"tid":myCtrl.messagesResults[i].msg_id,
                        "targetCommunity":selected});
                       myCtrl.setMetadata(myCtrl.messagesResults[i].msg_id,selected,unselected,status);
                      
                      var adminAction = "approved";
                      var index = i;
                      myCtrl.sendPriviteMessage(index, selected, adminAction, myCtrl.reason);

                    } 
                  } 
                }

                var jsonObj={
                  "details_list":myCtrl.selectedArray
                };
                myCtrl.publishingToLive(jsonObj, myCtrl.requestType, myCtrl.reason, "", [] , [], "");
            }
          } 

        }


        myCtrl.closeReasonModel = function () {
          myCtrl.isReasonModelOpen = false;
        };

        myCtrl.handlingReprocessingMessages = function() {
          myCtrl.bulkDataMessages =[];
          $window.loading(true);
          myCtrl.supportStatus = false;
          myCtrl.messagesStatusListState = false;
          myCtrl.forceSyncRequstState = false;
          myCtrl.reprocessMessagesListState = true;
          myCtrl.isReportsTab = false;
          myCtrl.count = 0;
          myCtrl.maxPage = 0;
           $window.loading(false);
        }

        myCtrl.reprocessingMessages = function() {
          myCtrl.bulkDataMessages =[];
          $window.loading(true);
                    
          var messageIds = myCtrl.messageIds;
         
          if (messageIds != "" && messageIds != null ) {
            $http({
              method:'POST',
              url:'${macroDetails.reprocess_url}?messageId='+ messageIds+'&requestType=${macroDetails.reprocess_requestType}'
            }).then(function successCallback(response) {
              console.log(response.data);
              var msg_data = "";
              if(response.data.response.successMessageIds != ""){
                msg_data = msg_data + "Success Message Id's -- "+response.data.response.successMessageIds+".";
              }
              if(response.data.response.errorMessageIds != ""){
                msg_data = msg_data + "\n Error Message Id's -- "+response.data.response.errorMessageIds+".";
              }
              //msg_data = msg_data + "</p>"
              myCtrl.modelMessage = msg_data;
              $window.loading(false);
              myCtrl.isModelOpen = true;
            },function errorCallback(response) {
              $window.loading(false);
            });
          }
          
          $window.loading(false);
          
        }
        
        myCtrl.setAccessTokenDetails = function(){
          
          $http({
              method:'POST',
              url:'${macroDetails.redirect_URI}?mode=facebookAuthorized'
            }).then(function successCallback(response) {
              console.log(response.data);
              
            },function errorCallback(response) {
              console.log(response);
            });
        }

        function processingReprocessingRequest(item, index){
          
          var msg_details = {}
          msg_details ["messageId"] = item;
          msg_details ["threadId"] = "";
          msg_details ["eventType"] = "MessageCreate";
          msg_details ["messageType"] = "";
          msg_details ["sourceCommunityId"] = myCtrl.communityID;
          myCtrl.bulkDataMessages.push(msg_details);
          
        }

      });
    </script>
  </#if>
<#recover>
  <h3 class="ics-element-donot-delete error-info" style="display: none">Error Message in admin page: ${.error}</h3>
</#attempt>