class AnalyticsDestroyUserWorkerTest < ActiveSupport::TestCase

  require 'test_helper'
  require 'sidekiq/testing'

  def setup
    @user = FactoryGirl.create(:user)
    Sidekiq::Worker.clear_all
  end

  test "work added to the queue" do
    assert_equal 0, AnalyticsDestroyUserWorker.jobs.size
    AnalyticsDestroyUserWorker.perform_async @user.username
    assert_equal 1, AnalyticsDestroyUserWorker.jobs.size
  end
end