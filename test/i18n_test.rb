# frozen_string_literal: true

require "i18n/tasks"

class I18nTest < ActiveSupport::TestCase
  def setup
    @i18n = I18n::Tasks::BaseTask.new
  end

  def test_no_unused_keys
    unused_keys = @i18n.unused_keys

    assert_empty unused_keys, "#{unused_keys.inspect} are unused"
  end
end
