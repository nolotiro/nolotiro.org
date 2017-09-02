# frozen_string_literal: true

#
# Routes constraints for Ad routes
#
class AdConstraint
  def matches?(request)
    params = request.path_parameters

    return false unless valid_combination?(params[:type], params[:status])

    true
  end

  private

  def valid_combination?(type, status)
    # rubocop:disable Style/WordArray
    [
      [nil, nil],
      ['want', nil],
      ['give', nil],
      ['give', 'available'],
      ['give', 'booked'],
      ['give', 'delivered']
    ].include?([type, status])
    # rubocop:enable Style/WordArray
  end
end
