<#-- 
Display links to share the topic/content on Social Platforms
-->
<@component id="autodesk-was-this-helpful"/>
<div class="lia-social-share adk-bcomment-share">
    <div class="share-icon active">
    <label class="label-txt">${text.format('autodesk-custom-social-share-text')}: </label>
    <ul class="social-share-content" style="display: inline;">
        <li class="social-share-link">
            <a href="#" class="facebook" aria-label="facebook" data-wat-social="facebook">
                
            </a>
        </li>
        <li class="social-share-link">
            <a href="#" class="twitter" aria-label="twitter" data-wat-social="twitter">
               
               
            </a>
        </li>
        <li class="social-share-link">
            <a href="#" class = "linkedin" aria-label="linkedin" data-wat-social="linkedin">
               
                
            </a>
        </li>
        <li class="social-share-link">
            <a href="#" class="email" aria-label="email" data-wat-social="email">
                
               
            </a>
        </li>
    </ul>
   </div>
 
</div>
<@liaAddScript>
(function($) {
    var shareURl = '';
    var icons = ['facebook', 'twitter', 'linkedin', 'email'];

    for (var i in icons) {
        $("." + icons[i]).on("click", function(e) {
            e.preventDefault();
            if ($(this).attr("class") == 'facebook') {
                shareURl = 'https://www.facebook.com/sharer/sharer.php?u=';
                openWindow();
                $(this).attr("href", shareURl);
                
            } else if ($(this).attr("class") == 'twitter') {
                shareURl = 'https://twitter.com/intent/tweet?url=';
                $(this).attr("href", shareURl);
                openWindow();
            } else if ($(this).attr("class") == 'linkedin') {
                shareURl = 'https://www.linkedin.com/cws/share?url=';
				$(this).attr("href", shareURl);
                openWindow();
            } else if($(this).attr("class") == 'email'){
                var sTitle = document.querySelector("meta[property='og:title']").getAttribute('content');
                window.location = 'mailto:?subject=' + encodeURIComponent(sTitle) + '&body=' + window.location.href;
            }

        })

    }

    function openWindow() {
        window.open(shareURl + encodeURIComponent(document.location), 'Share', 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=500,height=300');
    }
})(LITHIUM.jQuery);
</@liaAddScript>
