class LegacyMessagesMigratorWorker

  queue_as :default

  def perform(thread_message_id)
    thread = Legacy::MessageThread.find thread_message_id
    thread.migrate!
  end

end
