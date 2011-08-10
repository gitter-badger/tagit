module ApplicationHelper
  def logo
    @logo = image_tag("logo.png", :alt => t(:app_name), :class => "round")
  end

  def title # return a title on a per-page basis.
    base_title = t(:base_title)
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
