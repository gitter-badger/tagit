$(function() {
  setPostAnchorTarget('_blank');
  embedVideo();
});

$(document).ajaxComplete(function(event, request) {
  setPostAnchorTarget('_blank');
});

//This has to be done client side due to server sanitization not allowing the 'target' attribute
function setPostAnchorTarget(target) {
  $('a.' + target).attr('target', target);
}

//This has to be done client side due to server sanitization not allowing the 'iframe' attribute
function embedVideo() {
  $('#stream').on('click.video', '.video', clickVideo);
}

function clickVideo() {
  if ($(this).children('iframe').length > 0) return; //There is a 4px region on the bottom of the div that can still be clicked after the video has started
  $(this).html('<iframe width="100%" height="360" src="http://youtube.com/embed/' + $(this).attr('src') + '?autoplay=1" frameborder="0" allowfullscreen></iframe>');
  var self = this;
  $('.video').each(function() { //Revert any playing videos back to static images
    if (this != self && $(this).children('iframe').length > 0) {
      $(this).html('<img src="http://img.youtube.com/vi/' + $(this).attr('src') + '/0.jpg" /><div class="play_video"></div>');
    }
  });
}
