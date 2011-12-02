module PostsHelper
  TRUNC_POST_LENGTH = 200
  MAX_WORD_WIDTH = 43
  ZERO_WIDTH_SPACE = '&#8203;'
  IMAGE_URL_REGEX = /(?:([^:\/?#]+):)?(?:\/\/([^\/?#]*))?([^?#]*\.(?:jpg|gif|png))(?:\?([^#]*))?(?:#(.*))?/
  
  def format_post(content)
    raw_content = content.gsub(/\n/, '<br>').gsub(/@(\w+)/, link_to('@\\1', users_path + '/\\1'))
    split_content = raw_content.split.map{ |s| wrap_long_string(s) }.join(' ')
    insert_image = split_content.gsub(IMAGE_URL_REGEX, '<img src="\\0" width="455" />')
    formatted_content = simple_format(insert_image)
  end
  
  private
    def wrap_long_string(text, max_width = MAX_WORD_WIDTH)
      text # dummy for now, to avoid mangling URLs
      # regex = /.{1,#{max_width}}/
      # (text.length < max_width) ? text : text.scan(regex).join(ZERO_WIDTH_SPACE)
    end
end
