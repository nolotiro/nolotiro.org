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

    User.where(id: duplicate_ids).destroy_all

    User.find(chosen_id).update(email: @email.downcase)
  end

  private

  def users
    @users ||= User.where("LOWER(email) = '#{@email}'")
  end

  def chosen_id
    @chosen_id ||= DuplicateEmailUserChooser.new(users).choose
  end

  def duplicate_ids
    @duplicate_ids ||= users.where.not(id: chosen_id).pluck(:id)
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
