<#import "theme-lib.common-functions" as common />
<#assign endpointUrl = common.getEndpointUrl("custom.autodesk.event-subscription") />
<script>
;(function($) {

    /* sendbeacon function */
    const reportData = (url, data) => {
        const formData = new FormData();
        Object.keys(data).forEach((key) => {
            let value = data[key];
            if (typeof value !== 'string') {
                value = JSON.stringify(value);
            }
            formData.append(key, value);
        });
        navigator.sendBeacon(url, formData);
    };

    /* fallback - async function */
    const reportAsync = (url, data) => {
        const formData = new FormData();
        Object.keys(data).forEach((key) => {
            let value = data[key];
            if (typeof value !== 'string') {
                value = JSON.stringify(value);
            }
            formData.append(key, value);
        });
        $.ajax({
            type: "POST",
            url: url,
            async: false,
            processData: false,
            contentType: false,
            data: formData,
            success: function(data, status, xhr) {
                //console.log("mmmmsuccess:" + data);
            },
            error: function(e, error, errorThrown) {
                //console.log("mmmmerror" + error);
            }
        });
    };

    var endpointUrl = '${endpointUrl?js_string}';


    /* accept solution */
    $('.lia-component-accepted-solutions-button').on('click', function() { 
        var $immediateElement = $(this).find('.lia-button.lia-button-secondary');
        var hrefURL = $immediateElement.attr('href');
        var msgString = '/message-uid/';
        var indexEnd = hrefURL.indexOf('?');
        var indexStart = hrefURL.indexOf('/message-uid') + msgString.length;
        var msgID = hrefURL.substring(indexStart,indexEnd);
        
        var sendInfo = {
            "message_id": msgID,
            "action": 'Solution'
        };
        
        if (navigator.sendBeacon) {
            reportData(endpointUrl, sendInfo);  
        } else {
            reportAsync(endpointUrl, sendInfo);
        }
                
    });

    /* solution undo */
    $('.lia-component-solutions-action-unmark-message-as-accepted-solution').on('click', function() { 
        var hrefURL = $(this).attr('href');
        var msgString = '/message-uid/';
        var indexEnd = hrefURL.indexOf('?');
        var indexStart = hrefURL.indexOf('/message-uid') + msgString.length;
        var msgID = hrefURL.substring(indexStart,indexEnd);
        
        var sendInfo = {
            "message_id": msgID,
            "action": 'SolutionUndo'
        };
        
        if (navigator.sendBeacon) {
            reportData(endpointUrl, sendInfo);  
        } else {
            reportAsync(endpointUrl, sendInfo);
        }   

    });

    /* mark spam */
    $('.lia-component-spam-action-mark-message-as-spam').on('click', function() { 
        var hrefURL = $(this).attr('href');
        var msgString = '/message-uid/';
        var indexEnd = hrefURL.indexOf('?');
        var indexStart = hrefURL.indexOf('/message-uid') + msgString.length;
        var msgID = hrefURL.substring(indexStart,indexEnd);
        
        var sendInfo = {
            "message_id": msgID,
            "action": 'Spam'
        };
        
        if (navigator.sendBeacon) {
            reportData(endpointUrl, sendInfo);  
        } else {
            reportAsync(endpointUrl, sendInfo);
        }   

    });

    /* report */
    $('.NotifyModeratorPage .lia-button-Submit-action').on('click', function() { 

        var msgID = window.location.href.split('/message-uid/')[1];
        
        var sendInfo = {
            "message_id": msgID,
            "action": 'Report'
        };
        
        if (navigator.sendBeacon) {
            reportData(endpointUrl, sendInfo);  
        } else {
            reportAsync(endpointUrl, sendInfo);
        }           

    });

    /* unmark spam */
    if( $('.lia-quilt-spam-search-page').length > 0 ) {

        $( document ).ajaxComplete(function() {
            $('.lia-button-wrapper-not-spam .lia-button-primary').on('click',function() {
                $('.lia-spam-view-message').each( function() {
                    if( $(this).hasClass('lia-effect-highlight') ) {
                        var msgID = $(this).find('.BatchProcessing').attr('value');

                        var sendInfo = {
                            "message_id": msgID,
                            "action": "SpamUndo"
                        };
                        if (navigator.sendBeacon) {
                            reportData(endpointUrl, sendInfo);  
                        } else {
                            reportAsync(endpointUrl, sendInfo);
                        }
                    };
                });
            });
        })
    }
    

})(LITHIUM.jQuery);
</script>
