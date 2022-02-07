<#if (env.context.message.uniqueId)??>
  <#assign msg = env.context.message.uniqueId />
  <#assign sql = "select status from messages where id='${msg}'" />
  <#assign qry =  rest("2.0","/search?q=" + sql?url) />
  <#if qry.data.size?number gt 0 >
    <#if (qry.data.items[0].status)?? >
      <span class="lia-button-wrapper lia-button-wrapper-secondary lia-component-forums-action-escalate-message-button lia-component-escalate-message-button lia-link-disabled">
        <a class="lia-button lia-button-secondary escalate-message lia-link-disabled" title="Already escalated." id="link_14" href="javascript:;">Escalate</a>
      </span>
    <#else>
      <@delegate/>
    </#if>
  </#if>
</#if>