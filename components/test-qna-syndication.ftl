<div id="target-element-in-DOM"></div>
<script>
function LithiumScriptsLoadedCallback() {
	var compId = LITHIUM.Activecast.Widget.init({
		id: 'qanda.widget.qanda-messages-widget',
		parameters: {        
				'page-size': '6',
				'board-id': 'test-q-n-a'
		},
		useLoader: false,
		target: document.getElementById('target-element-in-DOM')
	});
}
</script>



<script type="text/javascript" data-li-url="/t5/activecast/iframepage" id="lia-syndicate" src="/html/assets/js/activecast/widget.js"></script>