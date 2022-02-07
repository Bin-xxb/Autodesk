<#if page.interactionStyle == "contest">
    <div class="agree-to lia-form-row-checkbox lia-form-row-reverse-label-input">
        <input class="lia-form-disable-agree-input" id="lia-disableAgree" type="checkbox" />
        <div class="lia-form-label">
            ${text.format('custom.post-agree-text')}
            <span class="agree-error hide">${text.format('custom.post-agree-error-text')}</span>
        </div>
    </div>

    <@liaAddScript>
    ; (function ($){
        var $agree = $('.agree-to');
        var $form = $('.lia-contest #form #submitContext');
        var $checkbox = $('#lia-disableAgree');
        var $error = $('.agree-to .agree-error');

        $checkbox.on('change', function() {
            $error.addClass('hide');
        });

        $form.on('click', function(e) {
            if (!$checkbox.is(':checked')) {
                e.preventDefault();
                $error.removeClass('hide');
            }
            $form.on('submit', function(e) {
                if (!$checkbox.is(':checked')) {
                    e.preventDefault();
                    $error.removeClass('hide');
                }
            })
        })

        $('.lia-quilt-column-right.lia-input-edit-form-column >div').append($agree);

    })(LITHIUM.jQuery);
    </@liaAddScript>
</#if>