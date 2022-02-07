<#assign pageURL=http.request.url/>
<#assign isMyDashBoardPage="false">
<#if pageURL?contains('mydashboard')>
	<#assign isMyDashBoardPage="true"/>
</#if>
<div id="lia-ssoscript">
<#if settings.name.get("community.signon_url", "")?has_content >
	
<@liaAddScript>

/*!
 * JavaScript Cookie v2.1.3
 * https://github.com/js-cookie/js-cookie
 *
 * Copyright 2006, 2015 Klaus Hartl & Fagner Brack
 * Released under the MIT license
 */
;(function (factory) {
	var registeredInModuleLoader = false;
	if (typeof define === 'function' && define.amd) {
		define(factory);
		registeredInModuleLoader = true;
	}
	if (typeof exports === 'object') {
		module.exports = factory();
		registeredInModuleLoader = true;
	}
	if (!registeredInModuleLoader) {
		var OldCookies = window.Cookies;
		var api = window.Cookies = factory();
		api.noConflict = function () {
			window.Cookies = OldCookies;
			return api;
		};
	}
}(function () {
	function extend () {
		var i = 0;
		var result = {};
		for (; i < arguments.length; i++) {
			var attributes = arguments[ i ];
			for (var key in attributes) {
				result[key] = attributes[key];
			}
		}
		return result;
	}

	function init (converter) {
		function api (key, value, attributes) {
			var result;
			if (typeof document === 'undefined') {
				return;
			}

			// Write

			if (arguments.length > 1) {
				attributes = extend({
					path: '/'
				}, api.defaults, attributes);

				if (typeof attributes.expires === 'number') {
					var expires = new Date();
					expires.setMilliseconds(expires.getMilliseconds() + attributes.expires * 864e+5);
					attributes.expires = expires;
				}

				try {
					result = JSON.stringify(value);
					if (/^[\{\[]/.test(result)) {
						value = result;
					}
				} catch (e) {}

				if (!converter.write) {
					value = encodeURIComponent(String(value))
						.replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent);
				} else {
					value = converter.write(value, key);
				}

				key = encodeURIComponent(String(key));
				key = key.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent);
				key = key.replace(/[\(\)]/g, escape);

				return (document.cookie = [
					key, '=', value,
					attributes.expires ? '; expires=' + attributes.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
					attributes.path ? '; path=' + attributes.path : '',
					attributes.domain ? '; domain=' + attributes.domain : '',
					attributes.secure ? '; secure' : ''
				].join(''));
			}

			// Read

			if (!key) {
				result = {};
			}

			// To prevent the for loop in the first place assign an empty array
			// in case there are no cookies at all. Also prevents odd result when
			// calling "get()"
			var cookies = document.cookie ? document.cookie.split('; ') : [];
			var rdecode = /(%[0-9A-Z]{2})+/g;
			var i = 0;

			for (; i < cookies.length; i++) {
				var parts = cookies[i].split('=');
				var cookie = parts.slice(1).join('=');

				if (cookie.charAt(0) === '"') {
					cookie = cookie.slice(1, -1);
				}

				try {
					var name = parts[0].replace(rdecode, decodeURIComponent);
					cookie = converter.read ?
						converter.read(cookie, name) : converter(cookie, name) ||
						cookie.replace(rdecode, decodeURIComponent);

					if (this.json) {
						try {
							cookie = JSON.parse(cookie);
						} catch (e) {}
					}

					if (key === name) {
						result = cookie;
						break;
					}

					if (!key) {
						result[name] = cookie;
					}
				} catch (e) {}
			}

			return result;
		}

		api.set = api;
		api.get = function (key) {
			return api.call(api, key);
		};
		api.getJSON = function () {
			return api.apply({
				json: true
			}, [].slice.call(arguments));
		};
		api.defaults = {};

		api.remove = function (key, attributes) {
			api(key, '', extend(attributes, {
				expires: -1
			}));
		};

		api.withConverter = init;

		return api;
	}

	return init(function () {});
}));
/*jshint browser: true, jquery: true, expr: true, sub: true */

