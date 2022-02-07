<@liaAddScript>
; (function ($) {
    if ($('.PostPage').length > 0) {
        console.log('in');
        var $coreNode = $('.PostPage .lia-quilt-column-main-content .lia-form .lia-quilt-row-first.lia-quilt-row-last');
        buttonsControl($coreNode);
    }
    else if($('.ReplyPage').length > 0) {
        var $coreNode = $('.ReplyPage .lia-quilt-column-main-content .lia-form .lia-quilt-row-first.lia-quilt-row-last');
        buttonsControl($coreNode);
    }
    else if($('.EditPage').length > 0) {
        var $coreNode = $('.EditPage .lia-quilt-column-main-content .lia-form .lia-quilt-row-first.lia-quilt-row-last');
        buttonsControl($coreNode);
    } else {
        return;
    }
    
    function buttonsControl(node) {
        console.log('test');
        var $buttonsWrap = node.find('.lia-quilt-row.lia-quilt-row-standard.lia-form-buttons-empty-left-column');
        node.append($buttonsWrap);
        node.find('.lia-quilt-row.lia-quilt-row-standard.lia-form-buttons-empty-left-column').css({"display": "flex", "display": "-webkit-flex", "display": "-ms-flexbox", "display": "-moz-box", "display": "-webkit-box"});
        return;
    }
})(LITHIUM.jQuery);
</@liaAddScript>