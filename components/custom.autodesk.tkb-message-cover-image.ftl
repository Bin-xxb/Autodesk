<#if page.name != "PostPage" && page.name != "ReplyPage">
	<#if env?? && env.context?? && env.context.message??>
		<#assign imageDimensions = "600x600" />
		<#assign threadId = env.context.message.uniqueId />
		<#assign query = "SELECT teaser, body, cover_image.id FROM messages WHERE id = '${threadId}'"/>
		<#assign message = restadmin("2.0","/search?q=" + query?url).data.items![] />

		<#assign photo = "" />
		<#assign photoIsIframe = false />
		<#if message[0].cover_image?? && message[0].cover_image?has_content>
			<#assign imageDimensions = "600x600" />
			<#assign coverImageId = message[0].cover_image.id />
			<#assign photo = "/t5/image/serverpage/image-id/" + coverImageId + "/image-dimensions/" + imageDimensions />
		</#if>

		<#if !photo?has_content >
			<#if message[0].teaser?? && message[0].teaser?has_content>
				<#assign pictureID = message[0].teaser?keep_after('/t5/image/serverpage/image-id/')?keep_before('/') />
				<#if pictureID?has_content >
					<#assign photo = "/t5/image/serverpage/image-id/" + pictureID + "/image-dimensions/" + imageDimensions />
				<#elseif message[0].teaser?contains('<iframe') || message[0].teaser?contains('<IFRAME')>
					<#assign photo = message[0].teaser?replace("&nbsp;","","rm")?replace("\\s{1,}","","rm")?replace("\n+", "","rm")?replace('.*iframe ',"","ri")?replace('.*src=\\"',"","ri")?replace('\\".*',"","ri")?trim />

					<#assign photoIsIframe = true />
				</#if>
			</#if>
		</#if>


		<#if !photo?has_content >
			<#if message[0].body?? && message[0].body?has_content>
				<#assign pictureID = message[0].body?keep_after('/t5/image/serverpage/image-id/')?keep_before('/') />
				<#if pictureID?has_content >
					<#assign photo = "/t5/image/serverpage/image-id/" + pictureID + "/image-dimensions/" + imageDimensions />
				</#if>
			</#if>
		</#if>

		<#if photoIsIframe>
			<div class="cover-image" ><iframe src="${photo}" frameborder="no" scrolling="no"></iframe></div>
		<#else>
            <#if photo != ''>
                <div class="cover-image" style="background-image: url(${photo});"></div>
            <#else>
                <div class="cover-image" style="background-image: url('/html/assets/blog-messagelist-default.png'); background-position: left bottom;"></div>
            </#if>
        </#if>
	</#if>
</#if>