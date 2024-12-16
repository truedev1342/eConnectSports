// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.purr
//= require popover.js
//= require best_in_place
//= require bootstrap-colorpicker
//= require_tree ./app

$(document).ready(function(){
	// Twitter Bootstrap iPad fix for dropdown top nav
	$('body').on('touchstart.dropdown', '.dropdown-menu', function (e) { e.stopPropagation(); });
	// Place form labels inside field
	$("div.control-label > label").inFieldLabels();
	$('.rs-carousel').carousel({});
  $('.auto-submit').change(function() {
    this.form.submit();
  });



});

// Add rounded corners to .roundedImage images
function hasBorderRadius() {
  var d = document.createElement("div").style;
  if (typeof d.borderRadius !== "undefined") return true;
  if (typeof d.WebkitBorderRadius !== "undefined") return true;
  if (typeof d.MozBorderRadius !== "undefined") return true;
  return false;
};
if (hasBorderRadius()) { // 1
  $("img.roundedImage").each(function() { // 2
    $(this).wrap('<div class="roundedImage" />'); // 3
    var imgSrc = $(this).attr("src"); // 4
    var imgHeight = $(this).height(); // 4
    var imgWidth = $(this).width(); // 4
    $(this).parent()
      .css("background-image", "url(" + imgSrc + ")")
      .css("background-repeat","no-repeat")
      .css("height", imgHeight + "px")
      .css("width", imgWidth + "px"); // 5
    $(this).remove(); // 6
  });
};
