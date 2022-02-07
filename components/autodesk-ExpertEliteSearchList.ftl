<#assign admin = false />
<#assign expertEliteRoleId=""/>
<#list restadmin("/roles").roles.role as role>
<#if role.name == "Expert Elite">
<#assign expertEliteRoleId=role.id/>
</#if>
</#list>
<#list restadmin("/users/id/${user.id?c}/roles").roles.role as role>
<#if role.name?? && (role.name == "Administrator" || role.name == "Expert Elite Admin" || role.name == "EE Admin View-only")  >
<#assign admin = true  />
</#if>
</#list>

<#assign env=http.request.serverName/>
<#assign stage=""/>
<#if env=="forums-dev.autodesk.com">
<#assign stage="-dev"/>
<#elseif env=="forums-stg.autodesk.com">
<#assign stage="-stg"/>
<#else>
</#if>

<#if admin>


<#-------------Get Base URL as per environment :Start ------------------------>

<#if env == "forums-stg.autodesk.com" || env == "forums-dev.autodesk.com" >
<#assign expertelite_endpoint="/plugins/custom/autodesk/${community.id}/expertelite-userdetails"/>             
<#assign autodesk_ee_vm_baseurl = "https://autoeedev.autodesk.com/AutodeskExpertElite" />
<#else>
<#assign autodesk_ee_vm_baseurl = "https://autoeeprod.autodesk.com/AutodeskExpertElite" />
<#assign expertelite_endpoint="/plugins/custom/autodesk/${community.id}/expertelite-userdetails"/>
</#if>

<#-------------Get Base URL as per environment :End ------------------------>

<script src='${asset.get("/html/assets/jquery-3.4.1.min.js")}'></script>
<link rel="stylesheet" href="${asset.get('/html/assets/bootstrap.min.css')}">
<script src="${asset.get('/html/assets/bootstrap.min.js')}"></script>
<link href="${asset.get('/html/assets/datepicker.css')}" rel="stylesheet" type="text/css" />
<script src="${asset.get('/html/assets/bootstrap-datepicker.js')}"></script>
<script src="${asset.get('/html/assets/base64EncodeDecode.js')}"></script>

