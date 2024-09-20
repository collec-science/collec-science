<script>
$(document).ready(function () {
	$('.image-popup-no-margins').magnificPopup( {
		type: 'image',
		closeOnContentClick: true,
		closeBtnInside: false,
		fixedContentPos: true,
		mainClass: 'mfp-no-margins mfp-with-zoom', // class to remove default margin from left and right side
		image: {
			verticalFit: false
		},
		zoom: {
			enabled: true,
			duration: 300 // don't foget to change the duration also in CSS
		}
	});
	var documentChangeShow = 0;
	$('#documentChange').hide("") ;
	$('#documentChangeActivate').click(function () {
		if (documentChangeShow == 0) {
			$('#documentChange').show("");
			documentChangeShow = 1 ;
			 $("html, body").animate({ scrollTop: $(document).height() }, 1000);
		} else {
			$('#documentChange').hide("");
			documentChangeShow = 0 ;
		}
	});
});
</script>