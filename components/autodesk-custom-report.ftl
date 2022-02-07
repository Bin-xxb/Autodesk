<#assign uniqueMsgId=env.context.message.uniqueId/>
<#assign reportLink="/t5/notifications/notifymoderatorpage/message-uid/${uniqueMsgId}"/>
<div class="custom-report">
   <a class="lia-link-navigation report-abuse-link lia-component-forums-action-report-abuse" rel="noindex, nofollow" id="reportAbuseCustom" href="${reportLink}">${text.format('menubar.report_abuse')}</a>
</div>
