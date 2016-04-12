class AnalyticsCreateUserWorkerTest < ActiveSupport::TestCase

  require 'test_helper'
  require 'sidekiq/testing'

  def setup
    @user = FactoryGirl.create(:user)
    Sidekiq::Worker.clear_all
  end

  test "work added to the queue" do
    assert_equal 0, AnalyticsCreateUserWorker.jobs.size
    AnalyticsCreateUserWorker.perform_async @user.id
    assert_equal 1, AnalyticsCreateUserWorker.jobs.size
  end
end