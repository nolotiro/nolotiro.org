#
# Some utilities to handle strings
#
module StringUtils
  def positive_integer?(str)
    Integer(str).positive?
  rescue
    false
  end
end
