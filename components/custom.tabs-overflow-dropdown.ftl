<@liaAddScript>
;(function($) {
    
    $(window).resize(function() {
        var $tab = $('.GroupHubPage .lia-component-nodes-widget-activity .lia-node-activity >.lia-menu-action .dropdown-positioning .lia-menu-dropdown-items');
    
        var $tabItems = $tab.find('li');
    
        var tabWidth = $tab.width();
    
        var tabItemsTotalWidth = 0;
        $tabItems.each(function() {
            tabItemsTotalWidth += $(this).width();
        });
        if(tabItemsTotalWidth > tabWidth) {
            console.log('overflow');
        } else {
            
        }
    });
})(LITHIUM.jQuery);
</@liaAddScript>
