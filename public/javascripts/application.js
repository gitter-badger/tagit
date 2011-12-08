var closeButton = '<span class="close_client_flash delete_button">×</span>';

$(function() {
  $('.flash').each(function() {
    $(this).append(closeButton);
    $(this).children('.close_client_flash').on('click.flash', function() { $(this).parent().remove(); });
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
