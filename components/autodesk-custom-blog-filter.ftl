<#assign labelMenuValue = webuisupport.path.rawParameters.name.get("label-name","${text.format('custom.blog-filter-default')}") />

<div class="custom-filter">
    <span>${text.format('custom-filter-by')}</span>
    <div class="lia-menu-navigation-wrapper lia-menu-action" id="blog-filter-label" >
        <div class="lia-menu-navigation">
            <div class="dropdown-default-item">
                <a title="${text.format('component.DropDownMenu.link.title')}" class="lia-js-menu-opener default-menu-option lia-js-click-menu lia-link-navigation" aria-expanded="false" role="button" aria-label="${text.format('DropDownMenu.default-link.aria-label')}">${labelMenuValue}</a>
                <div class="dropdown-positioning">
                    <div class="dropdown-positioning-static">
                        <ul aria-label="${text.format('dropdownMenuItems.list.aria-label')}" role="list" class="lia-menu-dropdown-items">
                            <a></a>
                            <@component id="blogs.widget.labels" />
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<@liaAddScript>
; (function ($) {
    function all() {
        var filterUl = $('.BlogLabelsTaplet .lia-list-standard');
        var allItem = '<li class="label"><a class="label-link lia-link-navigation" id="filter-select-all">All</a></li>';
        if ($('#filter-select-all').length == 0) {
            filterUl.prepend(allItem);
        }

        var url = window.location.href.split("/label-name")[0];
        $('#filter-select-all').on('click', function() {
            window.location.href = url; 
        })
    }

    $(document).ajaxComplete(function() {
        all();
    });

    all();
})(jQuery);
</@liaAddScript>
