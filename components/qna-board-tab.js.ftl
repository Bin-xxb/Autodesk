<@liaAddScript>
; (function ($) {
    var $tabs = $('.QandAPage').find('#tabgroup');
    var $tabItem = $tabs.find('li');
    var $resolvedTab = $tabs.find('.resolved-tab');

    $tabItem.each(function() {
        if ($(this).hasClass('lia-tabs-active')) {
            $(this).removeClass('lia-tabs-active');
            $(this).addClass('lia-tabs-inactive');
        }
    })
    if ($resolvedTab.hasClass('lia-tabs-inactive')) {
        $resolvedTab.removeClass('lia-tabs-inactive');
        $resolvedTab.addClass('lia-tabs-active');
    }

})(LITHIUM.jQuery);
</@liaAddScript>