<@liaAddScript>
$(document).ready(function() {
//;
var filterJSON;
var allfilterJSON;
var selectedIds;
var txt="";
filterJSON = localStorage.getItem("filterJSON");
console.log("filterJSON : "+JSON.stringify(filterJSON));
//page load first time set all attributes in 3 lines
var pageSize = 30;
var username = "admin";
var password = "admin!";


var timeStamp1,timeStamp2;

//get config variables through Ajax call-----------------------------------




var configURL = "${autodesk_ee_vm_baseurl}/expertelite/nominee/config";
$.ajax({
type: "GET",
crossDomain: true,
data: JSON.stringify(filterJSON),
url: configURL,
dataType: "json",
async: "false",
beforeSend: function(xhr1) {
xhr1.setRequestHeader("Authorization", "Basic " + Base64.encode(username + ":" + password));
xhr1.setRequestHeader("Content-Type", "application/json");
xhr1.setRequestHeader("User-Type", "admin");
},
success: function(data, status, xhr) {
//do something  

//Social mediapresence List  : declaring as global variable
socialMediaPresenceString = data.socialMediaPresenceProperties.socialMediaPresenceList;
socialMediaPresenceString = socialMediaPresenceString.join(",");

var attendedAULasVegasYearList = optionConversion(data.attendedAuLasVegasList.attendedAULasVegasYearList);
var attendedEESummitYearList = optionConversion(data.attendedEESummitYearProperties.attendedEESummitYearList);
var productListProperties = optionConversion(data.productProficiencyProperties.productListProperties);
var socialMediaPresenceList = optionConversion(data.socialMediaPresenceProperties.socialMediaPresenceList);



//Enabling function calling 
filterEnable(attendedAULasVegasYearList,attendedEESummitYearList,productListProperties,socialMediaPresenceList);
},
error: function(e) {
//;
console.log("error : " + e);                   
}
});     

function optionConversion(elementsArray)
{
var options = "";
for(var i=0;i<elementsArray.length;i++)
{
options = options + "<option>"+elementsArray[i]+"</option>"
}
return(options);
}
//-----------------------------------get config varialbles end--------------------------

//getUsersList(1, pageSize);
$("#searchResults tbody").html("<tr><td class='no-record-found' colspan='5'>Click on Apply Filter.</td></tr>");

function getUsersList(pageNo, pageSize) {
;
//Actual running code
var getNomineeListURL = "${autodesk_ee_vm_baseurl}/expertelite/nominee/list?pageNo=" + pageNo + "&pageSize=" + pageSize;
//console.log("get Member Details URL  =>  " + getNomineeListURL);
//console.log("Authorization = Basic " + Base64.encode(username + ":" + password));
//console.log(JSON.stringify(filterJSON));
timeStamp1 = new Date();

$("img.ajaxLoading").show();
console.log("filterJSON123 : "+JSON.stringify(filterJSON));
$.ajax({
type: "POST",
crossDomain: true,
data: JSON.stringify(filterJSON),
url: getNomineeListURL,
dataType: "json",
async: "false",
beforeSend: function(xhr1) {
xhr1.setRequestHeader("Authorization", "Basic " + Base64.encode(username + ":" + password));
xhr1.setRequestHeader("Content-Type", "application/json");
},
success: function(data, status, xhr) {
//do something

if(data.status == "success")
{  
allfilterJSON=data;
timeStamp2 = new Date();
//console.log("Time require /nominee/list call: "+ (timeStamp2 - timeStamp1)/1000 +" Sec");
//console.log("userlist are avliable");

//console.log(data.totalNomineeCount);
showUserList(data, pageNo);
//console.log("get call length of records" + data.nomineeList.length);
if (pageNo == 1) 
{
add_pagination(data.totalNomineeCount);
}
}
$("img.ajaxLoading").hide();
},
error: function(e) {
console.log("error" + e);
$("img.ajaxLoading").hide();
}
});
}


function add_pagination(MemberCount) {
var pageCount = MemberCount / pageSize;

pageCount = Math.ceil(pageCount)

//console.log("page Count = " + pageCount);

var pagination_html = "";
for (var i = 0; i < pageCount; i++) {
if (i == 0) {
pagination_html = pagination_html + "<li class='selected-page' data=" + (i + 1) + ">" + (i + 1) + "</li>";
} else {
pagination_html = pagination_html + "<li data=" + (i + 1) + ">" + (i + 1) + "</li>";
}
}

if (pageCount > 1) {
$(".pagination ul").html(pagination_html);
} else {
$(".pagination ul").empty();
}
}

$(document).on('click', '.pagination li', function() {
$("#searchResults th input").prop('checked',false);
if ($(this).hasClass("selected-page") == false) {
$(".pagination li").each(function() {
$(this).removeClass("selected-page");
});
//console.log("clicked page no" + $(this).text());
var pageNoClicked = $(this).text().trim();
getUsersList(pageNoClicked, pageSize);
var li_val = $(this).attr('data');
$(".pagination li[data="+li_val+"]").addClass("selected-page");
}
});

//receive json in function
function showUserList(payload, pageNo) {
////debugger;
if (payload.hasOwnProperty("nomineeList")) {
var nomineeMemberList = "";
for (var i in payload.nomineeList) {
//console.log(payload.nomineeList[i]);
//adding anchor tag for every field in message list
var userDetailsHref = "/t5/custom/page/page-id/ExpertEliteDetails?Id="+JSONFieldCheck(payload.nomineeList[i].id);
nomineeMemberList = nomineeMemberList + "<tr><td class='nomineeID' style='display:none'>" + JSONFieldCheck(payload.nomineeList[i].id) + "</td>" + "<td class='firstname'><a class='detailsPageLink' href='"+userDetailsHref+"' target='_blank'>" + JSONFieldCheck(payload.nomineeList[i].firstName) + "</a></td>" + "<td class='lastname'><a class='detailsPageLink' href='"+userDetailsHref+"' target='_blank'>" + JSONFieldCheck(payload.nomineeList[i].lastName) + "</a></td>" + "<td class='communityUserId'><a class='detailsPageLink' href='"+userDetailsHref+"' target='_blank'>" + JSONFieldCheck(payload.nomineeList[i].autodeskCommunityUserId) + "</td>" + "<td class='memberStatus'><a class='detailsPageLink' href='"+userDetailsHref+"' target='_blank'>" + JSONFieldCheck(payload.nomineeList[i].memberStatus) + "</a></td>" + "<td class='statusInput'><input type='checkbox' name='NomineeStatusInput' value='"+ JSONFieldCheck(payload.nomineeList[i].id)+"'></td></tr>";
}

//console.log(nomineeMemberList);
$("#searchResults tbody").html(nomineeMemberList);
$("#searchResults th input").prop('checked',false);

/* we are not creating link dinamically 
$("#searchResults tbody tr").click(function(argument) {
var nomineeID_clicked = $(this).find(".nomineeID").text().trim();
//console.log("clicked nomiee ID =>  " + nomineeID_clicked);

var redirection_url = "/t5/custom/page/page-id/ExpertEliteDetails?Id=" + nomineeID_clicked;

//console.log("redirection url => " + redirection_url);
window.open(redirection_url, '_self');
});*/

} else {
$("#searchResults tbody").html("<tr><td class='no-record-found' colspan='5'>No search results found.</td></tr>");
$("#searchResults th input").prop('checked',false);
}


}

function JSONFieldCheck(value) {
if (value == undefined)
return "-";
else
return value;
}

function filterEnable(attendedAULasVegasYearList,attendedEESummitYearList,productListProperties,socialMediaPresenceList)
{
$("#filter-values").change(function() {
//;
if ($(this).val() != "select") {
//$(this).val()+$(this).find('option:selected').attr('data-type');
var temp = $(this).find('option:selected').text();
//;
console.log("clicked" + temp);
var toolTipTextMultipleSelect = "${text.format('autodesk-EE-multiple-select-tooltip')}";
//console.log("toolTipTextMultipleSelect text log " + toolTipTextMultipleSelect);

var appliedFilter = "<tr>" + "<td class='filter-label'>" + temp + "</td>";
var selected_value = $(this).find('option:selected').val();
//console.log("selected value " + selected_value);

var text_fileds = ["firstName", "lastName", "address1", "city", "stateOrProvince", "postalCode", "communityUserId", "rankPositionCommunityUserIDs"];
var radio_fields = ["sendEECommunications","autodeskReseller", "studentOrEEProgram", "eeDirectory", "featuredEEWebsite", "helpOrSolution", "createArticle", "prdTipsUsingScreencast", "contributeBlog", "autodeskProductUserGroup", "speakerAutodeskEvents", "betaTester"];

if (text_fileds.indexOf(selected_value) >= 0) {
//console.log("text filed");
appliedFilter = appliedFilter + "<td class='input-text-field' id='" + selected_value + "'><input type='text'></td>";
} else if (radio_fields.indexOf(selected_value) >= 0) {
//console.log("radio button");
appliedFilter = appliedFilter + "<td class='input-radio-field' id='" + selected_value + "'><input type='radio' value='true' name='" + $(this).val() + "' checked >Yes</input><input type='radio' value='false' name='" + selected_value + "'>No</input></td>";
} else if (selected_value == "email") {
//console.log("email filed");
appliedFilter = appliedFilter + "<td class='input-text-field' id='" + selected_value + "'><input type='text'></td>";
setTimeout(function(){ $("#email input").attr('maxlength','200'); }, 3000);
}else if (selected_value == "email2") {
//console.log("email filed");
appliedFilter = appliedFilter + "<td class='input-text-field' id='" + selected_value + "'><input type='text'></td>";
setTimeout(function(){ $("#email input").attr('maxlength','200'); }, 3000);
} else if (selected_value == "country") {
//console.log("dropdown country");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select><option>United States</option><option>Andorra</option><option>Afghanistan</option><option>Albania</option><option>Algeria</option><option>Antigua and Barbuda</option><option>Angola</option><option>Anguilla</option><option>Argentina</option><option>Armenia</option><option>Aruba</option><option>Australia</option><option>Austria</option><option>Azerbaijan</option><option>Bahamas</option><option>Bahrain</option><option>Bangladesh</option><option>Barbados</option><option>Belarus</option><option>Belgium</option><option>Belize</option><option>Bermuda</option><option>Bhutan</option><option>Bolivia</option><option>Bosnia and Herzegovina</option><option>Botswana</option><option>Brazil</option><option>Brunei Darussalam</option><option>Bulgaria</option><option>Cameroon</option><option>Cambodia</option><option>Canada</option><option>Cayman Islands</option><option>Central African Republic</option><option>Chad</option><option>Chile</option><option>China</option><option>Christmas Island</option><option>Colombia</option><option>Congo</option><option>Congo, Dem. Republic</option><option>Costa Rica</option><option>Croatia</option><option>Cyprus</option><option>Czech Republic</option><option>Denmark</option><option>Djibouti</option><option>Dominica</option><option>Dominican Republic</option><option>Ecuador</option><option>Egypt</option><option>El Salvador</option><option>Estonia</option><option>Ethiopia</option><option>Faeroe Islands</option><option>Finland</option><option>France</option><option>Gabon</option><option>Gambia</option><option>Georgia</option><option>Germany</option><option>Ghana</option><option>Gibraltar</option><option>Greece</option><option>Greenland</option><option>Guadeloupe</option><option>Guam</option><option>Guatemala</option><option>Guyana</option><option>Haiti</option><option>Honduras</option><option>Hong Kong</option><option>Hungary</option><option>Iceland</option><option>India</option><option>Indonesia</option><option>Ireland</option><option>Israel</option><option>Italy</option><option>Jamaica</option><option>Japan</option><option>Jordan</option><option>Kazakhstan</option><option>Kenya</option><option>Korea</option><option>Kyrgyzstan</option><option>Kuwait</option><option>Latvia</option><option>Lebanon</option><option>Libya</option><option>Liechtenstein</option><option>Lithuania</option><option>Luxembourg</option><option>Macedonia</option><option>Madagascar</option><option>Malawi</option><option>Malaysia</option><option>Malta</option><option>Martinique</option><option>Mauritania</option><option>Mauritius</option><option>Mexico</option><option>Moldova</option><option>Monaco</option><option>Montenegro</option><option>Morocco</option><option>Mozambique</option><option>Myanmar</option><option>Namibia</option><option>Nepal</option><option>Netherlands</option><option>Netherlands Antilles</option><option>New Zealand</option><option>Nicaragua</option><option>Niger</option><option>Nigeria</option><option>Norway</option><option>Oman</option><option>Pakistan</option><option>Palestinian Territory, Occupied</option><option>Panama</option><option>Papua New Guinea</option><option>Paraguay</option><option>Peru</option><option>Philippines</option><option>Poland</option><option>Portugal</option><option>Puerto Rico</option><option>Qatar</option><option>Reunion</option><option>Romania</option><option>Russian Federation</option><option>Rwanda</option><option>Saint Kitts and Nevis</option><option>Saint Pierre and Miquelon</option><option>Saint Vincent and the Grenadines</option><option>San Marino</option><option>Saudi Arabia</option><option>Senegal</option><option>Serbia</option><option>Singapore</option><option>Slovakia</option><option>Slovenia</option><option>Somalia</option><option>South Africa</option><option>Spain</option><option>Sri Lanka</option><option>Swaziland</option><option>Sweden</option><option>Switzerland</option><option>Taiwan</option><option>Tajikistan</option><option>Tanzania, United Republic of </option><option>Thailand</option><option>Tunisia</option><option>Turkmenistan</option><option>Turkey</option><option>Uganda</option><option>Ukraine</option><option>United Arab Emirates</option><option>United Kingdom</option><option>Uruguay</option><option>Uzbekistan</option><option>Vatican City State (Holy See)</option><option>Venezuela</option><option>Vietnam</option><option>Virgin Islands (British)</option><option>Virgin Islands (U.S.)</option><option>Zambia</option><option>Zimbabwe</option></select></td>";

} else if (selected_value == "language") {
//console.log("dropdown language");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select multiple title='"+toolTipTextMultipleSelect+"'><option>English</option><option>French</option><option>German</option><option>Italian</option><option>Spanish</option><option>Portuguese</option><option>Russian</option><option>Japanese</option><option>Simplified Chinese</option><option>Traditional Chinese</option></select></td>";
} else if (selected_value == "shirtSize") {
//console.log("dropdown shirtSize");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select><option>Small</option><option>Medium</option><option>Large</option><option>Extra Large</option><option>2XL</option><option>3XL</option></select></td>";
} else if (selected_value == "proficiencyAustodeskProduct") {
//console.log("dropdown proficiencyAustodeskProduct");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select multiple title='"+toolTipTextMultipleSelect+"'>"+productListProperties+"</select></td>";
} else if (selected_value == "socialMediaPresence") {
//console.log("dropdown socialMediaPresence");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select multiple title='"+toolTipTextMultipleSelect+"'>"+socialMediaPresenceList+"</select></td>";
} else if (selected_value == "auLasVegas") {
//console.log("dropdown auLasVegas");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select multiple title='"+toolTipTextMultipleSelect+"'>"+attendedAULasVegasYearList+"</select></td>";
} else if (selected_value == "eeSumit") {
//console.log("dropdown eeSumit");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select multiple title='"+toolTipTextMultipleSelect+"'>"+attendedEESummitYearList+"</select></td>";
} else if (selected_value == "eeMentor") {
//console.log("dropdown eeMentor");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select><option>Active</option><option>No Longer Active</option><option>To be considered</option></select></td>";
} else if (selected_value == "memberStatus") {
//console.log("dropdown memberStatus");
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-combo-field'><select><option selected>All</option><option>EE Active</option><option>EE no longer active</option><option>EE under review</option><option>Employee Active</option><option>Employee Inactive</option><option>Nomination duplicate</option><option>Nomination new</option><option>Nomination not qualified</option><option>Nomination to be considered</option></select></td>";
} else if (selected_value == "joinedDate") {
appliedFilter = appliedFilter + "<td id='" + selected_value + "' class='input-text-field'> From: <input class='form-control datepickerFrom' placeholder='mm/dd/yyyy' data-date-format='mm/dd/yyyy'> To: <input class='form-control datepickerTo' placeholder='mm/dd/yyyy' data-date-format='mm/dd/yyyy'></td>";
}
appliedFilter = appliedFilter + "<td class='remove-filter'><img src=${asset.get('/html/assets/toggle-minus.gif')}></td></tr>";

$("#selectedFields").append(appliedFilter);
$(this).find('option:selected').attr("disabled", true);
$("#filter-values").val("select");

$("input.joinedDate").datepicker({});
$("input.datepickerFrom").datepicker({});
$("input.datepickerTo").datepicker({});
}
});
}

$(document).on("click", ".remove-filter", function() {
var temp = $(this).parent().find(".filter-label").next().attr("id");
//console.log("hi" + temp);
$("#filter-values option[value=" + temp + "]").attr("disabled", false);
$(this).parent().remove();
$("#filter-values").val("select");
});

$(".selectedFields-wrapper").keypress(function(evnt){

if(evnt.which==13){
$("#apply-filter").trigger("click");
}


});

$("#apply-filter").click(function() {
//;

if (getFilterValues()) {
getUsersList(1, pageSize);
}

});

function getFilterValues() {
;
var valid_text_fileds = true;
var valid_date = true;
var valid_multiple_select = true;

$("#selectedFields input[type=text]").each(function() {
if ($(this).val().trim() == "") {
valid_text_fileds = false;
//console.log("value of text box => "+ $(this).val().trim());
$(this).addClass("border-red");
}
else{
$(this).removeClass("border-red");
}
});

var dateFiled = $("#selectedFields input.joinedDate");
if(dateFiled.val()=="") {
dateFiled.addClass("border-red");
valid_text_fileds = false;
}
else{
dateFiled.removeClass("border-red");
}

$("#selectedFields select").each(function(){
;
if($(this).val() == null){
//console.log("not selected");
$(this).addClass("border-red");
valid_multiple_select = false;
}
else {
$(this).removeClass("border-red");
//console.log("value "+$(this).val());
}
});


if (valid_text_fileds && valid_date && valid_multiple_select) {

$("#selectedFields input[type=text]").each(function() {
$(this).removeClass("border-red");
});

var filterData = "{";
$("#selectedFields tr").each(function() {
//debugger;
var filterLabel = $(this).find(".filter-label").next().attr('id');
//console.log("filter " + filterLabel);
var filterValue;
if ($("#" + filterLabel).hasClass("input-radio-field")) {
filterValue = $("#" + filterLabel).children("[name=" + filterLabel + "]:checked").val();
}
else if ($("#" + filterLabel).hasClass("input-combo-field")){
//debugger;

    filterValue = $("#" + filterLabel+" select").val();
    
    if($.type(filterValue) === "string"){
    filterValue=filterValue.toUpperCase();
    }else{
        for(var i=0;i<filterValue.length;i++){
             filterValue[i]=filterValue[i].toUpperCase();                               
        }
    }
  

//console.log("filterData before isarry check => "+filterValue);
if(jQuery.isArray(filterValue))
{
filterValue = filterValue.join(",");
}
if(filterLabel == "socialMediaPresence")
{
filterValue = filterValue.replace(/ /g,"_");
}
//console.log("filterData after isarry check => "+filterValue);
} else {
    if(filterLabel==="communityUserId"){
    filterValue = $("#" + filterLabel).children().val();
    }else{
    filterValue = $("#" + filterLabel).children().val().toUpperCase();
    }

}

if(filterLabel==="joinedDate")
{
filterData = filterData + '"' + "startDate" + '"' + ":" + JSON.stringify($("#" + filterLabel).children()[0].value) + ',';
filterData = filterData + '"' + "endDate" + '"' + ":" + JSON.stringify($("#" + filterLabel).children()[1].value) + ',';
}
else
{
filterData = filterData + '"' + filterLabel + '":' + JSON.stringify(filterValue) + ',';
}


});

filterData = filterData + "}";

filterData = filterData.replace(/,([^,]*)$/, '$1');

//console.log(filterData);
// filterJSON = {};
localStorage.setItem("filterJSON", filterData);
console.log(filterData);
filterJSON = $.parseJSON(filterData);

//using rank position retrive community userids ajax call
//console.log(filterJSON.payload.rankPositionCommunityUserIDs);
if (typeof filterJSON.rankPositionCommunityUserIDs !== "undefined") {
var rank = Number(filterJSON.rankPositionCommunityUserIDs.trim())
if (rank >= 1 && rank <= 13) {  
//filterJSON.rankPositionCommunityUserIDs = 
getAllUserIdsFromDB(rank); 
//console.log("Apply filter button function=> "+filterData.rankPositionCommunityUserIDs);
}
else {
filterJSON.rankPositionCommunityUserIDs = "-1";
}
}

//console.log("JSON =>  " + JSON.stringify(filterJSON));
return true;
}
return false;
}

function getAllUserIdsFromDB(rank){
var getNomineeListURL = "${autodesk_ee_vm_baseurl}/expertelite/nominee/list";
//console.log("get Member Details URL  =>  " + getNomineeListURL);
//console.log("Authorization = Basic " + Base64.encode(username + ":" + password));
//console.log(JSON.stringify(filterJSON));

$.ajax({
type: "POST",
crossDomain: true,
url: getNomineeListURL,
dataType: "json",
async: false,
beforeSend: function(xhr1) {
xhr1.setRequestHeader("Authorization", "Basic " + Base64.encode(username + ":" + password));
xhr1.setRequestHeader("Content-Type", "application/json");
},
success: function(data, status, xhr) {
//do something
if(data.status == "success")
{  
var userFromDBList=[];
for(i=0;i<data.totalNomineeCount;i++)
{
if(data.nomineeList[i].autodeskCommunityUserId != null)
{
var temp_user_id = data.nomineeList[i].autodeskCommunityUserId;
if(temp_user_id != null){
temp_user_id = temp_user_id.split(",");
temp_user_id = temp_user_id[0];
}
else{
temp_user_id = "";
}

//var userLoginRegexp = new RegExp(/^[a-zA-Z0-9-_]+$/);
//username dos not satisfy the regex then push blank value
//if( !userLoginRegexp.test(temp_user_id) )
//{
//temp_user_id=""; 
//}

userFromDBList.push(temp_user_id);
}
}
userFromDBList_string = userFromDBList.join(",");
//console.log("All users of DB =>" + userFromDBList_string);

var userIDsAfterFilter = getCommunityUserIdsFromRankPosition(rank,userFromDBList_string);
//console.log("userIDS in getAllUserIdsFromDB function => "+userIDsAfterFilter);
//return userIDsAfterFilter;
}
else
{
console.log("DB error");  
}
},
error: function(e) {
console.log("error" + e);
}
});
}


function getCommunityUserIdsFromRankPosition(rankPosition,userIDsFromDB) {
var userIds;
//console.log("in function getCommunityUserIdsFromRankPosition" + rankPosition);
timeStamp1 = new Date();

$.ajax({
url: "/plugins/custom/autodesk/autodesk/autodesk.ee-rank-position-filter?rank_position=" + rankPosition+"&userIDsFromDB="+userIDsFromDB,
async: false,
cache: false,
success: function(result) {
timeStamp2 = new Date();
//console.log("Time require /autodesk/autodesk.ee-rank-position-filter call: "+ (timeStamp2 - timeStamp1)/1000 +" Sec");
//console.log("Ajax Responce => " + result);
userIds = result.trim();
//console.log("userIds=> " + userIds);
//console.log("userIDS in getCommunityUserIdsFromRankPosition function => "+userIds);
filterJSON.rankPositionCommunityUserIDs = userIds;
console.log(filterJSON.rankPositionCommunityUserIDs);
//return userIds;
},
error: function(e) {
//console.log("error" + e);
}
});

}

$("#exportCSV").click(function() {
debugger;
if (getFilterValues()) {
var csvURL = "${autodesk_ee_vm_baseurl}/expertelite/nominee/csv"
//console.log("get Member Details URL  =>  " + csvURL);
//console.log("Authorization = Basic " + Base64.encode(username + ":" + password));
//console.log(JSON.stringify(filterJSON));
timeStamp1 = new Date();
$("img.ajaxLoading").show();
$.ajax({
type: "POST",
crossDomain: true,
data: JSON.stringify(filterJSON),
url: csvURL,
dataType: "json",
async: "false",
beforeSend: function(xhr1) {
xhr1.setRequestHeader("Authorization", "Basic " + Base64.encode(username + ":" + password));
xhr1.setRequestHeader("Content-Type", "application/json");
},
success: function(data, status, xhr) {
//do something
if(data.status == "success")
{
timeStamp2 = new Date();
//console.log("Time require /nominee/csv call: "+ (timeStamp2 - timeStamp1)/1000 +" Sec");
//console.log(" csv user list are avliable");
//showUserList(data);
//add_pagination(data.totalNomineeCount,pageNo);
if(data.expertEliteDetailsList.length > 0)
{
extractCommunityIds(data.expertEliteDetailsList);
}
else
{
//console.log("No nomiees found for this filter");
$("img.ajaxLoading").hide();
}
}
else
{
$("img.ajaxLoading").hide();  
}
},
error: function(e) {
//console.log("error" + e);
$("img.ajaxLoading").hide();
}
});
}
});


function extractCommunityIds(list1) {
//console.log("in extractCommunityIds");

var communityIds = [];
for (var i = 0, len = list1.length; i < len; i++) {
var temp_user_id = list1[i].personalDetails.autodeskCommunityUserId;
if(temp_user_id != null) {
temp_user_id = temp_user_id.split(",");
temp_user_id = temp_user_id[0]; 
}
else{
temp_user_id = ""; 
}
//var userLoginRegexp = new RegExp(/^[a-zA-Z0-9-_]+$/);

//username dos not satisfy the regex then push blank value
//if( !userLoginRegexp.test(temp_user_id) )
//{
//temp_user_id=""; 
//}
communityIds.push(temp_user_id);
}

//console.log("communityIds => " + communityIds);
if(list1.length>0)
{
communityIds = communityIds.join(',');
}
//call endpoint for extracting details by user ids
timeStamp1 = new Date();

$.ajax({
type: 'POST',
url:"${expertelite_endpoint}",
//url: "/plugins/custom/autodesk/autodesk/expertelite-userdetails",
dataType: "json",
data: {
'communityIds': communityIds
},
async: false,
cache: false,
success: function(result) {
timeStamp2 = new Date();
//console.log("Time require /autodesk/expertelite-userdetails call: "+ (timeStamp2 - timeStamp1)/1000 +" Sec");
for (var i = 0, len = list1.length; i < len; i++) {
//console.log(result[i]);
list1[i]["userStats"] = result[i];
//console.log("JOSN user stats> "+JSON.stringify(list1[i]));
}

var dummyCSV = jsonToCSV(list1);
CreateCSVandDownload(dummyCSV);
$("img.ajaxLoading").hide();
},
error: function () {
$("img.ajaxLoading").hide();
}
});

}


function CreateCSVandDownload(CSV) {
var fullDate = new Date();
var currentDate = (fullDate.getMonth() + 1 ) + "/" + fullDate.getDate() + "/" + fullDate.getFullYear();
console.log("currentDate = " + currentDate);

var fileName = "ExpertElite" + currentDate;
console.log("filename = "+fileName);

if(msieversion())
{
if ( window.navigator.msSaveOrOpenBlob && window.Blob ) {
var blob = new Blob( [CSV], { type: "text/csv" } );
navigator.msSaveOrOpenBlob( blob, fileName + ".csv" );
}
} 
else {
//var uri = 'data:text/csv;charset=utf-8,' + escape(CSV);         
var blobby = new Blob([CSV], {type: 'text/csv'});
//var uri = 'data:application/csv;charset=utf-8,' + encodeURIComponent(CSV);
var link = document.createElement("a");
link.href = window.URL.createObjectURL(blobby);
link.target = "_blank";
link.id = "dyanamicExportCSVLink";

link.style = "visibility:hidden";
/* link.download = fileName;*/
link.download = fileName + ".csv";

document.body.appendChild(link);
/*var evObj = document.createEvent('MouseEvents');
evObj.initMouseEvent('click', true, true, window);
link.dispatchEvent(evObj);*/
link.click();
document.body.removeChild(link);

//----------------------------------------

/*jQuery('<a/>', {
id: 'dyanamicExportCSVLink',
href: uri,
download: fileName + ".csv",
style: "visibility:hidden",
}).appendTo('#EEMemberList');

$("#dyanamicExportCSVLink").click();
$("#dyanamicExportCSVLink").remove();*/

}
}

//fun: export csv for IE 
function msieversion() {
var ua = window.navigator.userAgent; 
var msie = ua.indexOf("MSIE "); 
if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) // If Internet Explorer, return version number 
{
return true;
} else { // If another browser, 
return false;
}
return false; 
}


$("#clear-filter").click(function() {
$(".status-inline-message").hide();
//console.log("clear filter click");
$("#searchResults th input").prop('checked',false);
$("td.remove-filter img").each(function() {
$(this).click();
});
$("#searchResults tbody").html("<tr><td class='no-record-found' colspan='5'>Click on Apply Filter.</td></tr>");
$(".pagination ul").empty();
});

$("#change-status-submit").click(function() {
//debugger;
$(".status-error-message").hide();
var statusSelected = $('.change-status-input select').val().toUpperCase();
var selected = $('#searchResults tbody tr input:checked').map(function() {return this.value;}).get().join(',');
var selectInputs=$('#searchResults tbody tr input:checked');

for(var i=0;i<selectInputs.length;i++){
var par=$(selectInputs[i]).parent().parent().find('.communityUserId .detailsPageLink');
txt=txt+par.text()+",";
;
}
txt=txt.substring(0,txt.length-1);
var selectedArray=txt.split(',');
if(selected.length == 0){
$(".status-inline-message").html("Please select record below to change status").show().css("color","red");
}
else{
if( statusSelected == 'SELECT'){
            $(".status-inline-message").html("Please select a status").show().css("color","red");
            txt="";
}
else{
            var data1 = {"status":statusSelected,"nomineeIds":selected};
            console.log(JSON.stringify(data1));
            
            $.ajax({
               type: "POST",
               crossDomain: true,
               dataType: "json",
               contentType: "application/json",
               url: "${autodesk_ee_vm_baseurl}/expertelite/nominee/statusupdate",
               data : JSON.stringify(data1),
beforeSend: function(xhr1) {
xhr1.setRequestHeader("Authorization", "Basic " + Base64.encode(username + ":" + password));
xhr1.setRequestHeader("Content-Type", "application/json");
xhr1.setRequestHeader("User-Type", "admin");
},
               success: function(){

                                            console.log("changed status successfully");
console.log("response data"+data1);
var sel=selected.split(',');
$('.status-inline-message').hide();
                                            if (getFilterValues()) {
                                                            var pageNoClicked = 1;
                                                            if( ($('.pagination li').length) > 0){
                                                                            pageNoClicked = $('.pagination li.selected-page:first').text().trim();
                                                            }
                                                            getUsersList(pageNoClicked, pageSize);
                                                            var li_val = $('.pagination li.selected-page:first').attr('data');
                                                            $(".pagination li[data="+li_val+"]").addClass("selected-page");
                                                            }

selectedArray.forEach(function(curr,index){
$.ajax({
type: "POST",
crossDomain: true,
dataType: "json",
contentType: "application/xml",
url: "https://forums${stage}.autodesk.com/autodesk/plugins/custom/autodesk/autodesk/update_role_expert_elite?user_id="+curr+"&status="+statusSelected,
success: function(data){
//debugger;
    if(data.status==="success"){
    txt="";
    $(".status-inline-message").hide();
    }else{
    $(".status-inline-message").html("User Forum Id  is invalid, Expert ELite role cannot be assigned").show().css("color","red");
    }
console.log("changed role successfully");

},
error: function(){
console.log("error in change role");
$(".status-inline-message").html("Error in Change Role for id "+curr.autodeskCommunityUserId).show().css("color","red");
}
});
});
               },
               error: function(){
                                            console.log("error in change status");
                                            $(".status-inline-message").html("Error in Change Status").show().css("color","red");
               }
            });
}
}
});

$("#searchResults th input").click(function() {
var checked = $(this).prop('checked');
if(checked == true){
$('#searchResults tbody tr input').prop('checked', true);
}
else{
$('#searchResults tbody tr input').prop('checked', false);
}
});
});


