//This has to be done client side due to server sanitization not allowing the target attribute
function setPostAnchorTarget(target) { $('a.' + target).attr('target', target); }