# frozen_string_literal: true

#
# Some utilities to handle strings
#
module StringUtils
  def positive_integer?(str)
    Integer(str).positive?
  rescue StandardError
    false
  end
end
