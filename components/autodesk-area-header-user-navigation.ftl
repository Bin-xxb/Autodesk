<#attempt>
	<#assign avatar_url = restadmin("/users/id/${user.id}/profiles/avatar").image.url />
<#recover>
	<#assign avatar_url = "/html/assets/default-avatar-area.png" />
</#attempt>

<div class="header-login-container">
	<#if user.anonymous>
				<div class='area-header-signin'>
					<a class='lia-link-navigation login-link lia-authentication-link lia-component-users-action-login' href="#">SIGN IN</a>	
				</div>
				<div class='area-header-create-account'>
					<a class='lia-link-navigation registration-link lia-component-users-action-registration' href="#">CREATE ACCOUNT</a>
				</div>
	<#else>
		<div class="custom-user-menu">
			<div class="custom-dropdown">
				<div class="overlay-container">
                  	
						<a class="lia-link-navigation view-profile-link lia-component-users-action-view-user-profile" id="${user.id}" href="${user.webUi.url}">
							${user.login}
						</a>
					
					<img src="${avatar_url}" class="avatar-image img-responsive img-thumbnail" />
					
				</div>
			</div>
			<div id="head-row-1">
				<ul class="lia-list-standard-inline UserNavigation lia-component-common-widget-user-navigation">
					<li class="item loggedIn userProfile">
						<a class="lia-link-navigation view-profile-link lia-component-users-action-view-user-profile" id="${user.id}" href="${user.webUi.url}">
							${user.login}
						</a>
					</li>
					<li class="item loggedIn editAccount">
						<@component id="autodesk-edit-account-link" />
					</li>
					<li class="item loggedIn preferences">
						<a href="/t5/user/myprofilepage/tab/personal-profile">${text.format("autodesk-header-preferences")}</a>				
					</li>
					<li class="item privateMsg noBorder loggedIn">
						<a href="/t5/notes/privatenotespage" target="_blank">${text.format("area-header-forum-inbox")}</a>
					</li>
					<li class="item loggedIn logout">
						<@component id="users.action.logout" />
						<!-- LIT-1077:  remove sign out 2 link
						<a href="${webUi.getUserLogoutPageUrl('/')}">Sign Out 2</a> -->
					</li>
					<#if coreNode.permissions.hasPermission("allow_switch_users")>
						<li class="item loggedIn logout switchUser">
							<@component id="admin.action.switch-user" />
						</li>
					</#if>
					<li class="item noBorder autodeskhelp">
						<a href="/t5/help/faqpage">${text.format("autodesk-header-help")}</a>
					</li>
				</ul>
			</div>
		</div>
	</#if>
</div>

<@liaAddScript>
;(function($) {
	$("header .login-wrapper a.login-link").text("login ").append("<i class='fa fa-sign-in'></i>").css("display","inline-block");
	
	$(".custom-user-menu .custom-dropdown").click(function(){
		$(".custom-user-menu").toggleClass("open");
	});
	$(document).keyup(function(e) {
		if (e.keyCode == 27) { // escape key maps to keycode `27`
			$(".custom-user-menu").removeClass("open");
		}
	});
	$(document).click(function(){
		$(".custom-user-menu").removeClass("open");
	});
	$(".header-login-container").click(function(e){
		e.stopPropagation();
	});
  
  	$('#search').on("click",function(){
		$('.search-bar').css('display', 'block');
	});
  	$('.view-profile-link.lia-component-users-action-view-user-profile').on("click",function(){
		$('.UserNavigation').css('display', 'none');
	});
})(LITHIUM.jQuery);
</@liaAddScript>

<style>
.header-login-container{
	margin-top: -5px;
}
.header-login-container .avatar-image{
    background: transparent;
    border-radius: 55px;
	border: 0;
	width: 60px;
    height: 60px;
    object-fit: contain;
    background-color: #ccc;
}
.header-login-container .overlay-container{
	cursor:pointer;
  	width:170px;
  	text-align: right;
}
.header-login-container .login-link{
	color: #1a81c2;
	padding: 5px 10px;
	font-family: FrutigerNextW04-Regular;
    font-size: 14px;
    line-height: 1.5;
	text-decoration:none;
    border-radius: 3px;
	background-color: #fff;
    display: none;
	margin-top: 15px;
    margin-bottom: 0;
    font-weight: normal;
    text-align: center;
    vertical-align: middle;
    touch-action: manipulation;
    cursor: pointer;
    background-image: none;
    border: 1px solid #ccc;
	text-transform:uppercase;
    white-space: nowrap;
}
.header-login-container .login-link:hover{
	color: #333;
    background-color: #e6e6e6;
    border-color: #adadad;
	text-decoration: underline;
}
.header-login-container .custom-user-menu.open>#head-row-1{
    display: block;
	height:0;
}
.UserNavigation.lia-component-common-widget-user-navigation{
    position: absolute;
    top: 100%;
    left: 0;
    z-index: 1000;
    float: left;
    min-width: 130px;
    padding: 5px 0;
    margin: 2px 120px 0;
    list-style: none;
    font-size: 16px;
    text-align: left;
    background-color: #fff;
    border: 1px solid #ccc;
    border: 1px solid rgba(0,0,0,0.15);
    border-radius: 2px;
    -webkit-box-shadow: 0 6px 12px rgba(0,0,0,0.175);
    box-shadow: 0 6px 12px rgba(0,0,0,0.175);
    background-clip: padding-box;
}
.header-login-container .login-wrapper li{
    list-style: none;
}
.custom-user-menu .UserNavigation>li>a {
    display: block;
    padding: 3px 20px;
    clear: both;
	font-family: frutigernextlt_medium;
  	font-size: 12.19px;
    font-weight: normal;
    line-height: 1.42857;
    color: #444444;
    white-space: nowrap;
}
.custom-user-menu li>a:hover, .custom-user-menu li>a:focus {
    text-decoration: none;
    color: #0096D4;
    background-color: transparent;
}
ul.UserNavigation{
	padding-left:0;
}
</style>
