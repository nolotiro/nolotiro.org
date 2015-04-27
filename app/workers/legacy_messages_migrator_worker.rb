class LegacyMessagesMigratorWorker

  include Sidekiq::Worker

  #sidekiq_options(queue: :legacy_messages, backtrace: true, retry: true)
  #queue_as :legacy_messages

  def perform(thread_message_id)
    thread = Legacy::MessageThread.find thread_message_id
    thread.migrate!
  end

end
