${coreNode.settings.name.get("customcontent.16_text")}

<@liaAddScript>
(function ($) {
	$(document).ready(function () {
		var $submitBtn = $('#group-join-submit');
        var $closeBtn = $('.ui-dialog-titlebar-close');
        var $checkboxList = $('.check-list label');

        var $hiddenJoinGrouphubBtn = $('.PrivateNotesPage').find('a[title="join this group hub"]');
       
		
		$submitBtn.on('click', function() {
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
            if($hiddenJoinGrouphubBtn.length > 0) {
                goPage($hiddenJoinGrouphubBtn)
            }
        }

        function goPage($button) {
            var href = $button.attr('href');
            window.location.href = href;
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