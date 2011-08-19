module ApplicationHelper
  def logo
    @logo = image_tag("logo.png", :alt => t(:app_name))
  end

  def title # return a title on a per-page basis.
    base_title = t(:base_title)
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def pageless(total_pages, url = nil, target = nil, container = nil)
    opts = { :totalPages => total_pages, :url => url, :loader => "#" + target }
    container && opts[:container] ||= container
    javascript_tag("jQuery('##{target}').pageless(#{opts.to_json});")
  end
end
