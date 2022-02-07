<div class="lia-menu-bar-buttons">
    <span class="lia-button-wrapper lia-button-wrapper-primary">
        <span class="primary-action message-post">
            <a class="lia-button lia-button-primary message-post-link" id="post-button">
                <span>${text.format('custom.blog-console.post-title')}</span>
            </a>
        </span>
    </span>
</div>

<@liaAddScript>
;(function($){
    var $post = $('#post-button');
    var postUrl = $('.BoardManagementTaplet .article-post-link').attr('href');
    
    $post.attr('href', postUrl);
})(LITHIUM.jQuery);
</@liaAddScript>