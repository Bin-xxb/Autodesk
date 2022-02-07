<#import "postRead.ftl" as view>

<#assign imageDimensions = "600x600" />
<#assign boardID = coreNode.id />  
<#assign curLabel = webuisupport.path.rawParameters.name.get("label-name","") />
<#if curLabel != "" >
	<#assign featuredQuery = "/search?q=" 
		+ "SELECT id, subject, view_href, board.id, board.view_href, teaser, body, cover_image.id FROM messages WHERE board.id = '${boardID}' AND depth = 0 AND conversation.featured = true AND labels.text = '${curLabel}' Order By post_time DESC LIMIT 3"?url />
<#else>
	<#assign featuredQuery = "/search?q=" 
	+ "SELECT id, subject, view_href, board.id, board.view_href, teaser, body, cover_image.id FROM messages WHERE board.id = '${boardID}' AND depth = 0 AND conversation.featured = true Order By post_time DESC LIMIT 3"?url />
</#if>
<#assign postsItems = rest("2.0", featuredQuery).data.items![] />

<#if postsItems?size gt 0>
<div class="custom-articles-featured">
	<div class="wrapper">
		<h2>${text.format('custom.featured-title')}</h2>
		<div class="boxes">
			<#list postsItems as postItem>
				<#assign post = {
					"subject": postItem.subject,
					"viewHref": postItem.view_href,
					"body": postItem.body,
					"teaser": postItem.teaser
				} />

				<#assign photo = "" />
				<#assign photoIsIframe = false />
				<#if postItem.cover_image?? && postItem.cover_image?has_content>
					<#assign coverImageId = postItem.cover_image.id />
					<#assign photo = "/t5/image/serverpage/image-id/" + coverImageId + "/image-dimensions/" + imageDimensions />
				</#if>
				<#if !photo?has_content >
					<#if post.teaser?? && post.teaser?has_content>
						<#assign pictureID = post.teaser?keep_after('/t5/image/serverpage/image-id/')?keep_before('/') />
						<#if pictureID?has_content >
							<#assign photo = "/t5/image/serverpage/image-id/" + pictureID + "/image-dimensions/" + imageDimensions />
						<#elseif post.teaser?contains('<iframe') || post.teaser?contains('<IFRAME')>
							<#assign photo = post.teaser?replace("&nbsp;","","rm")?replace("\\s{1,}","","rm")?replace("\n+", "","rm")?replace('.*iframe ',"","ri")?replace('.*src=\\"',"","ri")?replace('\\".*',"","ri")?trim />

							<#assign photoIsIframe = true />
						</#if>
					</#if>
				</#if>

				<#if !photo?has_content >
					<#if post.body?? && post.body?has_content>
						<#assign pictureID = post.body?keep_after('/t5/image/serverpage/image-id/')?keep_before('/') />
						<#if pictureID?has_content >
							<#assign photo = "/t5/image/serverpage/image-id/" + pictureID + "/image-dimensions/" + imageDimensions />
						</#if>
					</#if>
				</#if>

				<#assign body = postItem.body?replace("<BR />", " ")?trim />
				<#assign stripperOptions = utils.html.stripper.from.owasp.optionsBuilder.build() />
				<#assign body = utils.html.stripper.from.owasp.strip(body, stripperOptions)?replace("&nbsp;", " ")?trim />
				<#assign words = 0/>
				<#list body?split(' ') as word>
					<#assign words = words + 1/>
				</#list>
				

				<div class="box">
					<h3><a href="${post.viewHref}">${post.subject}</a></h3>
					<#if photoIsIframe>
					<div class="image">
						<iframe src="${photo}" frameborder="no" scrolling="no"></iframe>
					</div>
					<#else>
						<#if photo != "">
						<div class="image" style="background-image: url('${photo}');"></div>
						<#else>
						<div class="image empty"></div>
						</#if>
					</#if>
					<@view.postRead words=words />
				</div>
				<#assign post = {} />
			</#list>
		</div>
	</div>
</div>
</#if>