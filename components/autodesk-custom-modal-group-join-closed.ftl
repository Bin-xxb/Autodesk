<#-- Build the options variable -->
<#assign modalOptions = modalsupport.options
    .setButtonType("primary")
    .setTitle("Requirements to join")
    .setSmall(false).setResizable(false)
 
.build />

<#-- Build the parameters variable -->
<#assign componentParameters = modalsupport.component.parameters.add("name", "1").add("panel", "true").build />

<#-- Call the modal directive passing the variables -->
<@modal id="autodesk-custom-group-join-requirements" label="custom-modal-group-request-join.label.key" parameters=componentParameters options=modalOptions />
<@liaAddScript>
(function ($) {
	$(document).ready(function () {
        var $sendRequestBtn = $('#sendMembershipRequest');
		if($sendRequestBtn.length > 0) {
			$('.lia-component-memberships-widget-request-to-join +.lia-component-common-widget-modal').css('display', 'block');
		}
		
	});
})(LITHIUM.jQuery);
</@liaAddScript>

