function initialize() {
	/* Google Maps Init */
	var myLatlng = new google.maps.LatLng(43.640268, -79.390018);
	var myOptions = {
		zoom: 12	,
		center: myLatlng,
		popup: true,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	var map = new google.maps.Map(document.getElementById("google-map-contact"), myOptions);
	
	var marker = new google.maps.Marker({
		position: myLatlng, 
		map: map,
		title: "Our Location"
	});
	google.maps.event.addListener(marker, 'click', function() {
		map.setZoom(12);
	});
}