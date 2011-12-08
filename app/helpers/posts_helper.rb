module PostsHelper
  TRUNC_POST_LENGTH = 200
  NEWLINE_REGEX = /\n/
  WHITESPACE_REGEX = /\s+/
  URL_REGEX = /(http|ftp|https):\/\/(\S*)/i
  IMAGE_URL_REGEX = />((http|ftp|https):\/\/(\S*)\.(jpg|jpeg|gif|png)(\?[^\\\/\s]+)?)<\/a>/i
  VIDEO_REGEX = /<a class="_blank" href="(http:\/\/(www\.)?(youtube\.com\/watch\?(?=.*v=(\w+))(?:\S+)?))">\1<\/a>/i
  
  def format_post(content)
    insert_newlines_and_whitespaces = content.gsub(NEWLINE_REGEX, "<br>").gsub(WHITESPACE_REGEX, " ")
    insert_user_paths = insert_newlines_and_whitespaces.gsub(AT_USERNAME_REGEX, link_to("@\\1", users_path + "/\\1") + "\\2")
    insert_urls = insert_user_paths.gsub(URL_REGEX, '<a class="_blank" href="\\0">\\0</a>')
    insert_images = insert_urls.gsub(IMAGE_URL_REGEX, '><img src="\\1" /></a>')
    insert_video = insert_images.gsub(VIDEO_REGEX, '<div class="video" src="\\4"><img src="http://img.youtube.com/vi/\\4/0.jpg" /><div class="play_video"></div></div>')
    format_content = simple_format(insert_video)
  end
end
