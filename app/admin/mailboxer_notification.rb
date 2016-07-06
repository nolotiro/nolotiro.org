# frozen_string_literal: true
ActiveAdmin.register Mailboxer::Notification do
  menu parent: 'Mensajería'

  filter :created_at
  filter :body
  filter :subject
  filter :sender_id, as: :string
  filter :conversation_id, as: :string

  index do
    selectable_column
    column :subject
    column :sender
    column :conversation
    actions
  end
end
