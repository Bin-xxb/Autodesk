<@liaAddScript>
if(!LITHIUM.ResponsiveTabsInit) {
	;(function($LITH){'use strict';var uniqueIndex=0;LITHIUM.ResponsiveTabsInit=function(){$LITH('.lia-tabs-secondary:not(.lia-tabs-vertical)').each(function(){new LITHIUM.ResponsiveTabs(this,{overflowType:'select'});});$LITH('.lia-tabs-sort').each(function(){new LITHIUM.ResponsiveTabs(this,{overflowType:'select',selectedFn:function(tab){return $LITH(tab).find('.lia-link-disabled').length>0}});});$LITH('.lia-tabs-standard:not(.lia-tabs-vertical)').each(function(){new LITHIUM.ResponsiveTabs(this,{overflowType:'dropdown'});});};LITHIUM.ResponsiveTabs=function(tabs,options){this.$tabs=$LITH(tabs);this.options=$LITH.extend({},this.defaults,options);this.init();this.layout();};LITHIUM.ResponsiveTabs.prototype={defaults:{overflowType:'select',selectTemplate:'<select class="lia-tabselect"></select>',overflowMenuTitleTemplate:'<span class="lia-fa lia-tab-overflow-icon"></span>',selectIdPrefix:'lia-tabselect',throttleInterval:250,selectedFn:function(tab){return $LITH(tab).hasClass('lia-tabs-active');}},init:function(){this.uniqueIndex=++uniqueIndex;this.maxWidth=this.getWidth(true);if(this.options.overflowType==='select'){this.selectId=this.options.selectIdPrefix+this.uniqueIndex;this.$tabSelect=this.createSelectFromTabs();}else if(this.options.overflowType==='dropdown'){this.$overflowMenu=$LITH('.lia-tab-overflow',this.$tabs);this.overflowMenuWidth=this.$overflowMenu.width();this.$overflowMenuItems=this.$overflowMenu.find('.lia-menu-dropdown-items');$LITH('.default-menu-option',this.$overflowMenu).append(this.options.overflowMenuTitleTemplate);}
	$LITH(window).on('resize',LITHIUM.Throttle($LITH.proxy(function(){this.layout();},this),this.options.throttleInterval));},getWidth:function(showMaxWidth){var cloneContainer=$LITH('<div></div>',{'class':'lia-cloned-responsive-tab-wrapper','style':'position:absolute;top:-9999px;height:0;'}).append(this.getTabsNoWrap(this.$tabs.clone(),showMaxWidth));this.$tabs.parent().append(cloneContainer);var eleWidth=cloneContainer.width();cloneContainer.remove();return eleWidth;},getTabsNoWrap:function(elem,showMaxWidth){var tabSelector=showMaxWidth?'li':'li:visible';$LITH(elem).children(tabSelector).css({'float':'none','display':'table-cell'});$LITH(elem).find('a').css('white-space','nowrap');return elem;},isOverflowing:function(){return this.maxWidth>this.$tabs.parent().width();},createSelectFromTabs:function(){var tabSelect=$LITH(this.options.selectTemplate).attr('name',this.selectId).attr('aria-label','Tab Selector Dropdown').addClass(this.selectId).addClass('lia-js-hidden');var selectedFn=this.options.selectedFn;if(this.$tabs.hasClass('lia-tabs-sort')){this.$tabs.parent().after(tabSelect);}else{this.$tabs.parent().before(tabSelect);}
	this.$tabs.children('li').each(function(i,tab){tabSelect.append(createOption(tab,selectedFn(tab)));});tabSelect.on('change',function(){if($LITH(this).val().indexOf('[id=')===0){$LITH($LITH(this).val().slice(4,-1))[0].click();}else{$LITH(this).parent().find('a[href="'+$LITH(this).val()+'"]')[0].click();}});function createOption(tab,selected,prependText){prependText=prependText||'';var link=$LITH('a,.lia-link-disabled',tab);var dropdownTabSelected;var options;link.each(function(i,e){var isDropdownLink=!$LITH(e).closest('li').hasClass('lia-tabs');var linkText=prependText+$LITH(e).text();var linkHref=$LITH(e).attr('href');if($LITH(e).hasClass('default-menu-option')){if($LITH(e).find('.lia-menu-dropdown-items li').length===0){return;}}
	selected=selected=selected||$LITH(e).hasClass('default-menu-option');if($LITH(e).attr('href')==='#'){var newId=$LITH(e).attr('id')?$LITH(e).attr('id'):'lia-'+Math.floor(Math.random()*34)+Date.now();linkHref='[id=#'+newId+']';}
	var newTab=$LITH('<option></option>').text(linkText).val(linkHref);if(selected){newTab.attr('selected','selected');}
	options=$LITH(options).add(newTab);});return options;}
	return tabSelect;},createOverflowMenu:function(){return $LITH(this.options.overflowMenuTemplate);},layout:function(){if(this.options.overflowType==='select'){this.layoutSelect();}else if(this.options.overflowType==='dropdown'){this.layoutOverflowMenu();}},layoutOverflowMenu:function(){this.$tabs.children('.lia-tabs').removeClass('lia-js-hidden');this.$overflowMenu.addClass('lia-js-hidden');this.$overflowMenuItems.empty();if(!this.isOverflowing()){return;}
	this.$overflowMenu.removeClass('lia-js-hidden');var $overflowDropDownMenu=this.$overflowMenuItems.closest(".lia-menu-navigation-wrapper");$overflowDropDownMenu.show();var addedTabsCnt=0;while(this.getWidth(true)+this.overflowMenuWidth>this.$tabs.parent().width()){var tab=this.$tabs.children(':not(.lia-tabs-active):not(.lia-tab-overflow):visible').last();if(tab.length>0){$LITH(tab).find('a').clone(true).appendTo(this.$overflowMenuItems).wrapAll('<li></li>');tab.addClass('lia-js-hidden');addedTabsCnt++;}else{break;}}
	if(!addedTabsCnt){$overflowDropDownMenu.hide();}},layoutSelect:function(){if(this.isOverflowing()){this.$tabs.addClass('lia-js-hidden');this.$tabSelect.removeClass('lia-js-hidden');}else{this.$tabs.removeClass('lia-js-hidden');this.$tabSelect.addClass('lia-js-hidden');}}};})(LITHIUM.jQuery);
	
	LITHIUM.ResponsiveTabsInit();
}
</@liaAddScript>