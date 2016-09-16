# frozen_string_literal: true

require 'test_helper'

#
# @todo Move everything in test/ under the `Test` namespace. Otherwise test
# classes defined inline like this one might conflict at some point with real
# application objects.
#
class GenericPost < ActiveRecord::Base
  include Hidable

  belongs_to :user
end

class HidableTest < ActiveSupport::TestCase
  before do
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.create_table :generic_posts do |t|
        t.integer :user_id
      end
    end

    @author = create(:user)
    @visitor = create(:user)
    @post = GenericPost.create!(user: @author)
  end

  after do
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.drop_table :generic_posts
    end
  end

  def test_from_authors_whitelisting_excludes_objects_from_authors_blocking_user
    create(:blocking, blocker: @author, blocked: @visitor)

    assert_empty GenericPost.from_authors_whitelisting(@visitor)
    assert_equal [@post], GenericPost.from_authors_whitelisting(@author)
  end

  def test_from_unlocked_authors
    assert_equal [@post], GenericPost.from_unlocked_authors

    @author.lock!

    assert_empty GenericPost.from_unlocked_authors
  end
end
