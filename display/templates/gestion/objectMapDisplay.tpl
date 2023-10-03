<div id="map" class="map"></div>
{if $mapIsChange == 1}
<div id="radar">
	<a href="#">
		<img src="display/images/radar.png" height="30">
		{t}Repérez votre position !{/t}
	</a>
</div>
{/if}
{include file="mapDefault.tpl"}
<script>
	var mapIsChange = "{$mapIsChange}";
	var map = setMap( "map" );
	var lon = "{$data.wgs84_x}";
	var lat = "{$data.wgs84_y}";
	var point;
	function setPosition( lat, lon ) {
		if ( point == undefined ) {
			point = L.marker( [ lat, lon ] );
			point.addTo( map );
		} else {
			point.setLatLng( [ lat, lon ] );
		}
		map.setView( [ lat, lon ] );
	}
	mapDisplay( map );


	if ( lon.length > 0 && lat.length > 0 ) {
		setPosition( lat, lon );
		if ( point == undefined ) {
			point = L.marker( [ lat, lon ] );
			point.addTo( map );
		}
	}

	if ( mapIsChange == 1 ) {
		/*
		 * Traitement de la localisation par clic sur le radar
		 * (position approximative du terminal)
		 */
		$( "#radar" ).click( function () {
			if ( navigator && navigator.geolocation ) {
				navigator.geolocation.getCurrentPosition( function ( position ) {
					var lon = position.coords.longitude;
					var lat = position.coords.latitude;
					$( "#wgs84_x" ).val( lon );
					$( "#wgs84_y" ).val( lat );
					setPosition( lat, lon );
				} );
			}

		} );

		$( ".position" ).change( function () {
			var lon = $( "#wgs84_x" ).val();
			var lat = $( "#wgs84_y" ).val();
			if ( lon.length > 0 && lat.length > 0 ) {
				setPosition( lat, lon );
			}
		} );

		map.on( 'click', function ( e ) {
			setPosition( e.latlng.lat, e.latlng.lng );
			$( "#wgs84_x" ).val( e.latlng.lng );
			$( "#wgs84_y" ).val( e.latlng.lat );
		} );
	}

</script>