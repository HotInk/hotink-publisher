$(function() {
	
	//Carousel for featured articles 	
    $(".features_carousel").jCarouselLite({
		visible: 1,
		auto: 7500,
		speed: 1700,
        btnNext: ".next",
        btnPrev: ".prev",
		btnGo:
		[".indicators .1", ".indicators .2", ".indicators .3", ".indicators .4"]
    });

});
