<#if config.getString("phase", "") == "prod">
<script type='text/javascript' src='https://akn.unifiedprofile.autodesk.com/unifiedprofile-widgets/prd/unifiedprofile.min.js'></script>
<#else>
<script type='text/javascript' src='https://akn.unifiedprofile-staging.autodesk.com/unifiedprofile-widgets/stg/unifiedprofile.min.js'></script>
</#if>
<div id="common-profile-widget"></div>

<#assign user_id = "${page.context.user.id?c}" />
<#assign current_user_id = "${user.id?c}" />
<@liaAddScript>
;(function($) {
    $.ajax({
       type: "POST",
       async: false,
       url: "${webuisupport.urls.endpoints.name.get("autodesk-up-commonprofile-structure").build()}?user_id=${user_id}&current_user_id=${current_user_id}",
       success: function(data){
            $('#common-profile-widget').html(data);
            var userId = $('.adsk-up-full').attr('data-user-id-tmp');
            $('.adsk-up-full').attr('data-user-id', userId);
            $('.adsk-up-full').removeAttr('data-user-id-tmp');
            if (typeof($('.adsk-up-full').attr('data-is-owner-tmp')) != 'undefined') {
            	var isOwner = $('.adsk-up-full').attr('data-is-owner-tmp');
            	$('.adsk-up-full').attr('data-is-owner', isOwner);
            	$('.adsk-up-full').removeAttr('data-is-owner-tmp');
            }
            if(adskUnifiedProfile2) {
            	adskUnifiedProfile2.init();
            }
       },
    });
})(LITHIUM.jQuery);
</@liaAddScript>