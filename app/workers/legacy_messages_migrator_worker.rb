class LegacyMessagesMigratorWorker
  @queue = :legacy_messages_migrator_worker

  def self.perform(message_id)
    m = Legacy::Message.find message_id
    m.start_or_reply_conversation
  end

end
