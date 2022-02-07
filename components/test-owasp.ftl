<#assign html = '<p><a href="https://www.autodesk.com" target="_blank" title="my title" rel="nofollow" class="myclass">this is a link</a> and other text<p>' />
<#assign stripperOptions = utils.html.stripper.from.owasp.optionsBuilder.allowElement("p").allowElement("a").allowAttribute("href", "a").allowStandardUrlProtocols().build() />
<#assign stripped = utils.html.stripper.from.owasp.strip(html, stripperOptions) />
${stripped}