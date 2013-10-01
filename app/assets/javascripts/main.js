$(function(){
	console.log("loaded");
	$('.container ul').animate({opacity:1},1000);
	var height = $(window).innerHeight();
	if (height-437 >= 343) {
		$('.description').css('min-height', height-473);
	}
	console.log("done");
	
	$(document).on('resize',function() {
		var height = $(window).innerHeight();
		if (height-437 >= 343) {
			$('.description').css('min-height', height-473);
		}
	});
});

//$(document).ready(function() {
//	$('.container ul').show('slow');
//});
