<header class="global-header navbar">
    <div class="navbar-inner">
        <div class="container" id="top-menu">
            <div class="navbar-inner">
                <div class="container" id="bottom-menu">
                    <div class="local-navigation-container">
                        <div class="local-navigation-name">
                            <h2 class="pull-left"><a href="${text.format("autodesk-fusion360-header-nav-label.home")}">FUSION 360</a></h2>
                            <div id="header-hamburger-icon" data-toggle="dropdown"></div>
                        </div>
                        <div class="local-navigation-links">
                            <ul class="site-nav nav">
                                <li><a href="https://www.autodesk.com/products/fusion-360/features">${text.format("autodesk-fusion360-header-nav-label.features")}</a></li>
                                <li class="eng-lang-link">
                                    <a href="#" data-toggle="dropdown">${text.format("autodesk-fusion360-header-nav-label.why-fusion-360")}<b class="caret"></b></a>
                                    <ul class="dropdown-menu">
                                        <li><a href="#" style="pointer-events: none;">${text.format("autodesk-fusion360-header-nav-label.by-role")}</a></li>
                                        <li><a href="https://www.autodesk.com/products/fusion-360/mechanical-engineer">${text.format("autodesk-fusion360-header-nav-label.mechanical-engineer")}</a></li>
                                        <li><a href="https://www.autodesk.com/products/fusion-360/industrial-designer">${text.format("autodesk-fusion360-header-nav-label.industrial-designer")}</a></li>
                                        <li><a href="https://www.autodesk.com/products/fusion-360/machinist">${text.format("autodesk-fusion360-header-nav-label.machinist")}</a></li>
                                        <li><a href="https://www.autodesk.com/products/fusion-360/collaborator">${text.format("autodesk-fusion360-header-nav-label.collaborator")}</a></li>
                                        <li><a href="https://www.autodesk.com/products/fusion-360/electronics-engineer">${text.format("autodesk-fusion360-header-nav-label.electronics-engineer")}</a></li>
                                    </ul>
                                </li>
                                <li><a href="https://www.autodesk.com/products/fusion-360/learn-support" >${text.format("autodesk-fusion360-header-nav-label.learn-and-support")}</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="wd-new-buttons">
                        <a class="nav-link subscribe-button" href="${text.format("autodesk-fusion360-header-nav-label.try-subscribe.link")}" id="header-try-button">${text.format("autodesk-fusion360-header-nav-label.try-subscribe")}</a>
                        <a class="nav-link freetrial-button" href="${text.format("autodesk-fusion360-header-nav-label.free-trial.link")}">${text.format("autodesk-fusion360-header-nav-label.free-trial")}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="hamburger-menu" class="" style="display: none;">
        <div class="scroll-header-menu-option">
            <a href="https://www.autodesk.com/products/fusion-360/features">
            ${text.format('autodesk-fusion360-header-nav-label.features')}
            </a>
        </div>
        <div class="scroll-header-menu-option" id="why-fusion-360">
            <a href="#">
            ${text.format('autodesk-fusion360-header-nav-label.why-fusion-360')}
            </a>
            <div id="menu-icon"></div>
            <div id="menu-options" style="display: none;">
                <div class="scroll-header-menu-option selected">
                    <a href="#" style="pointer-events: none; cursor: default;">
                    ${text.format('autodesk-fusion360-header-nav-label.by-role')}
                    </a>
                </div>
                <div class="scroll-header-menu-option">
                    <a href="https://www.autodesk.com/products/fusion-360/mechanical-engineer">
                    ${text.format('autodesk-fusion360-header-nav-label.mechanical-engineer')}
                    </a>
                </div>
                <div class="scroll-header-menu-option">
                    <a href="https://www.autodesk.com/products/fusion-360/industrial-designer">
                    ${text.format('autodesk-fusion360-header-nav-label.industrial-designer')}
                    </a>
                </div>
                <div class="scroll-header-menu-option">
                    <a href="https://www.autodesk.com/products/fusion-360/machinist">
                    ${text.format('autodesk-fusion360-header-nav-label.machinist')}
                    </a>
                </div>
                <div class="scroll-header-menu-option">
                    <a href="https://www.autodesk.com/products/fusion-360/collaborator">${text.format("autodesk-fusion360-header-nav-label.collaborator")}</a>
                </div>
                <div class="scroll-header-menu-option">
                    <a href="https://www.autodesk.com/products/fusion-360/electronics-engineer">${text.format("autodesk-fusion360-header-nav-label.electronics-engineer")}</a>
                </div>
            </div>
        </div>
        <div class="scroll-header-menu-option">
            <a href="https://www.autodesk.com/products/fusion-360/learn-support" >
            ${text.format("autodesk-fusion360-header-nav-label.support-and-learning")}
            </a>
        </div>
        <div class="scroll-header-menu-option" id="subscribe">
            <a href="${text.format('autodesk-fusion360-header-nav-label.try-subscribe.link')}" >
            ${text.format('autodesk-fusion360-header-nav-label.try-subscribe')}
            </a>
        </div>
        <div class="scroll-header-menu-option">
            <a href="${text.format('autodesk-fusion360-header-nav-label.free-trial.link')}">
            ${text.format('autodesk-fusion360-header-nav-label.free-trial')}
            </a>
        </div>
    </div>
    <div class="node-title"> 
        <@component id="common.widget.node-information"/>
    </div>
    <nav class="fusion-mobile-navbar">
        <div class="outer-container">
            <div class="inner-container">
                <aside class="mobile-navigation-menu">
                    <a class="close-button btn-x"></a>
                    <ul class="site-nav nav">
                        <li>
                            <a href="https://www.autodesk.com/products/fusion-360/learn-support">Learn &amp; Support</a>
                        </li>
                        <li><a href="https://www.autodesk.com/products/fusion-360/subscribe" id="header-try-button">Subscribe</a></li>
                        <li><a href="https://www.autodesk.com/products/fusion-360/free-trial">Free Trial</a></li>
                    </ul>
                </aside>
            </div>
        </div>
    </nav>
