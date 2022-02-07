<div class="overlay">
	<div class="loader"></div>
</div>


  
<style>
  .loader {
    height: 100%;
    z-index: 20;
  	 border: 16px solid #f3f3f3; /* Light grey */
    border-top: 16px solid #3498db; /* Blue */
    border-radius: 50%;
    width: 120px;
    height: 120px;
    animation: spin 2s linear infinite;
    margin: 60px auto auto auto;
    top: 50%;
    position: relative;
    display:flex;
    align-items:center;
    justify-content:center;
}
 @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.overlay {
    background: #e9e9e9;
    display: none;
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    opacity: 0.5;
}
</style>

<script>
$('#go-button').click(function(event){
debugger;
$('.overlay').show();
});

  

  </script>




