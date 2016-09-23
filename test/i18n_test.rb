# frozen_string_literal: true

require 'i18n/tasks'

class I18nTest < Minitest::Test
  def test_does_not_have_unused_keys
    unused_keys = I18n::Tasks::BaseTask.new.unused_keys
    msg = "#{unused_keys.leaves.count} unused i18n keys, run " \
          '`i18n-tasks unused` to show them'

    assert_empty unused_keys, msg
  end
end
