<div class="forumPage-filter-component">
    <span class="forumPage-filter hide">Filter by Labels</span>
    <div class="forumPage-labels-list hide">
        <@component id="labels.widget.labels-list"/>
    </div>
</div>

<#assign value = coreNode.settings.name.get("label.predefined_labels")!'' />

<@liaAddScript>
;(function($) {
    var $filter = $('.forumPage-filter');
    var $list = $('.forumPage-labels-list');
    var $listItem = $list.find('li');
    var $listChild = $('.forumPage-labels-list .lia-component-labels-widget-labels-list');
    var value = '${value}';
    var arr = value.split(', ');
    var labelValue = $list.find('.label a');
    labelValue.each(function() {
        var label = $(this).attr('aria-label').split(': ')[1];
        for (var i = 0; i < arr.length; i ++) {
            if (arr[i] == label) {
                $(this).parent('li').addClass('predefined');
            }
        }
    });

    $listItem.each(function() {
        if(!$(this).hasClass('predefined')) {
            $(this).remove();
        }
        $(this).removeClass('lia-js-hidden');
    })

    if( $listChild.length > 0) {
        $filter.removeClass('hide');
    }
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
