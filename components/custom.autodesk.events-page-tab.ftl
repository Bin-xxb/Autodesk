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
    var url = window.location.href.split("?")[1];
    var defindUrl = window.location.href.split("?")[0] + '?include_upcoming=true&include_ongoing=true';
    if (url == undefined) {
        window.location.href = defindUrl; 
    }
    var tab = $('.event-header-tab').find('li');
    var query = window.location.search.substring(1).split("&");

    function deleteArr(i) {
　　    var index = query.indexOf(i);
        query.splice(index, 1);
    }
    deleteArr('depth=0');
    deleteArr('sort_by=occasionStartTime');

    tab.each(function () { 
        $(this).on('click', function () { 
            if (!$(this).hasClass('active')) { 
                // tab.removeClass('active');
                // $(this).addClass('active');

                for (var i = 0; i < query.length; i++) {
                    if (query[i] == 'include_past=true' || query[i] == 'include_ongoing=true' || query[i] == 'include_upcoming=true') {
                        var index = query.indexOf(query[i]);
                        query.splice(index, 1);
                    }
                }

                if ($(this).attr('data-id') == 'upcoming') {
                    query.push('include_upcoming=true&include_ongoing=true');
                    var urlBefore = window.location.href.split("?")[0];
                    var url = urlBefore + '?' + query;
                } else if ($(this).attr('data-id') == 'past') {
                    query.push('include_past=true');
                    var urlBefore = window.location.href.split("?")[0];
                    var url = urlBefore + '?' + query;
                }
                
                $(this).find('a').attr('href',url); 
            }
        })
    })
})(jQuery);
</@liaAddScript>