${coreNode.settings.name.get("customcontent.16_text")}

<@liaAddScript>
(function ($) {
	$(document).ready(function () {
		var $submitBtn = $('#group-join-submit');
		var $closeBtn = $('.ui-dialog-titlebar-close');
		var $sendRequestBtn = $('#sendMembershipRequest');
        var $joinGrouphubBtn = $('.lia-component-memberships-widget-join-open-node-link .lia-button');
		var $checkboxList = $('.check-list label');
		
		$submitBtn.on('click', function() {
            console.log('click');
			var isAllCheck = true;
			$checkboxList.each(function() {
				if( $(this).find('input').attr('checked') != 'checked' ) {
					isAllCheck = false;
				}
			});
			if( isAllCheck ) {
				$closeBtn.click();
				typeButtonClick();
			} else {
				$checkboxList.each(function() {
					isChecked($(this).find('input'));
				});
			}
		});
		$checkboxList.each(function() {
			$(this).find('input').on('click', function() {
				isChecked($(this));
			});
		});

        function typeButtonClick() {
            if($sendRequestBtn.length > 0) {
                $sendRequestBtn.click();
            } else if ($joinGrouphubBtn.length > 0) {
                $joinGrouphubBtn.click();
            } else {
                return;
            }
        }

		function isChecked(checkbox) {
			if(checkbox.attr('checked') == 'checked') {
				checkbox.removeClass('not-agree');
			} else {
				checkbox.addClass('not-agree');
			}
		}
	});
})(LITHIUM.jQuery);
</@liaAddScript>