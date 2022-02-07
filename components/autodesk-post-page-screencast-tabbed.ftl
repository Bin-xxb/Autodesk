<#if coreNode.ancestors?size gt 1>
    <#assign interaction_style=page.interactionStyle/>
<#else>
    <#assign interaction_style=http.request.parameters.name.get("interaction_style","") />
</#if>


<#if interaction_style != "blog" && interaction_style != "qna" && interaction_style != "contest">

    <#assign
screencastTabs = [
		{
		"id"     : "pasteurl",
		"title"    : "${text.format('autodesk-screencast-tab-label.pasteurl')}",
		"pageLabel": "pasteurl-page"
		},
		{
		"id"     : "myscreencasts",
		"title"    : "${text.format('autodesk-screencast-tab-label.myscreencasts')}"
		}
	]
/>

<#assign iframeWidth = 640 />
<#assign iframeHeight = 400 />
<#assign SsoId = "" />
<#attempt>
<#assign UserDetails = restadmin("/users/id/${user.id}/sso_id") />
<#assign SsoId = UserDetails.value />
<#recover>
<#assign SsoId = "INVALID" />
</#attempt>
<#assign phase=config.getString("phase", "prod")/>
<#assign corenode_id=coreNode.id/>
<#if config.getString("phase", "prod") == "stage">
<#assign screencastBaseURL = "integration-screencast.autodesk.com" />
<#assign screencastBaseURLnew = "knowledge-staging.autodesk.com" />
<#-- Duplicate code added to preserve the condition for future
<#assign screencastBaseURL = "screencast.autodesk.com" />
<#assign screencastBaseURLnew = "knowledge.autodesk.com" />
 -->
<#else>
<#assign screencastBaseURL = "screencast.autodesk.com" />
<#assign screencastBaseURLnew = "knowledge.autodesk.com" />
</#if>

<#if (coreNode.ancestors?size > 0) >
	<#assign ancestors = coreNode.ancestors[0].title />
<#else>
	<#assign ancestors = coreNode.title />
</#if>


	
<div class="lia-component-custom-screencast-tab-panels">
<fieldset>
<legend>${text.format('autodesk-insert-screencast.title')}
<span class="helptexticon fa fa-question-circle" title="${text.format('autodesk-post-page-screencast-tabbed-label.screencast-tooltip')}"></span>
</legend>
<ul class="lia-component-custom-tabs clearfix lia-screencast-tabs">
	<#list screencastTabs as tab>
	<li class="tab-${tab.id} <#if tab_index == 0>active</#if>"><span tab-des="lia-component-custom-screencast-wrapper-${tab.id}">${tab.title}</span></li>
	</#list>
</ul>
<div class="lia-component-custom-screencast-wrapper-container">
	<#list screencastTabs as tab>
	<#if tab.id == "pasteurl">
		<div class="lia-component-custom-screencast-wrapper lia-component-custom-screencast-wrapper-pasteurl">
		<div class="inserted-screencast_pasteurl" style="display: none">The following Screencast will be inserted in your post. <span class="change-screencast-pasteurl">Change Screencast?</span></div>
		<div class="screencast-input-controls" >
			<input id="pasteurl-input" type="text" name="fname"><div id="screencast-preview-button">${text.format('autodesk-screencast-preview.title')}</div>
			<div id="insert-button" >Insert</div>
			<a href="https://knowledge.autodesk.com/community/screencast" target="_blank">${text.format('autodesk-what-is-screencast')}</a>
		</div>
		
		<div class="iframe-preview">
			<table>
			<tbody>
				<tr>
				<td class="iframe-content">
					<div class="iframe-container" style="position: relative; height: 0; margin: 0;"></div>
				</td>
				<td class="insert-screencast">
					<div>${text.format('autodesk-screencast-insert.title')}</div>
				</td>
				</tr>
			</tbody>
			</table>
		</div>
		<div class="pasteurl-error-text">
			
		</div>
		</div>

		<div class="screencast-loading-div" style="display:none;">
		<center>
			<img src='${skin.images.feedback_loading.url}' title='${skin.images.feedback_loading.title}' alt='${skin.images.feedback_loading.alt}'/>
		</center>
		</div>
	<#else>
		<div class="lia-component-custom-screencast-wrapper lia-component-custom-screencast-wrapper-${tab.id}">         
		</div>
	</#if>
	</#list>

