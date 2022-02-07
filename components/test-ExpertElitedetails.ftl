<#-- Compoent Details : used to show the EE Memeber profile with Admin and EEmember View -->
<#-- "EE Admin View-only" can see all the content avliable to admin Except update button-->
<#assign admin = false />
<#assign EEMember = false />
<#assign adminViewOnly = false />

<#assign EEMemberAdmin = false />


<#attempt>
  <#assign communityUserIdFromUrl = http.request.parameters.name.get("Id")?html /> 
<#recover>
  <#assign communityUserIdFromUrl = user.login />
</#attempt>

<#attempt>
  <#assign cancelButtonLink = http.request.parameters.name.get("callback")?html /> 
<#recover>
  <#assign cancelButtonLink = coreNode.webUi.url />
</#attempt>


<#list restadmin("/users/id/${user.id?c}/roles").roles.role as role>
  <#if role.name?? && (role.name == "Administrator" || role.name == "Expert Elite Admin" || role.name == "EE Admin View-only")  >
    <#assign admin = true  />
  </#if>
  <#if role.name?? && (role.name == "Expert Elite") >
    <#assign EEMember = true  />
  </#if>
  <#if role.name?? && (role.name == "EE Admin View-only") >
    <#assign adminViewOnly = true  />
  </#if>
  
  <#if role.name?? && (role.name == "Expert Elite Admin" || role.name == "Expert Elite") >
    <#assign EEMemberAdmin = true  />
  </#if>
  
</#list>

<#-----rest call to get preferred language of the current user---->
<#assign pref_lang = restadmin("/users/id/${user.id?c}/settings/name/profile.language").value />


<#if admin || (EEMember && user.login == communityUserIdFromUrl) >

	<#-------------Get Base URL as per environment :Start ------------------------>
	<#assign env = config.getString("phase", "prod") />

	<#if env == "stage" || env == "dev" >
	<#if env == "stage" || env == "dev">
		<#assign expertelite_endpoint="/plugins/custom/autodesk/autodesk/expertelite-userdetails"/>
	<#else>
		<#assign expertelite_endpoint="/plugins/custom/autodesk/autodesk/expertelite-userdetails"/>
	</#if>
	
	<#assign autodesk_ee_vm_baseurl = "https://autoeeprod.autodesk.com/AutodeskExpertElite_dev" />
	
<#else>
	<#assign autodesk_ee_vm_baseurl = "https://autoeeprod.autodesk.com/AutodeskExpertElite" />
	<#assign expertelite_endpoint="/plugins/custom/autodesk/autodesk/expertelite-userdetails"/>
</#if>


