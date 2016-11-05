# frozen_string_literal: true

module Pagination
  def with_pagination(n)
    old_per_page = Ad.page(1).limit_value
    Ad.paginates_per(n)

    yield
  ensure
    Ad.paginates_per(old_per_page)
  end
end
