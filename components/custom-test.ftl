<@liaAddScript>
;(function ($) {
	$(document).ready(function() {
        var $calender = $('#occasionscalendar');
        var $angleLeftBtn = $calender.find('.fc-button-group .fc-prev-button');
        var $angleRightBtn = $calender.find('.fc-button-group .fc-next-button');
        console.log($calender);
        $('#occasionscalendar .fc-button-group .fc-prev-button').on('click', function() {
            console.log('click1');
            console.log('left: ' + $calender.find('.fc-toolbar .fc-center').text());
        });
         $('#occasionscalendar .fc-button-group .fc-next-button').on('click', function() {
            console.log('click2');
            console.log('right:' + $calender.find('.fc-toolbar .fc-center').text());
        });
	});
})(jQuery);

</@liaAddScript>