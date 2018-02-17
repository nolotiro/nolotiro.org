# frozen_string_literal: true

class RssController < ApplicationController
  layout false

  def feed
    @type = type_scope || "give"

    scope = Ad.public_send(@type).by_woeid_code(params[:woeid])
    scope = scope.available if @type == "give"

    @ads = policy_scope(scope).latest(30)
  end
end
