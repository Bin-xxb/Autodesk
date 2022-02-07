<script src="https://forums-dev.autodesk.com/html/assets/DHXOxygen.js"></script>
<script>
// defined by DHXOxygen.js
const DHXOxygen = window.DHXOxygen || {};
// setup DHOxygen
if (typeof DHXOxygen.setOptions === 'function') {
	console.log('DHXOxygen.setOptions');
	DHXOxygen.setOptions({
		//environment: 'production', // OR 'staging'
		environment: 'staging',
		onOpenIDResponse: function(params) {
			console.log('onOpenIDResponse');
			console.log(params);
		}
	});

	DHXOxygen.checkImmediate("https://forums-dev.autodesk.com/html/assets/oxygen_openid_response.html");
}
</script>