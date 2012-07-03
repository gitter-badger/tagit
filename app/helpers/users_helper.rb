module UsersHelper
  def gravatar_for(user, options = { :size => 200 })
    gravatar_image_tag(user.email.downcase, :alt => user.username, :title => user.name.blank? ? user.username : user.name, :class => 'gravatar', :gravatar => options)
  end
  
  def connect_button(provider)
    link_to(provider.capitalize, "/auth/#{provider}/", :class => "#{provider}_connect_button")
  end
end
