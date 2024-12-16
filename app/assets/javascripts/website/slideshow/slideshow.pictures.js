//  Flight:  Full Screen Slideshow Pictures
jQuery(function($){
				
	$.slideshow({
			
		// Functionality
		slide_interval          :   5000,		// Length between transitions
		transition              :   1, 			// 0-None, 1-Fade, 2-Slide Top, 3-Slide Right, 4-Slide Bottom, 5-Slide Left, 6-Carousel Right, 7-Carousel Left
		transition_speed		:	700,		// Speed of transition
															   
		// Components							
		slide_links				:	'blank',	// Individual links for each slide (Options: false, 'num', 'name', 'blank')
		slides 					:  	[			// Slideshow Images
										{image : '/assets/website/background/slideshow/mgolf.jpg',},
										{image : '/assets/website/background/slideshow/msoc.jpg',},  
										{image : '/assets/website/background/slideshow/baseball.jpg',},
										{image : '/assets/website/background/slideshow/fieldhockey.jpg',},
										{image : '/assets/website/background/slideshow/mten.jpg',},
										{image : '/assets/website/background/slideshow/baseball.jpg',},
										{image : '/assets/website/background/slideshow/lax.jpg',},
										{image : '/assets/website/background/slideshow/football.jpg',},
										{image : '/assets/website/background/slideshow/baseball.jpg',},
										{image : '/assets/website/background/slideshow/mvol.jpg',},
										{image : '/assets/website/background/slideshow/mbasketball.jpg',},
										{image : '/assets/website/background/slideshow/baseball.jpg',},
                                        {image : '/assets/website/background/slideshow/rubgby_slider1.png',},
                                        {image : '/assets/website/background/slideshow/swimming_slider2.png',}
									]

	});
});