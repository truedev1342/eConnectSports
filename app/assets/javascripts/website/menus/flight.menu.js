jQuery.fn.exists = function() {
  return (this.length > 0) ? this : false;
};


$(document).ready(function() {
  /*
   * Global variables
   */
  var $menu = $("#menu");
  var $pix_per_em = 16.0;
  var resize_height = 750;
  
  var $menu_desc = $('<div />', {
    'class': 'menu-desc',
    'id':    'menu-desc'
  }).appendTo('body');

  $('#menu a').each(function() {
	var text = $(this).data('title') ? $(this).data('title') : ' ';
    $('<span />').text(text).appendTo($('<div />').appendTo($menu_desc).width(0));
  });

  var $selected = $menu.find('.active').exists() || $menu.find('li').first();
  var $moving = $('<li />', {
    'class': 'move',
    'top':   $selected[0].offsetTop,
    'width': $selected[0].offsetWidth
  });
  
  
  /*
   * Helper functions
   */
  function moveTo($elem, speed) {
    $moving.stop(true).animate({
      top:   $elem[0].offsetTop,
      width: $elem.outerWidth()
    }, speed, 'easeOutExpo');
  }
  
  function calculateOffsets() {
    $('#menu-desc > div').each(function(i) {
      $(this).css('top', $menu.find('li').eq(i)[0].offsetTop);
    });
  }
  
  
  /*
   * Browser-specific hacks
   */
  if ($.browser.webkit || $.browser.opera) {
    $('<style type="text/css">#menu, #menu-desc, .move { visibility: hidden; } .wf-active #menu, .wf-active #menu-desc, .wf-active .move { visibility: visible; }</style>').appendTo('head');
  }
   
  WebFont.load({
    custom: {
      families: ['League Gothic Regular']
    },
    
    active: function(fontFamily, fontDescription) {
      moveTo($selected, 0);
      calculateOffsets();
    }
  });

  
  /*
   * Menu logic
   */
  $menu.mouseleave(function () {
    moveTo($selected, 400);
  }).append($moving);
  
  $('#menu li:not(.move)').hover(function () {
    var $this = $(this);
    
    if ($this.find('a').data('title')) {
      $('#menu-desc > div').eq($(this).index()).stop(true).css('z-index', 1).animate({
        'width': 0.975 * ($(window).width() - $this.outerWidth())
      }, 400, 'easeOutExpo');
    }
    moveTo($this, 400);
  }, function () {
    $('#menu-desc > div').eq($(this).index()).stop(true).animate({
      'width': 0
    }, 400, 'easeOutExpo');
  });
  
  $(window).resize(function() {
    var height = $(this).height();
    
    if (height < resize_height) {
      if (height < 370) {
        $('#menu-desc, #menu').css('top', '120px');
      } else if (height < 800) {
        $('#menu-desc, #menu').css('top', '220px');
      } else {
        $('#menu-desc, #menu').css('top', height * 0.5);
      }
      
      document.body.style.fontSize = $pix_per_em * (height / resize_height) + 'px';
      moveTo($selected, 0);
      calculateOffsets();
    }
	  moveTo($selected, 0);
	  calculateOffsets()
  }).resize();
});


/*
 *  Back To Top
 */
$(document).ready(function(){

	// hide #back-top first
	$("#back-top").hide();
	
	// fade in #back-top
	$(function () {
		$(window).scroll(function () {
			if ($(this).scrollTop() > 100) {
				$('#back-top').fadeIn();
			} else {
				$('#back-top').fadeOut();
			}
		});

		// scroll body to 0px on click
		$('#back-top a').click(function () {
			$('body,html').animate({
				scrollTop: 0
			}, 800);
			return false;
		});
	});

});


/*
 *  Hover Fade
 */
$(document).ready(function() {

$('.hover-fade, .pages-icon').hover(function() {
    $(this).stop().fadeTo('fast', 1.0);
}, function() {
    $(this).stop().fadeTo('fast', 0.7);
}).fadeTo('normal', 0.7);

});