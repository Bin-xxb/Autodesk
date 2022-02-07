<#assign queryString = "SELECT id, title FROM grouphubs LIMIT 1000" />
<#assign groupHubTitles = restadmin("2.0", "/search?q=" + queryString ? url).data.items![] />
<#assign endpoint = "custom.autodesk.group-hub-custom-content-hidden" /> 
<div class="requirements-wrapper"></div>
<@liaAddScript>
(function ($) {
	$(document).ready(function () {
		function privateMessageAction() {
			var grouphubsArray = [];
			<#list groupHubTitles as grouphub>
				grouphubsArray.push({id: `${grouphub.id}`, title: `${grouphub.title}`});
			</#list>
			var inviteGroupHubTitle = $('.PrivateNotesPage').find('.custom-private-message-group-hub-title b').text();
			var inviteGroupHubID = null;
			grouphubsArray.map(function (item) {
				if (inviteGroupHubTitle == item.title) {
					inviteGroupHubID = item.id;
				}
			});
			var url = '${webuisupport.urls.endpoints.name.get(endpoint).build()?js_string}';
			var data = {
				inviteGroupHubID: inviteGroupHubID,
			};
			$.ajax({
				dataType: 'html',
				type: 'GET',
				url: url,
				data: data,
				success: function (result) {
					var wrapper = $('.requirements-wrapper');
					wrapper.append(result);
				},
				error: function(error) { console.log('error:', error) }
					
			});
		}
		privateMessageAction();
	});
})(LITHIUM.jQuery);
</@liaAddScript>