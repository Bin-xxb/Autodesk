<@liaAddScript>
;(function($){
    var $occasionRsvp = $('.lia-component-occasion-action-rsvp');
    var $occasionTitle = $occasionRsvp.find('.lia-attendance >p >b');
    var $occasionEndedTitle = $occasionRsvp.find('.lia-occasion-ended-title');
    var $occasionEndedText = $occasionRsvp.find('.lia-occasion-ended-text');
    $occasionTitle.text("${text.format('custom.occasion-rsvp.title')?js_string}");
    $occasionEndedTitle.text("${text.format('custom.occasion-ended.title')?js_string}");
    $occasionEndedText.text("${text.format('custom.occasion-ended.text')?js_string}");
})(LITHIUM.jQuery);
</@liaAddScript>