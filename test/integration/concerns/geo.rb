# frozen_string_literal: true

module Geo
  private

  def assert_location_page(name)
    assert_text 'No hay anuncios para esta ubicación.'
    assert_text name
  end
end
