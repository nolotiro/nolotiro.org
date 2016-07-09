# frozen_string_literal: true
class Dismissal < ActiveRecord::Base
  belongs_to :announcement
  belongs_to :user
end
