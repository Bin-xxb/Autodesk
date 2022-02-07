<#import "postRead.ftl" as view>

<#assign imageDimensions = "400x400" />
<#assign pageSizeMax = 3 />
<#assign pageSize = 0/>
<#assign 
	curID = page.context.thread.topicMessage.uniqueId
	title = page.context.thread.topicMessage.subject
	boardID = page.context.thread.board.id
 />

<#assign topicTitle = title?replace("[^a-zA-Z0-9\\s]","","r")/>
<#assign recommendedQuery = "/search?q=" 
	+ "SELECT id, subject, view_href, board.id, teaser, body, cover_image.id FROM messages WHERE subject MATCHES '${topicTitle}' AND board.id = '${boardID}' LIMIT 4 "?url />
<#assign postsItems = rest("2.0", recommendedQuery).data.items![] />

<#if postsItems?size gt 1>
<div class="blog-articles-recommended">
	<div class="wrapper">
		<h2>${text.format('custom.blog-recommended-title')}</h2>
		<div class="boxes">
			<#list postsItems as postItem>
				<#assign pageSize = pageSize + 1/>
				<#if postItem.id?number != curID?number  >
					<#assign post = {
						"subject": postItem.subject,
						"viewHref": postItem.view_href,
						"body": postItem.body,
						"teaser": postItem.teaser,
						"boardID": postItem.board.id
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
				</#if>
				<#if pageSize == pageSizeMax> <#break> </#if>
			</#list>
		</div>
	</div>
</div>
</#if>