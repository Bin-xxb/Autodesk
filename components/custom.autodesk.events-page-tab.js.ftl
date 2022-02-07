<@liaAddScript>
; (function ($) {
    $(document).ajaxComplete(function() {
        var $radioItem = $('.lia-component-search-widget-post-date-filter .search-toggle-element');
        $('.filter-toggle[type="checkbox"]').each(function() {
            if ($(this).is(':checked')) {
                $(this).parent('.search-toggle-element').addClass('checked');
            }
        })
        $('.lia-component-search-widget-post-date-filter .filter-toggle').each(function() {
            var $this = $(this);
            if ($(this).is(':checked')) {
                $(this).parent('.search-toggle-element').addClass('checked');
            } else {
                var interval = setInterval(function() {
                    if ($this.is(':checked')) {
                        $this.parent('.search-toggle-element').addClass('checked');
                        clearInterval(interval);
                    } else if ($radioItem.hasClass('checked') || $radioItem.find('.lia-component-lazy-loader').length > 0) {
                        clearInterval(interval);
                    }
                }, 10);
            }
        })
    });
})(jQuery);
</@liaAddScript>

<@liaAddScript>
; (function ($) {
    var query = window.location.search.substring(1).split("&");
    var $eventHeaderTabUl = $('.event-header-tab').find('ul');
    for (var i = 0; i < query.length; i++) {
        if (query[i] == 'include_past=true') {
            $('.event-header-tab .past').addClass('active');
            $eventHeaderTabUl.before('<a href="javascript:void(0);" class="lia-js-menu-opener default-menu-option lia-button-secondary">${text.format('occasions.filter.status.past.title')}</a>');
            $('body').addClass('past-show');
            $('body').removeClass('ongoing-show');
            $('body').removeClass('upcoming-show');
            break;
        } else { 
            $('.event-header-tab .upcoming').addClass('active');
            $eventHeaderTabUl.before('<a href="javascript:void(0);" class="lia-js-menu-opener default-menu-option lia-button-secondary">${text.format('occasions.filter.status.upcoming.title')}</a>');
            $('body').removeClass('past-show');
            $('body').removeClass('ongoing-show');
            $('body').addClass('upcoming-show');
            break;
        }
    }
    $('.event-header-tab').find('.lia-button-secondary').on('click', function() { 
        if ($(this).find('+ ul').hasClass('open')) {
            $(this).find('+ ul').removeClass('open');
        } else { 
            $(this).find('+ ul').addClass('open');
        }
    })

    function labelFilter() {
        var $filterItem = $('.lia-list-standard-inline li');
        $filterItem.each(function() {
            var filterValue = $(this).find('.lia-search-filter-bread-crumb-link').html();
            var temp = document.createElement("div");
            temp.innerHTML = filterValue;
            var output = temp.textContent || temp.innerText;
            output = output.replace("amp;","");
            temp = null;
            $(this).find('.lia-search-filter-bread-crumb-link').html(output);

            var ariaLabel = $(this).find('.lia-fa-times-circle').attr('aria-label');
            if (ariaLabel == 'Remove the Status: Past filter' || ariaLabel == 'Remove the Status: Upcoming filter' || ariaLabel == 'Remove the Status: In progress filter') {
                $(this).remove();
            }
        })

        var $eventList = $('.lia-occasions-list .lia-occasion-list-item');
        $eventList.each(function() {
            var $kudos = $(this).find('.lia-occasion-kudos-count');
            var $kudosNum = $kudos.html().trim().replace(/\s/g,"");;

            if ($kudosNum == '1') {
                if ($kudosNum.indexOf("Like") == -1 && $kudosNum.indexOf("Likes") == -1) {
                    $kudos.append('${text.format("general.Kudo")}');
                }
            } else if ($kudosNum.indexOf("Like") == -1 && $kudosNum.indexOf("Likes") == -1) {
                $kudos.append('${text.format("general.Kudos")}');
            }
        })

        var $labelsListTab = $('.filter-bread-crumb .lia-list-standard-inline');
        if ($labelsListTab.find('li').length > 0 && $labelsListTab.find('.clear-all').length <= 0)  {
            var clearAll = '<li class="lia-search-filter-bread-crumb-item clear-all"><span class="lia-link-navigation lia-search-filter-bread-crumb-link lia-custom-event">Clear all</span><span class="lia-link-navigation lia-fa lia-fa-times-circle lia-filter-delete-icon lia-custom-event"></span></li>';
            $labelsListTab.prepend(clearAll);
        }

        $('.clear-all').on('click', function() {
            var url = window.location.href.split("?")[1];
            if (url.indexOf("include_upcoming=true") != -1) {
                var defindUrl = window.location.href.split("?")[0] + '?include_upcoming=true&include_ongoing=true';
                window.location.href = defindUrl; 
            } else if (url.indexOf("include_past=true") != -1) {
                var defindUrl = window.location.href.split("?")[0] + '?include_past=true';
                window.location.href = defindUrl;
            }
        })
    }
    labelFilter();

    $('.lia-component-occasions-widget-labels-filter .filter-toggle[type="checkbox"]').each(function() {
        $(this).on('click', function() {
            $(this).parent('.search-toggle-element').addClass('checked');
        })
    })

    $(document).ajaxComplete(function() {
        labelFilter();
        $('.lia-component-occasions-widget-labels-filter .filter-toggle[type="checkbox"]').each(function() {
            if ($(this).is(':checked')) {
                $(this).parent('.search-toggle-element').addClass('checked');
            }
        })
    });
})(jQuery);
</@liaAddScript>