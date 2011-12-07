//This has to be done client side due to server sanitization not allowing the target attribute
function setPostAnchorTarget(target) { $('a.' + target).attr('target', target); }

//This has to be done client side due to server sanitization not allowing the iframe attribute
function embedVideo() {
  $('.video').each(function() {
    var src = $(this).attr('src');
    if (src) {
      $(this).html('<iframe width="455" height="338" src="' + src + '" frameborder="0" allowfullscreen></iframe>');
    }
  });
}