function convertToFlat(jsonObj) {


//socialMediaPresenceString variable is globally declared as it come from config call

var socialMediaChannelsConfiguration = socialMediaPresenceString;
if(socialMediaChannelsConfiguration != null) {
socialMediaChannelsConfiguration = socialMediaChannelsConfiguration.split(",");
}
else{
socialMediaChannelsConfiguration = []; 
}

var nameHandleJson = {};
var all_channels = jsonObj.proficiency.socialMediaPresence;

for(var i=0; i<socialMediaChannelsConfiguration.length; i++)
{
socialMediaChannelsConfiguration[i] =  socialMediaChannelsConfiguration[i].toLowerCase().replace(" ","_");
nameHandleJson[socialMediaChannelsConfiguration[i]]= "";
}

//console.log("-----------------1---------------------");
//console.log(socialMediaChannelsConfiguration);
//console.log(nameHandleJson);
//console.log("--------------------------------------");

for(var i=0; i<socialMediaChannelsConfiguration.length;i++)
{
for(var j=0; j<all_channels.length;j++)
{
if(all_channels[j]["name"] == socialMediaChannelsConfiguration[i].toUpperCase())
{
            //console.log("value assigned");
            nameHandleJson[socialMediaChannelsConfiguration[i]]= all_channels[j]["handle"];                
}              
}
}
var obj2 = nameHandleJson;
//console.log("-----------------2---------------------");
//console.log(nameHandleJson);
//console.log("--------------------------------------");



var obj1 = {
//Personal details
id: jsonObj.personalDetails.id,

firstName: jsonObj.personalDetails.firstName,
lastName: jsonObj.personalDetails.lastName,
email: jsonObj.personalDetails.email,
email2:jsonObj.personalDetails.email2,                                                         
sendEECommunications: jsonObj.personalDetails.sendEECommunications,
phone: jsonObj.personalDetails.phone,
address1: jsonObj.personalDetails.address1,
address2: jsonObj.personalDetails.address2,
city: jsonObj.personalDetails.city,
stateOrProvince: jsonObj.personalDetails.stateOrProvince,
postalCode: jsonObj.personalDetails.postalCode,
country: jsonObj.personalDetails.country,
languageSpoken: jsonObj.personalDetails.languageSpoken,
shirtSize: jsonObj.personalDetails.shirtSize,
autodeskCommunityUserId: jsonObj.personalDetails.autodeskCommunityUserId,
isNomWorkForAutodeskReseller: jsonObj.personalDetails.isNomWorkForAutodeskReseller,
autodeskResellerName: jsonObj.personalDetails.autodeskResellerName,
studentOrEducator: jsonObj.personalDetails.studentOrEducator,
includeInEEDirectory: jsonObj.personalDetails.includeInEEDirectory,
featuredMemberOnEEWebsite: jsonObj.personalDetails.featuredMemberOnEEWebsite,

//Proficiency details
proficiencyInAutodeskProduct: jsonObj.proficiency.proficiencyInAutodeskProduct
}

var obj3 = {
doPromoteAutodeskHelp: jsonObj.proficiency.doPromoteAutodeskHelp,
autodHelpProductSolutionURL: jsonObj.proficiency.autodHelpProductSolutionURL,
doCreateProductArticlesVideosWebinars: jsonObj.proficiency.doCreateProductArticlesVideosWebinars,
productArticleWebinarURL: jsonObj.proficiency.productArticleWebinarURL,
doProvideAutodPrdTipSolScreencast: jsonObj.proficiency.doProvideAutodPrdTipSolScreencast,
autodPrdTipSolScreencastUrl: jsonObj.proficiency.autodPrdTipSolScreencastUrl,
doContributeBlog: jsonObj.proficiency.doContributeBlog,
blogURL: jsonObj.proficiency.blogURL,
doParticipateOrLeadAutodeskProduct: jsonObj.proficiency.doParticipateOrLeadAutodeskProduct,
participateLeadAutodeskProductUserGroupDetails: jsonObj.proficiency.participateLeadAutodeskProductUserGroupDetails,
isSpeaker: jsonObj.proficiency.isSpeaker,
speakerInfo: jsonObj.proficiency.speakerInfo,
doParticipateInGunslinger: jsonObj.proficiency.doParticipateInGunslinger,
gunslingerEventsDetails: jsonObj.proficiency.gunslingerEventsDetails,

autodeskCertificatesDetails: jsonObj.proficiency.autodeskCertificatesDetails,
attendedAuLasVegas: jsonObj.proficiency.attendedAuLasVegas,
attendedEESummit: jsonObj.proficiency.attendedEESummit,
eeMentor: jsonObj.proficiency.eeMentor,
autodeskInternalNotes: jsonObj.proficiency.autodeskInternalNotes,
//nomination by related fields--------------
isSubmitterEEMember: jsonObj.personalDetails.isSubmitterEEMember,
submitterFullName: jsonObj.personalDetails.submitterFullName,
nominationSubmissionDate: jsonObj.personalDetails.nominationSubmissionDate,
//nomination by related fields--------------
memberStatus: jsonObj.proficiency.memberStatus,
//dateJoinedProgram: convertDate('yyyy-mm-dd', 'dd-mm-yyyy', jsonObj.proficiency.dateJoinedProgram),
dateJoinedProgram: jsonObj.proficiency.dateJoinedProgram,
additionalComments: jsonObj.proficiency.additionalComments,
//userStats
RegistrationDate: jsonObj.userStats.RegistrationDate,
MostRecentLogin: jsonObj.userStats.MostRecentLogin,
AcceptedSolutions: jsonObj.userStats.AcceptedSolutions,
NetKudosReceived: jsonObj.userStats.NetKudosReceived,
NetKuodsGiven: jsonObj.userStats.NetKuodsGiven,
NetForumTopics: jsonObj.userStats.NetForumTopics,
NetForumPosts: jsonObj.userStats.NetForumPosts,
RankPosition: jsonObj.userStats.RankPosition,
NetBoardsReplies: jsonObj.userStats.NetBoardsReplies,

//valuePoints
autodeskProficiency: jsonObj.valuePoints.autodeskProficiency,
socialMediaPresenceV: jsonObj.valuePoints.socialMediaPresence,
productRelatedSolutions: jsonObj.valuePoints.productRelatedSolutions,
createProductArticlesVideosWebinars: jsonObj.valuePoints.createProductArticlesVideosWebinars,
contributeBlogOrWebsite: jsonObj.valuePoints.contributeBlogOrWebsite,
participattionInOrLeadAutodeskProductUserGroups: jsonObj.valuePoints.participattionInOrLeadAutodeskProductUserGroups,
speakerAtAutodeskOrLocalCountryEvents: jsonObj.valuePoints.speakerAtAutodeskOrLocalCountryEvents,
participateInGunslinger: jsonObj.valuePoints.participateInGunslinger,
kloutScore: jsonObj.valuePoints.kloutScore,
communityRankPosition: jsonObj.valuePoints.communityRankPosition,
communityUserStat: jsonObj.valuePoints.communityUserStat,
attendedAuLasVegasV: jsonObj.valuePoints.attendedAuLasVegas,
attendedEESummitV: jsonObj.valuePoints.attendedEESummit,
autodPrdTipSolScreencast: jsonObj.valuePoints.autodPrdTipSolScreencast
};

var obj = $.extend(obj1,obj2);
obj = $.extend(obj,obj3);

return obj;
}

