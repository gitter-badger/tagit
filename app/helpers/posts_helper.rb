gem 'sanitize'

module PostsHelper
  TRUNC_POST_LENGTH = 200
  MAX_WORD_WIDTH = 43
  ZERO_WIDTH_SPACE = '&#8203;'

  def wrap_and_trunc(content)
    raw_content = content.gsub(/\n/, '<br>').gsub(/@(\w+)/, link_to('@\\1', users_path + '/\\1'))
    split_content = raw_content.split.map{ |s| wrap_long_string(s) }.join(' ')
    truncated_content = truncate(raw(split_content), :length => TRUNC_POST_LENGTH)
    sanitized_content = Sanitize.clean(truncated_content, Sanitize::Config::RELAXED)
  end
  
  private
    def wrap_long_string(text, max_width = MAX_WORD_WIDTH)
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join(ZERO_WIDTH_SPACE)
    end
end
