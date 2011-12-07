// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$().ajaxComplete(function(event, request) {
  var error = request.getResponseHeader('X-Error-Message');
  if (error) alert(error);

  var warning = request.getResponseHeader('X-Warning-Message');
  if (warning) alert(warning);

  var notice = request.getResponseHeader('X-Notice-Message');
  if (notice) alert(notice);
});
