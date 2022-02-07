<@liaAddScript>
	;(function($) {
			adskUnifiedProfileLang = LITHIUM.CommunityJsonObject.User.settings['profile.language'].substring(0,2);
			adskUnifiedProfileAppKey = "${community.settings.name.get("autodesk.unified_profile_app_key", "")}";
	})(LITHIUM.jQuery);
</@liaAddScript>

 <!--JS file for unified profile-->

<#if config.getString("phase", "prod") == "prod">
  		<script async src="https://akn.unifiedprofile.autodesk.com/unifiedprofile-widgets/prd/unifiedprofile.min.js"></script>
  <#else>
  		<script async src="https://akn.unifiedprofile-staging.autodesk.com/unifiedprofile-widgets/stg/unifiedprofile.min.js"></script> 
 </#if>

<#if user.anonymous == false>
	<@liaAddScript>
		;(function($) {
		//debugger;
			$( document ).ready(function() {
				
					if(typeof adskUnifiedProfile != "undefined" && typeof adskUnifiedProfile.mergeExperience.validate == "function") {
      					//debugger;
						adskUnifiedProfile.mergeExperience.validate();
				}
			});
		})(LITHIUM.jQuery);
	</@liaAddScript>
</#if>
  

