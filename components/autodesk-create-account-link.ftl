<#-- The Create account appears only if user is not logged in -->

<#if user.anonymous >
<div class="custom-component-users-create-account-link">
       <div class="lia-user-navigation-create-account">
   <div class="user-navigation-create-account">
       <a class="registration-link" href='${webUi.getUserRegistrationPageUrl("/")}'>${text.format('general.register')}</a>
   </div>
 </div>
</div>
</#if>