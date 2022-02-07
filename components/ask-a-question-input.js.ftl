<@liaAddScript>
; (function ($) {
    $('.lia-ask-search-results').ajaxSuccess(function () {
        var $resultsList = $('.lia-ask-search-results').find('.thread-list-display');
        $resultsList.each(function () { 
            var $aTag = $(this).find('.lia-link-navigation');
            var link = $aTag.attr('href');
            var detaidLink = $(this).find('.see-more-link').attr('href');
            if (link == '#') { 
                link = detaidLink;
                $aTag.attr('href', link);
            }
            $('.message-subject-link').unbind('click');
            $aTag.unbind('click');
        })
    });
    $('#lia-questionField').on('click', function() {
        $('.lia-ask-search-results').css('display', 'block');
    })
     $(document).on('click', function(e) {
        var area = $('#lia-questionField');
        if(!area.is(event.target) && area.has(event.target).length === 0){
            $('.lia-ask-search-results').css('display', 'none');
        }
    })
})(LITHIUM.jQuery);
</@liaAddScript>