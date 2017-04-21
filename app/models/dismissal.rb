# frozen_string_literal: true

class Dismissal < ApplicationRecord
  belongs_to :announcement
  belongs_to :user
end
