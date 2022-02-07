<#assign debugEnabled = (settings.name.get("custom.debug_enabled")!false)?boolean />
<#if debugEnabled><#assign start = .now?long /></#if>

<!-- div class="was-this-helpful"></div -->
<#if config.getString( "phase", "prod")=="prod">
    <#assign server_url = 'https://akn.analytics.autodesk.com' />
    <#assign api_key = '90322b0e23b611e793ae92361f002671' />
    <#assign secret_key = '8e22077f-0f3e-f892-b948-a942275fe856' />
    <#assign phase="production">
<#elseif config.getString( "phase", "stage")=="stage">
    <#assign server_url='https://akn.analytics-staging.autodesk.com' />
    <#assign api_key = '4ddb515423b611e793ae92361f002671' />
    <#assign secret_key = 'b5d84be8-6b01-4093-adbd-aa89c24ee514' />
    <#assign phase="staging">
<#elseif config.getString( "phase", "dev")=="dev">
    <#assign server_url='https://akn.analytics-staging.autodesk.com' />
    <#assign api_key = '4ddb515423b611e793ae92361f002671' />
    <#assign secret_key = 'b5d84be8-6b01-4093-adbd-aa89c24ee514' />
    <#assign phase="dev">
</#if>
<#assign env = http.request.serverName>

<script src='${asset.get("/html/assets/jquery-3.4.1.min.js")}'></script>
	
    <link rel="stylesheet" type="text/css" href="/html/assets/akp_helpful.css">
    <script>
    $(function(){
			$('.was-this-helpful').akp_helpful({
				appId: 'forums',
                env: '${phase}', 
                ADPData: {
                 apiKey: '${api_key}',
                 signWith: '${secret_key}'
                },
				data: {
					u: document.location.href,
					t: document.title,
                    s:"discussion"
				}
			});	
    });
    </script>

<#if debugEnabled>
    <#assign finish = .now?long />
    <#assign elapsed = finish - start />
    <script>console.log('autodesk-was-this-helpful: Time elapsed: ${elapsed}ms');</script>
</#if>