</header>
  
<@liaAddScript>
;(function($) {
    $(function() {
        $('#lia-body .global-header #bottom-menu .site-nav > li > [data-toggle="dropdown"]').on('click', function(e) {
            e.preventDefault(); 
            $(this).parent().toggleClass('open');
        });
        $('#header-hamburger-icon').on('click', function(e) {
            e.preventDefault(); 
            $(this).toggleClass('down');
        });
        $('#menu-icon').on('click', function(e) {
            e.preventDefault(); 
            $(this).toggleClass('down-arrow');
        });
    
        $('body').on('click', function(e) { 
            var $target = $(e.target);
            var $find = $target.closest('#lia-body .global-header #bottom-menu .site-nav > li.open [data-toggle="dropdown"]'); 
            if($find.length == 0) {
                $('#lia-body .global-header #bottom-menu .site-nav > li.open').removeClass('open');
            }
            var $target = $(e.target);
            var $find = $target.closest('#header-hamburger-icon'); 
            if($find.length == 0) {
                $('#header-hamburger-icon').removeClass('down');
            }
            var $target = $(e.target);
            var $find = $target.closest('#menu-icon'); 
            if($find.length == 0) {
                $('#menu-icon').removeClass('down-arrow');
            }
        });
    });
    
    $("#header-hamburger-icon").on('click', function(){
        $("#hamburger-menu").slideToggle(0);
    });
    $("#menu-icon").on('click', function(){
        $("#menu-options").toggle(0); 
    });

    $("#lia-body .lia-page .global-header.navbar > .navbar-inner > .container > .navbar-inner > .container > button.hamburger-menu").click(function() {
        $("#lia-body .lia-page .global-header.navbar nav.fusion-mobile-navbar").show();
        $("#lia-body .lia-page .global-header.navbar nav.fusion-mobile-navbar > .outer-container").animate({left: '0%'}, "slow");

        $("body").css("overflow-y","hidden");

    });
    $("#lia-body .lia-page .global-header.navbar nav.fusion-mobile-navbar .outer-container .inner-container aside.mobile-navigation-menu a.close-button.btn-x").click(function(){
        $("#lia-body .lia-page .global-header.navbar nav.fusion-mobile-navbar > .outer-container").animate({left: '-100%'}, "slow", function(){
            $("#lia-body .lia-page .global-header.navbar nav.fusion-mobile-navbar").hide(); 
        });

        $("body").css("overflow-y","auto");
    });
  
    $("#lia-body .lia-page .global-header.navbar nav.fusion-mobile-navbar .outer-container .inner-container aside.mobile-navigation-menu ul.site-nav.nav > li > a.down-arrow").click(function(){
        var currentObj = $(this);
        if( currentObj.hasClass("open") ){
            currentObj.siblings(".dropdown-menu").slideToggle();
            currentObj.toggleClass("open");        
        
        }else{
            $("#lia-body .lia-page .global-header.navbar nav.fusion-mobile-navbar .outer-container .inner-container aside.mobile-navigation-menu ul.site-nav.nav > li > a.down-arrow.open").toggleClass("open").siblings(".dropdown-menu").slideToggle();    
            currentObj.siblings(".dropdown-menu").slideToggle();
            currentObj.toggleClass("open");
        }
    });
    


})(LITHIUM.jQuery);
</@liaAddScript>
