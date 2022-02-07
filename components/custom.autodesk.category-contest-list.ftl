<#macro contestCards contest >
	<div class="item">
		<div class="contest-image">
			${contest.image}
		</div>
		<div class="item-body">
			<h4>
				<a href="${contest.href}">${contest.title}</a>
			</h4>
			<p>${contest.description}</p>
			<span>${contest.count} ENTRIES</span>
		</div>
	</div>
</#macro>

<#assign query = "SELECT id, description, view_href, title, posting_date_start, posting_date_end, voting_date_start, voting_date_end, winner_announced_date FROM boards WHERE parent_category.id = '${coreNode.id}'" />
<#assign boards = rest("2.0", "/search?q=" + query?url).data.items![] />

<#assign active_contests = [] />
<#assign past_contests = [] />
<#assign contests = [] />

<#assign now_ts = .now?long />

<#list boards as board>
	<#assign example = restadmin("/boards/id/${board.id}/settings/name/contest.example")>
	<#assign query = "SELECT id, count(*) FROM messages WHERE board.id = '${board.id}' AND depth = 0" />
	<#assign entries = rest("2.0", "/search?q=" + query?url)/>
	<#assign contest_obj = {
		'description' : board.description,
		'href' : board.view_href,
		'title' : board.title,
		'posting_date_start' : board.posting_date_start,
		'posting_date_end' : board.posting_date_end,
		'voting_date_start' : board.voting_date_start,
		'voting_date_end' : board.voting_date_end,
		'winner_announced_date' : board.winner_announced_date,
		'image' : example.value,
		'count' : entries.data.count
	}/>
	<#assign contests = contests + [contest_obj] />
</#list>

<#list contests as contest >
	<#if contest.winner_announced_date?? && contest.winner_announced_date?long lt now_ts>
		<#assign past_contests = past_contests + [contest] />
	<#elseif !contest.posting_date_start?? || contest.posting_date_start?long lt now_ts>
		<#assign active_contests = active_contests + [contest] />
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

<div class="contest-cards active-cards">
	<div class="item-container">
		<#list active_contests as active_contest>
			<@contestCards contest = active_contest/>
		</#list>
	</div>
</div>

<div class="contest-cards past-cards hide">
	<div class="item-container">
		<#list past_contests as past_contest>
			<@contestCards contest = past_contest/>
		</#list>
	</div>
</div>

<@liaAddScript>
;(function ($) {
	$('.past-contests').on('click', function() {
		$('.past-cards').removeClass('hide');
		$('.active-cards').addClass('hide');
		$('.active-contests').removeClass('active');
		$(this).addClass('active');
		init();
	});
	$('.active-contests').on('click', function() {
		$('.active-cards').removeClass('hide');
		$('.past-cards').addClass('hide');
		$('.past-contests').removeClass('active');
		$(this).addClass('active');
		init();
	})

	var activeCards = '.active-cards .item';
	var pastCards = '.past-cards .item';
	var cols = 3;

	init();

	if ($('.active-contests').hasClass('active')) {
		var h = $('.item-container .item').outerHeight(true);
		if ($('.active-cards').height() < h) {
			$('.active-cards').css('height',h+'px');
		}
	} else if ($('.past-contests').hasClass('active')) {
		var h = $('.item-container .item').outerHeight(true);
		if ($('.past-cards').height() < h) {
			$('.past-cards').css('height',h+'px');
		}
	}

	$(window).on('resize',function() {
		init();
	});

	function init() {
		var activeCards = '.active-cards';
		var pastCards = '.past-cards';
		var boxWidth = ($('.contest-header-tab').width() / cols) + 6;

		arrange(activeCards);
		arrange(pastCards);

		function arrange(cards) {
			var heightArr=[];
			for(var i=0; i<cols; i++){
				heightArr.push(0);
			};

			$(cards).find('.item').each(function(index,item) {
				var boxWidth = $(this).outerWidth(true);
			});

			$(cards).find('.item').each(function(index,item) {
				var idx = 0;
				var minBoxHeight = heightArr[0];
				for (var i=0; i<heightArr.length; i++) {
					if (heightArr[i] < minBoxHeight) {
						minBoxHeight = heightArr[i];
						idx = i;
					}
				};

				$(this).css({
					left: boxWidth * idx,
					top: minBoxHeight
				});
				heightArr[idx] += $(this).outerHeight(true);
			});

			var maxContainerHeight = 0;

			for (var i=0; i<heightArr.length; i++) {
				if (heightArr[i] > maxContainerHeight) {
					maxContainerHeight = heightArr[i];
				}
			}
			var height = 0;
			$(cards).find('.item').each(function(index,item) {
				if (($(this).outerHeight(true) + 100) > height) {
					height = $(this).outerHeight(true) + 100;
				}
			})
			if (maxContainerHeight > height) {
				$(cards).css('height',maxContainerHeight +'px');
			} else {
				$(cards).css('height',height+'px');
			}
			// setTimeout(function() {
			// 	$(cards).css('height',maxContainerHeight +'px')
			// }, 500);
		}
	};
})(jQuery);
</@liaAddScript>
