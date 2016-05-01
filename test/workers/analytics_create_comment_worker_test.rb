class AnalyticsCreateCommentWorkerTest < ActiveSupport::TestCase

  require 'test_helper'
  require 'sidekiq/testing'

  def setup
    @comment = FactoryGirl.create(:comment)
    Sidekiq::Worker.clear_all
  end

  test "work added to the queue" do
    assert_equal 0, AnalyticsCreateCommentWorker.jobs.size
    AnalyticsCreateCommentWorker.perform_async @comment.id
    assert_equal 1, AnalyticsCreateCommentWorker.jobs.size
  end
end