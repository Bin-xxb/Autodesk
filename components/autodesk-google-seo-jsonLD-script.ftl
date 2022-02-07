<#assign root = restadmin("/boards/id/${coreNode.id}/threads/id/${page.context.thread.topicMessage.id}").thread />
<#assign solutions = root.solutions.solution?size />
<#assign subjroot = root.messages.topic.subject?replace('"','')?replace("'"," ")?replace("\\","-")?trim />
<#assign bodyroot = root.messages.topic.body?replace('"','')?replace("'"," ")?replace("\\","-")?trim />
<#assign authorRoot = root.messages.topic.author.login?replace('"','')?replace("'"," ")?replace("\\","-")?trim />
<#assign jsonStr = '{
	"@context": "https://schema.org",
	"@type": "Question",
	"name": "${utils.html.stripper.from.owasp.strip(subjroot)}",
	"upvoteCount": "${root.messages.topic.kudos.count}",
	"text": "${utils.html.stripper.from.owasp.strip(bodyroot)}",
	"dateCreated": "${root.messages.topic.post_time}",
	"author": {
		"@type": "Person",
		"name": "${authorRoot}"
	},
	"answerCount": "${solutions}"' />
	<#if (solutions > 0) >
		<#assign jsonStr = jsonStr + ',"acceptedAnswer": [' />
		<#list root.solutions.solution as solution>
			<#assign bodyContent = restadmin("/messages/id/${solution.id}/body").value />
			<#assign bodyContent = bodyContent?replace('"','')?replace("'"," ")?replace("\\","-")?trim />
			<#assign authorReply = solution.author.login?replace('"','')?replace("'"," ")?replace("\\","-")?trim />
			<#assign jsonStr = jsonStr + '{
					"@type": "Answer",
					"upvoteCount": "${solution.kudos.count}",
					"text": "${utils.html.stripper.from.owasp.strip(bodyContent)}",
					"dateCreated": "${solution.post_time}",
					"author": {
						"@type": "Person",
						"name": "${authorReply}"
					}
				}' />
				<#if (solutions > 1) >
					<#assign jsonStr = jsonStr + "," />
				</#if>
				<#assign solutions = solutions?number - 1 />
		</#list>
	
		<#assign jsonStr = jsonStr + "]" />
	</#if>
<#assign jsonStr = jsonStr + "}" />
<script type="application/ld+json">
${jsonStr}
</script>

<#if page.name=="ForumTopicPage">
	<#assign ancestor=coreNode.ancestors/>
	<#assign ancestors_size=coreNode.ancestors?size/>
	<#if ancestors_size gte 2>
	<#assign ancestor_title=ancestor[ancestors_size-2].title/>
	<@liaAddScript>
		;(function($) { 
			$(document).ready(function(){
				document.title=document.title+" - " +"${ancestor_title?js_string}";
			});
		})(LITHIUM.jQuery);
	</@liaAddScript>
	</#if>
</#if>