<#assign html = '<p><a title="my title" href="/" >link</a></p> <span>span</span> <p class="test" id="myid" style="color:red;">red p</p>' />
<#assign stripperOptions = utils.html.stripper.from.owasp.optionsBuilder.allowElement("a").allowAttribute("href", "a").allowStandardUrlProtocols().allowElement("p").allowElement("br").allowElement("ul").allowElement("ol").allowElement("li").build() />
<#assign stripped = utils.html.stripper.from.owasp.strip(html, stripperOptions) />
${stripped}