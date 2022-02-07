<!-- Update base url of EE server : var name : baseURLDB-->
<html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://getbootstrap.com/dist/css/bootstrap.css">
      <script src='${asset.get("/html/assets/jquery-3.4.1.min.js")}'></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
      <script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script> 
      <script type="text/javascript">
         $(document).ready(function() {
			console.log("Loading document");
           var baseURLDB = "https://autoeeprod.autodesk.com";
           var isEmailValid = false;
           var isPhoneOrEmail = false;
         
           //-----------------Config variables call and set to DOM : Start------------
	
		populateStaticText("en");	
			  
		function populateStaticText(locale){
			  		var configURL = baseURLDB + "/AutodeskExpertElite_dev/expertelite/nominee/staticText/"+locale;
			$.ajax({
				type: "GET",
				crossDomain: true,
				url: configURL,
				dataType: "json",
				async: "false",
				beforeSend: function(xhr1) {
				  xhr1.setRequestHeader("Content-Type", "application/json");
				},
				success: function(data, status, xhr) {	
//debugger;				
					//Setting select field - function calling with config call data
					setSelectFieldOptions("proficiency",data.productProficiencyProperties.productListProperties);
					setLanguagesSpoken("language_spoken",data.languagesSpokenProperties.languagesSpokenProperties);
					//setting social Media dom using setSocialMediaFields function
					setSocialMediaFields(data.socialMediaPresenceProperties.socialMediaPresenceList);
					$("#selectLanguage").html(data.selectLanguage);
					$("#nominationFormHeading").html(data.formTitle);
					$("#forSelf").html(data.forSelf);
					$("#areYouExpertEliteMember").html(data.areYouExpertEliteMember);
					$("#labelYes").html(data.labelYes);
					$("#labelYesEEMember").html(data.labelYes);
					$("#labelYesAutodeskReseller").html(data.labelYes);
					$("#labelYesAutodeskStudent").html(data.labelYes);
					$("#labelYesPromoteAutodeskHelp").html(data.labelYes);
					$("#labelYesProductArticles").html(data.labelYes);
					$("#labelYesTipSolScreencast").html(data.labelYes);
					$("#labelYesBlogContribution").html(data.labelYes);
					$("#labelYesLeadProductGroup").html(data.labelYes);
					$("#labelYesIsSpeaker").html(data.labelYes);
					$("#labelYesGunslinger").html(data.labelYes);
					$("#labelNoEEMember").html(data.labelNo);
					$("#labelNoAutodeskReseller").html(data.labelNo);
					$("#labelNoAutodeskStudent").html(data.labelNo);
					$("#labelNoPromoteAutodeskHelp").html(data.labelNo);
					$("#labelNoProductArticles").html(data.labelNo);
					$("#labelNoTipSolScreencast").html(data.labelNo);
					$("#labelNoBlogContribution").html(data.labelNo);
					$("#labelNoLeadProductGroup").html(data.labelNo);
					$("#labelNoIsSpeaker").html(data.labelNo);
					$("#labelNoGunslinger").html(data.labelNo);
					$("#labelNo").html(data.labelNo);
					$("#fullName").html(data.fullName);
					$("#candidateSectionHeading").html(data.candidateSectionHeading);
					$("#candidateFirstName").html(data.candidateFirstName);
					$("#candidateLastName").html(data.candidateLastName);
					$("#labelEmail").html(data.email);
					$("#labelPhone").html(data.phone);
					$("#labelAddress1").html(data.address1);
					$("#labelAddress2").html(data.address2);
					$("#labelCity").html(data.city);
					$("#labelStateProvince").html(data.stateProvince);
					$("#labelZipPostalCode").html(data.zipPostalCode);
					$("#labelCountry").html(data.country);
					$("#labelLanguagesSpoken").html(data.languagesSpoken);
					$("#languageEnglish").html(data.languageEnglish);
					$("#languageFrench").html(data.languageFrench);
					$("#languageGerman").html(data.languageGerman);
					$("#languageItalian").html(data.languageItalian);
					$("#languageSpanish").html(data.languageSpanish);
					$("#languagePortuguese").html(data.languagePortuguese);
					$("#languageRussian").html(data.languageRussian);
					$("#languageJapanese").html(data.languageJapanese);
					$("#languageSimplifiedChinese").html(data.languageSimplifiedChinese);
					$("#languageTraditionalChinese").html(data.languageTraditionalChinese);
					$("#labelOtherLanguage").html(data.otherLanguage);
					$("#labelCommunityUserId").html(data.communityUserId);
					$("#workForAnAutodeskReseller").html(data.workForAnAutodeskReseller);
					$("#doYouWorkForAnAutodeskReseller").html(data.doYouWorkForAnAutodeskReseller);
					$("#nameTheReseller").html(data.nameTheReseller);
					$("#partOfStudentEducatorProgram").html(data.partOfStudentEducatorProgram);
					$("#areYouPartOfStudentEducatorProgram").html(data.areYouPartOfStudentEducatorProgram);
					$("#proficiencyInAutodeskProducts").html(data.proficiencyInAutodeskProducts);
					$("#other").html(data.other);
					$("#socialMedia").html(data.socialMedia);
					$("#nameHandleUrl").html(data.nameHandleUrl);
					$("#promoteHelpProductSolution").html(data.promoteHelpProductSolution);
					$("#doYouPromoteHelpProductSolution").html(data.doYouPromoteHelpProductSolution);
					$("#provideExamplesOrUrls").html(data.provideExamplesOrUrls);
					$("#createArticlesVideosWebinars").html(data.createArticlesVideosWebinars);
					$("#doYouCreateArticlesVideosWebinars").html(data.doYouCreateArticlesVideosWebinars);
					$("#productTipUsingScreencast").html(data.productTipUsingScreencast);
					$("#doYouProductTipUsingScreencast").html(data.doYouProductTipUsingScreencast);
					$("#contributeToBlogWebsite").html(data.contributeToBlogWebsite);
					$("#doYouContributeToBlogWebsite").html(data.doYouContributeToBlogWebsite);
					$("#provideUrls").html(data.provideUrls);
					$("#participateInLeadProductUserGroups").html(data.participateInLeadProductUserGroups);
					$("#doYouParticipateInLeadProductUserGroups").html(data.doYouParticipateInLeadProductUserGroups);
					$("#provideDetails").html(data.provideDetails);
					$("#speakerAtAutodeskEvents").html(data.speakerAtAutodeskEvents);
					$("#areYouSpeakerAtAutodeskEvents").html(data.areYouSpeakerAtAutodeskEvents);
					$("#provideInformation").html(data.provideInformation);
					$("#participateInGunslingerEvents").html(data.participateInGunslingerEvents);
					$("#doYouParticipateInGunslingerEvents").html(data.doYouParticipateInGunslingerEvents);
					$("#autodeskCertifications").html(data.autodeskCertifications);
					$("#additionalCommentsAboutCandidate").html(data.additionalCommentsAboutCandidate);
					$("#submitButton").html(data.submitButton);
					$("#thankYouMessage").html(data.thankYouMessage);
					$("#pleaseCompleteMessage").html(data.pleaseCompleteMessage);
					$(".radio-required-message").html(data.requiredFieldMessage);
					$("#indicatesRequiredFields").html(data.indicatesRequiredFields);
					$("#enterValidEmailId").html(data.enterValidEmailId);
					$("#provideExamplesOrUrlsWebinar").html(data.provideExamplesOrUrls);
					$("#provideExamplesOrUrlsScreencast").html(data.provideExamplesOrUrls);
					$("#provideDetailsGunslingerEvent").html(data.provideDetails);
					$(".form_EE_select[multiple]").prop("title",data.holdDownCtrlKey);
					
				},
				error: function(e, error, errorThrown) {
				//debugger;	
				  console.log("error" + e);
				}
			  });	
			  }
			  function setSelectFieldOptions(selectFieldID,options)
			  {
				//options are in array
				var optionsDOM = "";
				for(var i=0; i<options.length; i++)
				{
					optionsDOM = optionsDOM + "<option>" + options[i] + "</option>";
				}
				$("#"+selectFieldID).html(optionsDOM);
			  }
			  function setLanguagesSpoken(selectFieldID,options)
			  {
				
				//options are in array
				var optionsDOM = "";
				for(var i=0; i<options.length; i++)
				{
					var language = options[i].split(':');
					optionsDOM = optionsDOM + "<option value=\""+language[0]+"\">" + language[1] + "</option>";
				}
				$("#"+selectFieldID).html(optionsDOM);
			  }
			  function setSocialMediaFields(socialMediaChannel)
			  {
				var socialMediaDOM = "";
				for(var i=0;i<socialMediaChannel.length;i++)
				{
					var socialMediaChannelId = socialMediaChannel[i];
					if(i == socialMediaChannel.length - 1){
						socialMediaChannelId = "other_channels";
					}
					socialMediaDOM = socialMediaDOM + "<div class='socialFieldWrapper'><span for='"+socialMediaChannelId.toLowerCase().replace(" ","_")+"' class='SocialMediaLabel'>"+socialMediaChannel[i]+"</span><input id='"+socialMediaChannelId.toLowerCase().replace(" ","_")+"' class='SocialMediaInput form_EE' maxlength='200'></input></div>";
						
				}
				$(".SocialMediaWrapper .allSocialMediaFieldsWrapper").html(socialMediaDOM);
			  }
		   //----------------Config variables call and set to DOM : End------------
		   
		   
		   
		   //--------Nomination for self or other JS : START
            if($("input[name=nomination_for_self]:checked").val() == "Yes")
             {
               //console.log("self nomination");
               $(".mandatoryfieldForOther").hide();
               $(".mandatoryfield").show();
               $(".emailOrPhone").hide();
               $("#full_name").val("");
               $(".full_name_wrapper").hide();
         
               $('input[name=is_ee_member]:checked').attr('checked',false);
               $(".is_ee_member_wrapper").hide();
         
               $(".EELabel .labelPart1").show();
			   $(".EELabe2 .labelPart2").hide();
  /*             $(".EELabel .labelPart2").each(function(){
                 //console.log("text changes");
                 var text = $(this).html();
                 $(this).html(text.charAt(0).toLowerCase() + text.slice(1));
               }); 
   */      
            
             }
             else
             {
               //console.log("other nomination");
               $(".mandatoryfield").hide();
               $(".mandatoryfieldForOther").show();
               $(".emailOrPhone").show();
               $(".full_name_wrapper").show(); 
               $(".is_ee_member_wrapper").show(); 
         
               $(".EELabel .labelPart1").hide(); 
			   $(".EELabel .labelPart2").show(); 
  /*             $(".EELabel .labelPart2").each(function(){
                 var text = $(this).html();
                 $(this).html(text.charAt(0).toUpperCase() + text.slice(1));
                 //console.log($(this).html());
               });        
    */
             }
           //--------Nomination for self or other JS : End
 			//email validation
           var component = {
             input   : $('input[name="email"]'),
             mensage : {
                 fields  : $('.msg'),
                 success : $('.success'),
                 error   : $('.error')
                 }
              },
             regex  = /^(.)+\@((.)+\.)+(.)+$/;
         
             component.input.blur(function () {
              if($("input[name=nomination_for_self]:checked").val() == "Yes"){
             component.mensage.fields.hide();
             //console.log("hiding all error messages for email input"+component.mensage.error + regex.test(component.input.val()));
             //component.mensage.error.hide();
             regex.test(component.input.val()) ? component.mensage.success.show() : component.mensage.error.show();
         
             if(regex.test(component.input.val())){
               isEmailValid = true;
             }else{
               isEmailValid = false;
             }
             //console.log(' ------- Email valid :'+ isEmailValid);
			 }
           });
           $("input[type='radio']").each(function () {
            var radioGrpName = $(this).attr('name');
            $("input."+radioGrpName+"_other").blur(function(){
              if($("input[name="+radioGrpName+"]:checked").val() == "Yes" && $("input."+radioGrpName+"_other").val()=="") 
              {
                $("input."+radioGrpName+"_other").addClass("borderclass");
              }
              else
              {
                $("input."+radioGrpName+"_other").removeClass("borderclass");
              }
            })
          });
         
           $("input[type='radio']").change(function () {
             if($(this).attr("value") == "Yes") {
               var radio_name = $(this).attr("name");
               $("."+radio_name+"_other").attr('disabled',false);
               $("."+radio_name+"_other").removeClass("borderclass");
             }
             else {
               var radio_name = $(this).attr("name");
               $("."+radio_name+"_other").val("").attr('disabled',true); 
               $("."+radio_name+"_other").removeClass("borderclass");
			   $(".input_txt."+radio_name+"_other + .radio-required-message").removeClass("show");
             };
           });
         
         
           $("input[name=nomination_for_self]").change(function (argument) {
             
             $("#full_name,#first_name,#last_name,#email,#address1,#city,#language_spoken,#country,#phone,#proficiency").removeClass("borderclass");
             //console.log("yes no nomination for self clikced");
             $(".msg.error").hide();
             $("#error").html("");
         
             $(".radio-required-message").removeClass("show");
			 $("textarea.input_txt").removeClass("borderclass");
             if($(this).filter('[value=Yes]').prop('checked') == true)
             {
               //console.log("self nomination");
               $(".mandatoryfieldForOther").hide();
               $(".mandatoryfield").show();
               //$(".emailOrPhone").hide();
               $("#full_name").val("");
               $(".full_name_wrapper").hide();
         
               $('input[name=is_ee_member]:checked').attr('checked',false);
              $(".is_ee_member_wrapper").hide();
         
               $(".EELabel .labelPart1").show();
               $(".EELabel .labelPart2").hide();

    /*           $(".EELabel .labelPart2").each(function(){
                 //console.log("text changes");
                 var text = $(this).html();
                 $(this).html(text.charAt(0).toLowerCase() + text.slice(1));
               }); 
    */     
             }
             else
             {
               //console.log("other nomination");
               $(".mandatoryfield").hide();
               $(".mandatoryfieldForOther").show();
               //$(".emailOrPhone").show();
               $(".full_name_wrapper").show(); 
               $(".is_ee_member_wrapper").show(); 
         
               $(".EELabel .labelPart1").hide(); 
			   $(".EELabel .labelPart2").show(); 
     /*          $(".EELabel .labelPart2").each(function(){
                 var text = $(this).html();
                 $(this).html(text.charAt(0).toUpperCase() + text.slice(1));
                 //console.log($(this).html());
               });        
	*/		   
             }
           });
           
            /* 
               Removes Red border from 'Language & Proficiency' when their respective 'other' field have some value
            */
           $('#other_languages,#other_proficiency').blur(function(){


                if( $(this).attr('id') == 'other_languages' ){

                  if( ($("#language_spoken").val()!= null || $("#other_languages").val().trim() != "" ) ){
                  $("#language_spoken").removeClass('borderclass');

                  }else{
                    $("#language_spoken").addClass('borderclass');
                  }
                }

                 if( $(this).attr('id') == 'other_proficiency' ){

                  if( ($("#proficiency").val()!= null || $("#other_proficiency").val().trim() != "" ) ){
                  $("#proficiency").removeClass('borderclass');
                  }else{
                    $("#proficiency").addClass('borderclass');
                  }

               }            

           });

           //$("input[name=nomination_for_self]").change();
         
           $("#full_name,#first_name,#last_name,#address1,#city,#language_spoken,#country,#proficiency").blur(function () {
             if($("input[name=nomination_for_self]").filter('[value=Yes]').prop('checked') == true)
             {
               addRemoveBorder($(this));
             }
           });
         
          $("#full_name").blur(function () {
             if($("input[name=nomination_for_self]").filter('[value=No]').prop('checked') == true)
             {
               if( $(this).val().trim() != ''){
                 $(this).removeClass('borderclass');
               }
			   else{
                 $(this).addClass('borderclass');
               }
             }
           });
		   $("#first_name,#last_name").blur(function () {
             if($("input[name=nomination_for_self]").filter('[value=No]').prop('checked') == true)
             {
                $(this).removeClass('borderclass');
             }
           });
         
         
           $("#email,#phone").blur(function () {
			 if($("input[name=nomination_for_self]:checked").val() == "Yes"){
               if( $(this).attr('id') == 'phone' ){
                 //console.log('-++* phone'+ $(this).val());
                 if(  $('#phone').val().trim() != '' ){
         
                   
                     if( $('#email').val().trim() != ''){
                       if( regex.test(component.input.val()) ){
                         component.mensage.fields.hide();
                         $('#email').removeClass('borderclass');
                         //$("#phone").removeClass('borderclass');
                        //console.log("Phone not required");
                       }
                       else{
                         //console.log("add border if email invalid");
                         component.mensage.fields.show();
                         $('#email').addClass('borderclass');
                       }
                     }else if( $('#email').val().trim() == ''){
                       component.mensage.fields.hide();
                         $('#email').removeClass('borderclass');
                         //$("#phone").removeClass('borderclass');
                     }
                 }else if( $('#phone').val().trim() == '' ){
                   //console.log('---------* ph empty');
                   $("#phone").removeClass('borderclass');
                 }
         
               }else if( $(this).attr('id') == 'email' ){
                 //console.log("emial blur new");
                 if(regex.test(component.input.val())){
                   isEmailValid = true;
                 }else{
                    isEmailValid = false;
                }
                
                if(isEmailValid || ( $(this).val() == "" && $("#phone").val()!="") ){
                 //console.log("remove a border to email new one");
                 $(this).removeClass("borderclass");
                 component.mensage.fields.hide();
                 $("#phone").removeClass("borderclass"); 
                }
                else {
                 //console.log("adding a border to email new one");
                 $(this).addClass("borderclass");
                 component.mensage.fields.show();
                }
         
               }else{
                 if( $(this).val().trim() != ''){
                   $(this).removeClass('borderclass');
                 }else{
                   $(this).addClass('borderclass');
                 }
         
         
               }
             }
           });
         
           function addRemoveBorder (element) {
             if (element.val() == "")
               {
                   element.addClass('borderclass'); 
         
               }
               else {
                 //console.log("remove border class" + $(this));
                   element.removeClass('borderclass');
               }
           }
         
         
          function radioOtherFieldValidationFun (argument) {
            var radioOtherFieldValid=true;
            $("input[type='radio']").each(function () {
               var radioGrpName = $(this).attr('name');
               if($("input[name="+radioGrpName+"]:checked").val() == "Yes" && $("."+radioGrpName+"_other").val()=="")
               {
                  radioOtherFieldValid = false;
               }
            });
			//console.log('radioOtherFieldValid -> '+radioOtherFieldValid);
            return radioOtherFieldValid;
          } 

		  	$(".languageSelection #language").change(function(){
				var language_val = document.getElementById('language').value;
				populateStaticText(language_val)

			});
			
          function validation () {
             if($("input[name=nomination_for_self]:checked").val() == "Yes")
             {
               // $("#email").val()!=""
               if($("#first_name").val()!="" && $("#last_name").val()!=""  && $("#city").val()!="" && ( $("#language_spoken").val()!= null || $("#other_languages").val().trim() != "" ) && $("#address1").val()!="" && $("#country").val()!="" && $('input[name=nomination_for_self]:checked').length > 0 && $('input[name=is_autodesk_reseller]:checked').length > 0 && $('input[name=is_part_of_autodesk_student]:checked').length > 0 && ( $('#proficiency option:selected').length >0 || $("#other_proficiency").val().trim() != "" )&& $('input[name=is_promote_autodesk_help]:checked').length > 0 && $('input[name=created_product_articles]:checked').length > 0 && $('input[name=doProvideAutodPrdTipSolScreencast]:checked').length > 0 && $('input[name=blog_contribution]:checked').length > 0 && $('input[name=is_part_of_lead_product_group]:checked').length > 0 && $('input[name=is_speaker]:checked').length > 0 && $('input[name=partcipated_in_gushlinger]:checked').length > 0 )
               {        
                return radioOtherFieldValidationFun(); 
              }
               else
               { return false; }
             }
             else
             {
               //console.log('------------- ++ :'+$("input[name=nomination_for_self]:checked").val());
			   console.log('in else of validation');
               var isNominationForSelfRadioVal = $("input[name=nomination_for_self]:checked").val();
               if( isNominationForSelfRadioVal == undefined ){
                 //console.log('.. here');
                 return false;
               }
               if($('input[name=is_ee_member]:checked').length > 0 && $("#full_name").val()!="")
               { return radioOtherFieldValidationFun();
			   }
               else
               { return false; } 
             }
         
           }
         
         
           $('#submitbtn').click(function() {
         
             $("#error").html("");
			 //console.log('Email : '+$('#email').val());
             if( $('#phone').val().trim() == ''){
               //console.log('-------- phone is empty :' );
         
               if( $('#email').val().trim() == ''){
                 //console.log('-------- email is empty :' );
                 isPhoneOrEmail = false ;
               }
         
               if( isEmailValid ){
                 isPhoneOrEmail = true ;
               }
             }else{
         
               //console.log('-------- phone is not empty :' );
               
         
               if( $('#email').val().trim() == ''){
                 isPhoneOrEmail = true ;
                 //console.log('-------- submit it :' );
               }else{
         
                 if( isEmailValid){
                 isPhoneOrEmail = true;
               }else{
                 isPhoneOrEmail = false ;
               }
               }
             }
			 
			 var check_variable = false;
			 if($("input[name=nomination_for_self]:checked").val() == "Yes"){
			  check_variable = ( validation() && isPhoneOrEmail ) ;
			 }
			 else if($("input[name=nomination_for_self]:checked").val() == "No"){
			  check_variable = ( validation() ) ;
			 }
         
             if ( check_variable) {
                 //$("#error").html("");
               var language_spoken = [];
               if ($("#language_spoken").val() != null) {
                 var temp = document.getElementById("language_spoken");
                 for (var i = 0; i < temp.length; i++) {
                   if (temp.options[i].selected) language_spoken.push(temp.options[i].value);
                 }
                /* if ($("#other_languages").val().trim() != "") {
                   ////console.log('--------- other lang :'+ ($("#other_languages").val()) );
                   language_spoken.push( ($("#other_languages").val()) );
                 }*/
               }
               if ($("#other_languages").val().trim() != "") {
                   ////console.log('--------- other lang :'+ ($("#other_languages").val()) );
                   language_spoken.push( ($("#other_languages").val()) );
                 }
               var language_spoken_value;
               if(language_spoken.length > 0)
               {
                 ////console.log("greater then 0");
                 language_spoken_value = language_spoken.join(',');
                 ////console.log('--------- lang :'+language_spoken_value);
               }
         
               var proficiency = [];
               if ($("#proficiency").val() != null) {
                 var temp = document.getElementById("proficiency");
                 for (var i = 0; i < temp.length; i++) {
                   if (temp.options[i].selected) proficiency.push(temp.options[i].value);
                 }
                 
               }
               if ($("#other_proficiency").val().trim() != "") {
                 //console.log('--------- other lang :'+ ($("#other_languages").val()) );
                   proficiency.push($("#other_proficiency").val());
               }
         
               var proficiency_value;
               if(proficiency.length > 0)
               {
                 proficiency_value = proficiency.join(',');
               }
         
         
               var social_media_presence = [];
               $(".SocialMediaInput").each(function(){
                 ////console.log(this.id +"   "+ $(this).val());
                 if($(this).val() != "")
                 {
                   social_media_presence.push( {"name":this.id,"handle":$(this).val()} );
                 }
               });
               //console.log(JSON.stringify(social_media_presence));
               
         
         
               var is_ee_member;
               var is_ee_member_element = $('input[name=is_ee_member]:checked');
               if (is_ee_member_element.length > 0) {
                 if (is_ee_member_element.val() == "Yes") {
                   is_ee_member = "true";
                 } else if(is_ee_member_element.val() == "No"){
                   is_ee_member = "false";
                 } else {
                   is_ee_member = undefined;
                 }
               }
         
               var is_part_of_autodesk_student;
               if ($('input[name=is_part_of_autodesk_student]:checked').length > 0) {
                 if ($('input[name=is_part_of_autodesk_student]:checked').val() == "Yes") {
                   is_part_of_autodesk_student = "true";
                 } else {
                   is_part_of_autodesk_student = "false";
                 }
               }
               var is_autodesk_reseller;
               var reseller_name;
               if ($('input[name=is_autodesk_reseller]:checked').length > 0) {
                 if ($('input[name=is_autodesk_reseller]:checked').val() == "Yes") {
                   is_autodesk_reseller = "true";
                   reseller_name = $("#reseller_name").val();
                 } else {
                   is_autodesk_reseller = "false";
                   //reseller_name = "";
                 }
               }
               var is_promote_autodesk_help;
               var promote_autodesk_help_details;
               if ($('input[name=is_promote_autodesk_help]:checked').length > 0) {
                 if ($('input[name=is_promote_autodesk_help]:checked').val() == "Yes") {
                   is_promote_autodesk_help = "true";
                   promote_autodesk_help_details = $("#promote_autodesk_help_details").val();
                 } else {
                   is_promote_autodesk_help = "false";
                   //promote_autodesk_help_details = "";
                 }
               }
               
               var created_product_articles;
               var created_product_articles_details;
               if ($('input[name=created_product_articles]:checked').length > 0) {
                 if ($('input[name=created_product_articles]:checked').val() == "Yes") {
                   created_product_articles = "true";
                   created_product_articles_details = $("#created_product_articles_details").val();
                 } else {
                   created_product_articles = "false";
                   //created_product_articles_details = "";
                 }
               }
         
               var doProvideAutodPrdTipSolScreencast;
               var autodPrdTipSolScreencastUrl;
               if ($('input[name=doProvideAutodPrdTipSolScreencast]:checked').length > 0) {
                 if ($('input[name=doProvideAutodPrdTipSolScreencast]:checked').val() == "Yes") {
                   doProvideAutodPrdTipSolScreencast = "true";
                   autodPrdTipSolScreencastUrl = $("#autodPrdTipSolScreencastUrl").val();
                 } else {
                   doProvideAutodPrdTipSolScreencast = "false";
                   //autodPrdTipSolScreencastUrl = "";
                 }
               }
         
         
               var blog_contribution;
               var blog_contribution_urls;
               if ($('input[name=blog_contribution]:checked').length > 0) {
                 if ($('input[name=blog_contribution]:checked').val() == "Yes") {
                   blog_contribution = "true";
                   blog_contribution_urls = $("#blog_contribution_urls").val();
                 } else {
                   blog_contribution = "false";
                   //blog_contribution_urls = "";
                 }
               }
               var is_part_of_lead_product_group;
               var lead_product_group_details;
               if ($('input[name=is_part_of_lead_product_group]:checked').length > 0) {
                 if ($('input[name=is_part_of_lead_product_group]:checked').val() == "Yes") {
                   is_part_of_lead_product_group = "true";
                   lead_product_group_details = $("#lead_product_group_details").val();
                 } else {
                   is_part_of_lead_product_group = "false";
                   //lead_product_group_details = "";
                 }
               }
               var is_speaker;
               var speaker_information;
               if ($('input[name=is_speaker]:checked').length > 0) {
                 if ($('input[name=is_speaker]:checked').val() == "Yes") {
                   is_speaker = "true";
                   speaker_information = $("#speaker_information").val();
                 } else {
                   is_speaker = "false";
                   //speaker_information = "";
                 }
               }
               var partcipated_in_gushlinger;
               var gushlinger_details;
               if ($('input[name=partcipated_in_gushlinger]:checked').length > 0) {
                 if ($('input[name=partcipated_in_gushlinger]:checked').val() == "Yes") {
                   partcipated_in_gushlinger = "true";
                   gushlinger_details = $("#gushlinger_details").val();
                 } else {
                   partcipated_in_gushlinger = "false";
                   //gushlinger_details = "";
                 }
               }
               var full_name = $("#full_name").val().trim();
               full_name = (full_name != "") ? full_name : undefined;
         
               var first_name = $("#first_name").val().trim();
               first_name = (first_name != "") ? first_name : undefined; 
         
               var last_name = $("#last_name").val().trim();
               last_name = (last_name != "") ? last_name : undefined;
         
               var email = $("#email").val().trim();
               email = (email != "") ? email : '';
         
               var phone = $("#phone").val().trim();
               phone = (phone != "") ? phone : undefined;
         
               var address1 = $("#address1").val().trim();
               address1 = (address1 != "") ? address1 : undefined;
         
               var address2 = $("#address2").val().trim();
               address2 = (address2 != "") ? address2 : undefined;
         
               var city = $("#city").val().trim();
               city = (city != "") ? city : undefined;
         
               var state = $("#state").val().trim();
               state = (state != "") ? state : undefined;
         
               var postal_code = $("#postal_code").val().trim();
               postal_code = (postal_code != "") ? postal_code : undefined;
         
               var community_id = $("#community_id").val().trim();
               community_id = (community_id != "") ? community_id : undefined;
         
               var additional_comments = $("#additional_comments").val().trim();
               additional_comments = (additional_comments != "") ? additional_comments : undefined; 
				
				
				
			   var autodeskCertification = $("#autodeskCertification").val().trim();
               autodeskCertification = (autodeskCertification != "") ? autodeskCertification : undefined; 
				
         
               var country = $("#country").val().trim();
               country = (country != "") ? country : undefined;
         
               var payload = {
                 "personalDetails": {
                   "submitterFullName": full_name,
                   "isSubmitterEEMember": is_ee_member,
                   "firstName": first_name,
                   "lastName": last_name,
                   "email": email,
                   "phone": phone,
                   "address1": address1,
                   "address2": address2,
                   "city": city,
                   "stateOrProvince": state,
                   "postalCode": postal_code,
                   "country": country,
                   "languageSpoken": language_spoken_value,
                   "autodeskCommunityUserId": community_id,
                   "autodeskResellerName": reseller_name,
                   "studentOrEducator": is_part_of_autodesk_student,
                   "isNomWorkForAutodeskReseller": is_autodesk_reseller
                 },
                 "proficiency": {
                   "proficiencyInAutodeskProduct": proficiency_value,
                   "socialMediaPresence": social_media_presence,
                   "doPromoteAutodeskHelp": is_promote_autodesk_help,
                   "autodHelpProductSolutionURL": promote_autodesk_help_details,
                   "doCreateProductArticlesVideosWebinars": created_product_articles,
                   "productArticleWebinarURL": created_product_articles_details,
                   "doProvideAutodPrdTipSolScreencast": doProvideAutodPrdTipSolScreencast,
                   "autodPrdTipSolScreencastUrl": autodPrdTipSolScreencastUrl,
                   "doContributeBlog": blog_contribution,
                   "blogURL": blog_contribution_urls,
                   "doParticipateOrLeadAutodeskProduct": is_part_of_lead_product_group,
                   "participateLeadAutodeskProductUserGroupDetails": lead_product_group_details,
                   "speakerInfo": speaker_information,
                   "doParticipateInGunslinger": partcipated_in_gushlinger,
                   "gunslingerEventsDetails": gushlinger_details,
				   "autodeskCertificatesDetails": autodeskCertification,
                   "additionalComments": additional_comments,
                   "isSpeaker": is_speaker
                 }
               }
         
         
               ////console.log("paylo",btoa(username + ":" + password));
               ////console.log('-------- final payload :',payload);
               var OnBehalf;
               if ($("input[name=nomination_for_self]:checked").val() == "Yes") {
                OnBehalf = false;
               }
               else
               {
                 OnBehalf = true;
               }
               var addNomieeURL = baseURLDB+"/AutodeskExpertElite_dev/expertelite/nominee/add";
               //console.log(JSON.stringify(payload));
               $.ajax({
                 type: "POST",
                 url: addNomieeURL,
                 data: JSON.stringify(payload),
                 async: false,
                 crossDomain: true,
                 dataType: "json",
                 beforeSend: function(xhr1) {
                   
                   xhr1.setRequestHeader("Content-Type", "application/json");
                   xhr1.setRequestHeader("On-Behalf", OnBehalf);
                 },
                 success: function(data) {
                   if(data.status == 'success')
                   {
                     //alert('Thanks for your Nomination!');
                     $(".container.NominationForm").hide();
                     $(".serverResponceSuccess-wrapper").show();
                   }
                   else
                   {
                     console.log("Error...! Server side"); 
                     $("#error").html("Error..! Server Issue.");
                   }
                 }
               });
         
             } else {
         
         
               if( !validation() ){
                 $("#error").html("Please complete all of the required fields");
               console.log("enter all fileds");
               }
               
               if( !isEmailValid){
                 console.log("Email is invalid");
                 $('#email').blur();
         
               }
         
             }
         
             if($('input[name=nomination_for_self]:checked').length == 0){
               $("label[for='nomination_for_self'] .radio-required-message").addClass("show");
             }
             else{
               $("label[for='nomination_for_self'] .radio-required-message").removeClass("show");
             }
			 
			 if($("#full_name").val() == ""){
               $(".full_name_wrapper .radio-required-message").addClass("show");
             }
             else{
               $(".full_name_wrapper .radio-required-message").removeClass("show");
             }
         
             if ($("input[name=nomination_for_self]:checked").val() == "Yes") {
               
               $("input[type='radio']").each(function () {
                 var radioGrpName = $(this).attr('name');
                 //console.log("try"+$("input[name="+radioGrpName+"]:checked").val());
                 if($("input[name="+radioGrpName+"]:checked").val() == undefined)
                 {
                   $("label[for="+radioGrpName+"] .radio-required-message").addClass("show");
                 }
                 else
                 {
                   $("label[for="+radioGrpName+"] .radio-required-message").removeClass("show");
                 }
               });
			   if($("#first_name").val() == ""){
               $("#first_name + .radio-required-message").addClass("show");
				 }
				 else{
				   $("#first_name + .radio-required-message").removeClass("show");
				 }
				 
				 if($("#last_name").val() == ""){
				   $("#last_name + .radio-required-message").addClass("show");
				 }
				 else{
				   $("#last_name + .radio-required-message").removeClass("show");
				 }
			   
			   if($("#city").val() == ""){
				 $("#city + .radio-required-message").addClass("show");
			   }
			   else{
				 $("#city + .radio-required-message").removeClass("show");
			   }
			   
			   if($("#address1").val() == ""){
				 $("#address1 + .radio-required-message").addClass("show");
			   }
			   else{
				 $("#address1 + .radio-required-message").removeClass("show");
			   }
			   
			   if($("#country").val() == ""){
				 $("#country + .radio-required-message").addClass("show");
			   }
			   else{
				 $("#country + .radio-required-message").removeClass("show");
			   }
			   
			   if($("#language_spoken").val() != null || $("#other_languages").val().trim() !="" ){
				 $("#language_spoken + .radio-required-message").removeClass("show");
			   }
			   else{
				 $("#language_spoken + .radio-required-message").addClass("show");
			   }
			   
               if($('#proficiency option:selected').length > 0 || $("#other_proficiency").val().trim() != "")
               {
                 $("#proficiency").removeClass('borderclass'); 
				 $("#proficiency + .radio-required-message").removeClass("show");
               } else {
                 $("#proficiency").addClass('borderclass'); 
				 $("#proficiency + .radio-required-message").addClass("show");
               }
         
         
               if ($("#full_name").val() == "") {
                 $("#full_name").addClass('borderclass');
               } else {
                 $("#full_name").removeClass('borderclass');
               }
               if ($("#first_name").val() == "") {
                 $("#first_name").addClass('borderclass');
               } else {
                 $("#first_name").removeClass('borderclass');
               }
               if ($("#last_name").val() == "") {
                 $("#last_name").addClass('borderclass');
               } else {
                 $("#last_name").removeClass('borderclass');
               }
               /*if ($("#email").val() == "") {
                 $("#email").addClass('borderclass');
               } else {
                 $("#email").removeClass('borderclass');
               }*/
               if ($("#city").val() == "") {
                 $("#city").addClass('borderclass');
               } else {
                 $("#city").removeClass('borderclass');
               }
               if ($("#language_spoken").val() != null || $("#other_languages").val().trim() !="" ) {
                 $("#language_spoken").removeClass('borderclass');
               } else {
                 $("#language_spoken").addClass('borderclass');
               }
               if ($("#address1").val() == "") {
                 $("#address1").addClass('borderclass');
               } else {
                 $("#address1").removeClass('borderclass');
               }
               if ($("#country").val() == "") {
                 $("#country").addClass('borderclass');
               } else {
                 $("#country").removeClass('borderclass');
               }
               /*if ($("#community_id").val() == "") {
                 $("#community_id").addClass('borderclass');
               } else {
                 $("#community_id").removeClass('borderclass');
               }*/
             } else {
         
               var radioGrpName = "is_ee_member";
               if($("input[name="+radioGrpName+"]:checked").val() == undefined) {
                 $("label[for="+radioGrpName+"] .radio-required-message").addClass("show")
               } else {
                 $("label[for="+radioGrpName+"] .radio-required-message").removeClass("show"); 
               }
         
               if ($("#full_name").val() == "") {
                 $("#full_name").addClass('borderclass');
               } else {
                 $("#full_name").removeClass('borderclass');
               }
             }

             //----if radio box is Yes, than if Yes field should be red.
              $("input[type='radio']").each(function () {
                 var radioGrpName = $(this).attr('name');
                 //console.log("try"+$("input[name="+radioGrpName+"]:checked").val());
                 if($("input[name="+radioGrpName+"]:checked").val() == "Yes" && $(".input_txt."+radioGrpName+"_other").val() == "")
                 {
                    $(".input_txt."+radioGrpName+"_other").addClass("borderclass");
					$(".input_txt."+radioGrpName+"_other + .radio-required-message").addClass("show");
                 }
                 else
                 {
                    $(".input_txt."+radioGrpName+"_other").removeClass("borderclass");
					$(".input_txt."+radioGrpName+"_other + .radio-required-message").removeClass("show");
                 }
              });

             window.scroll(0,0);
           });
         
         });
      </script>
      <style>
         .NominationForm span.radio-required-message
         {
         display:none;
         color: red;
         }
		 .NominationForm span.radio-required-message.show{
			display: block;
		 }
         .NominationForm span.emailOrPhone
         {
         margin-left: 100px;
         margin-bottom: -20px;
         }
         .NominationForm .seperator {
         border-right: 1px dotted #999;
         width: 330px;
         float: left;
         }
         .NominationForm select[multiple] {
         height: auto;
         width: 80%;
         }
         .NominationForm .form-control {
         width: 80%;
         height: 25px;
         padding: 6px 12px;
         }
         .NominationForm .form_EE{
         width: 80%;
         height: 25px;
         padding: 6px 12px;
         border: 1px solid #CCC;
         border-radius: 4px;
         }
         .NominationForm .neForm{
         float: left;
         width: 330px;
         margin-right: 15px;
         }
         .NominationForm .EELabel {
         display: block;
         padding-top: 10px;
         padding-bottom: 2px;
         font-weight: 100;
         margin-top: 5px;
         }
         .NominationForm select {
         width: 40%;
         height: 23px;
         }
         .NominationForm .form_EE_select {
         display: block;
         width: 80%;
         height: 25px;
         color: #555;
         background-color: #fff;
         border: 1px solid #CCC;
         border-radius: 4px;
         }
         .NominationForm input,
         .NominationForm textarea,
         .NominationForm select,
         .NominationForm button {
         margin: 0em;
         font: normal normal normal 13.3333346154419px/normal Arial;
         color: initial;
         }
         .NominationForm input,.NominationForm input[type="password" i],.NominationForm input[type="search" i] {
         -webkit-appearance: textfield;
         padding: 1px;
         background-color: white;
         border: 2px inset;
         border-image-source: initial;
         border-image-slice: initial;
         border-image-width: initial;
         border-image-outset: initial;
         border-image-repeat: initial;
         -webkit-rtl-ordering: logical;
         -webkit-user-select: text;
         cursor: auto;
         }
         .NominationForm .msg {
         display: none;
         }
         .NominationForm .error {
         color: red;
         }
         .NominationForm .success {
         color: green;
         }
         .NominationForm .borderclass {
         border:1px solid red;
         }
         .NominationForm .borderclass:focus {
         border: 1px solid red;
         box-shadow: 0px 0px 2px 0px red;
         outline: 0;
         }
         .NominationForm input[type="radio" i] {
         -webkit-appearance: radio;
         box-sizing: border-box;
         }
         .NominationForm input[type="radio" i] {
         margin: 3px 3px 0px 5px;
         }
         .NominationForm input[type="text"]{
         font-size: 11px;
         height : 25px;
         }
         .NominationForm input[type="email"] {
         display: block;
         }
         .NominationForm .neform-second-col{
         float: left;
         width: 330px;
         margin-left: 15px;
         }
         .NominationForm input
         {
         padding : 0px 5px ! important;
         }
         .NominationForm .bb3,.NominationForm .bv3,.NominationForm .ba3 {
         border-bottom: 1px dashed #dadada;
         }
         .NominationForm .btn-brand {
         color: #fff;
         background-color: #0696d7;
         text-transform: uppercase;
         border: 0;
         padding:  2%;
         border-radius: 4px;
         text-decoration:none;
         font-size:14px;
         }
         .NominationForm .mbl,.NominationForm .mvl,.NominationForm .mal {
         margin-bottom: 24px;
         }
         .NominationForm .mrm,.NominationForm .mhm,.NominationForm .mam {
         margin-right: 12px;
         }
         .container.NominationForm{
         margin-bottom: 50px;
		 margin-top:20px;
         }
         .NominationForm .s3, .NominationForm .s3-b {
         font-size: 1.357143em;
         line-height: 1.105263;
         }
         .NominationForm-wrapper{
         font-size: 11px;
         width: 700px;
         margin: auto;
         }
         .NominationForm .error-content{
         color: red;
         }
         .NominationForm .mandatoryfield:before { 
         content:"* ";
         color:red;
         }
         .NominationForm .mandatoryfieldForOther:before{
         content:"* ";
         color:red; 
         }
         .NominationForm input, textarea, keygen, select, button {
         margin: 0em;
         font: inherit;
         color: initial;
         letter-spacing: normal;
         word-spacing: normal;
         text-transform: none;
         text-indent: 0px;
         text-shadow: none;
         display: inline-block;
         text-align: mandatoryFieldt;
         }
         .NominationForm .full_name_wrapper,
         .NominationForm .is_ee_member_wrapper {
         display: none;
         }
         .NominationForm-wrapper .serverResponceSuccess-wrapper {
         display: none;
         }
         .NominationForm-wrapper .serverResponceSuccess-wrapper .thank-you-text,
         .NominationForm-wrapper .NominationForm .blockHeading {
         font-family: 'Frutiger Next W04 Light';
         font-weight: 400;
         color: #0696d7;
         font-size: 27px;
		 line-height: 35px;
         margin-bottom: 20px;
         }
         .NominationForm-wrapper .serverResponceSuccess-wrapper .serverResponceSuccess-message {
			font-family: 'Frutiger Next W04 Light';
			font-weight: 400;
			color: #0696d7;
			font-size: 27px;
         }
         .NominationForm .SocialMediaLabel {
         width: 30%;
         font-weight: normal;
         display: inline-block;
         }
         .NominationForm .SocialMediaInput {
         width: 63%;
         }
         .NominationForm .socialFieldWrapper {
         margin: 5px 0px;
         }
         .NominationForm textarea {
         width:80%; 
         height:68px;
         border-radius: 4px;
         border-color: #CCC;
		 resize: none;
		 border: 1px solid #ccc;
		 background-color: #EBEBE4;
		 overflow-y: hidden;
		 background-color: #FFF;
         }
		 .NominationForm textarea[disabled]{
			background-color: #EBEBE4;
		 }
		.NominationForm .SocialMediaWrapper{
			padding-top: 10px;
			padding-bottom: 2px;
			font-weight: 100;
			margin-top: 5px;
		}
		.NominationForm-wrapper .languageSelection {	
			margin-left: 400px;
			width: 400px;
		}
		.NominationForm-wrapper .blockHeading {
			float: left;
		}
		.NominationForm-wrapper .form-group {
			clear: both;
		}
		.NominationForm-wrapper input[type="radio"] {
			margin-right: 5px !important;
		}
		.NominationForm-wrapper .EELabel .italic span {
			font-family: 'FrutigerNextW04-Italic';
			font-style: normal;
		}
      </style>
   </head>
   <body>
      <div class="NominationForm-wrapper">
         <div class="container NominationForm">
            
            <div class="blockHeading" id="nominationFormHeading">
              
            </div>
			<div class="languageSelection">
				<!-- <span>Select Language</span> -->
				<span id="selectLanguage"></span>
				<select id="language">
					<option value="de">German</option>
					<option value="en" selected="selected">English (US)</option>
					<option value="es-mx">Spanish</option>
					<option value="fr">French</option>
					<option value="ja">Japanese</option>
					<option value="pt-br">Portuguese (Brazilian)</option>
					<option value="zh-CN">Chinese (Simplified)</option>
					<option value="ru">Russian</option>
					<option value="tr">Turkish</option>					
				</select>	
			</div>
            <div>

               <span id="pleaseCompleteMessage"></span>
            </div>
            <!-- <hr/> -->
            <div class="form-group">
               <div class="neform seperator " id="form-group">
                  <p><span class="mandatoryfield mandatoryfieldForOther" id="indicatesRequiredFields"></span></p> 
                  <label class=" EELabel" for="nomination_for_self" class="form-control radio-button-label"> <span class="mandatoryfield mandatoryfieldForOther"></span><span id="forSelf"></span> <span class='radio-required-message' ></span></label>
                  <input type="radio" name="nomination_for_self" value="Yes" ><span id="labelYes"></span>
				  <br/>
                  <input type="radio" name="nomination_for_self" value="No"><span id="labelNo"></span>
                  <br>
                  <div class="full_name_wrapper">
                     <label class="EELabel" for="full_name"  ><span class="mandatoryfield mandatoryfieldForOther"></span><span id="fullName"></span></label>
                     <input  type="text" size="46" id="full_name" name="full_name" maxlength="100"  class="form-control form_EE">
					 <span class='radio-required-message'></span>
                  </div>
                  <div class="is_ee_member_wrapper">
                     <label class=" EELabel" for="is_ee_member" class="form-control radio-button-label"><span class="mandatoryfield mandatoryfieldForOther" id="areYouExpertEliteMember"></span> <span class='radio-required-message'></label>
                     <input type="radio" name="is_ee_member" value="Yes"><span id="labelYesEEMember"></span>
                     <br/>
                     <input type="radio" name="is_ee_member" value="No"><span id="labelNoEEMember"></span>
                     <br>
                  </div>
                  <hr class="bb3 mvl mrm">
                  <h3 class="s3" id="candidateSectionHeading"> </h3>
                  <label class=" EELabel" for="first_name"><span class="mandatoryfield"></span><span id="candidateFirstName"></span></label>
                  <input type="text" class="form-control form_EE" name="first_name" id="first_name" value="" size="46" maxlength="100" class="input_txt"  class="form-control">
				  <span class="radio-required-message"></span>
                  <label class=" EELabel" for="last_name"><span class="mandatoryfield"></span><span id="candidateLastName"></span></label>
                  <input type="text" class="form-control form_EE" name="last_name" id="last_name" value="" size="46" maxlength="100" class="input_txt"  class="form-control"/>
				  <span class="radio-required-message"></span>
                  <label class=" EELabel" for="email"><span class="mandatoryfield"></span><span id="labelEmail"></span></label>
                  <input  class="form-control form_EE" type="email" name="email" id="email" value="" size="46" maxlength="200" class="input_txt"  class="form-control"><span class="msg error" id="enterValidEmailId"></span>
                  <!-- <span class="emailOrPhone EELabel">OR</span>  -->
                  <label class=" EELabel" for="phone">
                     <!--<span class="mandatoryfieldForOther"></span>--> <span id="labelPhone"></span>
                  </label>
                  <input type="text" class="form_EE" name="phone" id="phone" value="" size="46" maxlength="100" class="input_txt">
                  <label class=" EELabel" for="address1"> <span class="mandatoryfield"></span><span id="labelAddress1"></span></label>
                  <input type="text" class="form_EE" class="form-control" name="address1" id="address1" size="46" maxlength="100" class="input_txt">
				  <span class="radio-required-message"></span>
                  <label class=" EELabel" for="address2" ><span id="labelAddress2"></span></label>
                  <input type="text" class="form_EE" name="address2" id="address2" value="" size="46" maxlength="100" class="input_txt">
                  <label class=" EELabel" for="city"><span class="mandatoryfield" class="form-control"></span><span id="labelCity"></span></label>
                  <input type="text" class="form_EE" name="city" id="city" value="" size="46" maxlength="100" class="input_txt" >
				  <span class="radio-required-message"></span>
                  <label class=" EELabel" for="state"><span id="labelStateProvince"></span></label>
                  <input type="text" class="form_EE" name="state" id="state" value="" size="46" maxlength="100" class="input_txt">
                  <label class=" EELabel" for="postal_code"><span id="labelZipPostalCode"></span></label>
                  <input type="text" class="form_EE" name="postal_code" id="postal_code" value="" size="46" maxlength="100" class="input_txt">
                  <label class=" EELabel" for="country"><span class="mandatoryfield" class="form-control"></span><span id="labelCountry"></span></label>
                  <select class="form_EE_select"  name="country" id="country"  >
                     <option value="">Select...</option>
                     <option>United States</option>
                     <option>Andorra</option>
                     <option>Afghanistan</option>
                     <option>Albania</option>
                     <option>Algeria</option>
                     <option>Antigua and Barbuda</option>
                     <option>Angola</option>
                     <option>Anguilla</option>
                     <option>Argentina</option>
                     <option>Armenia</option>
                     <option>Aruba</option>
                     <option>Australia</option>
                     <option>Austria</option>
                     <option>Azerbaijan</option>
                     <option>Bahamas</option>
                     <option>Bahrain</option>
                     <option>Bangladesh</option>
                     <option>Barbados</option>
                     <option>Belarus</option>
                     <option>Belgium</option>
                     <option>Belize</option>
                     <option>Bermuda</option>
                     <option>Bhutan</option>
                     <option>Bolivia</option>
                     <option>Bosnia and Herzegovina</option>
                     <option>Botswana</option>
                     <option>Brazil</option>
                     <option>Brunei Darussalam</option>
                     <option>Bulgaria</option>
                     <option>Cameroon</option>
                     <option>Cambodia</option>
                     <option>Canada</option>
                     <option>Cayman Islands</option>
                     <option>Central African Republic</option>
                     <option>Chad</option>
                     <option>Chile</option>
                     <option>China</option>
                     <option>Christmas Island</option>
                     <option>Colombia</option>
                     <option>Congo</option>
                     <option>Congo, Dem. Republic</option>
                     <option>Costa Rica</option>
                     <option>Croatia</option>
                     <option>Cyprus</option>
                     <option>Czech Republic</option>
                     <option>Denmark</option>
                     <option>Djibouti</option>
                     <option>Dominica</option>
                     <option>Dominican Republic</option>
                     <option>Ecuador</option>
                     <option>Egypt</option>
                     <option>El Salvador</option>
                     <option>Estonia</option>
                     <option>Ethiopia</option>
                     <option>Faeroe Islands</option>
                     <option>Finland</option>
                     <option>France</option>
                     <option>Gabon</option>
                     <option>Gambia</option>
                     <option>Georgia</option>
                     <option>Germany</option>
                     <option>Ghana</option>
                     <option>Gibraltar</option>
                     <option>Greece</option>
                     <option>Greenland</option>
                     <option>Guadeloupe</option>
                     <option>Guam</option>
                     <option>Guatemala</option>
                     <option>Guyana</option>
                     <option>Haiti</option>
                     <option>Honduras</option>
                     <option>Hong Kong</option>
                     <option>Hungary</option>
                     <option>Iceland</option>
                     <option>India</option>
                     <option>Indonesia</option>
                     <option>Ireland</option>
                     <option>Israel</option>
                     <option>Italy</option>
                     <option>Jamaica</option>
                     <option>Japan</option>
                     <option>Jordan</option>
                     <option>Kazakhstan</option>
                     <option>Kenya</option>
                     <option>Korea</option>
                     <option>Kyrgyzstan</option>
                     <option>Kuwait</option>
                     <option>Latvia</option>
                     <option>Lebanon</option>
                     <option>Libya</option>
                     <option>Liechtenstein</option>
                     <option>Lithuania</option>
                     <option>Luxembourg</option>
                     <option>Macedonia</option>
                     <option>Madagascar</option>
                     <option>Malawi</option>
                     <option>Malaysia</option>
                     <option>Malta</option>
                     <option>Martinique</option>
                     <option>Mauritania</option>
                     <option>Mauritius</option>
                     <option>Mexico</option>
                     <option>Moldova</option>
                     <option>Monaco</option>
                     <option>Montenegro</option>
                     <option>Morocco</option>
                     <option>Mozambique</option>
                     <option>Myanmar</option>
                     <option>Namibia</option>
                     <option>Nepal</option>
                     <option>Netherlands</option>
                     <option>Netherlands Antilles</option>
                     <option>New Zealand</option>
                     <option>Nicaragua</option>
                     <option>Niger</option>
                     <option>Nigeria</option>
                     <option>Norway</option>
                     <option>Oman</option>
                     <option>Pakistan</option>
                     <option>Palestinian Territory, Occupied</option>
                     <option>Panama</option>
                     <option>Papua New Guinea</option>
                     <option>Paraguay</option>
                     <option>Peru</option>
                     <option>Philippines</option>
                     <option>Poland</option>
                     <option>Portugal</option>
                     <option>Puerto Rico</option>
                     <option>Qatar</option>
                     <option>Reunion</option>
                     <option>Romania</option>
                     <option>Russian Federation</option>
                     <option>Rwanda</option>
                     <option>Saint Kitts and Nevis</option>
                     <option>Saint Pierre and Miquelon</option>
                     <option>Saint Vincent and the Grenadines</option>
                     <option>San Marino</option>
                     <option>Saudi Arabia</option>
                     <option>Senegal</option>
                     <option>Serbia</option>
                     <option>Singapore</option>
                     <option>Slovakia</option>
                     <option>Slovenia</option>
                     <option>Somalia</option>
                     <option>South Africa</option>
                     <option>Spain</option>
                     <option>Sri Lanka</option>
                     <option>Swaziland</option>
                     <option>Sweden</option>
                     <option>Switzerland</option>
                     <option>Taiwan</option>
                     <option>Tajikistan</option>
                     <option>Tanzania, United Republic of </option>
                     <option>Thailand</option>
                     <option>Tunisia</option>
                     <option>Turkmenistan</option>
                     <option>Turkey</option>
                     <option>Uganda</option>
                     <option>Ukraine</option>
                     <option>United Arab Emirates</option>
                     <option>United Kingdom</option>
                     <option>Uruguay</option>
                     <option>Uzbekistan</option>
                     <option>Vatican City State (Holy See)</option>
                     <option>Venezuela</option>
                     <option>Vietnam</option>
                     <option>Virgin Islands (British)</option>
                     <option>Virgin Islands (U.S.)</option>
                     <option>Zambia</option>
                     <option>Zimbabwe</option>
                  </select>
				  <span class="radio-required-message"></span>
                  <label class=" EELabel" for="language_spoken"><span class="mandatoryfield"></span><span id="labelLanguagesSpoken"></span></label>
                  <select class="form_EE_select" name="language_spoken" id="language_spoken" multiple="true"  class="form-control" title="Hold down &quot;Ctrl&quot; key to select multiple items">
                  </select>
				  <span class="radio-required-message"></span>
                  <label class=" EELabel" for="other_languages"><span id="labelOtherLanguage"></span></label>
                  <input type="text" class="form_EE" name="other_languages" id="other_languages" value="" size="46" maxlength="100" class="input_txt">
                  <label class=" EELabel" for="community_id"><span id="labelCommunityUserId"></span></label>
                  <input type="text" class="form_EE" name="community_id" id="community_id" value="" size="46" maxlength="100" class="input_txt">
                  <label class=" EELabel radio-button-label" for="is_autodesk_reseller"><span class="mandatoryfield"></span><span class="labelPart1" id="doYouWorkForAnAutodeskReseller"></span><span class="labelPart2"><span id="workForAnAutodeskReseller"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="is_autodesk_reseller" value="Yes"><span id="labelYesAutodeskReseller"></span>
                  <br>
                  <input type="radio" name="is_autodesk_reseller" value="No"><span id="labelNoAutodeskReseller"></span>
                  <br>
                  <label class=" EELabel" for="reseller_name"><em class="italic"><span id="nameTheReseller"></span></em></label>
                  <input type="text" class="input_txt form_EE is_autodesk_reseller_other" name="reseller_name" id="reseller_name" value="" size="46" maxlength="50" disabled>
				  <span class="radio-required-message"></span>
                  <label class=" EELabel radio-button-label" for="is_part_of_autodesk_student"><span class="mandatoryfield"></span><span class="labelPart1" id="areYouPartOfStudentEducatorProgram"></span><span class="labelPart2"><span id="partOfStudentEducatorProgram"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="is_part_of_autodesk_student" value="Yes"><span id="labelYesAutodeskStudent"></span>
                  <br>
                  <input type="radio" name="is_part_of_autodesk_student" value="No"><span id="labelNoAutodeskStudent"></span>
                  <br>
                  <!-- <label class=" EELabel" for="edirectory">Would like to be included in the Expert Elite Directory (only viewable by Expert Elilte members)?</label>
                     <input type="radio" name="edirectory" value="Yes">
                     Yes<br>
                     <input type="radio" name="edirectory" value="No">
                     No<br> -->
					 
				  <label class=" EELabel" for="proficiency"><span class="mandatoryfield"></span><span id="proficiencyInAutodeskProducts"></span></label>
                  <select class="form_EE_select" name="proficiency" class="form-control" id="proficiency" class="single" multiple title="Hold down &quot;Ctrl&quot; key to select multiple items">
                     
                  </select>
				  <span class="radio-required-message"></span>
                  <label class="EELabel" for="other_proficiency"><span id="other"></span></label>
                  <input type="text" class="form_EE" name="other_proficiency" id="other_proficiency" value="" size="46" maxlength="100" class="input_txt">      
                   <div class="SocialMediaWrapper">
					  <div class="socialFieldWrapper header-part">
						 <span class="SocialMediaLabel"><span id="socialMedia"></span></span>
						 <span><span id="nameHandleUrl"></span></span>
					  </div>
					  <div class="allSocialMediaFieldsWrapper">
					  </div>
				  </div>
               </div>
               <div class="neform-second-col">
                  <label class=" EELabel radio-button-label" for="is_promote_autodesk_help"> <span class="mandatoryfield"></span><span class="labelPart1" id="doYouPromoteHelpProductSolution"></span><span class="labelPart2"><span id="promoteHelpProductSolution"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="is_promote_autodesk_help" value="Yes"><span id="labelYesPromoteAutodeskHelp"></span>
                  <br>
                  <input type="radio" name="is_promote_autodesk_help" value="No"><span id="labelNoPromoteAutodeskHelp"></span>
                  <br>
                  <label class=" EELabel" for="promote_autodesk_help_details"><em class="italic"><span id="provideExamplesOrUrls"></span></em></label>
                  <textarea type="text" class="input_txt is_promote_autodesk_help_other" name="promote_autodesk_help_details" id="promote_autodesk_help_details" value="" size="46" maxlength="1000" disabled></textarea>
				  <span class='radio-required-message' ></span>
                  <label class=" EELabel radio-button-label" for="created_product_articles"><span class="mandatoryfield"></span><span class="labelPart1" id="doYouCreateArticlesVideosWebinars"></span><span class="labelPart2"><span id="createArticlesVideosWebinars"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="created_product_articles" value="Yes"><span id="labelYesProductArticles"></span>
                  <br>
                  <input type="radio" name="created_product_articles" value="No"><span id="labelNoProductArticles"></span>
                  <br>
                  <label class=" EELabel" for="created_product_articles_details"><em class="italic"><span id="provideExamplesOrUrlsWebinar"></span></em></label>
                  <textarea type="text" class="input_txt created_product_articles_other" name="created_product_articles_details" id="created_product_articles_details" value="" size="46" maxlength="1000" disabled></textarea>
				  <span class='radio-required-message' ></span>
                  <!-- Newly added field screencast start-->
                  <label class=" EELabel radio-button-label" for="doProvideAutodPrdTipSolScreencast"><span class="mandatoryfield"></span><span class="labelPart1" id="doYouProductTipUsingScreencast"></span><span class="labelPart2"><span id="productTipUsingScreencast"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="doProvideAutodPrdTipSolScreencast" value="Yes"><span id="labelYesTipSolScreencast"></span>
                  <br>
                  <input type="radio" name="doProvideAutodPrdTipSolScreencast" value="No"><span id="labelNoTipSolScreencast"></span><br>
                  <label class=" EELabel" for="autodPrdTipSolScreencastUrl"><em class="italic"><span id="provideExamplesOrUrlsScreencast"></span></em></label>
                  <textarea type="text" class="input_txt doProvideAutodPrdTipSolScreencast_other" name="autodPrdTipSolScreencastUrl" id="autodPrdTipSolScreencastUrl" value="" size="46" maxlength="1000" disabled></textarea>
				  <span class='radio-required-message' ></span>
                  <!-- Newly added field screencast end-->
                  <label class=" EELabel radio-button-label" for="blog_contribution"><span class="mandatoryfield"></span><span class="labelPart1" id="doYouContributeToBlogWebsite"></span><span class="labelPart2"><span id="contributeToBlogWebsite"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="blog_contribution" value="Yes"><span id="labelYesBlogContribution"></span>
                  <br>
                  <input type="radio" name="blog_contribution" value="No"><span id="labelNoBlogContribution"></span>
                  <br>
                  <label class=" EELabel" for="blog_contribution_urls"><em class="italic"><span id="provideUrls"></span></em></label>
                  <textarea type="text" class="input_txt blog_contribution_other" name="blog_contribution_urls" id="blog_contribution_urls" value="" size="46" maxlength="1000" disabled></textarea>
				  <span class='radio-required-message' ></span>
                  <label class=" EELabel radio-button-label" for="is_part_of_lead_product_group"><span class="mandatoryfield"></span><span class="labelPart1" id="doYouParticipateInLeadProductUserGroups"></span><span class="labelPart2"><span id="participateInLeadProductUserGroups"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="is_part_of_lead_product_group" value="Yes"><span id="labelYesLeadProductGroup"></span>
                  <br>
                  <input type="radio" name="is_part_of_lead_product_group" value="No"><span id="labelNoLeadProductGroup"></span>
                  <br>
                  <label class=" EELabel" for="lead_product_group_details"><em class="italic"><span id="provideDetails"></span></em></label>
                  <textarea type="text" class="input_txt is_part_of_lead_product_group_other" name="lead_product_group_details" id="lead_product_group_details" value="" size="46" maxlength="1000" disabled></textarea>
				  <span class='radio-required-message' ></span>
                  <label class=" EELabel radio-button-label" for="is_speaker"><span class="mandatoryfield"></span><span class="labelPart1" id="areYouSpeakerAtAutodeskEvents"></span><span class="labelPart2"><span id="speakerAtAutodeskEvents"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="is_speaker" value="Yes"><span id="labelYesIsSpeaker"></span>
                  <br>
                  <input type="radio" name="is_speaker" value="No"><span id="labelNoIsSpeaker"></span>
                  <br>
                  <label class=" EELabel" for="speaker"><em class="italic"><span id="provideInformation"></span></em></label>
                  <textarea type="text" class="input_txt is_speaker_other" name="speaker_information" id="speaker_information" value="" size="46" maxlength="1000" disabled></textarea>
				  <span class='radio-required-message' ></span>
                  <label class=" EELabel radio-button-label" for="partcipated_in_gushlinger"><span class="mandatoryfield"></span><span class="labelPart1" id="doYouParticipateInGunslingerEvents"></span><span class="labelPart2"><span id="participateInGunslingerEvents"></span></span><span class='radio-required-message'></span> </label>
                  <input type="radio" name="partcipated_in_gushlinger" value="Yes"><span id="labelYesGunslinger"></span>
                  <br>
                  <input type="radio" name="partcipated_in_gushlinger" value="No"><span id="labelNoGunslinger"></span>
                  <br>
                  <label class=" EELabel" for="gushlinger_details"><em class="italic"><span id="provideDetailsGunslingerEvent"></span></em></label>
                  <textarea type="text" class="input_txt partcipated_in_gushlinger_other" name="gushlinger_details" id="gushlinger_details" value="" size="46" maxlength="1000" disabled></textarea>
				  <span class='radio-required-message' ></span>
                  
				  <!----------------adding certification field : Start------>
				  <label class=" EELabel" for="autodeskCertification"><span id="autodeskCertifications"></span></label>
                  <textarea id="autodeskCertification" class="input_txt" maxlength="1000" > </textarea>
				  <!----------------adding certification field : Stop------>
				  
				  <label class=" EELabel" for="additional_comments"><span id="additionalCommentsAboutCandidate"></span></label>
                  <textarea id="additional_comments" class="input_txt" maxlength="2500" > </textarea>
                  <br>
                  <br>
                  <div>
                     <button class="btn-brand " id="submitbtn"><span id="submitButton"></span></button>
                     <!-- <a class="btn-brand " id="cancelbtn" href="/t5/expert-elite-lounge/bd-p/1976">CANCEL</a> -->
                  </div>
                  <p></p>
               </div>
            </div>
         </div>
         <div class="serverResponceSuccess-wrapper">
            <div class="serverResponceSuccess-message">
               <span id="thankYouMessage"></span>
            </div>
         </div>
      </div>
   </body>
</html>