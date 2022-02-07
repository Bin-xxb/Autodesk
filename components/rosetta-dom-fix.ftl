<@liaAddScript>
; (function ($) {
    $(document).ajaxComplete(function() {
        var $radioItem = $('.lia-component-search-widget-post-date-filter .search-toggle-element');
        $('.filter-toggle[type="checkbox"]').each(function() {
            if ($(this).is(':checked')) {
                $(this).parent('.search-toggle-element').addClass('checked');
            }
        })
        $('.lia-component-search-widget-post-date-filter .filter-toggle').each(function() {
            var $this = $(this);
            if ($(this).is(':checked')) {
                $(this).parent('.search-toggle-element').addClass('checked');
            } else {
                var interval = setInterval(function() {
                    if ($this.is(':checked')) {
                        $this.parent('.search-toggle-element').addClass('checked');
                        clearInterval(interval);
                    } else if ($radioItem.hasClass('checked') || $radioItem.find('.lia-component-lazy-loader').length > 0) {
                        clearInterval(interval);
                    }
                }, 10);
            }
        })
    });
})(jQuery);
</@liaAddScript>