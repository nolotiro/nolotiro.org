# frozen_string_literal: true

module PolicyHelper
  def assert_permit_index(user, record)
    msg = "#{record} should be listed for #{user}, but it is not"

    assert permit_index(user, record), msg
  end

  def refute_permit_index(user, record)
    msg = "#{record} should NOT be listed for #{user}, but it is"

    refute permit_index(user, record), msg
  end

  private

  def permit_index(user, record)
    (record.class.to_s + "Policy::Scope")
      .constantize
      .new(user, record.class)
      .resolve
      .include?(record)
  end
end
