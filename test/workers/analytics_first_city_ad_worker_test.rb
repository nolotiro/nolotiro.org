class AnalyticsFirstCityAdWorkerTest < ActiveSupport::TestCase

  require 'test_helper'
  require 'sidekiq/testing'

  def setup
    @ad = FactoryGirl.create(:ad)
    Sidekiq::Worker.clear_all
  end

  test "work added to the queue" do
    assert_equal 0, AnalyticsFirstCityAdWorker.jobs.size
    AnalyticsFirstCityAdWorker.perform_async @ad.id
    assert_equal 1, AnalyticsFirstCityAdWorker.jobs.size
  end
end