# frozen_string_literal: true
module Minitest
  #
  # Custom Minitest assertions
  #
  module Assertions
    def assert_content(text)
      msg = "Content '#{text}' was not found in page's content: '#{page.text}'"
      assert page.has_content?(text), msg
    end

    def refute_content(text)
      msg = "Content '#{text}' was found in page's content: '#{page.text}'"
      refute page.has_content?(text), msg
    end
  end
end
