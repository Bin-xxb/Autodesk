<div id="common-profile-widget"></div>

<#assign user_id = "${page.context.user.id?c}" />
<#assign current_user_id = "${user.id?c}" />

<@liaAddScript>
;(function($) {
    $.ajax({
       type: "POST",
       async:false,
       url: "${webuisupport.urls.endpoints.name.get("autodesk-up-commonprofile-structure").build()}?user_id=${user_id}&current_user_id=${current_user_id}",
       success: function(data){
            $('#common-profile-widget').html(data);
       }
    });
})(LITHIUM.jQuery);
</@liaAddScript>