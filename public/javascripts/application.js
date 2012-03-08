var ANIMATION_DURATION = 200;
var CLOSE_BUTTON = '<span class="close_client_flash delete_button">×</span>';

$(function() {
  $('.flash').each(function() {
    var flash = $(this);
    flash.append(CLOSE_BUTTON);
    flash.children('.close_client_flash').on('click.flash', function() { flash.remove(); });
  });
  
  //Attach submit click handlers
  $('body').on('click.submit', 'a.submit', function() { $(this).closest('form').submit(); return false; });
  $('body').on('click.submit', 'input.submit', function() { $(this).closest('form').submit(); });
  
  $('.autocomplete_tags').on('click.select', 'div.tag', function() { console.log('selected'); });
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
  $(sender).children('.expand_button, .collapse_button').toggleClass('expand_button').toggleClass('collapse_button');
  $('#' + collapsedElement).animate({ height: 'toggle' }, ANIMATION_DURATION);
}

function addedTagsTextBoxKeyUp(event, self, post_id) {
  switch (event.keyCode) {
    case 13: //Enter
      $('#post_' + post_id + '_add_tags').click();
      break;
    case 27: //Escape
      $('#post_' + post_id + '_show_add_tags').toggle(true);
      $('#post_' + post_id + '_add_tags').toggle(false);
      $(self).toggle(false);
      break;
    default:
      var lastIndexOfDelimiter = $(self).val().lastIndexOf(',');
      var query = $(self).val().substr(lastIndexOfDelimiter + 1);
      if (query.length == 0) {
        $('#autocomplete_tags_post_' + post_id).remove();
        return;
      }
      
      $.ajax({
        url: 'tags?search=' + query,
        context: self,
        success: function(data) {
          $('#autocomplete_tags_post_' + post_id).remove();
          data = $.trim(data);
          if (data.length > 0) {
            $(this).after('<div id="autocomplete_tags_post_' + post_id + '" class="autocomplete_tags"></div>');
            $('#autocomplete_tags_post_' + post_id).html(data);
            $('#autocomplete_tags_post_' + post_id).append('<div class="clear"></div>');
          }
          
          //TODO: Close the tag picker if clicked anywhere in the body except the autocomplete_tags_post_X div and the input itself
          
          //TODO: Attach a click handler to each tag
        }
      });
  }
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

function clickEach(elements) {
  elements.each(function() { $(this).click(); });
}
