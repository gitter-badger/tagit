//This has to be done client side due to server sanitization not allowing the target attribute
function setPostAnchorTarget(target) { $('a.' + target).attr('target', target); }

//This has to be done client side due to server sanitization not allowing the iframe attribute
function embedVideo() {
  $('.video').each(function() {
    var src = $(this).attr('src');
    if (src) {
      $(this).on('click.video', { src: src }, clickVideo);
    }
  });
}

function clickVideo(event) {
  $(this).off('click.video'); //There is a 4px region on the bottom of the div that can still be clicked, so turn the handler off
  $(this).html('<iframe width="455" height="338" src="http://youtube.com/embed/' + event.data.src + '?autoplay=1" frameborder="0" allowfullscreen></iframe>');
  var self = this;
  $('.video').each(function() {
    if (this != self && $(this).children('iframe').length > 0) { //That's just one
      $(this).on('click.video', { src: event.data.src }, clickVideo); //Attach the handler for other videos back on
      $(this).html('<img src="http://img.youtube.com/vi/' + event.data.src + '/0.jpg" /><div class="play_video"></div>');
    }
  });
}
