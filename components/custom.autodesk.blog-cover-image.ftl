<#assign messageQuery = "/search?q=" +
    "SELECT cover_image.id, cover_image.title FROM messages WHERE id = '${page.context.message.uniqueId}'"?url />
<#assign coverImageItems = rest("2.0", messageQuery).data.items![] />

<#if coverImageItems[0].cover_image?? && coverImageItems[0].cover_image?has_content>
    <#assign imageDimensions = "1200x408" /> 
    <#assign coverImageId = coverImageItems[0].cover_image.id />
    <#assign coverImageTitle = coverImageItems[0].cover_image.title />
    <#assign photo = "/t5/image/serverpage/image-id/" + coverImageId + "/image-dimensions/" + imageDimensions />
    <div class="cover-image">
        <img src="${photo}" alt="${coverImageTitle}">
    </div>
</#if>