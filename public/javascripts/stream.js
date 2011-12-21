$(function() {
  setAnchorTarget('_blank');
  embedVideo();
  attachTogglePost();
});

$(document).ajaxComplete(function(event, request) {
  setAnchorTarget('_blank');
});

//This has to be done client side due to server sanitization not allowing the 'target' attribute
function setAnchorTarget(target) {
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

function attachTogglePost() {
  $('#toggle_all_posts').on('click.expand_all', '.expand_all_posts', function() { clickEach($('#stream').find('.expand_button:visible')); });
  $('#toggle_all_posts').on('click.collapse_all', '.collapse_all_posts', function() { clickEach($('#stream').find('.collapse_button:visible')); });
  $('#stream').on('click.toggle_post', '.expand_button, .collapse_button', togglePost);
}

function togglePost() {
  $(this).closest('.post_item').children('.expanded_post, .collapsed_post').animate({ height: 'toggle' }, ANIMATION_DURATION);
}
