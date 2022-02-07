<#assign start_date = restadmin("/boards/id/${coreNode.id}/settings/name/contest.posting_date_start")>
<#assign end_date = restadmin("/boards/id/${coreNode.id}/settings/name/contest.posting_date_end")>

<#if (end_date.value != '') && (start_date.value  != '')>

	<#if end_date?? && end_date.value?number lt .now?long?number>
		<div class="contest-closed contest-date-banner">
			<p>${text.format("custom.contest-closed-date")} <span>${end_date.value?number?number_to_datetime?string('EEEEEEEEE, MMMMMMMMM dd, yyyy')}</span></p>
		</div>
	<#elseif !start_date?? || start_date.value?number lt .now?long?number>
		<div class="contest-active contest-date-banner">
			<#if start_date?? >
				<p>${text.format("custom.contest-start-date")} <span>${start_date.value?number?number_to_datetime?string('EEEEEEEEE, MMMMMMMMM dd, yyyy')}</span></p>
			</#if>
			<#if end_date?? >
				<p>${text.format("custom.contest-end-date")} <span>${end_date.value?number?number_to_datetime?string('EEEEEEEEE, MMMMMMMMM dd, yyyy')}</span></p>
			</#if>
		</div>
	</#if>
</#if>
