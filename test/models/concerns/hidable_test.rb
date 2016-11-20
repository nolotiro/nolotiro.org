# frozen_string_literal: true

require 'test_helper'

class GenericTestPost < ActiveRecord::Base
  include Hidable

  belongs_to :user
end

class HidableTest < ActiveSupport::TestCase
  before do
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.create_table :generic_test_posts do |t|
        t.integer :user_id
      end
    end

    @author = create(:user)
    @visitor = create(:user)
    @post = GenericTestPost.create!(user: @author)
  end

  after do
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.drop_table :generic_test_posts
    end
  end

  def test_from_authors_whitelisting_excludes_objects_from_authors_blocking_user
    create(:blocking, blocker: @author, blocked: @visitor)

    assert_empty GenericTestPost.from_authors_whitelisting(@visitor)
    assert_equal [@post], GenericTestPost.from_authors_whitelisting(@author)
  end

  def test_from_legitimate_authors
    assert_equal [@post], GenericTestPost.from_legitimate_authors

    @author.ban!

    assert_empty GenericTestPost.from_legitimate_authors
  end
end
