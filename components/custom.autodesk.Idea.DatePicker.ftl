<!doctype html>
<html lang="en">
<head>
  
  <title>jQuery UI Datepicker - Default functionality</title>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/datepick/5.1.1/js/jquery.plugin.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/datepick/5.1.1/js/jquery.datepick.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/datepick/5.1.1/css/jquery.datepick.css">
  <script>
  $( function() {
       
    $('#datepickerTo').click(function(){
      if($("#datepickerFrom").val() === '')
      {
          $("#datepickerFrom").val("01/01/2012");
      }
    });
    
    $('#datepickerFrom').click(function(){
      var d = new Date();
      var month = d.getMonth()+1;
      var day = d.getDate();
      var year=d.getFullYear();
      if($("#datepickerTo").val() === '')
      {
          $("#datepickerTo").val(month+"/"+day+"/"+year);
      }
    });
    
    $( "#datepickerFrom" ).datepick();
    $( "#datepickerTo" ).datepick();
  } );
  </script>
</head>
<body>
 <div class="lia-date-picker" style="display:flex;">
   <div style="display:flex;width: 240px;margin-right: 15px;">
<span style="line-height:20px;padding-right: 5px;">${text.format('idea-batch-process-datepicker-date-from-label')}</span><input type="text" id="datepickerFrom">
  </div>
      <div style="padding-left:5px;display:flex;width: 240px;">
<span style="line-height:20px;padding-right: 5px;">${text.format('idea-batch-process-datepicker-date-to-label')}</span><input type="text" id="datepickerTo">
  </div>
 </div>
 
</body>
</html>