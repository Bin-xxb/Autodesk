<#assign query = "SELECT id, description, view_href, title, posting_date_start, posting_date_end, voting_date_start, voting_date_end FROM boards WHERE parent_category.id = '${coreNode.id}'" />
<#assign boards = rest("2.0", "/search?q=" + query?url).data.items![] />

<#assign active_boards = [] />
<#assign past_boards = [] />

<#assign now_ts = .now?long />

<#list boards as board>
	<#if board.winner_announced_date?? && board.winner_announced_date?long lt now_ts>
		<#assign past_boards = past_boards + [board] />
	<#elseif !board.posting_date_start?? || board.posting_date_start?long lt now_ts>
		<#assign active_boards = active_boards + [board] />
	</#if>
</#list>

<div class="contest-header-tab">
	<ul>
		<li class="active-contests active" data-id="active-contests">
			<span>Active contests</span>
		</li>
		<li class="past-contests" data-id="past-contests">
			<span>Past contests</span>
		</li>
	</ul>
</div>

<div class="category-contest-cards active-cards">
	<div class="item-container">
		<#list active_boards as active_board>
			<#assign example = restadmin("/boards/id/${active_board.id}/settings/name/contest.example")>
			<#assign query = "SELECT id, count(*) FROM messages WHERE board.id = '${active_board.id}' AND depth = 0" />
			<#assign entries = rest("2.0", "/search?q=" + query?url)/>
			<div class="item">
				<div class="contest-image">
					${example.value}
				</div>
				<div class="item-body">
					<h4>
						<a href="${active_board.view_href}">${active_board.title}</a>
					</h4>
					<p>${active_board.description}</p>
					<span>${entries.data.count} ENTRIES</span>
				</div>
			</div>
		</#list>
	</div>
</div>

<div class="category-contest-cards past-cards">
	<div class="item-container">
		<#list past_boards as past_board>
			<#assign example = restadmin("/boards/id/${past_board.id}/settings/name/contest.example")>
			<#assign query = "SELECT id, count(*) FROM messages WHERE board.id = '${past_board.id}' AND depth = 0" />
			<#assign entries = rest("2.0", "/search?q=" + query?url)/>
			<div class="item">
				<div class="contest-image">
						${example.value}
				</div>
				<div class="item-body">
					<h4>
						<a href="${past_board.view_href}">${past_board.title}</a>
					</h4>
					<p>${past_board.description}</p>
					<span>${entries.data.count} ENTRIES</span>
				</div>
			</div>
		</#list>
	</div>
</div>

<@liaAddScript>
;(function ($) {
	$('.past-contests').on('click', function() {
		$('.past-cards').removeClass('hide');
		$('.active-cards').addClass('hide');
	});
	$('.active-contests').on('click', function() {
		$('.active-cards').removeClass('hide');
		$('.past-cards').addClass('hide');
	})
})(jQuery);
</@liaAddScript>
