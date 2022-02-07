<#if coreNode.nodeType == 'board'>

<@liaAddScript>
;(function ($) {
  $('body').addClass('post-forum');
  $('.lia-js-labels-editor-input').attr('placeholder', '${text.format("form.MessageEditor.field.labels.placeholder")?js_string}' );
  $('.lia-js-labels-editor').addClass('forum-label');

  var $label = $('.predefined-labels li a');

  $(document).keyup(function(e) {
    var val = $('.lia-js-labels-editor-input').val().replace(/\s*/g,'');
    var arr = val.split(',');

    for (i = 0; i < arr.length; i++) {
      $label.each(function() {
        var label = $(this).prop('innerHTML').trim();
        var aria = $(this).attr('aria-label').replace(/\s*/g,'');
        if (arr[i] == label && aria == 'ChooseLabel:'+label+'') {
          $(this).attr('aria-label', 'Remove Label: '+label+'');
        }
      })
    }

    $label.each(function() {
      var label = $(this).prop('innerHTML').trim();
      var aria = $(this).attr('aria-label').replace(/\s*/g,'');

      $(this).on('click', function() {
        if (aria == 'RemoveLabel:'+label+'') {
          $(this).addClass('remove');
          $(this).attr('aria-label', 'Choose Label: '+label+'');
        } else {
          $(this).addClass('add');
        }
      })

      if (aria == 'RemoveLabel:'+label+'') {
        var k = 0;
        for (i = 0; i < arr.length; i++) {
          if (arr[i] == label) {
            k = 1;
            break;
          }
        }
        if (k == 0) {
          $(this).attr('aria-label', 'Choose Label: '+label+'');
        }
      } 
    })
  });

})(jQuery);
</@liaAddScript>

</#if>