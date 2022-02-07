<@liaAddScript>
;(function($){
  var buttonValIdeaExchange = $('.IdeaExchangePage .lia-button-image-kudos-give span').val();
        var text = 'vote';
  if (!buttonValIdeaExchange) {
    $('.IdeaExchangePage .lia-button-image-kudos-give span').each(function() {
      $(this).html(text);
    })
  }

  var buttonValIdea = $('.IdeaPage .lia-button-image-kudos-give span').val();
  if (!buttonValIdea) {
    $('.IdeaPage .lia-button-image-kudos-give span').each(function() {
      $(this).html(text);
    })
  }
})(LITHIUM.jQuery);
</@liaAddScript>