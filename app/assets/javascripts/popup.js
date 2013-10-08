$(document).ready(function(){
	$('.pop_box').hide();

    $('.usSu1').click(function(){
	    $('.pop_body, .pop_box').fadeIn(300);

	$('.pop_body, .pop_close').click(function(){
		$('.pop_box, .pop_body').fadeOut(300);
		});
	});
	$(window).resize(function(){

    $('.pop_box').css({
    position:'absolute',
    left: ($(window).width() - $('.pop_box').outerWidth())/2,
    top: ($(window).height() - $('.pop_box').outerHeight())/2
  });

 });

 $('.floatFormP123 .cl').click(function(){
 	$('.popBl').hide();
 });

 $('.polPo').click(function(){
 	$('.floatFormP').show();
 });

 $('.floatFormP .cl').click(function(){
 	$('.floatFormP').hide();
 });

 $(window).resize();
});