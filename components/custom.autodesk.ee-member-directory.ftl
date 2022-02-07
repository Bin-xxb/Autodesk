<#assign isAllowed = false />

<#if !user.anonymous>
    <#assign allowed_roles = ["EE Admin View-only", "EE moderator", "EE moderator int'l", "Expert Elite", "Expert Elite Admin", "Expert Elite Alumni", "Expert Elite Highlight", "Administrator", "Moderator"] />
    <#assign roles = restadmin('users/id/${user.id?c}/roles').roles.role />
    <#list roles as role>
        <#if allowed_roles?seq_contains(role.name)>
            <#assign isAllowed = true />
            <#break>
        </#if>
    </#list>
</#if>

<#if user.anonymous>

<div class="InfoMessage lia-panel-feedback-inline-alert">
    <div role="alert" class="lia-text">    
        <p>${text.format("page.UserLoginPage.description@reason:notregistered")}</p>
    </div>        
</div>

<#elseif !isAllowed>

<div class="InfoMessage lia-panel-feedback-inline-alert">
    <div role="alert" class="lia-text">    
        <p>${text.format("error.UserBannedException.title")}</p>
    </div>        
</div>

<#else>

<a href="/t5/expert-elite-hub/ct-p/1974"><i class="lia-fa lia-fa-angle-left"></i> ${text.format("custom.back-to-expert-elite-lounge")}</a>
<script type="text/javascript" src="https://expertelite.autodesk.com/libraries/iframe-resizer/js/iframeResizer.min.js"></script>
<iframe frameborder="0" id="ee-member-directory-iframe" src="https://expertelite.autodesk.com/ee-member-directory?no_sso" style="width: 100%; height:3500px; border: 0;"></iframe><script type="text/javascript">iFrameResize({}, '#ee-member-directory-iframe');</script>
<a href="/t5/expert-elite-hub/ct-p/1974"><i class="lia-fa lia-fa-angle-left"></i> ${text.format("custom.back-to-expert-elite-lounge")}</a>


    
</#if>


