<#assign test = "&amp; is a special character" />

<h3>Original:</h3>
${test}

<h3>New:</h3>
<#noautoesc>
  ${test}
</#noautoesc>