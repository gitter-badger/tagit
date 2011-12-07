$(document).ajaxComplete(function(event, request) {
  var error = request.getResponseHeader('Flash-Error-Message');
  if (error) showFlash(error, 'error');
  
  var warning = request.getResponseHeader('Flash-Warning-Message');
  if (warning) showFlash(warning, 'warning');
  
  var notice = request.getResponseHeader('Flash-Notice-Message');
  if (notice) showFlash(notice, 'notice');
});

function showFlash(message, type) {
  var close_button = '<span id="close_client_flash" class="delete_button">×</span>';
  var client_flash = $('#client_flash');
  client_flash.html(message + close_button);
  client_flash.attr('class', type);
  $('#close_client_flash').bind('click.flash', function() {
    client_flash.attr('class', null);
    client_flash.empty();
  });
}
