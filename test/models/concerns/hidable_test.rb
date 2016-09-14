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

    assert_equal [GenericPost.create!(user: create(:user))],
                 GenericPost.from_authors_whitelisting(@visitor)
  end
end
