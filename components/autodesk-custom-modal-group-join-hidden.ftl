<#-- Build the options variable -->
<#assign modalOptions = modalsupport.options
    .setButtonType("primary")
    .setTitle("Requirements to join")
    .setSmall(false).setResizable(false)
.build />

<#-- Build the parameters variable -->
<#assign componentParameters = modalsupport.component.parameters.add("name", "1").add("panel", "true").build />

<#-- Call the modal directive passing the variables -->
<@modal id="autodesk-custom-group-join-requirements-hidden" label="custom-modal-group-request-join-open.label.key" parameters=componentParameters options=modalOptions />


<@liaAddScript>
(function ($) {
    $(document).ready(function () {
        var $privatePage = $('.PrivateNotesPage');
        
        $( document ).ajaxComplete(function( event, xhr, settings ) {
            joinAction();
        });

        function joinAction() {
            var $joinBtn = $privatePage.find('.custom-private-message-group-hub-button');
            var $modal = $privatePage.find('.lia-component-common-widget-modal .lia-button');
            $joinBtn.on('click', function(e) {
                e.preventDefault();
                $modal.click();
            });
        }
        joinAction();
	});
})(LITHIUM.jQuery);
</@liaAddScript>