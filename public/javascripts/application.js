var ANIMATION_DURATION = 200;
var CLOSE_BUTTON = '<span class="close_client_flash delete_button">×</span>';

$(function() {
  //Enable flash closing
  $('.flash').each(function() {
    var flash = $(this);
    flash.append(CLOSE_BUTTON);
    flash.children('.close_client_flash').on('click.flash', function() { flash.remove(); });
  });
  
  //Attach submit click handlers
  $(document).on('click.submit', 'a.submit', function() { $(this).closest('form').submit(); return false; });
  $(document).on('click.submit', 'input.submit', function() { $(this).closest('form').submit(); });
  
  //Attach autocompleting of tags
  $('.tag_list').on('click.select', '.tag', function() {
    var tagListTextBox = $(this).closest('.tag_list').children('input[type=text]');
    var lastIndexOfDelimiter = tagListTextBox.val().lastIndexOf(',');
    var separator = (lastIndexOfDelimiter != -1 ? ' ' : '');
    var previousTags = tagListTextBox.val().substring(0, lastIndexOfDelimiter + 1);
    tagListTextBox.val(previousTags + separator + $(this).html() + ', ');
    tagListTextBox.focus();
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
  var clientFlash = $('#client_flash');
  clientFlash.append('<div class="flash ' + type + '">' + message + CLOSE_BUTTON + '</div>');
  clientFlash.children('.flash').filter(':last').children('.close_client_flash').on('click.flash', function() { $(this).parent().remove(); });
}

function toggleCollapsed(sender, collapsedElement) {
  $(sender).children('.expand_button, .collapse_button').toggleClass('expand_button').toggleClass('collapse_button');
  $('#' + collapsedElement).animate({ height: 'toggle' }, ANIMATION_DURATION);
}

function tagListTextBoxKeyUp(event, path, post_id) {
  var sender = event.srcElement;
  switch (event.keyCode) {
    case 13: //Enter
      if (post_id != undefined) {
        $('#post_' + post_id + '_add_tags').click();
      }
      break;
    case 27: //Escape
      if (post_id != undefined) {
        $('#post_' + post_id + '_show_add_tags').toggle(true);
        $('#post_' + post_id + '_add_tags').toggle(false);
        $(sender).toggle(false);
      }
      break;
    default:
      if (!(event.keyCode == 8 || //Backspace
        event.keyCode == 46 || //Delete
        String.fromCharCode(event.keyCode).match(/\w/))) {
        return;
      }
      
      var lastIndexOfDelimiter = $(sender).val().lastIndexOf(',');
      var query = $(sender).val().substring(lastIndexOfDelimiter + 1);
      if (query.length == 0) break;
      
      getAutocompleteTags(sender, path, query);
      return; //Do not remove the #autocomplete_tags div
  }
  $('#autocomplete_tags').remove();
}

function getAutocompleteTags(sender, path, query) {
  query = $.trim(query);
  if (query.length == 0) return;

  $.ajax({
    url: path + '?search=' + encodeURIComponent(query),
    context: sender,
    success: function(data) {
      $('#autocomplete_tags').remove();
      if (data.length > 0) {
        $(sender).after('<div id="autocomplete_tags"></div>');
        $('#autocomplete_tags').html(data);
        $('#autocomplete_tags').append('<div class="clear"></div>');
      }
      
      $(document).one('click.close_autocomplete', ':not(#' + sender.id + ')', function() {
        $('#autocomplete_tags').remove();
      });
    }
  });
}

function addTags(sender, post_id, show) {
  $('#post_' + post_id + '_show_add_tags').toggle(!show);
  $('#post_' + post_id + '_add_tags').toggle(show);
  
  var tagListTextBox = $('#post_' + post_id + '_tag_list_text_box');
  tagListTextBox.toggle(show);
  if (show) {
    tagListTextBox.val('');
    tagListTextBox.focus();
  }
  else {
    sender.href += '&added_tags=' + encodeURIComponent(tagListTextBox.val());
  }
}
