<div class="forumPage-filter-component">
    <span class="forumPage-filter">Filter by Lables</span>
    <div class="forumPage-labels-list hide">
        <@component id="labels.widget.labels-list"/>
    </div>
</div>

<@liaAddScript>
;(function($) {
    var $filter = $('.forumPage-filter');
    var $list = $('.forumPage-labels-list');
    $filter.on('click', function() {
        if($list.hasClass('hide')) {
            $list.removeClass('hide');
        } else {
            $list.addClass('hide');
        }
    });
    $('.ForumPage .label').each(function() {
      var count = $(this).find('.label-count');
      $(this).find('a').append(count);
    });
})(LITHIUM.jQuery);
</@liaAddScript>