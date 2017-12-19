# frozen_string_literal: true

#
# A bad site usage report.
#
# It reports users, not specific content. User reports can be dismised.
#
class Report < ApplicationRecord
  validates :reported_id, presence: true, uniqueness: { scope: :reporter_id }

  belongs_to :reported, class_name: 'User', inverse_of: :received_reports
  belongs_to :reporter, class_name: 'User', inverse_of: :sent_reports

  scope :pending, -> { where(dismissed_at: nil) }
end
