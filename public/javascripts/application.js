var ANIMATION_DURATION = 200;
var CLOSE_BUTTON = '<span class="close_client_flash delete_button">×</span>';

$(function() {
  $('.flash').each(function() {
    var flash = $(this);
    flash.append(CLOSE_BUTTON);
    flash.children('.close_client_flash').on('click.flash', function() { flash.remove(); });
  });
  
  //Attach submit click handlers
  $('a.submit').click(function() { $(this).closest('form').submit(); return false; });
  $('input.submit').click(function() { $(this).closest('form').submit(); });
});

$(document).ajaxComplete(function(event, request) {
  var error = request.getResponseHeader('Flash-Error-Message');
  if (error) addFlash(error, 'error');
  
  var warning = request.getResponseHeader('Flash-Warning-Message');
  if (warning) addFlash(warning, 'warning');
  
  var notice = request.getResponseHeader('Flash-Notice-Message');
  if (notice) addFlash(notice, 'notice');
});

function addFlash(message, type) {
  var client_flash = $('#client_flash');
  client_flash.append('<div class="flash ' + type + '">' + message + CLOSE_BUTTON + '</div>');
  client_flash.children('.flash').filter(':last').children('.close_client_flash').on('click.flash', function() { $(this).parent().remove(); });
}

function toggleCollapsed(sender, collapsedElement) {
  var expand_button = $(sender).children('.expand_button');
  if (expand_button.length > 0) {
    expand_button.attr('class', 'collapse_button');
  }
  else {
    $(sender).children('.collapse_button').attr('class', 'expand_button');
  }
  $('#' + collapsedElement).animate({ height: 'toggle' }, ANIMATION_DURATION);
}

function submitForm(element) {
  $(element).closest('form').submit();
  return false;
}

function addTags(self, post_id, show) {
  $('#post_' + post_id + '_show_add_tags').toggle(!show);
  $('#post_' + post_id + '_add_tags').toggle(show);
  
  added_tags_text_box = $('#post_' + post_id + '_added_tags');
  added_tags_text_box.toggle(show);
  if (show) {
    added_tags_text_box.val('');
    added_tags_text_box.focus();
  }
  else {
    self.href += '&added_tags=' + encodeURIComponent(added_tags_text_box.val());
  }
}
