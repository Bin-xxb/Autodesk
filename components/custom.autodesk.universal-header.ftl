<#assign switch_user_mode = http.session.attributes.name.get("switch_user_mode", "")/>

<#if switch_user_mode?has_content>
	<@component id="users.widget.menu"/>
<#else>

	<div id="forums-uh-container-wrapper" style="min-height:98px;">
		<div id="forums-uh-container" style="min-height:98px;position:fixed;z-index:999;top:0;left:0;right:0;"></div>
	</div>

	<#assign sso_id = "" />
	<#if !user.anonymous>
		<#assign query = "SELECT sso_id FROM users WHERE id = '${user.id?c}'" />
		<#assign items = restadmin("2.0", "/search?q=${query?url}").data.items![] />
		<#if items?size gt 0>
			<#assign sso_id = items[0].sso_id />
		</#if>
	</#if>

	<#assign notification_unread = "false" />
	<#assign notification_count = 0 />
	<#if !user.anonymous>
		<#assign query = "SELECT count(*) FROM notification_feeds" />
		<#assign items_count = rest("2.0", "/search?q=${query?url}").data.count!0 />
		<#if items_count gt 0>
			<#assign notification_unread = "true" />
			<#assign notification_count = items_count />
		</#if>
	</#if>

	<#assign messages_unread = "false" />
	<#assign messages_count = 0 />
	<#if !user.anonymous>
		<#assign items_count = rest("/users/id/${user.id?c}/mailbox/notes/inbox/unread/count").value?number />
		<#if items_count gt 0>
			<#assign messages_unread = "true" />
			<#assign messages_count = items_count />
		</#if>
	</#if>

	<#assign country = http.request.cookies.name.get("OPTOUTMULTI_GEO").value!"" />

	<#assign user_lang = settings.name.get("profile.language") />
	<#if !user_lang?has_content>
		<#assign user_lang = "en" />
	</#if>

	<#switch user_lang>
		<#case "de">
			<#assign lang = "de-DE" />
			<#break>
		<#case "fr">
			<#assign lang = "fr-FR" />
			<#break>
		<#case "es">
			<#assign lang = "es-ES" />
			<#break>
		<#case "pt-br">
			<#assign lang = "pt-BR" />
			<#break>
		<#case "ru">
			<#assign lang = "ru-RU" />
			<#break>
		<#case "zh-CN">
			<#assign lang = "zh-CN" />
			<#break>
		<#case "ja">
			<#assign lang = "ja-JP" />
			<#break>
		<#case "tr">
			<#assign lang = "tr-TR" />
			<#break>
		<#default>
			<#assign lang = "en-US" />
	</#switch>


	<script>
		/*! @adsk/dhx-auth - v1.2.3
				Copyright 2020 Autodesk, Inc. All rights reserved. */
		!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?module.exports=t():"function"==typeof define&&define.amd?define("DHXOxygen",t):(e=e||self).DHXOxygen=t()}(this,(function(){"use strict";function e(e,t){return e(t={exports:{}},t.exports),t.exports}var t=e((function(e){var t=e.exports="undefined"!=typeof window&&window.Math==Math?window:"undefined"!=typeof self&&self.Math==Math?self:Function("return this")();"number"==typeof __g&&(__g=t)})),n=function(e){if("function"!=typeof e)throw TypeError(e+" is not a function!");return e},o=function(e,t,o){if(n(e),void 0===t)return e;switch(o){case 1:return function(n){return e.call(t,n)};case 2:return function(n,o){return e.call(t,n,o)};case 3:return function(n,o,r){return e.call(t,n,o,r)}}return function(){return e.apply(t,arguments)}},r={}.toString,i=function(e){return r.call(e).slice(8,-1)},s=e((function(e){var t=e.exports={version:"2.6.11"};"number"==typeof __e&&(__e=t)})),a=(s.version,e((function(e){var n=t["__core-js_shared__"]||(t["__core-js_shared__"]={});(e.exports=function(e,t){return n[e]||(n[e]=void 0!==t?t:{})})("versions",[]).push({version:s.version,mode:"global",copyright:"© 2019 Denis Pushkarev (zloirock.ru)"})}))),c=0,u=Math.random(),d=function(e){return"Symbol(".concat(void 0===e?"":e,")_",(++c+u).toString(36))},p=e((function(e){var n=a("wks"),o=t.Symbol,r="function"==typeof o;(e.exports=function(e){return n[e]||(n[e]=r&&o[e]||(r?o:d)("Symbol."+e))}).store=n})),h=p("toStringTag"),l="Arguments"==i(function(){return arguments}()),f=function(e){var t,n,o;return void 0===e?"Undefined":null===e?"Null":"string"==typeof(n=function(e,t){try{return e[t]}catch(e){}}(t=Object(e),h))?n:l?i(t):"Object"==(o=i(t))&&"function"==typeof t.callee?"Arguments":o},v=function(e){return"object"==typeof e?null!==e:"function"==typeof e},m=function(e){if(!v(e))throw TypeError(e+" is not an object!");return e},y=function(e){try{return!!e()}catch(e){return!0}},g=!y((function(){return 7!=Object.defineProperty({},"a",{get:function(){return 7}}).a})),_=t.document,w=v(_)&&v(_.createElement),x=function(e){return w?_.createElement(e):{}},b=!g&&!y((function(){return 7!=Object.defineProperty(x("div"),"a",{get:function(){return 7}}).a})),O=Object.defineProperty,k={f:g?Object.defineProperty:function(e,t,n){if(m(e),t=function(e,t){if(!v(e))return e;var n,o;if("function"==typeof(n=e.toString)&&!v(o=n.call(e)))return o;if("function"==typeof(n=e.valueOf)&&!v(o=n.call(e)))return o;throw TypeError("Can't convert object to primitive value")}(t),m(n),b)try{return O(e,t,n)}catch(e){}if("get"in n||"set"in n)throw TypeError("Accessors not supported!");return"value"in n&&(e[t]=n.value),e}},I=g?function(e,t,n){return k.f(e,t,function(e,t){return{enumerable:!1,configurable:!0,writable:!0,value:t}}(0,n))}:function(e,t,n){return e[t]=n,e},E={}.hasOwnProperty,j=function(e,t){return E.call(e,t)},S=a("native-function-to-string",Function.toString),C=e((function(e){var n=d("src"),o=(""+S).split("toString");s.inspectSource=function(e){return S.call(e)},(e.exports=function(e,r,i,s){var a="function"==typeof i;a&&(j(i,"name")||I(i,"name",r)),e[r]!==i&&(a&&(j(i,n)||I(i,n,e[r]?""+e[r]:o.join(String(r)))),e===t?e[r]=i:s?e[r]?e[r]=i:I(e,r,i):(delete e[r],I(e,r,i)))})(Function.prototype,"toString",(function(){return"function"==typeof this&&this[n]||S.call(this)}))})),R=function(e,n,r){var i,a,c,u,d=e&R.F,p=e&R.G,h=e&R.S,l=e&R.P,f=e&R.B,v=p?t:h?t[n]||(t[n]={}):(t[n]||{}).prototype,m=p?s:s[n]||(s[n]={}),y=m.prototype||(m.prototype={});for(i in p&&(r=n),r)c=((a=!d&&v&&void 0!==v[i])?v:r)[i],u=f&&a?o(c,t):l&&"function"==typeof c?o(Function.call,c):c,v&&C(v,i,c,e&R.U),m[i]!=c&&I(m,i,u),l&&y[i]!=c&&(y[i]=c)};t.core=s,R.F=1,R.G=2,R.S=4,R.P=8,R.B=16,R.W=32,R.U=64,R.R=128;var T,P,A,L=R,N=function(e,t,n,o){try{return o?t(m(n)[0],n[1]):t(n)}catch(t){var r=e.return;throw void 0!==r&&m(r.call(e)),t}},D={},U=p("iterator"),H=Array.prototype,M=function(e){return void 0!==e&&(D.Array===e||H[U]===e)},z=Math.ceil,q=Math.floor,G=function(e){return isNaN(e=+e)?0:(e>0?q:z)(e)},W=Math.min,B=function(e){
			return e>0?W(G(e),9007199254740991):0},F=p("iterator"),Z=s.getIteratorMethod=function(e){if(null!=e)return e[F]||e["@@iterator"]||D[f(e)]},J=e((function(e){var t={},n={},r=e.exports=function(e,r,i,s,a){var c,u,d,p,h=a?function(){return e}:Z(e),l=o(i,s,r?2:1),f=0;if("function"!=typeof h)throw TypeError(e+" is not iterable!");if(M(h)){for(c=B(e.length);c>f;f++)if((p=r?l(m(u=e[f])[0],u[1]):l(e[f]))===t||p===n)return p}else for(d=h.call(e);!(u=d.next()).done;)if((p=N(d,l,u.value,r))===t||p===n)return p};r.BREAK=t,r.RETURN=n})),K=p("species"),Q=function(e,t,n){var o=void 0===n;switch(t.length){case 0:return o?e():e.call(n);case 1:return o?e(t[0]):e.call(n,t[0]);case 2:return o?e(t[0],t[1]):e.call(n,t[0],t[1]);case 3:return o?e(t[0],t[1],t[2]):e.call(n,t[0],t[1],t[2]);case 4:return o?e(t[0],t[1],t[2],t[3]):e.call(n,t[0],t[1],t[2],t[3])}return e.apply(n,t)},X=t.document,V=X&&X.documentElement,Y=t.process,$=t.setImmediate,ee=t.clearImmediate,te=t.MessageChannel,ne=t.Dispatch,oe=0,re={},ie=function(){var e=+this;if(re.hasOwnProperty(e)){var t=re[e];delete re[e],t()}},se=function(e){ie.call(e.data)};$&&ee||($=function(e){for(var t=[],n=1;arguments.length>n;)t.push(arguments[n++]);return re[++oe]=function(){Q("function"==typeof e?e:Function(e),t)},T(oe),oe},ee=function(e){delete re[e]},"process"==i(Y)?T=function(e){Y.nextTick(o(ie,e,1))}:ne&&ne.now?T=function(e){ne.now(o(ie,e,1))}:te?(A=(P=new te).port2,P.port1.onmessage=se,T=o(A.postMessage,A,1)):t.addEventListener&&"function"==typeof postMessage&&!t.importScripts?(T=function(e){t.postMessage(e+"","*")},t.addEventListener("message",se,!1)):T="onreadystatechange"in x("script")?function(e){V.appendChild(x("script")).onreadystatechange=function(){V.removeChild(this),ie.call(e)}}:function(e){setTimeout(o(ie,e,1),0)});var ae={set:$,clear:ee},ce=ae.set,ue=t.MutationObserver||t.WebKitMutationObserver,de=t.process,pe=t.Promise,he="process"==i(de);function le(e){var t,o;this.promise=new e((function(e,n){if(void 0!==t||void 0!==o)throw TypeError("Bad Promise constructor");t=e,o=n})),this.resolve=n(t),this.reject=n(o)}var fe={f:function(e){return new le(e)}},ve=function(e){try{return{e:!1,v:e()}}catch(e){return{e:!0,v:e}}},me=t.navigator,ye=me&&me.userAgent||"",ge=k.f,_e=p("toStringTag"),we=p("species"),xe=p("iterator"),be=!1;try{var Oe=[7][xe]();Oe.return=function(){be=!0},Array.from(Oe,(function(){throw 2}))}catch(e){}var ke,Ie,Ee,je,Se,Ce,Re=ae.set,Te=function(){var e,n,o,r=function(){var t,r;for(he&&(t=de.domain)&&t.exit();e;){r=e.fn,e=e.next;try{r()}catch(t){throw e?o():n=void 0,t}}n=void 0,t&&t.enter()};if(he)o=function(){de.nextTick(r)};else if(!ue||t.navigator&&t.navigator.standalone)if(pe&&pe.resolve){var i=pe.resolve(void 0);o=function(){i.then(r)}}else o=function(){ce.call(t,r)};else{var s=!0,a=document.createTextNode("");new ue(r).observe(a,{characterData:!0}),o=function(){a.data=s=!s}}return function(t){var r={fn:t,next:void 0};n&&(n.next=r),e||(e=r,o()),n=r}}(),Pe=t.TypeError,Ae=t.process,Le=Ae&&Ae.versions,Ne=Le&&Le.v8||"",De=t.Promise,Ue="process"==f(Ae),He=function(){},Me=Ie=fe.f,ze=!!function(){try{var e=De.resolve(1),t=(e.constructor={})[p("species")]=function(e){e(He,He)};return(Ue||"function"==typeof PromiseRejectionEvent)&&e.then(He)instanceof t&&0!==Ne.indexOf("6.6")&&-1===ye.indexOf("Chrome/66")}catch(e){}}(),qe=function(e){var t;return!(!v(e)||"function"!=typeof(t=e.then))&&t},Ge=function(e,t){if(!e._n){e._n=!0;var n=e._c;Te((function(){for(var o=e._v,r=1==e._s,i=0,s=function(t){var n,i,s,a=r?t.ok:t.fail,c=t.resolve,u=t.reject,d=t.domain;try{a?(r||(2==e._h&&Fe(e),e._h=1),!0===a?n=o:(d&&d.enter(),n=a(o),d&&(d.exit(),s=!0)),n===t.promise?u(Pe("Promise-chain cycle")):(i=qe(n))?i.call(n,c,u):c(n)):u(o)}catch(e){d&&!s&&d.exit(),u(e)}};n.length>i;)s(n[i++]);e._c=[],e._n=!1,t&&!e._h&&We(e)}))}},We=function(e){Re.call(t,(function(){var n,o,r,i=e._v,s=Be(e);if(s&&(n=ve((function(){Ue?Ae.emit("unhandledRejection",i,e):(o=t.onunhandledrejection)?o({promise:e,reason:i}):(r=t.console)&&r.error&&r.error("Unhandled promise rejection",i)})),e._h=Ue||Be(e)?2:1),e._a=void 0,
		s&&n.e)throw n.v}))},Be=function(e){return 1!==e._h&&0===(e._a||e._c).length},Fe=function(e){Re.call(t,(function(){var n;Ue?Ae.emit("rejectionHandled",e):(n=t.onrejectionhandled)&&n({promise:e,reason:e._v})}))},Ze=function(e){var t=this;t._d||(t._d=!0,(t=t._w||t)._v=e,t._s=2,t._a||(t._a=t._c.slice()),Ge(t,!0))},Je=function(e){var t,n=this;if(!n._d){n._d=!0,n=n._w||n;try{if(n===e)throw Pe("Promise can't be resolved itself");(t=qe(e))?Te((function(){var r={_w:n,_d:!1};try{t.call(e,o(Je,r,1),o(Ze,r,1))}catch(e){Ze.call(r,e)}})):(n._v=e,n._s=1,Ge(n,!1))}catch(e){Ze.call({_w:n,_d:!1},e)}}};ze||(De=function(e){!function(e,t,n,o){if(!(e instanceof t)||"_h"in e)throw TypeError("Promise: incorrect invocation!")}(this,De),n(e),ke.call(this);try{e(o(Je,this,1),o(Ze,this,1))}catch(e){Ze.call(this,e)}},(ke=function(e){this._c=[],this._a=void 0,this._s=0,this._d=!1,this._v=void 0,this._h=0,this._n=!1}).prototype=function(e,t,n){for(var o in t)C(e,o,t[o],void 0);return e}(De.prototype,{then:function(e,t){var o,r,i,s=Me((o=De,void 0===(i=m(this).constructor)||null==(r=m(i)[K])?o:n(r)));return s.ok="function"!=typeof e||e,s.fail="function"==typeof t&&t,s.domain=Ue?Ae.domain:void 0,this._c.push(s),this._a&&this._a.push(s),this._s&&Ge(this,!1),s.promise},catch:function(e){return this.then(void 0,e)}}),Ee=function(){var e=new ke;this.promise=e,this.resolve=o(Je,e,1),this.reject=o(Ze,e,1)},fe.f=Me=function(e){return e===De||e===je?new Ee(e):Ie(e)}),L(L.G+L.W+L.F*!ze,{Promise:De}),(Se=De)&&!j(Se=Se.prototype,_e)&&ge(Se,_e,{configurable:!0,value:"Promise"}),Ce=t.Promise,g&&Ce&&!Ce[we]&&k.f(Ce,we,{configurable:!0,get:function(){return this}}),je=s.Promise,L(L.S+L.F*!ze,"Promise",{reject:function(e){var t=Me(this);return(0,t.reject)(e),t.promise}}),L(L.S+L.F*!ze,"Promise",{resolve:function(e){return function(e,t){if(m(e),v(t)&&t.constructor===e)return t;var n=fe.f(e);return(0,n.resolve)(t),n.promise}(this,e)}}),L(L.S+L.F*!(ze&&function(e,t){if(!be)return!1;var n=!1;try{var o=[7],r=o[xe]();r.next=function(){return{done:n=!0}},o[xe]=function(){return r},function(e){De.all(e).catch(He)}(o)}catch(e){}return n}()),"Promise",{all:function(e){var t=this,n=Me(t),o=n.resolve,r=n.reject,i=ve((function(){var n=[],i=0,s=1;J(e,!1,(function(e){var a=i++,c=!1;n.push(void 0),s++,t.resolve(e).then((function(e){c||(c=!0,n[a]=e,--s||o(n))}),r)})),--s||o(n)}));return i.e&&r(i.v),n.promise},race:function(e){var t=this,n=Me(t),o=n.reject,r=ve((function(){J(e,!1,(function(e){t.resolve(e).then(n.resolve,o)}))}));return r.e&&o(r.v),n.promise}});var Ke={};Ke[p("toStringTag")]="z",Ke+""!="[object z]"&&C(Object.prototype,"toString",(function(){return"[object "+f(this)+"]"}),!0);var Qe=Object("z").propertyIsEnumerable(0)?Object:function(e){return"String"==i(e)?e.split(""):Object(e)},Xe=function(e){if(null==e)throw TypeError("Can't call method on  "+e);return e},Ve=function(e){return Qe(Xe(e))},Ye=Math.max,$e=Math.min,et=a("keys"),tt=function(e,t,n){for(var o=Ve(e),r=B(o.length),i=function(e,t){return(e=G(e))<0?Ye(e+t,0):$e(e,t)}(n,r);r>i;i++)if(i in o&&o[i]===t)return i||0;return-1},nt=et.IE_PROTO||(et.IE_PROTO=d("IE_PROTO")),ot="constructor,hasOwnProperty,isPrototypeOf,propertyIsEnumerable,toLocaleString,toString,valueOf".split(","),rt=Object.keys||function(e){return function(e,t){var n,o=Ve(e),r=0,i=[];for(n in o)n!=nt&&j(o,n)&&i.push(n);for(;t.length>r;)j(o,n=t[r++])&&(~tt(i,n)||i.push(n));return i}(e,ot)},it={f:{}.propertyIsEnumerable},st=it.f,at=function(e){for(var t,n=Ve(e),o=rt(n),r=o.length,i=0,s=[];r>i;)t=o[i++],g&&!st.call(n,t)||s.push([t,n[t]]);return s};L(L.S,"Object",{entries:function(e){return at(e)}});var ct=function(e){return e.split("/").slice(0,-1).join("/")+"/"},ut=function(e){return/^(?:http(?:s?)\:)?\/\//.test(e)?e:ct(window.location.href)+e},dt=function(e){var t=e.split("?"),n=t[0],o=t[1];return{endpoint:n,queryString:o,params:o?ht(o):{}}},pt=function e(t){for(var n=arguments.length,o=new Array(n>1?n-1:0),r=1;r<n;r++)o[r-1]=arguments[r];return o.forEach((function(n){Object.entries(n).forEach((function(n){var o=n[0],r=n[1]
		;"__proto__"!==o&&(t.hasOwnProperty(o)&&null!==t[o]&&"object"==typeof t[o]&&"object"==typeof r?t[o]=e(t[o],r):t[o]=r)}))})),t},ht=function(e){return(/\?.+/.test(e)?e.substring(e.indexOf("?")+1):e).split("&").reduce((function(e,t){var n=t.split("="),o=n[0],r=n[1];return e[o]=decodeURIComponent(r),e}),{})},lt=function(e,t){Object.entries(t).forEach((function(t){var n=t[0],o=t[1];e.style[n]=o}))},ft=function(e,t){Object.entries(t).forEach((function(t){var n=t[0],o=t[1];e.setAttribute(n,o)}))},vt=function(e){return document.getElementById(e)||((t=document.createElement("div")).setAttribute("id",e),t);var t},mt=function(e){var t=e.message,n=e.code,o=e.request,r=new Error(t);return n&&(r.code=n),r.request=o,r},yt={oxygen:"https://accounts-staging.autodesk.com",dhx:"https://akn.services-staging.autodesk.com"},gt={environment:"production",endpoints:{dev:yt,staging:yt,production:{oxygen:"https://accounts.autodesk.com",dhx:"https://akn.services.autodesk.com"}}},_t={returnUrl:"",stateLess:!1,oauth2:!0},wt={},xt=function(e){var t,n=e.url,o=e.method,r=void 0===o?"get":o,i=e.data,s=void 0===i?{}:i,a=e.headers;return(t={url:n,method:r,headers:void 0===a?{}:a,withCredentials:e.withCredentials,data:s,timeout:3e4},void 0===t&&(t={}),t.headers=pt({Accept:"application/json, text/javascript, */*; q=0.01","Content-Type":"application/json;charset=utf-8"},t.headers||{}),function(e){var t=e.url,n=e.method,o=void 0===n?"get":n,r=e.withCredentials,i=e.headers,s=void 0===i?{}:i,a=e.data,c=void 0===a?null:a;return new Promise((function(e,n){var i=new XMLHttpRequest,a=o.toUpperCase(),u="GET"===a?function(e,t){void 0===t&&(t={});var n=Object.keys(t.params||{}).reduce((function(e,n,o,r){return void 0!==t.params[n]&&e.push(n+(t.params.hasOwnProperty(n)&&null!==t.params[n]?"="+encodeURIComponent(t.params[n]):"")),e}),[]),o=-1===e.indexOf("?")?"?":"&";return e+(n.length?o+n.join("&"):"")}(t,{params:c}):t;i.open(a,u),Object.keys(s).forEach((function(e){i.setRequestHeader(e,s[e])})),i.onreadystatechange=function(){i&&4===i.readyState&&(0!==i.status||i.responseURL&&0===i.responseURL.indexOf("file:"))&&(i.status>=200&&i.status<300?e({data:i.responseText,headers:i.getAllResponseHeaders&&i.getAllResponseHeaders()||null,status:i.status,statusText:i.statusText,request:i}):n(mt({message:"Request failed with code "+i.status,request:i})),i=null)},i.onerror=function(){n(mt({message:"Network error.",request:i})),i=null},i.ontimeout=function(){n(mt({message:"Network timeout.",code:"ECONNABORTED",request:i})),i=null},r&&(i.withCredentials=r),i.send(c)}))}(t).then((function(e){return e.data=JSON.parse(e.data),e}))).then((function(e){return e.data}))},bt={getOptions:function(){var e=window.Oxygen&&window.Oxygen.getOptions()||{},t={environment:e.environment,viewmode:e.viewmode};return pt({},gt,t,wt)},setOptions:function(e){return pt(wt,e),e.onOpenIDResponse&&window.Oxygen&&window.Oxygen.setOptions({onOpenIDResponse:e.onOpenIDResponse}),bt},checkImmediate:function(e,t,n){void 0===e&&(e=_t.returnUrl),void 0===t&&(t=_t.stateLess),void 0===n&&(n=_t.responseType);var o=pt({},_t,"object"==typeof e?e:{returnUrl:e,stateLess:t,responseType:n}),r=bt.getOptions(),i=r.endpoints[r.environment].dhx,s=o.headers||{},a={identifier:r.endpoints[r.environment].oxygen,returnUrl:o.returnUrl||ct(window.location.href),responseType:o.responseType,stateLess:o.stateLess,requestId:o.requestId,clientId:o.clientId,oauth:o.oauth,oauth2:o.oauth2};return o.accessId&&o.signature&&(s.Authorization='AKNAUTH akn_accessid="'+o.accessId+'" , akn_signature="'+o.signature+'"'),xt({url:i+"/aknuserservices/user/openid/v2/checkidimmediate",headers:s,data:a,withCredentials:!o.stateLess}).then((function(e){return"SUCCESS"===e.MESSAGE?!o.stateLess&&e.CONSUMER_RESPONSE_DATA?{namePerson:e.CONSUMER_RESPONSE_DATA.first+" "+e.CONSUMER_RESPONSE_DATA.last,"autodesk/userid":e.CONSUMER_RESPONSE_DATA.userid}:e.REDIRECT_URL?window.Oxygen?(window.Oxygen.checkImmediate(e.REDIRECT_URL),{}):e.REDIRECT_URL:e:{}}))},showSignIn:function(e,t,n,o){void 0===e&&(e=_t.returnUrl),void 0===n&&(n=_t.stateLess),void 0===o&&(o=_t.responseType)
			;var r=pt({},_t,"object"==typeof e?e:{returnUrl:e,lang:t,stateLess:n,responseType:o}),i=bt.getOptions(),s=i.endpoints[i.environment].dhx,a=r.headers||{},c={identifier:i.endpoints[i.environment].oxygen,returnUrl:r.returnUrl||("redirect"===i.viewmode?window.location.href:ct(window.location.href)),mode:"redirect"===i.viewmode?"popup":i.viewmode||"iframe",responseType:r.responseType,stateLess:r.stateLess,requestId:r.requestId,clientId:r.clientId,oauth:r.oauth,oauth2:r.oauth2,pape:r.pape,uitype:r.uitype,register:r.register,lang:r.lang};return r.accessId&&r.signature&&(a.Authorization='AKNAUTH akn_accessid="'+r.accessId+'" , akn_signature="'+r.signature+'"'),xt({url:s+"/aknuserservices/user/openid/v2/signin",data:c,withCredentials:!r.stateLess}).then((function(e){return e.REDIRECT_URL&&window.Oxygen&&window.Oxygen.show(e.REDIRECT_URL,i.viewmode),e}))},signOut:function(e,t){void 0===e&&(e=""),void 0===t&&(t=!1);var n=bt.getOptions(),o=n.endpoints[n.environment].dhx;return xt({url:o+"/aknuserservices/user/openid/v2/signoff",data:{callback:""},withCredentials:!0}).then((function(o){return!t&&window.Oxygen&&window.Oxygen.signOut(e,n.environment),o}))},getAnalyticsId:function(e){var t=bt.getOptions(),n=t.endpoints[t.environment].dhx;return xt({url:n+"/aknuserservices/user/v1/analytics/analyticsid/user/"+e}).then((function(e){return e.analyticsId})).catch((function(){return Promise.resolve(null)}))},getEncodedCSN:function(e){var t=bt.getOptions(),n=t.endpoints[t.environment].dhx;return xt({url:n+"/aknuserservices/user/entitlement/v3/enc/csn/"+e}).then((function(e){return e.enccsn})).catch((function(){return Promise.resolve(null)}))},getUserData:function(){var e=bt.getOptions(),t=e.endpoints[e.environment].dhx;return xt({url:t+"/aknuserservices/user/openid/v2/userdata",withCredentials:!0}).catch((function(){return Promise.resolve({})}))},getEntitlementData:function(){var e=bt.getOptions(),t=e.endpoints[e.environment].dhx;return xt({url:t+"/aknuserservices/user/entitlement/v3/app/knowledge/getentitlementdata",withCredentials:!0}).catch((function(){return Promise.resolve({})}))}},Ot={f:Object.getOwnPropertySymbols},kt=function(e){return Object(Xe(e))},It=Object.assign,Et=!It||y((function(){var e={},t={},n=Symbol(),o="abcdefghijklmnopqrst";return e[n]=7,o.split("").forEach((function(e){t[e]=e})),7!=It({},e)[n]||Object.keys(It({},t)).join("")!=o}))?function(e,t){for(var n=kt(e),o=arguments.length,r=1,i=Ot.f,s=it.f;o>r;)for(var a,c=Qe(arguments[r++]),u=i?rt(c).concat(i(c)):rt(c),d=u.length,p=0;d>p;)a=u[p++],g&&!s.call(c,a)||(n[a]=c[a]);return n}:It;L(L.S+L.F,"Object",{assign:Et});var jt="http://specs.openid.net/auth/2.0",St=function(e,t,n){n&&n.length&&(e.push(["ax."+t,n]),n.forEach((function(t){e.push(["ax.type."+t,"http://axschema.org/"+t])})))},Ct=function(e){var t,n,o=function(e){var t=[["ns",jt],["claimed_id",jt+"/identifier_select"],["identity",jt+"/identifier_select"],["return_to",e.openid_response||window.location.href],["realm",e.openid_response||ct(window.location.href)]];switch(e.mode){case"register":t.push(["ns.alias4","http://autodesk.com/openid/ext/register/1.0"],["alias4.mode","register"]);case"checkid_setup":t.push(["mode","checkid_setup"],["ns.alias5","http://specs.openid.net/extensions/ui/1.0"],["alias5.mode",e.viewmode]),e.refresh_response&&t.push(["alias5.iframe_refresh_url",e.refresh_response]);break;case"checkid_immediate":default:t.push(["mode",e.mode])}return Rt(t)}({mode:e.mode,viewmode:e.viewmode,openid_response:e.openid_response&&ut(e.openid_response),refresh_response:e.refresh_response&&ut(e.refresh_response)}),r=e.ax_params&&(n=[],(t={required:e.ax_params.required,if_available:e.ax_params.if_available})&&(n.push(["ns.ax","http://openid.net/srv/ax/1.0"],["ax.mode","fetch_request"]),St(n,"required",t.required),St(n,"if_available",t.if_available)),Rt(n))||[];return Tt(e.endpoint,o.concat(r))},Rt=function(e){return e.map((function(e){return["openid."+e[0],e[1]]}))},Tt=function(e,t){var n;return e+"?"+(n=t,Array.isArray(n)?n:Object.entries(n)||[]).map((function(e){var t=e[0],n=e[1]
		;return t+"="+encodeURIComponent(n)})).join("&")},Pt={border:"0 none",outline:"0 none"},At={frameborder:"0",allowtransparency:"true"},Lt=function(e){void 0===e&&(e={});var t=document.createElement("iframe");return t.addEventListener("load",e.onload||function(){},!1),lt(t,pt({},Pt,e.styles||{})),ft(t,pt({},At,e.attrs||{},{src:e.src})),t},Nt=function(e){var t,n;function o(t){return void 0===t&&(t={}),e.call(this,t)||this}n=e,(t=o).prototype=Object.create(n.prototype),t.prototype.constructor=t,t.__proto__=n;var r=o.prototype;return r.open=function(t,n){this.iframe?t&&this.iframe.setAttribute("src",t):this.iframe=Lt({src:t,onload:this.options.onLoadComplete,styles:{display:"block",width:"100%",height:"100%",minWidth:"0",minHeight:"0"}}),this.iframe.parentNode||(this.empty(),this.container.appendChild(this.iframe)),e.prototype.open.call(this,void 0,n)},r.close=function(){var t=this;e.prototype.close.call(this,(function(){t.iframe&&t.iframe.parentNode&&t.iframe.parentNode.removeChild(t.iframe),t.iframe=null}))},o}(function(){function e(e){void 0===e&&(e={}),this.overlay=vt("oxygen-overlay"),this.container=vt("oxygen-container"),this.close_btn=vt("oxygen-closebtn"),this.options=pt({},{zIndex:6e4,onCreate:function(){},onOpen:function(){},onClose:function(){},styles:{overlay:{position:"fixed",left:0,top:0,right:0,bottom:0,transition:"opacity .33s ease"},container:{position:"fixed",maxHeight:"calc(100vh - 42px)",maxWidth:"calc(100vw - 42px)",top:"50%",left:"50%",webkitTransform:"translate(-50%, -50%)",msTransform:"translate(-50%, -50%)",transform:"translate(-50%, -50%)",transition:"opacity .33s ease, width .33s ease, height .33s ease",outline:"0 none"}}},e),lt(this.overlay,pt({zIndex:this.options.zIndex,opacity:0},this.options.styles.overlay)),lt(this.container,pt({width:this.options.width||"auto",height:this.options.height||"auto",zIndex:this.options.zIndex+6,opacity:0},this.options.styles.container)),ft(this.container,{role:"dialog",tabindex:"-1"}),ft(this.close_btn,{role:"button"}),this.__eventsAttached=!1,this.__keyDownHandler=function(e){27===e.keyCode&&this.close()}.bind(this),this.__overlayClickHandler=function(e){e.stopPropagation(),this.options.hideOnOverlayClick&&this.close()}.bind(this),this.__mouseWheelHandler=function(e){e.stopPropagation(),e.preventDefault()},this.options.styles.close_button&&(lt(this.close_btn,this.options.styles.close_button),this.close_btn.addEventListener("click",this.close.bind(this),!1),this.container.appendChild(this.close_btn)),this.options.content&&(this.empty(),this.container.appendChild(this.options.content))}var t=e.prototype;return t.empty=function(){for(var e=this.container.children.length;e;e--)this.container.children[e-1]!==this.close_btn&&this.container.removeChild(this.container.children[e-1])},t._show=function(){var e=this;lt(this.overlay,{display:"block"}),lt(this.container,{display:"block"}),setTimeout((function(){lt(e.overlay,{opacity:e.options.styles.overlay.opacity}),lt(e.container,{opacity:1})}),25)},t._hide=function(){var e=this;lt(this.overlay,{opacity:0}),lt(this.container,{opacity:0}),setTimeout((function(){lt(e.overlay,{display:"none"}),lt(e.container,{display:"none"})}),333)},t.open=function(e,t){var n=this;this.__eventsAttached||(document.body.addEventListener("keydown",this.__keyDownHandler,!1),this.overlay.addEventListener("click",this.__overlayClickHandler,!1),this.overlay.addEventListener("mousewheel",this.__mouseWheelHandler,!1),this.container.addEventListener("mousewheel",this.__mouseWheelHandler,!1),this.__eventsAttached=!0),e&&(this.options.content=e,this.empty(),this.container.appendChild(this.options.content)),this.overlay.parentNode||document.body.appendChild(this.overlay),this.container.parentNode||document.body.appendChild(this.container),this.resizeTo(t||this.options);try{this.container.focus()}catch(e){}this.options.onCreate&&this.options.onCreate(),this._show(),setTimeout((function(){n.options.onOpen&&n.options.onOpen()}),333)},t.close=function(e){var t=this;document.body.removeEventListener("keydown",this.__keyDownHandler),
				this.overlay.removeEventListener("click",this.__overlayClickHandler),this._hide(),this.overlay.removeEventListener("mousewheel",this.__mouseWheelHandler),this.container.removeEventListener("mousewheel",this.__mouseWheelHandler),this.__eventsAttached=!1,setTimeout((function(){t.options.onClose&&t.options.onClose(),e&&e()}),333)},t.resizeTo=function(e){e&&(this.options.width=e.width,this.options.height=e.height);var t=e.width||this.options.width,n=e.height||this.options.height;-1===t.indexOf("px")&&(t+="px"),-1===n.indexOf("px")&&(n+="px"),lt(this.container,{width:t,height:n})},e}()),Dt=function(){function e(e){void 0===e&&(e={}),this.popup=null,this.options=pt({},{width:350,height:420},e)}var t=e.prototype;return t.open=function(e){try{this.popup.location.href=e}catch(t){this.popup=window.open(e,"OxygenPopup","width="+this.options.width+",height="+this.options.height),this.popup&&this.popup.addEventListener("load",this.options.onLoadComplete||function(){},!1)}},t.close=function(){this.popup.close(),this.popup=null},t.resizeTo=function(e){try{popup&&popup.resizeTo(e.width,e.height)}catch(e){}},e}(),Ut=function(){function e(){}var t=e.prototype;return t.open=function(e){window.top.location.href=e},t.close=function(){},t.resizeTo=function(){},e}(),Ht={base:{overlay:{backgroundColor:"#000"},container:{backgroundColor:"#fff"},close_button:{backgroundPosition:"50% 50%",backgroundRepeat:"no-repeat",backgroundImage:'url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiI+PHBhdGggc3Ryb2tlPSIjNDQ1IiBzdHJva2Utd2lkdGg9IjIiIGQ9Ik0yIDJsMTIgMTJNMiAxNEwxNCAyIi8+PC9zdmc+")',width:"16px",height:"16px",position:"absolute",top:"0",right:"0",cursor:"pointer"}},legacy:{extend:"base",overlay:{opacity:.42},container:{boxShadow:"0 2px 8px rgba(0,0,0,0.5)",padding:"10px"},close_button:{backgroundImage:'url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiI+PHBhdGggc3Ryb2tlPSIjY2NjIiBzdHJva2Utd2lkdGg9IjIiIGQ9Ik0zLjUgMy41bDkgOW0tOSAwbDktOSIvPjwvc3ZnPg==")',backgroundColor:"#3e3e3e",top:"-8px",right:"-8px",border:"2px solid #ccc",borderRadius:"50%",boxShadow:"0 1px 3px rgba(0,0,0,0.82)"}},hig:{extend:"base",overlay:{opacity:.4},container:{boxShadow:"0 0 8px rgba(0,0,0,0.4)",padding:"20px 10px 10px",borderRadius:"4px",border:"3px solid #fff"},close_button:{top:"2px",right:"2px"}},akn:{extend:"base",overlay:{opacity:.6},container:{boxShadow:"inset 0 26px #f3f3f3",padding:"26px 10px 10px",border:"2px solid #888"},close_button:{top:"4px",right:"4px",backgroundColor:"#fff",backgroundSize:"75%",border:"1px solid #ccc"}}},Mt=null,zt={viewmode:"iframe",viewmode_options:{width:"350px",height:"420px",theme:"hig",hideOnOverlayClick:!1},environment:"production",providers:{production:"https://accounts.autodesk.com",staging:"https://accounts-staging.autodesk.com",dev:"https://accounts-dev.autodesk.com"},openid_response:"",refresh_response:"",ax_params:{required:["namePerson","autodesk/userid"],if_available:["autodesk/media/image/50"]}},qt={},Gt=function e(t){return t.extend?pt({},e(Ht[t.extend]),t):t},Wt=function(e,t,n){return{mode:n,viewmode:e.viewmode,openid_response:e.openid_response,refresh_response:e.refresh_response,ax_params:e.ax_params,endpoint:e.providers[e.environment]+t}};window.addEventListener("message",(function(e){if(/(\.autodesk\.com)$/.test(e.origin)){var t=/^iframe\-resize::(\d+),(\d+)/;if("string"==typeof e.data&&t.test(e.data)){var n=e.data.match(t)||[],o=n[1],r=n[2];(o||r)&&Ft.resizeTo({width:o,height:r})}}}),!1);var Bt=function(e){return Lt({src:e,onload:function(e){var t=this;setTimeout((function(){var n;(n=e.target||t).parentNode&&n.parentNode.removeChild(n)}),3e3)},styles:{display:"none"}})},Ft={show:function(e,t,n){t&&t!==zt.viewmode&&(Mt=null,zt.viewmode=t);var o,r,i=e&&-1!==e.indexOf(".")?e:Ct(Wt(zt,"/SignIn",e||"checkid_setup"));Mt||(Mt=function(e,t){switch(e){case"popup":return new Dt(t);case"redirect":return new Ut(t);case"iframe":default:return new Nt(t)}}(zt.viewmode,(r=function(e){switch(typeof e){case"string":
				return Ht[e];case"function":return e.call(null,Ht);default:return e}}((o=zt.viewmode_options).theme),Object.assign({},o,{styles:Gt(r)})))),zt.viewmode_options.onLoadStart&&zt.viewmode_options.onLoadStart(),Mt.open(i,n)},hide:function(){Mt&&Mt.close()},resizeTo:function(e){Mt&&Mt.resizeTo(e)},getOptions:function(){return zt},setOptions:function(e){return Mt&&e.hasOwnProperty("viewmode")&&e.viewmode!==zt.viewmode&&(Mt.close(),Mt=null),pt(zt,e),Ft},checkImmediate:function(e){var t=e||Ct(Wt(zt,"/SignIn","checkid_immediate")),n=Bt(t);document.body.appendChild(n)},showSignIn:function(e,t,n){Ft.show(e,t,n)},signOut:function(e,t){var n=zt.providers[t||zt.environment]+"/Authentication/LogOut";e&&(n+="?ReturnToUrl="+encodeURIComponent(ut(e)));var o=Bt(n);document.body.appendChild(o)},verifyAssertion:function(e,t){var n=dt(e);if(!n.params["openid.return_to"])return!1;var o=dt(t),r=dt(n.params["openid.return_to"]);if(o.endpoint!==r.endpoint)return!1;if(Object.entries(r.params).some((function(e){var t=e[0],n=e[1];return o.params[t]!==n})))return!1;var i=n.params["openid.response_nonce"];if(!i)return!1;if(qt.hasOwnProperty(i))return!1;qt[i]=!0;var s=n.params["openid.sig"],a=(n.params["openid.signed"]||"").split(",");return!(!s||!a.length||a.some((function(e){return!n.params.hasOwnProperty("openid."+e)})))},processOpenIDResponse:function(e){if("string"==typeof e){var t=(n=dt(e).params,o=Object.entries(n).reduce((function(e,t){var n=t[0],o=t[1],r=(0===n.indexOf("openid.")?n.split("."):[null,n]).slice(1),i=r.length-1;return r.reduce((function(e,t,n){return n<i?"string"==typeof e[t]?e[t]={_value:e[t]}:e[t]=e[t]||{}:e[t]=o,e[t]}),e),e}),{}),i=(r=o.ns&&Object.entries(o.ns).reduce((function(e,t){var n=t[0];return"http://openid.net/srv/ax/1.0"===t[1]?n:e}),"")||"")&&Object.entries(o[r].type).map((function(e){var t=e[0];return[e[1].replace("http://axschema.org/",""),o[r].value[t]]})).reduce((function(e,t){var n=t[0],o=t[1];return e[n]=o,e}),{})||{},{params:o,axData:i});zt.onOpenIDResponse&&zt.onOpenIDResponse(t.params,t.axData,e)}else zt.onOpenIDResponse&&zt.onOpenIDResponse(e);var n,o,r,i;Mt&&Mt.close()},processOpenIDRefreshResponse:function(e){var t="string"==typeof e?dt(e).params:e;t.page?Ft.show(t.page,void 0,{width:t.width,height:t.height}):Ft.resizeTo({width:t.width,height:t.height})},toString:function(){return"Oxygen"}};return window.Oxygen=window.Oxygen||Ft,bt}));

		;(function() {
			var meMenuConfig, messageConfig, notificationConfig, languageSelectorConfig, config;

			function renderUniversalHeader(accessToken) {

				var logoutUrl = '${webUi.getUserLogoutPageUrl("/")?js_string}';
				var loginUrl = '${webUi.getUserLoginPageUrl(http.request.url)?js_string}';
				meMenuConfig = {
					onSignIn: function () {
						window.location.href = loginUrl;
						return;
					},
					onSignOut: function () {
						window.location.href = logoutUrl;
						return;
					},
					<#if user.anonymous>
					tokenLoading: false
					<#else>
					tokenLoading: true
					</#if>
				};

				messageConfig = {
					url: '/t5/notes/privatenotespage',
					unread: ${messages_unread},
					count: ${messages_count}
				};

				notificationConfig = {
					url: '/t5/notificationfeed/page',
					unread: ${notification_unread},
					count: ${notification_count}
				};

				function insertParam(key, value, search) {
					key = encodeURIComponent(key);
					value = encodeURIComponent(value);

					var kvp = search.substr(1).split('&');
					var i = 0;

					for(; i<kvp.length; i++){
						if (kvp[i].indexOf(key + '=') === 0) {
							var pair = kvp[i].split('=');
							pair[1] = value;
							kvp[i] = pair.join('=');
							break;
						}
					}

					if(i >= kvp.length){
						kvp[kvp.length] = [key,value].join('=');
					}

					var params = kvp.join('&');
					if(params.indexOf('&') === 0) {
						params = params.substr(1);
					}

					return '?' + params;
				}

				languageSelectorConfig = {
					defaultUrl: document.location.pathname + insertParam('profile.language', 'en', document.location.search),
					<#if country?has_content>
					country: '${country?js_string}',
					</#if>
					localeUrlMapping: [
						{locale: 'en-US', url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: 'de-DE', url: document.location.pathname + insertParam('profile.language', 'de', document.location.search)},
						{locale: 'ja-JP', url: document.location.pathname + insertParam('profile.language', 'ja', document.location.search)},
						{locale: "en-GB", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: 'fr-FR', url: document.location.pathname + insertParam('profile.language', 'fr', document.location.search)},
						{locale: "en-CA", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "fr-CA", url: document.location.pathname + insertParam('profile.language', 'fr', document.location.search)},
						{locale: "en-AU", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "en-NZ", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "de-CH", url: document.location.pathname + insertParam('profile.language', 'de', document.location.search)},
						{locale: "de-AT", url: document.location.pathname + insertParam('profile.language', 'de', document.location.search)},
						{locale: "fr-CH", url: document.location.pathname + insertParam('profile.language', 'fr', document.location.search)},
						{locale: "fr-BE", url: document.location.pathname + insertParam('profile.language', 'fr', document.location.search)},
						{locale: 'zh-CN', url: document.location.pathname + insertParam('profile.language', 'zh-CN', document.location.search)},
						{locale: "en-HK", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "zh-TW", url: document.location.pathname + insertParam('profile.language', 'zh-CN', document.location.search)},
						{locale: "en-NL", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: 'pt-BR', url: document.location.pathname + insertParam('profile.language', 'pt-br', document.location.search)},
						{locale: 'es-ES', url: document.location.pathname + insertParam('profile.language', 'es', document.location.search)},
						{locale: 'ru-RU', url: document.location.pathname + insertParam('profile.language', 'ru', document.location.search)},
						{locale: "en-AE", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: 'tr-TR', url: document.location.pathname + insertParam('profile.language', 'tr', document.location.search)},
						{locale: "en-IN", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "en-SG", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "en-MY", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "es-MX", url: document.location.pathname + insertParam('profile.language', 'es', document.location.search)},
						{locale: "es-AR", url: document.location.pathname + insertParam('profile.language', 'es', document.location.search)},
						{locale: "en-ZA", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)},
						{locale: "pt-PT", url: document.location.pathname + insertParam('profile.language', 'pt-br', document.location.search)},
						{locale: "en-TH", url: document.location.pathname + insertParam('profile.language', 'en', document.location.search)}
					]
				};

				var components = {
					meMenu: meMenuConfig,
					message: messageConfig,
					languageSelector: languageSelectorConfig,
					notification: notificationConfig
				};

				var sessionChecked = false;
				var eventListener = function (response) {
					if (response) {
						if (response.event === "USER_INFO_FETCH_FAILED") {
							console.debug("Event received: ", response);
						}

						if (response.type === "error") {
							for (var i = 0; i < response.message.length; i++) {
								console.error("Event received: ", response.message[i]);
							}
						}

						if(response.event === 'ME_MENU_MOUNT' && !sessionChecked) {
							sessionChecked = true;
							checkSession();
						}

					}
				};

				var environment = '${(config.getString("phase", "") == "prod")?string("prd", "stg")}';
				config = {
					property: 'forums',
					propertyPageWidth: '1280px',
					language: '${lang?js_string}',
					environment: environment,
					components: components,
					eventListener: eventListener
				};
				if (accessToken) {
					config.accessToken = accessToken;
				}

				if (window.adsk && window.adsk.components && window.adsk.components.universalHeader) {
					window.adsk.components.universalHeader.render('forums-uh-container', config);
				}
			}

			/**
			 Polyfill for CustomEvent for IE
			 **/
			(function () {
				if ( typeof window.CustomEvent === "function" ) return false;

				function CustomEvent ( event, params ) {
					params = params || { bubbles: false, cancelable: false, detail: null };
					var evt = document.createEvent( 'CustomEvent' );
					evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
					return evt;
				}

				window.CustomEvent = CustomEvent;
			})();

			function reRenderMeMenu(accessToken) {
				meMenuConfig.tokenLoading = false;
				if (accessToken) {
					config.accessToken = accessToken;
					window.adsk.components.universalHeader.reRender(config);
				} else {
					delete config.accessToken;
					window.adsk.components.universalHeader.reRender(config);
				}

				/*
				var customEvent = null;
				if (accessToken) {
					customEvent = new CustomEvent('SSO_SIGNED_IN', { "detail": { "at": accessToken } });
				} else {
					customEvent = new CustomEvent('SSO_SIGNED_OUT');
				}
				window.dispatchEvent(customEvent);
				*/
			}

			function checkSession() {
				var loggedIntoForum = ${user.anonymous?string("false", "true")};
				var logoutUrl = '${webUi.getUserLogoutPageUrl(http.request.url)?js_string}';
				var bounceUrl = '/plugins/common/feature/oauth2sso_v2/sso_login_redirect?referer=${http.request.url?url}';
				var forumSsoId = '${sso_id?js_string}';

				var DHXOxygenEnvironment = '${(config.getString("phase", "") == "prod")?string("production", "staging")}';
				DHXOxygen.setOptions({
					oauth2: true,
					environment: DHXOxygenEnvironment, /* 'production', 'staging', 'dev' */
					onOpenIDResponse: function(params) {
						if (params.loginNeeded == "true") {
							
							if (loggedIntoForum) {
								window.location.href = logoutUrl;
								return;
							}
							
							reRenderMeMenu();
							return;
						} else {
							DHXOxygen.getUserData().then(function (result) {
								if (result.CONSUMER_RESPONSE_DATA && result.CONSUMER_RESPONSE_DATA.userid) {
									if (!loggedIntoForum) {
										window.location.href = bounceUrl;
										return;
									} else if(result.CONSUMER_RESPONSE_DATA.userid !== forumSsoId) {
										window.location.href = logoutUrl;
										return;
									}

									if(result.jwt_token) {
			console.log(result.jwt_token)							
reRenderMeMenu(result.jwt_token);
										return;
									} else {
										reRenderMeMenu();
										return;
									}

								} else {
									if (loggedIntoForum) {
										window.location.href = logoutUrl;
										return;
									} else {
										reRenderMeMenu();
										return;
									}
								}
							}).catch(function(e) {
								reRenderMeMenu();
								return;
							});
						}
					}
				});


				var oxygenOpenidResponseUrl = 'https://${http.request.serverName?js_string}/html/assets/oxygen_openid_response_2020.html';
				DHXOxygen.checkImmediate(oxygenOpenidResponseUrl);
			}


			function main() {
				renderUniversalHeader('');
			}

			main();


		})();
	</script>
</#if>