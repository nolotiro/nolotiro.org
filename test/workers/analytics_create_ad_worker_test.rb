class AnalyticsCreateAdWorkerTest < ActiveSupport::TestCase

  require 'test_helper'
  require 'sidekiq/testing'

  def setup
    @ad = FactoryGirl.create(:ad)
    Sidekiq::Worker.clear_all
  end

  test "work added to the queue" do
    assert_equal 0, AnalyticsCreateAdWorker.jobs.size
    AnalyticsCreateAdWorker.perform_async @ad.id
    assert_equal 1, AnalyticsCreateAdWorker.jobs.size
  end
end