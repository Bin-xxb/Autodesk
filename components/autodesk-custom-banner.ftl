<#assign bannerImage = settings.name.get("layout.hero.banner.image", "/html/assets/brand-reimagined-background.jpg") />

<div class="custom-banner ${page.interactionStyle}" style="background-image: url(${bannerImage});">
    <div class="content">
        <div class="title">
            <#if coreNode.title?has_content>
                ${coreNode.title}
            </#if>
        </div>
        <div class="description">
            ${coreNode.description}
        </div>
    </div>
</div>