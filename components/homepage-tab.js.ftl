
    <#assign blogURL = "/t5/autodesk-community-voices/bg-p/voices-blog" />

<@liaAddScript>
; (function ($) {
    var $communityPageTab = $('.CommunityPage #tabgroup');
    var $tabUl = $communityPageTab.find('ul.lia-tabs-standard:first-child');
    var $tabLi = $tabUl.find('li.lia-tabs');
    var $tabContent = $communityPageTab.find('.tab-content');

    var $groupsContent = $('.lia-group-hubs-list');
    var html1 = '<div class="tab-right"><span class="tab-blogs"><a href="${blogURL?js_string}"><i class="icon-blog"></i>${text.format("autodesk-area-header-nav-label.blog")}</a></span><span class="tab-groups"><img class="icon-group" src="${asset.get("/html/assets/icon-group.svg")}"><img class="icon-group-white" src="${asset.get("/html/assets/icon-group-white.svg")}">${text.format("general.Groups")}</span><span class="tab-events"><a href="/t5/community-events/eb-p/communityevents"><i class="lia-fa lia-fa-calendar"></i>${text.format("autodesk-area-header-nav-label.events")}</a></span></div>';
    // $tabUl.insertAdjacentHTML("afterend", html)
    $tabUl.after(html1);
    // $tabUl.after(`<div class="tab-right"><span class="tab-blogs"><a href="${blogURL?js_string}"><i class="icon-blog"></i>${text.format("autodesk-area-header-nav-label.blog")}</a></span><span class="tab-groups"><img class="icon-group" src="${asset.get("/html/assets/icon-group.svg")}"><img class="icon-group-white" src="${asset.get("/html/assets/icon-group-white.svg")}">${text.format("general.Groups")}</span><span class="tab-events"><a href="/t5/community-events/eb-p/communityevents"><i class="lia-fa lia-fa-calendar"></i>${text.format("autodesk-area-header-nav-label.events")}</a></span></div>`);
    $('.tab-groups').on('click', function () {
        $groupsContent.css('display', 'block');
        $tabUl.css('display', 'none');
        if ($('.lia-tabs-standard').hasClass('tabs-modify')) {
            $('.tabs-modify').css('display', 'block');
        } else { 
            var html2 = '<ul class="lia-tabs-standard tabs-modify"><li class="back"><svg viewBox="0 0 11 11" id="caret-icon-uh-pn-3" class="uh-pn-caret-icon uh-pn-caret-level-0" data-testid="caret-icon-uh-pn-3"><path d="M5.5 8.5c-.1 0-.3-.1-.4-.2l-5-5 .8-.8 4.6 4.6 4.6-4.6.8.8-5 5c-.1.1-.3.2-.4.2z"></path></svg><span>${text.format("ios.ui.back")}</span></li></ul>';
            $tabUl.after(html2);
        }
        $('.tab-groups').addClass('active');
        $tabLi.each(function () {
            if ($(this).hasClass('lia-tabs-active')) {
                $(this).removeClass('lia-tabs-active');
                $(this).addClass('lia-tabs-inactive');
            }
        });
        $tabContent.each(function () {
            if (!$(this).hasClass('lia-js-hidden')) {
                $(this).addClass('lia-js-hidden');
            }
        });
        $('.back').on('click', function () {
            $('.tabs-modify').css('display', 'none');
            $tabUl.css('display', 'block');
            // $tabLi.css('display', 'table-cell');
            $('.tab-groups').removeClass('active');
            $groupsContent.css('display', 'none');
            $tabUl.find('li:first-child').addClass('lia-tabs-active');
            $communityPageTab.find('#products-tab-content').removeClass('lia-js-hidden');
        });
    });

    $tabLi.each(function () {
        $(this).on('click', function () {
            $groupsContent.css('display','none');
            $('.tab-groups').removeClass('active');
        });
    });
})(LITHIUM.jQuery);
</@liaAddScript>