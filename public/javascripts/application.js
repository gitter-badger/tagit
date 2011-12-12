var closeButton = '<span class="close_client_flash delete_button">×</span>';

$(function() {
  $('.flash').each(function() {
    var flash = $(this);
    flash.append(closeButton);
    flash.children('.close_client_flash').on('click.flash', function() { flash.remove(); });
  });
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
  client_flash.append('<div class="flash ' + type + '">' + message + closeButton + '</div>');
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
  $('#' + collapsedElement).slideToggle(200);
}
