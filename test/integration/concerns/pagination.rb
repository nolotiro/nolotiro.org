# frozen_string_literal: true

module Pagination
  def with_pagination(n)
    old_per_page = Ad.per_page
    Ad.per_page = n

    yield
  ensure
    Ad.per_page = old_per_page
  end
end
