<#attempt>
	<#--
	 Intelligent Content Syndication.
	 (ICS) 2019 iTalent By Ravindra
	for #Display the ICS admin page link in community dashboard#
	-->
	
	
	<#if user.registered && !user.anonymous>
		<#import "cross_community_macro.ftl" as macroDetails>
		
			<@delegate />
			<#-- User is an Admin display widget -->
			<#if macroDetails.isLithiumAdmin>	
				
				<@liaAddScript>
				    ;(function($){
						$( "#communityAdminLinksTaplet" ).find( "ul" ).find("li:last").after('<li><a class="lia-link-navigation cross-community-link" href="${macroDetails.redirect_page_url}">${text.format("custom.ics_admin")?js_string}</a></li>');
					})(LITHIUM.jQuery);
				</@liaAddScript>
			</#if>
	</#if>
<#recover>
	<h3 class="ics-element-donot-delete error-info" style="display: none">Error Message admin link: ${.error}</h3> 
</#attempt> 