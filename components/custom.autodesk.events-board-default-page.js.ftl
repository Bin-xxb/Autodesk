<@liaAddScript>
; (function ($) {
    var url = window.location.href.split("?")[1];
    var defindUrl = window.location.href.split("?")[0] + '?include_upcoming=true';
    if (url == undefined) {
        window.location.href = defindUrl; 
    }
})(jQuery);
</@liaAddScript>