function jsonToCSV(jsonArray) {
;        
var arrData = typeof jsonArray != 'object' ? JSON.parse(jsonArray) : jsonArray;

var csvData = '';
csvData += csvHeaders() + '\r\n';
var row = '';


for (var i = 0; i < arrData.length; i++) {

var obj = convertToFlat(arrData[i]);
row = '';
//console.log('-- ------------*********** :',obj.attendedEESummit);
for (var key in obj) {

if(key == "RegistrationDate")
{
console.log("registration date before=> "+obj[key]);
}

var data = (typeof obj[key] === 'undefined' || obj[key] === 'null' || obj[key] == null || obj[key] === 'NULL') ? "" : obj[key];

if(jQuery.type(data) === "string")
{
data = data.replace(/\"/g,'""');
}
if(key == "RegistrationDate")
{
console.log("registration date after=> "+data);
}

row += '"' + data + '",';
// console.log(csvData);
}

row = row.slice(0, row.length - 1);
//console.log('-- ------------*********** :',row);
//console.log(' len :'+row.length)
csvData += row + '\r\n';

}

return csvData;

}

function csvHeaders() {

var header = '';

//Personal details (19)
header += "id," + "First Name," + "Last Name," + "Email," +"Email program communications,"+ "Send EE Communications," + "Phone," + "Address 1," + "Address 2," + "City," + "State or Province," + "Zip / Postal Code," + "Country," + "Language(s) spoken," + "Shirt Size," + "Autodesk Community forum user id," + "Do you work for an Autodesk reseller?," + "Autodesk ResellerName," + "Are you part of the Autodesk Student or Educator Expert program?," + "Would like to be included in the Expert Elite Directory," + "Would like to be Featured as a member on the Expert Elite web site?,";

//Proficiency details   

header +="Proficiency in Autodesk product(s)," + socialMediaPresenceString + "," + "Do you promote Autodesk Help or any product related solutions?," + "Autodesk Help Product Solution URL," + "Do you create product articles or videos or webinars used by Autodesk?," + "Product Article Webinar URL," +"Do you provide any Autodesk product tips / solutions using Screencast?,"+"Autodesk product tips / solutions using Screencast URL,"+ "Do you contribute to a blog or website?," + "Blog or Website URL," + "Do you participate in or lead Autodesk product user groups?," + "Participate Lead Autodesk Product user group details," + "Are you a speaker at Autodesk or local country events?  ," + "Speaker information," + "Do you participate in gunslinger events and/or are you a beta tester for Autodesk?," + "Gunslinger Events or Beta Tester Details," +"Autodesk Certifications,"+ "Attended AU LasVegas," + "Attended EE Summit," + "EE Mentor," + "Autodesk Internal Notes," + "Nomination submitted by Expert Elite," + "Nominated by Name," +"Nomination Submitted Date," + "Member Status," + "Date joined program,"+ "External Nomination and EE Comments,";

//userstats
header += "Registration Date," + "Most Recent Login," + "Accepted Solutions," + "Net Kudos Received," + "Net Kudos Given," + "Net Forum Topics," + "Net Forum Posts," + "Rank Position," + "Net Boards Replies,";

//Value Points
header += "autodesk Proficiency," + "social Media Presence," + "product Related Solutions," + "create Product Articles Videos Webinars," + "contribute Blog Or Website," + "participation In Or Lead Autodesk Product User Groups," + "speaker at Autodesk Or LocalCountry Events," + "participate In Gunslinger," + "Klout Score," + "Community rank position," + "Community user stat," + "Attended AU LasVegas," + "Attended EE Summit,"+"Autodesk product tips / solutions using screencast";



return header;
}

function convertDate(fromDateFormat, toDateFormat, inDate) {

var fromDateObj = {};

var dateSeparator = '-';

var fromDateArr;
var inDateArr;

fromDateArr = fromDateFormat.split(dateSeparator);

if (inDate != null) {
inDateArr = inDate.split(dateSeparator);
} else {
inDateArr = ["yyyy", "mm", "dd"];
}

for (var str in fromDateArr) {

fromDateObj[fromDateArr[str].toUpperCase()] = inDateArr[str];
}


toDateArr = toDateFormat.split(dateSeparator);

var outDate = '';
for (var i in toDateArr) {
outDate += fromDateObj[toDateArr[i].toUpperCase()] + dateSeparator;
}

outDate = outDate.slice(0, outDate.length - 1)
//console.log('----------------- ', outDate);

return outDate;

}

</@liaAddScript>

<#-- Filter Script End -->


<div id="EEMemberList">
<div class="container">
<h2>${text.format('autodesk-EE-searchPage-page-title')}</h2>


<!-- Filter DOM start -->
<div class="filter_wrapper">
<div class="filter-dropdown">
<select id="filter-values">
<option selected value="select">Select...</option>
<option value="memberStatus">Status</option>
<option value="firstName">First name</option>
<option value="lastName">Last name</option>
<option value="email">Email</option>
    
<#if admin>
    <option value="email2">Email Program Communications</option>
</#if>
<option value="sendEECommunications">Send EE Communications</option>
<option value="address1">Address 1</option>
<option value="city">City</option>
<option value="stateOrProvince">State / Province</option>
<option value="postalCode">Postal code</option>
<option value="country">Country</option>
<option value="language">Languages spoken</option>
<option value="shirtSize">Shirt size</option>
<option value="communityUserId">Autodesk Community user Id</option>
<option value="autodeskReseller">Do you work for an Autodesk reseller?</option>
<option value="studentOrEEProgram">Are you part of the Autodesk Student or Educator Expert program?</option>
<option value="eeDirectory">Would you like to be included in the Expert Elite Directory?</option>
<option value="featuredEEWebsite">Would you like to be featured as a member on the Expert Elite website?</option>
<option value="proficiencyAustodeskProduct">Proficiency in Autodesk products</option>
<option value="socialMediaPresence">Social media presence</option>
<option value="helpOrSolution">Do you promote Autodesk Help or any product related solutions?</option>
<option value="createArticle">Do you create product articles, videos or webinars used by Autodesk?</option>
<option value="prdTipsUsingScreencast">Do you provide any Autodesk product tips / solutions using Screencast?</option>
<option value="contributeBlog">Do you contribute to a blog or website?</option>
<option value="autodeskProductUserGroup">Do you participate in or lead Autodesk product user groups?</option>
<option value="speakerAutodeskEvents">Are you a speaker at Autodesk or local country events?</option>
<option value="betaTester">Do you participate in gunslinger events and/or are you a beta tester for Autodesk?</option>
<!--Using rank position retrive community user ids to that rank position-->
<option value="rankPositionCommunityUserIDs">Community rank position</option>
<option value="auLasVegas">Attended AU Las Vegas</option>
<option value="eeSumit">Attended EE Summit</option>
<option value="eeMentor">EE Mentor</option>
<option value="joinedDate">Date joined program</option>
</select>
</div>
<div class="selectedFields-wrapper">
<table>
<tbody id="selectedFields">

</tbody>
</table>
</div>
<div class="buttonsWrapper">
<input type="button" value="${text.format('autodesk-EE-searchPage-filter-button-apply')}" class="button lia-button-small" id="apply-filter">
<input type="button" value="${text.format('autodesk-EE-searchPage-filter-button-clear')}" class="button lia-button-small" id="clear-filter">
<input type="button" value="${text.format('autodesk-EE-searchPage-filter-button-exportCSV')}" class="button lia-button-small" id="exportCSV">
<img class="ajaxLoading"src="/skins/images/BF4AADEF5C6DA1F2134E9E8E3B4132C3/base/images/feedback_loading.gif" title="images.feedback_loading.title" alt="images.feedback_loading.alt" style="display: none;" >
</div>
</div>

<!-- filter DOM end-->

<br/>

<div class="searchResults-wrapper">
<div class="search-result-text">${text.format('autodesk-EE-searchPage-table-title')}</div>
<div class="pagination">
<ul>
</ul>
</div>

<div class="statusChangeWrapper">
<div class="StatusDropdownWrapper">
<table id="changeStatusDropdown">
            <tbody>
                            <tr>
                                            <td class="status-filter-label">Change Status to: </td><td class="change-status-input"><select value="Select Status"><option selected="" value="select">Select a status</option><option>EE ACTIVE</option><option>EE NO LONGER ACTIVE</option><option>EE UNDER REVIEW</option><option>EMPLOYEE ACTIVE</option><option>EMPLOYEE INACTIVE</option><option>NOMINATION DUPLICATE</option><option>NOMINATION NEW</option><option>NOMINATION NOT QUALIFIED</option><option>NOMINATION TO BE CONSIDERED</option></select></td>
                                            <td id="change-status-submit"><span class="lia-button-small">Change Status</span></td>
                            </tr>
                            <tr><td colspan="3" style="padding-top: 10px;"><span class="status-inline-message" style="display:none"></span></td></tr>
            </tbody>
</table>
</div>   
</div>

<div class="serch-list-table-wrapper">
<table class="table table-hover" id="searchResults">
<thead>
<tr>
<th>${text.format('autodesk-EE-searchPage-table-header-firstname')}</th>
<th>${text.format('autodesk-EE-searchPage-table-header-lastname')}</th>
<th>${text.format('autodesk-EE-searchPage-table-header-forumId')}</th>
<th>${text.format('autodesk-EE-searchPage-table-header-status')}</th>
              <th>${text.format('autodesk-EE-searchPage-table-header-statusInput')} <input type="checkbox" name="NomineeStatusInput" value="571"</th>
</tr>
</thead>
<tbody>

</tbody>
</table>
</div>
</div>
<div class="pagination">
<ul>
</ul>
</div>
</div>
</div>

<style>
#lia-body.ExpertEliteSearch img.ajaxLoading {
height: 24px;
vertical-align: bottom;
}
</style>

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
#lia-body.ExpertEliteSearch .lia-content #EEMemberList #searchResults td.statusInput{
padding: 12px 10px 8px 10px;
}
#lia-body.ExpertEliteSearch .lia-content #EEMemberList .searchResults-wrapper .search-result-text{
float:left;
}
#lia-body.ExpertEliteSearch .lia-content #EEMemberList #changeStatusDropdown tbody tr{
border: none;
}
#lia-body.ExpertEliteSearch .statusChangeWrapper{
clear: both;
float: right;
padding: 15px 0;
}
#lia-body.ExpertEliteSearch .status-filter-label{
padding-right: 10px;
}

#lia-body.ExpertEliteSearch .change-status-input select{
margin-right: 15px;
}

#lia-body.ExpertEliteSearch input[type="radio"],
#lia-body.ExpertEliteSearch .radioBtnText {
margin: 0 5px 0 5px;
}
</style>
</style>