</div>
</fieldset>
</div>



<@liaAddScript>
var domStr='<div class="lia-panel lia-panel-standard lia-screencast-guidelines">\
	<div class="lia-decoration-border">\
		<div class="lia-decoration-border-top">\
		</div>\
		<div class="lia-decoration-border-content">\
			<div>\
				<div class="lia-panel-content-wrapper">\
					<div class="lia-panel-content">${text.format('autodesk-screencast-submission-guidelines')}</div></div>\								</div>\
</div>\
		<div class="lia-decoration-border-bottom">\
			<div> </div>\
		</div>\
	</div>\
</div>';
var inputString;
var iHeight = "${iframeHeight}";
var screencastBaseURL = "${screencastBaseURL}";
var screencastBaseURLnew = "${screencastBaseURLnew}" ;
var insertButtonTitle = "${text.format('autodesk-screencast-insert.title')}";
var ssoid = "${SsoId}";
var userId = "${user.id}";
var finalGUID = "";
var phase="${phase}";
var corenode_id="${corenode_id}";


;(function($){
"use strict";
var newScreencastId="";
var screencastTabs = {
	$ulElement   : $("#lia-body .lia-content .lia-component-custom-screencast-tab-panels .lia-component-custom-tabs"),
	$tabPanel    : $("#lia-body .lia-content .lia-component-custom-screencast-tab-panels .lia-component-custom-screencast-wrapper"),
	onPageLoad   : function(){
				$("#lia-body .lia-content .lia-component-custom-screencast-wrapper-pasteurl")
				.addClass("active"); 
				$('.pasteurl-error-text').append(domStr);				
			},
	tabClick   : function(){
				var that = this;
				that.$ulElement.on("click","span",function(){               
				var tab_des=$(this).attr('tab-des');    
				//console.log('tabClick event>>'+tab_des);
				$(".iframe-preview iframe-content").html("");                    
				$(this)
				.parent()
				.addClass("active")
				.siblings()
				.removeClass("active");

				var tabDes = $(this).attr("tab-des");

				that.$tabPanel.filter("." + tabDes)
				.addClass("active")
				.siblings()
				.removeClass("active");
				
				});
			}
};
$(function(){
	screencastTabs.onPageLoad();
	screencastTabs.tabClick();
});

$(document).ready(function(){
	//To inject component in editor component
	$(".lia-component-custom-screencast-tab-panels").insertAfter($(".lia-form-fieldset-wrapper.lia-form-post-fieldset-toggle"));
	$(".screencast-pasteurl-help").attr("title","${text.format('autodesk-screencast-pasteurl-help-modal')}");

	function editcall(iframetag){
	
	$(".screencast-loading-div").hide();
	$(".inserted-screencast_pasteurl").show();
	$(".pasteurl_label").hide();
	$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html(iframetag);
	
	}

	if( "${page.name}" == "EditPage"){
		$(".screencast-loading-div").show();
		var toMatch = new RegExp("(^((https|http)://("+screencastBaseURL+"|"+screencastBaseURLnew+")/){1})");
		
		var toBitlyMatch = new RegExp("(^((https|http)://autode.sk/){1})");
		var editorStr = $('.lia-form-tiny-mce-editor-input').val();
		var editorHtml = $.parseHTML( editorStr );
		var iframetag = $(editorHtml).find('iframe');
		var srceditor = $(iframetag).attr('src');

		if( toMatch.test(srceditor) ){
			
			var stringArr = srceditor.split("/");
			var GUID1 = stringArr[stringArr.length-1];
			GUID1 = GUID1.replace(".html","");
			if((/^[a-f0-9]{8}(?:-[a-f0-9]{4}){3}-[a-f0-9]{12}$/i).test(GUID1)){
			editcall(iframetag);
		}
		}
		else if( toBitlyMatch.test(srceditor) ){
			editcall(iframetag);
		}
		else{
		$(".screencast-loading-div").hide();
		$(".inserted-screencast_pasteurl").hide();
		$(".pasteurl_label").show();        
		}
	}
});
function showGuidelines(bflag){
		if(bflag){
			$('.pasteurl-error-text').html(domStr);
		}else{
			var domStr1 = '<span>Not a Screencast URL. Please insert a public Screencast.</span>';
			$('.pasteurl-error-text').html(domStr1).css("display","block");;
			$('.pasteurl-error-text').html(domStr).css("display","block");;
		}
	}
function validateGUID(str,GUIDstatus){
		var stringArray = str.split("/");
		var GUID = stringArray[stringArray.length-1];
		GUID = GUID.replace(".html","");
		
		if(GUIDstatus == true){
		if((/^[a-f0-9]{8}(?:-[a-f0-9]{4}){3}-[a-f0-9]{12}$/i).test(GUID)){
			$(".pasteurl-error-text").html();
			finalGUID = GUID;
			ajaxCall(GUID);
		}else{
			$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");
			$(".pasteurl-error-text").html("You can't insert private or unlisted Screencasts. Please insert a public Screencast").css("display","block");
			$(".screencast-loading-div").hide();
		}
		}else{
			finalGUID = GUID;
			ajaxCall(GUID);
		}
}
	
$('#insert-button').on('click',function(){
	$('.iframe-preview .insert-screencast div').trigger('click');
	});
	
	
$(".lia-component-custom-screencast-wrapper-pasteurl #screencast-preview-button").on("click",function(){

	var screencastUrl= $('#pasteurl-input').val();
	var tempindex1=screencastUrl.lastIndexOf('/');
	newScreencastId=screencastUrl.substring(tempindex1+1,screencastUrl.length);
	$(".pasteurl-error-text").css("display","none");
	$(".screencast-loading-div").show();
	$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");
	$(".iframe-preview .insert-screencast div").css("display","none");

	inputString = $(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val();
	iHeight = "${iframeHeight}";
	
	if(inputString != ""){
	var toMatch = new RegExp("(^((https|http)://("+screencastBaseURL+"|"+screencastBaseURLnew+")/){1})");
	var toBitlyMatch = new RegExp("(^((https|http)://autode.sk/){1})");
	var GUIDstatus = true;

	if(inputString.indexOf("iframe") != -1){
		var iframe_element = $.parseHTML( inputString );
		inputString = $(iframe_element).attr('src');
		
		if(inputString != "" && inputString != undefined){
		if(toMatch.test(inputString)){
			GUIDstatus = true;
			validateGUID(inputString,GUIDstatus);

			}
			else if(toBitlyMatch.test(inputString)){
			GUIDstatus = false;
			validateGUID(inputString,GUIDstatus);
			}
			else{
				$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");
				showGuidelines(false);
				$(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val("");
				$(".screencast-loading-div").hide();
			}
		}
		else{
		$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");
		
		showGuidelines(false);
		$(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val("");
		$(".screencast-loading-div").hide();
		}
	}else{
		var matchSingleOcc = new RegExp(screencastBaseURL+"|"+screencastBaseURLnew,"gi");
		if( ((inputString.match(matchSingleOcc) || []).length) == 1){								//to check for multiple occurrence of URL
			var error_msg=$('.pasteurl-error-text #errorMsg');
			if(error_msg!=undefined){
					$(error_msg).remove();
				}
			
				if(toMatch.test(inputString)){
					GUIDstatus = true;
					validateGUID(inputString,GUIDstatus);
				}else if(toBitlyMatch.test(inputString)){
					GUIDstatus = false;
					validateGUID(inputString,GUIDstatus);
				}
				else{
				$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");              
				showGuidelines(false);
				$(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val("");
				$(".screencast-loading-div").hide();
				}
		}
		else{
		$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");
		$(".pasteurl-error-text").html("<span>Not a Screencast URL. Please insert a public Screencast.</span>").css("display","block");
		$(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val("");
		$(".screencast-loading-div").hide();
		}
	}
	}
	else{
		$(".screencast-loading-div").hide();
		$(".pasteurl-error-text").css("display","block");
	
	}
});


function ajaxCall(GUID){
	$.ajax({
			method: "POST",
			url: "https://"+screencastBaseURL+"/Api/v1/Screencast/Timeline/Height/"+GUID,
			dataType: "json",
			success: function (jsonData, textStatus, jqXHR) {
				iHeight = parseInt(iHeight) + parseInt(jsonData);
				var iWidth = "${iframeWidth}";
				var ratio = iHeight.toFixed(6)/parseInt(iWidth).toFixed(6)*100;
				$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").css('padding-bottom', ratio+'%');
				
				$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html('<iframe width="640" height="'+ iHeight +'" style="position: absolute; left: 0; top: 0; width: 100%; height: 100%;" src= "https://'+screencastBaseURL+'/Embed/Timeline/' + GUID + '" frameborder="0" allowfullscreen="true" webkitallowfullscreen="true" scrolling="no"></iframe>');
				$(".iframe-preview .insert-screencast div").css("display","inline-block").addClass("lia-button lia-button-secondary");
				$(".screencast-loading-div").hide();
				$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container iframe").show();
				$(".lia-component-custom-screencast-wrapper-pasteurl #screencast-preview-button").css("display","none");
				$("#insert-button").css("display","inline-block");
				$(".pasteurl-error-text").css("display","block");
				showGuidelines(true);
			},
			error: function (jqXHR, textStatus, errorThrown) {
			$(".screencast-loading-div").hide();
			$(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val("");
			$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");
			if(jqXHR.getResponseHeader("X-Screencast-Api-Error") == "data_access_control_level_restricted"){
				$(".pasteurl-error-text").html("You can't insert private or unlisted Screencasts. Please insert a public Screencast.").css("display","block");
			}
			else if(jqXHR.getResponseHeader("X-Screencast-Api-Error") == "no_data_found"){
				$(".pasteurl-error-text").html("You can't insert private or unlisted Screencasts. Please insert a public Screencast.").css("display","block");
			}
			else{
				$(".pasteurl-error-text").html("You can't insert private or unlisted Screencasts. Please insert a public Screencast.").css("display","block");
			}
			$(".lia-component-custom-screencast-wrapper-pasteurl #screencast-preview-button").css("display","inline-block");
				$("#insert-button").css("display","none");
			}
		});
}


$(".iframe-preview .insert-screencast div").on("click",function(){
	
	var iframe_structure=$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content").html();  
	$(".mce-edit-area iframe").contents().find("#tinymce").append(iframe_structure);                                         

	$(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val("");
	$(".iframe-preview .insert-screencast div").css("display","none");
	$(".inserted-screencast_pasteurl").show();
	$(".pasteurl_label").hide();
	$(".lia-screencast-tabs").hide();
	$(".screencast-input-controls").hide();
 
});

$(".change-screencast-pasteurl").on("click",function(){

	$('#insert-button').hide();
	$('#screencast-preview-button').css("display","inline-block");  
	$('.pasteurl-error-text').css("display","block");
	$(".lia-component-custom-screencast-wrapper-pasteurl .iframe-preview .iframe-content .iframe-container").html("");
	$(".mce-edit-area iframe").contents().find("#tinymce").find('.iframe-container').remove();
	$(".lia-component-custom-screencast-wrapper-pasteurl input#pasteurl-input").val("");
	$(".screencast-loading-div").hide();
	$(".inserted-screencast_pasteurl").hide();
	$(".pasteurl_label").show();  
	$(".lia-screencast-tabs").show();
	$(".screencast-input-controls").show();

	showGuidelines(true);
	
});




$(".tab-myscreencasts").on("click",function(){
	
	if($(".lia-component-custom-screencast-wrapper-myscreencasts").children().length==0){
		$.ajax({
			type: "GET",
			url: "https://"+screencastBaseURL+"/Api/v1/User/Screencast/ShortMetadata/List/"+ssoid+"/Published/Public/640/400",
			data: {},
			dataType: "json",
			success: function (jsonData, textStatus, jqXHR) {
				var htmldata = "<div class='user-public-label' style='display: none'>${user.login}'s ${text.format('autodesk-screencast-field-label.myscreencast')} <span class='screencast-myscreencast-help fa fa-question-circle'></span></div><div class='inserted-screencast' style='display: none'>The following Screencast will be inserted in your post. <span class='change-screencast'>Change Screencast?</span></div><Select id='myscreencast-select' style='width: 100%'><option value=''>-- Select a Screencast --</option>";
				var selectOptions="";
				var iframeDivs = "<div class='iframe-preview'><table><tbody><tr><td class='iframe-content'>";
		
				function dateComp(prop){
					return function(a,b){
						if( new Date(a[prop]) > new Date(b[prop])){
							return 1;
						}else if( new Date(a[prop]) < new Date(b[prop])){
							return -1;
						}
						return 0;
					}
				}
				jsonData.sort( dateComp("PublishDate") ).reverse();

				for(var i=0;i<jsonData.length;i++){
					selectOptions += "<option value='"+jsonData[i].Id+"'>"+jsonData[i].Title+"</option>";
					var $iframeTmp = $(jsonData[i].HTML);
					$iframeTmp.attr('data-src', $iframeTmp.attr('src')).removeAttr('src');
					iframeDivs += "<div id='"+jsonData[i].Id+"' class='myscreencast-iframe iframe-container' style='display:none'>"+$iframeTmp.wrap('div').parent().html()+"</div>";
				}
				selectOptions +="</Select>";
				iframeDivs += "</td><td class='insert-myscreencast'><div style='display:none'>"+insertButtonTitle+"</div></td></tr></tbody></table></div><div class='myscreencast-error-text'></div>";
				htmldata += selectOptions;
				htmldata += iframeDivs;

				$(".lia-component-custom-screencast-wrapper-myscreencasts").html(htmldata);
				$(".myscreencast-error-text").hide();
				bindSelectMyscreencast();
			},
			error: function (jqXHR, textStatus, errorThrown) {
				var errorStr = jqXHR.getResponseHeader("X-Screencast-Api-Error");
				$(".lia-component-custom-screencast-wrapper-myscreencasts").html("<div class='myscreencast-error-text'></div>");
				console.log("errorStr "+errorStr);
				errorStr = errorStr.replace("<br>", "");
				var arr = errorStr.split('.');
				arr[0] = "<p class='screencast-error-para-2'>" + arr[0] + "</p>";
				var finalstr = arr.join(".");
				finalstr = finalstr.replace("</p>.",".</p>");
				$(".myscreencast-error-text").html(finalstr).show();
			},
			complete: function (jqXHR, textStatus, errorThrown) {
				$(".screencast-myscreencast-help").attr("title","${text.format('autodesk-screencast-myscreencast-help-modal')}");
			}
		});
	}
});

function bindSelectMyscreencast(){
	$('#myscreencast-select').on("change",function(){
		$('.myscreencast-iframe').hide().removeClass("active-myscreencast");

		if($(this).val() == '') {
			$('.iframe-preview .insert-myscreencast div').hide();
			$(".iframe-preview .iframe-content .iframe-container iframe").hide();
		} else {
			var $iframeContainer = $('#' + $(this).val());
			var $iframe = $iframeContainer.find('iframe');
			if(!$iframe.attr('src')) {
				$iframe.attr('src', $iframe.attr('data-src'));
			}
			$iframeContainer.show().addClass("active-myscreencast");
			$('.iframe-preview .insert-myscreencast div').show();
			$(".iframe-preview .iframe-content .iframe-container iframe").show();
		}
	});


	$(".iframe-preview .insert-myscreencast div").on("click",function(){
		var iframe_structure=$(".lia-component-custom-screencast-wrapper-myscreencasts .iframe-preview .iframe-content").html();
		$(".mce-edit-area iframe").contents().find("#tinymce").append(iframe_structure);

		$(".iframe-preview .insert-myscreencast div").css("display","none");
		$(".inserted-screencast").show();
		$(".lia-screencast-tabs").hide();
		$("#myscreencast-select").hide();
	});

	$(".change-screencast").on("click",function(){
		$(".mce-edit-area iframe").contents().find("#tinymce").find('.iframe-container').remove();
		$(".screencast-loading-div").hide();
		$(".inserted-screencast").hide();
		$(".lia-screencast-tabs").show();
		$("#myscreencast-select").show().val('');
		$('.myscreencast-iframe').hide().removeClass("active-myscreencast");
		
	});

}  


$(window).load(function() 
{ 
		
			
		var textInTinyMce=tinyMCE.activeEditor.getContent();
			var index1 = textInTinyMce.indexOf('<div class="iframe-container">');
			var str = textInTinyMce.substring(index1);
			var index2 = str.indexOf('</div>');
			var str_len = '</div>';
			var replace_str = textInTinyMce.substring(index1, index1+index2+str_len.length);

			var index3 = replace_str.indexOf('<p class="screencast_id">');
			var p_len = '<p class="screencast_id">';
			var index4 = replace_str.indexOf('</p>');
			var str_attr = replace_str.substring(index3+p_len.length, index4);
			var arr = str_attr.split(',');
			var str_id = arr[0];
			var str_width = parseInt(arr[1]);
			var str_height = parseInt(arr[2]);

		

			var str_ratio = str_height/str_width*100;

			if(index3 != -1 ){

				var new_str = '<div class="iframe-container" style="position: relative; height: 0; margin: 0; padding-bottom: '+str_ratio+'%;">'+'<iframe width='+arr[1]+' height='+arr[2]+' style="position: absolute; left: 0; top: 0; width: 100%; height: 100%;" src= "https://'+screencastBaseURL+'/Embed/Timeline/'+arr[0]+'" frameborder="0" allowfullscreen="true" webkitallowfullscreen="true" scrolling="no"></iframe></div>';
				var newTinyMceDOM=textInTinyMce.replace(replace_str,new_str);
				tinymce.activeEditor.setContent(newTinyMceDOM);

			}
		
});

$('#submitContext_1').on('click',function(){
			var textInTinyMce=tinyMCE.activeEditor.getContent();
			var index1=textInTinyMce.indexOf('<div class="iframe-container"');
			if(index1 == -1 ){
				var a=textInTinyMce.indexOf('class="myscreencast-iframe iframe-container');
				var b=textInTinyMce.substring(0,a);
				var index1=b.lastIndexOf('<div id=');
			}
			var index2=textInTinyMce.indexOf('</iframe></div>');
			var str_len='</iframe></div>';
			var replace_iframe=textInTinyMce.substring(index1,index2+str_len.length);
			var arr = replace_iframe.split('"');
			var width_str = arr[arr.indexOf(' width=')+1];
			var height_str = arr[arr.indexOf(' height=')+1];
			if(index1 != -1 ){
				var str = new String("Timeline/");
				var split_str=textInTinyMce.split("Timeline/");
				var temp=split_str[1].indexOf('"');
				var id_str=split_str[1].substring(0,temp);
				var placeholder = '<div class="iframe-container"><p class="screencast_id">'+id_str+','+width_str+','+height_str+'</p></div>'; 
				var  newTinyMceDOM=textInTinyMce.replace(replace_iframe,placeholder);
				tinymce.activeEditor.setContent(newTinyMceDOM);
			}
	});
})(LITHIUM.jQuery);
</@liaAddScript>

</#if> 