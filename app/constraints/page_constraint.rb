# frozen_string_literal: true

#
# Route constraint for page parameters
#
class PageConstraint
  include StringUtils

  def matches?(request)
    params = request.path_parameters

    return false unless valid_page?(params[:page])

    true
  end

  private

  def valid_page?(page)
    page.nil? || positive_integer?(page)
  end
end
