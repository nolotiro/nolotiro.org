# frozen_string_literal: true
class Friendship < ActiveRecord::Base
  belongs_to :friend, :class_name => 'User'
end


