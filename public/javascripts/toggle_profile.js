$(function() {
  $('#toggle_profile').on('click.toggle_profile', toggleUserProfile);
});

function toggleUserProfile() {
  $(this).toggleClass('expand_button').toggleClass('collapse_button');
  $('.main_bar').toggleClass('main_bar_expanded');
  $('.info_bar').toggle();
}
