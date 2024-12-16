$(document).ready(function() {
  $('#submenu div.submenu').hoverIntent(function() {
    $('.submenu-head', this).addClass('visible'); 
    
    $(this).siblings().each(function() {
      $('div.submenu-body', this).stop(true).slideUp('slow', function() { $(this).height('auto'); });
      $('p.submenu-head', this).removeClass('visible');
    });
    
    $('div.submenu-body', this).stop(true).slideDown(500);
  }, function() {
    $('.submenu-head', this).removeClass('visible');
    
    $('div.submenu-body', this).stop(true).slideUp('slow', function() { $(this).height('auto'); });
  });
});
