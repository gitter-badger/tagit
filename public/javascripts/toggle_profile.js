$(function() {
  $('#toggle_profile').on('click.toggle_profile', toggleUserProfile);
});

function toggleUserProfile() {
  $(this).toggleClass('expand_button').toggleClass('collapse_button');
  $('.new_post').find('input').toggleClass('input_expanded');
  $('.new_post').find('textarea').toggleClass('textarea_expanded');
  $('.main_bar').toggleClass('main_bar_expanded');
  $('.info_bar').toggle();
}
