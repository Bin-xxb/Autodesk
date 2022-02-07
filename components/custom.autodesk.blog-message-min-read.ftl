<#import "postRead.ftl" as view>
<#assign threadId = env.context.message.uniqueId />
<#assign query = "SELECT body FROM messages WHERE id = '${threadId}'"/>
<#assign message = restadmin("2.0","/search?q=" + query?url).data.items!0 />

<#assign body = message[0].body?replace("<BR />", " ")?trim />
<#assign stripperOptions = utils.html.stripper.from.owasp.optionsBuilder.build() />
<#assign body = utils.html.stripper.from.owasp.strip(body, stripperOptions)?replace("&nbsp;", " ")?trim />
<#assign words = 0/>
<#list body?split(' ') as word>
	<#assign words = words + 1/>
</#list>

<@view.postRead words=words />
