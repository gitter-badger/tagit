$(function() {
  attachToggleUserProfile();
});

function attachToggleUserProfile() {
  $('#toggle_profile').on('click.toggle_profile', toggleUserProfile);
}

function toggleUserProfile() {
  $(this).children('.expand_button, .collapse_button').toggleClass('expand_button').toggleClass('collapse_button');
  $('.user_info').children('.user_profile').animate({ height: 'toggle' }, ANIMATION_DURATION);
}
