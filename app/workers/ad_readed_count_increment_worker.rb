class AdReadedCountIncrementWorker
  @queue = :ad_increment_readed_count

  def self.perform(ad_id)
    Ad.increment_counter(:readed_count, ad_id)
  end

end
