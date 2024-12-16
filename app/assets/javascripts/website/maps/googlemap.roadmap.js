function initialize() {
  var streetViewOptions = {
    panControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT
    },
    zoomControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT
    },
    addressControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER
    },
    visible: false
  };
  
  var street = new google.maps.StreetViewPanorama(document.getElementById('google-map'), streetViewOptions);
  
  var mapOptions = {
    center: new google.maps.LatLng(43.640268, -79.390018),
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    panControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT
    },
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.SMALL,
      position: google.maps.ControlPosition.TOP_RIGHT
    },
    streetView: street
  };
  
  var map = new google.maps.Map(document.getElementById('google-map'), mapOptions);
  
  google.maps.event.addListener(map, 'visible_changed', function() {
    alert('a');
  });
  
  map.setTilt(45);
}