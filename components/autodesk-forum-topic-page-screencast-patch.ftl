<#assign screencastBaseURL ="" />
<#if config.getString("phase", "prod") == "stage">
  <#assign screencastBaseURL = "integration-screencast.autodesk.com" />
<#else>
  <#assign screencastBaseURL = "screencast.autodesk.com" />
</#if>

<@liaAddScript>
	;(function($){
	"use strict";
       
		if($('.lia-message-body-content p').hasClass('screencast_id')) {
			
			var str = $('.screencast_id').text();

			var arr = str.split(',');
			var id_str = arr[0];
			var width_str = parseInt(arr[1]);
			var height_str = parseInt(arr[2]);
			var ratio = height_str/width_str*100;
			
			var new_str = '<div class="iframe-container" style="position: relative; height: 0; margin: 0; padding-bottom: '+ratio+'%;">'+'<iframe width='+arr[1]+' height='+arr[2]+' style="position: absolute; left: 0; top: 0; width: 100%; height: 100%;" src= "https://'+screencastBaseURL+'/Embed/Timeline/'+arr[0]+'" frameborder="0" allowfullscreen="true" webkitallowfullscreen="true" scrolling="no"></iframe></div>';

			$('.lia-message-body-content .iframe-container').replaceWith(new_str);
		}

	})(LITHIUM.jQuery);
</@liaAddScript>