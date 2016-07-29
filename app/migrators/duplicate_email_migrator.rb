# frozen_string_literal: true

require 'ruby-progressbar'
require 'duplicate_email_user_chooser'

#
# Migrates duplicated references to a user
#
class DuplicateEmailMigrator
  def initialize(email)
    @email = email
  end

  def self.migrate!
    duplicated_emails = User.group('LOWER(email)')
                            .having('COUNT(*) > 1')
                            .pluck('LOWER(email)')

    bar = ProgressBar.create(total: duplicated_emails.size,
                             format: '%a %B %c/%C')

    duplicated_emails.each do |email|
      new(email).migrate!

      bar.increment
    end
  end

  def migrate!
    update_references

    duplicates.destroy_all

    master.update(email: @email.downcase)
  end

  private

  def users
    @users ||= User.where("LOWER(email) = '#{@email}'")
  end

  def chooser
    @chooser ||= DuplicateEmailUserChooser.new(users)
  end

  def master
    @master ||= chooser.master
  end

  def duplicates
    @duplicates ||= chooser.duplicates
  end

  def chosen_id
    master.id
  end

  def duplicate_ids
    duplicates.pluck(:id)
  end

  def update_references
    update_reference(Ad, :user_owner)
    update_reference(Comment, :user_owner)
    update_reference(Friendship, :user_id)
    update_reference(Friendship, :friend_id)
    update_reference(Identity, :user_id)
    update_reference(Mailboxer::Receipt, :receiver_id)
    update_reference(Mailboxer::Message, :sender_id)
  end

  def update_reference(model, column)
    model.where(column => duplicate_ids).update_all(column => chosen_id)
  end
end
