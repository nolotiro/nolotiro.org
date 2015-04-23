class LegacyMessagesMigratorWorker
  @queue = :legacy_messages_migrator_worker

  def self.perform(thread_message_id)
    thread = Legacy::MessageThread.find thread_message_id
    thread.migrate!
  end

end
