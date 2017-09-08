# frozen_string_literal: true

class Report < ApplicationRecord
  validates :ad, presence: true
  validates :reporter, presence: true, uniqueness: { scope: :ad }

  belongs_to :ad
  belongs_to :reporter, class_name: 'User'

  enum reason: %i[scam spam]

  scope :recent, -> { where('reports.created_at > ?', 24.hours.ago) }

  def self.baneable_score?
    score >= max_allowed_score
  end

  def self.max_allowed_score
    10
  end

  def self.score
    sum { |report| report.reporter.report_weight }
  end
end
