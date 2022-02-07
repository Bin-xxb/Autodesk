<#--
	Machine Translation Widget
-->

<#assign isInternationalForum="false" />
<#assign internationalForumsList =settings.name.get("autodesk.international_forums") />
<#assign internationalForumsArray=internationalForumsList?split(',') />
<#assign ID=coreNode.ancestors[0].id />
    
<#if internationalForumsArray?seq_contains(ID) >
    <#assign isInternationalForum="true" />
</#if>

<#if isInternationalForum=="false">
    <#assign clientId="" />
    <#if config.getString( "phase", "prod")=="prod">
        <#assign clientId="forums" />
        <#assign translate_url="translate.autodesk.com" />
        <#elseif config.getString( "phase", "stage")=="stage">
            <#assign clientId="forums_stg" />
            <#assign translate_url="translate-stg.autodesk.com" />
			<#assign translate_url="translate.autodesk.com" />
            <#elseif config.getString( "phase", "dev")=="dev">
                <#assign clientId="forums_dev" />
                <#assign translate_url="translate-dev.autodesk.com" />
    </#if>

   

    

   
        <div class="lia-panel lia-panel-standard lia-machine-translation lang-translator" style="display:none;">

            <div class="lang-translator-left">
                <div class="info-container">
                    
                    <img class="info-img" src='${asset.get("/html/assets/machine-translation-info-icon.png")}' alt="" style="display:none;" />

                    <span class="info-text">${text.format('autodesk-autodesk-machine-translation-widget-info-text')}</span>
                    <span class="info-msg">${text.format('autodesk-autodesk-machine-translation-widget-info-msg')}</span>

                </div>
            </div>
            <div class="lang-translator-right">
                <button id="btn-default-lang" class="hide-button style-button"> Lang1 </button>
                <button id="btn-selected-lang" class="hide-button style-button"> Lang2 </button>
                <select id="select-lang" class="default-select style-select">
              <option value='zho-CN'>中文 (CHINESE SIMPLIFIED)</option>
              <option value='eng-EN' selected>ENGLISH</option>
              <option value='fra-FR'>FRANÇAIS (FRENCH)</option>
              <option value='deu-DE'>DEUTSCH (GERMAN)</option>
              <option value='jpn-JP'>日本語 (JAPANESE)</option>
              <option value='por-BR'>PORTUGUÊS (PORTUGUESE)</option>
              <option value='pol-PL'>POLSKI (POLISH)</option>
              <option value='rus-RU'>РУССКИЙ (RUSSIAN)</option>
              <option value='spa-ES'>ESPAÑOL (SPANISH)</option>
              <option value='tur-TR'>TÜRKÇE (TURKISH)</option>
              <option value='ita-IT'>ITALIANO (ITALIAN)</option>
              <option value='kor-KR'>한국어 (KOREAN)</option>
          </select>
            </div>

        </div>

        <@liaAddScript>
        ;(function($){
            var _alc = _alc || [];
            _alc.push({
                clientId: "${clientId}",
                //product: 'yourProductCode',
                // Delete the following line if you do not want to translate by ID or replace IDs with your values
                //(add as many IDs as you need).
                //toTranslateIds: ['yourIdToTranslate', 'yourIdToTranslate2'],
                // Delete the following line if you do not want to translate � but do not delete both
                // by class name or replace class names with your values (add as many class names as you need).
                //toTranslateClasses: ['yourClassToTranslate', 'yourclassToTranslate2'];
                toTranslateClasses: ['lia-component-message-list', 'lia-message-view-forum-message', 'lia-component-common-widget-page-title','translation__info', 'lia-menu-bar', 'was-this-helpful', 'lia-paging-full-wrapper','lia-forum-topic-page-reply-count','CommentList','lia-component-idea-topic','lia-menu-navigation-wrapper']
            });
            (function() {
                var h = document.getElementsByTagName('head')[0] || document.documentElement;
                var s = document.createElement('script');
                /*s.src = ('https:' == document.location.protocol ? 'https://' : 'http://') +
                    'translate.autodesk.com/javascript/adskLsTranslateMin.js';*/
          s.src = ('https:' == document.location.protocol ? 'https://' :'http://') + '${translate_url}'+'/javascript/adskLsTranslateMin.js'; 
                s.type = 'text/javascript';
                s.async = true;
                h.insertBefore(s, h.firstChild);
            })();

            var langCodeToLang = {
                'zho-CN': "中文 (CHINESE SIMPLIFIED)",
                'eng-EN': "ENGLISH",
                'fra-FR': "FRANÇAIS (FRENCH)",
                'deu-DE': "DEUTSCH (GERMAN)",
                'jpn-JP': "日本語 (JAPANESE)",
                'por-BR': "PORTUGUÊS (PORTUGUESE)",
                'pol-PL': "POLSKI (POLISH)",
                'rus-RU': "РУССКИЙ (RUSSIAN)",
                'spa-ES': "ESPAÑOL (SPANISH)",
                'tur-TR': "TÜRKÇE (TURKISH)",
          		'ita-IT': "ITALIANO (ITALIAN)",
          		'kor-KR': "한국어 (KOREAN)"
            };


            var langToLangCode = {
                "中文 (CHINESE SIMPLIFIED)": 'zho-CN',
                "ENGLISH": 'eng-EN',
                "FRANÇAIS (FRENCH)": 'fra-FR',
                "DEUTSCH (GERMAN)": 'deu-DE',
                "日本語 (JAPANESE)": 'jpn-JP',
                "PORTUGUÊS (PORTUGUESE)": 'por-BR',
                "POLSKI (POLISH)": 'pol-PL',
                "РУССКИЙ (RUSSIAN)": 'rus-RU',
                "ESPAÑOL (SPANISH)": 'spa-ES',
                "TÜRKÇE (TURKISH)": 'tur-TR',
          		"ITALIANO (ITALIAN)": 'ita-IT',
          		"한국어 (KOREAN)": 'kor-KR'
            };

            function translateTo(language) {
                if (language === "eng-EN") {
                    adskLsOriginal();
                } else {
                    
                    adskLsTranslate(_alc, language);
                }
            }

            $(document).ready(function() {
          
               
                         $('.lia-machine-translation.lang-translator').show();
                        var selectedLanguage = sessionStorage.getItem('selectedLanguage') || "eng-EN";
                        var changed = sessionStorage.getItem('selectedLanguageChanged') || true;
                        $("#select-lang").val(selectedLanguage);
                        $(window).on('load',function() {
                          /*reduced the right margin to resolve kudos issue in safari on selecting German/Polish*/
                          $("#lia-body .lia-content .lia-quilt-row-forum-message-footer").css("margin-right","15px");
                          $(".lia-link-navigation .lia-paging-page-arrow").remove();
                            $('#lia-body .lia-machine-translation .info-img').hide();
                            if (selectedLanguage != "eng-EN") {
                                $("#select-lang").change();
                            }
                        });

                        $("#select-lang").on("change", function() {

                            if (changed) {
                                $("#select-lang").removeClass("default-select").addClass("hide-select");
                                $("#btn-default-lang").removeClass("hide-button").addClass("unselected-button").html("ENGLISH");
                                $("#btn-selected-lang").removeClass("hide-button").addClass("selected-button").html(langCodeToLang[$('#select-lang option:selected').val().toString()]);
                                changed = false;
                                sessionStorage.setItem('selectedLanguageChanged', false);
                                sessionStorage.setItem('selectedLanguage', $('#select-lang option:selected').val().toString());
                                selectedLanguage = sessionStorage.getItem('selectedLanguage');
                                translateTo(selectedLanguage);
                                $('#lia-body .lia-machine-translation .info-img').show();
                                $(".escalate-message, .lia-component-accepted-solutions-actions-mark-message-as-accepted-solution-secondary-button .lia-button, .lia-button-wrapper.lia-button-wrapper-secondary .lia-button.lia-button-secondary.reply-action-link.lia-action-reply, .message-reply .lia-button-primary, .helpful-action-buttons .helpful-yes, .helpful-action-buttons .helpful-no").addClass('mt-disable-buttons');
                                $(".lia-button-wrapper.lia-button-wrapper-secondary .reply-action-link.lia-action-quick-reply").addClass('mt-disable-buttons-nobackground');

                                $(".escalate-message, .reply-action-link, .message-reply .lia-button-primary, .helpful-action-buttons .helpful-yes, .helpful-action-buttons .helpful-no").parent().css("cursor", "default");

                                $(".lia-link-navigation.add-tag-link, .metadata-tool-toggle-link.lia-twizzle-closed").addClass('mt-disable-buttons-nobackground');

                            } else if ($('#select-lang option:selected').val() == "eng-EN") {

                                $("#btn-default-lang").removeClass("unselected-button").addClass("selected-button");
                                $("#btn-selected-lang").removeClass("selected-button").addClass("unselected-button");

                                sessionStorage.setItem('selectedLanguage', $('#select-lang option:selected').val().toString());
                                selectedLanguage = sessionStorage.getItem('selectedLanguage');
                                translateTo(selectedLanguage);

                                $('#lia-body .lia-machine-translation .info-img').hide();
                                $(".escalate-message, .lia-component-accepted-solutions-actions-mark-message-as-accepted-solution-secondary-button .lia-button, .lia-button-wrapper.lia-button-wrapper-secondary .lia-button.lia-button-secondary.reply-action-link.lia-action-reply, .message-reply .lia-button-primary, .helpful-action-buttons .helpful-yes, .helpful-action-buttons .helpful-no").removeClass('mt-disable-buttons');
                                $(".lia-button-wrapper.lia-button-wrapper-secondary .reply-action-link.lia-action-quick-reply").removeClass('mt-disable-buttons-nobackground');
                                $(".escalate-message, .reply-action-link, .message-reply .lia-button-primary, .helpful-action-buttons .helpful-yes, .helpful-action-buttons .helpful-no").parent().css("cursor", "pointer");

                                $(".lia-link-navigation.add-tag-link, .metadata-tool-toggle-link.lia-twizzle-closed").removeClass('mt-disable-buttons-nobackground');


                            } else {
                                $("#btn-selected-lang").removeClass("unselected-button").addClass("selected-button").html(langCodeToLang[$('#select-lang option:selected').val().toString()]);
                                $("#btn-default-lang").removeClass("selected-button").addClass("unselected-button");
                                sessionStorage.setItem('selectedLanguage', $('#select-lang option:selected').val().toString());
                                selectedLanguage = sessionStorage.getItem('selectedLanguage');
                                translateTo(selectedLanguage);
                                $('#lia-body .lia-machine-translation .info-img').show();
                                $(".escalate-message, .lia-component-accepted-solutions-actions-mark-message-as-accepted-solution-secondary-button .lia-button, .lia-button-wrapper.lia-button-wrapper-secondary .lia-button.lia-button-secondary.reply-action-link.lia-action-reply, .message-reply .lia-button-primary, .helpful-action-buttons .helpful-yes, .helpful-action-buttons .helpful-no").addClass('mt-disable-buttons');
                                $(".lia-button-wrapper.lia-button-wrapper-secondary .reply-action-link.lia-action-quick-reply").addClass('mt-disable-buttons-nobackground');

                                $(".escalate-message, .reply-action-link, .message-reply .lia-button-primary, .helpful-action-buttons .helpful-yes, .helpful-action-buttons .helpful-no").parent().css("cursor", "default");

                                $(".lia-link-navigation.add-tag-link, .metadata-tool-toggle-link.lia-twizzle-closed").addClass('mt-disable-buttons-nobackground');
                            }
                        });
                        $("#btn-default-lang").on("click", function() {
                            $("#btn-default-lang").removeClass("unselected-button").addClass("selected-button");
                            $("#btn-selected-lang").removeClass("selected-button").addClass("unselected-button");
                            $("#select-lang").val(langToLangCode[$("#btn-default-lang").text().toString()]).trigger('change');
                        });
                        $("#btn-selected-lang").on("click", function() {
                            $("#btn-selected-lang").removeClass("unselected-button").addClass("selected-button");
                            $("#btn-default-lang").removeClass("selected-button").addClass("unselected-button");
                            $("#select-lang").val(langToLangCode[$("#btn-selected-lang").text().toString()]).trigger('change');
                        });
                    
                    });
    })(LITHIUM.jQuery);
</@liaAddScript>
</#if>
