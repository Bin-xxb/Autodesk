<#assign id = coreNode.id />
<#assign link = settings.name.get("custom.tnc_link", "#") />
<#if page.interactionStyle == "contest">
    <div class="agree-to lia-form-row-checkbox lia-form-row-reverse-label-input">
        <input class="lia-form-disable-agree-input" id="lia-disableAgree" type="checkbox" />
        <div class="lia-form-label">
            ${text.format("custom.post-agree-text", link)}
            <span class="agree-error hide">${text.format('custom.post-agree-error-text')?js_string}</span>
        </div>
    </div>

    <@liaAddScript>
    ; (function ($){
        var $agree = $('.agree-to');
        var $form = $('.lia-contest .lia-form  .lia-button-Submit-action');
        var $checkbox = $('.agree-to .lia-form-disable-agree-input');
        var $error = $('.agree-to .agree-error');
        var $link = $agree.find('a');

        $link.on('click', function() {
            var status = sessionStorage.getItem('${id}');
            if (status != 'ture') {
                sessionStorage.setItem('${id}', 'true');
            }
        })

        $checkbox.on('change', function() {
            $error.addClass('hide');
        });

        $form.on('click', function(e) {
            var status = sessionStorage.getItem('${id}');
            if (!$checkbox.is(':checked') || status == null) {
                e.preventDefault();
                $error.removeClass('hide');
            }
            $form.on('submit', function(e) {
                if (!$checkbox.is(':checked') || status == null) {
                    e.preventDefault();
                    $error.removeClass('hide');
                }
            })
        })

        sessionStorage.removeItem('${id}');

        $('.lia-quilt-column-right.lia-input-edit-form-column >div').append($agree);

    })(LITHIUM.jQuery);
    </@liaAddScript>
</#if>