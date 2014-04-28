(function($){
  $('#main-content h2').each(function(i){
    $(this).attr('id', 'h2-'+i);
    $('#navmenu').append('<li><a href="#h2-'+i+'">'+$(this).text()+'</a></li>');
  });
  $('a[href^=#]').click(function(){
    var speed = 500;
    var href= $(this).attr("href");
    var target = $(href == "#" || href == "" ? 'html' : href);
    var position = target.offset().top;
    $("html, body").animate({scrollTop:position}, speed, "swing");
    return false;
  });
})(jQuery);