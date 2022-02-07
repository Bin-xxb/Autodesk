<@liaAddScript>
;(function($) {
    $(document).ready(function($) {
        var $sidebarContent = $('.lia-quilt-occasion-page .lia-component-occasion-message-view >.lia-quilt-row-main .lia-quilt-column-main-right');
        var $sidebarWrapper = $('.lia-quilt-occasion-page >.lia-quilt-row-main >.lia-quilt-column-side-content');
        var $occasionRsvp = $('.lia-component-occasion-action-rsvp');
        $sidebarWrapper.prepend($sidebarContent);
        $sidebarContent.css('display', 'block');
    });	
})(LITHIUM.jQuery);
</@liaAddScript>