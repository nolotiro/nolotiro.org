# frozen_string_literal: true

require 'ruby-progressbar'
require 'concerns/duplicate_user_chooser'

#
# Merges duplicate references to the same user
#
class DuplicateUserMerger
  def initialize(email)
    @email = email
  end

  def self.merge!
    duplicated_emails = User.group('LOWER(email)')
                            .having('COUNT(*) > 1')
                            .pluck('LOWER(email)')

    bar = ProgressBar.create(total: duplicated_emails.size,
                             format: '%a %B %c/%C')

    duplicated_emails.each do |email|
      new(email).merge!

      bar.increment
    end
  end

  def merge!
    update_references

    duplicates.destroy_all
  end

  private

  def users
    @users ||= User.where("LOWER(email) = '#{@email}'")
  end

  def chooser
    @chooser ||= DuplicateUserChooser.new(users)
  end

  def master
    chooser.master
  end

  def duplicates
    chooser.duplicates
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
    model.where(column => duplicates.pluck(:id)).update_all(column => master.id)
  end
end
