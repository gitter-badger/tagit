// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ajaxComplete(function(event, request) {
  var error = request.getResponseHeader('X-Error-Message');
  if (error) showFlash(error, 'error');
  
  var warning = request.getResponseHeader('X-Warning-Message');
  if (warning) alert(warning, 'warning');
  
  var notice = request.getResponseHeader('X-Notice-Message');
  if (notice) alert(notice, 'notice');
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
