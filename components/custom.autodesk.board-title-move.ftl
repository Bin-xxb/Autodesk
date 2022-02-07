<@liaAddScript>
(function($) {
    $(document).ready(function(){
        $.fn.titleMove = function(){
            var $classname = $(this);
            var $nodeTitle = $classname.find('header .node-title');
            var $searchForm = $classname.find('.lia-quilt-row-main .lia-quilt-column-alley-left> .lia-component-common-widget-search-form');
            $searchForm.before($nodeTitle.clone());
        }
        function initTitleMove(){
            $('.ForumTopicPage').titleMove();
            $('.IdeaPage').titleMove();
            $('.GroupMessagePage').titleMove();
        }
        initTitleMove();

    })
})(LITHIUM.jQuery);
</@liaAddScript>