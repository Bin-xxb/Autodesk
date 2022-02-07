<#assign phase = config.getString( "phase", "prod") />
<#if phase == "dev" || phase == "stage">
  <script type="text/javascript" src="//tags.tiqcdn.com/utag/autodesk/akp-community-qa/qa/utag.js" async></script>
<#elseif phase == "prod">
  <script type="text/javascript" src="//tags.tiqcdn.com/utag/autodesk/akp-community/prod/utag.js" async></script>
</#if>

<#import "svg-lib" as svg/>

<#attempt>
  <#function strip_html html>
    <#local html = html?replace("<P>&nbsp;</P>", "")?replace("<p>&nbsp;</p>", "") />
    <#local stripperOptions = utils.html.stripper.from.owasp.optionsBuilder.allowElement("a").allowAttribute("href", "a").allowStandardUrlProtocols().allowAttribute("rel", "a").allowAttribute("title", "a").allowElement("p").allowElement("br").allowElement("ul").allowElement("ol").allowElement("li").build() />
    <#local stripped = utils.html.stripper.from.owasp.strip(html, stripperOptions) />
    <#local stripped = stripped?replace('<a ', '<a target="_blank" ')?replace('<A ', '<A target="_blank" ') />

    <#list 1..1000 as x>
      <#local stripBr = stripped?replace("<br /><br />", "<br />") />
      <#if stripBr?length == stripped?length>
        <#break>
      <#else>
        <#local stripped = stripBr />
      </#if>
    </#list>
    <#return stripped>
  </#function>

  <#function is_employee items>
    <#local result = false />
    <#local employeeRoles = ["Employee"] />
    <#list items as item>
      <#if employeeRoles?seq_contains(item.name)>
        <#local result = true />
        <#break>
      </#if>
    </#list>
    <#return result>
  </#function>

  <#assign questionItems = [] />
  <#assign answersMap = {} />
  <#assign commentsMap = {} />

  <#assign boardId = webuisupport.path.rawParameters.name.get("board-id", "") />
  <#assign rootCategoryQuery = "SELECT view_href, root_category.title, root_category.view_href FROM boards WHERE id = '${boardId}'" />
  <#assign rootCategoryItems = rest("2.0", "/search?q=${rootCategoryQuery?url}").data.items![] />
  <#if rootCategoryItems?size gt 0 && rootCategoryItems[0].root_category.title?? && rootCategoryItems[0].root_category.view_href??>
    <#assign rootCategoryTitle = rootCategoryItems[0].root_category.title />
    <#assign rootCategoryHref = rootCategoryItems[0].root_category.view_href />
    <#assign boardHref = rootCategoryItems[0].view_href />
    <#assign pageSize = webuisupport.path.rawParameters.name.get("page-size", "6")?number />

    <#assign questionsQuery = "SELECT id, subject, body, author.login FROM messages WHERE board.id = '${boardId}' AND depth = 0 AND conversation.featured = true LIMIT ${pageSize}" />
    <#assign questionItems = rest("2.0", "/search?q=${questionsQuery?url}").data.items![] />
  
    <#--syntax not supported with current freemarker version-->
    <#--<#assign questionIds = questionItems?map(questionItem -> questionItem.id) />-->

    <#assign questionIds = [] />
    <#list questionItems as questionItem>
      <#assign questionIds = questionIds + ["'" + questionItem.id + "'"] />
    </#list>

    <#if questionIds?size gt 0>

      <#assign answersQuery = "SELECT id, subject, body, is_solution, author.id, author.login, parent.id FROM messages WHERE board.id = '${boardId}' AND parent.id IN (${questionIds?join(',')}) ORDER BY is_solution DESC, post_time ASC" />
      <#assign answerItems = rest("2.0", "/search?q=${answersQuery?url}").data.items![] />
      
      <#assign answerIds = [] />
      <#assign answersMap = {} />
      <#list answerItems as answerItem>
        <#if answersMap["question_${answerItem.parent.id}"]?has_content>
          <#assign questionAnswerItems = answersMap["question_${answerItem.parent.id}"] />
        <#else>
          <#assign questionAnswerItems = [] />
        </#if>
        <#assign questionAnswerItems = questionAnswerItems + [answerItem] />
        <#assign answerIds = answerIds + ["'" + answerItem.id + "'"] />
        <#assign answersMap = answersMap + {
          "question_${answerItem.parent.id}": questionAnswerItems
        } />
      </#list>


      <#if answerIds?size gt 0>

        <#assign commentsQuery = "SELECT id, subject, body, author.login, parent.id FROM messages WHERE board.id = '${boardId}' AND parent.id IN (${answerIds?join(',')}) ORDER BY post_time ASC" />
        <#assign commentItems = rest("2.0", "/search?q=${commentsQuery?url}").data.items![] />

        <#assign commentsMap = {} />
        <#list commentItems as commentItem>
          <#if commentsMap["answer_${commentItem.parent.id}"]?has_content>
            <#assign answerCommentItems = commentsMap["answer_${commentItem.parent.id}"] />
          <#else>
            <#assign answerCommentItems = [] />
          </#if>
          <#assign answerCommentItems = answerCommentItems + [commentItem] />
          <#assign commentsMap = commentsMap + {
            "answer_${commentItem.parent.id}": answerCommentItems
          } />
        </#list>

      </#if>




    </#if>

  </#if>

  <#if questionItems?size gt 0>
  <div class="qna-component lia-quilt lia-quilt-qanda-question lia-quilt-layout-two-column-message">
    <h3 class="qna-title">
      <a class="accordion-button" data-wat-link="true" data-wat-loc="expand" data-wat-val="customer questions and answers">
        <span class="accordion-icon">
          <div class="svg-show">
              <span class="svg-icon">
                <svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" viewBox="0 0 100 100">
                  <!-- <symbol id="icon-svg-show" viewBox="0 0 20 20"> -->
                  <!-- <path d="M100 46H54V0h-8v46H0v8h46v46h8V54h46z" fill-rule="evenodd"/> -->
                  <path d="M100 46H54V0h-8v46H0v8h46v46h8V54h46z"/>
                <!-- </symbol> -->
                </svg>
              </span>
          </div>
          <div class="svg-hide hide">
              <span class="svg-icon">
                  <svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape">
                    <!-- <symbol id="icon-svg-hide" viewBox="0 0 1250 100"> -->
                    <path d="M1250 0v100H0V0z"/>
                  <!-- </symbol> -->
                  </svg>
              </span>
          </div>
        </span>
        <span class="accordion-title">Customer questions and answers</span>
        
      </a>
    </h3>
    <ul class="lia-qanda-tab-message-list hide">

    <#list questionItems as questionItem>
      <li class="lia-quilt lia-quilt-qanda-message-item lia-quilt-layout-one-column-list-item">
        <div class="MessageView lia-message-view-qanda-message-item lia-message-view-display qna-question">
          <div class="question">
            <h6 class="lia-message-subject">${questionItem.subject}</h6>
            ${strip_html(questionItem.body)}
            <span>
              <span class="author-name">${questionItem.author.login}</span>
            </span>
          </div>
          <#if answersMap["question_" + questionItem.id]?has_content>
            <#if answersMap["question_" + questionItem.id]?size gt 0>
              <div class="lia-toggler-component qna-answer-list">
                <#list answersMap["question_" + questionItem.id] as answerItem>
                  <div class="MessageView lia-message-view-qanda-answer lia-message-view-display qna-answer-item hide">
                    <div class="qna-answers-right">
                      <div class="lia-message-body-content">
                        <#if answerItem.is_solution?has_content><span><@svg.check_circle/> Verified answer</span></#if>${strip_html(answerItem.body)}
                      </div>
                      <span>
                        <#assign rolesQuery = "SELECT name FROM roles WHERE users.id = '${answerItem.author.id}' LIMIT 1000" />
                        <#assign rolesItems = restadmin("2.0", "/search?q=${rolesQuery?url}").data.items![] />
                        <#assign isEmployee = is_employee(rolesItems) />
                        <span>
                          <#if isEmployee>
                            <@svg.autodesk_logo/>
                          </#if>
                          <span class="author-name">${answerItem.author.login}<#if isEmployee>, Autodesk Employee</span></#if>
                        </span>
                      </span>
                      <#if commentsMap["answer_" + answerItem.id]?has_content>
                        <#if commentsMap["answer_" + answerItem.id]?size gt 0>
                        <div class="qna-comments-list">
                          <#list commentsMap["answer_" + answerItem.id] as commentItem>
                            <div class="qna-comments-item">
                              <span>Reply from ${commentItem.author.login}:</span>
                              <div class="lia-message-body-content">${strip_html(commentItem.body)}</div>
                            </div>
                          </#list>
                        </div>
                        </#if>
                      </#if>
                    </div>
                  </div>
                </#list>
              </div>
              <div class="view-more-answers"><span> more answers</span><@svg.chevron_down/></div>
              <div class="hide-answers hide"><span>Hide answers</span><@svg.chevron_down/></div>
            </#if>
          </#if>
        </div>
      </li>

    </#list>
    </ul>
    <div class="qna-component-bottom hide">
      <a href="${boardHref}" target="_blank" data-wat-link="true" data-wat-loc="CTA" data-wat-val="Ask the ${rootCategoryTitle} community"><@svg.external_link/>Ask the ${rootCategoryTitle} community</a>
    </div>
  </div>

  <@liaAddScript>
  ;(function ($) { 
    var $qnaItemList = $('.qna-component .lia-qanda-tab-message-list');
    var $qnaItem = $qnaItemList.find('.lia-quilt-qanda-message-item');
    var qnaItemLen = $qnaItem.length;
    var $loadMoreBtn = $('.load-more-btn');
    var $viewMoreBtn = $('.view-more-btn');
    var $answerList = $('.qna-component .qna-answer-list');
    var $accordion = $('.qna-title');
    var $qnaComponentBottom = $('.qna-component-bottom');

    $accordion.on('click', function() {
      if ($qnaItemList.hasClass('hide')) {
        $qnaItemList.removeClass('hide');
        $qnaComponentBottom.removeClass('hide');
        $('.svg-show').addClass('hide');
        $('.svg-hide').removeClass('hide');
      } else {
        $qnaItemList.addClass('hide');
        $qnaComponentBottom.addClass('hide');
        $('.svg-show').removeClass('hide');
        $('.svg-hide').addClass('hide');
      }
    })

    $answerList.each(function() {
      var $this = $(this);
      var moreAnswerItemLen = $this.find('.qna-answer-item').length - 1;
      var $viewMoreAnswersBtn = $this.siblings('.view-more-answers');
      var $hideAnswersBtn = $this.siblings('.hide-answers');
      var $answerItem = $this.find('.qna-answer-item');
      var $answerFirstItem = $this.find('.qna-answer-item:first-child');
      var $answerNotFirstItem = $this.find('.qna-answer-item:not(:first-child)');

      if (moreAnswerItemLen > 0) {
        $viewMoreAnswersBtn.prepend('+ '+ moreAnswerItemLen);
      } else {
        $viewMoreAnswersBtn.addClass('hide');
      }

      $answerFirstItem.removeClass('hide');

    
      $viewMoreAnswersBtn.on('click', function() {
        $answerItem.removeClass('hide');
        $viewMoreAnswersBtn.addClass('hide');
        $hideAnswersBtn.removeClass('hide');
      })
      
      $hideAnswersBtn.on('click', function() {
        $answerNotFirstItem.addClass('hide');
        $viewMoreAnswersBtn.removeClass('hide');
        $hideAnswersBtn.addClass('hide');
      })
    })


    $( ".qna-component .MessageView a" ).each(function() {
      var $this = $(this);
      var text = $this.text().trim();
      $(this).attr({"data-wat-link":"true", "data-wat-loc":"answer", "data-wat-val":text});
    });

  })(LITHIUM.jQuery); 
  </@liaAddScript>

  </#if>
<#recover>
</#attempt>