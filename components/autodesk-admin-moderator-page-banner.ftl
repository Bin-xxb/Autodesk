<#if page.name == "MoveMessagesPage">
<div class="lia-page-banner-wrapper">
    <div class="lia-page-banner">
        <!-- Below span is the Banner Title -->
        <span class="lia-page-banner-title"><h2>${text.format('page.MoveMessagepage.title')}</h2></span>
       <!-- Below span is the Banner description -->
        <!-- <span class="lia-page-banner-description">${text.format('page.mydashboard.description')}</span> -->
    </div>
	</div>
<#else>
	<div class="lia-page-banner-wrapper">
      <div class="lia-page-banner">
          <!-- Below span is the Banner Title -->
          <span class="lia-page-banner-title"><h2>${text.format('page.SpamSearchPage.title')}</h2></span>
         <!-- Below span is the Banner description -->
          <!-- <span class="lia-page-banner-description">${text.format('page.mydashboard.description')}</span> -->
      </div>
	</div>
</#if>