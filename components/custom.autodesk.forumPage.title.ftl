<@liaAddScript>
(function($) {
    $(document).ready(function(){
        $.fn.titleReverse = function(){
            var $classname = $(this);
            var $searchForm = $classname.find('.lia-quilt-row-main .lia-quilt-column-alley-left .lia-component-common-widget-search-form');
            var $headerInfo = $classname.find('.lia-quilt-row-main .lia-quilt-column-alley-left .lia-node-header-info'); 
            $searchForm.before($headerInfo);
        }
        function initTitleReverse(){
            $('.ForumPage').titleReverse();
            $('.IdeaExchangePage').titleReverse();
            $('.GroupPage').titleReverse();
        }
        initTitleReverse();

    })
})(LITHIUM.jQuery);
</@liaAddScript>