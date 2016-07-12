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

    def assert_css_selector(selector, text:)
      msg = "Selector '#{selector}' was not found in page's html: '#{page.html}'"
      assert page.has_selector?(selector), msg

      found = page.find_all(selector)
      msg = <<~MSG.squish
        #{pluralize(found.size, 'instance')} of selector '#{selector}' were
        found, but none of them contained '#{text}'. Instead, they had content
        #{found.map { |f| "'#{f.text}'" }.join(', ')}, respectively.
      MSG

      assert page.has_selector?(selector, text: text), msg
    end

    private

    def pluralize(count, name)
      s = count == 1 ? '' : 's'

      "#{count} #{name}#{s}"
    end
  end
end
