<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>

<@liaAddScript>
! function(t) {
    "use strict";
    if (void 0 === LITHIUM.ResponsiveTabsInit) {
        var e = 0;
        LITHIUM.ResponsiveTabsInit = function() {
            t(".lia-tabs-secondary:not(.lia-tabs-vertical)").each(function() {
                new LITHIUM.ResponsiveTabs(this, {
                    overflowType: "select"
                })
            }), t(".lia-tabs-sort").each(function() {
                new LITHIUM.ResponsiveTabs(this, {
                    overflowType: "select",
                    selectedFn: function(e) {
                        return t(e).find(".lia-link-disabled").length > 0
                    }
                })
            }), t(".lia-tabs-standard:not(.lia-tabs-vertical)").each(function() {
                new LITHIUM.ResponsiveTabs(this, {
                    overflowType: "dropdown"
                })
            })
        }, LITHIUM.ResponsiveTabs = function(e, i) {
            this.$tabs = t(e), this.options = t.extend({}, this.defaults, i), this.init(), this.layout()
        }, LITHIUM.ResponsiveTabs.prototype = {
            defaults: {
                overflowType: "select",
                selectTemplate: '<select class="lia-tabselect"></select>',
                overflowMenuTitleTemplate: '<span class="lia-fa lia-tab-overflow-icon"></span>',
                selectIdPrefix: "lia-tabselect",
                throttleInterval: 250,
                selectedFn: function(e) {
                    return t(e).hasClass("lia-tabs-active")
                }
            },
            init: function() {
                this.uniqueIndex = ++e, this.maxWidth = this.getWidth(!0), "select" === this.options.overflowType ? (this.selectId = this.options.selectIdPrefix + this.uniqueIndex, this.$tabSelect = this.createSelectFromTabs()) : "dropdown" === this.options.overflowType && (this.$overflowMenu = t(".lia-tab-overflow", this.$tabs), this.overflowMenuWidth = this.$overflowMenu.width(), this.$overflowMenuItems = this.$overflowMenu.find(".lia-menu-dropdown-items"), t(".default-menu-option", this.$overflowMenu).append(this.options.overflowMenuTitleTemplate)), t(window).on("resize", LITHIUM.Throttle(t.proxy(function() {
                    this.layout()
                }, this), this.options.throttleInterval))
            },
            getWidth: function(e) {
                var i = t("<div></div>", {
                    class: "lia-cloned-responsive-tab-wrapper",
                    style: "position:absolute;top:-9999px;height:0;"
                }).append(this.getTabsNoWrap(this.$tabs.clone(), e));
                this.$tabs.parent().append(i);
                var s = i.width();
                return i.remove(), s
            },
            getTabsNoWrap: function(e, i) {
                var s = i ? "li" : "li:visible";
                return t(e).children(s).css({
                    float: "none",
                    display: "table-cell"
                }), t(e).find("a").css("white-space", "nowrap"), e
            },
            isOverflowing: function() {
                return this.maxWidth > this.$tabs.parent().width()
            },
            createSelectFromTabs: function() {
                var e = t(this.options.selectTemplate).attr("name", this.selectId).addClass(this.selectId).addClass("lia-js-hidden"),
                    i = this.options.selectedFn;
                return this.$tabs.hasClass("lia-tabs-sort") ? this.$tabs.parent().after(e) : this.$tabs.parent().before(e), this.$tabs.children("li").each(function(s, a) {
                    e.append(function(e, i, s) {
                        s = s || "";
                        var a;
                        return t("a,.lia-link-disabled", e).each(function(e, n) {
                            t(n).closest("li").hasClass("lia-tabs");
                            var o = s + t(n).text(),
                                l = t(n).attr("href");
                            if (!t(n).hasClass("default-menu-option") || 0 !== t(n).find(".lia-menu-dropdown-items li").length) {
                                i = i = i || t(n).hasClass("default-menu-option"), "#" === t(n).attr("href") && (l = "[id=#" + (t(n).attr("id") ? t(n).attr("id") : "lia-" + Math.floor(34 * Math.random()) + Date.now()) + "]");
                                var r = t("<option></option>").text(o).val(l);
                                i && r.attr("selected", "selected"), a = t(a).add(r)
                            }
                        }), a
                    }(a, i(a)))
                }), e.on("change", function() {
                    0 === t(this).val().indexOf("[id=") ? t(t(this).val().slice(4, -1))[0].click() : t(this).parent().find('a[href="' + t(this).val() + '"]')[0].click()
                }), e
            },
            createOverflowMenu: function() {
                return t(this.options.overflowMenuTemplate)
            },
            layout: function() {
                "select" === this.options.overflowType ? this.layoutSelect() : "dropdown" === this.options.overflowType && this.layoutOverflowMenu()
            },
            layoutOverflowMenu: function() {
                if (this.$tabs.children(".lia-tabs").removeClass("lia-js-hidden"), this.$overflowMenu.addClass("lia-js-hidden"), this.$overflowMenuItems.empty(), this.isOverflowing())
                    for (this.$overflowMenu.removeClass("lia-js-hidden"); this.getWidth(!0) + this.overflowMenuWidth > this.$tabs.parent().width();) {
                        var e = this.$tabs.children(":not(.lia-tabs-active):not(.lia-tab-overflow):visible").last();
                        if (!(e.length > 0)) break;
                        t(e).find("a").clone(!0).appendTo(this.$overflowMenuItems).wrapAll("<li></li>"), e.addClass("lia-js-hidden")
                    }
            },
            layoutSelect: function() {
                this.isOverflowing() ? (this.$tabs.addClass("lia-js-hidden"), this.$tabSelect.removeClass("lia-js-hidden")) : (this.$tabs.removeClass("lia-js-hidden"), this.$tabSelect.addClass("lia-js-hidden"))
            }
        }, LITHIUM.ResponsiveTabsInit()
    }
}(LITHIUM.jQuery); 
</@liaAddScript>

<#if debugEnabled>
    <#assign finish = .now?long />
    <#assign elapsed = finish - start />
    <script>console.log('autodesk-lia-script-tabs-responsive: Time elapsed: ${elapsed}ms');</script>
</#if>