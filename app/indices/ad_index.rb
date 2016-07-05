# frozen_string_literal: true
ThinkingSphinx::Index.define :ad, with: :active_record do
  indexes title
  indexes body
  indexes user_owner

  has woeid_code
  has status
  has type
  has created_at
end

