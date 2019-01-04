# frozen_string_literal: true

#
# Routes constraints for Ad routes
#
class AdConstraint
  def matches?(request)
    params = request.path_parameters

    return false unless valid_combination?(params[:controller], params[:type], params[:status])

    true
  end

  private

  def valid_combination?(controller, type, status)
    # rubocop:disable Style/WordArray
    [
      ["users", nil, nil],
      ["users", "want", nil],
      ["users", "give", nil],
      ["users", "give", "available"],
      ["users", "give", "booked"],
      ["users", "give", "delivered"],
      ["users", "give", "expired"],
      ["woeid", nil, nil],
      ["woeid", "want", nil],
      ["woeid", "give", nil],
      ["woeid", "give", "available"],
      ["woeid", "give", "booked"],
      ["woeid", "give", "delivered"]
    ].include?([controller, type, status])
    # rubocop:enable Style/WordArray
  end
end
