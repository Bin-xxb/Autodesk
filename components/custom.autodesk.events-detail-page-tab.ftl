<div class="event-header-tab">
    <ul>
        <li class="upcoming" data-id="upcoming">
            <a href="#">${text.format('occasions.filter.status.upcoming.title')}</a>
        </li>
        <li class="past" data-id="past">
            <a href="#">${text.format('occasions.filter.status.past.title')}</a>
        </li>
        
    </ul>
</div>    

<@liaAddScript>
; (function ($) {
    var $endTitle = $('.lia-component-occasion-action-rsvp .lia-occasion-ended-title');
    var $endText = $('.lia-component-occasion-action-rsvp .lia-occasion-ended-text');
    var $eventHeaderTabUl = $('.event-header-tab').find('ul');
    var url = $('.OccasionPage .lia-breadcrumb .lia-list-standard-inline li:nth-last-child(3) a').attr('href');

    var upcomingUrl = url + '?include_upcoming=true&include_ongoing=true';
    var pastUrl = url + '?include_past=true';
    

    $eventHeaderTabUl.find('.upcoming a').attr('href', upcomingUrl);
    $eventHeaderTabUl.find('.past a').attr('href', pastUrl);
    
    if ($endTitle.length > 0 || $endText.length > 0) { 
        $('.event-header-tab .past').addClass('active');
        $eventHeaderTabUl.before('<a href="javascript:void(0);" class="lia-js-menu-opener default-menu-option lia-button-secondary">${text.format('occasions.filter.status.past.title')}</a>');
    } else {
        $('.event-header-tab .upcoming').addClass('active');
        $eventHeaderTabUl.before('<a href="javascript:void(0);" class="lia-js-menu-opener default-menu-option lia-button-secondary">${text.format('occasions.filter.status.upcoming.title')}</a>');
    }

    $('.event-header-tab').find('.lia-button-secondary').on('click', function() { 
        if ($(this).find('+ ul').hasClass('open')) {
            $(this).find('+ ul').removeClass('open');
        } else { 
            $(this).find('+ ul').addClass('open');
        }
    })
})(jQuery);
</@liaAddScript>