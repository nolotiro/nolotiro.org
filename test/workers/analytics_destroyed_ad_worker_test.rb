class AnalyticsDestroyedAdWorkerTest < ActiveSupport::TestCase

  require 'test_helper'
  require 'sidekiq/testing'

  def setup
    @ad = FactoryGirl.create(:ad)
    Sidekiq::Worker.clear_all
  end

  test "work added to the queue" do
    assert_equal 0, AnalyticsDestroyedAdWorker.jobs.size
    AnalyticsDestroyedAdWorker.perform_async @ad.title
    assert_equal 1, AnalyticsDestroyedAdWorker.jobs.size
  end
end