Base URL : ${autodesk_ee_vm_baseurl}
	<#-------------Get Base URL as per environment :End ------------------------>
	
    <#if admin>
      <#assign userType = "admin" />
    <#else>
      <#assign userType = "ee" />
    </#if>

    <script src='${asset.get("/html/assets/jquery-3.4.1.min.js")}'></script>

    <link rel="stylesheet" href="${asset.get('/html/assets/bootstrap.min.css')}">
    <script src="${asset.get('/html/assets/bootstrap.min.js')}"></script>
    
    <link href="${asset.get('/html/assets/datepicker.css')}" rel="stylesheet" type="text/css" />
    <script src="${asset.get('/html/assets/bootstrap-datepicker.js')}"></script>

    <script src="${asset.get('/html/assets/base64EncodeDecode.js')}"></script>

    <@liaAddScript>
	
	



	
	
      ;(function($) {
	  
	  <!--------------adding select field values 1.autodesk products 2.au las vegag 3.ee summit: sprint2 : Start---->
	  function setSelectProductFieldOptions(selectFieldID,options)
	  {
		//options are in array
		var optionsDOM = "";
		
		for(var i=0; i<options.length; i++)
		{
			optionsDOM = optionsDOM + "<label style=\"display:block;\"><input type=\"checkbox\" name=\"product\" value='"+options[i]+"'/>&nbsp;&nbsp;" + options[i] + "</label>";
		}
		$("#"+selectFieldID).html(optionsDOM);
				
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
	  
	  
	  function setSocialMediaFields(socialMediaChannel)
	  {
		var socialMediaDOM = "";
		for(var i=0;i<socialMediaChannel.length;i++)
		{
			var socialMediaChannelId = socialMediaChannel[i];
					if(i == socialMediaChannel.length - 1){
						socialMediaChannelId = "other_channels";
					}
			socialMediaDOM = socialMediaDOM + "<tr><td><label class='SocialMediaPresenceLabel'>"+socialMediaChannel[i]+"</label></td><td>&nbsp;&nbsp;&nbsp;</td><td><input class='SocialMediaPresenceInput input_txt' maxlength='200' id='"+socialMediaChannelId.toLowerCase().replace(" ","_")+"'></td></tr>"
		}
		$("tr.socialMediaHeaderWrapper").after(socialMediaDOM);
	  }
	  
	  <!--------------adding select field values 1.autodesk products 2.au las vegag 3.ee summit : sprint2 : End---->

      var username = "admin";
      var password = "admin";

      var payload = {};
      var dirtyField = false;

      var payload_temp = {};

      var timeStamp1,timeStamp2;


      //ajax call thrird party to get user details
      //var getEEMemberDetails = "${autodesk_ee_vm_baseurl}/expertelite/nominee/id/${communityUserIdFromUrl}";

      var getEEMemberDetails = "${autodesk_ee_vm_baseurl}/expertelite/nominee/id/${communityUserIdFromUrl}?language=${pref_lang}";

      //var getEEMemberDetails =  "http://autodwebservice.persistent.co.in:8080/AutodeskExpertElite/rest/nominee/id/19"
      console.log("get Member Details URL  =>  " + getEEMemberDetails);
      console.log("userType => ${userType}");
      //console.log("------------------Header------------------");
      console.log("Authorization = Basic " + Base64.encode(username + ":" + password));
      
      timeStamp1 = new Date();

      $.ajax({
        type: "GET",
        crossDomain: true,
        url: getEEMemberDetails,
        dataType: "json",
        async: false,
        cache: false,
        beforeSend: function(xhr1) {
          xhr1.setRequestHeader("Authorization", "Basic " + Base64.encode(username + ":" + password));
          xhr1.setRequestHeader("User-Type", "${userType}");

        },
        success: function(data, status, xhr) {
          //do something
		  
          timeStamp2 = new Date();
          //console.log("Time require /expertelite/nominee/id/ call "+(timeStamp2 - timeStamp1)/1000+" Sec");
          //console.log("userdetails call success");
          
          if(data.status == "success" && data.hasOwnProperty("personalDetails"))
          {
			//Setting select field - function calling with config call data
			setSelectFieldOptions("attended_au_las_vegas",data.attendedAuLasVegasList.attendedAULasVegasYearList);
			setSelectFieldOptions("attended_ee_summit",data.attendedEESummitYearProperties.attendedEESummitYearList);
			setSelectProductFieldOptions("select_autodesk_proficiency",data.productProficiencyProperties.productListProperties);
			//setSelectFieldOptions("select_autodesk_proficiency",data.productProficiencyProperties.productListProperties);
			//setting social Media dom using setSocialMediaFields function
			setSocialMediaFields(data.socialMediaPresenceProperties.socialMediaPresenceList);
			
            payload_temp.submitterFullName = data.personalDetails.submitterFullName;
			payload_temp.nominationSubmissionDate = data.personalDetails.nominationSubmissionDate;
            payload_temp.isSubmitterEEMember = data.personalDetails.isSubmitterEEMember;
            payload_temp.memberStatus = data.proficiency.memberStatus;
            payload_temp.autodeskCommunityUserId = data.personalDetails.autodeskCommunityUserId;
			
			
            //console.log("Member Status "+payload_temp.memberStatus);
			
            setFormFields(data);
            <#if admin>
              getUserStats(data.personalDetails.autodeskCommunityUserId);
            </#if>
          }
          else
          {
            //console.log("Error in responce"+data);
          }
        },
        error: function(e) {
          //console.log("error" + e);
        }
      });

      <#if admin>
      function addRemoveRole () {
        
        //console.log("forumId=>"+data.personalDetails.autodeskCommunityUserId);
        //console.log("add remove role function");
        var autodeskUserId = $("#forum_user_id").val();
		 var email = $("#email").val();
        autodeskUserId = autodeskUserId.split(",");
        autodeskUserId = autodeskUserId[0];
		
        var addRemoveRoleURL = "/plugins/custom/autodesk/autodesk/autodesk.ee.add.remove.expert_elite.role?userId="+autodeskUserId+"&email="+email;
		//console.log(addRemoveRoleURL);
        var status = $("#member_status").val();
        var changeRole = false;

        if(status == "EE Active")
        {
          addRemoveRoleURL = addRemoveRoleURL + "&roleAction=add";
          changeRole = true;
        }
        else if(status == "EE no longer active")
        {
          addRemoveRoleURL = addRemoveRoleURL + "&roleAction=remove";
          changeRole = true;
        }
        if(changeRole)
        {
          timeStamp1 = new Date();

          $.ajax({
            url: addRemoveRoleURL,
            dataType: "json",
            async: false,
            cache: false,
            success: function(result) {   
              timeStamp2 = new Date();
              //console.log("Time require /autodesk/autodesk.ee.add.remove.expert_elite.role call "+(timeStamp2 - timeStamp1)/1000+" Sec");
              //console.log(result.RegistrationDate);
              if(result.status == "successAdd")
              {
                //console.log("Expert Elite Role added sucessfully");
                payload_temp.memberStatus = status;
                $("#success-role-change").css('display','block');
              }
              else if(result.status == "successRemove")
              {
                //console.log("Expert Elite Role removed sucessfully"); 
                payload_temp.memberStatus = status;
                $("#success-role-change").css('display','block');
              }
              else
              {
                //console.log("Role change : Error");
              }
            },
            error: function () {
              //console.log("Role change : Error");
              //console.log(e);
            }
          });
        }
      }
      

      //call this function on sucess of get call from third party. and pass user id to this function
      function getUserStats(forumId) {
        timeStamp1 = new Date();

        if(forumId != null){
          //forumId = forumId.split(","); replaced the Autodesk community user id with id
          forumId = forumId;
        }
         var email = $("#email").val();        

        $.ajax({
          url: "${expertelite_endpoint}?communityIds="+forumId+"&email="+email,
          dataType: "json",
          cache: false,
          success: function(result) {
            timeStamp2 = new Date();
            //console.log("Time require /autodesk/expertelite-userdetails call "+(timeStamp2 - timeStamp1)/1000+" Sec");
            //console.log(result.RegistrationDate);

            $("#forum_rank_position").text(result[0].RankPosition);
            $("#registartion_date").text(result[0].RegistrationDate);
            $("#most_recent_login").text(result[0].MostRecentLogin);
            $("#net_boards_replies").text(result[0].NetBoardsReplies);
            $("#accepted_solutions").text(result[0].AcceptedSolutions);
            $("#net_kudos_recieved").text(result[0].NetKudosReceived);
            $("#net_kudos_given").text(result[0].NetKuodsGiven);
            $("#net_forum_topics").text(result[0].NetForumTopics);
            $("#posts").text(result[0].NetForumPosts);
          }
        });
      }

      </#if>

      <#if admin>
        $("#forum_user_id").blur(function(){
			//regarding role add and remove action: user id field should not be blank
			var memberStatus = $("#member_status").val();
          if( $("#forum_user_id").val() == "" &&  ( memberStatus == "EE Active" || memberStatus == "EE no longer active" ) ){
            $("#forum_user_id").addClass("borderclass");
          }       
          else{
            $("#forum_user_id").removeClass("borderclass");
          }
        }); 

        $("#member_status").change(function(){
          $("#forum_user_id").blur();
        });

      </#if>

      //#forum_user_id commenting
      $("#candidate_first_name,#candidate_last_name,#email,#address1,#city,#country,#community_rank_position").blur(function() {
        if ($(this).val().trim().length == 0) {
          $(this).addClass('borderclass');
        } else {
          $(this).removeClass('borderclass');
        }
      });
	  
	  <#-- Fields mandatory for ee member only : sprint2 : start--->
	  <#if EEMember>
		$("#shirt_size").blur(function() {
			if ($(this).val().trim().length == 0) {
			  $(this).addClass('borderclass');
			} else {
			  $(this).removeClass('borderclass');
			}
		});
	  </#if>
	  <#-- Fields mandatory for ee member only : sprint2 : start--->
	
      //if yes field - blur events 
      $("input[type='radio']").each(function () {
        var radioGrpName = $(this).attr('class');
        $("textarea."+radioGrpName+"_other").blur(function(){
          if($("input."+radioGrpName+":checked").val() == "true" && $("textarea."+radioGrpName+"_other").val()=="") 
          {
            $("textarea."+radioGrpName+"_other").addClass("borderclass");
          }
          else
          {
            $("textarea."+radioGrpName+"_other").removeClass("borderclass");
          }
        });
      });

      //multiselect with other fields blur event
      $("#languages,#other_languages").blur(function () {
        if ($("#languages").val() != null || $("#other_languages").val() != "") {
          $("#languages").removeClass('borderclass');
        } else {
          $("#languages").addClass('borderclass');
        } 
		
      });

      $("#select_autodesk_proficiency,#other_proficiency").blur(function () {
        if ($("#select_autodesk_proficiency").val() != null || $("#other_proficiency").val() != "") {
          $("#select_autodesk_proficiency").removeClass('borderclass');
        } else {
          $("#select_autodesk_proficiency").addClass('borderclass');
        } 
      });

      //for number field jQuery 
      $("#collapse5 input[type=text]").keypress(function (e) { 
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57) ) {
          return false;
        }
      });



      $('#updatebtn').click(function() {

        //console.log("update button clicked");
        $("#no-change-message").hide();
        $("#success-message").hide();
        $("#success-role-change").hide();
        $("#error-message").hide();
		
		
		 var languagesSpoken = [];
		  var autodesk_proficiency = [];
		  var language_checkboxes;
		  var product_checkboxes;
		  
		  language_checkboxes = $("#languages").find("input:checkbox");
		  product_checkboxes = $("#select_autodesk_proficiency").find("input:checkbox");
	  
		  language_checkboxes.each(function() {		
			var checkbox = $(this);
			if(checkbox.prop("checked")){
				languagesSpoken.push(checkbox.val());
			}				
		  });
			
	     if ($("#other_languages").val() != "") {
              languagesSpoken.push($("#other_languages").val());
          }
	
          
          
		  product_checkboxes.each(function() {		
			var checkbox = $(this);
			if(checkbox.prop("checked")){
				autodesk_proficiency.push(checkbox.val());
			}				
		  });
		  
		  if ($("#other_proficiency").val() != "") {
            autodesk_proficiency.push($("#other_proficiency").val());
          }
		
		
		
		
		
		
		

        var validation;
        var tab1Validation,tab2Validation, email2Validation;

        //&& $("#forum_user_id").val() != "" commenting this
		//Shirt size is manadatory for eemember only
		
        if($("#candidate_first_name").val() != "" && $("#candidate_last_name").val() != "" && $("#email").val() != "" && regex.test(component.input.val()) && $("#address1").val() != "" && $("#city").val() != "" && $("#country").val() != "" && languagesSpoken!="" <#if EEMember> && $("#shirt_size").val() != "" </#if> && $('input[name=is_autodesk_reseller]:checked').length > 0 && $('input[name=is_autodesk_student]:checked').length > 0)
        {
          tab1Validation= true;
        }
        else {
          tab1Validation= false;
        }
		
		if($("#email2").val() != "" && !regex.test(component2.input.val())){
			email2Validation= false;
		}else{
			email2Validation= true;
		}

        <#if admin>
			//regarding role add or remove action : user lid should not be blank
			var memberStatus = $("#member_status").val();
          if( ($("#forum_user_id").val() == "" &&  ( memberStatus == "EE Active" || memberStatus =="EE no longer active" ) ) || tab1Validation == false ) {
            tab1Validation = false;
          }       
          else{
            tab1Validation = true;
          }
        </#if>

        //reseller name validation
        var ifYesinputFiled = $("input[name='reseller_name']");
        if($('input[name=is_autodesk_reseller]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab1Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }


        if(autodesk_proficiency!="" &&$('input[name=do_you_promote_product]:checked').length > 0 &&$('input[name=prod_articles]:checked').length > 0 &&$('input[name=doProvideAutodPrdTipSolScreencast]:checked').length > 0 &&$('input[name=blog_contribution]:checked').length > 0 &&$('input[name=is_prod_user_groups_member]:checked').length > 0 &&$('input[name=is_speaker]:checked').length > 0 &&$('input[name=is_participated_gunslinger]:checked').length > 0)
        {
          tab2Validation= true;
        }
        else
        {
          tab2Validation= false;
        }

        //if yes filed validation  name validation
        
        //1
        ifYesinputFiled = $("textarea[name='promote_url']");
        if($('input[name=do_you_promote_product]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab2Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }

        //2
        ifYesinputFiled = $("textarea[name='prod_articles_url']");
        if($('input[name=prod_articles]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab2Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }

        //3
        ifYesinputFiled = $("textarea[name='autodPrdTipSolScreencastUrl']" );
        if($('input[name=doProvideAutodPrdTipSolScreencast]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab2Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }
        //4
        ifYesinputFiled =  $("textarea[name='blog_contribution_url']");
        if($('input[name=blog_contribution]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab2Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }
        //5
        ifYesinputFiled = $("textarea[name='is_prod_user_groups_member_details']");
        if($('input[name=is_prod_user_groups_member]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab2Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }
        //6
        ifYesinputFiled = $("textarea[name='speaker_information']");
        if($('input[name=is_speaker]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab2Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }
        //7
        ifYesinputFiled = $("textarea[name='gushlinger_details']");
        if($('input[name=is_participated_gunslinger]:checked').val() == "true" && ifYesinputFiled.val()==""){
          tab2Validation= false;
          ifYesinputFiled.addClass("borderclass");
        }
        else{
          ifYesinputFiled.removeClass("borderclass");
        }
        //end: if yes filed validation
	//console.log("tab1Validation : "+tab1Validation);
        if (tab1Validation && tab2Validation && email2Validation) {
          $("#error").html("");
          validation = "valid";

        } else {
          validation = "invalid";
        }


        //radio-button adding - removing required message
        var optionalRadioButtons = ["Send_EE_Communications","include_in_directory","featured_member"];

        $("input[type='radio']").each(function () {
          var radioGrpName = $(this).attr('name');
          if(optionalRadioButtons.indexOf(radioGrpName) == -1)
          {  
            if($("input[name="+radioGrpName+"]:checked").val() == undefined)
            {
                //console.log("----radio btn name---"+radioGrpName);
                $("."+radioGrpName+"_radio-required-message").html("${text.format('autodesk.ee.required-field')}");
            }
            else
            {
                $("."+radioGrpName+"_radio-required-message").html(""); 
            }
          }  
        });



        if ($("#candidate_first_name").val() == "") {
          $("#candidate_first_name").addClass('borderclass');
        } else {
          $("#candidate_first_name").removeClass('borderclass');
        }
        if ($("#candidate_last_name").val() == "") {
          $("#candidate_last_name").addClass('borderclass');
        } else {
          $("#candidate_last_name").removeClass('borderclass');
        }
        if ($("#email").val() == "" || !regex.test(component.input.val()) ) {
          $("#email").blur();
        } else {
          $("#email").removeClass('borderclass');
        }
	
        if ($("#city").val() == "") {
          $("#city").addClass('borderclass');
        } else {
          $("#city").removeClass('borderclass');
        }
        if (languagesSpoken!="") {
          
		  $("#languages").css('border','1px solid #ccc');
		  //console.log("borderclass remove");
        } else {
			$("#languages").css('border','1px solid red');
          
		  //console.log("borderclass add");
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
        //if($("#klout_score").val()==""){$("#klout_score").addClass('borderclass'); }else{ $("#klout_score").removeClass('borderclass');}
        if ($("#community_rank_position").val() == "") {
          $("#community_rank_position").addClass('borderclass');
        } else {
          $("#community_rank_position").removeClass('borderclass');
        }

        <#if admin>
          $("#forum_user_id").blur();
        </#if>

		//Shirt Size is manadatory for ee member only
		<#if EEMember>
        if ($("#shirt_size").val() == "") {
          $("#shirt_size").addClass('borderclass');
        } else {
          $("#shirt_size").removeClass('borderclass');
        }
		</#if>
		
		if(autodesk_proficiency!=""){
			$("#select_autodesk_proficiency").css('border','1px solid #ccc');
		}else{
			$("#select_autodesk_proficiency").css('border','1px solid red');
		}
		
        


        if (validation == "valid") {

          //console.log("details are valid");
         

          var social_media_presence = [];
          $(".SocialMediaPresenceInput").each(function(){
            if($(this).val() != "")
            {
              social_media_presence.push( {"name":this.id,"handle":$(this).val()} );
            }
          });
          //console.log(JSON.stringify(social_media_presence));

          var attended_au_las_vegas = [];
          if ($("#attended_au_las_vegas").val() != null) {
            attended_au_las_vegas = $("#attended_au_las_vegas").val();
          }
          if ($("#other_au").val() != "") {
            attended_au_las_vegas.push($("#other_au").val());
          }

          var attended_ee_summit = [];
          if ($("#attended_ee_summit").val() != null) {
            attended_ee_summit = $("#attended_ee_summit").val();
          }
          if ($("#other_summit").val() != "") {
            attended_ee_summit.push($("#other_summit").val());
          }


          var ee_mentor = [];
          if ($("#ee_mentor").val() != null) {
            ee_mentor.push($("#ee_mentor").val());
          }
          if ($("#other_mentor").val() != "") {
            ee_mentor.push($("#other_mentor").val());
          }
		  
		  
		  //Radio button fields updation with details
		     
		  var isSubmitterEEMember;
          if ($('input[name=isSubmitterEEMember]:checked').length > 0) {
            if ($('input[name=isSubmitterEEMember]:checked').val() == "true") {
              isSubmitterEEMember = true;
            } else if ($('input[name=isSubmitterEEMember]:checked').val() == "false"){
              isSubmitterEEMember = false;
            }
          }


          var is_autodesk_reseller;
          var reseller_name;
          if ($('input[name=is_autodesk_reseller]:checked').length > 0) {
            if ($('input[name=is_autodesk_reseller]:checked').val() == "true") {
              is_autodesk_reseller = true;
              reseller_name = $("#reseller_name").val();
            } else {
              is_autodesk_reseller = false;
              reseller_name = "";
            }
          }

          var is_autodesk_student;
          if ($('input[name=is_autodesk_student]:checked').length > 0) {
            if ($('input[name=is_autodesk_student]:checked').val() == "true") {
              is_autodesk_student = true;
            } else {
              is_autodesk_student = false;
            }
          }
          var Send_EE_Communications;
          if ($('input[name=EE_Communications]:checked').length > 0) {
            if ($('input[name=EE_Communications]:checked').val() == "true") {
              Send_EE_Communications = true;
            } else {
              Send_EE_Communications = false;
            }
          }  
          var include_in_directory;
          if ($('input[name=include_in_directory]:checked').length > 0) {
            if ($('input[name=include_in_directory]:checked').val() == "true") {
              include_in_directory = true;
            } else if ($('input[name=include_in_directory]:checked').val() == "false"){
              include_in_directory = false;
            }
          }
          var featured_member;
          if ($('input[name=featured_member]:checked').length > 0) {
            if ($('input[name=featured_member]:checked').val() == "true") {
              featured_member = true;
            } else if($('input[name=featured_member]:checked').val() == "false"){
              featured_member = false;
            }
          }

          var do_you_promote_product;
          var promote_url;
          if ($('input[name=do_you_promote_product]:checked').length > 0) {
            if ($('input[name=do_you_promote_product]:checked').val() == "true") {
              do_you_promote_product = true;
              promote_url = ($("#promote_url").val());
            } else {
              do_you_promote_product = false;
              promote_url = "";
            }
          }

          var prod_articles;
          var prod_articles_url;
          if ($('input[name=prod_articles]:checked').length > 0) {
            if ($('input[name=prod_articles]:checked').val() == "true") {
              prod_articles = true;
              prod_articles_url = ($("#prod_articles_url").val());
            } else {
              prod_articles = false;
              prod_articles_url = "";
            }
          }

          var doProvideAutodPrdTipSolScreencast;
          var autodPrdTipSolScreencastUrl;
          if ($('input[name=doProvideAutodPrdTipSolScreencast]:checked').length > 0) {
            if ($('input[name=doProvideAutodPrdTipSolScreencast]:checked').val() == "true") {
              doProvideAutodPrdTipSolScreencast = true;
              autodPrdTipSolScreencastUrl = ($("#autodPrdTipSolScreencastUrl").val());
            } else {
              doProvideAutodPrdTipSolScreencast = false;
              autodPrdTipSolScreencastUrl = "";
            }
          }



          var blog_contribution;
          var blog_contribution_url;
          if ($('input[name=blog_contribution]:checked').length > 0) {
            if ($('input[name=blog_contribution]:checked').val() == "true") {
              blog_contribution = true;
              blog_contribution_url = ($("#blog_contribution_url").val());
            } else {
              blog_contribution = false;
              blog_contribution_url = "";
            }
          }
          var is_prod_user_groups_member;
          var is_prod_user_groups_member_details;
          if ($('input[name=is_prod_user_groups_member]:checked').length > 0) {
            if ($('input[name=is_prod_user_groups_member]:checked').val() == "true") {
              is_prod_user_groups_member = true;
              is_prod_user_groups_member_details = ($("#is_prod_user_groups_member_details").val());
            } else {
              is_prod_user_groups_member = false;
              is_prod_user_groups_member_details = "";
            }
          }
          var is_speaker;
          var speaker_information;
          if ($('input[name=is_speaker]:checked').length > 0) {
            if ($('input[name=is_speaker]:checked').val() == "true") {
              is_speaker = true;
              speaker_information = ($("#speaker_information").val());
            } else {
              is_speaker = false;
              speaker_information = "";
            }
          }

          var is_participated_gunslinger;
          var gushlinger_details;
          if ($('input[name=is_participated_gunslinger]:checked').length > 0) {
            if ($('input[name=is_participated_gunslinger]:checked').val() == "true") {
              is_participated_gunslinger = true;
              gushlinger_details = ($("#gushlinger_details").val());
            } else {
              is_participated_gunslinger = false;
              gushlinger_details = "";
            }
          }

          var community_id = "";
		  var submitterFullName = "";
		  var nominationSubmissionDate = "";
          <#if admin>
            community_id = $("#forum_user_id").val();
			submitterFullName =  $("#submitterFullName").val();
			nominationSubmissionDate =  $("#nominationSubmissionDate").val();
          <#else>
            community_id = payload_temp.autodeskCommunityUserId;
			submitterFullName =  payload_temp.submitterFullName;
			nominationSubmissionDate =  payload_temp.nominationSubmissionDate;
			isSubmitterEEMember = payload_temp.isSubmitterEEMember;
          </#if>
		  
		  
		  
		  

          payload = {
            "personalDetails": {
              "id": $("#id").val(),

              "submitterFullName": submitterFullName,
              "isSubmitterEEMember": isSubmitterEEMember,
			  "nominationSubmissionDate": nominationSubmissionDate,
			  
			  
              "firstName": $("#candidate_first_name").val(),
              "lastName": $("#candidate_last_name").val(),
              "email": $("#email").val(),
			  "email2": $("#email2").val(),
              "SendEECommunications": Send_EE_Communications,
              "phone": $("#phone_number").val(),
              "address1": $("#address1").val(),
              "address2": $("#address2").val(),
              "city": $("#city").val(),
              "stateOrProvince": $("#state").val(),
              "postalCode": $("#postal_code").val(),
              "country": $("#country").val(),
              "languageSpoken": languagesSpoken.join(","),
              "shirtSize": $("#shirt_size").val(),
              "autodeskCommunityUserId": community_id,
              "autodeskResellerName": reseller_name,
              "studentOrEducator": is_autodesk_student,
              "includeInEEDirectory": include_in_directory,
              "isNomWorkForAutodeskReseller": is_autodesk_reseller
            },
            "proficiency": {
              "nomineeId": $("#id").val(),
              "proficiencyInAutodeskProduct": autodesk_proficiency.join(","),
              "socialMediaPresence": social_media_presence,
              "doPromoteAutodeskHelp": do_you_promote_product,
              "autodHelpProductSolutionURL": promote_url,
              "doCreateProductArticlesVideosWebinars": prod_articles,
              "productArticleWebinarURL": prod_articles_url,
              "doProvideAutodPrdTipSolScreencast" : doProvideAutodPrdTipSolScreencast,
              "autodPrdTipSolScreencastUrl" : autodPrdTipSolScreencastUrl,
              "doContributeBlog": blog_contribution,
              "blogURL": blog_contribution_url,
              "doParticipateOrLeadAutodeskProduct": is_prod_user_groups_member,
              "participateLeadAutodeskProductUserGroupDetails": is_prod_user_groups_member_details,
              "isSpeaker": is_speaker,
              "speakerInfo": speaker_information,
              "doParticipateInGunslinger": is_participated_gunslinger,
              "gunslingerEventsDetails": gushlinger_details,
              "additionalComments": $("#ee_details_comments").val(),
			  "autodeskCertificatesDetails": $("#autodeskCertification").val()
              <#if admin > ,
              "attendedAuLasVegas": attended_au_las_vegas.join(","),
              "attendedEESummit": attended_ee_summit.join(","),
              "autodeskInternalNotes": $("#interna_notes").val(),
              "eeMentor": ee_mentor.join(","),
              "memberStatus": $("#member_status").val(),
              "dateJoinedProgram": $("#program_joined_date").val() 
              </#if>
            } 
            <#if admin > ,
            "valuePoints": {
              "nomineeId": $("#id").val(),
              "autodeskProficiency": $("#proficiency_point_value").val(),
              "socialMediaPresence": $("#social_media_point_value").val(),
              "productRelatedSolutions": $("#promote_autodesk_help_point_value").val(),
              "createProductArticlesVideosWebinars": $("#product_article_point_value").val(),
              "contributeBlogOrWebsite": $("#blog_contribute_point_value").val(),
              "participattionInOrLeadAutodeskProductUserGroups": $("#is_participated_in_lead_point_value").val(),
              "speakerAtAutodeskOrLocalCountryEvents": $("#is_speaker_point_value").val(),
              "participateInGunslinger": $("#participate_gunslinger_point_value").val(),
              "kloutScore": $("#klout_point_value").val(),
              "communityRankPosition": $("#community_rank_point_value").val(),
              "communityUserStat": $("#community_user_states_point_values").val(),
              "attendedAuLasVegas": $("#attended_au_point_value").val(),
              "attendedEESummit": $("#attended_summit_point_value").val(),
              "autodPrdTipSolScreencast" : $("#autodPrdTipSolScreencast_point_value").val()
            } 
            </#if>
          }

          //add if value present in UI then only push thease values to server
          if(typeof featured_member !== 'undefined')
          {
            payload.personalDetails['featuredMemberOnEEWebsite'] = featured_member;
          }
		  


          //console.log("payload created");

          var updateEEMemberDetails = "${autodesk_ee_vm_baseurl}/expertelite/nominee/update";
          //console.log("Update Member Details URL  =>  " + updateEEMemberDetails);
          //console.log("userType => ${userType}");
          


          if (dirtyField == true) {
            //console.log("doing ajax call");
            
            $('#updatebtn').attr('disabled','disabled');
            $(".loading-img").show();
            timeStamp1 = new Date();

            $.ajax({
              type: "POST",
              url: updateEEMemberDetails,
              dataType: "json",
              async: false,
              data: JSON.stringify(payload),
              beforeSend: function(xhr1) {
                xhr1.setRequestHeader("Authorization", "Basic " + Base64.encode(username + ":" + password));
                xhr1.setRequestHeader("User-Type", "${userType}");
                xhr1.setRequestHeader("Content-Type", "application/json");
              },
              success: function(data, status, xhr) {
                //do something
                if(data.status == "success")
                {

                  timeStamp2 = new Date();
                  //console.log("Time require /expertelite/nominee/update call "+(timeStamp2 - timeStamp1)/1000+" Sec");
                  //console.log("details updated successfully");
                  <#if admin>
                    if($("#member_status").val() != payload_temp.memberStatus)
                    {
                      addRemoveRole();
                    }
                  </#if>

                  $("#success-message").show();
                  window.scroll(0, 0);
                }
                else
                {
                  $("#error-message").show();
                  window.scroll(0, 0); 
                }
              },
              error: function(e) {
                //console.log("error", e);
                $("#error-message").show();
                window.scroll(0, 0);
              }
            }).done(function () {
              //console.log("update done function");
              $(".loading-img").hide();
              $('#updatebtn').removeAttr('disabled');
            });

            dirtyField = false;
          } else {
            //console.log("please change any field");
            $("#no-change-message").show();
            window.scroll(0, 0);
          }

        } else {
          if(!tab1Validation && !tab2Validation)
          {
            $("#error").html('${text.format('autodesk.ee.required-fields-member-product')}');
            //console.log("Please fill all Madatory fields");  
          }
          else if(!tab1Validation)
          {
            //console.log("Tab1 fileds are not filled");
            $("#error").html('${text.format('autodesk.ee.required-fields-member-info')}');
          }
          else if(!tab2Validation)
          {
            //console.log("Tab2 fields are not filled");
            $("#error").html('${text.format('autodesk.ee.required-fields-product')}');
          }
		  else if(!email2Validation)
		  {
			$("#error").html('Please enter valid email id for Email program communications field.');
		  }
          
          window.scroll(0, 0);
        }
      });


      $("#accordion a").click(function() {
        //console.log("accrodian anchor clicked");
        window.scroll(0, 0);
      });


      function setFormFields(payload1) {
        //console.log("reset click");        


        //if(payload1.length >0 && payload1 != undefined){

        $("#id").val(payload1.personalDetails.id);
        $("#candidate_first_name").val(payload1.personalDetails.firstName);
        $("#candidate_last_name").val(payload1.personalDetails.lastName);
        $("#email").val(payload1.personalDetails.email);
		$("#email2").val(payload1.personalDetails.email2);
        $("#phone_number").val(payload1.personalDetails.phone);
        $("#address1").val(payload1.personalDetails.address1);
        $("#address2").val(payload1.personalDetails.address2);
        $("#city").val(payload1.personalDetails.city);
        $("#state").val(payload1.personalDetails.stateOrProvince);
        $("#postal_code").val(payload1.personalDetails.postalCode);
        $("#country").val(payload1.personalDetails.country);
        
        $("#forum_user_id").val(payload1.personalDetails.autodeskCommunityUserId);
        <#if EEMember>
          //After field set : Making autodesk userid filed disable to EEmember
          $("#forum_user_id").prop( "disabled", true );
        </#if>

        $("#shirt_size").val(payload1.personalDetails.shirtSize);
		
		if(payload1.personalDetails.submitterFullName != null)
		{
			$("#submitterFullName").val(payload1.personalDetails.submitterFullName);
		}
		if (payload1.personalDetails.isSubmitterEEMember == true) {
          $('input[name=isSubmitterEEMember]').filter('[value=true]').prop('checked', true);
        } else if(payload1.personalDetails.isSubmitterEEMember == false){
          $('input[name=isSubmitterEEMember]').filter('[value=false]').prop('checked', true);
        }
		
		if(payload1.personalDetails.nominationSubmissionDate != null)
		{
			$("#nominationSubmissionDate").val(payload1.personalDetails.nominationSubmissionDate);
		}

        
        //database :SendEECommunications
        if (payload1.personalDetails.SendEECommunications == true) {
          $('input[name=Send_EE_Communications]').filter('[value=true]').prop('checked', true);
        } else if(payload1.personalDetails.SendEECommunications == false){
          $('input[name=Send_EE_Communications]').filter('[value=false]').prop('checked', true);
        }  
          
        //database :isNomWorkForAutodeskReseller
        if (payload1.personalDetails.isNomWorkForAutodeskReseller == true) {
          $('input[name=is_autodesk_reseller]').filter('[value=true]').prop('checked', true);
          $('#reseller_name').val(payload1.personalDetails.autodeskResellerName);
        } else if(payload1.personalDetails.isNomWorkForAutodeskReseller == false){
          $('input[name=is_autodesk_reseller]').filter('[value=false]').prop('checked', true);
        }

        //database :studentOrEducator
        if (payload1.personalDetails.studentOrEducator == true) {
          $('input[name=is_autodesk_student]').filter('[value=true]').prop('checked', true);
        } else if(payload1.personalDetails.studentOrEducator == false){
          $('input[name=is_autodesk_student]').filter('[value=false]').prop('checked', true);
        }


        //database :includeInEEDirectory
        if (payload1.personalDetails.includeInEEDirectory == true) {
          $('input[name=include_in_directory]').filter('[value=true]').prop('checked', true);
        } else if(payload1.personalDetails.includeInEEDirectory == false){
          $('input[name=include_in_directory]').filter('[value=false]').prop('checked', true);
        }


        //database :featuredMemberOnEEWebsite
        if (payload1.personalDetails.featuredMemberOnEEWebsite == true) {
          $('input[name=featured_member]').filter('[value=true]').prop('checked', true);
        } else if(payload1.personalDetails.featuredMemberOnEEWebsite == false){
          $('input[name=featured_member]').filter('[value=false]').prop('checked', true);
        }

        var dropdown_name = $("#languages");
		
		
        var other_filed = set_dropdown_values_language(dropdown_name, payload1.personalDetails.languageSpoken);
		$("#languages").css('border','1px solid #ccc');
        $("#other_languages").val(other_filed);


        //--------------------------------proficiency fileds Start ----------

        $("#ee_details_comments").val(payload1.proficiency.additionalComments);

        $("#interna_notes").val(payload1.proficiency.autodeskInternalNotes);

        $("#member_status").val(payload1.proficiency.memberStatus);
        $("#program_joined_date").val(payload1.proficiency.dateJoinedProgram);
		$("#autodeskCertification").val(payload1.proficiency.autodeskCertificatesDetails);


        //--------------------script for the dropdowns...--------------------------

        //proficiencyInAutodeskProduct": autodesk_proficiency
        var dropdown_name = $("#select_autodesk_proficiency");
        var other_filed = set_product_dropdown_values(dropdown_name, payload1.proficiency.proficiencyInAutodeskProduct);
		$("#select_autodesk_proficiency").css('border','1px solid #ccc');
        $("#other_proficiency").val(other_filed);

        //socialMediaPresence database name
        var socialMediaPresenceValues = payload1.proficiency.socialMediaPresence;
        for (var i = socialMediaPresenceValues.length - 1; i >= 0; i--) {
          $("#"+socialMediaPresenceValues[i].name).val(socialMediaPresenceValues[i].handle);
        };

        //attendedAuLasVegas database name
        var dropdown_name = $("#attended_au_las_vegas");
        var other_filed = set_dropdown_values(dropdown_name, payload1.proficiency.attendedAuLasVegas);
        $("#other_au").val(other_filed);

        //attendedEESummit database name
        var dropdown_name = $("#attended_ee_summit");
        var other_filed = set_dropdown_values(dropdown_name, payload1.proficiency.attendedEESummit);
        $("#other_summit").val(other_filed);


        //eeMentor database name
        var dropdown_name = $("#ee_mentor");
        var other_filed = set_dropdown_values(dropdown_name, payload1.proficiency.eeMentor);
        $("#other_mentor").val(other_filed);

        //redio button and if yes related filed 
        if (payload1.proficiency.doPromoteAutodeskHelp == true) {
          $('input[name=do_you_promote_product]').filter('[value=true]').prop('checked', true);
          $('#promote_url').val(payload1.proficiency.autodHelpProductSolutionURL);
        } else if(payload1.proficiency.doPromoteAutodeskHelp == false){
          $('input[name=do_you_promote_product]').filter('[value=false]').prop('checked', true);
        }

        if (payload1.proficiency.doCreateProductArticlesVideosWebinars == true) {
          $('input[name=prod_articles]').filter('[value=true]').prop('checked', true);
          $('#prod_articles_url').val(payload1.proficiency.productArticleWebinarURL);
        } else if(payload1.proficiency.doCreateProductArticlesVideosWebinars == false){
          $('input[name=prod_articles]').filter('[value=false]').prop('checked', true);
        }

        if (payload1.proficiency.doProvideAutodPrdTipSolScreencast == true) {
          $('input[name=doProvideAutodPrdTipSolScreencast]').filter('[value=true]').prop('checked', true);
          $('#autodPrdTipSolScreencastUrl').val(payload1.proficiency.autodPrdTipSolScreencastUrl);
        } else if(payload1.proficiency.doProvideAutodPrdTipSolScreencast == false){
          $('input[name=doProvideAutodPrdTipSolScreencast]').filter('[value=false]').prop('checked', true);
        }


        if (payload1.proficiency.doContributeBlog == true) {
          $('input[name=blog_contribution]').filter('[value=true]').prop('checked', true);
          $('#blog_contribution_url').val(payload1.proficiency.blogURL);
        } else if(payload1.proficiency.doContributeBlog == false){
          $('input[name=blog_contribution]').filter('[value=false]').prop('checked', true);
        }

        if (payload1.proficiency.doParticipateOrLeadAutodeskProduct == true) {
          $('input[name=is_prod_user_groups_member]').filter('[value=true]').prop('checked', true);
          $('#is_prod_user_groups_member_details').val(payload1.proficiency.participateLeadAutodeskProductUserGroupDetails);
        } else if(payload1.proficiency.doParticipateOrLeadAutodeskProduct == false){
          $('input[name=is_prod_user_groups_member]').filter('[value=false]').prop('checked', true);
        }

        if (payload1.proficiency.isSpeaker == true) {
          $('input[name=is_speaker]').filter('[value=true]').prop('checked', true);
          $('#speaker_information').val(payload1.proficiency.speakerInfo);
        } else if(payload1.proficiency.isSpeaker == false){
          $('input[name=is_speaker]').filter('[value=false]').prop('checked', true);
        }

        if (payload1.proficiency.doParticipateInGunslinger == true) {
          $('input[name=is_participated_gunslinger]').filter('[value=true]').prop('checked', true);
          $('#gushlinger_details').val(payload1.proficiency.gunslingerEventsDetails);
        } else if(payload1.proficiency.doParticipateInGunslinger == false){
          $('input[name=is_participated_gunslinger]').filter('[value=false]').prop('checked', true);
        }

        //--------------------------------proficiency fileds End ----------


        //--------------------valuePoints fileds start--------------------
        <#if admin >
        $("#id").val(payload1.valuePoints.nomineeId);
        $("#proficiency_point_value").val(payload1.valuePoints.autodeskProficiency);
        $("#social_media_point_value").val(payload1.valuePoints.socialMediaPresence);
        $("#promote_autodesk_help_point_value").val(payload1.valuePoints.productRelatedSolutions);
        $("#product_article_point_value").val(payload1.valuePoints.createProductArticlesVideosWebinars);
        $("#blog_contribute_point_value").val(payload1.valuePoints.contributeBlogOrWebsite);
        $("#is_participated_in_lead_point_value").val(payload1.valuePoints.participattionInOrLeadAutodeskProductUserGroups);
        $("#is_speaker_point_value").val(payload1.valuePoints.speakerAtAutodeskOrLocalCountryEvents);
        $("#participate_gunslinger_point_value").val(payload1.valuePoints.participateInGunslinger);
        $("#klout_point_value").val(payload1.valuePoints.kloutScore);
        $("#community_rank_point_value").val(payload1.valuePoints.communityRankPosition);
        $("#community_user_states_point_values").val(payload1.valuePoints.communityUserStat);
        $("#attended_au_point_value").val(payload1.valuePoints.attendedAuLasVegas);
        $("#attended_summit_point_value").val(payload1.valuePoints.attendedEESummit); 
        $("#autodPrdTipSolScreencast_point_value").val(payload1.valuePoints.autodPrdTipSolScreencast);
        </#if>
        //-------------------valuePoints fileds End-------------------
		

      }

      function set_dropdown_values(dropdown_name, database_string) {
        var arrayFromDOM = $(dropdown_name).find("option").map(function() {
          return this.value;
        }).get();
	
        var arrayFromData;
        var diffForOther;

        if (database_string != null) {
          arrayFromData = database_string.split(',');
          diffForOther = $(arrayFromData).not(arrayFromDOM).get();
        } else {
          arrayFromData = "";
          diffForOther = "";
        }
        $(dropdown_name).val(arrayFromData);
        return diffForOther;
      }
	  
	  function set_product_dropdown_values(dropdown_name, database_string) {
        
		var arrayFromData="";
		var diffForOther;
		
		 var arrayFromDOM = $(dropdown_name).find("input:checkbox").map(function() {
           return $(this).attr("value");
        }).get();
		
		if (database_string != null) {
					arrayFromData = database_string.split(',');
					
					for(var i=0;i<arrayFromData.length;i++){
						$("input[value='"+arrayFromData[i]+"']").attr("checked","true");
						
					diffForOther = $(arrayFromData).not(arrayFromDOM).get();
				}
		}else {
          arrayFromData = "";
          diffForOther = "";
        }
		
		
        return diffForOther;
      }
	  
	  function set_dropdown_values_language(dropdown_name, database_string) {
       
		var arrayFromData="";
		var diffForOther;
		
		 var arrayFromDOM = $(dropdown_name).find("input:checkbox").map(function() {
           return $(this).attr("value");
        }).get();
		
		if (database_string != null) {
					arrayFromData = database_string.split(',');
					for(var i=0;i<arrayFromData.length;i++){
						$("input[value='"+arrayFromData[i]+"']").attr("checked","true");
						
					diffForOther = $(arrayFromData).not(arrayFromDOM).get();
				}
		}else {
          arrayFromData = "";
          diffForOther = "";
        }
		
	
		
        return diffForOther;
      }


      //email validation
      var component = {
          input: $('#email'),
          mensage: {
            fields: $('.msg'),
            success: $('.success'),
            error: $('#emailError')
          }
        },
        regex = /^(.)+\@((.)+\.)+(.)+$/;
		
		var component2 = {
          input: $('#email2'),
          mensage: {
            fields: $('.msg'),
            success: $('.success'),
            error2: $('#email2Error')
          }
        },
        regex = /^(.)+\@((.)+\.)+(.)+$/;
		
      component.input.blur(function() {
        
        if(regex.test(component.input.val()) ){
		
          component.mensage.success.show();
          component.input.removeClass("borderclass");
		  component.mensage.error.css("display","none");
        }
         else{ 
		 
          component.mensage.error.css("display","table-cell");
          component.input.addClass("borderclass");
        }
      });

	  component2.input.blur(function() {
        
        if(component2.input.val()=="" || regex.test(component2.input.val()) ){
		  component2.mensage.success.show();
          component2.input.removeClass("borderclass");
		  component2.mensage.error2.css("display","none");
        }
         else{ 
		 
          component2.mensage.error2.css("display","table-cell");
          component2.input.addClass("borderclass");
        }
      });


      //Script for Yes No radio option and text box sync

      $("input[name=is_autodesk_reseller],input[name=do_you_promote_product],input[name=prod_articles],input[name=doProvideAutodPrdTipSolScreencast],input[name=blog_contribution],input[name=is_prod_user_groups_member],input[name=is_speaker],input[name=is_participated_gunslinger]").change(function(argument) {
        radioAndTextBoxSync($(this));
      });


      $("#accordion .input_txt,#accordion .EESelect,#accordion input[type=radio]").change(function() {
        //console.log('changed');
        dirtyField = true;
      });

      
      
      $("#program_joined_date,#nominationSubmissionDate").on('click',function() {
        //console.log('changed date');
        dirtyField = true;
      });
      

    })(LITHIUM.jQuery);

    function radioAndTextBoxSync(radioButtonElement) {
      //console.log("in radioAndTextBoxSync function argument passed "+radioButtonElement.attr('name'));
      var value = false;
      if(radioButtonElement.is(':checked'))
      {
        value = radioButtonElement.filter(':checked').val();
      }
      else
      {
        value = false;
      }

      switch (radioButtonElement.attr('name')) {
        case "is_autodesk_reseller":
          //console.log("1");
          enbleDisableTextBox("reseller_name", value);
          break;

        case "do_you_promote_product":
          enbleDisableTextBox("promote_url", value);
          break;

        case "prod_articles":
          enbleDisableTextBox("prod_articles_url", value);
          break;

        case "doProvideAutodPrdTipSolScreencast":
          enbleDisableTextBox("autodPrdTipSolScreencastUrl", value);
          break;        

        case "blog_contribution":
          enbleDisableTextBox("blog_contribution_url", value);
          break;

        case "is_prod_user_groups_member":
          enbleDisableTextBox("is_prod_user_groups_member_details", value);
          break;

        case "is_speaker":
          enbleDisableTextBox("speaker_information", value);
          break;

        case "is_participated_gunslinger":
          enbleDisableTextBox("gushlinger_details", value);
          break;
      }
    }

    function enbleDisableTextBox(inputBoxId, value) {
      //console.log("in enbleDisableTextBox function " + value + "  " + inputBoxId);
      if (value == "true") {
        $("#" + inputBoxId).removeAttr('disabled');
      } else {
        $("#" + inputBoxId).val("");
        $("#" + inputBoxId).attr('disabled', 'disabled');
        $("#" + inputBoxId).removeClass("borderclass");
      }
    }
    
    function viewData(evt,tabName){
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("panel-body");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";          
    }

    $(window).load(function() {
      //console.log("in Window . load function");
      //console.log("input[name=is_autodesk_reseller" + $("input[name=is_autodesk_reseller]").val());
      radioAndTextBoxSync($("input[name=is_autodesk_reseller]"));
      radioAndTextBoxSync($("input[name=do_you_promote_product]"));
      radioAndTextBoxSync($("input[name=prod_articles]"));
      radioAndTextBoxSync($("input[name=doProvideAutodPrdTipSolScreencast]"));
      radioAndTextBoxSync($("input[name=blog_contribution]"));
      radioAndTextBoxSync($("input[name=is_prod_user_groups_member]"));
      radioAndTextBoxSync($("input[name=is_speaker]"));
      radioAndTextBoxSync($("input[name=is_participated_gunslinger]"));
	  
	  <#-- Disable all fields if user have read-only access--->
		<#if adminViewOnly >
			$("input").prop("disabled","true");
			$("textarea").prop("disabled","true");
			$("select").prop("disabled","true")
		</#if>

    });
    //console.log("we are here to run a datepicker");
    $("#program_joined_date").datepicker({});
  </@liaAddScript>

  
    <div class="container">
      <h2>${text.format('autodesk-EE-detailsPage-page-title')}</h2>
      <div class="change-language"><a href="/t5/user/myprofilepage/tab/user-preferences">${text.format('autodesk.ee.change-language')}</a></div>
	  <p id="error" style="color:red;"></p>
	  
      <div class="InfoMessage lia-panel-feedback-inline-safe">
        <div class="lia-text">
          <p id="success-message" style="display:none;">${text.format('autodesk.ee.details-updated')}</p>
          
          <#if admin>
            <p id="success-role-change" style="display:none;">Role updated successfully.</p>
          </#if>

        </div>
      </div>

      <div class="InfoMessage no-change-message-panel">
        <div class="lia-text">
          <p id="no-change-message" style="display:none;">${text.format('autodesk.ee.change-field-to-update')}</p>
        </div>
      </div>

      <div class="InfoMessage error-message-panel">
        <div class="lia-text">
          <p id="error-message" style="display:none;">Error...!</p>
        </div>
      </div>



   
            
        <div class="tab">
          <a href="#collapse1" class="tablinks" onclick="viewData(event,'Expert_Elite_Member_Information')">Expert Elite ${text.format('autodesk.ee.member-information')}</a>
          <a class="tablinks" onclick="viewData(event,'Autodesk_Product_Proficiency')">${text.format('autodesk.ee.product-proficiency-engagement')}</a>
          <a class="tablinks" onclick="viewData(event,'Community_Stats')">Community Stats</a>
          <a class="tablinks" onclick="viewData(event,'Point_Values')">Point Values</a>
        </div>
                  
                    
          <div class="panel-body" id="Expert_Elite_Member_Information">
              <table>
                <tr style="display: none;">
                  <td>
                    <label class="EELabel" for="id"> Id<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="id" id="id" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>

                <tr>
                  <td>
                    <label class="EELabel" for="candidate_first_name"> ${text.format('autodesk.ee.firstname')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="candidate_first_name" id="candidate_first_name" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="candidate_last_name"> ${text.format('autodesk.ee.lastname')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="candidate_last_name" id="candidate_last_name" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="candidate_Email"> ${text.format('autodesk.ee.email')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="email" id="email" value="" size="46" maxlength="200" class="input_txt"/>
                    <span id="emailError" class="msg error">${text.format('autodesk.ee.enter-emailid')}</span>
                  </td>
                </tr>

                <#if EEMemberAdmin>
                        <tr>
                          <td>
                            <label class="EELabel" for="candidate_Email"> ${text.format('autodesk.ee.email.prog.communication')}<span class="nonmandatoryField"></span></label>
                          </td>
                          <td>&nbsp;&nbsp;&nbsp;</td>
                          <td>
                            <input type="text" name="email2" id="email2" value="" size="46" maxlength="200" class="input_txt"/>
                            <span id="email2Error" class="msg error">${text.format('autodesk.ee.enter-emailid')}</span>
                          </td>
                        </tr>    

                        <tr>
                          <td>
                            <label class=" EELabel" for="Send_EE_Communications">${text.format('autodesk.ee.Send.EE.Communications')}</label>
                          </td>
                          <td>&nbsp;&nbsp;&nbsp;</td>
                          <td>
                            <input type="radio" class="radioCheck_EE_Communications" name="Send_EE_Communications" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                            <input type="radio" class="radioCheck_EE_Communications" name="Send_EE_Communications" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                          </td>
                        </tr>
                </#if>

                <tr>
                  <td>
                    <label class=" EELabel" for="phone_number"><span class="nonmandatoryField"></span> ${text.format('autodesk.ee.phone')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="phone" id="phone_number" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="address1">  ${text.format('autodesk.ee.address1')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="address1" id="address1" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="address2"><span class="nonmandatoryField"></span> ${text.format('autodesk.ee.address2')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="address2" id="address2" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                   <label class=" EELabel" for="city">  ${text.format('autodesk.ee.city')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="city" id="city" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                 <tr>
                  <td>
                   <label class=" EELabel" for="state">${text.format('autodesk.ee.state-province')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="state" id="state" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                 <tr>
                  <td>
                   <label class=" EELabel" for="postal_code">${text.format('autodesk.ee.zip-postal-code')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="postal_code" id="postal_code" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="country" >  ${text.format('autodesk.ee.country')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                     <select name="country" id="country" class="EESelect">           
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
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="languages">  ${text.format('autodesk.ee.languages-spoken')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>

                  <div style="padding: 10px; overflow: auto; max-height: 180px;" name="languages" id="languages" class="EESelect" >
                        <label style="display:block;"><input type="checkbox" name="option[]" value="English" />&nbsp;&nbsp;${text.format('autodesk.ee.english')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="French" />&nbsp;&nbsp;${text.format('autodesk.ee.french')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="German" />&nbsp;&nbsp;${text.format('autodesk.ee.german')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="Italian" />&nbsp;&nbsp;${text.format('autodesk.ee.italian')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="Spanish" />&nbsp;&nbsp;${text.format('autodesk.ee.spanish')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="Portuguese" />&nbsp;&nbsp;${text.format('autodesk.ee.portuguese')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="Russian" />&nbsp;&nbsp;${text.format('autodesk.ee.russian')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="Japanese" />&nbsp;&nbsp;${text.format('autodesk.ee.japanese')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="Simplified Chinese" />&nbsp;&nbsp;${text.format('autodesk.ee.simplifies-chinese')}</label>
                        <label style="display:block;"><input type="checkbox" name="option[]" value="Traditional Chinese" />&nbsp;&nbsp;${text.format('autodesk.ee.traditional-chinese')}</label>
                  </div>


                  <!--
                    <select name="languages" id="languages" class="EESelect" multiple="true" title = "${text.format('autodesk.ee.select-multiple-items')}">
                      <option value="English">${text.format('autodesk.ee.english')}</option>
                      <option value="French">${text.format('autodesk.ee.french')}</option>
                      <option value="German">${text.format('autodesk.ee.german')}</option>
                      <option value="Italian">${text.format('autodesk.ee.italian')}</option>
                      <option value="Spanish">${text.format('autodesk.ee.spanish')}</option>
                      <option value="Portuguese">${text.format('autodesk.ee.portuguese')}</option>
                      <option value="Russian">${text.format('autodesk.ee.russian')}</option>
                      <option value="Japanese">${text.format('autodesk.ee.japanese')}</option>
                      <option value="Simplified Chinese">${text.format('autodesk.ee.simplifies-chinese')}</option>
                      <option value="Traditional Chinese">${text.format('autodesk.ee.traditional-chinese')}</option> -->
                      <!-- <option>English</option>
                      <option>French</option>
                      <option>German</option>
                      <option>Italian</option>
                      <option>Spanish</option>
                      <option>Portuguese</option>
                      <option>Russian</option>
                      <option>Japanese</option>
                      <option>Simplified Chinese</option>
                      <option>Traditional Chinese</option> -->
                 <!--   </select> -->
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="other_languages">${text.format('autodesk.ee.other-language')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="other_languages" id="other_languages" value="" size="30" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="shirt_size">${text.format('autodesk.ee.shirtsize')}<#if EEMember><span class="mandatoryField"></span></#if></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <select name="shirt_size" id="shirt_size" class="EESelect">
                    <option value="">Please select</option>
                    <option>Small</option>
                    <option>Medium</option>
                    <option>Large</option>
                    <option>Extra Large</option>
                    <option>2XL</option>
                    <option>3XL</option>
                   </select>
                  </td>
                </tr>


                <tr>
                  <td>
                    <label class=" EELabel" for="forum_user_id">${text.format('autodesk.ee.community-userid')} <!--span class="mandatoryField"></span--></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="text" name="forum_user_id" id="forum_user_id" value="" size="30" maxlength="100" class="input_txt">
                  </td>
                </tr>


                <tr>
                  <td>
                   <label class=" EELabel" for="is_autodesk_reseller">${text.format('autodesk.ee.autodesk-reseller')}<span class="mandatoryField"></span>  </label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_reseller" name="is_autodesk_reseller" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_reseller" name="is_autodesk_reseller" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="is_autodesk_reseller_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                   <label class=" EELabel" for="reseller_name"><em>${text.format('autodesk.ee.name-reseller')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                     <input type="text" name="reseller_name" id="reseller_name" value="" size="46" maxlength="50" class="input_txt radioCheck_reseller_other">
                  </td>
                </tr>
                <tr>
                  <td>
                   <label class=" EELabel" for="is_autodesk_student"> ${text.format('autodesk.ee.student-educator-expert-program')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_student" name="is_autodesk_student" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_student" name="is_autodesk_student" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="is_autodesk_student_radio-required-message radio-required-message"></span>
                  </td>
                </tr>


                <tr>
                  <td>
                    <label class=" EELabel" for="include_in_directory">${text.format('autodesk.ee.expertelite-directory-inclusion')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_directory" name="include_in_directory" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_directory" name="include_in_directory" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                  </td>
                </tr>


                <tr>
                  <td>
                    <label class=" EELabel" for="featured_member">${text.format('autodesk.ee.member-on-expertelitesite')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_featured" name="featured_member" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_featured" name="featured_member" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                  </td>
                </tr>

            </table>
        </div>
          <div class="panel-body" id="Autodesk_Product_Proficiency">
              <table>
                <tr>
                  <td>
                    <label class=" EELabel" for="autodesk_proficiency"> ${text.format('autodesk.ee.proficiency-products')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <div style="padding: 10px; overflow: auto; max-height: 180px;" name="select_autodesk_proficiency" id="select_autodesk_proficiency" class="EESelect newclass" ></div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="other_proficiency">${text.format('autodesk.ee.other')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="other_proficiency" id="other_proficiency" value="" size="30" maxlength="100" class="input_txt"> 
                  </td>
                </tr>
                <tr class="socialMediaHeaderWrapper">
                  <td class="socialMediaPresenceHeader key">${text.format('autodesk.ee.social-media')}</td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <label class="socialMediaPresenceHeader value">${text.format('autodesk.ee.name-handle-url')}</label>
                  </td>
                </tr>

                <#--removed config variables and adding all social medeia fields through jQuery--->
                <#--assign socialMediaoptions = coreNode.settings.name.get("autodesk.social_media_presence")?split(",") />
                <#list socialMediaoptions as option>
                <tr>
                  <td>
                      <label class="SocialMediaPresenceLabel">${option}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input class="SocialMediaPresenceInput input_txt" maxlength="200" id="${option?replace(' ','')?lower_case}">    
                  </td>
                </tr>
                </#list-->

                <tr>
                  <td>
                    <label class=" EELabel" for="do_you_promote_product">${text.format('autodesk.ee.promote-autodesk_help-label')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_promote_product" name="do_you_promote_product" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_promote_product" name="do_you_promote_product" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="do_you_promote_product_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="promote_url"><em>${text.format('autodesk.ee.provide-example-urls-label')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea type="text" name="promote_url" id="promote_url" value="" size="46" maxlength="1000" class="input_txt radioCheck_promote_product_other input-text-area"></textarea>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="prod_articles"> ${text.format('autodesk.ee.create-product-articles-label')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_articles" name="prod_articles" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_articles" name="prod_articles" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="prod_articles_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="prod_articles_url"><em>${text.format('autodesk.ee.provide-example-urls-label')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea type="text" name="prod_articles_url" id="prod_articles_url" value="" size="46" maxlength="1000" class="input_txt radioCheck_articles_other input-text-area"></textarea>
                  </td>
                </tr>

                <tr>
                  <td>
                    <label class=" EELabel" for="doProvideAutodPrdTipSolScreencast"> ${text.format('autodesk.ee.provide-product-tips-label')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_SolScreencast" name="doProvideAutodPrdTipSolScreencast" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_SolScreencast" name="doProvideAutodPrdTipSolScreencast" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="doProvideAutodPrdTipSolScreencast_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="autodPrdTipSolScreencastUrl"><em>${text.format('autodesk.ee.provide-example-urls-label')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea type="text" name="autodPrdTipSolScreencastUrl" id="autodPrdTipSolScreencastUrl" value="" size="46" maxlength="1000" class="input_txt radioCheck_SolScreencast_other input-text-area"></textarea>
                  </td>
                </tr>

                <tr>
                  <td>
                    <label class=" EELabel" for="blog_contribution"> ${text.format('autodesk.ee.contribute-blog-label')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_blog" name="blog_contribution" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_blog" name="blog_contribution" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="blog_contribution_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="blog_contribution_url"><em>${text.format('autodesk.ee.provide-urls-label')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea type="text" name="blog_contribution_url" id="blog_contribution_url" value="" size="46" maxlength="1000" class="input_txt radioCheck_blog_other input-text-area"></textarea>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="is_prod_user_groups_member"> ${text.format('autodesk.ee.lead-product-user-groups-label')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_prod_user" name="is_prod_user_groups_member" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_prod_user" name="is_prod_user_groups_member" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="is_prod_user_groups_member_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="is_prod_user_groups_member_details"><em>${text.format('autodesk.ee.provide-details-label')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea type="text" name="is_prod_user_groups_member_details" id="is_prod_user_groups_member_details" value="" size="46" maxlength="1000" class="input_txt radioCheck_prod_user_other input-text-area"></textarea>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="is_speaker">${text.format('autodesk.ee.speaker-events-label')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="radioCheck_speaker" name="is_speaker" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="radioCheck_speaker" name="is_speaker" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                    <span class="is_speaker_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="speaker_information"><em>${text.format('autodesk.ee.provide-info-label')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <textarea type="text" name="speaker_information" id="speaker_information" value="" size="46" maxlength="1000" class="input_txt radioCheck_speaker_other input-text-area"></textarea>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="is_participated_gunslinger"> ${text.format('autodesk.ee.participate-gunslinger-event-label')}<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                   <input type="radio" class="radioCheck_gushlinger" name="is_participated_gunslinger" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                   <input type="radio" class="radioCheck_gushlinger" name="is_participated_gunslinger" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                   <span class="is_participated_gunslinger_radio-required-message radio-required-message"></span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class=" EELabel" for="gushlinger_details"><em>${text.format('autodesk.ee.provide-details-label')}</em></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea type="text" name="gushlinger_details" id="gushlinger_details" value="" size="46" maxlength="1000" class="input_txt radioCheck_gushlinger_other input-text-area"></textarea>
                  </td>
                </tr>

                <!---------Autodesk certification field : sprint 2 : Start------->
                <tr class="autodeskCertificationWrapper">
                  <td>
                    <label class="EELabel autodeskCertificationLabel" for="autodeskCertification">${text.format('autodesk.ee.autodesk-certifications')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td class="textareaWrapper">
                    <textarea name="autodeskCertification" id="autodeskCertification" class="input_txt input-text-area" maxlength="1000" > </textarea>
                  </td>
                </tr>
                <!---------Autodesk certification field : sprint 2 : End------->

                <#if admin>
                <!-- <tr>
                  <td>
                    <label class="EELabel" for="klout_score"> Klout Score<span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="klout_score" id="klout_score" value="" size="46" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class="EELabel" for="community_rank_position"> Community rank position <span class="mandatoryField"></span></label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="community_rank_position" id="community_rank_position" value="" size="46" maxlength="100" class="input_txt">       
                  </td>
                </tr> -->
                 <tr>
                  <td>
                    <label class="EELabel" for="attended_au_las_vegas">Attended AU Las Vegas</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <select id="attended_au_las_vegas" class="single EESelect" multiple="true" title = "${text.format('autodesk-EE-multiple-select-tooltip')}">
                      <#--assign optionValues = systemListEditor.getOptionValues('autodesk.attended_au_las_vegas')>
                      ${optionValues}-->
                    </select>     
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class="EELabel" for="other_au">${text.format('autodesk.ee.other-language')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="other_au" id="other_au" value="" size="30" maxlength="100" class="input_txt">   
                  </td>
                </tr>
                 <tr>
                  <td>
                    <label class="EELabel" for="attended_ee_summit">Attended EE Summit</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                     <select name="attended_ee_summit" id="attended_ee_summit" class="single EESelect" multiple="true" title = "${text.format('autodesk-EE-multiple-select-tooltip')}">
                      <#--assign optionValues = systemListEditor.getOptionValues('autodesk.attended_ee_summit')>
                      ${optionValues}-->
                    </select>
                  </td>
                </tr>
                 <tr>
                  <td>
                    <label class="EELabel" for="other_summit">${text.format('autodesk.ee.other-language')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="other_summit" id="other_summit" value="" size="30" maxlength="100" class="input_txt">
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class="EELabel" for="ee_mentor">EE Mentor</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                     <select name="ee_mentor" id="ee_mentor" class="EESelect">
                      <option value="">Select...</option>
                      <option>Active</option>
                      <option>No longer active</option>
                      <option>To be considered</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class="EELabel" for="other_mentor">${text.format('autodesk.ee.other-language')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="text" name="other_mentor" id="other_mentor" value="" size="30" maxlength="100" class="input_txt">
                  </td>
                </tr>
                  <tr>
                  <td>
                    <label class="EELabel" for="interna_notes">Autodesk Internal Notes</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea name="interna_notes" id="interna_notes" class="input_txt input-text-area" maxlength="2500" > </textarea>
                  </td>
                </tr>

                <!-----------Nominated by and nominatio date : Start------------->
                <tr>
                  <td>
                    <label class=" EELabel" for="isSubmitterEEMember">Nomination submitted by Expert Elite</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input type="radio" class="isSubmitterEEMember" name="isSubmitterEEMember" value="true"><span class="radioBtnText">${text.format('autodesk.ee.yes')}</span>
                    <input type="radio" class="isSubmitterEEMember" name="isSubmitterEEMember" value="false" style="margin-left:10px;"><span class="radioBtnText">${text.format('autodesk.ee.no')}</span>
                  </td>
                </tr>

                <tr>
                    <td>
                    <label class="EELabel" for="submitterFullName">Nominated by Name</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input name="submitterFullName" id="submitterFullName" class="input_txt" maxlength="100" size="46">
                  </td>
                </tr>

                <tr>
                  <td>
                    <label class="EELabel" for="nominationSubmissionDate">Nomination Submitted Date</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input class="input_txt form-control dateInputField" data-provide="datepicker" data-date-format="mm/dd/yyyy" name="nominationSubmissionDate"  placeholder="mm/dd/yyyy" id="nominationSubmissionDate" size="30" maxlength="100">
                  </td>
                </tr>


                <!-------Nominated by and nominatio date : End----------->

                <tr>
                  <td>
                    <label class="EELabel" for="member_status">Member Status</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <select name="member_status" id="member_status" class="single EESelect">
                      <option value="">Select...</option>
                      <option>EE Active</option>
                      <option>EE no longer active</option>
                      <option>EE under review</option>
                      <option>Employee Active</option>
                      <option>Employee Inactive</option>
                      <option>Nomination duplicate</option>
                      <option>Nomination new</option>
                      <option>Nomination not qualified</option>
                      <option>Nomination to be considered</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label class="EELabel" for="program_joined_date">Date joined program</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <input class="input_txt form-control singleInputField dateInputField" data-provide="datepicker" data-date-format="mm/dd/yyyy" name="program_joined_date"  placeholder="mm/dd/yyyy" id="program_joined_date" value="" size="30" maxlength="100">
                  </td>
                </tr>
                </#if>
                <tr>
                  <td>
                    <label class="EELabel" for="ee_details_comments">${text.format('autodesk.ee.External-Nomination-EE-Comments')}</label>
                  </td>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <textarea name="ee_details_comments" id="ee_details_comments" maxlength="2500" class="input_txt input-text-area" > </textarea>
                  </td>
                </tr>
              </table>
    </div>
          <#if admin>
              <div class="panel-body" id="Community_Stats" >
                <table>
                  <tr>
                      <td>
                        <label class=" EELabel" for="forum_rank_position">Forum Rank Position</label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <span id="forum_rank_position" class="userStats"></span>
                      </td>
                    </tr>
                     <tr>
                      <td>
                        <label class=" EELabel" for="registartion_date">Registration Date</label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                       <span id="registartion_date" class="userStats"></span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label class=" EELabel" for="most_recent_login">Most Recent Login </label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                       <span id="most_recent_login" class="userStats"></span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label class=" EELabel" for="net_boards_replies">Net Boards Replies</label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <span id="net_boards_replies" class="userStats"></span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                         <label class=" EELabel" for="accepted_solutions">Accepted Solutions (solutions authored)</label>     
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                         <span id="accepted_solutions" class="userStats"></span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label class=" EELabel" for="net_kudos_recieved">Net Kudos Received</label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <span id="net_kudos_recieved" class="userStats"></span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label class=" EELabel" for="net_kudos_given">Net Kudos Given</label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <span id="net_kudos_given" class="userStats"></span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label class=" EELabel" for="net_forum_topics">Net Forum Topics</label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <span id="net_forum_topics" class="userStats"></span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label class=" EELabel" for="posts">Posts</label>
                      </td>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <span id="posts" class="userStats"></span>
                      </td>
                    </tr>
                </table>
    </div>
              <div class="panel-body" id="Point_Values">
               <table class="">
                <thead>
                  <tr>
                    <th>Attribute</th>
                    <th>Point Value</th>               
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <label class=" EELabel" for="proficiency_point_value">${text.format('autodesk.ee.proficiency-products-admin')} </label>
                    </td>
                    <td>
                      <input type="text" name="proficiency_point_value" id="proficiency_point_value" value="" size="30" maxlength="7" class="input_txt">
                      </td>
                  </tr>
                  <tr>
                    <td>
                      <label class=" EELabel" for="social_media_point_value">Social Media presence (provide handle / name) </label>
                    </td>
                    <td>
                      <input type="text" name="social_media_point_value" id="social_media_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label class=" EELabel" for="promote_autodesk_help_point_value">${text.format('autodesk.ee.promote-autodesk_help-label-admin')}  </label>
                    </td>
                    <td>
                      <input type="text" name="promote_autodesk_help_point_value" id="promote_autodesk_help_point_value" value="" size="30" maxlength="7" class="input_txt" >
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label class=" EELabel" for="product_article_point_value">${text.format('autodesk.ee.create-product-articles-label-admin')} </label>
                    </td>
                    <td>
                      <input type="text" name="product_article_point_value" id="product_article_point_value" value="" size="30" maxlength="7" class="input_txt" >
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label class=" EELabel" for="autodPrdTipSolScreencast_point_value">${text.format('autodesk.ee.provide-product-tips-label-admin')}</label>
                    </td>
                    <td>
                    <input type="text" name="autodPrdTipSolScreencast_point_value" id="autodPrdTipSolScreencast_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr> 
                  <tr>
                    <td>
                      <label class=" EELabel" for="blog_contribute_point_value">${text.format('autodesk.ee.contribute-blog-label-admin')} </label>
                    </td>
                    <td>
                      <input type="text" name="blog_contribute_point_value" id="blog_contribute_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label class=" EELabel" for="is_participated_in_lead_point_value">${text.format('autodesk.ee.lead-product-user-groups-label-admin')} </label>
                    </td>
                    <td>
                      <input type="text" name="is_participated_in_lead_point_value" id="is_participated_in_lead_point_value" value="" size="30" maxlength="7" class="input_txt" >
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label class=" EELabel" for="is_speaker_point_value"> ${text.format('autodesk.ee.speaker-events-label-admin')}   </label>
                    </td>
                    <td>
                      <input type="text" name="is_speaker_point_value" id="is_speaker_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label class=" EELabel" for="participate_gunslinger_point_value">${text.format('autodesk.ee.participate-gunslinger-event-label-admin')} </label>
                    </td>
                    <td>
                      <input type="text" name="participate_gunslinger_point_value" id="participate_gunslinger_point_value" value="" size="30" maxlength="7" class="input_txt">
                      </td>
                  </tr>
                   <tr>
                    <td>
                      <label class=" EELabel" for="klout_point_value">${text.format('autodesk.ee.klout-score-admin')}</label>
                    </td>
                    <td>
                      <input type="text" name="klout_point_value" id="klout_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>
                   <tr>
                    <td>
                       <label class=" EELabel" for="community_rank_point_value">${text.format('autodesk.ee.rank-position-admin')}</label>
                    </td>
                    <td>
                      <input type="text" name="community_rank_point_value" id="community_rank_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>         
                   <tr>
                    <td>
                      <label class="EELabel" for="community_user_states_point_value">${text.format('autodesk.ee.user-stats-admin')}</label></td>
                    <td>
                      <input type="text" name="community_user_states_point_values" id="community_user_states_point_values" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>           
                   <tr>
                    <td>
                      <label class=" EELabel" for="attended_au_point_value">${text.format('autodesk.ee.AU-las-vegas-admin')}</label>
                    </td>
                    <td>
                      <input type="text" name="attended_au_point_value" id="attended_au_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>           
                   <tr>
                    <td>
                      <label class=" EELabel" for="attended_summit_point_value">${text.format('autodesk.ee.attended-summit-admin')}</label>
                    </td>
                    <td>
                    <input type="text" name="attended_summit_point_value" id="attended_summit_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>
                  </tr>


                  <!--  <tr>
                    <td>
                      <label class=" EELabel" for="mentor_point_value">EE Mentor</label>
                    </td>
                    <td>
                    <input type="text" name="mentor_point_value" id="mentor_point_value" value="" size="30" maxlength="7" class="input_txt">
                    </td>              
                  </tr>      -->         
              </tbody>
            </table>
    </div> 
          </#if>
        
        
    <div style="margin-top:15px;">
	  <#if !adminViewOnly >
		<button class="btn-brand " id="updatebtn">${text.format('autodesk-EE-detailsPage-button-update')}</button>
	  </#if>
	  
      <a class="btn-brand " id="cancelbtn" href="${cancelButtonLink}">${text.format('autodesk-EE-detailsPage-button-cancel')}</a>
    </div>

   

  

<#else>
  <div class="ErrorPageNotFound">                
      <div class="Error-Message-heading">
        Sorry..!
      </div>
    <div class="ErrorMessage">
        <p>You don’t have sufficient privileged to access this part of community.</p>
    </div>
  </div>
</#if>
<style>
    .tablinks{
        float: left;
    }
    
    .panel-body {
    display: none;
    padding: 6px 12px;
    border: 1px solid #ccc;
    border-top: none;
}
</style>