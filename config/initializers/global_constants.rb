USERNAME_REGEX = /^[a-z0-9]+[-\w]+[a-z0-9]+$/i # Starts and ends with a letter or a digit, has letters, digits, hyphens or underscores in between
AT_USERNAME_REGEX = /@([a-z0-9]+[-\w]+[a-z0-9]+)(\W*)/i # Based on USERNAME_REGEX; starts with @ and can end with a punctuation mark
EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
