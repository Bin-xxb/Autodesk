<#-- outdated component, do not use -->

<#-- 
	Hamburger Menu ( Overriding the OOTB widget slide out menu )
-->	

<@delegate />


    
<#if config.getString("phase", "dev") == "dev">
  <#assign envURL = "https://knowledge-int.autodesk.com" />
<#elseif config.getString("phase", "stage") == "stage">
  <#assign envURL = "https://knowledge-staging.autodesk.com" />
<#elseif config.getString("phase", "prod") == "prod">
    <#assign envURL = "https://knowledge.autodesk.com" />
</#if>
    
    
<#-- Get the preferred language by user from site preference -->

<#assign user_lang="en">
<#assign isAnanymous = true>
<#if user.anonymous==false>
	<#assign liql_str="select language from users where id='"+user.id+"'" />
	<#assign response_user_lanugage=restadmin("2.0","/search?q=" + liql_str?url)>
	<#assign user_lang= response_user_lanugage.data.items[0].language />
	<#assign isAnanymous = false>
</#if>

<@liaAddScript>
var hbmenuAkpDomain;
;(function($) { 


jQuery(document).on('click',function(e) 
{
    var className = e.target.className;//$(".lia-slide-menu-overlay-open");
    var classList = e.target.classList;
	var id = e.target.id;
	var bflag = false;
    //debugger;
	for(var i=0;i<classList.length;i++){
		if(classList[i] == "lia-slide-menu-content"){
			jQuery(".lia-slide-menu-overlay.lia-slide-menu-overlay-open").trigger('click');
			jQuery('.product_picker_modal').removeClass("show").addClass("hide");
            jQuery(".off-canvas-wrap").removeClass('product-picker-open');
			jQuery('#lia-body .lia-component-quilt-header .lia-quilt.lia-quilt-autodesk-header-first-row').css("z-index","99");
            jQuery('body').css("overflow-y","auto");

		}
		if(classList[i] == 'ui-widget-overlay'){
			jQuery('.ui-dialog-titlebar-close').trigger('click');
		}
		if(classList[i] == 'language-dropdown-first-name' || classList[i] == 'pointable' || classList[i] == 'language-dropdown-name' ){
			bflag = true;
		}
	}
	if(bflag == false)
		jQuery('.user-navigation-language-drop-down').css('display','none');
	if(id == "oxygen-overlay"){
		jQuery('#oxygen-closebtn').trigger('click');
	}	
}); 

/******* Create a DOM structure required for right side product window *******/
var domStr = '<div class="inner-wrap">\
          <div class="off-canvas-menu-wrap ">\
            <aside class="left-off-canvas-menu widget-container">\
                <a zf-close="" class="close-button  btn-x"></a>\
            </aside>\
            <aside class="left-off-canvas-product-menu product_picker_modal"></aside>\
        </div>\
    </div>\
	<div class="exit-off-canvas"></div>';

/******* Click Event to Slide out the hamburger menu (OOTB) *******/	
$(".lia-slide-menu-trigger.lia-slide-out-nav-menu-wrapper").on('click', function(){ 
    jQuery('body').css("overflow-y","hidden");
    $('#lia-body .lia-component-quilt-header .lia-quilt.lia-quilt-autodesk-header-first-row').css("z-index","98");
	$('.lia-slide-menu-content ').empty();
	$('.lia-slide-menu-content ').append(domStr);
	$(".lia-nav-item-container.lia-nav-subcategories").remove(); 
	 loadData();	
});


/******* Function to Get URL Parameter *******/
var getUrlParameter = function getUrlParameter(sParam) {
		var sPageURL = decodeURIComponent(window.location.search.substring(1)),
			sURLVariables = sPageURL.split('&'),
			sParameterName,
			i;

		for (i = 0; i < sURLVariables.length; i++) {
			sParameterName = sURLVariables[i].split('=');

			if (sParameterName[0] === sParam) {
				return sParameterName[1] === undefined ? true : sParameterName[1];
			}
		}
	};

/******* Function to Get Language evaluated as per AKN ( Only AKN language supported for hamburger, if no match default to "EN")*******/
function getLanguage(lang){
	var lang_supported_by_lithium = ["de","en","es","fr","ja","pl","pt","pt-br","tr","zh-CN","ru"];	
	var li_lang_param_site_preference = lang;
	var bflag=false;
	var language_supported_by_AKN_arr = [{lang:"English",initial:"en"},{lang:"Chinese Simplified",initial:"zh-hans"},{lang:"French",initial:"fr"},{lang:"German",initial:"de"},{lang:"Japanese",initial:"ja"},{lang:"Polish",initial:"pl"},{lang:"Portuguese",initial:"pt"},{lang:"Russian",initial:"ru"},{lang:"Spanish",initial:"es"},{lang:"Turkish",initial:"tr"},{lang:"Italian",initial:"it"},{lang:"Korean",initial:"ko"}]
	for( var i=0;i<language_supported_by_AKN_arr.length;i++){
		var obj = language_supported_by_AKN_arr[i];
		if(obj.initial == li_lang_param_site_preference){
			bflag = true;
			break;
		}
	}
	hbmenuLang = "en";
	if(bflag)
		hbmenuLang = li_lang_param_site_preference;
    if(lang=="pt")
             hbmenuLang="pt-br"; 
    
}

/******* Function to Load Data from AKN *******/

function loadData() {
					var isAnanymous = "${isAnanymous?c}";
					var lang_param = "${user_lang}";
					var test = getUrlParameter('profile.language');
					if(lang_param != "")
						hbmenuLang = lang_param;
					if(isAnanymous == "true"){
						/*lang_param = getUrlParameter('profile.language');*/
						lang_param = jQuery("html").attr('lang');
					}	
					getLanguage(lang_param);	
					//hbmenuLang = "es";
                    console.log("language param " +lang_param);  
                    // writing code to change lang as in above function it did not work to change lang
                    if(lang_param=="pt-br" || lang_param=="pt")
                         hbmenuLang="pt-br"; 
                    if(lang_param=="tr")
                         hbmenuLang="en";
                    if(lang_param=="zh-CN" || lang_param=="zh")
                        hbmenuLang="zh-hans"; 
                    var akp_domain = (typeof hbmenuAkpDomain != 'undefined') ? hbmenuAkpDomain : '${envURL}';
                    var lang = (typeof hbmenuLang != 'undefined' && hbmenuLang != 'en') ? '/' + hbmenuLang : '';
                    hbmenuAkpDomain = akp_domain;
                    /******* Load HTML *******/
                    var jsonp_url = akp_domain + lang + "/ajax/adsk/main-menu?callback=?";
                    $
                        .ajax({
                            url: akp_domain + lang + "/ajax/adsk/main-menu",
                            crossDomain: true,
                        })
                        .done(
                            function(data) {
                                if (console && console.log) {
                                    console.log("Sample of data:", data.slice(0, 100));
                                }
				
                                var htmlString = data;
								dataStr = htmlString;
                                //$('.widget-container').append(htmlString);
								$('.left-off-canvas-menu ').append(dataStr);
                                console.log("Load was performed.");
                                console.log("Hamburger Init");

                                var links = [".modal-learn",
                                    ".modal-troubleshooting",
                                    ".modal-system-requirements",
                                    ".modal-all-system-requirements",
                                    ".modal-all-products",
                                    ".modal-forums", ".modal-ideas"
                                ];
                                links = links.join(", ");

                                $(links)
                                    .click(
                                        function(e) {
                                            e.preventDefault();
                                            console.log("prevent default: " +
                                                e.isDefaultPrevented()); // true
                                            e.stopPropagation();

                                            var target = ".left-off-canvas-product-menu";

                                            var trigger = $(this).attr("class").split(
                                                /\s+/);
                                            trigger = trigger[0];
                                            trigger = trigger.slice(6);
											console.log("on tab ---",trigger);
                                            var loadingHtml = '<div class="loading">';
                                            // loadingHtml += '<img src="' + pathToTheme +
                                            // 'images/standard/ring.gif">';
                                            loadingHtml += '</div>';
                                            $(target).html(loadingHtml);

                                            var url = akp_domain + lang +
                                                    '/ajax/adsk/products/quicktabs/' +
                                                    trigger;
											//console.log("url formed :",url);
                                            $(target).attr(
                                                'id',
                                                'product_picker_' +
                                                trigger.replace(/[\.-]+/g, "_"));
                                            $(target)
                                                .load(
                                                    url,
                                                    function() {
                                                        /*
                                                         * Fusion 360 Gettting Started and
                                                         * Learn & Explore link overrides to
                                                         * redirect to external site .
                                                         * AKNSITE-4426 Stingray Overrides.
                                                         */
												
																
																
                                                        if (trigger === 'learn') {
                                                            // Fusion 360 Learn -
                                                            // English only
															//var urlFusion = akp_domain + lang +"/support/fusion-360/learn";
																	
															$('#product_picker_learn .field-content a[href*= "/support/fusion-360/learn"]')
                                                                .attr('href', 'https://help.autodesk.com/view/fusion360/ENU');
															$('#product_picker_learn .all-product-list .list-item a[href*= "/support/fusion-360/learn"]')
                                                                .attr('href', 'https://help.autodesk.com/view/fusion360/ENU');
                                          
                                                        } 
                                                    });
                                           $(target).addClass("show");
											$(target).removeClass("hide");
                                            $(".off-canvas-wrap").addClass(
                                                'product-picker-open');
                                            if ($(this).parents('.left-off-canvas-menu').length === 0) {
                                                $(".off-canvas-wrap").addClass(
                                                    "show-product-picker-only");
                                            }
                                        });

                                // Close Button (Canvas Menu)
                                $(document).on(
                                    'close.fndtn.offcanvas',
                                    '[data-offcanvas]',
                                    function(e) {
                                        $(".product_picker_modal").removeClass("show")
                                            .addClass("hide");
                                        $(".off-canvas-wrap").removeClass(
                                            "show-product-picker-only");
                                        $(".off-canvas-wrap").removeClass(
                                            'product-picker-open');
                                    });

                                // Close Button (Canvas Menu)
                                $(".left-off-canvas-menu").on(
                                    'click',
                                    '.close-button',
                                    function() {
										jQuery(".lia-slide-menu-overlay.lia-slide-menu-overlay-open").trigger('click');
                                        $('#lia-body .lia-component-quilt-header .lia-quilt.lia-quilt-autodesk-header-first-row').css("z-index","99");
                                        jQuery('body').css("overflow-y","auto");
                                        $('.product_picker_modal').removeClass("show")
                                            .addClass("hide");
                                        $(".off-canvas-wrap").removeClass(
                                            'product-picker-open');
                                    });

                                // Close Button (Product Menu)
                                $(".product_picker_modal").on(
                                    'click',
                                    '.close-button',
                                    function() {
                                       console.log("product menu close button");
                                        $(this).parent("aside").removeClass("show")
                                            .addClass("hide");
                                        $(".off-canvas-wrap").removeClass(
                                            "show-product-picker-only");
                                        $(".off-canvas-wrap").removeClass(
                                            'product-picker-open');

                                    });

                                // Product Tabs
                                $(".product_picker_modal")
                                    .on(
                                        'click',
                                        '.tab-product-suites-cloud li',
                                        function(e) {
                                            e.preventDefault();
                                            $("ul.menu-tabs > li.menu-tab.active")
                                                .removeClass("active");
                                            $(".product-picker-tabpage").removeClass(
                                                "show").addClass("hide");
                                            $(this).addClass("active");

                                            if ($(this).hasClass('menu-tab-clouds')) {
                                                $(".product-picker-tabpage.cloud-services")
                                                    .removeClass("hide").addClass("show");
                                            } else if ($(this)
                                                .hasClass('menu-tab-suites')) {
                                                $(".product-picker-tabpage.suites")
                                                    .removeClass("hide").addClass("show");
                                            } else if ($(this).hasClass(
                                                    'menu-tab-products')) {
                                                $(
                                                        ".product-picker-tabpage.featured-products")
                                                    .removeClass("hide").addClass("show");
                                            } else if ($(this).hasClass(
                                                    'menu-tab-additional')) {
                                                $(".product-picker-tabpage.additional")
                                                    .removeClass("hide").addClass("show");
                                            } else if ($(this).hasClass(
                                                    'menu-tab-international')) {
                                                $(".product-picker-tabpage.international")
                                                    .removeClass("hide").addClass("show");
                                            }

                                        });

                                // Show All Products Button
                                $(".product_picker_modal").on(
                                    'click',
                                    '.show-all-products',
                                    function(e) {
                                        e.preventDefault();
                                        $(window).scrollTop(0);
                                        $('.product_picker_modal').scrollTop(0);
                                        $(".product-picker-by-topics-container")
                                            .addClass("hide");
                                        $(".all-products-list-container").removeClass(
                                            "hide").addClass("show");
                                        $(".all-product-tab-mobile li.menu-tab.first")
                                            .addClass('active').siblings('li.active')
                                            .removeClass('active');
                                    });

                                // Anchor Links for All Products
                                $(".product_picker_modal").on(
                                    'click',
                                    '.all-product-tab-mobile li.menu-tab > a',
                                    function(e) {
                                        e.preventDefault();
                                        var el = $(this);
                                        var gotoId = el.attr('data-goto');

                                        el.parent().addClass('active').siblings(
                                            'li.active').removeClass('active');

                                        var modal = el.parents('.product_picker_modal');
                                        var cur_pos = modal.scrollTop();
                                        var nav_height = modal.find(
                                            '.all-product-tab-mobile').outerHeight();
                                        modal.animate({
                                            scrollTop: cur_pos +
                                                modal.find(gotoId).offset().top -
                                                nav_height
                                        }, 500);

                                        return false;
                                    });
                            });
                }
			
var dataStr="";
})(LITHIUM.jQuery); 
</@liaAddScript> 