<#assign env = http.request.serverName>
<#if env == "forums-dev.autodesk.com" || env == "forums-stg.autodesk.com">
	<#assign oxygenUrl = '//accounts-staging.autodesk.com' />
	<#assign bounce = '/auth/openid_security_check?openid_identifier=http%3A%2F%2Faccounts-staging.autodesk.com%2F&action=bounce' />
<#else>
	<#assign oxygenUrl = '//accounts.autodesk.com' />
	<#assign bounce = '/auth/openid_security_check?openid_identifier=http%3A%2F%2Faccounts.autodesk.com%2F&action=bounce' />
</#if>

var oxygenUrl = '${oxygenUrl?js_string}';
var bounce = '${bounce?js_string}';
	
// these are default options, can be overriden with Oxygen.setOptions({key: value, key: value, ...})
var OXYGEN_OPTIONS = {
	viewmode: 'iframe',
	viewmode_options: {
		width: 350,
		height: 356,
		close_button: {
			size: 24,
			image: 'close_24.png'
		}
	},
	provider: 'autodesk',
	providers_endpoint: {
		autodesk: oxygenUrl
	},
	openid_response: 'oxygen_openid_response.html',
	refresh_response: 'oxygen_refresh_response.html'
};


(function() {

	// nested merging of objects, options on second parameter are used when they are not defined on the first parameter.
	var mergeOptions = function(options, default_options) {
		for (var key in default_options) {
			if (default_options.hasOwnProperty(key)) {
				if (options.hasOwnProperty(key) && typeof options[key] === 'object' && typeof default_options[key] === 'object') {
					options[key] = mergeOptions(options[key], default_options[key]);
				} else if (!options.hasOwnProperty(key)) {
					options[key] = default_options[key];
				}
			}
		}
		return options;
	};

	// returns an object with {key: value, key: value, ...}
	var parseQueryString = function(s) {
		var split = (/\?/.test(s) ? s.split('?')[1] : s).split('&'), query = {}, param, i, j;
		for (i = 0, j = split.length; i < j; i++) {
			param = split[i].split('=');
			query[param[0]] = decodeURIComponent(param[1]);
		}
		return query;
	};

	var ObjectCreate = Object.create || function (o) {
		function F() {}
		F.prototype = o;
		return new F();
	};
	//begin overlay
	var OxygenOverlay = function(options) {
		var default_options = {
			zIndex: 60000,
			width: 350,
			height: 356,
			onCreate: function() {},
			onOpen: function() {},
			onClose: function() {},
			overlay: {
				color: '#000',
				opacity: 0.4
			},
			container: {
				shadow: '0 2px 8px rgba(0,0,0,0.5)',
				backgroundColor: '#fff',
				padding: 10
			}
	};
	
	options = mergeOptions(mergeOptions({}, options), default_options);
	
	var fn = {
		setStyles: function() {
			jQuery(overlay).css({
				position: 'absolute',
				left: 0,
				top: 0,
				width: '100%',
				zIndex: options.zIndex,
				backgroundColor: options.overlay.color,
				opacity: 0
			});
			
			jQuery(container).css({
				position: 'absolute',
				top: 0,
				left: 0,
				zIndex: options.zIndex + 6,
				padding: options.container.padding,
				backgroundColor: options.container.backgroundColor,
				mozBoxShadow: options.container.shadow,
				webkitBoxShadow: options.container.shadow,
				boxShadow: options.container.shadow,
				opacity: 0
			});
		
			jQuery(close_btn).css({
				position: 'absolute',
				top: -options.close_button.size / 2.75,
				right: -options.close_button.size / 2.75,
				width: options.close_button.size,
				height: options.close_button.size,
				zIndex: options.zIndex + 8,
				backgroundImage: 'url("/' + options.close_button.image + '")',
				cursor: 'pointer'
			});
		},
		resizeOverlay: function() {
			overlay.style.height = 0;
			overlay.style.height = Math.max(jQuery(container).height() + 42, jQuery(document).height()) + 'px';
		},
		resizeTo: function(size, animate) {
			if (size) {
				options.width = size.width;
				options.height = size.height;
			} else {
				size = {width: options.width, height: options.height};
			}
		
			var hideOnTransition = animate && size && ((options.width != size.width) || (options.height != size.height)),
			width, height;
			
			if (size.width === 'auto') {
				container.style.display = 'block';
				container.style.width = 'auto';
				content.style.width = 'auto';
				width = jQuery(content).width();
				animate = hideOnTransition = false;
			} else {
				width = size.width;
			}
			if (size.height === 'auto') {
				container.style.display = 'block';
				container.style.height = 'auto';
				content.style.height = 'auto';
				height = jQuery(content).height();
				animate = hideOnTransition = false;
			} else {
				height = size.height;
			}
		
			if (hideOnTransition) content.style.display = 'none';
		
			if (animate) {
				jQuery([container, content]).stop(true, true);
			}
		
			if (size.autoscale !== false && !Oxygen.MOBILE_FRIENDLY) {
				height = Math.min(height, jQuery(window).height() - 42);
			}
			
			jQuery(container)[animate ? 'animate' : 'css']({
				left: '50%',
				top: '50%',
				width: width,
				height: height,
				marginTop: Math.max(-height / 2 - options.container.padding, (-jQuery(window).height() + 24) / 2) + jQuery(window).scrollTop(),
				marginLeft: Math.max(-width / 2 - options.container.padding, (-jQuery(window).width() + 24) / 2)
			}, {duration: 300, complete: fn.resizeOverlay});
			jQuery(content)[animate ? 'animate' : 'css']({
				width: width,
				height: height
			}, {duration: 300, complete: function() { content.style.display = '';  }});
		
			fn.resizeOverlay();
			setTimeout(fn.resizeOverlay, 50);
		},
		keydown: function(e) {
			if (e.keyCode === 27) this.close();
		},
		show: function() { 
			jQuery(overlay).stop(true, true).fadeTo(300, options.overlay.opacity, function() { options.onOpen(); jQuery(document).trigger('oxygen::open'); });
			jQuery(container).fadeTo(300, 1);
		},
		hide: function() {
			jQuery(overlay).stop(true, true).fadeTo(300, 0, function(){ jQuery(this).hide(); options.onClose(); jQuery(document).trigger('oxygen::close'); });
			jQuery(container).stop(true, true).fadeTo(300, 0, function(){ jQuery(this).hide(); });
		}
	},
	eventsAttached = false,
	overlay = document.getElementById('oxygen-overlay') || document.createElement('div'),
	container = document.getElementById('oxygen-container') || document.createElement('div'),
	close_btn = document.getElementById('oxygen-closebtn') || document.createElement('div'),
	content = options.content;
	
	// make sure the container is empty
	for (var i = 0, j = container.children.length; i < j; i++) {
		container.removeChild(container.children[0]);
	}
	
	// setup initial state
	container.appendChild(close_btn);
	content && container.appendChild(content);
	
	this.open = function(new_content, size) {
		var self = this;
		
		if (new_content) {
			if (content && content.parentNode) container.removeChild(content);
		
			content = new_content;
		
			container.appendChild(content);
		}
		
		if (!document.getElementById('oxygen-overlay')) {
			overlay.setAttribute('id', 'oxygen-overlay');
			container.setAttribute('id', 'oxygen-container');
			container.setAttribute('role', 'dialog');
			container.setAttribute('tabindex', '-1');
			close_btn.setAttribute('id', 'oxygen-closebtn');
			close_btn.setAttribute('role', 'button');
		
			fn.setStyles();
		
			if (!eventsAttached) {
				jQuery(close_btn).bind('click', jQuery.proxy(self.close, self));
				jQuery(container).bind('mousewheel', function(e) { e.stopPropagation(); e.preventDefault(); });
				eventsAttached = true;
			}
		
			document.body.appendChild(overlay);
			document.body.appendChild(container);
		} else {
			if (!jQuery(container).is(':visible')) fn.setStyles();
		}
		
		jQuery(window).unbind('resize.oxygen');
		jQuery(document).unbind('keydown.oxygen');
		jQuery(overlay).unbind('click.oxygen');

		jQuery(window).bind('resize.oxygen', function() { fn.resizeTo.call(self, options); });
		jQuery(document).bind('keydown.oxygen', jQuery.proxy(fn.keydown, self));
		if (options.hideOnOverlayClick) jQuery(overlay).bind('click.oxygen', jQuery.proxy(self.close, self));
		
		fn.resizeTo(size || options, !!size, false);
		
		try { container.focus(); } catch(e) {}
		options.onCreate();
		jQuery(document).trigger('oxygen::create');
		
		fn.show();
		
		return this;
	};
	
	this.close = function() {
		fn.hide();
	};

	this.resizeTo = function(size, animate) {
		fn.resizeTo(size, animate);
	};
	
	this.toString = function() { return 'OxygenOverlay'; };
	};
	//end overlay
	var OxygenOverlayIframe = function(options) {
		options = mergeOptions(options || {}, OXYGEN_OPTIONS.viewmode_options);
		
		if (options.href) {
			this.iframe = OxygenIframe(options.href, options.onLoadComplete);
		}
		options.content = options.content || this.iframe;
		
		var old_onClose = options.onClose,
			self = this;
		options.onClose = function() {
			old_onClose && old_onClose.call(self, arguments);
			if (self.iframe && self.iframe.parentNode) {
				self.iframe.parentNode.removeChild(self.iframe);
				self.iframe = null;
			}
		};
		
		OxygenOverlay.call(this, options);
		
		var old_open = this.open;
		this.open = function(href, size) {
		if (!this.iframe) {
			this.iframe = OxygenIframe(href, options.onLoadComplete);
			old_open.call(this, this.iframe, size);
		} else {
			this.setURL(href);
			old_open.call(self, undefined, size);
		}
		};

		this.setURL = function(href) {
			this.iframe.setAttribute('src', href);
		};
		
		this.toString = function() { return 'OxygenOverlayIframe'; };
	};
	OxygenOverlayIframe.prototype = ObjectCreate(OxygenOverlay.prototype);

	/* this is just a utility to take advantage of our overlay plugin.
		Given that it clones the node, it's not useful for taking content
		that has events attached to it. So basically, it's for static content */
	var OxygenOverlayInline = function(options) {
		var self = this,
			element = document.createElement('div');
		
		OxygenOverlay.call(this, options);
		
		var old_open = this.open;
		this.open = function(content, size) {
			element.innerHTML = '';
			element.appendChild(content.cloneNode(true));
			old_open.call(self, element, size);
		};
		
		this.toString = function() { return 'OxygenOverlayInline'; };
	};
	OxygenOverlayInline.prototype = ObjectCreate(OxygenOverlay.prototype);

	var OxygenPopup = function(options) {
		var popup_ref,
		default_options = {
			width: 350,
			height: 356
		};
		
		options = mergeOptions(options || {}, default_options);
		
		this.open = function(href) {
			try {
				popup_ref.location.href = href;
			} catch (e) {
				popup_ref = window.open(href, "OxygenPopup", "width=" + options.width + ",height=" + options.height);
				jQuery(popup_ref).bind('load', options.onLoadComplete);
			}
		};
		
		this.close = function() {
			popup_ref.close();
			popup_ref = null;
		};
		
		this.resizeTo = function(size) {
			try { // can only resize if the popup is in the same domain
				if (popup_ref) popup_ref.resizeTo(size.width, size.height);
			} catch (e) {}
		};
		
		this.toString = function() { return 'OxygenPopup'; };
	};

	// returns an <iframe/> element that points to the given URL
	var OxygenIframe = function(href, onload) {
		var element = document.createElement('iframe');
		
		element.setAttribute('frameBorder', '0');
		element.setAttribute('hspace', '0');
		element.setAttribute('scrolling', 'no');
		element.setAttribute('data-proxy-for', 'oxygen');
		element.setAttribute('allowtransparency', 'true');
		element.style.border = 'none';
		

		if (onload) jQuery(element).bind('load', onload);
		element.setAttribute('src', href);
		element.style.width="200px";
		element.style.height="200px";
		return element;
	};




	var Oxygen = this.Oxygen = (function() {
		var adapter,
		options = OXYGEN_OPTIONS,
		server_root = window.location.href.split('/').slice(0, 3).join('/') + '/', 
		fn = {
			init: function(opts) {
				if (adapter) return;
				opts = opts || {};
				
				switch (options.viewmode) {
				case 'iframe':
					adapter = new OxygenOverlayIframe(mergeOptions(opts, options.viewmode_options));
					break;
				case 'popup':
					adapter = new OxygenPopup(mergeOptions({}, options.viewmode_options));
					break;
				case 'inline':
					adapter = new OxygenOverlayInline(mergeOptions({}, options.viewmode_options));
					break;
				}
			},
			getOptions: function() {
				return options;
			},
			setOptions: function(new_opts) {
				if (adapter && new_opts.hasOwnProperty('viewmode') && new_opts.viewmode !== options.viewmode) {
				adapter.close();
				adapter = null;
				}
				
				options = mergeOptions(new_opts, options);

				return this;
			},
			getBaseOpenIDProviderURL: function(provider, immediate, register) {
				var providerURL = options.providers_endpoint[provider] + "/SignIn"  +
					"?openid.ns=" + encodeURIComponent("http://specs.openid.net/auth/2.0") +
					"&openid.claimed_id=" + encodeURIComponent("http://specs.openid.net/auth/2.0/identifier_select") +
					"&openid.identity=" + encodeURIComponent("http://specs.openid.net/auth/2.0/identifier_select") +
					"&openid.return_to=" + encodeURIComponent(server_root + options.openid_response) +
					"&openid.realm=" + encodeURIComponent(server_root + options.openid_response) +
					"&openid.ns.ax=" + encodeURIComponent("http://openid.net/srv/ax/1.0") +
					"&openid.ax.required=name" +
					"&openid.ax.mode=fetch_request" +
					"&openid.ax.type.name=" + encodeURIComponent("http://axschema.org/namePerson/friendly") +
					"&openid.ax.count.name=1" ;
				if(immediate) {
					providerURL += "&openid.mode=checkid_immediate";
				} else {
					providerURL += "&openid.mode=checkid_setup" +
								"&openid.ns.alias5=" + encodeURIComponent("http://specs.openid.net/extensions/ui/1.0") +
								"&openid.alias5.mode=" + encodeURIComponent(options.viewmode) +
								"&openid.alias5.iframe_refresh_url=" + encodeURIComponent(server_root + options.refresh_response);
				}
				if(register) {
					providerURL += "&openid.ns.alias6=" + encodeURIComponent("http://autodesk.com/openid/ext/register/1.0") +
								"&openid.alias6.mode=" + encodeURIComponent('register');
				}
				return providerURL;
			},
			receiveMessage: function(e) {
				var params;
				
				if (!/(autodesk\.com)$/.test(e.origin)) return;
				if (/^iframe\-resize::(\d+),(\d+)/.test(e.data)) {
					params = e.data.match(/^iframe\-resize::(\d+),(\d+)/);
					if (!params) return;
					Oxygen.resizeTo({width: params[1], height: params[2]}, false);
				}
			}
		};
		
		if (window.addEventListener) {
			window.addEventListener('message', fn.receiveMessage, false);
		}
		
		return {
			getOptions: fn.getOptions,
			setOptions: fn.setOptions,
			show: function(href, viewmode, size, link_click) {
				if (viewmode && viewmode !== options.viewmode) {
				adapter = null;
				options.viewmode = viewmode;
				}
				
				fn.init(href && {href: href});
				options.viewmode_options.onLoadStart && options.viewmode_options.onLoadStart();
				if(options.link_click == 'register'){
				adapter.open(href || fn.getBaseOpenIDProviderURL(options.provider, false, true), size);
				}
				else{
				adapter.open(href || fn.getBaseOpenIDProviderURL(options.provider, false, false), size);
				}
			},
			hide: function() {
				if (adapter) adapter.close();
			},
			resizeTo: function(size, animate) {
				if (adapter) adapter.resizeTo(size, animate);
			},
			checkImmediate: function(url) {
				options.onCheckImmediate && options.onCheckImmediate();
				var iframe = OxygenIframe(url || fn.getBaseOpenIDProviderURL(options.provider, true, false), options.onAfterCheckImmediate);
				iframe.style.display = 'none';
				document.body.appendChild(iframe);
			},
			processOpenIDResponse: function(url) {
				options.onOpenIDResponse && options.onOpenIDResponse(parseQueryString(url));
				if (adapter) adapter.close();
			},
			processOpenIDRefreshResponse: function(url) {
				var query = parseQueryString(url);
				if (query.page) {
				Oxygen.show(query.page, undefined, {width: query.width, height: query.height});
				} else {
				Oxygen.resizeTo({width: query.width, height: query.height}, true);
				}
			},
			processLoginError: function () {
				Oxygen.hide();
				if(options.onLoginError)
				options.onLoginError();
			},
			signOut: function(returnUrl, provider) {
				var url = options.providers_endpoint[provider || options.provider] + "/Authentication/LogOut";
				if (returnUrl !== undefined && returnUrl !== null) {
				url += "?ReturnToUrl=" + encodeURIComponent((/^http(?:s)?:\/\//.test(returnUrl) ? '' : server_root) + returnUrl);
				}
				var iframe = OxygenIframe(url);
				iframe.style.display = 'none';
				document.body.appendChild(iframe);
			}, 
			toString: function() { return 'Oxygen'; }
		};
	})();



	// trying to detect mobile browsers so we can disable iframe scrolling, which won't work on mobile.
	if (window.Modernizr && Modernizr.mq && (Modernizr.mq('handheld') || Modernizr.mq('screen and (max-device-width: 480px)') || Modernizr.mq('only screen and (-webkit-min-device-pixel-ratio: 2)') || Modernizr.mq('only screen and (max-device-width: 1024px)'))) {
		Oxygen.MOBILE_FRIENDLY = true;
	}

}).call(this);




;(function($) {
	
	$(function() {
	
		
		var userAnon = ${user.anonymous?c};
		var soUrl = $('a.logout-link').attr('href');
			Oxygen.setOptions({
				viewmode: 'iframe',
				viewmode_options: {
					width: 350,
					height: 356,
					close_button: {
						size: 24,
						image: 'html/assets/close_24.png'
					}
				},
				providers_endpoint: {
					autodesk: oxygenUrl
				},
				openid_response: 'html/assets/oxygen_openid_response.html',
				refresh_response: 'html/assets/oxygen_refresh_response.html',
				onOpenIDResponse: function(params) {
				
					if(params.newpost){
						
						top.window.location.href = bounce+"&dest_url="+encodeURIComponent(params.newpostURL);
					}else{
						if (params['openid.mode']) {
								switch (params['openid.mode']) {
								case 'setup_needed':
									break;
								case 'id_res':
									if(userAnon){
										top.window.location.href = bounce;
									}
									break;
								default:
									throw 'Unknown OpenID response: ' + params['openid.mode'];
								}
							} else if (params.signout) {
								if( "${coreNode.id}" == "autodesk" && "${page.name}"!= "ViewProfilePage"){
									top.window.location.href = soUrl+"&dest_url=/";
								}else if("${page.name}"== "PostPage" || "${page.name}"== "EditPage" || "${page.name}"== "ReplyPage"){
									top.window.location.href = soUrl+"&dest_url=/";
								}
								else{
									top.window.location.href = soUrl+"&dest_url="+top.window.location.href;
								}
							}
						}
				}
			});


		/*  Setup for my dashbboard giving pop-up window and redirecting to homepage*/
		
		<#if isMyDashBoardPage=="true" && user.anonymous?c=="true">
		$(window).load(function(e){
			//debugger;
			$('a.login-link').trigger('click');  
		});
		</#if>
		/* setup event for login */


		$('a.login-link').bind({
			click: function(e) {
				
			e.preventDefault();
		
			Cookies.set('loginAttemptedPage', window.location.href, { path: '/'});
			Oxygen.setOptions({viewmode: 'iframe',link_click: 'signin',openid_response: "html/assets/oxygen_openid_response.html",providers_endpoint: {autodesk: oxygenUrl}, viewmode_options: {width: 350, height: 356}}).show();
			$("#oxygen-container").css({"padding-left":"0px","padding-top":"0px","margin-top":"10px!important"});
			setting_css_for_login_register();
			
			
			},
			keydown: function(e) {
			if (e.keyCode === 13 || e.keyCode === 32) $(this).trigger('click');
			}
		});
			
		/* setup event for registration */
			
			
		$('a.registration-link').bind({
			click: function(e) {
			
			e.preventDefault();
			Oxygen.setOptions({viewmode: 'iframe', link_click: 'register',providers_endpoint: {autodesk: oxygenUrl}, viewmode_options: {width: 350, height: 356}}).show();
				$("#oxygen-container").addClass('newClassRegister');
			$("#oxygen-container").css({"padding-left":"0px","padding-top":"0px","margin-top":"10px!important"});
			setting_css_for_login_register();
			},
			keydown: function(e) {
			if (e.keyCode === 13 || e.keyCode === 32) $(this).trigger('click');
			}
		});
			
		/* setup event for logout  */
			
		$('a.logout-link').bind({
			click: function(e) {
			//debugger;
			e.preventDefault();
			Oxygen.signOut(Oxygen.getOptions().openid_response + "?signout=1");
			adskUnifiedProfile.logout();
			},
			keydown: function(e) {
			if (e.keyCode === 13 || e.keyCode === 32) $(this).trigger('click');
			}
		});
			
		/* setup event for click on  kudos, replies when user is not logged in ask for login */
			
			
		if(userAnon){
			$('a.lia-message-comment-post').bind({
				click: function(e) {
				e.preventDefault();
				var newpostURL = e.target.href;
				if(newpostURL.indexOf('/auth/openid_security_check') != -1){
					
					var queryStr = e.target.search;
					var index = queryStr.indexOf('&dest_url=') + 10;
					newpostURL = queryStr.substr(index);
				}
				
				Cookies.set('loginAttemptedPage', newpostURL, { path: '/'});
				Oxygen.setOptions({viewmode: 'iframe',link_click: 'signin',openid_response: "html/assets/oxygen_openid_response.html?newpost=1&newpostURL=" + newpostURL ,providers_endpoint: {autodesk: oxygenUrl}, viewmode_options: {width: 350, height: 356}}).show();
				$("#oxygen-container").css({"padding-left":"0px","padding-top":"0px","margin-top":"10px!important"});
			setting_css_for_login_register();
				},
				keydown: function(e) {
				if (e.keyCode === 13 || e.keyCode === 32) $(this).trigger('click');
				}
			});
			$('.lia-quilt-layout-blog-message .lia-quilt-row-footer').on('click','a.lia-button-secondary.post-comment',function(e){
				e.preventDefault();
				var newpostURL = e.target.baseURI + "#comments";
				
				Cookies.set('loginAttemptedPage', newpostURL, { path: '/'});
				Oxygen.setOptions({viewmode: 'iframe',link_click: 'signin',openid_response: "html/assets/oxygen_openid_response.html?newpost=1&newpostURL=" + encodeURIComponent(newpostURL) ,providers_endpoint: {autodesk: oxygenUrl}, viewmode_options: {width: 350, height: 356}}).show();
				$("#oxygen-container").css({"padding-left":"0px","padding-top":"0px","margin-top":"10px!important"});
			setting_css_for_login_register();
			});
			$('.lia-quilt-layout-blog-message .lia-quilt-row-footer').on('keydown','a.lia-button-secondary.post-comment',function(e){
				if (e.keyCode === 13 || e.keyCode === 32) $(this).trigger('click');
			});
			
			$('.lia-component-custom-post-to-community a.lia-post-link,a.lia-button-secondary.reply-action-link.lia-action-reply,.primary-action.message-reply .lia-button,.primary-action.message-post .lia-button,.custom-ideas-marketing-banner .lia-post-link,a.report-abuse-link,.lia-button-wrapper.lia-button-wrapper-primary.lia-component-primary-post-button .primary-action.article-post,.lia-go-to-forums').bind({
				click: function(e) {
				e.preventDefault();
				var newpostURL = $(this).attr('href');
				
				Cookies.set('loginAttemptedPage', newpostURL, { path: '/'});
				Oxygen.setOptions({viewmode: 'iframe',link_click: 'signin',openid_response: "html/assets/oxygen_openid_response.html?newpost=1&newpostURL=" + encodeURIComponent(newpostURL) ,providers_endpoint: {autodesk: oxygenUrl}, viewmode_options: {width: 350, height: 356}}).show();
				$("#oxygen-container").css({"padding-left":"0px","padding-top":"0px","margin-top":"10px!important"});
			setting_css_for_login_register();
				},
				keydown: function(e) {
				if (e.keyCode === 13 || e.keyCode === 32) $(this).trigger('click');
				}
			});			
			
			/*  kudos link click refined code according to class , getting message id  */
			
			
			$('.kudos-link').bind({
			
				click: function(e) {
				//debugger;
					e.preventDefault();
					
					var tar=e.currentTarget;
					var temp = $(tar).closest('.lia-panel-message');
					var msg_id=$(temp).attr('data-lia-message-uid');
					var lc=window.location.href;
					var new_lc=lc.replace('td','m');
					var kudosURL = new_lc +"#"+ msg_id;
									
					Cookies.set('loginAttemptedPage', kudosURL, { path: '/' });
					Oxygen.setOptions({ viewmode: 'iframe', link_click: 'signin', openid_response: "html/assets/oxygen_openid_response.html?newpost=1&newpostURL=" + encodeURIComponent(kudosURL), providers_endpoint: { autodesk: oxygenUrl }, viewmode_options: { width: 350, height: 356 } }).show();
					$("#oxygen-container").css({"padding-left":"0px","padding-top":"0px","margin-top":"10px!important"});
					setting_css_for_login_register();
		 
				},
				keydown: function(e) {
					if (e.keyCode === 13 || e.keyCode === 32) $(this).trigger('click');
				}
			});
			
			$(".lia-button-image-kudos-wrapper .lia-button-image-kudos-enabled .lia-button-image-kudos-give .give-kudo-text").click(function() {
				var elem = $(this).closest(".lia-button-image-kudos-give");
				var elem2 = elem.find("a.kudos-link");
				
				if($(elem2)[0] != undefined){
					$(elem2)[0].click();
				}
			
			});
			
			
		}
		
			
		window.onresize=function(){
			if ($("#oxygen-container").length) {
				var position_offset_vertical=$("#oxygen-container").offset().top;
				var win_height=$(window).height();
				var oxy_height=$("#oxygen-container").outerHeight();
				var diff=win_height-oxy_height;
				var x=(position_offset_vertical-(diff/2));
				$(window).scrollTop(x);
			}
		}
		
		function setting_css_for_login_register(){
			$('iframe').load(function () {
		
				var xx=$(this);
				var source_href=$(xx).attr('src');
				$(xx).css({'height':'100%','width':'100%'});
				$(xx).css({"padding-left":"10px","padding-top":"10px"});
				if ($("#oxygen-container").length) {
					$("#oxygen-container").addClass('newClass');
					$("#oxygen-container").css("margin-top","10px");
					var position_offset_vertical=$("#oxygen-container").offset().top;
					var win_height=$(window).height();
					var oxy_height=$("#oxygen-container").outerHeight();
					var diff=win_height-oxy_height;
					var x=(position_offset_vertical-(diff/2));
					$(window).scrollTop(x);
				}
				$('.iframe_mode').css({"overflow":"hidden"});
			});
		}
			
		Oxygen.checkImmediate();
		
		
	});
})(LITHIUM.jQuery);
</@liaAddScript>
</#if>
</div>
<style>
	.newClass {
		overflow: visible !important;
	}
	.newClassRegister {
		overflow: visible !important;
		width: 345px !important;
	}
	body.iframe_mode {
		overflow-y: hidden !important;
	}
</style>